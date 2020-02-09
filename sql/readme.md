# INVESTMENT MANAGER ENHANCEMENT TO GNUCASH

These SQL scripts add enhanced tables and views
to assist in managing investments with GnuCash.

One goal is to be able to develop a target allocation
by asset class for each investment account and have a set of commodities (securities) that can supply the investments with for each asset class for each account.
The other goal is to be able to take the current portfolio
and compare the actual investments against the target and
create a table result that can be used to guide reallocation
of investments to meet the percentage target for each class.

Currently the final select query that produces that information
would need to be exported to a spreadsheet for practical use.

Within the spreadsheet the investor could come up with an allocation of actual commodities within each class to meet that classes target allocation making descisons regarding which commodities to keep, reduce, increase, sell off. 
The spreadsheet may also be able to calculate the buy and
sell orders that need to be made.

A goal for future enhancement is to include in the repository a program which could take the same export as input.  The program would assist
the investor with doing the reallocation and could even generate
buy and sell order descriptions.
Beyond that the program could implement more sophisticated and complex strategies that are more than just allocation by class.

## Maintaining Support Tables
These are partial instructions.  For more information, refer to comments in SQL scripts.  This should be updated to be more complete.

### After Adding Investments
After creating a new investment asset account for a particular commodity under a parent invesment account (invmgr_investment_acccount), it needs to be added to the following tables to support using the tables and views as designed:
* invmgr_account_investment
* invmgr_commodity_research

The top half of this script handles initial population and adding of investments you want to be considering under an asset_class.
But the bottom half provides scripts for validation and updating the two above tables:
populate_invmgr_account_investment.sql

Note that if any invmgr_account_investments are present, but you don't want them to be still considered under an asset class in invmgr_model_allocation for the investment account,
at least set to an asset_class "DIVEST" with target_proportion of 0 in invmgr_model_allocation (i.e. you want to sell it off and replace it with others).

## Investment Research
Columns in invmgr_commodity_research originally came from a spreadsheet and the columns were a synthensis derived in part from the search in TD Ameritrade on the symbol, the prospectus, MoringStar (TM) analysis, segment/asset targt from https://www.etf.com.  You can use them however you like (I'm not providing data).  But here is how I used them:
* commodity_type: CASH, CD, TB (Treasury Bill), MF (Mutual Fund), ETF, B (Bond), S (Stock)
* asset_class: Fixed Income, Equity, Balanced
* asset_type_target: Primarily based on https://www.etf.com "Segment"
* aseet_target: Morningstar(TM) Category
* asset_max_actual: Morningstar(TM) Style box

## Next Enhancements
* Improve TODO items in SQL scripts
* Consider removing redundant data from table fields and use views to pull the data instead.  Consider, though, whether they should be kept in a table that needs to be edited. Currently validations and update statement are included that keep them up to date.




