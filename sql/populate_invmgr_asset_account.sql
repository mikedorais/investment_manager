-- Re run all below, except CREATE TABLE invmgr_asset_account, if:
-- 1) a new investment account was added
-- or
-- 2) any new asset accounts were added to any investment accounts

WITH RECURSIVE
invmgr_asset_account_tree (guid, name, account_type, code, description, placeholder, commodity_guid, namespace, mnemonic, master_parent_guid) AS (
SELECT a.guid, a.name, a.account_type, a.code, a.description, a.placeholder, commodity_guid, c.namespace, c.mnemonic, a.guid as master_parent_guid
	FROM accounts a
		INNER JOIN invmgr_investment_account pa on a.parent_guid = pa.guid
		LEFT OUTER JOIN commodities c on c.guid = a.commodity_guid		
UNION 
SELECT a.guid, a.name, a.account_type, a.code, a.description, a.placeholder, a.commodity_guid, c.namespace, c.mnemonic, pa.master_parent_guid
	FROM accounts a
		INNER JOIN invmgr_asset_account_tree pa on a.parent_guid = pa.guid
		LEFT OUTER JOIN commodities c on c.guid = a.commodity_guid
)		
--SELECT * FROM invmgr_asset_account_tree WHERE placeholder = 0  --AND guid NOT IN (SELECT guid FROM invmgr_asset_account)
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
	FROM invmgr_asset_account_tree
	WHERE placeholder = 0
		AND guid NOT IN (SELECT guid FROM invmgr_asset_account)

		
-- TODO: UPDATE statement to update name for guid in case it changes.		
	
	
SELECT ia.name, a.*
	FROM invmgr_asset_account a
		LEFT OUTER JOIN accounts ia on ia.guid = a.master_parent_guid
	ORDER BY ia.name, a.account_type, a.name