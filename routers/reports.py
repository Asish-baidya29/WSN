# =============================================================================
# routers/reports.py  —  Sensor data reports with time-gap filtering
# =============================================================================

from fastapi import APIRouter, Request, Depends, Query
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from database import get_db, fetch_all

router = APIRouter()
templates = Jinja2Templates(directory="templates")

GAP_OPTIONS = [0, 5, 10, 30, 60]


def compute_temp(raw: float) -> dict:
    volt = (raw / 127.0) * 2.56
    deg_c = ((volt * 1000.0) - 500.0) / 10.0
    return {
        "volt": round(volt, 4),
        "degree_centigrade": round(deg_c, 2),
    }


def enrich_row(row: dict) -> dict:
    raw = row.get("node_data")
    try:
        raw_f = float(raw)
    except (TypeError, ValueError):
        raw_f = 0.0
    if row.get("sensor_type_id") == "T":
        comp = compute_temp(raw_f)
        row["volt"] = comp["volt"]
        row["degree_centigrade"] = comp["degree_centigrade"]
    else:
        row["volt"] = None
        row["degree_centigrade"] = None
    return row


@router.get("/", response_class=HTMLResponse)
async def reports_page(request: Request, db: Session = Depends(get_db)):
    user = request.session.get("user")
    if not user:
        return RedirectResponse(url="/login")
    nodes = fetch_all(db,
        "SELECT node_id FROM node_master WHERE node_type_id IN ('E','R')"
    )
    return templates.TemplateResponse("reports/sensing.html", {
        "request": request,
        "user": user,
        "active": "reports",
        "nodes": nodes,
        "gap_options": GAP_OPTIONS,
    })


@router.get("/api/sensor_history")
async def sensor_history(
    node_id: str = Query(...),
    gap_minutes: int = Query(0),
    limit: int = Query(500),
    db: Session = Depends(get_db)
):
    if gap_minutes <= 0:
        rows = fetch_all(db,
            "SELECT dth.channel, dth.node_data, "
            "       CAST(dth.receive_time AS CHAR) as receive_time, "
            "       ncs.sensor_type_id, "
            "       sdl.mapped_data as real_value, "
            "       stm.uom as sensor_unit "
            "FROM data_txn_history dth "
            "JOIN node_channel_sensor ncs "
            "  ON dth.node_id = ncs.node_id AND dth.channel = ncs.channel "
            "LEFT JOIN sensor_data_lkp sdl "
            "  ON ncs.sensor_type_id = sdl.sensor_type_id "
            "  AND dth.node_data = sdl.node_data "
            "JOIN sensor_type_master stm "
            "  ON ncs.sensor_type_id = stm.sensor_type_id "
            "WHERE dth.node_id = :nid "
            "ORDER BY dth.receive_time DESC "
            "LIMIT :lim",
            {"nid": node_id, "lim": limit}
        )
    else:
        gap_seconds = gap_minutes * 60
        rows = fetch_all(db,
            "SELECT dth.channel, "
            "       AVG(dth.node_data) as node_data, "
            "       CAST(MIN(dth.receive_time) AS CHAR) as receive_time, "
            "       ncs.sensor_type_id, "
            "       stm.uom as sensor_unit "
            "FROM data_txn_history dth "
            "JOIN node_channel_sensor ncs "
            "  ON dth.node_id = ncs.node_id AND dth.channel = ncs.channel "
            "JOIN sensor_type_master stm "
            "  ON ncs.sensor_type_id = stm.sensor_type_id "
            "WHERE dth.node_id = :nid "
            "GROUP BY dth.channel, ncs.sensor_type_id, stm.uom, "
            "  FLOOR(UNIX_TIMESTAMP(dth.receive_time) / :gap) "
            "ORDER BY receive_time DESC "
            "LIMIT :lim",
            {"nid": node_id, "gap": gap_seconds, "lim": limit}
        )

    for row in rows:
        enrich_row(row)

    return JSONResponse(content=rows)


@router.get("/api/tracking_history")
async def tracking_history(
    node_id: str = Query(None),
    limit: int = Query(200),
    db: Session = Depends(get_db)
):
    sql = (
        "SELECT node_id, parent_node_id, is_node_active, "
        "CAST(receive_time AS CHAR) as receive_time "
        "FROM node_txn_history "
    )
    params = {"lim": limit}
    if node_id:
        sql += "WHERE node_id = :nid "
        params["nid"] = node_id
    sql += "ORDER BY receive_time DESC LIMIT :lim"
    rows = fetch_all(db, sql, params)
    return JSONResponse(content=rows)