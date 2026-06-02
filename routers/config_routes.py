# =============================================================================
# routers/config_routes.py
# =============================================================================
# profile_config: x_pos, y_pos are double(6,5) → values 0.00000 to 1.00000
# node_properties: node_id, property, value — all varchar, all part of PK
# =============================================================================

import os
from fastapi import APIRouter, Request, Depends, UploadFile, File, Form
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from database import get_db, fetch_all, fetch_one, execute_sql
import config

router = APIRouter()
templates = Jinja2Templates(directory="templates")


def _check_login(request: Request):
    return request.session.get("user")


# =============================================================================
# Locations
# =============================================================================
@router.get("/locations", response_class=HTMLResponse)
async def locations_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    locations = fetch_all(db,
        "SELECT location_id, location_desc FROM location_master")
    return templates.TemplateResponse("config/locations.html", {
        "request": request, "user": request.session.get("user"),
        "active": "locations", "locations": locations
    })


@router.post("/locations/add")
async def add_location(request: Request,
                        location_id: str = Form(...),
                        location_desc: str = Form(...),
                        db: Session = Depends(get_db)):
    execute_sql(db,
        "INSERT INTO location_master (location_id, location_desc) "
        "VALUES (:id, :d)",
        {"id": location_id.upper(), "d": location_desc}
    )
    return RedirectResponse(url="/configuration/locations", status_code=302)


@router.post("/locations/delete")
async def delete_location(request: Request,
                           location_id: str = Form(...),
                           db: Session = Depends(get_db)):
    execute_sql(db,
        "DELETE FROM location_master WHERE location_id = :id",
        {"id": location_id}
    )
    return RedirectResponse(url="/configuration/locations", status_code=302)


# =============================================================================
# Maps / Sites
# =============================================================================
@router.get("/maps", response_class=HTMLResponse)
async def maps_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    sites = fetch_all(db, "SELECT site_id, site_desc FROM site_master")
    profiles = fetch_all(db,
        "SELECT profile_id, profile_desc, site_id FROM profile_master")
    return templates.TemplateResponse("config/maps.html", {
        "request": request, "user": request.session.get("user"),
        "active": "maps", "sites": sites, "profiles": profiles
    })


@router.post("/maps/upload")
async def upload_map(request: Request,
                     site_id: str = Form(...),
                     site_desc: str = Form(...),
                     map_file: UploadFile = File(...),
                     db: Session = Depends(get_db)):
    ext = os.path.splitext(map_file.filename)[1].lower()
    if ext not in config.ALLOWED_IMAGE_EXTENSIONS:
        return JSONResponse({"error": "Invalid file type"}, status_code=400)

    file_bytes = await map_file.read()

    # Save to static/maps/ for browser serving
    filename = f"{site_id}{ext}"
    save_path = os.path.join(config.MAP_UPLOAD_DIR, filename)
    os.makedirs(config.MAP_UPLOAD_DIR, exist_ok=True)
    with open(save_path, "wb") as f:
        f.write(file_bytes)

    # Store in DB (site_map is longblob)
    execute_sql(db,
        "INSERT INTO site_master (site_id, site_desc, site_map) "
        "VALUES (:sid, :sd, :sm)",
        {"sid": site_id.upper(), "sd": site_desc, "sm": file_bytes}
    )
    return RedirectResponse(url="/configuration/maps", status_code=302)


# =============================================================================
# Sensors
# =============================================================================
@router.get("/sensors", response_class=HTMLResponse)
async def sensors_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    sensor_types = fetch_all(db,
        "SELECT sensor_type_id, sensor_type_desc, uom "
        "FROM sensor_type_master")
    return templates.TemplateResponse("config/sensors.html", {
        "request": request, "user": request.session.get("user"),
        "active": "sensors", "sensor_types": sensor_types
    })


