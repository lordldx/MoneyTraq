-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Thu Dec 27 13:35:22 2012
-- 

;
BEGIN TRANSACTION;
--
-- Table: accounts
--
CREATE TABLE accounts (
  id INTEGER PRIMARY KEY NOT NULL,
  description TEXT NOT NULL
);
--
-- Table: roles
--
CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  role TEXT NOT NULL
);
--
-- Table: transaction_attributes
--
CREATE TABLE transaction_attributes (
  id INTEGER PRIMARY KEY NOT NULL,
  description TEXT NOT NULL
);
--
-- Table: transaction_types
--
CREATE TABLE transaction_types (
  id INTEGER PRIMARY KEY NOT NULL,
  description TEXT NOT NULL
);
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  active INTEGER NOT NULL
);
--
-- Table: user_roles
--
CREATE TABLE user_roles (
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX user_roles_idx_role_id ON user_roles (role_id);
CREATE INDEX user_roles_idx_user_id ON user_roles (user_id);
--
-- Table: transactions
--
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY NOT NULL,
  transaction_type_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  description TEXT NOT NULL,
  dat_entry DATETIME NOT NULL,
  dat_valid DATE NOT NULL,
  cancelled INTEGER NOT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (transaction_type_id) REFERENCES transaction_types(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX transactions_idx_account_id ON transactions (account_id);
CREATE INDEX transactions_idx_user_id ON transactions (user_id);
CREATE INDEX transactions_idx_transaction_type_id ON transactions (transaction_type_id);
--
-- Table: user_settings
--
CREATE TABLE user_settings (
  user_id INTEGER PRIMARY KEY NOT NULL,
  default_transaction_type INTEGER NOT NULL,
  default_target_account INTEGER NOT NULL,
  default_source_account INTEGER NOT NULL,
  FOREIGN KEY (default_source_account) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (default_target_account) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (default_transaction_type) REFERENCES transaction_types(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX user_settings_idx_default_source_account ON user_settings (default_source_account);
CREATE INDEX user_settings_idx_default_target_account ON user_settings (default_target_account);
CREATE INDEX user_settings_idx_default_transaction_type ON user_settings (default_transaction_type);
--
-- Table: transaction_details
--
CREATE TABLE transaction_details (
  id INTEGER PRIMARY KEY NOT NULL,
  transaction_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  amount FLOAT NOT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX transaction_details_idx_account_id ON transaction_details (account_id);
CREATE INDEX transaction_details_idx_transaction_id ON transaction_details (transaction_id);
--
-- Table: transactions_transaction_attributes
--
CREATE TABLE transactions_transaction_attributes (
  transaction_id INTEGER NOT NULL,
  transaction_attribute_id INTEGER NOT NULL,
  PRIMARY KEY (transaction_id, transaction_attribute_id),
  FOREIGN KEY (transaction_attribute_id) REFERENCES transaction_attributes(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX transactions_transaction_attributes_idx_transaction_attribute_id ON transactions_transaction_attributes (transaction_attribute_id);
CREATE INDEX transactions_transaction_attributes_idx_transaction_id ON transactions_transaction_attributes (transaction_id);
COMMIT