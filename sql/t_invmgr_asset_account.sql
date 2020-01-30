-- DROP TABLE invmgr_asset_account
CREATE TABLE invmgr_asset_account (
    guid text(32) PRIMARY KEY NOT NULL, 
	name text(2048) NOT NULL,  -- redundant
	account_type text(2048) NOT NULL, -- redundant
	code text(2048), -- redundant
	description text(2048), -- redundant
	commodity_guid text(32), -- redundant
	cmdty_namespace text(2048), -- redundant
	cmdty_mnemonic text(2048), -- redundant
    master_parent_guid text(32) -- Actual Brokerage Account Where Invesement is managed
    )