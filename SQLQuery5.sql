/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [DispatchDate]
      ,[GSN]
      ,[SAPAccountNumber]
      ,[ClientPhotoID]
      ,[Caption]
      ,[PictureName]
      ,[PictureBlobID]
      ,[SizeInByte]
      ,[Extension]
      ,[ClientTime]
      ,[ClientTimeZone]
      ,[UTCInsertTime]
      ,[UTCUpdateTime]
  FROM [Merch].[Operation].[MerchStorePicture]
  order by dispatchDAte desc, clientTime desc