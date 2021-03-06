/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Json], count(*) Cnt
  FROM [Merch].[Setup].[WebAPILog]
  Where ModifiedDate > DateAdd(day, -7, GetDAte())
  And Operationname = 'UploadMerchStopCheckOut'
  And Exception = 'No Checkin record found'
  Group By Json
  Order By Json DESC

  /*
  {"ScheduleDate":"2018-10-01T00:00:00","GSN":"ZAMCD001","ClientSequence":2,"SameStoreSequence":1,"MerchGroupID":226,"SAPAccountNumber":11337167,"ClientCheckOutTime":"2018-10-01T11:08:48","ClientCheckOutTimeZone":"PDT","CheckOutLatitude":37.773259818353779,"CheckOutLongitude":-121.9766903922262,"CasesHandeled":0,"CasesInBackroom":0,"Comments":"","AtAccountTimeInMinute":155}
  */

Use Merch
Go

SELECT *
  FROM [Merch].[Setup].[WebAPILog]
  Where ModifiedDate > DateAdd(day, -7, GetDAte())
  And Operationname = 'UploadMerchStopCheckIn'
