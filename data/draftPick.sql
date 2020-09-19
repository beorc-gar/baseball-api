CREATE TABLE IF NOT EXISTS `draftPick` (
    `id`                BINARY(16) PRIMARY KEY,
    `draftId`           BINARY(16) NOT NULL,
    `leagueMemberId`    BINARY(16) NOT NULL,
    `order`             INT(11)    NOT NULL,

    `created` DATETIME,
    `modified` DATETIME,

    UNIQUE (`draftId`, `leagueMemberId`),
    UNIQUE (`leagueMemberId`, `order`),

    FOREIGN KEY(`draftId`)          REFERENCES `draft`(`id`)        ON DELETE CASCADE,
    FOREIGN KEY(`leagueMemberId`)   REFERENCES `leagueMember`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertDraftPickTrigger`;
DELIMITER $$
CREATE TRIGGER `insertDraftPickTrigger` BEFORE INSERT ON `draftPick`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateDraftPickTrigger`;
DELIMITER $$
CREATE TRIGGER `updateDraftPickTrigger` BEFORE UPDATE ON `draftPick`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;