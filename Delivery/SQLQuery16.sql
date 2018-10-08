use portal_data
Go

select *
from sap.route
where saproutenumber = '102500314'

select a.*
from sap.routeschedule d
join sap.account a on a.accountid = d.accountid
where routeid = 1286

select *
from sap.branch
where branchid = 13



