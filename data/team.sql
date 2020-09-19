CREATE TABLE IF NOT EXISTS `team` (
    `id`                BINARY(16)  PRIMARY KEY,
    `name`              VARCHAR(64) NOT NULL,
    `leagueMemberId`    BINARY(16)  NOT NULL,

    `created`           DATETIME,
    `modified`          DATETIME,

    FOREIGN KEY(`leagueMemberId`) REFERENCES `leagueMember`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertTeamTrigger`;
DELIMITER $$
CREATE TRIGGER `insertTeamTrigger` BEFORE INSERT ON `team`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateTeamTrigger`;
DELIMITER $$
CREATE TRIGGER `updateTeamTrigger` BEFORE UPDATE ON `team`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;