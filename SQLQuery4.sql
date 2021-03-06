/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [LogID]
      ,[ServiceName]
      ,[OperationName]
      ,[ModifiedDate]
      ,[GSN]
      ,[Type]
      ,[Exception]
      ,[GUID]
      ,[ComputerName]
      ,[UserAgent]
      ,[Json]
      ,[ServerInsertTime]
  FROM [Merch].[Setup].[WebAPILog]
  Where Operationname = 'GetImagePostingURL'
  order by LogID desc