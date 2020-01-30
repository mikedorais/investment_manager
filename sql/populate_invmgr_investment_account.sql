-- This insert statement can be run at any time for initial population
-- and to insert any missing rows due to added investment accounts
-- It defaults file_base_name to the account code.
-- This assumes that investment accounts in the account hierarchy will always be
-- directly under a parent named 'Investments' or 'Retirement Accounts'
-- modify accordingly if that is not the case.
INSERT INTO invmgr_investment_account 
    (guid, name, file_base_name)
	SELECT ia.guid, ia.name, ia.code
		FROM accounts ia
			INNER JOIN accounts iap ON (iap.name = 'Investments' OR iap.name = 'Retirement Accounts') AND iap.guid = ia.parent_guid
		WHERE ia.account_type = 'BANK'
			  AND ia.guid NOT IN (SELECT guid FROM invmgr_investment_account)
			  
-- TODO: UPDATE statement to update name for guid in case it changes.

SELECT * FROM invmgr_investment_account
