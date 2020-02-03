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
The spreadsheet may also be able to highlight the buy and
sell orders that need to be made.

A goal is to include in the repository a program which could take the same export as input.  The program would assist
the investor with doing the reallocation and could even generate
buy and sell order descriptions.
Beyond that the program could implement more sophisticated and complex strategies that are more than just allocation by class.


## Next Enhancements
* Improve TODO items in SQL scripts
* Consider removing redundant data from table fields and use views to pull the data instead.  Consider, though, the convenience for a table that needs to be edited.
* Write Validations
    * invmgr_account_investment should have every commodidty/inv account combination in v_invmgr_commodity_portfolio at least set to an asset_class "DIVEST" with target_proportion of 0 in invmgr_model_allocation (i.e. you want to sell it off and replace it with others).
    * Every asset_class in invmgr_account_investment should have a record in invmgr_model_allocation with the same asset_class
    * Every asset_class in invmgr_model_allocation should have at least one record in invmgr_account_investment with the same asset_class
    * Every commodity in invmgr_account_investment should have a record in invmgr_commodity_research with the same namespace and mnemonic.  Check namespace, check for renamed symbols.
    * More validations?

* Columns in invmgr_commodity_research originally came from a spreadsheet and the columns were a synthensis derived in part from the search in TD Ameritrade on the symbol, the prospectus, MoringStar (TM) analysis, segment/asset targt from https://www.etf.com.  You can use them however you like (I'm not providing data).  But here is how I used them:
    * asset_class: Fixed Income, Equity, Balanced
    * asset_type_target: Primarily based on https://www.etf.com "Segment"
    * aseet_target: Morningstar(TM) Category
    * asset_max_actual: Morningstar(TM) Style box