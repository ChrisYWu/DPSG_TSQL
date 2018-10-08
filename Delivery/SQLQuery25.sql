use Merch
Go
Select *
From ETL.DataLoadingLog
Go

Select DeliveryDateUTC, Count(*)
From [Mesh].[DeliveryRoute]
Group By DeliveryDateUTC
Order by DeliveryDAteUTC DESC

Select Start_Time s, *
From Staging.RS_Route
Where Selected = 1
Order By s

Select *
From Staging.RS_Stop
Where Route_Pkey = 21378591




