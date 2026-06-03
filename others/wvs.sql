/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50041
Source Host           : localhost:3306
Source Database       : wvs

Target Server Type    : MYSQL
Target Server Version : 50041
File Encoding         : 65001

Date: 2011-11-09 14:13:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `action_type_master`
-- ----------------------------
DROP TABLE IF EXISTS `action_type_master`;
CREATE TABLE `action_type_master` (
  `action_type_id` varchar(10) NOT NULL,
  `action_type_desc` varchar(50) NOT NULL,
  PRIMARY KEY  (`action_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of action_type_master
-- ----------------------------
INSERT INTO `action_type_master` VALUES ('-1', 'SMS');
INSERT INTO `action_type_master` VALUES ('-2', 'Assign Router Name');
INSERT INTO `action_type_master` VALUES ('1', 'Switch On LED');
INSERT INTO `action_type_master` VALUES ('2', 'Switch Off LED');
INSERT INTO `action_type_master` VALUES ('3', 'Switch On Buzzer');
INSERT INTO `action_type_master` VALUES ('4', 'Switch Off Buzzer');
INSERT INTO `action_type_master` VALUES ('6', 'Change Tag Beacon Interval');

-- ----------------------------
-- Table structure for `alert_master`
-- ----------------------------
DROP TABLE IF EXISTS `alert_master`;
CREATE TABLE `alert_master` (
  `node_id` varchar(6) NOT NULL,
  `channel` int(2) NOT NULL,
  `sensor_type_id` varchar(6) NOT NULL,
  `alert_condition` varchar(3) NOT NULL,
  `alert_value` double(11,3) NOT NULL,
  `action_type_id` varchar(10) NOT NULL,
  `action_recipient` varchar(50) NOT NULL,
  PRIMARY KEY  (`sensor_type_id`,`node_id`,`alert_condition`,`alert_value`,`action_type_id`,`action_recipient`,`channel`),
  KEY `fk_node_id` (`node_id`),
  KEY `fk_action_type_id` (`action_type_id`),
  KEY `fk_node_channel_sensor` (`node_id`,`channel`,`sensor_type_id`),
  CONSTRAINT `fk_action_type_id` FOREIGN KEY (`action_type_id`) REFERENCES `action_type_master` (`action_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_node_channel_sensor` FOREIGN KEY (`node_id`, `channel`, `sensor_type_id`) REFERENCES `node_channel_sensor` (`node_id`, `channel`, `sensor_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sensor_type_id` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_type_master` (`sensor_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of alert_master
-- ----------------------------

-- ----------------------------
-- Table structure for `data_txn`
-- ----------------------------
DROP TABLE IF EXISTS `data_txn`;
CREATE TABLE `data_txn` (
  `node_id` varchar(10) NOT NULL,
  `channel` int(2) NOT NULL,
  `node_data` double(4,0) NOT NULL default '0',
  `receive_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`node_id`,`channel`),
  CONSTRAINT `fk_node_channel_sensor_node_id_channel_id` FOREIGN KEY (`node_id`, `channel`) REFERENCES `node_channel_sensor` (`node_id`, `channel`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of data_txn
-- ----------------------------

-- ----------------------------
-- Table structure for `data_txn_history`
-- ----------------------------
DROP TABLE IF EXISTS `data_txn_history`;
CREATE TABLE `data_txn_history` (
  `node_id` varchar(10) NOT NULL,
  `channel` int(2) NOT NULL,
  `node_data` double(4,0) NOT NULL default '0',
  `receive_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  USING BTREE (`node_id`,`channel`,`receive_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of data_txn_history
-- ----------------------------

-- ----------------------------
-- Table structure for `default_node_properties`
-- ----------------------------
DROP TABLE IF EXISTS `default_node_properties`;
CREATE TABLE `default_node_properties` (
  `node_type_id` varchar(10) NOT NULL,
  `serial` int(3) NOT NULL,
  `property` varchar(20) NOT NULL,
  `value` varchar(50) default NULL,
  PRIMARY KEY  (`node_type_id`,`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of default_node_properties
-- ----------------------------
INSERT INTO `default_node_properties` VALUES ('E', '3', 'beaconInterval', '');
INSERT INTO `default_node_properties` VALUES ('E', '2', 'beaconTimeout', '');
INSERT INTO `default_node_properties` VALUES ('E', '1', 'resTimeout', '');
INSERT INTO `default_node_properties` VALUES ('G', '1', 'resTimeout', null);
INSERT INTO `default_node_properties` VALUES ('R', '1', 'beaconInterval', null);
INSERT INTO `default_node_properties` VALUES ('R', '2', 'beaconTimeout', null);

-- ----------------------------
-- Table structure for `default_sensor_data_lkp`
-- ----------------------------
DROP TABLE IF EXISTS `default_sensor_data_lkp`;
CREATE TABLE `default_sensor_data_lkp` (
  `node_data` int(3) NOT NULL,
  PRIMARY KEY  (`node_data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of default_sensor_data_lkp
-- ----------------------------
INSERT INTO `default_sensor_data_lkp` VALUES ('0');
INSERT INTO `default_sensor_data_lkp` VALUES ('1');
INSERT INTO `default_sensor_data_lkp` VALUES ('2');
INSERT INTO `default_sensor_data_lkp` VALUES ('3');
INSERT INTO `default_sensor_data_lkp` VALUES ('4');
INSERT INTO `default_sensor_data_lkp` VALUES ('5');
INSERT INTO `default_sensor_data_lkp` VALUES ('6');
INSERT INTO `default_sensor_data_lkp` VALUES ('7');
INSERT INTO `default_sensor_data_lkp` VALUES ('8');
INSERT INTO `default_sensor_data_lkp` VALUES ('9');
INSERT INTO `default_sensor_data_lkp` VALUES ('10');
INSERT INTO `default_sensor_data_lkp` VALUES ('11');
INSERT INTO `default_sensor_data_lkp` VALUES ('12');
INSERT INTO `default_sensor_data_lkp` VALUES ('13');
INSERT INTO `default_sensor_data_lkp` VALUES ('14');
INSERT INTO `default_sensor_data_lkp` VALUES ('15');
INSERT INTO `default_sensor_data_lkp` VALUES ('16');
INSERT INTO `default_sensor_data_lkp` VALUES ('17');
INSERT INTO `default_sensor_data_lkp` VALUES ('18');
INSERT INTO `default_sensor_data_lkp` VALUES ('19');
INSERT INTO `default_sensor_data_lkp` VALUES ('20');
INSERT INTO `default_sensor_data_lkp` VALUES ('21');
INSERT INTO `default_sensor_data_lkp` VALUES ('22');
INSERT INTO `default_sensor_data_lkp` VALUES ('23');
INSERT INTO `default_sensor_data_lkp` VALUES ('24');
INSERT INTO `default_sensor_data_lkp` VALUES ('25');
INSERT INTO `default_sensor_data_lkp` VALUES ('26');
INSERT INTO `default_sensor_data_lkp` VALUES ('27');
INSERT INTO `default_sensor_data_lkp` VALUES ('28');
INSERT INTO `default_sensor_data_lkp` VALUES ('29');
INSERT INTO `default_sensor_data_lkp` VALUES ('30');
INSERT INTO `default_sensor_data_lkp` VALUES ('31');
INSERT INTO `default_sensor_data_lkp` VALUES ('32');
INSERT INTO `default_sensor_data_lkp` VALUES ('33');
INSERT INTO `default_sensor_data_lkp` VALUES ('34');
INSERT INTO `default_sensor_data_lkp` VALUES ('35');
INSERT INTO `default_sensor_data_lkp` VALUES ('36');
INSERT INTO `default_sensor_data_lkp` VALUES ('37');
INSERT INTO `default_sensor_data_lkp` VALUES ('38');
INSERT INTO `default_sensor_data_lkp` VALUES ('39');
INSERT INTO `default_sensor_data_lkp` VALUES ('40');
INSERT INTO `default_sensor_data_lkp` VALUES ('41');
INSERT INTO `default_sensor_data_lkp` VALUES ('42');
INSERT INTO `default_sensor_data_lkp` VALUES ('43');
INSERT INTO `default_sensor_data_lkp` VALUES ('44');
INSERT INTO `default_sensor_data_lkp` VALUES ('45');
INSERT INTO `default_sensor_data_lkp` VALUES ('46');
INSERT INTO `default_sensor_data_lkp` VALUES ('47');
INSERT INTO `default_sensor_data_lkp` VALUES ('48');
INSERT INTO `default_sensor_data_lkp` VALUES ('49');
INSERT INTO `default_sensor_data_lkp` VALUES ('50');
INSERT INTO `default_sensor_data_lkp` VALUES ('51');
INSERT INTO `default_sensor_data_lkp` VALUES ('52');
INSERT INTO `default_sensor_data_lkp` VALUES ('53');
INSERT INTO `default_sensor_data_lkp` VALUES ('54');
INSERT INTO `default_sensor_data_lkp` VALUES ('55');
INSERT INTO `default_sensor_data_lkp` VALUES ('56');
INSERT INTO `default_sensor_data_lkp` VALUES ('57');
INSERT INTO `default_sensor_data_lkp` VALUES ('58');
INSERT INTO `default_sensor_data_lkp` VALUES ('59');
INSERT INTO `default_sensor_data_lkp` VALUES ('60');
INSERT INTO `default_sensor_data_lkp` VALUES ('61');
INSERT INTO `default_sensor_data_lkp` VALUES ('62');
INSERT INTO `default_sensor_data_lkp` VALUES ('63');
INSERT INTO `default_sensor_data_lkp` VALUES ('64');
INSERT INTO `default_sensor_data_lkp` VALUES ('65');
INSERT INTO `default_sensor_data_lkp` VALUES ('66');
INSERT INTO `default_sensor_data_lkp` VALUES ('67');
INSERT INTO `default_sensor_data_lkp` VALUES ('68');
INSERT INTO `default_sensor_data_lkp` VALUES ('69');
INSERT INTO `default_sensor_data_lkp` VALUES ('70');
INSERT INTO `default_sensor_data_lkp` VALUES ('71');
INSERT INTO `default_sensor_data_lkp` VALUES ('72');
INSERT INTO `default_sensor_data_lkp` VALUES ('73');
INSERT INTO `default_sensor_data_lkp` VALUES ('74');
INSERT INTO `default_sensor_data_lkp` VALUES ('75');
INSERT INTO `default_sensor_data_lkp` VALUES ('76');
INSERT INTO `default_sensor_data_lkp` VALUES ('77');
INSERT INTO `default_sensor_data_lkp` VALUES ('78');
INSERT INTO `default_sensor_data_lkp` VALUES ('79');
INSERT INTO `default_sensor_data_lkp` VALUES ('80');
INSERT INTO `default_sensor_data_lkp` VALUES ('81');
INSERT INTO `default_sensor_data_lkp` VALUES ('82');
INSERT INTO `default_sensor_data_lkp` VALUES ('83');
INSERT INTO `default_sensor_data_lkp` VALUES ('84');
INSERT INTO `default_sensor_data_lkp` VALUES ('85');
INSERT INTO `default_sensor_data_lkp` VALUES ('86');
INSERT INTO `default_sensor_data_lkp` VALUES ('87');
INSERT INTO `default_sensor_data_lkp` VALUES ('88');
INSERT INTO `default_sensor_data_lkp` VALUES ('89');
INSERT INTO `default_sensor_data_lkp` VALUES ('90');
INSERT INTO `default_sensor_data_lkp` VALUES ('91');
INSERT INTO `default_sensor_data_lkp` VALUES ('92');
INSERT INTO `default_sensor_data_lkp` VALUES ('93');
INSERT INTO `default_sensor_data_lkp` VALUES ('94');
INSERT INTO `default_sensor_data_lkp` VALUES ('95');
INSERT INTO `default_sensor_data_lkp` VALUES ('96');
INSERT INTO `default_sensor_data_lkp` VALUES ('97');
INSERT INTO `default_sensor_data_lkp` VALUES ('98');
INSERT INTO `default_sensor_data_lkp` VALUES ('99');
INSERT INTO `default_sensor_data_lkp` VALUES ('100');
INSERT INTO `default_sensor_data_lkp` VALUES ('101');
INSERT INTO `default_sensor_data_lkp` VALUES ('102');
INSERT INTO `default_sensor_data_lkp` VALUES ('103');
INSERT INTO `default_sensor_data_lkp` VALUES ('104');
INSERT INTO `default_sensor_data_lkp` VALUES ('105');
INSERT INTO `default_sensor_data_lkp` VALUES ('106');
INSERT INTO `default_sensor_data_lkp` VALUES ('107');
INSERT INTO `default_sensor_data_lkp` VALUES ('108');
INSERT INTO `default_sensor_data_lkp` VALUES ('109');
INSERT INTO `default_sensor_data_lkp` VALUES ('110');
INSERT INTO `default_sensor_data_lkp` VALUES ('111');
INSERT INTO `default_sensor_data_lkp` VALUES ('112');
INSERT INTO `default_sensor_data_lkp` VALUES ('113');
INSERT INTO `default_sensor_data_lkp` VALUES ('114');
INSERT INTO `default_sensor_data_lkp` VALUES ('115');
INSERT INTO `default_sensor_data_lkp` VALUES ('116');
INSERT INTO `default_sensor_data_lkp` VALUES ('117');
INSERT INTO `default_sensor_data_lkp` VALUES ('118');
INSERT INTO `default_sensor_data_lkp` VALUES ('119');
INSERT INTO `default_sensor_data_lkp` VALUES ('120');
INSERT INTO `default_sensor_data_lkp` VALUES ('121');
INSERT INTO `default_sensor_data_lkp` VALUES ('122');
INSERT INTO `default_sensor_data_lkp` VALUES ('123');
INSERT INTO `default_sensor_data_lkp` VALUES ('124');
INSERT INTO `default_sensor_data_lkp` VALUES ('125');
INSERT INTO `default_sensor_data_lkp` VALUES ('126');
INSERT INTO `default_sensor_data_lkp` VALUES ('127');

-- ----------------------------
-- Table structure for `default_system_properties`
-- ----------------------------
DROP TABLE IF EXISTS `default_system_properties`;
CREATE TABLE `default_system_properties` (
  `serial` int(2) NOT NULL,
  `property` varchar(20) NOT NULL,
  `value` varchar(50) default NULL,
  PRIMARY KEY  (`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of default_system_properties
-- ----------------------------
INSERT INTO `default_system_properties` VALUES ('4', 'ChokePointSMSNumber', null);
INSERT INTO `default_system_properties` VALUES ('5', 'ChokePointSMSTimeout', '120');
INSERT INTO `default_system_properties` VALUES ('2', 'COMPort', null);
INSERT INTO `default_system_properties` VALUES ('1', 'Debug', '0');
INSERT INTO `default_system_properties` VALUES ('13', 'EmergencySMSNumber', null);
INSERT INTO `default_system_properties` VALUES ('14', 'EmergencySMSTimeout', '60');
INSERT INTO `default_system_properties` VALUES ('10', 'GatewayInacTimeout', '600');
INSERT INTO `default_system_properties` VALUES ('11', 'GatewaySMSNumber', null);
INSERT INTO `default_system_properties` VALUES ('12', 'GatewaySMSTimeout', '600');
INSERT INTO `default_system_properties` VALUES ('6', 'OTAPResTimeout', '30');
INSERT INTO `default_system_properties` VALUES ('9', 'RecSMSInterval', '60');
INSERT INTO `default_system_properties` VALUES ('8', 'RecSMSNumber', null);
INSERT INTO `default_system_properties` VALUES ('7', 'SensorAlertTimeout', '120');
INSERT INTO `default_system_properties` VALUES ('3', 'SMSPort', null);

-- ----------------------------
-- Table structure for `delivery_log`
-- ----------------------------
DROP TABLE IF EXISTS `delivery_log`;
CREATE TABLE `delivery_log` (
  `node_id` varchar(10) NOT NULL,
  `message_queue_id` int(11) NOT NULL default '0',
  `message_id` varchar(10) NOT NULL,
  `delivery_status` varchar(45) default NULL,
  `notification_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `client_address` varchar(50) NOT NULL,
  PRIMARY KEY  USING BTREE (`node_id`,`message_queue_id`),
  KEY `fk_delivery_log_msg_id` (`message_id`),
  CONSTRAINT `fk_delivery_log_msg_id` FOREIGN KEY (`message_id`) REFERENCES `action_type_master` (`action_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of delivery_log
-- ----------------------------

-- ----------------------------
-- Table structure for `listener_log`
-- ----------------------------
DROP TABLE IF EXISTS `listener_log`;
CREATE TABLE `listener_log` (
  `raw_data` varchar(1000) default NULL,
  `receive_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `receive_millis` int(11) default NULL,
  `db_time` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of listener_log
-- ----------------------------

-- ----------------------------
-- Table structure for `location_master`
-- ----------------------------
DROP TABLE IF EXISTS `location_master`;
CREATE TABLE `location_master` (
  `location_id` varchar(10) NOT NULL,
  `location_desc` varchar(50) NOT NULL,
  PRIMARY KEY  (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of location_master
-- ----------------------------

-- ----------------------------
-- Table structure for `message_master`
-- ----------------------------
DROP TABLE IF EXISTS `message_master`;
CREATE TABLE `message_master` (
  `message_id` varchar(10) NOT NULL,
  `message` varchar(50) NOT NULL default 'message',
  PRIMARY KEY  (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of message_master
-- ----------------------------
INSERT INTO `message_master` VALUES ('1', 'LEFT');
INSERT INTO `message_master` VALUES ('2', 'RIGHT');
INSERT INTO `message_master` VALUES ('5', 'EMERGENCY');

-- ----------------------------
-- Table structure for `message_txn`
-- ----------------------------
DROP TABLE IF EXISTS `message_txn`;
CREATE TABLE `message_txn` (
  `node_id` varchar(10) NOT NULL,
  `message_id` varchar(10) NOT NULL,
  `receive_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`node_id`,`message_id`),
  KEY `fk_msg_txn_msg_id` (`message_id`),
  CONSTRAINT `fk_msg_txn_msg_id` FOREIGN KEY (`message_id`) REFERENCES `message_master` (`message_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_msg_txn_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of message_txn
-- ----------------------------

-- ----------------------------
-- Table structure for `message_txn_history`
-- ----------------------------
DROP TABLE IF EXISTS `message_txn_history`;
CREATE TABLE `message_txn_history` (
  `node_id` varchar(10) NOT NULL,
  `message_id` varchar(10) NOT NULL,
  `receive_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`node_id`,`message_id`,`receive_time`),
  KEY `node_id` (`node_id`),
  KEY `fk_msg_txn_hist_msg_id` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of message_txn_history
-- ----------------------------

-- ----------------------------
-- Table structure for `module_master`
-- ----------------------------
DROP TABLE IF EXISTS `module_master`;
CREATE TABLE `module_master` (
  `module_id` int(2) NOT NULL,
  `module_desc` varchar(50) NOT NULL,
  `can_view` char(1) NOT NULL default 'N',
  `can_change` char(1) NOT NULL default 'N',
  PRIMARY KEY  (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of module_master
-- ----------------------------
INSERT INTO `module_master` VALUES ('1', 'View', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('2', 'Configuration - Locations', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('3', 'Configuration - Maps', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('4', 'Configuration - Sensors', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('5', 'Configuration - Tags', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('6', 'Configuration - Routers', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('7', 'Configuration - Profiles', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('8', 'Configuration - Alerts', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('9', 'Configuration - OTAP', 'N', 'Y');
INSERT INTO `module_master` VALUES ('10', 'Configuration - System', 'Y', 'Y');
INSERT INTO `module_master` VALUES ('11', 'Messaging - From Device', 'Y', 'N');
INSERT INTO `module_master` VALUES ('12', 'Messaging - To Device', 'N', 'Y');
INSERT INTO `module_master` VALUES ('13', 'Reports - Tracking', 'Y', 'N');
INSERT INTO `module_master` VALUES ('14', 'Reports - Sensing', 'Y', 'N');
INSERT INTO `module_master` VALUES ('15', 'Reports - MIS', 'Y', 'N');
INSERT INTO `module_master` VALUES ('16', 'User - Change Password', 'N', 'Y');

-- ----------------------------
-- Table structure for `node_channel_sensor`
-- ----------------------------
DROP TABLE IF EXISTS `node_channel_sensor`;
CREATE TABLE `node_channel_sensor` (
  `node_id` varchar(10) NOT NULL,
  `channel` int(2) NOT NULL,
  `sensor_type_id` varchar(10) NOT NULL,
  PRIMARY KEY  (`node_id`,`channel`),
  KEY `fk_sensor_type_id` (`sensor_type_id`),
  KEY `node_id` (`node_id`,`channel`,`sensor_type_id`),
  CONSTRAINT `fk_node_master_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sensor_type_master_sensor_type_id` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_type_master` (`sensor_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of node_channel_sensor
-- ----------------------------

-- ----------------------------
-- Table structure for `node_master`
-- ----------------------------
DROP TABLE IF EXISTS `node_master`;
CREATE TABLE `node_master` (
  `node_id` varchar(10) NOT NULL,
  `node_type_id` varchar(10) NOT NULL,
  PRIMARY KEY  (`node_id`),
  KEY `fk_node_type_id` (`node_type_id`),
  CONSTRAINT `fk_node_type_id` FOREIGN KEY (`node_type_id`) REFERENCES `node_type_master` (`node_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of node_master
-- ----------------------------
INSERT INTO `node_master` VALUES ('GATEWAY', 'G');

-- ----------------------------
-- Table structure for `node_properties`
-- ----------------------------
DROP TABLE IF EXISTS `node_properties`;
CREATE TABLE `node_properties` (
  `node_id` varchar(10) NOT NULL,
  `property` varchar(20) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY  (`node_id`,`property`,`value`),
  CONSTRAINT `fk_node_prop_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of node_properties
-- ----------------------------
INSERT INTO `node_properties` VALUES ('GATEWAY', 'resTimeout', '');

-- ----------------------------
-- Table structure for `node_txn`
-- ----------------------------
DROP TABLE IF EXISTS `node_txn`;
CREATE TABLE `node_txn` (
  `parent_node_id` varchar(10) NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `is_node_active` char(1) NOT NULL default 'N',
  `receive_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  USING BTREE (`node_id`,`parent_node_id`),
  KEY `fk_node_id_3` (`node_id`),
  KEY `fk_parent_node_id` (`parent_node_id`),
  CONSTRAINT `fk_node_txn_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_node_txn_parent_node_id` FOREIGN KEY (`parent_node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of node_txn
-- ----------------------------

-- ----------------------------
-- Table structure for `node_txn_history`
-- ----------------------------
DROP TABLE IF EXISTS `node_txn_history`;
CREATE TABLE `node_txn_history` (
  `parent_node_id` varchar(10) NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `allocated_to` varchar(50) default NULL,
  `receive_time` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of node_txn_history
-- ----------------------------

-- ----------------------------
-- Table structure for `node_type_master`
-- ----------------------------
DROP TABLE IF EXISTS `node_type_master`;
CREATE TABLE `node_type_master` (
  `node_type_id` varchar(10) NOT NULL,
  `node_type_desc` varchar(50) NOT NULL,
  PRIMARY KEY  (`node_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of node_type_master
-- ----------------------------
INSERT INTO `node_type_master` VALUES ('E', 'End Device');
INSERT INTO `node_type_master` VALUES ('G', 'Gateway');
INSERT INTO `node_type_master` VALUES ('R', 'Router');

-- ----------------------------
-- Table structure for `otap_config`
-- ----------------------------
DROP TABLE IF EXISTS `otap_config`;
CREATE TABLE `otap_config` (
  `node_id` varchar(10) NOT NULL,
  `message_id` varchar(10) NOT NULL,
  `message_value` varchar(50) default NULL,
  `is_sent` char(1) NOT NULL default 'N',
  PRIMARY KEY  (`node_id`,`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of otap_config
-- ----------------------------

-- ----------------------------
-- Table structure for `otap_devices`
-- ----------------------------
DROP TABLE IF EXISTS `otap_devices`;
CREATE TABLE `otap_devices` (
  `device_id` varchar(10) NOT NULL,
  `device_name` varchar(10) NOT NULL,
  `property` varchar(10) NOT NULL,
  `value` varchar(10) default NULL,
  PRIMARY KEY  (`device_id`,`device_name`,`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of otap_devices
-- ----------------------------

-- ----------------------------
-- Table structure for `pending_messages`
-- ----------------------------
DROP TABLE IF EXISTS `pending_messages`;
CREATE TABLE `pending_messages` (
  `node_id` varchar(10) NOT NULL,
  `message_id` varchar(10) NOT NULL,
  `message_value` varchar(50) default NULL,
  `client_address` varchar(50) NOT NULL,
  PRIMARY KEY  (`node_id`,`message_id`),
  KEY `fk_pending_message_queue_msg_id` (`message_id`),
  CONSTRAINT `pending_messages_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `action_type_master` (`action_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pending_messages
-- ----------------------------

-- ----------------------------
-- Table structure for `process_txn`
-- ----------------------------
DROP TABLE IF EXISTS `process_txn`;
CREATE TABLE `process_txn` (
  `node_id` varchar(10) NOT NULL,
  `allocated_to` varchar(100) NOT NULL,
  `allocation_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `material_type` varchar(100) default NULL,
  `entry_image` longblob,
  `entry_weight` double default NULL,
  `entry_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `exit_image` longblob,
  `exit_weight` double default NULL,
  `exit_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `deallocation_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of process_txn
-- ----------------------------

-- ----------------------------
-- Table structure for `process_txn_history`
-- ----------------------------
DROP TABLE IF EXISTS `process_txn_history`;
CREATE TABLE `process_txn_history` (
  `node_id` varchar(10) NOT NULL,
  `allocated_to` varchar(100) NOT NULL,
  `allocation_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `material_type` varchar(100) default NULL,
  `entry_image` longblob,
  `entry_weight` double default NULL,
  `entry_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `exit_image` longblob,
  `exit_weight` double default NULL,
  `exit_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `deallocation_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`node_id`,`allocation_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
-- Table structure for `profile_config`
-- ----------------------------
DROP TABLE IF EXISTS `profile_config`;
CREATE TABLE `profile_config` (
  `profile_id` varchar(10) NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `x_pos` double(6,5) NOT NULL,
  `y_pos` double(6,5) NOT NULL,
  PRIMARY KEY  (`profile_id`,`node_id`),
  KEY `fk_node_id_1` (`node_id`),
  CONSTRAINT `fk_prof_config_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prof_config_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `profile_master` (`profile_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of profile_config
-- ----------------------------

-- ----------------------------
-- Table structure for `profile_master`
-- ----------------------------
DROP TABLE IF EXISTS `profile_master`;
CREATE TABLE `profile_master` (
  `profile_id` varchar(10) NOT NULL,
  `profile_desc` varchar(50) NOT NULL,
  `site_id` varchar(10) NOT NULL,
  PRIMARY KEY  (`profile_id`),
  KEY `fk_profile_master_site_id` (`site_id`),
  CONSTRAINT `fk_profile_master_site_id` FOREIGN KEY (`site_id`) REFERENCES `site_master` (`site_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of profile_master
-- ----------------------------

-- ----------------------------
-- Table structure for `sensor_alert_log`
-- ----------------------------
DROP TABLE IF EXISTS `sensor_alert_log`;
CREATE TABLE `sensor_alert_log` (
  `node_id` varchar(10) NOT NULL,
  `channel` int(2) NOT NULL,
  `sensor_type_id` varchar(10) NOT NULL,
  `last_alert_fired` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  USING BTREE (`node_id`,`channel`,`sensor_type_id`),
  KEY `fk_sensor_alert_log_sensor_type_id` (`sensor_type_id`),
  CONSTRAINT `fk_sensor_alert_log_node_id` FOREIGN KEY (`node_id`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sensor_alert_log_sensor_type_id` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_type_master` (`sensor_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sensor_alert_log
-- ----------------------------

-- ----------------------------
-- Table structure for `sensor_data_lkp`
-- ----------------------------
DROP TABLE IF EXISTS `sensor_data_lkp`;
CREATE TABLE `sensor_data_lkp` (
  `sensor_type_id` varchar(10) NOT NULL,
  `node_data` int(3) NOT NULL,
  `mapped_data` double(5,2) default '0.00',
  PRIMARY KEY  (`sensor_type_id`,`node_data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sensor_data_lkp
-- ----------------------------
INSERT INTO `sensor_data_lkp` VALUES ('A', '0', '100.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '1', '99.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '2', '98.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '3', '97.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '4', '96.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '5', '96.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '6', '95.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '7', '94.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '8', '93.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '9', '92.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '10', '92.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '11', '91.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '12', '90.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '13', '89.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '14', '88.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '15', '88.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '16', '87.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '17', '86.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '18', '85.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '19', '84.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '20', '84.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '21', '83.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '22', '82.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '23', '81.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '24', '80.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '25', '80.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '26', '79.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '27', '78.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '28', '77.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '29', '76.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '30', '76.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '31', '75.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '32', '74.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '33', '73.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '34', '72.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '35', '72.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '36', '71.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '37', '70.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '38', '69.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '39', '68.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '40', '68.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '41', '67.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '42', '66.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '43', '65.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '44', '64.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '45', '64.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '46', '63.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '47', '62.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '48', '61.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '49', '60.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '50', '60.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '51', '59.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '52', '58.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '53', '57.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '54', '56.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '55', '56.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '56', '55.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '57', '54.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '58', '53.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '59', '52.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '60', '52.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '61', '51.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '62', '50.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '63', '49.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '64', '48.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '65', '48.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '66', '47.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '67', '46.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '68', '45.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '69', '44.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '70', '44.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '71', '43.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '72', '42.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '73', '41.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '74', '40.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '75', '40.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '76', '39.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '77', '38.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '78', '37.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '79', '36.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '80', '36.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '81', '35.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '82', '34.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '83', '33.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '84', '32.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '85', '32.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '86', '31.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '87', '30.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '88', '29.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '89', '28.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '90', '28.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '91', '27.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '92', '26.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '93', '25.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '94', '24.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '95', '24.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '96', '23.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '97', '22.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '98', '21.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '99', '20.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '100', '20.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '101', '19.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '102', '18.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '103', '17.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '104', '16.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '105', '16.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '106', '15.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '107', '14.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '108', '14.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '109', '13.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '110', '13.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '111', '12.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '112', '11.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '113', '11.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '114', '10.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '115', '10.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '116', '9.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '117', '8.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '118', '8.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '119', '7.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '120', '7.00');
INSERT INTO `sensor_data_lkp` VALUES ('A', '121', '6.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '122', '5.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '123', '4.80');
INSERT INTO `sensor_data_lkp` VALUES ('A', '124', '3.60');
INSERT INTO `sensor_data_lkp` VALUES ('A', '125', '2.40');
INSERT INTO `sensor_data_lkp` VALUES ('A', '126', '1.20');
INSERT INTO `sensor_data_lkp` VALUES ('A', '127', '0.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '0', '0.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '1', '1.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '2', '2.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '3', '3.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '4', '4.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '5', '5.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '6', '6.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '7', '7.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '8', '8.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '9', '9.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '10', '10.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '11', '11.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '12', '12.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '13', '13.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '14', '14.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '15', '15.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '16', '16.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '17', '17.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '18', '18.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '19', '19.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '20', '20.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '21', '21.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '22', '22.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '23', '23.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '24', '24.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '25', '25.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '26', '26.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '27', '27.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '28', '28.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '29', '29.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '30', '30.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '31', '31.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '32', '32.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '33', '33.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '34', '34.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '35', '35.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '36', '36.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '37', '37.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '38', '38.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '39', '39.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '40', '40.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '41', '41.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '42', '42.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '43', '43.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '44', '44.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '45', '45.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '46', '46.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '47', '47.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '48', '48.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '49', '49.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '50', '50.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '51', '51.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '52', '52.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '53', '53.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '54', '54.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '55', '55.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '56', '56.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '57', '57.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '58', '58.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '59', '59.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '60', '60.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '61', '61.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '62', '62.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '63', '63.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '64', '64.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '65', '65.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '66', '66.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '67', '67.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '68', '68.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '69', '69.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '70', '70.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '71', '71.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '72', '72.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '73', '73.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '74', '74.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '75', '75.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '76', '76.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '77', '77.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '78', '78.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '79', '79.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '80', '80.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '81', '81.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '82', '82.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '83', '83.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '84', '84.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '85', '85.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '86', '86.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '87', '87.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '88', '88.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '89', '89.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '90', '90.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '91', '91.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '92', '92.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '93', '93.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '94', '94.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '95', '95.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '96', '96.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '97', '97.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '98', '98.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '99', '99.00');
INSERT INTO `sensor_data_lkp` VALUES ('B', '100', '100.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '0', '0.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '1', '0.04');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '2', '0.08');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '3', '0.12');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '4', '0.16');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '5', '0.20');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '6', '0.24');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '7', '0.28');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '8', '0.32');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '9', '0.36');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '10', '0.40');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '11', '0.44');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '12', '0.48');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '13', '0.52');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '14', '0.56');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '15', '0.60');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '16', '0.64');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '17', '0.68');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '18', '0.72');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '19', '0.76');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '20', '0.80');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '21', '0.84');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '22', '0.88');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '23', '0.92');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '24', '0.96');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '25', '1.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '26', '1.04');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '27', '1.08');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '28', '1.12');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '29', '1.16');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '30', '1.20');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '31', '1.24');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '32', '1.28');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '33', '1.32');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '34', '1.36');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '35', '1.40');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '36', '1.44');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '37', '1.48');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '38', '1.52');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '39', '1.56');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '40', '1.60');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '41', '1.64');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '42', '1.68');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '43', '1.72');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '44', '1.76');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '45', '1.80');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '46', '1.84');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '47', '1.88');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '48', '1.92');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '49', '1.96');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '50', '2.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '51', '2.04');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '52', '2.08');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '53', '2.12');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '54', '2.16');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '55', '2.20');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '56', '2.24');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '57', '2.28');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '58', '2.32');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '59', '2.36');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '60', '2.40');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '61', '2.44');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '62', '2.48');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '63', '2.52');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '64', '2.56');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '65', '2.60');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '66', '2.64');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '67', '2.68');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '68', '2.72');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '69', '2.76');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '70', '2.80');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '71', '2.84');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '72', '2.88');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '73', '2.92');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '74', '2.96');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '75', '3.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '76', '3.04');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '77', '3.08');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '78', '3.12');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '79', '3.16');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '80', '3.20');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '81', '3.24');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '82', '3.28');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '83', '3.32');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '84', '3.36');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '85', '3.40');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '86', '3.44');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '87', '3.48');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '88', '3.52');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '89', '3.56');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '90', '3.60');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '91', '3.64');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '92', '3.68');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '93', '3.72');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '94', '3.76');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '95', '3.80');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '96', '3.84');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '97', '3.88');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '98', '3.92');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '99', '3.96');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '100', '4.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '101', '4.04');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '102', '4.08');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '103', '4.12');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '104', '4.16');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '105', '4.20');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '106', '4.24');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '107', '4.28');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '108', '4.32');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '109', '4.36');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '110', '4.40');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '111', '4.44');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '112', '4.48');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '113', '4.52');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '114', '4.56');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '115', '4.60');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '116', '4.64');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '117', '4.68');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '118', '4.72');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '119', '4.76');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '120', '4.80');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '121', '4.84');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '122', '4.88');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '123', '4.92');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '124', '4.96');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '125', '5.00');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '126', '5.08');
INSERT INTO `sensor_data_lkp` VALUES ('CO', '127', '5.12');
INSERT INTO `sensor_data_lkp` VALUES ('H', '26', '1.15');
INSERT INTO `sensor_data_lkp` VALUES ('H', '27', '2.11');
INSERT INTO `sensor_data_lkp` VALUES ('H', '28', '3.07');
INSERT INTO `sensor_data_lkp` VALUES ('H', '29', '4.03');
INSERT INTO `sensor_data_lkp` VALUES ('H', '30', '5.00');
INSERT INTO `sensor_data_lkp` VALUES ('H', '31', '5.95');
INSERT INTO `sensor_data_lkp` VALUES ('H', '32', '6.91');
INSERT INTO `sensor_data_lkp` VALUES ('H', '33', '7.87');
INSERT INTO `sensor_data_lkp` VALUES ('H', '34', '8.83');
INSERT INTO `sensor_data_lkp` VALUES ('H', '35', '9.79');
INSERT INTO `sensor_data_lkp` VALUES ('H', '36', '10.75');
INSERT INTO `sensor_data_lkp` VALUES ('H', '37', '11.71');
INSERT INTO `sensor_data_lkp` VALUES ('H', '38', '12.67');
INSERT INTO `sensor_data_lkp` VALUES ('H', '39', '13.63');
INSERT INTO `sensor_data_lkp` VALUES ('H', '40', '14.59');
INSERT INTO `sensor_data_lkp` VALUES ('H', '41', '15.55');
INSERT INTO `sensor_data_lkp` VALUES ('H', '42', '16.51');
INSERT INTO `sensor_data_lkp` VALUES ('H', '43', '17.47');
INSERT INTO `sensor_data_lkp` VALUES ('H', '44', '18.43');
INSERT INTO `sensor_data_lkp` VALUES ('H', '45', '19.39');
INSERT INTO `sensor_data_lkp` VALUES ('H', '46', '20.35');
INSERT INTO `sensor_data_lkp` VALUES ('H', '47', '21.31');
INSERT INTO `sensor_data_lkp` VALUES ('H', '48', '22.27');
INSERT INTO `sensor_data_lkp` VALUES ('H', '49', '23.24');
INSERT INTO `sensor_data_lkp` VALUES ('H', '50', '24.20');
INSERT INTO `sensor_data_lkp` VALUES ('H', '51', '25.16');
INSERT INTO `sensor_data_lkp` VALUES ('H', '52', '26.12');
INSERT INTO `sensor_data_lkp` VALUES ('H', '53', '27.08');
INSERT INTO `sensor_data_lkp` VALUES ('H', '54', '28.04');
INSERT INTO `sensor_data_lkp` VALUES ('H', '55', '29.00');
INSERT INTO `sensor_data_lkp` VALUES ('H', '56', '29.96');
INSERT INTO `sensor_data_lkp` VALUES ('H', '57', '30.92');
INSERT INTO `sensor_data_lkp` VALUES ('H', '58', '31.88');
INSERT INTO `sensor_data_lkp` VALUES ('H', '59', '32.84');
INSERT INTO `sensor_data_lkp` VALUES ('H', '60', '33.80');
INSERT INTO `sensor_data_lkp` VALUES ('H', '61', '34.76');
INSERT INTO `sensor_data_lkp` VALUES ('H', '62', '35.72');
INSERT INTO `sensor_data_lkp` VALUES ('H', '63', '36.68');
INSERT INTO `sensor_data_lkp` VALUES ('H', '64', '37.64');
INSERT INTO `sensor_data_lkp` VALUES ('H', '65', '38.60');
INSERT INTO `sensor_data_lkp` VALUES ('H', '66', '39.56');
INSERT INTO `sensor_data_lkp` VALUES ('H', '67', '40.52');
INSERT INTO `sensor_data_lkp` VALUES ('H', '68', '41.48');
INSERT INTO `sensor_data_lkp` VALUES ('H', '69', '42.44');
INSERT INTO `sensor_data_lkp` VALUES ('H', '70', '43.40');
INSERT INTO `sensor_data_lkp` VALUES ('H', '71', '44.36');
INSERT INTO `sensor_data_lkp` VALUES ('H', '72', '45.33');
INSERT INTO `sensor_data_lkp` VALUES ('H', '73', '46.29');
INSERT INTO `sensor_data_lkp` VALUES ('H', '74', '47.25');
INSERT INTO `sensor_data_lkp` VALUES ('H', '75', '48.21');
INSERT INTO `sensor_data_lkp` VALUES ('H', '76', '49.17');
INSERT INTO `sensor_data_lkp` VALUES ('H', '77', '50.13');
INSERT INTO `sensor_data_lkp` VALUES ('H', '78', '51.09');
INSERT INTO `sensor_data_lkp` VALUES ('H', '79', '52.05');
INSERT INTO `sensor_data_lkp` VALUES ('H', '80', '53.01');
INSERT INTO `sensor_data_lkp` VALUES ('H', '81', '53.97');
INSERT INTO `sensor_data_lkp` VALUES ('H', '82', '54.93');
INSERT INTO `sensor_data_lkp` VALUES ('H', '83', '55.89');
INSERT INTO `sensor_data_lkp` VALUES ('H', '84', '56.85');
INSERT INTO `sensor_data_lkp` VALUES ('H', '85', '57.81');
INSERT INTO `sensor_data_lkp` VALUES ('H', '86', '58.77');
INSERT INTO `sensor_data_lkp` VALUES ('H', '87', '59.73');
INSERT INTO `sensor_data_lkp` VALUES ('H', '88', '60.69');
INSERT INTO `sensor_data_lkp` VALUES ('H', '89', '61.65');
INSERT INTO `sensor_data_lkp` VALUES ('H', '90', '62.61');
INSERT INTO `sensor_data_lkp` VALUES ('H', '91', '63.57');
INSERT INTO `sensor_data_lkp` VALUES ('H', '92', '64.53');
INSERT INTO `sensor_data_lkp` VALUES ('H', '93', '65.49');
INSERT INTO `sensor_data_lkp` VALUES ('H', '94', '66.45');
INSERT INTO `sensor_data_lkp` VALUES ('H', '95', '67.42');
INSERT INTO `sensor_data_lkp` VALUES ('H', '96', '68.38');
INSERT INTO `sensor_data_lkp` VALUES ('H', '97', '69.34');
INSERT INTO `sensor_data_lkp` VALUES ('H', '98', '70.30');
INSERT INTO `sensor_data_lkp` VALUES ('H', '99', '71.26');
INSERT INTO `sensor_data_lkp` VALUES ('H', '100', '72.22');
INSERT INTO `sensor_data_lkp` VALUES ('H', '101', '73.18');
INSERT INTO `sensor_data_lkp` VALUES ('H', '102', '74.14');
INSERT INTO `sensor_data_lkp` VALUES ('H', '103', '75.10');
INSERT INTO `sensor_data_lkp` VALUES ('H', '104', '76.06');
INSERT INTO `sensor_data_lkp` VALUES ('H', '105', '77.02');
INSERT INTO `sensor_data_lkp` VALUES ('H', '106', '77.98');
INSERT INTO `sensor_data_lkp` VALUES ('H', '107', '78.94');
INSERT INTO `sensor_data_lkp` VALUES ('H', '108', '79.90');
INSERT INTO `sensor_data_lkp` VALUES ('H', '109', '80.86');
INSERT INTO `sensor_data_lkp` VALUES ('H', '110', '81.82');
INSERT INTO `sensor_data_lkp` VALUES ('H', '111', '82.78');
INSERT INTO `sensor_data_lkp` VALUES ('H', '112', '83.74');
INSERT INTO `sensor_data_lkp` VALUES ('H', '113', '84.70');
INSERT INTO `sensor_data_lkp` VALUES ('H', '114', '85.66');
INSERT INTO `sensor_data_lkp` VALUES ('H', '115', '86.62');
INSERT INTO `sensor_data_lkp` VALUES ('H', '116', '87.58');
INSERT INTO `sensor_data_lkp` VALUES ('H', '117', '88.54');
INSERT INTO `sensor_data_lkp` VALUES ('H', '118', '89.51');
INSERT INTO `sensor_data_lkp` VALUES ('H', '119', '90.47');
INSERT INTO `sensor_data_lkp` VALUES ('H', '120', '91.43');
INSERT INTO `sensor_data_lkp` VALUES ('H', '121', '92.39');
INSERT INTO `sensor_data_lkp` VALUES ('H', '122', '93.35');
INSERT INTO `sensor_data_lkp` VALUES ('H', '123', '94.31');
INSERT INTO `sensor_data_lkp` VALUES ('H', '124', '95.27');
INSERT INTO `sensor_data_lkp` VALUES ('H', '125', '96.23');
INSERT INTO `sensor_data_lkp` VALUES ('H', '126', '97.19');
INSERT INTO `sensor_data_lkp` VALUES ('H', '127', '98.15');
INSERT INTO `sensor_data_lkp` VALUES ('T', '25', '0.00');
INSERT INTO `sensor_data_lkp` VALUES ('T', '26', '2.07');
INSERT INTO `sensor_data_lkp` VALUES ('T', '27', '4.15');
INSERT INTO `sensor_data_lkp` VALUES ('T', '28', '6.23');
INSERT INTO `sensor_data_lkp` VALUES ('T', '29', '8.30');
INSERT INTO `sensor_data_lkp` VALUES ('T', '30', '10.38');
INSERT INTO `sensor_data_lkp` VALUES ('T', '31', '12.46');
INSERT INTO `sensor_data_lkp` VALUES ('T', '32', '14.53');
INSERT INTO `sensor_data_lkp` VALUES ('T', '33', '16.61');
INSERT INTO `sensor_data_lkp` VALUES ('T', '34', '18.69');
INSERT INTO `sensor_data_lkp` VALUES ('T', '35', '20.77');
INSERT INTO `sensor_data_lkp` VALUES ('T', '36', '22.84');
INSERT INTO `sensor_data_lkp` VALUES ('T', '37', '24.92');
INSERT INTO `sensor_data_lkp` VALUES ('T', '38', '27.00');
INSERT INTO `sensor_data_lkp` VALUES ('T', '39', '29.07');
INSERT INTO `sensor_data_lkp` VALUES ('T', '40', '31.15');
INSERT INTO `sensor_data_lkp` VALUES ('T', '41', '33.23');
INSERT INTO `sensor_data_lkp` VALUES ('T', '42', '35.30');
INSERT INTO `sensor_data_lkp` VALUES ('T', '43', '37.38');
INSERT INTO `sensor_data_lkp` VALUES ('T', '44', '39.46');
INSERT INTO `sensor_data_lkp` VALUES ('T', '45', '41.54');
INSERT INTO `sensor_data_lkp` VALUES ('T', '46', '43.61');
INSERT INTO `sensor_data_lkp` VALUES ('T', '47', '45.69');
INSERT INTO `sensor_data_lkp` VALUES ('T', '48', '47.77');
INSERT INTO `sensor_data_lkp` VALUES ('T', '49', '49.84');
INSERT INTO `sensor_data_lkp` VALUES ('T', '50', '51.92');
INSERT INTO `sensor_data_lkp` VALUES ('T', '51', '54.00');
INSERT INTO `sensor_data_lkp` VALUES ('T', '52', '56.07');
INSERT INTO `sensor_data_lkp` VALUES ('T', '53', '58.15');
INSERT INTO `sensor_data_lkp` VALUES ('T', '54', '60.23');
INSERT INTO `sensor_data_lkp` VALUES ('T', '55', '62.31');
INSERT INTO `sensor_data_lkp` VALUES ('T', '56', '64.38');
INSERT INTO `sensor_data_lkp` VALUES ('T', '57', '66.46');
INSERT INTO `sensor_data_lkp` VALUES ('T', '58', '68.54');
INSERT INTO `sensor_data_lkp` VALUES ('T', '59', '70.61');
INSERT INTO `sensor_data_lkp` VALUES ('T', '60', '72.69');
INSERT INTO `sensor_data_lkp` VALUES ('T', '61', '74.77');
INSERT INTO `sensor_data_lkp` VALUES ('T', '62', '76.84');
INSERT INTO `sensor_data_lkp` VALUES ('T', '63', '78.92');
INSERT INTO `sensor_data_lkp` VALUES ('T', '64', '81.00');
INSERT INTO `sensor_data_lkp` VALUES ('T', '65', '83.08');
INSERT INTO `sensor_data_lkp` VALUES ('T', '66', '85.15');
INSERT INTO `sensor_data_lkp` VALUES ('T', '67', '87.23');
INSERT INTO `sensor_data_lkp` VALUES ('T', '68', '89.31');
INSERT INTO `sensor_data_lkp` VALUES ('T', '69', '91.38');
INSERT INTO `sensor_data_lkp` VALUES ('T', '70', '93.46');
INSERT INTO `sensor_data_lkp` VALUES ('T', '71', '95.54');
INSERT INTO `sensor_data_lkp` VALUES ('T', '72', '97.61');
INSERT INTO `sensor_data_lkp` VALUES ('T', '73', '99.69');
INSERT INTO `sensor_data_lkp` VALUES ('T', '74', '101.70');

