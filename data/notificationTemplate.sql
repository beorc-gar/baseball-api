CREATE TABLE IF NOT EXISTS `notificationTemplate` (
    `id`        BINARY(16)      PRIMARY KEY,
    `code`      VARCHAR(16)     UNIQUE,
    `title`     VARCHAR(256),
    `message`   VARCHAR(2048)
);

INSERT IGNORE INTO `notificationTemplate` (`id`, `code`, `title`, `message`) VALUES
(UUID_TO_BIN(UUID()), 'YOUR-TURN',       "It's your turn to pick!",                  "Why don't you go on ahead and make the next addition to your team?"),              -- referenceId will be draftPick
(UUID_TO_BIN(UUID()), 'INJURED-PLAYER',  "Your player was injured.",                 "Unfortunately, one of your players has went and gotten himself injured."),         -- referenceId will be injury
(UUID_TO_BIN(UUID()), 'INACTIVE-PLAYER', "Your player is no longer available.",      "Unfortunately, one of your players has retired, or was demoted, or something."),   -- referenceId will be player
(UUID_TO_BIN(UUID()), 'INACTIVE-PLAYER', "Your player is no longer available.",      "Unfortunately, one of your players has retired, or was demoted, or something."),   -- referenceId will be player
(UUID_TO_BIN(UUID()), 'LEAGUE-REQUEST',  "Someone wants to join your league.",       "You probably shouldn't leave them hanging."),                                      -- referenceId will be invitation
(UUID_TO_BIN(UUID()), 'LEAGUE-INVITE',   "Someone wants you to join their league.",  "You probably shouldn't leave them hanging.");                                      -- referenceId will be invitation
