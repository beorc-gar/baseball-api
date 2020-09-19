CREATE TABLE IF NOT EXISTS `notification` (
    `id`                BINARY(16) PRIMARY KEY,
    `templateId`        BINARY(16) NOT NULL,
    `leagueMemberId`    BINARY(16) NOT NULL,
    `referenceId`       BINARY(16), -- used to link to injury, invitation, etc.
    `reference`         VARCHAR(128), -- describe what the referenceId is referring to

    `created`           DATETIME,
    `modified`          DATETIME,

    UNIQUE (`templateId`, `leagueMemberId`, `referenceId`),
    
    FOREIGN KEY(`templateId`)       REFERENCES `notificationTemplate`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`leagueMemberId`)   REFERENCES `leagueMember`(`id`)         ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertNotificationTrigger`;
DELIMITER $$
CREATE TRIGGER `insertNotificationTrigger` BEFORE INSERT ON `notification`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateNotificationTrigger`;
DELIMITER $$
CREATE TRIGGER `updateNotificationTrigger` BEFORE UPDATE ON `notification`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;