-- 2018/07/24 --

Select *
From Mesh.DeliveryRoute
Where DeliveryDateUTC = Convert(Date, GetDate())
--And SAPAccountNumber = 12125329
And RouteID = 112001013


Select Quantity, Servicetime, ActualSErviceTime, Quantity*1.0/Servicetime, Quantity*1.0/ActualSErviceTime, *
From Mesh.DeliveryStop
Where DeliveryDateUTC = Convert(Date, GetDate())
--And SAPAccountNumber = 12125329
And RouteID = 112001013
Order By Sequence

Select *
From Mesh.Resequence
Where RouteID = 112001013
And DeliveryDateUTC = Convert(Date, GetDate())

Select *
From Mesh.ResequenceDetail
Where ResequenceID = 303
Order by NewSequence

Select *
from Mesh.DeliveryRoute



