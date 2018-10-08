use Merch
Go

Select DispatchDate, ReportInSequence, AccountName, Address, City, State, PostalCode, ClientCheckInTime, CheckInLatitude, CheckInLongitude, ClientCheckoutTime, CheckOutLatitude, CheckOutLongitude, Latitude, Longitude
From Operation.MerchStopCheckIn inn
Join [Operation].[MerchStopCheckOut] o on inn.MerchStopID = o.MerchStopID
Join SAP.Account a on inn.SAPAccountNumber = a.SAPAccountNumber
Where GSN = 'ROSIX506'
Order By DispatchDate, ReportInSequence
Go
