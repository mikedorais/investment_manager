-- Run this query for a list of all possible investments in each asset class for each account,
-- with the actual proportion.  Come up with a new allocation of individual investments within each asset class
-- to total up to the asset_class_target_proportion (repeated in each row for reference.
-- Before programmatic automation, just paste it into a spreadsheet and do the work there.

SELECT ai.master_account_guid, ai.master_account_code, ai.master_account_name, ai.sort_key,
		aa.invacct_commit_proportion, ai.asset_class, aa.asset_class_commit_proportion, aa.model_target_proportion AS asset_class_model_proportion,
		aa.current_target_proportion AS asset_class_target_proportion,
		ai.commodity_guid, ai.namespace, ai.mnemonic, ai.commodity_name,
    	(IFNULL(cp.value, 0) / av.total_value) as actual_proportion
	FROM  invmgr_account_investment ai 
		LEFT OUTER JOIN v_invmgr_commodity_portfolio cp ON ai.master_account_guid = cp.master_account_guid AND ai.commodity_guid = cp.commodity_guid
		INNER JOIN v_invmgr_asset_allocation aa ON aa.master_account_guid = ai.master_account_guid AND aa.asset_class = ai.asset_class
		INNER JOIN v_invmgr_acount_value av ON av.guid = ai.master_account_guid
	ORDER BY ai.master_account_name, ai.asset_class, ai.sort_key





