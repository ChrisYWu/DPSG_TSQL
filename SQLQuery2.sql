/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DeliveryDateUTC,   Count(*)
FROM [Merch].[Mesh].[PlannedStop]
Group by DeliveryDateUTC 
Order By DeliveryDateUTC Desc