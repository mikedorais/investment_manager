-- This populates invmgr_account_investment with starting rows based on all existing investments in 
-- all investment accounts  that will be the table to record each invesment option, and what asset_class will be used
-- for allocation in each investment account.  Note that a commodity may appear more than once
-- if it is to be an option for more than one investment account but should only appear once
-- per investment account.  sort_key is built up as a default but can be modified to sort to make it easier 
-- to edit related rows together.

-- TODO: Improve this procedure.
-- It might be better to prequery into a temp table
-- the unique set of asset_type_target values
-- (from invmgr_commodity_research)
-- invested in for each account based on current investments
-- assigning them to an asset class that will be used
-- for each account in another field, multiple can be
-- combined into one.  A number prefix can be added for sorting.
-- Additional asset class names can be added, with or without
-- asset_type_target values.  Then the initial population could
-- with a new redesigned query could do a better job of initial
-- populatin and the missing asset classes could be referenced
-- in the insert.
-- The inserts of missing commodities could be improved
-- by a join to the invmgr_investment_account table,
-- single row for all on match of code to pull in the 
-- multiple values instead of finding copying and pasting them in.



INSERT INTO invmgr_account_investment
SELECT cp.master_account_guid, cp.master_account_code, 
	   cp.master_account_code || '-' || IFNULL(sr.asset_type_target,'NA') || '-' || cp.mnemonic as sort_key, cp.master_account_name, cp.commodity_guid, cp.namespace, cp.mnemonic, cp.commodity_name, 
		sr.asset_type_target as asset_class
	FROM v_invmgr_commodity_portfolio cp
		LEFT OUTER JOIN invmgr_commodity_research sr on sr.namespace = cp.namespace and sr.mnemonic = cp.mnemonic
	ORDER BY cp.master_account_name, sr.asset_type_target, cp.namespace, cp.mnemonic


-- This was used once because a record got deleted from the above table.  This inserted it back.
SELECT * FROM invmgr_account_investment
INSERT INTO invmgr_account_investment
SELECT cp.master_account_guid, cp.master_account_code, 
	   cp.master_account_code || '-' || IFNULL(sr.asset_type_target,'NA') || '-' || cp.mnemonic as sort_key, cp.master_account_name, cp.commodity_guid, cp.namespace, cp.mnemonic, cp.commodity_name, 
		sr.asset_type_target as asset_class
	FROM temp.commodity_portfolio cp
		LEFT OUTER JOIN invmgr_commodity_research sr on sr.namespace = cp.namespace and sr.mnemonic = cp.mnemonic
	WHERE (cp.master_account_guid, cp.commodity_guid) not in (SELECT master_account_guid, commodity_guid FROM invmgr_account_investment)
	ORDER BY cp.master_account_name, sr.asset_type_target, cp.namespace, cp.mnemonic

-- This point review the automatically generated asset classes
-- and determine how you want to combine, split, and order them
-- prefixing them with a number would help sort them.
-- Add any classes not yet invested in.  Clean up existing
-- records and sort keys.  Have the complete set of asset
-- classes with their final names at hand for the next step.

-- At this point you should insert additional records into invmgr_account_investment
-- for investment options you are not yet invested in but want to be considering
-- as investments to reach a target percentage for the asset_class it is assigned to for
-- the account.

-- First make sure each commodity is added as commodities in GnuCash, if it is not there already.
-- Then insert the rows into the the invmgr_account_investment table.

-- This query assumes that the asset class has already been added to invmgr_model_allocation for the investment account
-- and that its redundant fields from accounts or invmgr_investment_account are updated with the latest corresponding values
-- and that all the commodities have already been added to the commodities table.
-- Then all that is needed is to specify the master account code and asset class in the inner join clause
-- and add the list of mnemonics to add to the in expression in the where clause.

-- TODO: The sort key values generated require editing after the insert to remove everything except the first number
-- if you want the sort key to be ACCTCODE-N-MNEMONIC where N is the first character, a number, of the asset class.

INSERT INTO invmgr_account_investment
(master_account_guid, master_account_code, sort_key, master_account_name, commodity_guid, namespace, mnemonic, commodity_name, asset_class)
SELECT ma.master_account_guid, ma.master_account_code, ma.sort_key || '-' || c.mnemonic, ma.master_account_name, 
		c.guid, c.namespace, c.mnemonic, c.fullname, ma.asset_class
FROM commodities c
	 inner join invmgr_model_allocation ma on ma.master_account_code = 'TDIRAR' and ma.asset_class = '8 International Fixed Income'
WHERE c.mnemonic in 
(
...
)


-- TODO: Update values that are redundant 
-- from master tables sources
