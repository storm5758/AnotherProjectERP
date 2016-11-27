﻿-- Script date 27.11.2016 17:33:49
-- Server version: 5.5.5-10.1.17-MariaDB
-- Client version: 4.1
--


--
-- Disable foreign keys
--
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

--
-- Set SQL mode
--
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

--
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

--
-- Set default database
--
USE erp_db;

--
-- Definition for table tbl_group_roles
--
DROP TABLE IF EXISTS tbl_group_roles;
CREATE TABLE tbl_group_roles (
  col_grID INT(11) NOT NULL AUTO_INCREMENT,
  col_gID INT(11) DEFAULT NULL,
  col_roleID INT(11) DEFAULT NULL,
  PRIMARY KEY (col_grID),
  CONSTRAINT FK_tbl_group_roles_tbl_user_groups_col_gID FOREIGN KEY (col_gID)
  REFERENCES tbl_user_groups(col_gID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_tbl_group_roles_tbl_user_roles_col_roleID FOREIGN KEY (col_roleID)
  REFERENCES tbl_user_roles(col_roleID) ON DELETE RESTRICT ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'какие роли к какой группе относятся';

--
-- Definition for table tbl_menu
--
DROP TABLE IF EXISTS tbl_menu;
CREATE TABLE tbl_menu (
  col_id INT(11) NOT NULL AUTO_INCREMENT,
  col_mtitle VARCHAR(255) DEFAULT NULL,
  col_mtype INT(11) DEFAULT NULL,
  col_link VARCHAR(255) DEFAULT NULL,
  col_modul VARCHAR(255) DEFAULT NULL,
  col_Seq INT(11) DEFAULT NULL,
  PRIMARY KEY (col_id)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

--
-- Definition for table tbl_menu_type
--
DROP TABLE IF EXISTS tbl_menu_type;
CREATE TABLE tbl_menu_type (
  col_id INT(11) NOT NULL AUTO_INCREMENT,
  col_ttitle VARCHAR(255) DEFAULT NULL,
  col_tbuild VARCHAR(255) DEFAULT NULL,
  col_seq INT(11) DEFAULT NULL,
  PRIMARY KEY (col_id)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

--
-- Definition for table tbl_module_groups
--
DROP TABLE IF EXISTS tbl_module_groups;
CREATE TABLE tbl_module_groups (
  col_mgID INT(11) NOT NULL AUTO_INCREMENT,
  col_modID INT(11) DEFAULT NULL,
  col_gID INT(11) DEFAULT NULL,
  PRIMARY KEY (col_mgID),
  CONSTRAINT FK_tbl_module_groups_col_gID FOREIGN KEY (col_gID)
  REFERENCES tbl_user_groups(col_gID) ON DELETE NO ACTION ON UPDATE RESTRICT,
  CONSTRAINT FK_tbl_module_groups_col_modID FOREIGN KEY (col_modID)
  REFERENCES tbl_modules(col_modID) ON DELETE NO ACTION ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 4
  AVG_ROW_LENGTH = 16384
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'разрешения групп к модулям';

--
-- Definition for table tbl_module_roles
--
DROP TABLE IF EXISTS tbl_module_roles;
CREATE TABLE tbl_module_roles (
  col_mrID INT(11) NOT NULL AUTO_INCREMENT,
  col_modID INT(11) DEFAULT NULL,
  col_roleID INT(11) DEFAULT NULL,
  PRIMARY KEY (col_mrID),
  CONSTRAINT FK_tbl_module_roles_tbl_modules_col_modID FOREIGN KEY (col_modID)
  REFERENCES tbl_modules(col_modID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_tbl_module_roles_tbl_user_roles_col_roleID FOREIGN KEY (col_roleID)
  REFERENCES tbl_user_roles(col_roleID) ON DELETE RESTRICT ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'указание ролей с правами доступа';

--
-- Definition for table tbl_modules
--
DROP TABLE IF EXISTS tbl_modules;
CREATE TABLE tbl_modules (
  col_modID INT(11) NOT NULL AUTO_INCREMENT,
  col_title VARCHAR(255) DEFAULT NULL COMMENT 'идентификатор названия страницы',
  col_path VARCHAR(255) DEFAULT NULL COMMENT 'местонахождения скрипта',
  col_cache INT(11) DEFAULT 0 COMMENT 'кеширование в секундах',
  col_isClass CHAR(1) DEFAULT '1' COMMENT 'mvc или обычный скрипт',
  PRIMARY KEY (col_modID)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 2
  AVG_ROW_LENGTH = 8192
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'модули системы';

--
-- Definition for table tbl_plugins
--
DROP TABLE IF EXISTS tbl_plugins;
CREATE TABLE tbl_plugins (
  col_pID INT(11) NOT NULL AUTO_INCREMENT,
  col_pluginName VARCHAR(255) DEFAULT NULL,
  col_seq INT(11) DEFAULT 0 COMMENT 'очередь загрузки',
  col_isClass CHAR(1) DEFAULT '0',
  col_pluginState CHAR(1) DEFAULT '0' COMMENT '0 - выключен 1- включен',
  col_cache INT(11) DEFAULT 0,
  PRIMARY KEY (col_pID)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

--
-- Definition for table tbl_plugins_group
--
DROP TABLE IF EXISTS tbl_plugins_group;
CREATE TABLE tbl_plugins_group (
  col_pgID INT(11) NOT NULL AUTO_INCREMENT,
  col_pID INT(11) DEFAULT NULL,
  col_gID INT(11) DEFAULT NULL,
  PRIMARY KEY (col_pgID),
  CONSTRAINT FK_tbl_plugins_group_col_gID FOREIGN KEY (col_gID)
  REFERENCES tbl_user_groups(col_gID) ON DELETE NO ACTION ON UPDATE RESTRICT,
  CONSTRAINT FK_tbl_plugins_group_col_pID FOREIGN KEY (col_pID)
  REFERENCES tbl_plugins(col_pID) ON DELETE NO ACTION ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  AVG_ROW_LENGTH = 16384
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'группы и плагины';

--
-- Definition for table tbl_plugins_roles
--
DROP TABLE IF EXISTS tbl_plugins_roles;
CREATE TABLE tbl_plugins_roles (
  col_prID INT(11) NOT NULL AUTO_INCREMENT,
  col_pID INT(11) DEFAULT NULL,
  col_roleID INT(11) DEFAULT NULL,
  PRIMARY KEY (col_prID),
  CONSTRAINT FK_tbl_plugins_role_col_pID FOREIGN KEY (col_pID)
  REFERENCES tbl_plugins(col_pID) ON DELETE NO ACTION ON UPDATE RESTRICT,
  CONSTRAINT FK_tbl_plugins_role_col_roleID FOREIGN KEY (col_roleID)
  REFERENCES tbl_user_roles(col_roleID) ON DELETE NO ACTION ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  AVG_ROW_LENGTH = 16384
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

--
-- Definition for table tbl_roles_in_group
--
DROP TABLE IF EXISTS tbl_roles_in_group;
CREATE TABLE tbl_roles_in_group (
  col_rigID INT(11) NOT NULL AUTO_INCREMENT,
  col_gID INT(11) DEFAULT NULL COMMENT 'группа',
  col_roleID INT(11) DEFAULT NULL COMMENT 'роль',
  PRIMARY KEY (col_rigID),
  CONSTRAINT FK_tbl_roles_in_group_col_gID FOREIGN KEY (col_gID)
  REFERENCES tbl_user_groups(col_gID) ON DELETE NO ACTION ON UPDATE RESTRICT,
  CONSTRAINT FK_tbl_roles_in_group_col_role FOREIGN KEY (col_roleID)
  REFERENCES tbl_user_roles(col_roleID) ON DELETE NO ACTION ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 3
  AVG_ROW_LENGTH = 16384
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'к какой группе, какая роль принадлежит';

--
-- Definition for table tbl_user
--
DROP TABLE IF EXISTS tbl_user;
CREATE TABLE tbl_user (
  col_uID INT(11) NOT NULL AUTO_INCREMENT,
  col_Name VARCHAR(100) DEFAULT NULL COMMENT 'имя',
  col_Sername VARCHAR(100) DEFAULT NULL COMMENT 'фамилия',
  col_Lastname VARCHAR(100) DEFAULT NULL COMMENT 'очество',
  col_login VARCHAR(100) DEFAULT NULL COMMENT 'логин',
  col_pwd VARCHAR(255) DEFAULT NULL COMMENT 'пароль',
  col_roleID INT(11) DEFAULT NULL COMMENT 'роль',
  col_isBaned CHAR(1) DEFAULT '0' COMMENT 'забанен ли?',
  col_deputyID INT(11) DEFAULT NULL,
  col_StartDep DATETIME DEFAULT NULL,
  col_banDate DATETIME DEFAULT NULL,
  PRIMARY KEY (col_uID),
  CONSTRAINT FK_tbl_user_col_roleID FOREIGN KEY (col_roleID)
  REFERENCES tbl_user_roles(col_roleID) ON DELETE NO ACTION ON UPDATE RESTRICT
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'пользователи';

--
-- Definition for table tbl_user_groups
--
DROP TABLE IF EXISTS tbl_user_groups;
CREATE TABLE tbl_user_groups (
  col_gID INT(11) NOT NULL AUTO_INCREMENT,
  col_gName VARCHAR(250) DEFAULT NULL,
  PRIMARY KEY (col_gID)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 5
  AVG_ROW_LENGTH = 4096
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'группы пользователей';

--
-- Definition for table tbl_user_roles
--
DROP TABLE IF EXISTS tbl_user_roles;
CREATE TABLE tbl_user_roles (
  col_roleID INT(11) NOT NULL AUTO_INCREMENT,
  col_roleName VARCHAR(250) DEFAULT NULL,
  PRIMARY KEY (col_roleID),
  UNIQUE INDEX UK_tbl_user_roles_col_roleName (col_roleName)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 7
  AVG_ROW_LENGTH = 2730
  CHARACTER SET utf8
  COLLATE utf8_general_ci
  COMMENT = 'роли для пользователя';

--
-- Definition for table tbl_users
--
DROP TABLE IF EXISTS tbl_users;
CREATE TABLE tbl_users (
  col_uID INT(11) NOT NULL AUTO_INCREMENT,
  col_Name VARCHAR(255) DEFAULT NULL COMMENT 'имя',
  col_Sername VARCHAR(255) DEFAULT NULL COMMENT 'фамилия',
  col_Lastname VARCHAR(255) DEFAULT NULL COMMENT 'очество',
  col_RegDate DATETIME DEFAULT NULL COMMENT 'дата регистрации',
  col_roleID INT(11) DEFAULT NULL COMMENT 'роль',
  col_isBlock CHAR(1) DEFAULT '0' COMMENT 'блокирован?',
  col_blockDate DATETIME DEFAULT NULL COMMENT 'когда блокирован?',
  col_deputy INT(11) DEFAULT NULL COMMENT 'id замещающего',
  col_DepStartDate DATETIME DEFAULT NULL COMMENT 'когда начато замещение',
  col_login VARCHAR(255) DEFAULT NULL,
  col_pwd VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (col_uID)
)
  ENGINE = INNODB
  AUTO_INCREMENT = 1
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

--
-- Dumping data for table tbl_group_roles
--

-- Table erp_db.tbl_group_roles does not contain any data (it is empty)

--
-- Dumping data for table tbl_menu
--

-- Table erp_db.tbl_menu does not contain any data (it is empty)

--
-- Dumping data for table tbl_menu_type
--

-- Table erp_db.tbl_menu_type does not contain any data (it is empty)

--
-- Dumping data for table tbl_module_groups
--
INSERT INTO tbl_module_groups VALUES
  (3, 1, 1);

--
-- Dumping data for table tbl_module_roles
--

-- Table erp_db.tbl_module_roles does not contain any data (it is empty)

--
-- Dumping data for table tbl_modules
--
INSERT INTO tbl_modules VALUES
  (1, 'title_2', 'adm/UnitManager', 0, '1');

--
-- Dumping data for table tbl_plugins
--

-- Table erp_db.tbl_plugins does not contain any data (it is empty)

--
-- Dumping data for table tbl_plugins_group
--

-- Table erp_db.tbl_plugins_group does not contain any data (it is empty)

--
-- Dumping data for table tbl_plugins_roles
--

-- Table erp_db.tbl_plugins_roles does not contain any data (it is empty)

--
-- Dumping data for table tbl_roles_in_group
--
INSERT INTO tbl_roles_in_group VALUES
  (2, 1, 1);

--
-- Dumping data for table tbl_user
--

-- Table erp_db.tbl_user does not contain any data (it is empty)

--
-- Dumping data for table tbl_user_groups
--
INSERT INTO tbl_user_groups VALUES
  (1, 'IT отдел'),
  (2, 'Гости'),
  (3, 'Пользователи'),
  (4, 'Все');

--
-- Dumping data for table tbl_user_roles
--
INSERT INTO tbl_user_roles VALUES
  (1, 'Администратор системы'),
  (2, 'тестовая роль 1'),
  (3, 'тестовая роль 2'),
  (4, 'тестовая роль 3'),
  (5, 'тестовая роль 4'),
  (6, 'тестовая роль 5');

--
-- Dumping data for table tbl_users
--

-- Table erp_db.tbl_users does not contain any data (it is empty)

-- 
-- Restore previous SQL mode
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Enable foreign keys
-- 
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;