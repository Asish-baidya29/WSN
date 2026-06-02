# =============================================================================
# WVS System Configuration
# =============================================================================

# --- Serial Port (Coordinator) ---
SERIAL_PORT = "COM3"
SERIAL_BAUD_RATE = 9600        # standard ZigBee coordinator baud rate
SERIAL_TIMEOUT = 1             # seconds

# --- MySQL Database (version 5) ---
DB_HOST = "localhost"
DB_PORT = 3306
DB_NAME = "wvs"
DB_USER = "admin"
DB_PASSWORD = "admin"

# Build the SQLAlchemy connection URL for MySQL 5 via PyMySQL driver
DATABASE_URL = (
    f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}"
    f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    f"?charset=utf8"
)

# --- Web Server ---
HOST = "0.0.0.0"
PORT = 8080                    # same port as old Tomcat, muscle memory friendly
DEBUG = True

# --- Packet Delimiters (from original listener analysis) ---
PACKET_DELIMITER = "**"        # splits fields in every incoming serial line

# --- Node ID Prefixes (from original listener bytecode analysis) ---
END_DEV_TAG       = "TE"       # tracking packet  — tag seen at router
MSG_DEV_TAG       = "ME"       # message packet   — LEFT / RIGHT / EMERGENCY
ACK_DEV_TAG       = "AE"       # acknowledgement from end device
PROC_DEV_TAG      = "PE"       # process event from end device
ROUTER_TAG        = "TR"       # router beacon / registration
ACK_ROUTER_TAG    = "AR"       # acknowledgement from router
PROC_ROUTER_TAG   = "PR"       # process event from router
SENSOR_TAG        = "S"        # sensor data packet
OTAP_NAME_REQ     = "OT"       # unnamed router requesting a name
OTAP_UNNAMED      = "RXX"      # unregistered router placeholder

# Coordinator node name — firmware had both spellings, support both
COORDINATOR_NAMES = {"COO", "C00"}

# --- File Upload ---
MAP_UPLOAD_DIR = "static/maps"
ALLOWED_IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".bmp"}

# --- Session ---
SESSION_SECRET_KEY = "wvs-secret-key-change-in-production"
SESSION_MAX_AGE = 3600         # 1 hour in seconds
