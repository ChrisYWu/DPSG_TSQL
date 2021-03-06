/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [StoreDeliveryID]
      ,[DeliveryDate]
      ,[SAPAccountNumber]
      ,[MerchandiserbleStore]
      ,[PlannedArrival]
      ,[ActualArrival]
      ,[InvoiceDelivered]
      ,[InvoiceDeliveredTime]
      ,[DriverID]
      ,[DriverFirstName]
      ,[DriverLastName]
      ,[DriverPhone]
      ,[PlannedLastModified]
      ,[ActualArrivalLastModified]
      ,[LastModified]
  FROM [Merch].[Operation].[StoreDelivery]
  Where ActualArrival is not null
  And DeliveryDate = '2017-02-21'
  And PlannedArrival is null
