CREATE TABLE IF NOT EXISTS `ssoType` (
    `id`        BINARY(16)      PRIMARY KEY,
    `source`    VARCHAR(32)     UNIQUE
);

INSERT IGNORE INTO `ssoType` (`id`, `source`) VALUES
(UUID_TO_BIN(UUID()), 'Google'), 
(UUID_TO_BIN(UUID()), 'Facebook');