SELECT a1.name, a1.account_type, a1.description, a1.placeholder, a1.code, 
	a2.description as description2, a2.placeholder as placeholder2, a2.code as code2,
	a3.description as description2, a3.placeholder as placeholder3, a3.code as code2,
	a4.description as description2, a4.placeholder as placeholder4, a4.code as code2
	FROM accounts_test a1
   LEFT OUTER JOIN accounts_test a2 on a2.guid = a1.parent_guid
   LEFT OUTER JOIN accounts_test a3 on a3.guid = a2.parent_guid
   LEFT OUTER JOIN accounts_test a4 on a4.guid = a3.parent_guid 
 order by a1.account_type, a1.code, a1.description