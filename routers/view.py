# =============================================================================
# routers/view.py
# =============================================================================
# sensor_data_lkp confirmed columns:
#   sensor_type_id, node_data (int), mapped_data (double 5,2)
# =============================================================================

import os
from fastapi import APIRouter, Request, Depends
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from database import get_db, fetch_all, fetch_one
import config

router = APIRouter()
templates = Jinja2Templates(directory="templates")


@router.get("/", response_class=HTMLResponse)
async def view_dashboard(request: Request, db: Session = Depends(get_db)):
    user = request.session.get("user")
    if not user:
        return RedirectResponse(url="/login")
    profiles = fetch_all(db,
        "SELECT profile_id, profile_desc FROM profile_master"
    )
    return templates.TemplateResponse("dashboard.html", {
        "request": request,
        "user": user,
        "active": "view",
        "profiles": profiles
    })


@router.get("/map/{profile_id}", response_class=HTMLResponse)
async def map_view(request: Request, profile_id: str,
                   db: Session = Depends(get_db)):
    user = request.session.get("user")
    if not user:
        return RedirectResponse(url="/login")

    profile = fetch_one(db,
        "SELECT p.profile_id, p.profile_desc, p.site_id "
        "FROM profile_master p WHERE p.profile_id = :pid",
        {"pid": profile_id}
    )

    # Find map image file in static/maps/
    map_filename = None
    if profile:
        maps_dir = config.MAP_UPLOAD_DIR
        if os.path.exists(maps_dir):
            for f in os.listdir(maps_dir):
                if os.path.splitext(f)[0].upper() == profile["site_id"].upper():
                    map_filename = f
                    break

    # Routers placed on this profile
    routers = fetch_all(db,
        "SELECT pc.node_id, pc.x_pos, pc.y_pos "
        "FROM profile_config pc "
        "WHERE pc.profile_id = :pid",
        {"pid": profile_id}
    )

    # Tags configured in the system (End Devices)
    tags = fetch_all(db,
        "SELECT node_id FROM node_master WHERE node_type_id = 'E'"
    )

    return templates.TemplateResponse("map_view.html", {
        "request": request,
        "user": user,
        "active": "view",
        "profile": profile,
        "map_filename": map_filename,
        "routers": routers,
        "tags": tags,
        "profile_id": profile_id,
    })


# =============================================================================
# API endpoints
# =============================================================================

@router.get("/api/nodes/live")
async def live_nodes(db: Session = Depends(get_db)):
    rows = fetch_all(db,
        "SELECT node_id, parent_node_id, is_node_active, "
        "       CAST(receive_time AS CHAR) as receive_time "
        "FROM node_txn WHERE is_node_active = 'Y'"
    )
    return JSONResponse(content=rows)


@router.get("/api/sensor/latest/{node_id}")
async def latest_sensor(node_id: str, db: Session = Depends(get_db)):
    """
    Returns latest sensor readings for a node.
    sensor_data_lkp columns: sensor_type_id, node_data, mapped_data
    sensor_type_master columns: sensor_type_id, sensor_type_desc, uom
    """
    rows = fetch_all(db,
        "SELECT dt.channel, dt.node_data, "
        "       CAST(dt.receive_time AS CHAR) as receive_time, "
        "       ncs.sensor_type_id, "
        "       sdl.mapped_data as real_value, "
        "       stm.uom as sensor_unit "
        "FROM data_txn dt "
        "JOIN node_channel_sensor ncs "
        "  ON dt.node_id = ncs.node_id AND dt.channel = ncs.channel "
        "LEFT JOIN sensor_data_lkp sdl "
        "  ON ncs.sensor_type_id = sdl.sensor_type_id "
        "  AND dt.node_data = sdl.node_data "
        "JOIN sensor_type_master stm "
        "  ON ncs.sensor_type_id = stm.sensor_type_id "
        "WHERE dt.node_id = :nid",
        {"nid": node_id}
    )
    return JSONResponse(content=rows)


@router.get("/api/profiles")
async def list_profiles(db: Session = Depends(get_db)):
    rows = fetch_all(db,
        "SELECT profile_id, profile_desc FROM profile_master"
    )
    return JSONResponse(content=rows)


@router.get("/api/stats")
async def dashboard_stats(db: Session = Depends(get_db)):
    active = fetch_one(db,
        "SELECT COUNT(*) as cnt FROM node_txn WHERE is_node_active = 'Y'"
    )
    total = fetch_one(db,
        "SELECT COUNT(*) as cnt FROM node_master"
    )
    return JSONResponse({
        "active_nodes": active["cnt"] if active else 0,
        "total_nodes":  total["cnt"] if total else 0,
    })


@router.post("/api/simulate_tag")
async def simulate_tag(request: Request, db: Session = Depends(get_db)):
    """
    TEST ONLY — simulate a tag moving to a router.
    Called from the map UI test buttons.
    Inserts into node_txn so the live system reacts as if real data arrived.
    """
    from database import execute_sql
    from websocket_manager import manager as ws_manager
    import asyncio

    body = await request.json()
    node_id   = body.get("node_id",   "E52")
    parent_id = body.get("parent_id", "R1")

    # Write to node_txn (upsert)
    try:
        execute_sql(db,
            "INSERT INTO node_txn "
            "(parent_node_id, node_id, is_node_active, receive_time) "
            "VALUES (:pid, :nid, 'Y', NOW()) "
            "ON DUPLICATE KEY UPDATE "
            "parent_node_id = :pid, is_node_active = 'Y', receive_time = NOW()",
            {"pid": parent_id, "nid": node_id}
        )
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)

    # Broadcast via WebSocket so map updates live
    await ws_manager.broadcast("node_update", {
        "node_id":       node_id,
        "parent_node_id": parent_id,
        "is_active":     True,
        "receive_time":  "",
    })

    return JSONResponse({"status": "ok", "node_id": node_id, "parent_id": parent_id})