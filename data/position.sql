CREATE TABLE IF NOT EXISTS `position` (
    `id`    BINARY(16)  PRIMARY KEY,
    `code`  VARCHAR(2)  UNIQUE,
    `name`  VARCHAR(64) NOT NULL UNIQUE
);

INSERT IGNORE INTO `position` (`id`, `code`, `name`) VALUES
(UUID_TO_BIN(UUID()), 'DH', 'designated hitter'),
(UUID_TO_BIN(UUID()), 'C',  'catcher'),
(UUID_TO_BIN(UUID()), 'P',  'pitcher'),
(UUID_TO_BIN(UUID()), 'RP', 'relief pitcher'),
(UUID_TO_BIN(UUID()), 'SP', 'starting pitcher'),
(UUID_TO_BIN(UUID()), 'IF', 'in field'),
(UUID_TO_BIN(UUID()), '1B', 'first base'),
(UUID_TO_BIN(UUID()), '2B', 'second base'),
(UUID_TO_BIN(UUID()), 'SS', 'short stop'),
(UUID_TO_BIN(UUID()), '3B', 'third base'),
(UUID_TO_BIN(UUID()), 'OF', 'out field'),
(UUID_TO_BIN(UUID()), 'LF', 'left field'),
(UUID_TO_BIN(UUID()), 'RF', 'right field'),
(UUID_TO_BIN(UUID()), 'CF', 'center field');