-- ----------------------------
-- Table structure for `sensor_type_master`
-- ----------------------------
DROP TABLE IF EXISTS `sensor_type_master`;
CREATE TABLE `sensor_type_master` (
  `sensor_type_id` varchar(10) NOT NULL,
  `sensor_type_desc` varchar(50) NOT NULL,
  `uom` varchar(10) NOT NULL,
  PRIMARY KEY  (`sensor_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sensor_type_master
-- ----------------------------
INSERT INTO `sensor_type_master` VALUES ('A', 'AirQuality', '%');
INSERT INTO `sensor_type_master` VALUES ('B', 'Battery', '%');
INSERT INTO `sensor_type_master` VALUES ('CO', 'CO', 'ppm');
INSERT INTO `sensor_type_master` VALUES ('H', 'Humidity', '%');
INSERT INTO `sensor_type_master` VALUES ('T', 'Temperature', 'C');

-- ----------------------------
-- Table structure for `site_master`
-- ----------------------------
DROP TABLE IF EXISTS `site_master`;
CREATE TABLE `site_master` (
  `site_id` varchar(10) NOT NULL,
  `site_desc` varchar(50) NOT NULL,
  `site_map` longblob NOT NULL,
  PRIMARY KEY  (`site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of site_master
-- ----------------------------

-- ----------------------------
-- Table structure for `sms_log`
-- ----------------------------
DROP TABLE IF EXISTS `sms_log`;
CREATE TABLE `sms_log` (
  `router_name` varchar(10) NOT NULL,
  `tag_name` varchar(10) NOT NULL,
  `last_sms_sent` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`router_name`,`tag_name`),
  KEY `fk_sms_log_tag_name` (`tag_name`),
  CONSTRAINT `fk_sms_log_router_name` FOREIGN KEY (`router_name`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sms_log_tag_name` FOREIGN KEY (`tag_name`) REFERENCES `node_master` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sms_log
-- ----------------------------

-- ----------------------------
-- Table structure for `sms_txn`
-- ----------------------------
DROP TABLE IF EXISTS `sms_txn`;
CREATE TABLE `sms_txn` (
  `coo_name` varchar(5) NOT NULL,
  `tag_name` varchar(5) NOT NULL,
  `time_taken` varchar(20) NOT NULL,
  `speed` double(6,2) NOT NULL,
  `receive_time` timestamp NOT NULL default '0000-00-00 00:00:00' on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`coo_name`,`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
-- Table structure for `system_properties`
-- ----------------------------
DROP TABLE IF EXISTS `system_properties`;
CREATE TABLE `system_properties` (
  `property` varchar(20) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY  (`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of system_properties
-- ----------------------------
INSERT INTO `system_properties` VALUES ('ChokePointSMSNumber', '');
INSERT INTO `system_properties` VALUES ('ChokePointSMSTimeout', '');
INSERT INTO `system_properties` VALUES ('COMPort', 'com24');
INSERT INTO `system_properties` VALUES ('Debug', '1');
INSERT INTO `system_properties` VALUES ('EmergencySMSNumber', '9831413744');
INSERT INTO `system_properties` VALUES ('EmergencySMSTimeout', '30');
INSERT INTO `system_properties` VALUES ('GatewayInacTimeout', '');
INSERT INTO `system_properties` VALUES ('GatewaySMSNumber', '');
INSERT INTO `system_properties` VALUES ('GatewaySMSTimeout', '');
INSERT INTO `system_properties` VALUES ('OTAPResTimeout', '');
INSERT INTO `system_properties` VALUES ('RecSMSInterval', '');
INSERT INTO `system_properties` VALUES ('RecSMSNumber', '');
INSERT INTO `system_properties` VALUES ('SensorAlertTimeout', '');
INSERT INTO `system_properties` VALUES ('SMSPort', '');

-- ----------------------------
-- Table structure for `user_access`
-- ----------------------------
DROP TABLE IF EXISTS `user_access`;
CREATE TABLE `user_access` (
  `user_id` varchar(10) NOT NULL,
  `module_id` int(2) NOT NULL,
  `can_view` char(1) NOT NULL default 'N',
  `can_change` char(1) NOT NULL default 'N',
  PRIMARY KEY  (`user_id`,`module_id`),
  KEY `fk_module_id` (`module_id`),
  CONSTRAINT `fk_module_id` FOREIGN KEY (`module_id`) REFERENCES `module_master` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user_master` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of user_access
-- ----------------------------

-- ----------------------------
-- Table structure for `user_master`
-- ----------------------------
DROP TABLE IF EXISTS `user_master`;
CREATE TABLE `user_master` (
  `user_id` varchar(10) NOT NULL,
  `password` varchar(256) NOT NULL,
  `administrator` char(1) NOT NULL default 'N',
  PRIMARY KEY  (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of user_master
-- ----------------------------
INSERT INTO `user_master` VALUES ('admin', 'admin', 'Y');


DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_get_db_time`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_get_db_time`() RETURNS varchar(50) CHARSET latin1
begin
   declare v_now varchar(50) default '';
   select now() into v_now;
   return v_now;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_get_latest_queue_id`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_get_latest_queue_id`(
node varchar(10)
) RETURNS int(11)
begin
   declare v_qid int default -1;
   SELECT message_queue_id
   into v_qid
   FROM delivery_log
   where node_id = node
   and message_queue_id >= 0
   and notification_time =
   (SELECT max(notification_time)
   FROM delivery_log
   group by node_id
   having node_id = node);
   return v_qid;
   end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_get_node_property`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_get_node_property`(
node varchar(10),
prop varchar(20)
) RETURNS varchar(50) CHARSET latin1
begin
   declare v_val varchar(50) default '';
   select value
   into v_val
   from node_properties
   where node_id = node
   and property = prop;
   return v_val;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_get_queue_size`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_get_queue_size`(
node varchar(10)
) RETURNS int(11)
begin
   declare v_count int default 0;
   select count(message_queue_id)
   into v_count
   from delivery_log
   where node_id = node
   and message_queue_id >= 0;
   return v_count;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_get_sys_property`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_get_sys_property`(
prop varchar(20)
) RETURNS varchar(50) CHARSET latin1
begin
   declare v_val varchar(50) default '';
   select value
   into v_val
   from system_properties
   where property = prop;
   return v_val;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_auth_access`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_auth_access`(
p_node varchar(10),
node varchar(10)
) RETURNS tinyint(1)
begin
   declare v_count int;
   select count(*)
   into v_count
   from node_properties
   where node_id = p_node
   and property = 'authTag'
   and value = node;
   if v_count <> 0 then 
      return true;
   end if;
   return false;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_choke_point`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_choke_point`(
node varchar(10)
) RETURNS tinyint(1)
begin
   declare v_count int;
   select count(*)
   into v_count
   from node_properties
   where node_id = node
   and property = 'authTag';
   if v_count <> 0 then 
      return true;
   end if;
   return false;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_gateway_inactive`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_gateway_inactive`(
     ) RETURNS tinyint(1)
    COMMENT 'sdfchjdsgfhdsgfsdhgf'
begin
        declare v_count int default 0;
        declare done int DEFAULT 0;
        DECLARE cur1 CURSOR FOR
        select count(*)
        from node_txn
        where receive_time = (select max(receive_time) from node_txn)
        and TIMESTAMPDIFF(SECOND, receive_time, now()) >
        (select IF(cast(value as signed) > 0, cast(value as signed), 600) GatewayInacTimeout
        from system_properties
        where property = 'GatewayInacTimeout'
        and exists
        (select * from system_properties
        where property = 'GatewayInacTimeout'
        and value is not null
        and value <> '')
        union
        select 600 GatewayInacTimeout
        from system_properties
        where not exists
        (select * from system_properties
        where property = 'GatewayInacTimeout')
        union
        select 600 GatewayInacTimeout
        from system_properties
        where exists
        (select * from system_properties
        where property = 'GatewayInacTimeout'
        and (value is null
        or value = '')))
        ;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
        set v_count := 0;
        OPEN cur1;
        REPEAT
        IF NOT done THEN
        FETCH cur1 INTO v_count;
           if v_count <> 0 then
              CLOSE cur1;
              return true;
           end if;
        END IF;
        UNTIL done END REPEAT;
        CLOSE cur1;
        return false;
     end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_in_sync`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_in_sync`(
val varchar(10)
) RETURNS tinyint(1)
begin
   declare v_count int default 0;
   select count(*)
   into v_count
   from otap_config
   where node_id = val
   and message_id = -2
   and message_value = val
   and is_sent = 'N';
   if v_count <> 0 then
      return true;
   end if;
   return false;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_in_sync_2`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_in_sync_2`(
rec varchar(10),
msg char(1)
) RETURNS tinyint(1)
begin
   declare v_count int default 0;
   select count(*)
   into v_count
   from otap_config
   where node_id = rec
   and message_id = msg
   and is_sent = 'N';
   if v_count <> 0 then
      return true;
   end if;
   return false;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_reported`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_reported`(
rec varchar(10),
qid char(1)
) RETURNS tinyint(1)
begin
   declare v_status varchar(45);
   select delivery_status
   into v_status
   from delivery_log
   where node_id = rec
   and message_queue_id = qid;
   if v_status = 'RECEIVED_BY_END_DEVICE' or  v_status = 'FAILED' then
      return true;
   end if;
   return false;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_is_router_inactive`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_is_router_inactive`(
     node varchar (10)
     ) RETURNS tinyint(1)
begin
declare v_status char(1);
select is_node_active from node_txn where node_id = node into v_status;
        if v_status = 'N' then
             return true;
        end if;
        return false;
end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_should_send_alert`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_should_send_alert`(
     node varchar(10),
     ch char(1),
     sensor varchar(10)
     ) RETURNS tinyint(1)
begin
        declare v_count int default 0;
        select count(*)
        into v_count
        from sensor_alert_log
        where node_id = node
        and channel = ch
        and sensor_type_id = sensor;
        if v_count = 0 then
           return true;
        else
        begin
        declare done int DEFAULT 0;
        DECLARE cur1 CURSOR FOR
        select count(*)
        from sensor_alert_log
        where
        node_id = node
        and channel = ch
        and sensor_type_id = sensor
        and TIMESTAMPDIFF(SECOND, last_alert_fired, now()) >
        (select IF(cast(value as signed) > 0, cast(value as signed), 120) SensorAlertTimeout
        from system_properties
        where property = 'SensorAlertTimeout'
        and exists
        (select * from system_properties
        where property = 'SensorAlertTimeout'
        and value is not null
        and value <> '')
        union
        select 120 SensorAlertTimeout
        from system_properties
        where not exists
        (select * from system_properties
        where property = 'SensorAlertTimeout')
        union
        select 120 SensorAlertTimeout
        from system_properties
        where exists
        (select * from system_properties
        where property = 'SensorAlertTimeout'
        and (value is null
        or value = '')))
        ;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
        set v_count := 0;
        OPEN cur1;
        REPEAT
        IF NOT done THEN
        FETCH cur1 INTO v_count;
           if v_count <> 0 then
              CLOSE cur1;
              delete from sensor_alert_log where node_id = node and channel = ch and sensor_type_id = sensor;              return true;
           end if;
        END IF;
        UNTIL done END REPEAT;
        CLOSE cur1;
    
        end;
        end if;
        return false;
     end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_should_send_cp_sms`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_should_send_cp_sms`(
     p_node varchar(10),
     node varchar(10)
     ) RETURNS tinyint(1)
begin
        declare v_count int default 0;
        select count(*)
        into v_count
        from sms_log
        where router_name = p_node
        and tag_name = node;
        if v_count = 0 then
           return true;
        else
        begin
        declare done int DEFAULT 0;
        DECLARE cur1 CURSOR FOR
        select count(*)
        from sms_log
        where
        router_name = p_node
        and tag_name = node
        and TIMESTAMPDIFF(SECOND, last_sms_sent, now()) >
        (select IF(cast(value as signed) > 0, cast(value as signed), 120) ChokePointSMSTimeout
        from system_properties
        where property = 'ChokePointSMSTimeout'
        and exists
        (select * from system_properties
        where property = 'ChokePointSMSTimeout'
        and value is not null
        and value <> '')
        union
        select 120 ChokePointSMSTimeout
        from system_properties
        where not exists
        (select * from system_properties
        where property = 'ChokePointSMSTimeout')
        union
        select 120 ChokePointSMSTimeout
        from system_properties
        where exists
        (select * from system_properties
        where property = 'ChokePointSMSTimeout'
        and (value is null
        or value = '')))
        ;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
        set v_count := 0;
        OPEN cur1;
        REPEAT
        IF NOT done THEN
        FETCH cur1 INTO v_count;
           if v_count <> 0 then
              CLOSE cur1;
              delete from sms_log where router_name = p_node and tag_name = node;
              return true;
           end if;
        END IF;
        UNTIL done END REPEAT;
        CLOSE cur1;
    
        end;
        end if;
        return false;
     end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_should_send_e_sms`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_should_send_e_sms`(
     node varchar(10)
     ) RETURNS tinyint(1)
begin
        declare v_count int default 0;
        select count(*)
        into v_count
        from sms_log
        where router_name = node
        and tag_name = node;
        if v_count = 0 then
           return true;
        else
        begin
        declare done int DEFAULT 0;
        DECLARE cur1 CURSOR FOR
        select count(*)
        from sms_log
        where
        router_name = node
        and tag_name = node
        and TIMESTAMPDIFF(SECOND, last_sms_sent, now()) >
        (select IF(cast(value as signed) > 0, cast(value as signed), 120) EmergencySMSTimeout
        from system_properties
        where property = 'EmergencySMSTimeout'
        and exists
        (select * from system_properties
        where property = 'EmergencySMSTimeout'
        and value is not null
        and value <> '')
        union
        select 120 EmergencySMSTimeout
        from system_properties
        where not exists
        (select * from system_properties
        where property = 'EmergencySMSTimeout')
        union
        select 120 EmergencySMSTimeout
        from system_properties
        where exists
        (select * from system_properties
        where property = 'EmergencySMSTimeout'
        and (value is null
        or value = '')))
        ;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
        set v_count := 0;
        OPEN cur1;
        REPEAT
        IF NOT done THEN
        FETCH cur1 INTO v_count;
           if v_count <> 0 then
              CLOSE cur1;
              delete from sms_log where router_name = node and tag_name = node;
              return true;
           end if;
        END IF;
        UNTIL done END REPEAT;
        CLOSE cur1;
        end;
        end if;
        return false;
     end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_should_send_gateway_sms`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_should_send_gateway_sms`(
     ) RETURNS tinyint(1)
begin
        declare v_count int default 0;
        select count(*)
        into v_count
        from sms_log
        where router_name = 'GATEWAY'
        and tag_name = 'GATEWAY';
        if v_count = 0 then
           return true;
        else
        begin
        declare done int DEFAULT 0;
        DECLARE cur1 CURSOR FOR
        select count(*)
        from sms_log
        where
        router_name = 'GATEWAY'
        and tag_name = 'GATEWAY'
        and TIMESTAMPDIFF(SECOND, last_sms_sent, now()) >
        (select IF(cast(value as signed) > 0, cast(value as signed), 120) GatewaySMSTimeout
        from system_properties
        where property = 'GatewaySMSTimeout'
        and exists
        (select * from system_properties
        where property = 'GatewaySMSTimeout'
        and value is not null
        and value <> '')
        union
        select 120 GatewaySMSTimeout
        from system_properties
        where not exists
        (select * from system_properties
        where property = 'GatewaySMSTimeout')
        union
        select 120 GatewaySMSTimeout
        from system_properties
        where exists
        (select * from system_properties
        where property = 'GatewaySMSTimeout'
        and (value is null
        or value = '')))
        ;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
        set v_count := 0;
        OPEN cur1;
        REPEAT
        IF NOT done THEN
        FETCH cur1 INTO v_count;
           if v_count <> 0 then
              CLOSE cur1;
              delete from sms_log where router_name = 'GATEWAY' and tag_name = 'GATEWAY';
              return true;
           end if;
        END IF;
        UNTIL done END REPEAT;
        CLOSE cur1;
    
        end;
        end if;
        return false;
     end;

 $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `wvs`.`udf_should_send_sms`$$
CREATE DEFINER=`root`@`localhost` FUNCTION  `wvs`.`udf_should_send_sms`(
     p_node varchar(10),
     node varchar(10)
     ) RETURNS tinyint(1)
begin
        declare v_count int default 0;
        select count(*)
        into v_count
        from sms_log
        where router_name = p_node
        and tag_name = node;
        if v_count = 0 then
           return true;
        else
        begin
        declare done int DEFAULT 0;
        DECLARE cur1 CURSOR FOR
        select count(*)
        from sms_log
        where
        router_name = p_node
        and tag_name = node
        and TIMESTAMPDIFF(SECOND, last_sms_sent, now()) >
        (select IF(cast(value as signed) > 0, cast(value as signed), 120) ChokePointSMSTimeout
        from system_properties
        where property = 'ChokePointSMSTimeout'
        and exists
        (select * from system_properties
        where property = 'ChokePointSMSTimeout'
        and value is not null
        and value <> '')
        union
        select 120 ChokePointSMSTimeout
        from system_properties
        where not exists
        (select * from system_properties
        where property = 'ChokePointSMSTimeout')
        union
        select 120 ChokePointSMSTimeout
        from system_properties
        where exists
        (select * from system_properties
        where property = 'ChokePointSMSTimeout'
        and (value is null
        or value = '')))
        ;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
        set v_count := 0;
        OPEN cur1;
        REPEAT
        IF NOT done THEN
        FETCH cur1 INTO v_count;
           if v_count <> 0 then
              CLOSE cur1;
              delete from sms_log where router_name = p_node and tag_name = node;
              return true;
           end if;
        END IF;
        UNTIL done END REPEAT;
        CLOSE cur1;
    
        end;
        end if;
        return false;
     end;

 $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_clear_transaction_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_clear_transaction_data`()
begin
   truncate otap_config;
   truncate pending_messages;
   truncate delivery_log;
   truncate node_txn;
   truncate data_txn;
   truncate message_txn;
   truncate sms_log;
   truncate sensor_alert_log;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_location_wise_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_location_wise_report`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `location` VARCHAR(50) NOT NULL,
  `tag` VARCHAR(10) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` varchar(20) NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_location_wise_report_hist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_location_wise_report_hist`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `location` VARCHAR(50) NOT NULL,
  `tag` VARCHAR(10) NOT NULL,
  `allocated_to` VARCHAR(50) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` varchar(20) NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_mis_start_stop`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_mis_start_stop`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `location` VARCHAR(50) NOT NULL,
  `tag` VARCHAR(10) NOT NULL,
  `allocated_to` VARCHAR(50) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` LONG NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_mis_tag_activity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_mis_tag_activity`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `location` VARCHAR(50) NOT NULL,
  `tag` VARCHAR(10) NOT NULL,
  `allocated_to` VARCHAR(50) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` LONG NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_mis_tag_utilization`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_mis_tag_utilization`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `location` VARCHAR(50) NOT NULL,
  `tag` VARCHAR(10) NOT NULL,
  `allocated_to` VARCHAR(50) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` LONG NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_nw_router_activity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_nw_router_activity`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_nw_tag_activity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_nw_tag_activity`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_sensor_activity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_sensor_activity`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_sensor_zone_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_sensor_zone_report`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `slice` INT NOT NULL,
  `from_date` TIMESTAMP NOT NULL,
  `to_date` TIMESTAMP NOT NULL,
  `time_duration` VARCHAR(100) NOT NULL,
  `min_value` DOUBLE(8,2) NOT NULL,
  `max_value` DOUBLE(8,2) NOT NULL,
  `avg_value` DOUBLE(8,2) NOT NULL,
  `data_count` INT NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_tagwise_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_tagwise_report`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `tag` VARCHAR(10) NOT NULL,
  `location` VARCHAR(50) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` varchar(100) NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_create_table_tagwise_report_hist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_create_table_tagwise_report_hist`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
SET @sql = CONCAT('create table ',table_name,' (`row_num` INTEGER NOT NULL DEFAULT NULL AUTO_INCREMENT,
  `location` VARCHAR(50) NOT NULL,
  `tag` VARCHAR(10) NOT NULL,
  `allocated_to` VARCHAR(50) NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  `duration` varchar(20) NOT NULL,
  PRIMARY KEY (`row_num`))');
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_del_otap_config`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_del_otap_config`(
node varchar(10),
msg varchar(10)
)
begin
update otap_config
set is_sent = 'Y' 
where node_id = node
and message_id = msg;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_del_pending_config_messages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_del_pending_config_messages`(
device varchar(10),
prop varchar(10)
)
begin
delete from pending_messages
where node_id = device
and message_id =
(select action_type_id from action_type_master where action_type_desc = prop);
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_del_pending_messages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_del_pending_messages`(
node varchar(10),
msg varchar(10)
)
begin
delete from pending_messages 
where node_id = node
and message_id = msg;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_del_sms_log`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_del_sms_log`(
router_name varchar(10),
tag_name varchar(10)
)
begin
delete from sms_log 
where router_name = router_name and tag_name = tag_name;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_diag_beacon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_diag_beacon`(
node varchar(10),
parent_node varchar(10),
min_receive_time TIMESTAMP,
max_receive_time TIMESTAMP)
begin
select a.node_id, b.selected_parent, under_selected_parent, under_all_parents,
((under_all_parents-under_selected_parent)/under_all_parents)*100 percentage_error
from
(select node_id, count(*) under_all_parents
from node_txn_history
where node_id = node
and receive_time >= min_receive_time
and receive_time <= max_receive_time
group by node_id) a,
(select node_id, parent_node_id selected_parent, count(*) under_selected_parent
from node_txn_history
where node_id = node
and parent_node_id = parent_node
and receive_time >= min_receive_time
and receive_time <= max_receive_time
group by node_id) b
where a.node_id = b.node_id;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_drop_table`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_drop_table`(
table_name varchar(100)
)
begin
SET @sql = CONCAT('drop table if exists ',table_name);
PREPARE stmt FROM @sql;
EXECUTE stmt;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_emergency_delete_all_hist_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_emergency_delete_all_hist_data`(
p_from_time timestamp,
p_to_time timestamp
)
begin
delete from data_txn            where receive_time >= p_from_time and receive_time <= p_to_time;
delete from data_txn_history    where receive_time >= p_from_time and receive_time <= p_to_time;
delete from delivery_log        where notification_time >= p_from_time and notification_time <= p_to_time;
delete from listener_log        where receive_time >= p_from_time and receive_time <= p_to_time;
delete from message_txn         where receive_time >= p_from_time and receive_time <= p_to_time;
delete from message_txn_history where receive_time >= p_from_time and receive_time <= p_to_time;
delete from node_txn            where receive_time >= p_from_time and receive_time <= p_to_time;
delete from node_txn_history    where receive_time >= p_from_time and receive_time <= p_to_time;
delete from process_txn            where allocation_time >= p_from_time and allocation_time <= p_to_time;
delete from process_txn_history    where allocation_time >= p_from_time and allocation_time <= p_to_time;
delete from sms_log                where last_sms_sent >= p_from_time and last_sms_sent <= p_to_time;
delete from wb1_image_txn          where receive_time >= p_from_time and receive_time <= p_to_time;
delete from wb1_load_txn        where receive_time >= p_from_time and receive_time <= p_to_time;
delete from wb2_image_txn       where receive_time >= p_from_time and receive_time <= p_to_time;
delete from wb2_load_txn        where receive_time >= p_from_time and receive_time <= p_to_time;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_action`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_action`(
sensor_type_id varchar(10),
node_id varchar(10),
alert_condition varchar(3),
alert_value float
)
begin 
select action_type_id, action_recipient from action_master where 
action_id = (select action_id from alert_master where 
sensor_type_id=sensor_type_id and node_id=node_id 
and alert_condition=alert_condition and alert_value=alert_value);
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_alert_count`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_alert_count`()
begin 
select count(*) from alert_master;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_auth_tag`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_auth_tag`(node_id varchar(10))
begin
Select A.VALUE From (Select NODE_ID, VALUE From NODE_PROPERTIES Where PROPERTY = 'authTag') A 
Join NODE_MASTER B On A.VALUE = B.NODE_ID Where A.NODE_ID = node_id;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_delivery_status`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_delivery_status`(
node_id varchar(10),
message_queue_id int
)
begin 
select delivery_status, notification_time from delivery_log 
where node_id = node_id and message_queue_id = message_queue_id;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_is_auth_access`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_is_auth_access`(
node_id varchar(10),
value varchar(50)
)
begin 
select count(*) from node_properties 
where node_id = node_id and property = 'authTag' and value = value;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_is_choke_point`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_is_choke_point`(
node_id varchar(10)
)
begin
select value from node_properties where node_id = node_id and property = 'isChokePoint';
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_is_valid_queue_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_is_valid_queue_id`(
node_id varchar(10), 
message_queue_id int )
begin 
select count(*) from delivery_log where node_id = node_id and message_queue_id = message_queue_id;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_last_sms_time`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_last_sms_time`(router_name varchar(10), tag_name varchar(10))
begin
select last_sms_sent from sms_log where router_name = router_name and tag_name = tag_name;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_latest_queue_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_latest_queue_id`(node_id varchar(10))
begin
SELECT message_queue_id FROM delivery_log
where node_id = node_id and notification_time = 
(SELECT max(notification_time) FROM delivery_log 
where delivery_status = 'WRITTEN_TO_PORT'
group by
node_id having node_id = node_id);
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_message_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_message_data`()
begin
Select T.RECEIVE_TIME, T.NODE_ID, T.MESSAGE_ID, M.MESSAGE
From MESSAGE_TXN T
Inner Join MESSAGE_MASTER M
On T.MESSAGE_ID = M.MESSAGE_ID;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_nw_router_activity_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_nw_router_activity_data`(
_router_id varchar(10),
_day timestamp,
_interval numeric,
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_router_activity CURSOR FOR
       select receive_time from node_txn_history
       where parent_node_id = _router_id
       and date(receive_time) = date(_day)
       order by receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count from node_txn_history
       where parent_node_id = _router_id
       and date(receive_time) = date(_day);
if(v_count > 0) then
            OPEN cur_router_activity;
                cursor_loop:LOOP
                    FETCH cur_router_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_router_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_nw_tag_activity_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_nw_tag_activity_data`(
_tag_id varchar(10),
_day timestamp,
_interval numeric,
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_tag_activity CURSOR FOR
       select receive_time from node_txn_history
       where node_id = _tag_id
       and date(receive_time) = date(_day)
       order by receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count from node_txn_history
       where node_id = _tag_id
       and date(receive_time) = date(_day);
if(v_count > 0) then
            OPEN cur_tag_activity;
                cursor_loop:LOOP
                    FETCH cur_tag_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_tag_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_queue_size`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_queue_size`(node_id varchar(10))
begin
select count(message_queue_id) from delivery_log where node_id = node_id;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_rtr_pos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_rtr_pos`(node_id varchar(10))
begin
Select IfNull(X_POS,0)  X_POS, IfNull(Y_POS,0)  Y_POS From PROFILE_CONFIG Where NODE_ID = node_id;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_activity_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_activity_data`(
_tag_id varchar(10),
_channel int(2),
_day timestamp,
_interval numeric,
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_sensor_activity CURSOR FOR
       select receive_time from data_txn_history
       where node_id = _tag_id
       and channel = _channel
       and date(receive_time) = date(_day)
       order by receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count from data_txn_history
       where node_id = _tag_id
       and channel = _channel
       and date(receive_time) = date(_day);
if(v_count > 0) then
            OPEN cur_sensor_activity;
                cursor_loop:LOOP
                    FETCH cur_sensor_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_sensor_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_activity_greater_cond`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_activity_greater_cond`(
_tag_id varchar(10),
_channel int(2),
_day timestamp,
_interval numeric,
_alert_value double(10,3),
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_sensor_activity CURSOR FOR
       select dth.receive_time
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data > _alert_value
       order by dth.receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data > _alert_value;
if(v_count > 0) then
            OPEN cur_sensor_activity;
                cursor_loop:LOOP
                    FETCH cur_sensor_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_sensor_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_activity_greater_equals_cond`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_activity_greater_equals_cond`(
_tag_id varchar(10),
_channel int(2),
_day timestamp,
_interval numeric,
_alert_value double(10,3),
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_sensor_activity CURSOR FOR
       select dth.receive_time
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data >= _alert_value
       order by dth.receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data >= _alert_value;
if(v_count > 0) then
            OPEN cur_sensor_activity;
                cursor_loop:LOOP
                    FETCH cur_sensor_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_sensor_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_activity_less_cond`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_activity_less_cond`(
_tag_id varchar(10),
_channel int(2),
_day timestamp,
_interval numeric,
_alert_value double(10,3),
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_sensor_activity CURSOR FOR
       select dth.receive_time
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data < _alert_value
       order by dth.receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data < _alert_value;
if(v_count > 0) then
            OPEN cur_sensor_activity;
                cursor_loop:LOOP
                    FETCH cur_sensor_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_sensor_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_activity_less_equals_cond`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_activity_less_equals_cond`(
_tag_id varchar(10),
_channel int(2),
_day timestamp,
_interval numeric,
_alert_value double(10,3),
_table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_loop_started INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_receive_time timestamp;
DECLARE v_from_time timestamp;
DECLARE v_to_time timestamp;
DECLARE cur_sensor_activity CURSOR FOR
       select dth.receive_time
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data <= _alert_value
       order by dth.receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       select count(*) into v_count
       from data_txn_history dth, sensor_data_lkp sdlkp
       where dth.node_id = _tag_id
       and dth.channel = _channel
       and date(dth.receive_time) = date(_day)
       and (select sensor_type_id
            from node_channel_sensor
            where node_id = _tag_id
            and channel = _channel) = sdlkp.sensor_type_id
       and dth.node_data = sdlkp.node_data
       and sdlkp.mapped_data <= _alert_value;
if(v_count > 0) then
            OPEN cur_sensor_activity;
                cursor_loop:LOOP
                    FETCH cur_sensor_activity INTO v_receive_time;
                    if done = 1 then
                          SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_receive_time,'\')');
                          PREPARE stmt FROM @sql;
                          EXECUTE stmt;
                          LEAVE cursor_loop;
                    end if;
                    IF(v_loop_started = 0) THEN
                          set v_from_time = v_receive_time;
                          set v_to_time = v_receive_time;
                          set v_loop_started = 1;
                    ELSE
                          if(TIMESTAMPDIFF(SECOND, v_to_time, v_receive_time) > _interval) then
                              SET @sql = CONCAT('insert into ',_table_name,'(entry_time, exit_time)
                                                 values (\'',v_from_time,'\',\'',v_to_time,'\')');
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              SET v_from_time = v_receive_time;
                              SET v_to_time = v_receive_time;
                          else
                              set v_to_time = v_receive_time;
                          end if;
                    END IF;
                END LOOP cursor_loop;
            CLOSE cur_sensor_activity;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_count`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_count`()
begin
select count(sensor_type_id) from sensor_type_master;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_data`(node_id varchar(10))
begin
Select B.CHANNEL, B.SENSOR_TYPE_ID, IfNull(C.MAPPED_DATA,0)  As VALUE
From DATA_TXN A
Inner Join NODE_CHANNEL_SENSOR B
On  A.NODE_ID = B.NODE_ID
And A.CHANNEL = B.CHANNEL
Left Outer Join SENSOR_DATA_LKP C
On  C.SENSOR_TYPE_ID = B.SENSOR_TYPE_ID
And C.NODE_DATA = A.NODE_DATA
Where A.NODE_ID = node_id;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_history`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_history`(tag_id varchar(10), channel int(2), start_datetime timestamp, end_datetime timestamp, chunk numeric)
begin
Select A.Slice, AVG(A.Mapped_Data) Value
From
(
  Select A.SLICE, IfNull(B.Mapped_Data,0) As Mapped_Data
  From
  (
	  Select FLOOR(TIMESTAMPDIFF(second, A.receive_time, end_datetime)/chunk) SLICE, A.node_data
	  From data_txn_history A
	  Where A.node_id = tag_id
          And A.channel = channel
          And A.receive_time between start_datetime  and end_datetime
  )As A
  Left Join
  (
    Select Node_Data, Mapped_Data
    From Sensor_Data_Lkp
    Where Sensor_Type_Id = ( Select A.Sensor_Type_Id
                               From Node_Channel_Sensor As A
                               Where A.Node_Id = tag_id
                               And   A.Channel = channel )
  ) As B
  On A.Node_Data = B.Node_Data
) As A
Group By A.Slice;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_history_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_history_report`(
tag_id varchar(10),
channel int(2),
start_datetime timestamp,
end_datetime timestamp,
chunk numeric)
begin
DECLARE v_channel int(2);
Select A.slice,
       DATE_ADD(start_datetime,INTERVAL chunk*A.Slice SECOND) from_date,
       DATE_ADD(start_datetime,INTERVAL chunk*(A.Slice+1) SECOND) to_date,
       concat('From ',DATE_ADD(start_datetime,INTERVAL chunk*A.Slice SECOND),
              ' To ',
              DATE_ADD(start_datetime,INTERVAL chunk*(A.Slice+1) SECOND)
             ) time_duration,
              min(A.Mapped_Data) min_value,
              max(A.Mapped_Data) max_value,
              avg(A.Mapped_Data) avg_value,
              count(A.Mapped_Data) data_count
From
(
  Select A.SLICE, IfNull(B.Mapped_Data,0) As Mapped_Data
  From
  (
	  Select CEIL(TIMESTAMPDIFF(second, start_datetime, A.receive_time)/chunk) SLICE, A.node_data
	  From data_txn_history A
	  Where A.node_id = tag_id
          And A.channel = channel
          And A.receive_time between start_datetime  and end_datetime
  )As A
  Left Join
  (
    Select Node_Data, Mapped_Data
    From Sensor_Data_Lkp
    Where Sensor_Type_Id = ( Select A.Sensor_Type_Id
                               From Node_Channel_Sensor As A
                               Where A.Node_Id = tag_id
                               And   A.Channel = channel )
  ) As B
  On A.Node_Data = B.Node_Data
) As A
Group By A.Slice;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_history_zone_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_history_zone_report`(
tag_id varchar(10),
channel int(2),
start_datetime timestamp,
end_datetime timestamp,
chunk numeric,
table_name varchar(100))
begin
DECLARE done INT DEFAULT 0;
DECLARE v_count int;
DECLARE v_slice int;
DECLARE v_from_date timestamp;
DECLARE v_to_date timestamp;
DECLARE v_time_duration varchar(100);
DECLARE v_min_value double;
DECLARE v_max_value double; 
DECLARE v_avg_value double;
DECLARE v_data_count int;
DECLARE d INT DEFAULT 0;
DECLARE cur_sensor_zone CURSOR FOR
       Select A.slice,
       DATE_ADD(start_datetime,INTERVAL chunk*A.Slice SECOND) from_date,
       DATE_ADD(start_datetime,INTERVAL chunk*(A.Slice+1) SECOND) to_date,
       concat('From ',DATE_ADD(start_datetime,INTERVAL chunk*A.Slice SECOND),
              ' To ',
              DATE_ADD(start_datetime,INTERVAL chunk*(A.Slice+1) SECOND)
             ) time_duration,
              min(A.Mapped_Data) min_value,
              max(A.Mapped_Data) max_value,
              avg(A.Mapped_Data) avg_value,
              count(A.Mapped_Data) data_count
        From
            (
            Select A.SLICE, IfNull(B.Mapped_Data,0) As Mapped_Data
            From
                  (
              	  Select CEIL(TIMESTAMPDIFF(second, start_datetime, A.receive_time)/chunk) SLICE, A.node_data
              	  From data_txn_history A
                  	  Where A.node_id = tag_id
                      And A.channel = channel
                      And A.receive_time between start_datetime  and end_datetime
                  )As A
            Left Join
                  (
                  Select Node_Data, Mapped_Data
                  From Sensor_Data_Lkp
                  Where Sensor_Type_Id = ( Select A.Sensor_Type_Id
                               From Node_Channel_Sensor As A
                               Where A.Node_Id = tag_id
                               And   A.Channel = channel )
                  ) As B
            On A.Node_Data = B.Node_Data
            ) As A
        Group By A.Slice;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

select count(*) into v_count from data_txn_history
where
node_id = tag_id
and channel = channel
and receive_time between start_datetime and end_datetime;
if(v_count > 0) then
            
            
            OPEN cur_sensor_zone;
                cursor_loop:LOOP
                    FETCH cur_sensor_zone INTO v_slice, v_from_date,v_to_date,v_time_duration, v_min_value, v_max_value, v_avg_value, v_data_count;
                    if done = 1 then
                    LEAVE cursor_loop;
                    end if;
                    SET @sql = CONCAT('insert into ',table_name,'(slice, from_date, to_date, time_duration, min_value, max_value, avg_value, data_count)
                                        values (',v_slice,',\'',v_from_date,'\',\'',v_to_date,'\',\'',v_time_duration,'\',round(',v_min_value,',2),round(',v_max_value,',2),round(',v_avg_value,',2),',v_data_count,')');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
                END LOOP cursor_loop;
            CLOSE cur_sensor_zone;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_info`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_info`()
begin
select c.sensor_type_id, b.sensor_type_desc, b.uom, a.node_id, a.node_data, a.receive_time from data_txn a, sensor_type_master b, node_channel_sensor c
where a.node_id = c.node_id and a.channel = c.channel and c.sensor_type_id = b.sensor_type_id;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_sensor_type_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_sensor_type_id`()
begin
select sensor_type_id from sensor_type_master;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_tags`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_tags`()
begin
select node_id from node_master where node_type_id = 'E';
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_get_viewer_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_get_viewer_data`(profile_id varchar(10))
begin
Select A.PARENT_NODE_ID, A.NODE_ID, A.IS_NODE_ACTIVE,
       (Case A.RECEIVE_TIME When Null Then -1 Else Abs(TimeStampDiff(second, Now(), A.RECEIVE_TIME)) End) As IDLE_TIME,
       If(IfNull(B.CHANNELS,0) = 0,'N','Y') As  IS_SENSOR_TAG,
       IfNull(C.LOCATION_DESC,'') As LOCATION_DESC,
       IfNull(D.ALLOCATED_TO,'') As ALLOCATED_TO,
       If(A.PARENT_NODE_ID=A.NODE_ID,A.X_POS,0) As X_POS,
       If(A.PARENT_NODE_ID=A.NODE_ID,A.Y_POS,0) As Y_POS,
       IfNull(E.IS_CHOKEPOINT,'N') As IS_CHOKEPOINT,
	     If(IfNull(E.IS_CHOKEPOINT,'N')='N','Y',If(A.PARENT_NODE_ID=A.NODE_ID,'Y',IfNull(F.IS_AUTHORISED,'N'))) As IS_AUTHORISED
From
(
    Select P.NODE_ID As PARENT_NODE_ID,
           IfNull(A.NODE_ID,P.NODE_ID) As NODE_ID,
           IfNull(A.IS_NODE_ACTIVE,'N') As IS_NODE_ACTIVE,
           A.RECEIVE_TIME, P.X_POS, P.Y_POS
    From PROFILE_CONFIG P
    Left Join NODE_TXN A
    On A.PARENT_NODE_ID = P.NODE_ID
    Where P.PROFILE_ID = profile_id
    Group By P.NODE_ID, A.NODE_ID, A.IS_NODE_ACTIVE, A.RECEIVE_TIME
) A
Left Join
(
        Select NODE_ID, Count(*)  CHANNELS From NODE_CHANNEL_SENSOR Group By NODE_ID
) As B
On A.NODE_ID = B.NODE_ID
Left Join
(
        Select A.NODE_ID, B.LOCATION_DESC
        From
        (
                Select NODE_ID, VALUE As LOCATION_ID
                From NODE_PROPERTIES
                Where PROPERTY = 'locationId'
        ) As A
        Join LOCATION_MASTER B
        On A.LOCATION_ID = B.LOCATION_ID
) As C
On A.PARENT_NODE_ID = C.NODE_ID
Left Join
(
        Select NODE_ID, VALUE As ALLOCATED_TO
        From NODE_PROPERTIES
        Where PROPERTY = 'allocatedTo'
) As D
On A.NODE_ID = D.NODE_ID
Left Join
(
        Select NODE_ID As PARENT_NODE_ID, (Case Count(*)>0 When 0 Then 'N' Else 'Y' End) As IS_CHOKEPOINT
        From NODE_PROPERTIES
        Where PROPERTY = 'authTag'
        Group By NODE_ID
) As E
On A.PARENT_NODE_ID = E.PARENT_NODE_ID
Left Join
(
        Select NODE_ID As PARENT_NODE_ID, VALUE As NODE_ID, 'Y' As IS_AUTHORISED
        From NODE_PROPERTIES
        Where PROPERTY = 'authTag'
) As F
On A.PARENT_NODE_ID = F.PARENT_NODE_ID And A.NODE_ID = F.NODE_ID
Order By A.PARENT_NODE_ID, If(A.NODE_ID = A.PARENT_NODE_ID,0,1);
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_data_txn`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_data_txn`(node varchar(10), chan int, val double)
begin
DECLARE v_now timestamp;
select now() into v_now;
delete from data_txn
where node_id = node
and channel = chan;
insert into data_txn
values (node, chan, val, v_now);
insert into data_txn_history
values (node, chan, val, v_now);
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_delivery_log`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_delivery_log`(node_id varchar(10),
message_queue_id int,
message_id varchar(10),
delivery_status varchar(45),
client_address varchar(50))
begin
insert into delivery_log (
node_id,message_queue_id,message_id,
delivery_status,notification_time,client_address) values
(
node_id, message_queue_id, message_id,
delivery_status,
now(),client_address
);
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_listener_log`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_listener_log`(
raw varchar(100),
rectime timestamp,
millis int
)
begin
insert into listener_log
values (raw, rectime, millis, now());
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_message_sms_log`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_message_sms_log`(p_router_id varchar(10),
p_message varchar(10),
p_sms_status boolean,
p_time timestamp
)
begin
DECLARE v_router_location varchar(50);

DECLARE v_mapped_router varchar(10);
DECLARE v_mapped_router_location varchar(50);
DECLARE v_mapped_router_dir_id varchar(10);

DECLARE v_row_count int;
DECLARE v_sms_no varchar(15);
DECLARE v_sms_status varchar(5);

if(p_sms_status) then
  set v_sms_status = '1';
else
  set v_sms_status = '0';
end if;

   select lm.location_desc into v_router_location
   from location_master lm, node_properties np
   where np.node_id = p_router_id and
   np.property = 'locationId' and
   np.value = lm.location_id;

   select mapped_router_id into v_mapped_router
   from dummy_router_lkp
   where router_id = p_router_id and
   direction_id = p_message;

   select lm.location_desc into v_mapped_router_location
   from location_master lm, node_properties np
   where np.node_id = v_mapped_router and
   np.property = 'locationId' and
   np.value = lm.location_id;

   select mapped_direction_id into v_mapped_router_dir_id
   from dummy_router_lkp
   where router_id = p_router_id and
   direction_id = p_message;


delete from message_txn
where node_id = p_router_id
and message_id = p_message;

delete from message_txn
where node_id = v_mapped_router
and message_id = v_mapped_router_dir_id;

insert into message_txn
values (p_router_id, p_message, p_time);

insert into message_txn
values (v_mapped_router, v_mapped_router_dir_id, p_time);

insert into message_txn_history
values (p_router_id, p_message, p_time);

insert into message_txn_history
values (v_mapped_router, v_mapped_router_dir_id, p_time);


    select value into v_sms_no from system_properties
    where property = 'EmergencySMSNumber';


    insert into message_txn_sms_log (parent_node, dummy_node,parent_location,dummy_location, receive_time, sms_no, sms_status, sms_time)
    values (p_router_id, v_mapped_router, v_router_location, v_mapped_router_location, p_time, v_sms_no, v_sms_status,p_time);



commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_message_txn`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_message_txn`(node varchar(10), message varchar(10))
begin
DECLARE v_now timestamp;

select now() into v_now;

if(node != 'E10' && node != 'E3')
then

delete from message_txn
where node_id = node
and message_id = message;
insert into message_txn
values (node, message, v_now);
insert into message_txn_history
values (node, message, v_now);
commit;


end if;


end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_node_txn`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_node_txn`(parent_node varchar(10), node varchar(10))
begin
DECLARE v_allocated_to VARCHAR(50) default null;
DECLARE v_now timestamp;
select now() into v_now;
select value
into v_allocated_to
from node_properties
where node_id = node
and property = 'allocatedTo';
delete from node_txn
where node_id = node;
insert into node_txn
values (parent_node, node, 'Y', v_now);
insert into node_txn_history
values (parent_node, node, v_allocated_to, v_now);
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_node_txn_sms_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_node_txn_sms_data`(parent_node varchar(10),
node varchar(10),
time_taken int)
begin
DECLARE v_now timestamp;
declare v_distance int;
declare v_speed double;
declare v_prev_rec_time timestamp;

select now() into v_now;
select receive_time into v_prev_rec_time from sms_txn
where coo_name = parent_node and tag_name = node;

if ((timestampdiff(second, v_prev_rec_time, v_now) > 10 || v_prev_rec_time is null) && time_taken > 5) then

  select distance into v_distance from distance_master
  where coo_name = parent_node;

  select (v_distance/time_taken)*60*60 into v_speed;

  delete from node_txn
  where node_id = node;
  delete from sms_txn
  where coo_name  = parent_node
  and tag_name = node;

  insert into node_txn
  values (parent_node, node, 'Y', v_now);
  insert into sms_txn
  values(parent_node, node, time_taken, v_speed, v_now);

  insert into node_txn_history
  values (parent_node, node, 'aaa', v_now);

  insert into sms_txn_history
  values(parent_node, node, time_taken, v_speed, v_now);

end if;

commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_pending_messages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_pending_messages`(
node varchar(10),
msg int,
addr varchar(50))
begin
insert into pending_messages
values (node, msg, addr);
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_sensor_alert_log`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_sensor_alert_log`(
node_id varchar(10),
channel int,
sensor_type_id varchar(10))
begin
insert into sensor_alert_log
values (node_id, channel, sensor_type_id, now());
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_ins_sms_log`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_ins_sms_log`(router_name varchar(10),
tag_name varchar(10))
begin
insert into sms_log (router_name,tag_name,last_sms_sent)
values (router_name, tag_name, now());
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_location_wise_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_location_wise_report`(
locationID varchar(50),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
DECLARE v_no_of_router_under_location INT;
DECLARE v_location_desc varchar(50);
DECLARE done INT DEFAULT 0;
DECLARE v_is_started INT DEFAULT 0;
DECLARE v_parent_node_id varchar(10);
DECLARE v_node_id varchar(10);
DECLARE v_node_id_temp varchar(10);
DECLARE v_receive_time timestamp;
DECLARE v_entry_time timestamp;
DECLARE v_exit_time timestamp;
DECLARE cur_tag_beacons CURSOR FOR
                                      select parent_node_id, node_id, receive_time
                                      from node_txn_history
                                      where receive_time
                                      between from_date and to_date
                                      and node_id
                                      like 'E%'
                                      and parent_node_id
                                      in
                                      (select a.node_id
                                      from node_master a, node_properties b
                                      where a.node_type_id = 'R'
                                      and a.node_id = b.node_id
                                      and b.property = 'locationId'
                                      and b.value = locationID)
                                      order by node_id, receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
select count(*) into v_no_of_router_under_location from node_properties where property = 'locationId'
and value = locationID;
SELECT location_desc into v_location_desc FROM location_master where location_id = locationID;
if(v_no_of_router_under_location > 0) then
    OPEN cur_tag_beacons;
    REPEAT
          IF NOT done THEN
                          FETCH cur_tag_beacons INTO v_parent_node_id, v_node_id, v_receive_time;
                          if(v_is_started = 0) then
                                  set v_entry_time = v_receive_time;
                                  set v_exit_time = v_receive_time;
                                  set v_node_id_temp = v_node_id;
                                  set v_is_started = 1;
                          else
                                  if(v_node_id_temp = v_node_id) then
                                               IF(timestampdiff(second, v_exit_time, v_receive_time) <= 2 * (select if(value > 0, value, 4) value
                                                                                                      from node_properties n
                                                                                                      where node_id = v_parent_node_id
                                                                                                      and property = 'beaconInterval'
                                                                                                      and exists
                                                                                                      (select * from node_properties
                                                                                                      where node_id = n.node_id
                                                                                                      and property = 'beaconInterval')
                                                                                                      union
                                                                                                      select 4 value from node_properties n
                                                                                                      where not exists
                                                                                                      (select * from node_properties
                                                                                                      where node_id = v_parent_node_id
                                                                                                      and property = 'beaconInterval')))
                                               THEN
                                                       set v_exit_time = v_receive_time;
                                               ELSE
                                                       if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                             SET @sql = CONCAT('insert into ',table_name,' (location, tag, entry_time, exit_time, duration) values (\'',v_location_desc,'\' ,\'',v_node_id_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                                             PREPARE stmt FROM @sql;
                                                             EXECUTE stmt;
                                                       end if;
                                                       set v_entry_time = v_receive_time;
                                                       set v_exit_time = v_receive_time;
                                                       set v_node_id_temp = v_node_id;
                                                       set v_is_started = 1;
                                               END IF;
                                  else
                                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                       SET @sql = CONCAT('insert into ',table_name,' (location, tag, entry_time, exit_time, duration) values (\'',v_location_desc,'\' ,\'',v_node_id_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                                       PREPARE stmt FROM @sql;
                                                       EXECUTE stmt;
                                                end if;
                                                set v_entry_time = v_receive_time;
                                                set v_exit_time = v_receive_time;
                                                set v_node_id_temp = v_node_id;
                                                set v_is_started = 1;
                                  end if;
                          end if;
          END IF;
    UNTIL done END REPEAT;
    CLOSE cur_tag_beacons;
    if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
          SET @sql = CONCAT('insert into ',table_name,' (location, tag, entry_time, exit_time, duration) values (\'',v_location_desc,'\' ,\'',v_node_id_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
    end if;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_location_wise_report_hist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_location_wise_report_hist`(
location_description varchar(50),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
DECLARE v_no_of_router_under_location INT;
DECLARE v_location_desc varchar(50);
DECLARE done INT DEFAULT 0;
DECLARE v_is_started INT DEFAULT 0;
DECLARE v_parent_node_id varchar(10);
DECLARE v_node_id varchar(10);
DECLARE v_node_id_temp varchar(10);
DECLARE v_allocated_to varchar(50);
DECLARE v_allocated_to_temp varchar(50);
DECLARE v_receive_time timestamp;
DECLARE v_entry_time timestamp;
DECLARE v_exit_time timestamp;
DECLARE cur_tag_beacons CURSOR FOR
                                      select parent_node_id, node_id,allocated_to, receive_time
                                      from node_txn_history
                                      where receive_time
                                      between from_date and to_date
                                      and node_id
                                      like 'E%'
                                      and parent_node_id
                                      in
                                      (select a.node_id
                                      from node_master a, node_properties b
                                      where a.node_type_id = 'R'
                                      and a.node_id = b.node_id
                                      and b.property = 'locationId'
                                      and b.value = (select location_id from location_master
                                                     where location_desc = location_description))
                                      order by node_id, receive_time;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
select count(*) into v_no_of_router_under_location from node_properties where property = 'locationId'
and value = (select location_id from location_master
            where location_desc = location_description);

if(v_no_of_router_under_location > 0) then
    OPEN cur_tag_beacons;
    REPEAT
          IF NOT done THEN
                          FETCH cur_tag_beacons INTO v_parent_node_id, v_node_id, v_allocated_to,v_receive_time;
                          if(v_is_started = 0) then
                                  set v_entry_time = v_receive_time;
                                  set v_exit_time = v_receive_time;
                                  set v_node_id_temp = v_node_id;
                                  set v_allocated_to_temp = v_allocated_to;
                                  set v_is_started = 1;
                          else
                                  if(v_node_id_temp = v_node_id && v_allocated_to_temp = v_allocated_to) then
                                               IF(timestampdiff(second, v_exit_time, v_receive_time) <= 2 * (select if(value > 0, value, 4) value
                                                                                                      from node_properties n
                                                                                                      where node_id = v_parent_node_id
                                                                                                      and property = 'beaconInterval'
                                                                                                      and exists
                                                                                                      (select * from node_properties
                                                                                                      where node_id = n.node_id
                                                                                                      and property = 'beaconInterval')
                                                                                                      union
                                                                                                      select 4 value from node_properties n
                                                                                                      where not exists
                                                                                                      (select * from node_properties
                                                                                                      where node_id = v_parent_node_id
                                                                                                      and property = 'beaconInterval')))
                                               THEN
                                                       set v_exit_time = v_receive_time;
                                               ELSE
                                                       if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                             SET @sql = CONCAT('insert into ',table_name,' (location, tag, allocated_to, entry_time, exit_time, duration) values (\'',location_description,'\' ,\'',v_node_id_temp,'\' ,\'',v_allocated_to_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                                             PREPARE stmt FROM @sql;
                                                             EXECUTE stmt;
                                                       end if;
                                                       set v_entry_time = v_receive_time;
                                                       set v_exit_time = v_receive_time;
                                                       set v_node_id_temp = v_node_id;
                                                       set v_allocated_to_temp = v_allocated_to;
                                                       set v_is_started = 1;
                                               END IF;
                                  else
                                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                       SET @sql = CONCAT('insert into ',table_name,' (location, tag,allocated_to, entry_time, exit_time, duration) values (\'',location_description,'\' ,\'',v_node_id_temp,'\' ,\'',v_allocated_to_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                                       PREPARE stmt FROM @sql;
                                                       EXECUTE stmt;
                                                end if;
                                                set v_entry_time = v_receive_time;
                                                set v_exit_time = v_receive_time;
                                                set v_node_id_temp = v_node_id;
                                                set v_allocated_to_temp = v_allocated_to;
                                                set v_is_started = 1;
                                  end if;
                          end if;
          END IF;
    UNTIL done END REPEAT;
    CLOSE cur_tag_beacons;
    if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
          SET @sql = CONCAT('insert into ',table_name,' (location, tag,allocated_to, entry_time, exit_time, duration) values (\'',location_description,'\' ,\'',v_node_id_temp,'\' ,\'',v_allocated_to_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
    end if;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_mis_shift_wise_tag_utilization_out`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_mis_shift_wise_tag_utilization_out`(
allocated_to_name varchar(50),
from_date timestamp,
to_date timestamp,
from_time varchar(10),
to_time varchar(10),
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_allocated_to varchar(50);
  DECLARE v_allocated_to_temp varchar(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE v_node_id varchar(10);
  DECLARE v_node_id_temp varchar(10);
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id,a.node_id,a.allocated_to, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.allocated_to = allocated_to_name
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and date(a.receive_time) >= date(from_date)
                          and date(a.receive_time) <= date(to_date)
                          and (time(a.receive_time) < from_time
                              or time(a.receive_time) > to_time)
                          order by  c.location_id,a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.allocated_to = allocated_to_name
  and b.property = 'locationId'
  and c.location_id = b.value
  and date(a.receive_time) >= date(from_date)
  and date(a.receive_time) <= date(to_date)
  and (time(a.receive_time) < from_time
      or time(a.receive_time) > to_time)
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router,v_node_id,v_allocated_to, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_node_id_temp = v_node_id;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc && v_node_id_temp = v_node_id) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*  (select if(value > 0, value, 4) value
                                                                                                  from node_properties n
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'
                                                                                                  and exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = n.node_id
                                                                                                  and property = 'beaconInterval')
                                                                                                  union
                                                                                                  select 4 value from node_properties n
                                                                                                  where not exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'))   )
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                                      PREPARE stmt FROM @sql;
                                                      EXECUTE stmt;
                                                  end if;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id_temp,'\',\'',allocated_to_name,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                      PREPARE stmt FROM @sql;
                                      EXECUTE stmt;
                                end if;
                                set v_loc_temp = v_loc;
                                set v_node_id_temp = v_node_id;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                    SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
              end if;
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_mis_shift_wise_tag_utilization_within`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_mis_shift_wise_tag_utilization_within`(
allocated_to_name varchar(50),
from_date timestamp,
to_date timestamp,
from_time varchar(10),
to_time varchar(10),
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_allocated_to varchar(50);
  DECLARE v_allocated_to_temp varchar(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE v_node_id varchar(10);
  DECLARE v_node_id_temp varchar(10);
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id,a.node_id,a.allocated_to, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.allocated_to = allocated_to_name
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and date(a.receive_time) >= date(from_date)
                          and date(a.receive_time) <= date(to_date)
                          and time(a.receive_time) >= from_time
                          and time(a.receive_time) <= to_time
                          order by  c.location_id,a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.allocated_to = allocated_to_name
  and b.property = 'locationId'
  and c.location_id = b.value
  and date(a.receive_time) >= date(from_date)
  and date(a.receive_time) <= date(to_date)
  and time(a.receive_time) >= from_time
  and time(a.receive_time) <= to_time
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router,v_node_id,v_allocated_to, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_node_id_temp = v_node_id;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc && v_node_id_temp = v_node_id) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*  (select if(value > 0, value, 4) value
                                                                                                  from node_properties n
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'
                                                                                                  and exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = n.node_id
                                                                                                  and property = 'beaconInterval')
                                                                                                  union
                                                                                                  select 4 value from node_properties n
                                                                                                  where not exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'))   )
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                                      PREPARE stmt FROM @sql;
                                                      EXECUTE stmt;
                                                  end if;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id_temp,'\',\'',allocated_to_name,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                      PREPARE stmt FROM @sql;
                                      EXECUTE stmt;
                                end if;
                                set v_loc_temp = v_loc;
                                set v_node_id_temp = v_node_id;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                    SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
              end if;
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_mis_start_stop`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_mis_start_stop`(
allocated_to_name varchar(50),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_allocated_to varchar(50);
  DECLARE v_allocated_to_temp varchar(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE v_node_id varchar(10);
  DECLARE v_node_id_temp varchar(10);
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id,a.node_id,a.allocated_to, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.allocated_to = allocated_to_name
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and a.receive_time between from_date and to_date
                          order by  a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.allocated_to = allocated_to_name
  and b.property = 'locationId'
  and c.location_id = b.value
  and a.receive_time between from_date and to_date
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router,v_node_id,v_allocated_to, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_node_id_temp = v_node_id;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc && v_node_id_temp = v_node_id) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*  (select if(value > 0, value, 4) value
                                                                                                  from node_properties n
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'
                                                                                                  and exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = n.node_id
                                                                                                  and property = 'beaconInterval')
                                                                                                  union
                                                                                                  select 4 value from node_properties n
                                                                                                  where not exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'))     )
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  if(timestampdiff(second, v_entry_time, v_exit_time) > 60) then
                                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                                      PREPARE stmt FROM @sql;
                                                      EXECUTE stmt;
                                                  end if;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                if(timestampdiff(second, v_entry_time, v_exit_time) > 60) then
                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id_temp,'\',\'',allocated_to_name,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                      PREPARE stmt FROM @sql;
                                      EXECUTE stmt;
                                end if;
                                set v_loc_temp = v_loc;
                                set v_node_id_temp = v_node_id;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              if(timestampdiff(second, v_entry_time, v_exit_time) > 60) then
                    SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
              end if;
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_mis_tag_activity_chart`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_mis_tag_activity_chart`(
allocated_to_name varchar(50),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_allocated_to varchar(50);
  DECLARE v_allocated_to_temp varchar(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE v_node_id varchar(10);
  DECLARE v_node_id_temp varchar(10);
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id,a.node_id,a.allocated_to, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.allocated_to = allocated_to_name
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and a.receive_time between from_date and to_date
                          order by  c.location_id,a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.allocated_to = allocated_to_name
  and b.property = 'locationId'
  and c.location_id = b.value
  and a.receive_time between from_date and to_date
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router,v_node_id,v_allocated_to, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_node_id_temp = v_node_id;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc && v_node_id_temp = v_node_id) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*  (select if(value > 0, value, 4) value
                                                                                                  from node_properties n
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'
                                                                                                  and exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = n.node_id
                                                                                                  and property = 'beaconInterval')
                                                                                                  union
                                                                                                  select 4 value from node_properties n
                                                                                                  where not exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'))   )
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                                  PREPARE stmt FROM @sql;
                                                  EXECUTE stmt;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id_temp,'\',\'',allocated_to_name,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                PREPARE stmt FROM @sql;
                                EXECUTE stmt;
                                set v_loc_temp = v_loc;
                                set v_node_id_temp = v_node_id;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_mis_tag_utilization`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_mis_tag_utilization`(
allocated_to_name varchar(50),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_allocated_to varchar(50);
  DECLARE v_allocated_to_temp varchar(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE v_node_id varchar(10);
  DECLARE v_node_id_temp varchar(10);
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id,a.node_id,a.allocated_to, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.allocated_to = allocated_to_name
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and a.receive_time between from_date and to_date
                          order by  c.location_id,a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.allocated_to = allocated_to_name
  and b.property = 'locationId'
  and c.location_id = b.value
  and a.receive_time between from_date and to_date
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router,v_node_id,v_allocated_to, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_node_id_temp = v_node_id;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc && v_node_id_temp = v_node_id) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*  (select if(value > 0, value, 4) value
                                                                                                  from node_properties n
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'
                                                                                                  and exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = n.node_id
                                                                                                  and property = 'beaconInterval')
                                                                                                  union
                                                                                                  select 4 value from node_properties n
                                                                                                  where not exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'))   )
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                                      PREPARE stmt FROM @sql;
                                                      EXECUTE stmt;
                                                  end if;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id_temp,'\',\'',allocated_to_name,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                                      PREPARE stmt FROM @sql;
                                      EXECUTE stmt;
                                end if;
                                set v_loc_temp = v_loc;
                                set v_node_id_temp = v_node_id;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                    SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\'))');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
              end if;
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_save_allocation_info_to_txn`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_save_allocation_info_to_txn`(
p_tag varchar(10),
p_allocated_to varchar(100),
p_material_type varchar(100)
)
begin
delete from process_txn
where node_id = p_tag;
insert into process_txn
(node_id, allocated_to, allocation_time, material_type)
values
(p_tag,   p_allocated_to, now(), p_material_type);
delete from node_properties
where node_id = p_tag
and property = 'allocatedTo';
insert into node_properties
(node_id, property, value)
values
(p_tag, 'allocatedTo', p_allocated_to);
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_save_allocation_info_to_txn_hist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_save_allocation_info_to_txn_hist`(
p_tag varchar(10)
)
begin
DECLARE v_allocated_to varchar(100);
DECLARE v_material_type varchar(100);
DECLARE v_wb1_image LONGBLOB;
DECLARE v_wb2_image LONGBLOB;
DECLARE v_wb1_weight DOUBLE;
DECLARE v_wb2_weight DOUBLE;
DECLARE v_wb1_time timestamp;
DECLARE v_wb2_time timestamp;
DECLARE v_allocation_time timestamp;
select allocated_to into v_allocated_to from process_txn where node_id = p_tag;
select allocation_time into v_allocation_time from process_txn where node_id = p_tag;
select material_type into v_material_type from process_txn where node_id = p_tag;
select wb1_image into v_wb1_image from process_txn where node_id = p_tag;
select wb1_weight into v_wb1_weight from process_txn where node_id = p_tag;
select wb1_time into v_wb1_time from process_txn where node_id = p_tag;
select wb2_image into v_wb2_image from process_txn where node_id = p_tag;
select wb2_weight into v_wb2_weight from process_txn where node_id = p_tag;
select wb2_time into v_wb2_time from process_txn where node_id = p_tag;
insert into process_txn_history
(node_id, allocated_to, allocation_time, material_type, wb1_image, wb1_weight, wb1_time, wb2_image, wb2_weight, wb2_time, deallocation_time)
values
(p_tag, v_allocated_to, v_allocation_time, v_material_type, v_wb1_image, v_wb1_weight, v_wb1_time, v_wb2_image, v_wb2_weight, v_wb2_time, now());
delete from process_txn  where node_id = p_tag;
delete from node_properties
where node_id = p_tag
and property = 'allocatedTo';
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_sensorwise_tabular_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_sensorwise_tabular_report`(
sensor varchar(50),
from_date timestamp,
to_date timestamp
)
begin
SELECT dth.node_id, dth.channel, stm.sensor_type_desc,stm.uom, avg(dth.node_data)avg_value, dth.receive_time
FROM data_txn_history dth,sensor_type_master stm, node_channel_sensor ncs 
where 
stm.sensor_type_desc = sensor and
stm.sensor_type_id = ncs.sensor_type_id and
ncs.node_id = dth.node_id and
ncs.channel = dth.channel and
receive_time between from_date and to_date
group by dth.node_id , dth.channel;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_tag_wise_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_tag_wise_report`(
node varchar(10),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.node_id = node
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and a.receive_time between from_date and to_date
                          order by  c.location_id,a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.node_id = node
  and b.property = 'locationId'
  and c.location_id = b.value
  and a.receive_time between from_date and to_date
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*(select if(value > 0, value, 4) value
                                                                            from node_properties n
                                                                            where node_id = v_parent_router
                                                                            and property = 'beaconInterval'
                                                                            and exists
                                                                            (select * from node_properties
                                                                            where node_id = n.node_id
                                                                            and property = 'beaconInterval')
                                                                            union
                                                                            select 4 value from node_properties n
                                                                            where not exists
                                                                            (select * from node_properties
                                                                            where node_id = v_parent_router
                                                                            and property = 'beaconInterval')))
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                      SET @sql = CONCAT('insert into ',table_name,' (tag, location, entry_time, exit_time, duration) values (\'',node,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                                      PREPARE stmt FROM @sql;
                                                      EXECUTE stmt;
                                                  end if;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                      SET @sql = CONCAT('insert into ',table_name,' (tag, location, entry_time, exit_time, duration) values (\'',node,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                      PREPARE stmt FROM @sql;
                                      EXECUTE stmt;
                                end if;
                                set v_loc_temp = v_loc;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                    SET @sql = CONCAT('insert into ',table_name,' (tag, location, entry_time, exit_time, duration) values (\'',node,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
              end if;
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_tag_wise_report_hist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_tag_wise_report_hist`(
allocated_to_name varchar(50),
from_date timestamp,
to_date timestamp,
table_name varchar(100)
)
begin
  DECLARE done INT DEFAULT 0;
  DECLARE v_parent_router VARCHAR(10);
  DECLARE v_loc VARCHAR(50);
  DECLARE v_rec_time timestamp;
  DECLARE v_entry_time TIMESTAMP;
  DECLARE v_exit_time TIMESTAMP;
  DECLARE v_is_started INT DEFAULT 0;
  DECLARE v_loc_temp VARCHAR(50);
  DECLARE v_allocated_to varchar(50);
  DECLARE v_allocated_to_temp varchar(50);
  DECLARE v_commit_count int DEFAULT 0;
  DECLARE v_count int;
  DECLARE v_node_id varchar(10);
  DECLARE v_node_id_temp varchar(10);
  DECLARE cur1 CURSOR FOR
                          select c.location_desc,a.parent_node_id,a.node_id,a.allocated_to, a.receive_time
                          from node_txn_history a, node_properties b, location_master c
                          where a.parent_node_id <> a.node_id
                          and a.parent_node_id = b.node_id
                          and a.allocated_to = allocated_to_name
                          and b.property = 'locationId'
                          and c.location_id = b.value
                          and a.receive_time between from_date and to_date
                          order by  c.location_id,a.receive_time;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  select count(*) into v_count
  from node_txn_history a, node_properties b, location_master c
  where a.parent_node_id <> a.node_id
  and a.parent_node_id = b.node_id
  and a.allocated_to = allocated_to_name
  and b.property = 'locationId'
  and c.location_id = b.value
  and a.receive_time between from_date and to_date
  order by  c.location_id,a.receive_time;
if(v_count > 0) then
  OPEN cur1;
    REPEAT
          IF NOT done THEN
              set v_commit_count = v_commit_count + 1;
              if(v_commit_count = 101)
              then
              commit;
              set v_commit_count = 0;
              end if;
              FETCH cur1 INTO v_loc, v_parent_router,v_node_id,v_allocated_to, v_rec_time;
              if(v_is_started = 0)
              then
                  set v_loc_temp = v_loc;
                  set v_node_id_temp = v_node_id;
                  set v_entry_time = v_rec_time;
                  set v_exit_time = v_rec_time;
                  set v_is_started = 1;
              else
                          if (v_loc_temp = v_loc && v_node_id_temp = v_node_id) then
                                        if(timestampdiff(second, v_exit_time, v_rec_time) <= 2*  (select if(value > 0, value, 4) value
                                                                                                  from node_properties n
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'
                                                                                                  and exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = n.node_id
                                                                                                  and property = 'beaconInterval')
                                                                                                  union
                                                                                                  select 4 value from node_properties n
                                                                                                  where not exists
                                                                                                  (select * from node_properties
                                                                                                  where node_id = v_parent_router
                                                                                                  and property = 'beaconInterval'))   )
                                        then
                                        set v_exit_time = v_rec_time;
                                        else
                                                  if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                                      PREPARE stmt FROM @sql;
                                                      EXECUTE stmt;
                                                  end if;
                                                  set v_entry_time = v_rec_time;
                                                  set v_exit_time = v_rec_time;
                                                  set v_is_started = 1;
                                        end if;
                            else
                                if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                                      SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id_temp,'\',\'',allocated_to_name,'\' ,\'',v_loc_temp,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                                      PREPARE stmt FROM @sql;
                                      EXECUTE stmt;
                                end if;
                                set v_loc_temp = v_loc;
                                set v_node_id_temp = v_node_id;
                                set v_entry_time = v_rec_time;
                                set v_exit_time = v_rec_time;
                                set v_is_started = 1;
                            end if;
              end if;
          END IF;
  UNTIL done END REPEAT;
  CLOSE cur1;
              if(timestampdiff(second, v_entry_time, v_exit_time) > 0) then
                    SET @sql = CONCAT('insert into ',table_name,' (tag,allocated_to, location, entry_time, exit_time, duration) values (\'',v_node_id,'\',\'',allocated_to_name,'\' ,\'',v_loc,'\' ,\'',v_entry_time,'\' ,\'',v_exit_time,'\' ,SEC_TO_TIME(timestampdiff(second,\'',v_entry_time,'\' ,\'',v_exit_time,'\')))');
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
              end if;
              commit;
end if;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_updt_delivery_log_fail`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_updt_delivery_log_fail`()
begin
update delivery_log set delivery_status = 'FAILED', notification_time = now()
where
node_id
in
(select node_id from node_master)
and
delivery_status = 'WRITTEN_TO_PORT'
and TIMESTAMPDIFF(SECOND, notification_time, now())
>=
(select IF(cast(value as signed) > 0, cast(value as signed), 5) resTimeout
from node_properties
where node_id = 'GATEWAY'
and property = 'resTimeout'
and exists
(select * from node_properties where node_id = 'GATEWAY'
and property = 'resTimeout'
and value is not null
and value <> '')
union
select 5 resTimeout
from node_properties
where not exists
(select * from node_properties where node_id = 'GATEWAY'
and property = 'resTimeout')
union
select 5 resTimeout
from node_properties
where exists
(select * from node_properties where node_id = 'GATEWAY'
and property = 'resTimeout'
and (value is null
or value = '')))
or
delivery_status = 'RECEIVED_BY_COORDINATOR'
and TIMESTAMPDIFF(SECOND, notification_time, now())
>=
(select IF(cast(value as signed) > 0, cast(value as signed), 5) resTimeout
from node_properties
where node_id = delivery_log.node_id
and property = 'resTimeout'
and exists
(select * from node_properties where node_id = delivery_log.node_id
and property = 'resTimeout'
and value is not null
and value <> '')
union
select 5 resTimeout
from node_properties
where not exists
(select * from node_properties where node_id = delivery_log.node_id
and property = 'resTimeout')
union
select 5 resTimeout
from node_properties
where exists
(select * from node_properties where node_id = delivery_log.node_id
and property = 'resTimeout'
and (value is null
or value = '')))
or
node_id
not in
(select node_id from node_master)
and
delivery_status = 'WRITTEN_TO_PORT'
and TIMESTAMPDIFF(SECOND, notification_time, now())
>=
(select IF(cast(value as signed) > 0, cast(value as signed), 30) resTimeout
from system_properties
where property = 'OTAPResTimeout'
and exists
(select * from system_properties where property = 'OTAPResTimeout'
and value is not null
and value <> '')
union
select 30 value
from system_properties
where not exists
(select * from system_properties where property = 'OTAPResTimeout')
union
select 30 value
from system_properties
where exists
(select * from system_properties where property = 'OTAPResTimeout'
and (value is null
or value = '')))
;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_updt_delivery_log_proc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_updt_delivery_log_proc`(node varchar(10),queue_id integer,deliv_status varchar(45))
begin
if (deliv_status = 'RECEIVED_BY_COORDINATOR') then
update delivery_log
set delivery_status = deliv_status, notification_time = now()
where
node_id = node
and message_queue_id = queue_id
and delivery_status = 'WRITTEN_TO_PORT'
and TIMESTAMPDIFF(SECOND, notification_time, now())
<
(select IF(cast(value as signed) > 0, cast(value as signed), 5) resTimeout
from node_properties
where node_id = 'GATEWAY'
and property = 'resTimeout'
and exists
(select * from node_properties where node_id = 'GATEWAY'
and property = 'resTimeout'
and value is not null
and value <> '')
union
select 5 resTimeout
from node_properties
where not exists
(select * from node_properties where node_id = 'GATEWAY'
and property = 'resTimeout')
union
select 5 resTimeout
from node_properties
where exists
(select * from node_properties where node_id = 'GATEWAY'
and property = 'resTimeout'
and (value is null
or value = '')));
elseif (deliv_status = 'RECEIVED_BY_END_DEVICE') then
update delivery_log set delivery_status = deliv_status, notification_time = now()
where
node_id = node
and message_queue_id = queue_id
and delivery_status = 'RECEIVED_BY_COORDINATOR'
or  delivery_status = 'WRITTEN_TO_PORT'
and TIMESTAMPDIFF(SECOND, notification_time, now())
<
(select IF(cast(value as signed) > 0, cast(value as signed), 5) resTimeout
from node_properties
where node_id = delivery_log.node_id
and property = 'resTimeout'
and exists
(select * from node_properties where node_id = delivery_log.node_id
and property = 'resTimeout'
and value is not null
and value <> '')
union
select 5 resTimeout
from node_properties
where not exists
(select * from node_properties where node_id = delivery_log.node_id
and property = 'resTimeout')
union
select 5 resTimeout
from node_properties
where exists
(select * from node_properties where node_id = delivery_log.node_id
and property = 'resTimeout'
and (value is null
or value = '')));
end if;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_updt_delivery_log_push`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_updt_delivery_log_push`(node varchar(10),queue_id integer,cmd varchar(10),deliv_status varchar(45),addr varchar(45))
begin
declare v_count int default 0;
select count(*) into v_count from delivery_log where node_id = node and message_queue_id = queue_id;
if v_count = 0 then
insert into delivery_log values (node, queue_id, cmd, deliv_status, now(), addr);
else
update delivery_log set message_id = cmd, delivery_status = deliv_status, notification_time = now(), client_address = addr where node_id = node and message_queue_id = queue_id;
end if;
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_updt_node_status`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_updt_node_status`()
begin
update node_txn set is_node_active = 'N'
where TIMESTAMPDIFF(SECOND, receive_time, now())
>=
(select IF(cast(value as signed) > 0, cast(value as signed), 30) beaconTimeout
from node_properties
where node_id = node_txn.node_id
and property = 'beaconTimeout'
and exists
(select * from node_properties
where node_id = node_txn.node_id
and property = 'beaconTimeout'
and value is not null
and value <> '')
union
select 30 beaconTimeout
from node_properties
where not exists
(select * from node_properties
where node_id = node_txn.node_id
and property = 'beaconTimeout')
union
select 30 beaconTimeout
from node_properties
where exists
(select * from node_properties
where node_id = node_txn.node_id
and property = 'beaconTimeout'
and (value is null
or value = '')));
commit;
update otap_config
set
is_sent = 'Y'
where
exists
(select * from delivery_log
where
notification_time =
(select max(notification_time)
from delivery_log
where
node_id = otap_config.node_id
and
message_id = otap_config.message_id)
and
delivery_status = 'FAILED')
and not exists
(select * from pending_messages
where
node_id = otap_config.node_id
and
message_id = otap_config.message_id);
delete from delivery_log
where
message_id = '-2'
and
delivery_status = 'FAILED';
delete from otap_config
where
is_sent = 'Y';
commit;
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_updt_on_config`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_updt_on_config`(
device varchar (10),
prop varchar (10))
begin  
declare v_msg_id varchar (10);  
declare v_status varchar (45);  
declare v_val varchar (10);
declare v_count int default 0;
   if prop = 'N' then
      set v_msg_id := '-2';
   elseif prop = 'B' then
      set v_msg_id := '6';
   end if;
   select delivery_status
   into v_status
   from delivery_log
   where
   notification_time =
   (select max(notification_time)
   from delivery_log
   where
   node_id = device
   and
   message_id = v_msg_id)
   and
   delivery_status = 'RECEIVED_BY_END_DEVICE';
   if v_status = 'RECEIVED_BY_END_DEVICE' then
      select message_value
      into v_val     
      from otap_config
      where node_id = device;
      if v_msg_id = '-2' and prop = 'N' then
         insert into node_master
         values (device, 'R');     
      elseif v_msg_id = '6' and prop = 'B' then        
         select count(*)
         into v_count 
         from node_properties 
         where node_id = device        
         and property = 'beaconInterval'; 
         if v_count = 1 then
            update node_properties        
            set value = v_val        
            where node_id = device        
            and property = 'beaconInterval';     
         elseif v_count = 0 then 
            insert into node_properties        
            values (device, 'beaconInterval', v_val);     
         end if;
      end if;  
   end if;  
end $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `wvs`.`usp_write_msg_info`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE  `wvs`.`usp_write_msg_info`(
tag_name varchar(10),
message_desc varchar(50),
client_id varchar(50)
)
begin
DECLARE msg_id INT;
select action_type_id into msg_id from action_type_master where action_type_desc = message_desc;
insert into pending_messages (node_id, message_id, client_address)
values
(tag_name,msg_id ,client_id);
commit;
end $$

DELIMITER ;

