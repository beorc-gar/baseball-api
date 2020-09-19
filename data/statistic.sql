CREATE TABLE IF NOT EXISTS `statistic` (
    `id`                    BINARY(16) PRIMARY KEY,
    `playerId`              BINARY(16) NOT NULL,
    `rank`                  INT(11), -- this and below are from fantasybaseballnerd.com
    `averageRank`           REAL(3,3),
    `atBats`                INT(11),
    `runs`                  INT(11),
    `homeRuns`              INT(11),
    `runsBattedIn`          INT(11),
    `stolenBases`           INT(11),
    `battingAverage`        REAL(3,3),
    `onBasePlusSlugging`    REAL(3,3),
    `singles`               INT(11),
    `doubles`               INT(11),
    `triples`               INT(11),

    `created`               DATETIME,
    `modified`              DATETIME,

    FOREIGN KEY(`playerId`) REFERENCES `player`(`id`) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `insertStatisticTrigger`;
DELIMITER $$
CREATE TRIGGER `insertStatisticTrigger` BEFORE INSERT ON `statistic`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = IFNULL(NEW.`created`, NOW());
    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `updateStatisticTrigger`;
DELIMITER $$
CREATE TRIGGER `updateStatisticTrigger` BEFORE UPDATE ON `statistic`
FOR EACH ROW
    BEGIN
        SET NEW.`created` = OLD.`created`;
        SET NEW.`modified` = NOW();
    END$$
DELIMITER ;