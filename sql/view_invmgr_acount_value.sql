CREATE View v_invmgr_acount_value AS
SELECT master_account_guid, master_account_code, master_account_name, sum(value) total_value
	FROM v_invmgr_portfolio
	GROUP BY master_account_guid, master_account_code, master_account_name
	ORDER BY master_account_name

--SELECT * FROM v_invmgr_acount_value