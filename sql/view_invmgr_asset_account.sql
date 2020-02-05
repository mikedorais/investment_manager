CREATE VIEW v_invmgr_asset_account AS
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
SELECT guid, 
	name,
	account_type,
	code,
	description,
	commodity_guid,
	namespace AS cmdty_namespace,
	mnemonic AS cmdty_mnemonic,
    master_parent_guid
	FROM invmgr_asset_account_tree
	WHERE placeholder = 0

--SELECT * FROM invmgr_asset_account