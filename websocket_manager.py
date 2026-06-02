# =============================================================================
# websocket_manager.py  —  Real-time broadcast to all connected browsers
# =============================================================================
# When the listener parses a packet and writes to DB, it calls
# broadcast() here. Every open browser tab receives the update
# instantly via WebSocket — no polling, no page refresh needed.
# =============================================================================

import json
import logging
from fastapi import WebSocket

logger = logging.getLogger(__name__)


class WebSocketManager:
    def __init__(self):
        # List of all currently connected WebSocket clients (browser tabs)
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)
        logger.info(f"WebSocket client connected. Total: {len(self.active_connections)}")

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)
        logger.info(f"WebSocket client disconnected. Total: {len(self.active_connections)}")

    async def broadcast(self, event_type: str, data: dict):
        """
        Send a JSON message to every connected browser tab.

        Message format:
        {
            "type": "sensor_update" | "node_update" | "message_event" | "delivery_update",
            "data": { ... event specific fields ... }
        }
        """
        if not self.active_connections:
            return  # nobody is watching, skip

        message = json.dumps({"type": event_type, "data": data})
        disconnected = []

        for ws in self.active_connections:
            try:
                await ws.send_text(message)
            except Exception:
                # Client disconnected mid-broadcast
                disconnected.append(ws)

        # Clean up dead connections
        for ws in disconnected:
            self.disconnect(ws)

    async def broadcast_sensor(self, node_id: str, channel: int,
                                raw_value: int, real_value: str,
                                sensor_type: str, receive_time: str):
        """Sensor reading arrived — update the data panel in browser."""
        await self.broadcast("sensor_update", {
            "node_id": node_id,
            "channel": channel,
            "raw_value": raw_value,
            "real_value": real_value,
            "sensor_type": sensor_type,
            "receive_time": receive_time,
        })

    async def broadcast_node_update(self, node_id: str, parent_node_id: str,
                                     is_active: bool, receive_time: str):
        """
        Node connectivity changed — move the tag marker on the map.
        The browser uses parent_node_id to know which router the tag is at.
        """
        await self.broadcast("node_update", {
            "node_id": node_id,
            "parent_node_id": parent_node_id,
            "is_active": is_active,
            "receive_time": receive_time,
        })

    async def broadcast_message_event(self, node_id: str, message_type: str,
                                       parent_node_id: str, receive_time: str):
        """LEFT / RIGHT / EMERGENCY message received from a tag."""
        await self.broadcast("message_event", {
            "node_id": node_id,
            "message_type": message_type,
            "parent_node_id": parent_node_id,
            "receive_time": receive_time,
        })

    async def broadcast_delivery_update(self, node_id: str, message_queue_id,
                                         status: str):
        """Command delivery status changed."""
        await self.broadcast("delivery_update", {
            "node_id": node_id,
            "message_queue_id": message_queue_id,
            "status": status,
        })


# Single global instance — imported by listener.py and the WebSocket route
manager = WebSocketManager()
