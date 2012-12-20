CREATE TABLE users (
       id            INTEGER PRIMARY KEY AUTOINCREMENT,
       username      TEXT NOT NULL,
       password      TEXT NOT NULL,
       first_name    TEXT,
       last_name     TEXT NOT NULL,
       active        INTEGER
);

CREATE TABLE roles (
       id   INTEGER PRIMARY KEY AUTOINCREMENT,
       role TEXT NOT NULL
);

CREATE TABLE user_roles (
       user_id INTEGER NOT NULL,
       role_id INTEGER NOT NULL,
       PRIMARY KEY (user_id, role_id)
);

CREATE TABLE user_settings (
       user_id INTEGER PRIMARY KEY, -- Elke user kan maar één keer settings hebben
       default_transaction_type INTEGER,
       default_target_account INTEGER,
       default_source_account INTEGER
);

CREATE TABLE transaction_types (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       description TEXT NOT NULL
);

CREATE TABLE transaction_attributes (
       id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
       description TEXT NOT NULL
);

CREATE TABLE accounts (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       description TEXT NOT NULL
);

CREATE TABLE transactions (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       transaction_type_id INTEGER NOT NULL,
       account_id INTEGER NOT NULL, -- De rekening waarvoor deze transactie is
       user_id INTEGER NOT NULL, -- user die de transactie ingegeven heeft
       description TEXT NOT NULL,
       dat_entry DATETIME NOT NULL,
       dat_valid DATE NOT NULL,
       cancelled INTEGER
);

CREATE TABLE transaction_details (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       transaction_id INTEGER NOT NULL,
       account_id INTEGER NOT NULL, -- De account waarvan dit  deel van de transactie betaald werd
       amount FLOAT NOT NULL
);
CREATE UNIQUE INDEX itransaction_details ON transaction_details (
       transaction_id,
       account_id
); -- elke account kan maximum één deel van een transactie betalen

CREATE TABLE transactions_transaction_attributes (
       transaction_id INTEGER NOT NULL,
       transaction_attribute_id INTEGER NOT NULL,
       PRIMARY KEY(transaction_id, transaction_attribute_id)
);

