-- TODO: Maker commit proportion modifyable at the investment account / asset class level
-- perhaps it could go with the default commot proportion for the investent account if not specified
-- or use the override commit proportion for the asset class for the investment account (maybe another field 
-- in the invmgr_model_allocation table?)
-- May want to handle cases of overweight underweight.  For now, all classes are weigthed 
-- in proporition to the commit proportion for the investment account * the model target allocation for the class
-- and asset_class_commit_proportion is the same value as invacct_commit_proportion
-- A Cash-like or stable value class is meant to hold all the uninvested funds.  It's resulant current_target_proporition
-- can be ignored because it is not involved with the commit_proprotion for the account, because it is where all 
-- the uninvested funds go.

-- DROP VIEW v_invmgr_asset_allocation
CREATE VIEW v_invmgr_asset_allocation AS
WITH 
target_asset_allocation AS (
SELECT ma.master_account_guid, ma.master_account_code, ma.master_account_name, ma.sort_key, ia.commit_proportion AS invacct_commit_proportion, 
	    ia.commit_proportion AS asset_class_commit_proportion,
		ma.asset_class, ma.target_proportion as model_target_proportion, 
		ma.target_proportion * ia.commit_proportion as current_target_proportion
	FROM invmgr_model_allocation ma 
		INNER JOIN invmgr_investment_account ia on ia.guid = ma.master_account_guid
		--ORDER BY ma.sort_key
)
--SELECT * FROM target_asset_allocation
--, asset_alloction AS (
SELECT ta.master_account_guid, ta.master_account_code, ta.master_account_name, ta.invacct_commit_proportion, 
		ta.asset_class, ta.asset_class_commit_proportion, ta.model_target_proportion, ta.current_target_proportion
	,SUM((IFNULL(cp.value, 0) / av.total_value)) as actual_proportion
	FROM invmgr_account_investment ai
		LEFT OUTER JOIN v_invmgr_commodity_portfolio cp ON ai.master_account_guid = cp.master_account_guid AND ai.commodity_guid = cp.commodity_guid
		INNER JOIN target_asset_allocation ta ON ta.master_account_guid = ai.master_account_guid AND ta.asset_class = ai.asset_class
		INNER JOIN v_invmgr_acount_value av ON av.guid = ai.master_account_guid
	GROUP BY ta.master_account_guid, ta.master_account_code, ta.master_account_name, ta.invacct_commit_proportion, 
		ta.asset_class, ta.model_target_proportion, ta.current_target_proportion
	ORDER BY ta.master_account_name, ta.sort_key

-- SELECT * FROM v_invmgr_asset_allocation
