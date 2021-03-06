/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [MerchStopID]
      ,[DispatchDate]
      ,[GSN]
      ,[MerchGroupID]
      ,[RouteID]
      ,[ClientSequence]
      ,[ReportInSequence]
      ,[SAPAccountNumber]
      ,[IsOffRouteStop]
      ,[ClientCheckInTime]
      ,[ClientCheckInTimeZone]
      ,[CheckInLatitude]
      ,[CheckInLongitude]
      ,[DriveTimeInMinutes]
      ,[StandardMileage]
      ,[UserMileage]
      ,[UTCInsertTime]
      ,[UTCUpdateTime]
      ,[SameStoreSequence]
      ,[CheckInDistanceInMiles]
  FROM [Merch].[Operation].[MerchStopCheckIn]
  Where DispatchDate = '2018-10-02' And GSN = 'JUDCX001'



Use merch
Go

  Select *
  From SAP.Account
  Where SAPAccountNumber = '11278611'

Select *
From [Operation].[GSNActivityLog]
Where OperationDate = '2018-10-02'

Select *
From Operation.MerchStopcheckOut
Where MerchStopID = 822361

Select Top 100 *
From Operation.GSNActivityLog
Where OperationDate = '2018-10-03'

Select Top 100 *
From [Setup].[WebAPILog]
Where ModifiedDate > '2018-10-03'

Select *
From Operation.GSNActivityLog
Where OperationDate = '2018-10-03'
And GSN = 'CARJX587'
Order By UTCInsertTime



