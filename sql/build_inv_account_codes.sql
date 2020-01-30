-- This builds account codes for anything that doesn't have a code
-- but an ancestor parent does have a code
-- The code is a from the most anscestor to the account itself, separated by dashes.
-- Placeholder account parts are their parent code plus the account name.
-- Non place holder account end with either the account name for BANK type accounts
-- or the commodity namespace.mnemonic for non BANK type accounts.account_type
-- Examples of non-placeholder accounts (which include their parent placeholder as the begging part of the string:
--   TDIRAP-CASH, TDBA-FUND-FUND.BCITX, TDIRAR-BOND-TREAS-CUSIP.9128285B2, TDIRAR-EFT-NASDAQ.SUSC

/*
-- Can first test it on a test copy of accounts
-- need to rename all the accounts to accounts in queries after this for test
-- then rename accounts to accounts to run the real thing.
-- DROP TABLE temp.accounts_test
CREATE TABLE temp.accounts_test AS
	SELECT * FROM accounts
-- SELECT * FROM accounts_test order by account_type, description
*/

-- TODO: Use WITH RECURSIVE CTE instead to generate values
--       in one compound statement, and then use an UPDATE
--       with corellated subqueries to fill in the codes.

-- TODO: Considering using investment accounts as the root instead of
--       doing it for any account that has a code for all its children.

-- Execute the following repeatedly all the way to the bottom,
-- including the drop table at the end each time,
-- until both update statements return 0 rows affected.

CREATE TABLE temp.accounts_temp AS
	SELECT * FROM accounts

--SELECT * FROM temp.accounts_temp ORDER BY placeholder, code


/*
-- Useful to check the update before it is done.
SELECT *, (SELECT code 
				FROM temp.accounts_temp AS pa 
				WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1) || '-' || name 
		    as newcode
	FROM accounts
	WHERE code = '' AND (placeholder = 1  OR account_type = 'BANK')
		  and EXISTS(SELECT code 
				FROM temp.accounts_temp AS pa 
				WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1)
*/

UPDATE accounts
  SET code = (SELECT code 
				FROM temp.accounts_temp AS pa 
				WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1) || '-' || name 
	WHERE code = '' AND (placeholder = 1  OR account_type = 'BANK')
		  and EXISTS(SELECT code 
				FROM temp.accounts_temp AS pa 
				WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1)

/*
-- Useful to check the update before it is done.
SELECT *, (SELECT code 
				  FROM temp.accounts_temp AS pa 
				  WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1) || '-' 
		     || (SELECT namespace || '.' || mnemonic 
		          FROM commodities c 
				  WHERE accounts.commodity_guid = c.guid ) 
			as newcode
	FROM accounts
	WHERE code = '' AND placeholder = 0 AND account_type <> 'BANK'
		and EXISTS(SELECT code 
				  FROM temp.accounts_temp AS pa 
				  WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1)
		and EXISTS(SELECT namespace || '.' || mnemonic 
		          FROM commodities c 
				  WHERE accounts.commodity_guid = c.guid )	
*/

UPDATE accounts
  SET code = (SELECT code 
				  FROM temp.accounts_temp AS pa 
				  WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1) || '-' 
		     || (SELECT namespace || '.' || mnemonic 
		          FROM commodities c 
				  WHERE accounts.commodity_guid = c.guid )
	WHERE code = '' AND placeholder = 0 AND account_type <> 'BANK'
		and EXISTS(SELECT code 
				  FROM temp.accounts_temp AS pa 
				  WHERE accounts.parent_guid = pa.guid and pa.code <> '' and pa.placeholder = 1)
		and EXISTS(SELECT namespace || '.' || mnemonic 
		          FROM commodities c 
				  WHERE accounts.commodity_guid = c.guid )


DROP TABLE temp.accounts_temp




