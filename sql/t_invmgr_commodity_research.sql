-- This table was originally created from 
-- an imported spreadsheet and so has the schema
-- resulting from that import.
-- It could be used as is, or improved
-- It is mostly used for reference when looking
-- for possible investments and to join to
-- to bring in some information about a commodity
-- that might be useful in making investment decisions
-- for example, when adjusting investments within 
-- an allocation.

CREATE TABLE `invmgr_commodity_research` (
	`namespace`	TEXT,
	`mnemonic`	TEXT,
	`name`	TEXT,
	`commodity_type`	TEXT,
	`asset_class`	TEXT,
	`asset_type_target`	TEXT,
	`asset_target`	TEXT,
	`asset_mix_actual`	TEXT,
	`esg`	TEXT,
	`no_fee`	TEXT,
	`no_load`	TEXT,
	`net_exp_ratio`	TEXT,
	`index_tracking`	TEXT,
	`score_application`	TEXT,
	`index`	TEXT,
	`base_index`	TEXT
);