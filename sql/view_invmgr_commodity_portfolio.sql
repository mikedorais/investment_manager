-- This contains the value of each commodity per investment account and the proportion it is of
-- the total value of investments in the investment account.
-- DROP VIEW v_invmgr_commodity_portfolio
CREATE VIEW  v_invmgr_commodity_portfolio AS
WITH commodity_portfolio (master_account_guid, master_account_code, master_account_name, commodity_guid, namespace, mnemonic, commodity_name, value) AS (
SELECT master_account_guid, master_account_code, master_account_name, commodity_guid, namespace, mnemonic, commodity_name,
		SUM(value) value
	FROM v_invmgr_portfolio
	GROUP BY master_account_guid, master_account_code, master_account_name, commodity_guid, namespace, mnemonic, commodity_name
) -- SELECT * FROM commodity_portfolio
SELECT cp.master_account_guid, cp.master_account_code, cp.master_account_name, cp.commodity_guid, cp.namespace, cp.mnemonic, cp.commodity_name,
	    value, cp.value / av.total_value as proportion
	FROM commodity_portfolio cp
		INNER JOIN v_invmgr_acount_value av on av.guid = cp.master_account_guid
	ORDER BY cp.master_account_name, cp.namespace, cp.mnemonic

-- SELECT * FROM v_invmgr_commodity_portfolio