# =============================================================================
# Tags
# =============================================================================
@router.get("/tags", response_class=HTMLResponse)
async def tags_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    tags = fetch_all(db,
        "SELECT nm.node_id, ncs.channel, ncs.sensor_type_id "
        "FROM node_master nm "
        "LEFT JOIN node_channel_sensor ncs ON nm.node_id = ncs.node_id "
        "WHERE nm.node_type_id = 'E'")
    sensor_types = fetch_all(db,
        "SELECT sensor_type_id, sensor_type_desc FROM sensor_type_master")
    return templates.TemplateResponse("config/tags.html", {
        "request": request, "user": request.session.get("user"),
        "active": "tags", "tags": tags, "sensor_types": sensor_types
    })


@router.post("/tags/add")
async def add_tag(request: Request,
                  node_id: str = Form(...),
                  db: Session = Depends(get_db)):
    execute_sql(db,
        "INSERT IGNORE INTO node_master (node_id, node_type_id) "
        "VALUES (:nid, 'E')",
        {"nid": node_id}
    )
    return RedirectResponse(url="/configuration/tags", status_code=302)


@router.post("/tags/assign_sensor")
async def assign_sensor(request: Request,
                         node_id: str = Form(...),
                         channel: int = Form(...),
                         sensor_type_id: str = Form(...),
                         db: Session = Depends(get_db)):
    execute_sql(db,
        "INSERT INTO node_channel_sensor (node_id, channel, sensor_type_id) "
        "VALUES (:nid, :ch, :sid) "
        "ON DUPLICATE KEY UPDATE sensor_type_id = :sid",
        {"nid": node_id, "ch": channel, "sid": sensor_type_id}
    )
    return RedirectResponse(url="/configuration/tags", status_code=302)


# =============================================================================
# Routers
# =============================================================================
@router.get("/routers", response_class=HTMLResponse)
async def routers_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    routers = fetch_all(db,
        "SELECT nm.node_id, np.value as location "
        "FROM node_master nm "
        "LEFT JOIN node_properties np "
        "  ON nm.node_id = np.node_id AND np.property = 'location' "
        "WHERE nm.node_type_id = 'R'")
    locations = fetch_all(db,
        "SELECT location_id, location_desc FROM location_master")
    return templates.TemplateResponse("config/routers.html", {
        "request": request, "user": request.session.get("user"),
        "active": "routers", "routers": routers, "locations": locations
    })


@router.post("/routers/add")
async def add_router(request: Request,
                      node_id: str = Form(...),
                      location_id: str = Form(None),
                      db: Session = Depends(get_db)):
    execute_sql(db,
        "INSERT IGNORE INTO node_master (node_id, node_type_id) "
        "VALUES (:nid, 'R')",
        {"nid": node_id}
    )
    if location_id:
        # node_properties: all 3 columns are PK — use REPLACE INTO
        execute_sql(db,
            "DELETE FROM node_properties "
            "WHERE node_id = :nid AND property = 'location'",
            {"nid": node_id}
        )
        execute_sql(db,
            "INSERT INTO node_properties (node_id, property, value) "
            "VALUES (:nid, 'location', :loc)",
            {"nid": node_id, "loc": location_id}
        )
    return RedirectResponse(url="/configuration/routers", status_code=302)


# =============================================================================
# Profiles
# =============================================================================
@router.get("/profiles", response_class=HTMLResponse)
async def profiles_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    profiles = fetch_all(db,
        "SELECT p.profile_id, p.profile_desc, s.site_desc "
        "FROM profile_master p "
        "JOIN site_master s ON p.site_id = s.site_id")
    sites = fetch_all(db, "SELECT site_id, site_desc FROM site_master")
    # Routers available to assign
    all_routers = fetch_all(db,
        "SELECT node_id FROM node_master WHERE node_type_id = 'R'")
    # Routers already in each profile
    profile_routers = fetch_all(db,
        "SELECT profile_id, node_id FROM profile_config")
    return templates.TemplateResponse("config/profiles.html", {
        "request": request, "user": request.session.get("user"),
        "active": "profiles", "profiles": profiles, "sites": sites,
        "all_routers": all_routers, "profile_routers": profile_routers
    })


