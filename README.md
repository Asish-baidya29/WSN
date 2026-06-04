# WVS — Wireless Sensor Network Monitor

A Python-based serial listener that reads data from a ZigBee coordinator COM port, parses sensor/tracking packets, stores them in MySQL, and serves a real-time web dashboard via FastAPI.

## Architecture

```
┌─────────────┐    COM port    ┌──────────────┐     SQL      ┌─────────┐
│ ZigBee COO  │ ─────────────→ │ listener.py  │ ───────────→ │  MySQL  │
│ (hardware)  │   9600 baud    │ (background  │              │   wvs   │
└─────────────┘                │  thread)     │              └─────────┘
                               └──────┬───────┘                    │
                                      │ WebSocket                  │
                                      ▼                            ▼
                               ┌──────────────┐           ┌──────────────┐
                               │  FastAPI App  │ ←─────── │  FastAPI App  │
                               │  (main.py)    │           │  (reports.py) │
                               └──────┬───────┘           │  (view.py)    │
                                      │                    └──────────────┘
                                      ▼
                               ┌──────────────┐
                               │   Browser    │
                               │  (Web UI at  │
                               │  :8080)      │
                               └──────────────┘
```

## Packet Format

Incoming ASCII lines from COM port, fields delimited by `**`:

| Packet | Example | Description |
|--------|---------|-------------|
| Sensor | `**S0E52**000**R2**` | Sensor type `0` (temp), node `E52`, raw value `0`, parent `R2` |
| Tracking | `**TE52**R2**` | Tag `52` seen at router `R2` |
| Router | `**TR2**` | Router `R2` beacon |
| Message | `**ME52**R2**LEFT**` | Message from node `52` at router `R2` |
| Ack | `**AE52**R2**` | Acknowledgement from device `52` |

### Sensor Type Mapping (from packet field 0)

| Raw prefix | Sensor type | ID |
|------------|-------------|----|
| `S0...` | Temperature | `T` |
| `S1...` | Humidity | `H` |
| `S2...` | Carbon Monoxide | `CO` |

### Raw-to-Value Conversion

Sensor raw readings (0–127) are converted in the backend API (`reports.py`):

#### Temperature

```text
Volt = (Raw / 127) * 2.56
Degree_Centigrade = ((Volt * 1000) - 500) / 10
```

Example: Raw = 46

```text
Volt = (46 / 127) * 2.56 = 0.9272 V
Degree_Centigrade = ((0.9272 * 1000) - 500) / 10 = 42.72 °C
```

#### Humidity

No conversion — the raw value IS the humidity percentage.

```text
Volt = NULL
Degree_Centigrade = NULL
```

Example: Raw = 51 → Humidity = 51%

## Prerequisites

- Python 3.10+
- MySQL 5.7+ (database named `wvs`)
- A ZigBee coordinator on a COM port (default: `COM3` at 9600 baud)

---

## Docker Setup (Recommended)

Docker runs both the app and MySQL 5.7 in containers — no need to install Python, MySQL, or dependencies manually.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows / macOS / Linux)

### 1. Build and start

```bash
docker compose up -d
```

This starts two containers:

| Container | Image | Port |
|-----------|-------|------|
| `wvs-mysql` | mysql:5.7 | `3307` (host) → `3306` (container) |
| `wvs-app` | built from `Dockerfile` | `8080` → `8080` |

The MySQL container automatically:
- Creates the `wvs` database
- Creates all tables, stored procedures, and functions
- Seeds sensor types, lookup data, default tags/routers, and user `admin`/`admin`

### 2. Open the web UI

```
http://localhost:8080
```

Login: `admin` / `admin`

### 3. Stop

```bash
docker compose down
```

Add `-v` to also delete volumes (database data + uploaded maps):

```bash
docker compose down -v
```

### Viewing logs

```bash
docker compose logs -f
```

### Building without compose

If you want to run only the app container and connect to your own MySQL:

