CREATE TABLE IF NOT EXISTS `invitation` (
    `id`        BINARY(16)  PRIMARY KEY,
    `leagueId`  BINARY(16)  NOT NULL,
    `memberId`  BINARY(16)  NOT NULL,
    `isRequest` BOOLEAN     NOT NULL, -- true if member asked to join league, false if league invited member.

    `created`   DATETIME,
    `modified`  DATETIME,

    UNIQUE (`leagueId`, `memberId`),
    
    FOREIGN KEY(`leagueId`) REFERENCES `league`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`memberId`) REFERENCES `member`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertInvitationTrigger`;
DELIMITER $$
CREATE TRIGGER `insertInvitationTrigger` BEFORE INSERT ON `invitation`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateInvitationTrigger`;
DELIMITER $$
CREATE TRIGGER `updateInvitationTrigger` BEFORE UPDATE ON `invitation`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;