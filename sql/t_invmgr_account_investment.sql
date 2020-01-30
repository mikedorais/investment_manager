-- This table indicates all commodities that are to be considered
-- as an investment for each investment account, assigned to a
-- particular asset_class for purposes of asset allocatoin with the account.
-- DROP TABLE invmgr_account_investment
CREATE TABLE `invmgr_account_investment` (
	`master_account_guid`	TEXT,
	`master_account_code`	TEXT,
	`sort_key`	TEXT,
	`master_account_name`	TEXT,
	`commodity_guid`	TEXT,
	`namespace`	TEXT,
	`mnemonic`	TEXT,
	`commodity_name`	TEXT,
	`asset_class`	TEXT
);