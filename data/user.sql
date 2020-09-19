CREATE TABLE IF NOT EXISTS `user` (
    `id`        BINARY(16)      PRIMARY KEY,
    `username`  VARCHAR(254)    NOT NULL UNIQUE,
    `password`  BINARY(60),
    `memberId`  BINARY(16)      NOT NULL UNIQUE,
    `verified`  TINYINT(1), -- 0 when they first create the account, 1 once they verify the email address

    `created`   DATETIME,
    `modified`  DATETIME,

    FOREIGN KEY(`memberId`) REFERENCES `member`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertUserTrigger`;
DELIMITER $$
CREATE TRIGGER `insertUserTrigger` BEFORE INSERT ON `user`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateUserTrigger`;
DELIMITER $$
CREATE TRIGGER `updateUserTrigger` BEFORE UPDATE ON `user`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;