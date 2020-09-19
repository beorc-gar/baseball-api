CREATE TABLE IF NOT EXISTS `player` (
    `id`            BINARY(16)  PRIMARY KEY,
    `sourceId`      INT(11)     UNIQUE,         -- player's id on fantasybaseballnerd.com
    `name`          VARCHAR(64) NOT NULL,       -- this and below is data from fantasybaseballnerd.com
    `positionId`    BINARY(16)  NOT NULL,
    `team`          VARCHAR(3),
    `bats`          VARCHAR(1),
    `throws`        VARCHAR(1),
    `height`        VARCHAR(5),
    `weight`        INT(3),
    `jersey`        INT(2),
    `birthDate`     DATE,

    `active`        BOOLEAN, -- when the player isn't returned by api anymore, set to true

    `created`       DATETIME,
    `modified`      DATETIME,

    FOREIGN KEY(`positionId`) REFERENCES `position`(`id`)
);

DROP TRIGGER IF EXISTS `insertPlayerTrigger`;
DELIMITER $$
CREATE TRIGGER `insertPlayerTrigger` BEFORE INSERT ON `player`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updatePlayerTrigger`;
DELIMITER $$
CREATE TRIGGER `updatePlayerTrigger` BEFORE UPDATE ON `player`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;