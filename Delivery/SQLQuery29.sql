use Merch
go

Select i.GSN, i.DisPatchDate Date, i.ClientCheckInTime, i.ClientCheckInTimeZone, i.SAPAccountNumber AccountNumber, a.AccountName, CheckInlatitude, CheckInLongitude, a.Latitude StoreLatitude, a.Longitude StoreLongitude
From Operation.MerchStopCheckIn i
Join Operation.MerchStopCheckout o On i.MerchStopID = o.MerchStopID
Join SAP.Account a on i.SAPAccountNumber = a.SAPAccountNumber
Where GSN = 'BASCM002'
And DispatchDate = '2018-04-14'
Order by ClientSequence