@router.post("/profiles/add")
async def add_profile(request: Request,
                       profile_id: str = Form(...),
                       profile_desc: str = Form(...),
                       site_id: str = Form(...),
                       db: Session = Depends(get_db)):
    execute_sql(db,
        "INSERT INTO profile_master (profile_id, profile_desc, site_id) "
        "VALUES (:pid, :pd, :sid)",
        {"pid": profile_id, "pd": profile_desc, "sid": site_id}
    )
    return RedirectResponse(url="/configuration/profiles", status_code=302)


@router.post("/profiles/add_router")
async def add_router_to_profile(request: Request,
                                  profile_id: str = Form(...),
                                  node_id: str = Form(...),
                                  db: Session = Depends(get_db)):
    """Add a router to a profile at default center position (0.5, 0.5)."""
    # Check not already added
    existing = fetch_one(db,
        "SELECT 1 FROM profile_config "
        "WHERE profile_id = :pid AND node_id = :nid",
        {"pid": profile_id, "nid": node_id}
    )
    if not existing:
        execute_sql(db,
            "INSERT INTO profile_config "
            "(profile_id, node_id, x_pos, y_pos) "
            "VALUES (:pid, :nid, 0.50000, 0.50000)",
            {"pid": profile_id, "nid": node_id}
        )
    return RedirectResponse(url="/configuration/profiles", status_code=302)


@router.post("/profiles/remove_router")
async def remove_router_from_profile(request: Request,
                                      profile_id: str = Form(...),
                                      node_id: str = Form(...),
                                      db: Session = Depends(get_db)):
    execute_sql(db,
        "DELETE FROM profile_config "
        "WHERE profile_id = :pid AND node_id = :nid",
        {"pid": profile_id, "nid": node_id}
    )
    return RedirectResponse(url="/configuration/profiles", status_code=302)


@router.post("/profiles/place_router")
async def place_router(request: Request,
                        profile_id: str = Form(...),
                        node_id: str = Form(...),
                        x_pos: float = Form(...),
                        y_pos: float = Form(...),
                        db: Session = Depends(get_db)):
    """
    Save router position from drag-and-drop.
    x_pos, y_pos come in as 0–100 percentage from JS,
    we convert to 0.0–1.0 for double(6,5) column.
    """
    x = round(x_pos / 100.0, 5)
    y = round(y_pos / 100.0, 5)
    # Clamp to valid range
    x = max(0.0, min(1.0, x))
    y = max(0.0, min(1.0, y))

    existing = fetch_one(db,
        "SELECT 1 FROM profile_config "
        "WHERE profile_id = :pid AND node_id = :nid",
        {"pid": profile_id, "nid": node_id}
    )
    if existing:
        execute_sql(db,
            "UPDATE profile_config SET x_pos = :x, y_pos = :y "
            "WHERE profile_id = :pid AND node_id = :nid",
            {"x": x, "y": y, "pid": profile_id, "nid": node_id}
        )
    else:
        execute_sql(db,
            "INSERT INTO profile_config "
            "(profile_id, node_id, x_pos, y_pos) "
            "VALUES (:pid, :nid, :x, :y)",
            {"pid": profile_id, "nid": node_id, "x": x, "y": y}
        )
    return JSONResponse({"status": "ok", "x": x, "y": y})


# =============================================================================
# System Properties
# =============================================================================
@router.get("/system", response_class=HTMLResponse)
async def system_page(request: Request, db: Session = Depends(get_db)):
    if not _check_login(request):
        return RedirectResponse(url="/login")
    props = fetch_all(db,
        "SELECT property, value FROM system_properties ORDER BY property")
    return templates.TemplateResponse("config/system.html", {
        "request": request, "user": request.session.get("user"),
        "active": "system", "props": props
    })


@router.post("/system/update")
async def update_system(request: Request, db: Session = Depends(get_db)):
    form = await request.form()
    for key, value in form.items():
        execute_sql(db,
            "UPDATE system_properties SET value = :v WHERE property = :p",
            {"v": value, "p": key}
        )
    return RedirectResponse(url="/configuration/system", status_code=302)