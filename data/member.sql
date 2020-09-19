CREATE TABLE IF NOT EXISTS `member` (
    `id`    BINARY(16)  PRIMARY KEY,
    `name`  VARCHAR(64) NOT NULL,

    `created` DATETIME,
    `modified` DATETIME
);

DROP TRIGGER IF EXISTS `insertMemberTrigger`;
DELIMITER $$
CREATE TRIGGER `insertMemberTrigger` BEFORE INSERT ON `member`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateMemberTrigger`;
DELIMITER $$
CREATE TRIGGER `updateMemberTrigger` BEFORE UPDATE ON `member`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;