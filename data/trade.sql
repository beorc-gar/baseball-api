CREATE TABLE IF NOT EXISTS `trade` (
    `id`                BINARY(16) PRIMARY KEY,
    `teamId`            BINARY(16) NOT NULL,
    `oldPlayerId`       BINARY(16) NOT NULL,
    `newPlayerId`       BINARY(16) NOT NULL,

    `created` DATETIME,
    `modified` DATETIME,

    FOREIGN KEY(`teamId`)        REFERENCES `team`(`id`)   ON DELETE CASCADE,
    FOREIGN KEY(`oldPlayerId`)   REFERENCES `player`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`newPlayerId`)   REFERENCES `player`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertTradeTrigger`;
DELIMITER $$
CREATE TRIGGER `insertTradeTrigger` BEFORE INSERT ON `trade`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateTradeTrigger`;
DELIMITER $$
CREATE TRIGGER `updateTradeTrigger` BEFORE UPDATE ON `trade`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;