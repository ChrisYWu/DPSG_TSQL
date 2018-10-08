use Portal_Data
Go

Select a.*
From SAP.Route r
Join SAP.RouteSchedule rs on r.RouteID = rs.RouteID
Join SAP.Account a on rs.AccountID = a.AccountID
Where RouteName like '%Bulk%'
And AccountName like '%Walmart%'
Order By AccountName

Select *
From SAP.Account
Where AccountName like '%Walmart%'
And Active = 1

