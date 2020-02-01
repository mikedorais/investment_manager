-- This table specifies proportion of each asset class for each investment acccount that would be 
-- invested in that account under reasonably good long term outlook conditions.
-- It is initialized with values based on current actual investments and the stated commit_proportion for the 
-- account and assuming the current commit proportion.  
-- The initial population is just a starting point.  They need
-- to be edited to intended allcation.
INSERT INTO invmgr_model_allocation	
SELECT ai.master_account_guid, ai.master_account_code, ai.master_account_name, 
		ai.master_account_code || '-' || ai.asset_class AS sort_key,  ai.asset_class,
	    SUM((IFNULL(cp.value, 0) / av.total_value) / ia.commit_proportion) AS target_proportion
	FROM  invmgr_account_investment ai 
		LEFT OUTER JOIN v_invmgr_commodity_portfolio cp ON ai.master_account_guid = cp.master_account_guid AND ai.namespace = cp.namespace AND ai.mnemonic = cp.mnemonic	
		INNER JOIN v_invmgr_acount_value av ON av.guid = ai.master_account_guid
		INNER JOIN invmgr_investment_account ia ON ia.guid = ai.master_account_guid
	GROUP BY ai.master_account_guid, ai.master_account_code, ai.master_account_name, ai.asset_class
	ORDER BY ai.master_account_name, ai.asset_class