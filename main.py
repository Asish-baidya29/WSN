# =============================================================================
# main.py  —  WVS System entry point
# =============================================================================
# Run with:
#     python -m uvicorn main:app --host 0.0.0.0 --port 8080 --reload
# Or simply:
#     python main.py
# =============================================================================

import asyncio
import logging
import threading
from contextlib import asynccontextmanager

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import RedirectResponse
from starlette.middleware.sessions import SessionMiddleware

import config
from database import test_connection
from listener import start_listener, stop_listener
from websocket_manager import manager as ws_manager

# --- Import routers (each handles a section of the UI) ---
from routers import auth, config_routes, view, reports, messaging

# =============================================================================
# Logging setup
# =============================================================================
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s  %(levelname)-8s  %(name)s — %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)


# =============================================================================
# Lifespan — startup and shutdown
# =============================================================================
@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Code before yield  → runs at startup
    Code after yield   → runs at shutdown
    """
    logger.info("=" * 60)
    logger.info("WVS System starting up...")
    logger.info("=" * 60)

    # 1. Test database connection
    if not test_connection():
        logger.critical("Cannot connect to MySQL. Check config.py DB settings.")
        logger.critical("System will start but database features will not work.")
    else:
        logger.info("MySQL connection OK.")

    # 2. Get the running event loop so the listener thread can post to it
    loop = asyncio.get_event_loop()

    # 3. Start the serial listener in a background thread
    listener_thread = start_listener(loop)
    logger.info(f"Listener started on {config.SERIAL_PORT}")

    logger.info(f"Web interface available at: http://localhost:{config.PORT}")
    logger.info("=" * 60)

    yield  # <-- application runs here

    # Shutdown
    logger.info("WVS System shutting down...")
    stop_listener()
    logger.info("Listener stopped. Goodbye.")


# =============================================================================
# FastAPI app
# =============================================================================
app = FastAPI(
    title="WVS — Wireless Sensor Network Monitor",
    version="2.0.0",
    lifespan=lifespan,
)

# --- Session middleware (must be added before routes) ---
app.add_middleware(
    SessionMiddleware,
    secret_key=config.SESSION_SECRET_KEY,
    max_age=config.SESSION_MAX_AGE,
)

# --- Static files (CSS, JS, uploaded maps) ---
app.mount("/static", StaticFiles(directory="static"), name="static")

# --- Jinja2 templates ---
templates = Jinja2Templates(directory="templates")

# --- Include route modules ---
app.include_router(auth.router)
app.include_router(config_routes.router, prefix="/configuration")
app.include_router(view.router,          prefix="/view")
app.include_router(reports.router,       prefix="/reports")
app.include_router(messaging.router,     prefix="/messaging")


# =============================================================================
# Root redirect
# =============================================================================
@app.get("/")
async def root():
    """Redirect root to login page."""
    return RedirectResponse(url="/login")


# =============================================================================
# WebSocket endpoint — real-time updates to browser
# =============================================================================
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """
    Browser connects here to receive live updates.
    Each packet the listener processes triggers a broadcast here.
    """
    await ws_manager.connect(websocket)
    try:
        while True:
            # Keep the connection alive; we only send FROM server TO client
            await websocket.receive_text()
    except WebSocketDisconnect:
        ws_manager.disconnect(websocket)


# =============================================================================
# Run directly
# =============================================================================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=config.HOST,
        port=config.PORT,
        reload=config.DEBUG,
        log_level="info",
    )