use Merch
Go

Select *
From Planning.Route r
Join Setup.MerchGroup mg on r.MerchGroupID = mg.MerchGroupID
Join SAP.Branch b on mg.SAPBranchID = b.SAPBranchID
Join Setup.Person p on p.GSN = mg.DefaultOwnerGSN
Where routeName = 'Flex 1'

Select *
From Setup.Store
Where SAPAccountNumber = 11513147

Select *
From Planning.RouteStoreWeekDay
Where MerchGroupID = 116
And DayOfWeek = 7


Select datepart(dw, getdate())

