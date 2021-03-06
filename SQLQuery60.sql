/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [DeliveryDateUTC]
      ,[SAPAccountNumber]
      ,[DepartureTime]
      ,[IsEstimated]
      ,[DNS]
      ,[ReportTimeLocal]
  FROM [Merch].[Notify].[StoreDeliveryTimeTrail]
  Where DeliveryDateUTC = Convert(Date, GetDate())
  And SAPAccountNumber = 12125329