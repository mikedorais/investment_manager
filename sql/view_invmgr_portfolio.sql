-- DROP VIEW v_invmgr_portfolio 
CREATE VIEW v_invmgr_portfolio AS
SELECT s.account_guid, ma.guid master_account_guid, ma.code master_account_code, a.code, ma.name master_account_name, a.name, a.description,
        p.guid commodity_guid, p.namespace, p.mnemonic, p.fullname commodity_name,
		sum(CAST(s.quantity_num as REAL) / s.quantity_denom) quantity, p.price, 
		sum(CAST(s.quantity_num as REAL) / s.quantity_denom) * p.price as value
	FROM splits s
	INNER JOIN v_invmgr_asset_account ia on s.account_guid = ia.guid
	INNER JOIN accounts a on a.guid = ia.guid
	INNER JOIN accounts ma on ma.guid = ia.master_parent_guid
	INNER JOIN v_invmgr_last_commodity_price p on p.guid = a.commodity_guid
	GROUP BY s.account_guid, a.code
	ORDER BY ma.name, a.code
	
-- SELECT * FROM v_invmgr_portfolio