```bash
docker build -t wvs-app .
docker run -d -p 8080:8080 \
  -e WVS_DB_HOST=host.docker.internal \
  -e WVS_DB_PORT=3306 \
  -e WVS_DB_USER=admin \
  -e WVS_DB_PASSWORD=admin \
  -e WVS_SERIAL_PORT=COM3 \
  --name wvs-app wvs-app
```

On Linux replace `host.docker.internal` with your host IP or use `--network host`.

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WVS_DB_HOST` | `localhost` | MySQL hostname |
| `WVS_DB_PORT` | `3306` | MySQL port |
| `WVS_DB_NAME` | `wvs` | Database name |
| `WVS_DB_USER` | `admin` | MySQL user |
| `WVS_DB_PASSWORD` | `admin` | MySQL password |
| `WVS_SERIAL_PORT` | `COM3` | ZigBee coordinator port path |
| `WVS_SERIAL_BAUD` | `9600` | Baud rate |

### Serial Port in Docker

- **Windows**: COM ports cannot be easily forwarded to containers. Run the listener natively (use the manual setup below) or use a COM-to-TCP bridge.
- **Linux**: Pass the device into the container by adding this to `docker-compose.yml` under the `app` service:
  ```yaml
  devices:
    - "/dev/ttyUSB0:/dev/ttyUSB0"
  ```
  Then set `WVS_SERIAL_PORT=/dev/ttyUSB0`.

If no serial device is connected, the app still works — the listener thread logs an error and retries every 5 seconds.

---

## Manual Setup

### 1. Clone and install

```
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

Or just double-click `start.bat` — it does all of the above.

### 2. Configure `config.py`

| Setting | Default | Description |
|---------|---------|-------------|
| `SERIAL_PORT` | `COM3` | ZigBee coordinator port |
| `SERIAL_BAUD_RATE` | `9600` | Baud rate |
| `DB_HOST` | `localhost` | MySQL host |
| `DB_PORT` | `3306` | MySQL port |
| `DB_NAME` | `wvs` | Database name |
| `DB_USER` | `admin` | MySQL user |
| `DB_PASSWORD` | `admin` | MySQL password |
| `HOST` | `0.0.0.0` | Web server bind address |
| `PORT` | `8080` | Web server port |

### 3. Database setup

Create the `wvs` database:

```sql
CREATE DATABASE IF NOT EXISTS wvs CHARACTER SET utf8;
```

### 4. Register nodes in the database

The listener inserts tracking and sensor data, but nodes must exist in `node_master` and `node_channel_sensor` first (foreign key constraint). Run these SQL commands:

```sql
-- Register end device (tag)
INSERT IGNORE INTO node_master (node_id, node_type_id) VALUES ('E52', 'E');
INSERT IGNORE INTO node_master (node_id, node_type_id) VALUES ('52', 'E');

-- Register router
INSERT IGNORE INTO node_master (node_id, node_type_id) VALUES ('R1', 'R');
INSERT IGNORE INTO node_master (node_id, node_type_id) VALUES ('R2', 'R');

-- Assign sensor channels to tag
INSERT INTO node_channel_sensor (node_id, channel, sensor_type_id)
VALUES ('E52', 0, 'T')
ON DUPLICATE KEY UPDATE sensor_type_id = 'T';

INSERT INTO node_channel_sensor (node_id, channel, sensor_type_id)
VALUES ('E52', 1, 'H')
ON DUPLICATE KEY UPDATE sensor_type_id = 'H';
```

### 5. Create default user (for web login)

```sql
INSERT INTO user_master (user_id, password, administrator)
VALUES ('admin', 'admin', 'Y');
```

## Map Upload & Floor Plan Setup

The live map view shows router positions on a floor plan image. Here's how to set it up:

### 1. Upload a map image

Go to **Configuration → Maps** (`/configuration/maps`):

| Field | Example | Description |
|-------|---------|-------------|
| Site ID | `FLOOR1` | Short unique code (no spaces) |
| Site Name | `Building A, Ground Floor` | Readable description |
| Map Image | `floorplan.jpg` | JPG, PNG, GIF, or BMP |

