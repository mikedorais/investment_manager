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
* Improve TODO items in scripts
* Consider removing redundant data from table fields and use views to pull the data instead.  Consider, though, the convenience for a table that needs to be edited.