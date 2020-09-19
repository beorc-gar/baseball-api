CREATE TABLE IF NOT EXISTS `league` (
    `id`        BINARY(16) PRIMARY KEY,
    `name`      VARCHAR(64) NOT NULL UNIQUE,
    `public`    BOOLEAN NOT NULL,

    `created`   DATETIME,
    `modified`  DATETIME
);

DROP TRIGGER IF EXISTS `insertLeagueTrigger`;
DELIMITER $$
CREATE TRIGGER `insertLeagueTrigger` BEFORE INSERT ON `league`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateLeagueTrigger`;
DELIMITER $$
CREATE TRIGGER `updateLeagueTrigger` BEFORE UPDATE ON `league`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;