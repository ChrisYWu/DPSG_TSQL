use Merch
Go

-- Get request details --
Select Top 20 convert(Datetime2(1), l.RequestTime) ActivityTime, 
	Case When e.LogID is null then 'Successful'
	Else 'Error'
	End Status,
	convert(Datetime2(1), e.ServerInserttime) ExceptionTime, l.LogID ActivityLogID, e.LogID ExceptionLogID, l.WebEndPoint, l.StoredProc, l.GetParemeters, l.PostJson, e.GSN, e.Exception, e.ComputerName, e.UserAgent, e.ModifiedDate, l.CorrelationID
From Mesh.MyDayActivityLog l
Full outer join Setup.WebAPILog e on l.CorrelationID = e.CorrelationID
Where (l.CorrelationID is not null or e.CorrelationID is not null)
--And e.LogID is Null
Order by coalesce(l.RequestTime, e.ServerInsertTime) Desc

-- Check header
Select *
From Mesh.DeliveryRoute
Where DeliveryDateUTC = Convert(Date, GetDate())  --'2018-04-16'
And RouteID = 111501301

-- Check footer
Select *
From Mesh.DeliveryStop
Where DeliveryDateUTC = Convert(Date, GetDate())  --'2018-04-16'
And RouteID = 111501301
Order By Sequence
