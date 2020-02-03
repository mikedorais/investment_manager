
SELECT cr.namespace, cr.mnemonic, cr.name, cr.commodity_type, cr.asset_class, cr.asset_type_target, cr.asset_target, 
    cr.asset_mix_actual, cr.esg, cr.no_fee, cr.no_load, cr.net_exp_ratio, cr.index_tracking, cr.score_application, cr.`index`, cr.base_index
	FROM invmgr_commodity_research  cr
	INNER JOIN invmgr_account_investment ai on ai.namespace = cr.namespace AND ai.mnemonic = cr.mnemonic
WHERE ai.master_account_code = 'TDIRAP'
	  --AND cr.commodity_type = 'ETF' 
	  --AND cr.mnemonic = ''
	  AND cr.mnemonic IN (
...
)
	  

