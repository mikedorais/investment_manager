

-- This insert statement can be run at any time for initial population
-- and to insert any missing rows due to added investment accounts
-- It defaults file_base_name to the account code.
-- This assumes that investment accounts in the account hierarchy will always be
-- directly under a parent named 'Investments' or 'Retirement Accounts'
INSERT INTO invmgr_investment_account 
    (guid, name, file_base_name)
	SELECT ia.guid, ia.name, ia.code
		FROM accounts ia
			INNER JOIN accounts iap ON (iap.name = 'Investments' OR iap.name = 'Retirement Accounts') AND iap.guid = ia.parent_guid
		WHERE ia.account_type = 'BANK'
			  AND ia.guid NOT IN (SELECT guid FROM invmgr_investment_account)
			  
-- TODO: UPDATE statement to update name for guid in case it changes.

SELECT * FROM invmgr_investment_account

-- Re run all below, except CREATE TABLE invmgr_asset_account, if:
-- 1) a new investment account was added
-- or
-- 2) any new asset accounts were added to any investment accounts

-- DROP TABLE temp.invmgr_asset_account_src
CREATE TABLE temp.invmgr_asset_account_src AS
	SELECT a.guid, a.name, a.account_type, a.code, a.description, a.placeholder, commodity_guid, c.namespace, c.mnemonic, a.guid as master_parent_guid
		FROM invmgr_investment_account ia
			INNER JOIN accounts a on a.guid = ia.guid
		LEFT OUTER JOIN commodities c on c.guid = a.commodity_guid
		
SELECT * FROM temp.invmgr_asset_account_src


-- Execute repeatedly until no rows are inserted (affected)
INSERT INTO temp.invmgr_asset_account_src
	(guid, name, account_type, code, description, placeholder, commodity_guid, namespace, mnemonic, master_parent_guid)
SELECT a.guid, a.name, a.account_type, a.code, a.description, a.placeholder, a.commodity_guid, c.namespace, c.mnemonic, pa.master_parent_guid
	FROM accounts a
		INNER JOIN temp.invmgr_asset_account_src pa on a.parent_guid = pa.guid
		LEFT OUTER JOIN commodities c on c.guid = a.commodity_guid
	WHERE a.guid NOT IN (SELECT guid FROM invmgr_asset_account_src)

SELECT * 
	FROM temp.invmgr_asset_account_src
	WHERE placeholder = 0
	
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
	
INSERT INTO invmgr_asset_account
	(guid, 
	name,
	account_type,
	code,
	description,
	commodity_guid,
	cmdty_namespace,
	cmdty_mnemonic,
    master_parent_guid )
	SELECT guid, 
	name,
	account_type,
	code,
	description,
	commodity_guid,
	namespace,
	mnemonic,
    master_parent_guid
	FROM temp.invmgr_asset_account_src
	WHERE placeholder = 0
		AND guid NOT IN (SELECT guid FROM invmgr_asset_account)
		
-- TODO: UPDATE statement to update name for guid in case it changes.		
	
	
SELECT ia.name, a.*
	FROM invmgr_asset_account a
		LEFT OUTER JOIN accounts ia on ia.guid = a.master_parent_guid
	ORDER BY ia.name, a.account_type, a.name