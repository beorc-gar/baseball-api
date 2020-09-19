CREATE TABLE IF NOT EXISTS `teamPlayer` (
    `id`        BINARY(16) PRIMARY KEY,
    `teamId`    BINARY(16) NOT NULL,
    `playerId`  BINARY(16) NOT NULL,

    `created`   DATETIME,
    `modified`  DATETIME,

    UNIQUE (`teamId`, `playerId`),
    FOREIGN KEY(`teamId`)   REFERENCES `team`(`id`)     ON DELETE CASCADE,
    FOREIGN KEY(`playerId`) REFERENCES `player`(`id`)   ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertTeamPlayerTrigger`;
DELIMITER $$
CREATE TRIGGER `insertTeamPlayerTrigger` BEFORE INSERT ON `teamPlayer`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateTeamPlayerTrigger`;
DELIMITER $$
CREATE TRIGGER `updateTeamPlayerTrigger` BEFORE UPDATE ON `teamPlayer`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;