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

Sensor readings (0–127) are converted to real-world values via the `sensor_data_lkp` table:

- **Temperature**: `mapped_data = (node_data - 25) × 2.075` (unit: °C)
- **Humidity**: `mapped_data = ((node_data - 26) × 96 + 115) / 100` (unit: %)

## Prerequisites

- Python 3.10+
- MySQL 5.7+ (database named `wvs`)
- A ZigBee coordinator on a COM port (default: `COM3` at 9600 baud)

## Setup

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

### 5. Populate the sensor lookup table

**Temperature mapping** (raw 0–127 → °C):

```sql
INSERT INTO sensor_data_lkp (sensor_type_id, node_data, mapped_data)
SELECT 'T', n, ROUND((n - 25) * 2075 / 1000, 2)
FROM (
  SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
  UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
  UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14
  UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19
  UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24
  UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29
  UNION SELECT 30 UNION SELECT 31 UNION SELECT 32 UNION SELECT 33 UNION SELECT 34
  UNION SELECT 35 UNION SELECT 36 UNION SELECT 37 UNION SELECT 38 UNION SELECT 39
  UNION SELECT 40 UNION SELECT 41 UNION SELECT 42 UNION SELECT 43 UNION SELECT 44
  UNION SELECT 45 UNION SELECT 46 UNION SELECT 47 UNION SELECT 48 UNION SELECT 49
  UNION SELECT 50 UNION SELECT 51 UNION SELECT 52 UNION SELECT 53 UNION SELECT 54
  UNION SELECT 55 UNION SELECT 56 UNION SELECT 57 UNION SELECT 58 UNION SELECT 59
  UNION SELECT 60 UNION SELECT 61 UNION SELECT 62 UNION SELECT 63 UNION SELECT 64
  UNION SELECT 65 UNION SELECT 66 UNION SELECT 67 UNION SELECT 68 UNION SELECT 69
  UNION SELECT 70 UNION SELECT 71 UNION SELECT 72 UNION SELECT 73 UNION SELECT 74
  UNION SELECT 75 UNION SELECT 76 UNION SELECT 77 UNION SELECT 78 UNION SELECT 79
  UNION SELECT 80 UNION SELECT 81 UNION SELECT 82 UNION SELECT 83 UNION SELECT 84
  UNION SELECT 85 UNION SELECT 86 UNION SELECT 87 UNION SELECT 88 UNION SELECT 89
  UNION SELECT 90 UNION SELECT 91 UNION SELECT 92 UNION SELECT 93 UNION SELECT 94
  UNION SELECT 95 UNION SELECT 96 UNION SELECT 97 UNION SELECT 98 UNION SELECT 99
  UNION SELECT 100 UNION SELECT 101 UNION SELECT 102 UNION SELECT 103 UNION SELECT 104
  UNION SELECT 105 UNION SELECT 106 UNION SELECT 107 UNION SELECT 108 UNION SELECT 109
  UNION SELECT 110 UNION SELECT 111 UNION SELECT 112 UNION SELECT 113 UNION SELECT 114
  UNION SELECT 115 UNION SELECT 116 UNION SELECT 117 UNION SELECT 118 UNION SELECT 119
  UNION SELECT 120 UNION SELECT 121 UNION SELECT 122 UNION SELECT 123 UNION SELECT 124
  UNION SELECT 125 UNION SELECT 126 UNION SELECT 127
) n
ON DUPLICATE KEY UPDATE mapped_data = VALUES(mapped_data);
```

**Humidity mapping** (raw 0–127 → %):

```sql
INSERT INTO sensor_data_lkp (sensor_type_id, node_data, mapped_data)
SELECT 'H', n, ROUND(((n - 26) * 96 + 115) / 100, 2)
FROM (
  SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
  UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
  UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14
  UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19
  UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24
  UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29
  UNION SELECT 30 UNION SELECT 31 UNION SELECT 32 UNION SELECT 33 UNION SELECT 34
  UNION SELECT 35 UNION SELECT 36 UNION SELECT 37 UNION SELECT 38 UNION SELECT 39
  UNION SELECT 40 UNION SELECT 41 UNION SELECT 42 UNION SELECT 43 UNION SELECT 44
  UNION SELECT 45 UNION SELECT 46 UNION SELECT 47 UNION SELECT 48 UNION SELECT 49
  UNION SELECT 50 UNION SELECT 51 UNION SELECT 52 UNION SELECT 53 UNION SELECT 54
  UNION SELECT 55 UNION SELECT 56 UNION SELECT 57 UNION SELECT 58 UNION SELECT 59
  UNION SELECT 60 UNION SELECT 61 UNION SELECT 62 UNION SELECT 63 UNION SELECT 64
  UNION SELECT 65 UNION SELECT 66 UNION SELECT 67 UNION SELECT 68 UNION SELECT 69
  UNION SELECT 70 UNION SELECT 71 UNION SELECT 72 UNION SELECT 73 UNION SELECT 74
  UNION SELECT 75 UNION SELECT 76 UNION SELECT 77 UNION SELECT 78 UNION SELECT 79
  UNION SELECT 80 UNION SELECT 81 UNION SELECT 82 UNION SELECT 83 UNION SELECT 84
  UNION SELECT 85 UNION SELECT 86 UNION SELECT 87 UNION SELECT 88 UNION SELECT 89
  UNION SELECT 90 UNION SELECT 91 UNION SELECT 92 UNION SELECT 93 UNION SELECT 94
  UNION SELECT 95 UNION SELECT 96 UNION SELECT 97 UNION SELECT 98 UNION SELECT 99
  UNION SELECT 100 UNION SELECT 101 UNION SELECT 102 UNION SELECT 103 UNION SELECT 104
  UNION SELECT 105 UNION SELECT 106 UNION SELECT 107 UNION SELECT 108 UNION SELECT 109
  UNION SELECT 110 UNION SELECT 111 UNION SELECT 112 UNION SELECT 113 UNION SELECT 114
  UNION SELECT 115 UNION SELECT 116 UNION SELECT 117 UNION SELECT 118 UNION SELECT 119
  UNION SELECT 120 UNION SELECT 121 UNION SELECT 122 UNION SELECT 123 UNION SELECT 124
  UNION SELECT 125 UNION SELECT 126 UNION SELECT 127
) n
ON DUPLICATE KEY UPDATE mapped_data = VALUES(mapped_data);
```

### 6. Create default user (for web login)

```sql
INSERT INTO user_master (user_id, password, administrator)
VALUES ('admin', 'admin', 'Y');
```

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
