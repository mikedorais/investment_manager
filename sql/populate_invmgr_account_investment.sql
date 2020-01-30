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

-- This might be done like this.  This is the way I did it,
-- once for each asset class with the in clause of mnemonic
-- values filled in with the commodities needed to be added -
-- to the class.  But this requires that you specify constant
-- values in the select for master_account_guid, master_account_code,
-- the sort key prefix, account name, and the asset class.

-- Reg IRA 
--'1 U.S. - Total Market'
INSERT INTO invmgr_account_investment
(master_account_guid, master_account_code, sort_key, master_account_name, commodity_guid, namespace, mnemonic, commodity_name, asset_class)
SELECT '1cffd4fb6000be456194c382e2cb28d9', 'TDIRAP', 'TDIRAP-1-' || c.mnemonic, 'TD Ameritrade Regular IRA', 
		c.guid, c.namespace, c.mnemonic, c.fullname, '1 U.S. - Total Market'
FROM commodities c
WHERE mnemonic in 
('XXXX',
'YYYY', 
...
)


-- TODO: Update values that are redundant 
-- from master tables sources
