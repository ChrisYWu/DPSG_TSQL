use Merch
Go

Select Distinct StopType
From Mesh.PlannedStop

Select *
From Mesh.PlannedStop
Where DeliveryRouteID in 
(
	Select DeliveryRouteID
	From Mesh.PlannedStop
	Where StopType = 'PL'
)

