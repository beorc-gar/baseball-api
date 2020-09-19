CREATE TABLE IF NOT EXISTS `injury` (
    `id`        BINARY(16)      PRIMARY KEY,
    `playerId`  BINARY(16)      NOT NULL,
    `reason`    VARCHAR(1024), -- this and below are from fantasybaseballnerd.com
    `notes`     VARCHAR(2048),

    `created` DATETIME,
    `modified` DATETIME,

    FOREIGN KEY(`playerId`) REFERENCES `player`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertInjuryTrigger`;
DELIMITER $$
CREATE TRIGGER `insertInjuryTrigger` BEFORE INSERT ON `injury`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateInjuryTrigger`;
DELIMITER $$
CREATE TRIGGER `updateInjuryTrigger` BEFORE UPDATE ON `injury`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;