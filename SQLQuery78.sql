/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [DispatchID]
      ,[DispatchDate]
      ,[MerchGroupID]
      ,[RouteID]
      ,[GSN]
      ,[Sequence]
      ,[SAPAccountNumber]
      ,[BatchID]
      ,[InvalidatedBatchID]
      ,[StoreVisitStatusID]
      ,[ChangeNote]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[SameStoreSequence]
  FROM [Merch].[Planning].[Dispatch]
  Where GSN = 'PREEX009'
  And DispatchDate = '2017-02-22'
  And InvalidatedBatchID is null
  Order By Sequence

Select *
From [Merch].[Planning].[PreDispatch]
Where GSN = 'GASTS001'
And DispatchDate = '2017-02-22'
