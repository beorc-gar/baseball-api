CREATE TABLE IF NOT EXISTS `role` (
    `id`    BINARY(16)  PRIMARY KEY,
    `name`  VARCHAR(64) NOT NULL UNIQUE
);

INSERT IGNORE INTO `role` (`id`, `name`) VALUES
(UUID_TO_BIN(UUID()), 'owner'),
(UUID_TO_BIN(UUID()), 'admin'),
(UUID_TO_BIN(UUID()), 'advanced'), -- someone who can manage their own stuff but no one else's.
(UUID_TO_BIN(UUID()), 'member'),
(UUID_TO_BIN(UUID()), 'spectator');