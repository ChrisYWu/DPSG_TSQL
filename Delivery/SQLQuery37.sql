use Merch
Go

Select RouteID, SAPAccountNumber
From Mesh.PlannedStop
Where DeliveryDAteUTC = Convert(Date, GetDAte())
And StopType = 'STP'
Group By RouteID, SAPAccountNumber
Having Count(*) > 1
Order By RouteID 

Select *
From Mesh.PlannedStop
Where DeliveryDAteUTC = Convert(Date, GetDAte())
And RouteID = 110200888
Order By SEquence

exec Mesh.pGetDeliveryManifest @DeliveryDateUTC = '2018-06-11', @RouteID = 108300545

Select *
From Mesh.DeliveryStop
Where DeliveryDAteUTC = '2018-06-11'
And RouteID = 108300545
Order By SEquence

Select *
From Mesh.PlannedStop
Where DeliveryDAteUTC = '2018-06-11'
And RouteID = 108300545
Order By Sequence
