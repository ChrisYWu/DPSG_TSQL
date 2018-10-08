use Merch
Go

Select *
From Planning.Dispatch
Where DispatchDate = Dateadd(day, -1, Convert(Date, GetDate()))
And GSN = 'CHANX014'
And InvalidatedBatchID is null

Select *
From Operation.MerchStopCheckIn
Where DispatchDate = Dateadd(day, -1, Convert(Date, GetDate()))
And GSN = 'CHANX014'
And SAPAccountNumber in (11299448, 12025927)
