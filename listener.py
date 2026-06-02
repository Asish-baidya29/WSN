# =============================================================================
# listener.py  —  Serial port reader + packet parser
# =============================================================================
# Runs as a background thread (started by main.py on startup).
# Reads lines from the Coordinator COM port, parses each packet,
# writes to the wvs MySQL 5 database via stored procedures,
# then broadcasts the update to all browser WebSocket clients.
#
# Packet format (plain ASCII, newline terminated):
#   FIELD1**FIELD2
#   FIELD1**FIELD2**FIELD3
#
# Node ID prefixes:
#   TE  — end device tracking (tag seen at router)
#   ME  — message from end device (LEFT/RIGHT/EMERGENCY)
#   AE  — acknowledgement from end device
#   TR  — router beacon/registration
#   AR  — acknowledgement from router
#   S   — sensor data
#   OT  — OTAP name request
#   RXX — unregistered router
# =============================================================================

import serial
import asyncio
import logging
import threading
from datetime import datetime

import config as config
from database import SessionLocal, call_procedure, fetch_one, execute_sql
from websocket_manager import manager as ws_manager

logger = logging.getLogger(__name__)

# Flag to stop the listener thread cleanly on shutdown
_stop_event = threading.Event()
 

# =============================================================================
# Packet Parsers
# =============================================================================

def get_db_time() -> str:
    """Current timestamp as MySQL DATETIME string."""
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def parse_sensor_packet(fields: list, db) -> dict | None:
    print(f"DEBUG parse_sensor_packet called: {fields}")
    """
    FIELD1 format:  S<sensor_type_id>E<node_id_suffix>
    Example:        STE52  →  sensor_type=T, node_id=E52
                    SHE52  →  sensor_type=H, node_id=E52

    FIELD2: parent node (router or COO/C00)
    FIELD3: raw numeric reading (0–127)
    """
    if len(fields) < 3:
        logger.warning(f"Sensor packet missing fields: {fields}")
        return None

    raw_field1 = fields[0]          # e.g. "STE52"
    parent_node  = fields[2]        # e.g. "TR001" or "COO"
    raw_value_str = fields[1].strip()

    # Split on 'E' to separate sensor_type from node_id
    # "STE52" → after removing leading 'S': "TE52" → split on first 'E': ["T","52"]
    inner = raw_field1[1:]          # remove the leading 'S'
    if 'E' not in inner:
        logger.warning(f"Cannot parse sensor node id from: {raw_field1}")
        return None

    e_idx = inner.index('E')
    sensor_type_raw = inner[:e_idx]   # "0" or "1"
    node_suffix     = inner[e_idx:]   # "E52"
    SENSOR_TYPE_MAP = {"0": "T", "1": "H", "2": "CO"}
    sensor_type_id  = SENSOR_TYPE_MAP.get(sensor_type_raw, sensor_type_raw)

    try:
        raw_value = int(raw_value_str)
    except ValueError:
        logger.warning(f"Non-numeric sensor value: {raw_value_str}")
        return None

    # Determine channel: look it up from node_channel_sensor table
    row = fetch_one(db,
        "SELECT channel FROM node_channel_sensor "
        "WHERE node_id = :nid AND sensor_type_id = :sid",
        {"nid": node_suffix, "sid": sensor_type_id}
    )
    channel = row["channel"] if row else 0

    # Look up real-world value from sensor_data_lkp
    lkp = fetch_one(db,
        "SELECT mapped_data FROM sensor_data_lkp "
        "WHERE sensor_type_id = :sid AND node_data = :val",
        {"sid": sensor_type_id, "val": raw_value}
    )
    real_value = str(lkp["mapped_data"]) if lkp else str(raw_value)

    receive_time = get_db_time()

    # Call the stored procedure (handles alert checking internally)
    call_procedure(db, "usp_ins_data_txn",
                   [node_suffix, channel, raw_value])

    return {
        "node_id": node_suffix,
        "channel": channel,
        "raw_value": raw_value,
        "real_value": real_value,
        "sensor_type": sensor_type_id,
        "receive_time": receive_time,
    }


def parse_tracking_packet(fields: list, db) -> dict | None:
    """
    TE packet — end device tag seen at a router.
    FIELD1: TE<node_id>   e.g. TE0A3B  → node_id = TE0A3B (kept as-is)
    FIELD2: parent router  e.g. TR002C
    """
    if len(fields) < 2:
        return None

    node_id      = fields[0][2:]   # full string e.g. TE0A3B
    parent_node  = fields[1]   # e.g. TR002C or COO
    receive_time = get_db_time()

    call_procedure(db, "usp_ins_node_txn",
                   [parent_node, node_id])

    return {
        "node_id": node_id,
        "parent_node_id": parent_node,
        "is_active": True,
        "receive_time": receive_time,
    }


def parse_router_packet(fields: list, db) -> dict | None:
    """
    TR packet — router beacon.
    FIELD1: TR<router_id>   e.g. TR001
    FIELD2: parent (COO or another router)
    """
    if len(fields) < 2:
        return None

    node_id      = fields[0]
    parent_node  = fields[1]
    receive_time = get_db_time()

    call_procedure(db, "usp_ins_node_txn",
                   [parent_node, node_id])

    return {
        "node_id": node_id,
        "parent_node_id": parent_node,
        "is_active": True,
        "receive_time": receive_time,
    }


