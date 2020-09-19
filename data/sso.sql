CREATE TABLE IF NOT EXISTS `sso` (
    `id`        BINARY(16)  PRIMARY KEY,
    `memberId`  BINARY(16)  NOT NULL,
    `token`     VARCHAR(64) NOT NULL,
    `ssoTypeId` BINARY(16)  NOT NULL,

    `created`           DATETIME,
    `modified`          DATETIME,

    UNIQUE (`token`, `ssoTypeId`),

    FOREIGN KEY(`memberId`)  REFERENCES `member`(`id`)  ON DELETE CASCADE,
    FOREIGN KEY(`ssoTypeId`) REFERENCES `ssoType`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertSsoTrigger`;
DELIMITER $$
CREATE TRIGGER `insertSsoTrigger` BEFORE INSERT ON `sso`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateSsoTrigger`;
DELIMITER $$
CREATE TRIGGER `updateSsoTrigger` BEFORE UPDATE ON `sso`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;