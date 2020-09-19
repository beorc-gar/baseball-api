CREATE TABLE IF NOT EXISTS `draft` (
    `id`        BINARY(16) PRIMARY KEY,
    `leagueId`  BINARY(16) NOT NULL,
    `turn`      BINARY(16) NOT NULL, -- this is the leagueMemberId of whose turn it is. not foreign key so if the member is removed, we can go: this person doesn't exist, so it's the next member after.

    `created`   DATETIME,
    `modified`  DATETIME,

    FOREIGN KEY(`leagueId`) REFERENCES `league`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertDraftTrigger`;
DELIMITER $$
CREATE TRIGGER `insertDraftTrigger` BEFORE INSERT ON `draft`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateDraftTrigger`;
DELIMITER $$
CREATE TRIGGER `updateDraftTrigger` BEFORE UPDATE ON `draft`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;