The image is stored in `static/maps/` and associated with the Site ID.

### 2. Create a profile

Go to **Configuration → Profiles** (`/configuration/profiles`):

1. Enter a **Profile Description** (e.g. "Ground Floor Sensors")
2. Select a **Site** (the one you just created)
3. Click **Add Profile**

### 3. Assign routers to the profile

On the same Profiles page, for each router in the profile's "Routers" section, click **Add Router** and select a router node.

### 4. Position routers on the map

Go to **Monitor → Live View** (`/view`) and click the profile name to open the map:

1. Click **Config Mode: OFF** to toggle drag mode ON
2. Drag each router circle to its physical location on the floor plan
3. Positions are saved automatically when you stop dragging
4. Toggle Config Mode OFF when done

### 6. Live tracking

When end devices (tags) are detected by routers, they appear as amber dots that move dynamically between router positions on the map.

## Running

### Option A: `start.bat` (double-click)

```
start.bat
```

### Option B: Manual

```
venv\Scripts\activate
python main.py
```

### Option C: Uvicorn directly

```
venv\Scripts\activate
python -m uvicorn main:app --host 0.0.0.0 --port 8080 --reload
```

Open `http://localhost:8080` in your browser. Login with your MySQL `user_master` credentials.

## Web UI Pages

| Page | URL | Description |
|------|-----|-------------|
| Login | `/login` | Authentication |
| Dashboard | `/view` | Live node tracking + latest sensor readings |
| Reports | `/reports` | Sensor history with per-sensor stats (temp/humidity separated) |
| Configuration | `/configuration/tags` | Register end devices and assign sensor channels |
| Configuration | `/configuration/routers` | Register routers |
| Configuration | `/configuration/profiles` | Assign routers to profiles for map view |
| Messaging | `/messaging` | Command dispatch to end devices |

## Database Tables

| Table | Purpose |
|-------|---------|
| `node_master` | Registered nodes (routers + end devices) |
| `node_channel_sensor` | Sensor-to-channel assignments per node |
| `sensor_data_lkp` | Raw-to-real-value lookup table |
| `sensor_type_master` | Sensor type definitions + units |
| `data_txn` / `data_txn_history` | Sensor readings |
| `node_txn` / `node_txn_history` | Node tracking events |
| `listener_log` | Raw serial packet log |
| `message_master` / `message_queue` | Command messaging |
| `user_master` | Web UI login accounts |

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Cannot add or update a child row: foreign key constraint fails` on `node_txn` | Node not in `node_master` | Run `INSERT IGNORE INTO node_master` |
| `Cannot add or update a child row` on `data_txn` | Sensor channel not assigned | Run `INSERT INTO node_channel_sensor` |
| `Value` shows `NaN` in UI | Missing `sensor_data_lkp` entry | Run the bulk INSERT for the sensor type |
| `Serial port error` | Wrong COM port or coordinator not connected | Check `SERIAL_PORT` in `config.py` |
| Raw temperature always `0` | Hardware/firmware issue — sensor not initialized or not connected | Check the sensor's firmware code and physical wiring |

## File Structure

```
WSN/
├── main.py                  # FastAPI app entry point
├── config.py                # Serial port, DB, server settings
├── database.py              # SQLAlchemy helpers (call_procedure, fetch_one, etc.)
├── listener.py              # Serial reader + packet parser (background thread)
├── websocket_manager.py     # WebSocket broadcast to browsers
├── requirements.txt         # Python dependencies
├── start.bat                # One-click launcher
├── routers/
│   ├── auth.py              # Login/logout
│   ├── view.py              # Dashboard + live map
│   ├── reports.py           # Sensor history reports
│   ├── config_routes.py     # Tags, routers, profiles, maps config
│   └── messaging.py         # Command dispatch
├── templates/               # Jinja2 HTML templates
├── static/                  # CSS, JS assets
└── README.md
```
