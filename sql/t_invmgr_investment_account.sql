-- This table should contain a record
-- only for each account that is an
-- investment account.

-- DROP TABLE invmgr_investment_account
CREATE TABLE invmgr_investment_account (
    guid text(32) PRIMARY KEY NOT NULL, 
	name text(2048) NOT NULL, -- redundant
    file_base_name text(40),
	commit_proportion real,
    )