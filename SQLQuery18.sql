use Merch
go

SELECT *
  FROM [Mesh].[DeliveryRoute] dr
  Join Mesh.PlannedStop ds on dr.DeliveryRouteID = ds.DeliveryRouteID
  Where dr.DeliveryDateUTC = '2018-03-02'
  Order By dr.DeliveryDateUTC

Select *
From Mesh.DeliveryRoute 
Where RouteID = 110901504
Order By DeliveryDateUTC

