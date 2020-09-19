CREATE TABLE IF NOT EXISTS `leagueMember` (
    `id`        BINARY(16)      PRIMARY KEY,
    `leagueId`  BINARY(16)      NOT NULL,
    `memberId`  BINARY(16)      NOT NULL,
    `nickName`  VARCHAR(64),
    `roleId`    BINARY(16)      NOT NULL,

    `created`   DATETIME,
    `modified`  DATETIME,

    UNIQUE (`leagueId`, `memberId`),

    FOREIGN KEY(`leagueId`) REFERENCES `league`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`memberId`) REFERENCES `member`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`roleId`)   REFERENCES `role`(`id`)
);

DROP TRIGGER IF EXISTS `insertLeagueMemberTrigger`;
DELIMITER $$
CREATE TRIGGER `insertLeagueMemberTrigger` BEFORE INSERT ON `leagueMember`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateLeagueMemberTrigger`;
DELIMITER $$
CREATE TRIGGER `updateLeagueMemberTrigger` BEFORE UPDATE ON `leagueMember`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;