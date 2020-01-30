CREATE VIEW v_last_commodity_price AS 
-- Get the last prices
-- TODO: Support getting the last price before a particular date and time.
WITH last_price (commodity_guid, currency_guid, date, source, type, value_num, value_denom) AS (
SELECT commodity_guid, currency_guid, date, source, type, value_num, value_denom 
	FROM prices p
	WHERE date = (SELECT max(date) FROM prices lp WHERE lp.commodity_guid = p.commodity_guid GROUP BY commodity_guid )
) -- SELECT * FROM last_price
,
last_commodity_price (guid, namespace, mnemonic, fullname, price_date, price_source, price_type, price_cur, price) AS (
-- Get the last price for each commodity.  Assumes all are deonominated in the same currency.
-- TODO: Deal with different currencies.  In the meantime, check the price_cur and make sure it is USD for all of them.
SELECT c.guid, c.namespace, c.mnemonic, c.fullname, p.date price_date, p.source price_source, p.type price_type, cur.mnemonic price_cur, CAST(p.value_num as REAL) / p.value_denom as price
	FROM last_price p
	INNER JOIN commodities c on c.guid = p.commodity_guid
	INNER JOIN commodities cur on cur.guid = p.currency_guid
UNION
SELECT c.guid, c.namespace, c.mnemonic, c.fullname, strftime('%Y%m%d%H%M%S', 'now', 'localtime'), 'n/a', 'n/a', c.mnemonic price_cur, 1.0 price
	FROM commodities c
	WHERE c.mnemonic = 'USD'
)
SELECT * from last_commodity_price

SELECT * FROM v_last_commodity_price