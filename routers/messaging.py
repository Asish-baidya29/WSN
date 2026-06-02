# =============================================================================
# routers/messaging.py  —  Send commands to devices / view received messages
# =============================================================================
# Confirmed columns:
#   action_type_master : action_type_id (varchar), action_type_desc
#   message_master     : message_id (varchar), message (not message_desc)
#   delivery_log       : node_id, message_queue_id, message_id,
#                        delivery_status, notification_time, client_address
# =============================================================================

import serial
from fastapi import APIRouter, Request, Depends, Form
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from database import get_db, fetch_all, fetch_one, execute_sql, call_procedure
import config

router = APIRouter()
templates = Jinja2Templates(directory="templates")


@router.get("/", response_class=HTMLResponse)
async def messaging_page(request: Request, db: Session = Depends(get_db)):
    user = request.session.get("user")
    if not user:
        return RedirectResponse(url="/login")

    nodes = fetch_all(db,
        "SELECT node_id FROM node_master WHERE node_type_id = 'E'"
    )
    # action_type_id is varchar in MySQL 5
    action_types = fetch_all(db,
        "SELECT action_type_id, action_type_desc FROM action_type_master"
    )
    # message_master column is 'message' not 'message_desc'
    recent_messages = fetch_all(db,
        "SELECT mth.node_id, mth.message_id, mm.message, "
        "       CAST(mth.receive_time AS CHAR) as receive_time "
        "FROM message_txn_history mth "
        "JOIN message_master mm ON mth.message_id = mm.message_id "
        "ORDER BY mth.receive_time DESC LIMIT 50"
    )
    delivery_log = fetch_all(db,
        "SELECT dl.node_id, dl.message_queue_id, dl.delivery_status, "
        "       CAST(dl.notification_time AS CHAR) as notification_time "
        "FROM delivery_log dl "
        "ORDER BY dl.notification_time DESC LIMIT 50"
    )

    return templates.TemplateResponse("messaging.html", {
        "request": request,
        "user": user,
        "active": "messaging",
        "nodes": nodes,
        "action_types": action_types,
        "recent_messages": recent_messages,
        "delivery_log": delivery_log,
    })


@router.post("/send")
async def send_command(request: Request,
                        node_id: str = Form(...),
                        action_type_id: str = Form(...),
                        db: Session = Depends(get_db)):
    action = fetch_one(db,
        "SELECT action_type_desc FROM action_type_master "
        "WHERE action_type_id = :id",
        {"id": action_type_id}
    )
    if not action:
        return JSONResponse({"error": "Unknown action type"}, status_code=400)

    # Queue via stored procedure
    try:
        call_procedure(db, "usp_write_msg_info",
                       [action["action_type_desc"], node_id])
    except Exception as e:
        pass  # log but don't crash if procedure fails

    # Write to COM port
    command_map = {
        "Switch On LED":    "LON",
        "Switch Off LED":   "LOFF",
        "Switch On Buzzer": "BON",
        "Switch Off Buzzer":"BOFF",
    }
    cmd_token = command_map.get(action["action_type_desc"],
                                action["action_type_desc"])
    serial_command = f"*{node_id}*{cmd_token}*\n"

    try:
        with serial.Serial(config.SERIAL_PORT, config.SERIAL_BAUD_RATE,
                           timeout=1) as ser:
            ser.write(serial_command.encode("ascii"))
    except serial.SerialException:
        pass  # no board connected — ignore silently

    return RedirectResponse(url="/messaging", status_code=302)


@router.get("/api/messages/from_device")
async def messages_from_device(db: Session = Depends(get_db)):
    rows = fetch_all(db,
        "SELECT mth.node_id, mm.message, "
        "       CAST(mth.receive_time AS CHAR) as receive_time "
        "FROM message_txn_history mth "
        "JOIN message_master mm ON mth.message_id = mm.message_id "
        "ORDER BY mth.receive_time DESC LIMIT 100"
    )
    return JSONResponse(content=rows)