def parse_message_packet(fields: list, db) -> dict | None:
    """
    ME packet — message event (LEFT / RIGHT / EMERGENCY).
    FIELD1: ME<node_id>
    FIELD2: parent router
    """
    if len(fields) < 2:
        return None

    node_id      = fields[0]
    parent_node  = fields[1]
    receive_time = get_db_time()

    # Determine message type from node context or message_master lookup
    # The original system used message_id to distinguish LEFT/RIGHT/EMERGENCY
    # For now we pass message_id=1 (LEFT), firmware context sets the correct one
    # TODO: map FIELD3 if present to correct message_master entry
    message_id = 1
    if len(fields) >= 3:
        msg_lookup = fetch_one(db,
            "SELECT message_id FROM message_master WHERE message_desc = :d",
            {"d": fields[2].strip().upper()}
        )
        if msg_lookup:
            message_id = msg_lookup["message_id"]

    call_procedure(db, "usp_ins_msg_txn",
                   [parent_node, node_id, message_id, receive_time])

    return {
        "node_id": node_id,
        "message_type": fields[2].strip() if len(fields) >= 3 else "UNKNOWN",
        "parent_node_id": parent_node,
        "receive_time": receive_time,
    }


def parse_ack_packet(fields: list, db) -> None:
    """
    AE / AR packet — acknowledgement from end device or router.
    Updates delivery log via usp_updt_delivery_log.
    FIELD1: AE<node_id> or AR<node_id>
    FIELD2: parent
    """
    if len(fields) < 2:
        return None

    node_id = fields[0]
    # Retrieve latest queue id for this node
    row = fetch_one(db,
        "SELECT udf_get_latest_queue_id(:nid) AS qid",
        {"nid": node_id}
    )
    if not row:
        return None

    queue_id = row.get("qid")
    if queue_id:
        call_procedure(db, "usp_updt_delivery_log",
                       [node_id, queue_id, "RECEIVED_BY_END_DEVICE"])
    return None


def parse_otap_packet(fields: list, db) -> None:
    """
    OT packet — unnamed router requesting a name.
    Handled by usp_updt_on_config after name is assigned.
    """
    logger.info(f"OTAP name request: {fields}")
    # The web UI messaging system handles command dispatch
    return None


# =============================================================================
# Main Dispatch
# =============================================================================

def dispatch_packet(line: str, db, loop: asyncio.AbstractEventLoop):
    """
    Parse one line from the serial port and call the right handler.
    Then schedule a WebSocket broadcast on the event loop.
    """
    line = line.strip()
    if not line:
        return

    # Log raw data to listener_log table
    receive_time = get_db_time()
    try:
        execute_sql(db,
            "INSERT INTO listener_log (raw_data, receive_time, db_time) "
            "VALUES (:rd, :rt, :dt)",
            {"rd": line[:1000], "rt": receive_time, "dt": receive_time}
        )
    except Exception as e:
        logger.debug(f"listener_log insert skipped: {e}")

    fields = [f for f in line.split(config.PACKET_DELIMITER) if f]
    if not fields:
        return

    prefix = fields[0]
    result = None
    event_type = None

    try:
        
        if prefix.startswith(config.SENSOR_TAG) and 'E' in prefix[1:]:
            print(f"DEBUG SENSOR ROUTE: fields={fields}")
            result = parse_sensor_packet(fields, db)
            event_type = "sensor_update"

        elif prefix.startswith(config.END_DEV_TAG):
            result = parse_tracking_packet(fields, db)
            event_type = "node_update"

        elif prefix.startswith(config.ROUTER_TAG):
            result = parse_router_packet(fields, db)
            event_type = "node_update"

        elif prefix.startswith(config.MSG_DEV_TAG):
            result = parse_message_packet(fields, db)
            event_type = "message_event"

        elif prefix.startswith(config.ACK_DEV_TAG) or \
             prefix.startswith(config.ACK_ROUTER_TAG):
            parse_ack_packet(fields, db)

        elif prefix.startswith(config.OTAP_NAME_REQ):
            parse_otap_packet(fields, db)

        else:
            logger.debug(f"Unknown packet prefix, ignoring: {line}")

    except Exception as e:
        logger.error(f"Error dispatching packet '{line}': {e}")

    # Broadcast to WebSocket clients if we have a result
    if result and event_type and loop:
        asyncio.run_coroutine_threadsafe(
            ws_manager.broadcast(event_type, result),
            loop
        )


# =============================================================================
# Listener Thread
# =============================================================================

def run_listener(loop: asyncio.AbstractEventLoop):
    """
    Blocking function — runs in a background thread.
    Opens the COM port and reads lines indefinitely.
    """
    logger.info(f"Starting listener on {config.SERIAL_PORT} "
                f"@ {config.SERIAL_BAUD_RATE} baud...")

    while not _stop_event.is_set():
        ser = None
        try:
            ser = serial.Serial(
                port=config.SERIAL_PORT,
                baudrate=config.SERIAL_BAUD_RATE,
                timeout=config.SERIAL_TIMEOUT,
            )
            logger.info(f"COM port {config.SERIAL_PORT} opened successfully.")

            db = SessionLocal()
            try:
                while not _stop_event.is_set():
                    raw = ser.readline()
                    if not raw:
                        continue  # timeout, no data — loop again
                    try:
                        line = raw.decode("ascii", errors="replace")
                    except Exception:
                        continue
                    dispatch_packet(line, db, loop)
            finally:
                db.close()

        except serial.SerialException as e:
            logger.error(f"Serial port error: {e}. Retrying in 5 seconds...")
            _stop_event.wait(timeout=5)   # wait 5s then retry

        finally:
            if ser and ser.is_open:
                ser.close()
                logger.info("COM port closed.")


def start_listener(loop: asyncio.AbstractEventLoop):
    """Start the listener in a daemon background thread."""
    t = threading.Thread(
        target=run_listener,
        args=(loop,),
        daemon=True,
        name="WSN-Listener"
    )
    t.start()
    logger.info("Listener thread started.")
    return t


def stop_listener():
    """Signal the listener thread to stop."""
    _stop_event.set()
    logger.info("Listener stop signal sent.")
