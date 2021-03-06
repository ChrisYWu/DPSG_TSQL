/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [LogID]
      ,[WebEndPoint]
      ,[StoredProc]
      ,[GetParemeters]
      ,[PostJson]
      ,[RequestTime]
      ,[CorrelationID]
      ,[DeliveryDateUTC]
      ,[RouteID]
      ,[GSN]
  FROM [Merch].[Mesh].[MyDayActivityLog] 
  Where Convert(DAte, RequestTime) = Convert(DAte, GEtDAte())
  Order By LogID DESC
