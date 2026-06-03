-- =============================================================================
-- WVS Database Initialization — run once on first MySQL container start
-- =============================================================================

CREATE DATABASE IF NOT EXISTS wvs CHARACTER SET utf8;
USE wvs;

-- =============================================================================
-- Tables
-- =============================================================================

CREATE TABLE IF NOT EXISTS node_master (
    node_id       VARCHAR(50)  NOT NULL,
    node_type_id  VARCHAR(10)  NOT NULL,
    PRIMARY KEY (node_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS node_channel_sensor (
    node_id         VARCHAR(50) NOT NULL,
    channel         INT         NOT NULL,
    sensor_type_id  VARCHAR(10) NOT NULL,
    PRIMARY KEY (node_id, channel)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sensor_type_master (
    sensor_type_id    VARCHAR(10)  NOT NULL,
    sensor_type_desc  VARCHAR(100) NOT NULL,
    uom               VARCHAR(20)  DEFAULT NULL,
    PRIMARY KEY (sensor_type_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sensor_data_lkp (
    sensor_type_id  VARCHAR(10) NOT NULL,
    node_data       INT         NOT NULL,
    mapped_data     DOUBLE(8,2) DEFAULT NULL,
    PRIMARY KEY (sensor_type_id, node_data)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS data_txn (
    node_id       VARCHAR(50) NOT NULL,
    channel       INT         NOT NULL,
    node_data     INT         DEFAULT NULL,
    receive_time  DATETIME    DEFAULT NULL,
    PRIMARY KEY (node_id, channel)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS data_txn_history (
    id            INT AUTO_INCREMENT NOT NULL,
    node_id       VARCHAR(50)        NOT NULL,
    channel       INT                NOT NULL,
    node_data     INT                DEFAULT NULL,
    receive_time  DATETIME           DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_node_time (node_id, receive_time)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS node_txn (
    node_id         VARCHAR(50) NOT NULL,
    parent_node_id  VARCHAR(50) DEFAULT NULL,
    is_node_active  CHAR(1)     DEFAULT 'Y',
    receive_time    DATETIME    DEFAULT NULL,
    PRIMARY KEY (node_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS node_txn_history (
    id              INT AUTO_INCREMENT NOT NULL,
    node_id         VARCHAR(50) NOT NULL,
    parent_node_id  VARCHAR(50) DEFAULT NULL,
    is_node_active  CHAR(1)     DEFAULT 'Y',
    receive_time    DATETIME    DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_ntime (node_id, receive_time)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS listener_log (
    id            INT AUTO_INCREMENT NOT NULL,
    raw_data      VARCHAR(1000) DEFAULT NULL,
    receive_time  DATETIME      DEFAULT NULL,
    db_time       DATETIME      DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS message_master (
    message_id  INT          NOT NULL AUTO_INCREMENT,
    message     VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (message_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS message_txn_history (
    id            INT AUTO_INCREMENT NOT NULL,
    node_id       VARCHAR(50) NOT NULL,
    message_id    INT         DEFAULT NULL,
    receive_time  DATETIME    DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_msgtime (node_id, receive_time)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS delivery_log (
    id                  INT AUTO_INCREMENT NOT NULL,
    node_id             VARCHAR(50)  DEFAULT NULL,
    message_queue_id    INT          DEFAULT NULL,
    message_id          INT          DEFAULT NULL,
    delivery_status     VARCHAR(100) DEFAULT NULL,
    notification_time   DATETIME     DEFAULT NULL,
    client_address      VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_delivery (node_id, message_queue_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS message_queue (
    queue_id        INT AUTO_INCREMENT NOT NULL,
    node_id         VARCHAR(50)  DEFAULT NULL,
    message         VARCHAR(500) DEFAULT NULL,
    queue_status    VARCHAR(50)  DEFAULT 'PENDING',
    created_time    DATETIME     DEFAULT NULL,
    PRIMARY KEY (queue_id),
    KEY idx_mq_node (node_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS action_type_master (
    action_type_id    INT          NOT NULL AUTO_INCREMENT,
    action_type_desc  VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (action_type_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS site_master (
    site_id     VARCHAR(50)  NOT NULL,
    site_desc   VARCHAR(200) DEFAULT NULL,
    site_map    LONGBLOB     DEFAULT NULL,
    PRIMARY KEY (site_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS profile_master (
    profile_id    VARCHAR(50)  NOT NULL,
    profile_desc  VARCHAR(200) DEFAULT NULL,
    site_id       VARCHAR(50)  DEFAULT NULL,
    PRIMARY KEY (profile_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS profile_config (
    profile_id  VARCHAR(50) NOT NULL,
    node_id     VARCHAR(50) NOT NULL,
    x_pos       DOUBLE(6,5) DEFAULT 0.50000,
    y_pos       DOUBLE(6,5) DEFAULT 0.50000,
    PRIMARY KEY (profile_id, node_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS location_master (
    location_id    VARCHAR(50)  NOT NULL,
    location_desc  VARCHAR(200) DEFAULT NULL,
    PRIMARY KEY (location_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS node_properties (
    node_id   VARCHAR(50) NOT NULL,
    property  VARCHAR(50) NOT NULL,
    value     VARCHAR(200) DEFAULT NULL,
    PRIMARY KEY (node_id, property)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS system_properties (
    property  VARCHAR(100) NOT NULL,
    value     VARCHAR(500) DEFAULT NULL,
    PRIMARY KEY (property)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS user_master (
    user_id        VARCHAR(50) NOT NULL,
    password       VARCHAR(100) DEFAULT NULL,
    administrator  CHAR(1)      DEFAULT 'N',
    PRIMARY KEY (user_id)
) ENGINE=InnoDB;

-- =============================================================================
-- Stored Procedures
-- =============================================================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS usp_ins_data_txn(
    IN p_node_id   VARCHAR(50),
    IN p_channel   INT,
    IN p_node_data INT
)
BEGIN
    INSERT INTO data_txn (node_id, channel, node_data, receive_time)
    VALUES (p_node_id, p_channel, p_node_data, NOW())
    ON DUPLICATE KEY UPDATE
        node_data    = VALUES(node_data),
        receive_time = VALUES(receive_time);

    INSERT INTO data_txn_history (node_id, channel, node_data, receive_time)
    VALUES (p_node_id, p_channel, p_node_data, NOW());
END //

CREATE PROCEDURE IF NOT EXISTS usp_ins_node_txn(
    IN p_parent_node VARCHAR(50),
    IN p_node_id     VARCHAR(50)
)
BEGIN
    INSERT INTO node_txn (node_id, parent_node_id, is_node_active, receive_time)
    VALUES (p_node_id, p_parent_node, 'Y', NOW())
    ON DUPLICATE KEY UPDATE
        parent_node_id = VALUES(parent_node_id),
        is_node_active = 'Y',
        receive_time   = VALUES(receive_time);

    INSERT INTO node_txn_history (node_id, parent_node_id, is_node_active, receive_time)
    VALUES (p_node_id, p_parent_node, 'Y', NOW());
END //

CREATE PROCEDURE IF NOT EXISTS usp_ins_msg_txn(
    IN p_parent_node VARCHAR(50),
    IN p_node_id     VARCHAR(50),
    IN p_message_id  INT,
    IN p_receive_time DATETIME
)
BEGIN
    INSERT INTO message_txn_history (node_id, message_id, receive_time)
    VALUES (p_node_id, p_message_id, p_receive_time);
END //

CREATE PROCEDURE IF NOT EXISTS usp_updt_delivery_log(
    IN p_node_id           VARCHAR(50),
    IN p_message_queue_id  INT,
    IN p_delivery_status   VARCHAR(100)
)
BEGIN
    UPDATE delivery_log
    SET delivery_status   = p_delivery_status,
        notification_time = NOW()
    WHERE node_id          = p_node_id
      AND message_queue_id = p_message_queue_id;
END //

CREATE PROCEDURE IF NOT EXISTS usp_write_msg_info(
    IN p_action_type_desc  VARCHAR(100),
    IN p_node_id           VARCHAR(50)
)
BEGIN
    INSERT INTO message_queue (node_id, message, queue_status, created_time)
    VALUES (p_node_id, p_action_type_desc, 'PENDING', NOW());
END //

-- =============================================================================
-- Functions
-- =============================================================================

CREATE FUNCTION IF NOT EXISTS udf_get_latest_queue_id(
    p_node_id VARCHAR(50)
) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE v_qid INT;
    SELECT queue_id INTO v_qid
    FROM message_queue
    WHERE node_id = p_node_id
    ORDER BY created_time DESC
    LIMIT 1;
    RETURN v_qid;
END //

DELIMITER ;

-- =============================================================================
-- Seed Data
-- =============================================================================

INSERT IGNORE INTO sensor_type_master (sensor_type_id, sensor_type_desc, uom)
VALUES ('T', 'Temperature', '°C'),
       ('H', 'Humidity', '%'),
       ('CO', 'Carbon Monoxide', 'ppm');

INSERT IGNORE INTO message_master (message_id, message)
VALUES (1, 'LEFT'),
       (2, 'RIGHT'),
       (3, 'EMERGENCY');

INSERT IGNORE INTO action_type_master (action_type_id, action_type_desc)
VALUES (1, 'Switch On LED'),
       (2, 'Switch Off LED'),
       (3, 'Switch On Buzzer'),
       (4, 'Switch Off Buzzer');

INSERT IGNORE INTO user_master (user_id, password, administrator)
VALUES ('admin', 'admin', 'Y');

INSERT IGNORE INTO location_master (location_id, location_desc)
VALUES ('ENTRANCE', 'Main Entrance'),
       ('CORRIDOR', 'Corridor'),
       ('ROOM-A',  'Room A'),
       ('ROOM-B',  'Room B');

INSERT IGNORE INTO system_properties (property, value)
VALUES ('app.name', 'WVS — Wireless Sensor Network Monitor'),
       ('app.version', '2.0.0');

INSERT IGNORE INTO node_master (node_id, node_type_id)
VALUES ('E52', 'E'),
       ('52',  'E'),
       ('R1',  'R'),
       ('R2',  'R');

INSERT IGNORE INTO node_channel_sensor (node_id, channel, sensor_type_id)
VALUES ('E52', 0, 'T'),
       ('E52', 1, 'H');

-- Temperature lookup: mapped_data = ((node_data / 127) * 2.56 * 1000 - 500) / 10
INSERT INTO sensor_data_lkp (sensor_type_id, node_data, mapped_data)
SELECT 'T', n, ROUND(((n / 127.0) * 2.56 * 1000 - 500) / 10, 2)
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

-- Humidity lookup: no conversion, raw value IS the percentage
INSERT INTO sensor_data_lkp (sensor_type_id, node_data, mapped_data)
SELECT 'H', n, n
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
