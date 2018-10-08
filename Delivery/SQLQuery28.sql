use Merch
Go

Select *
From Planning.PreDispatch
Where GSN = 'ESCDC001'
And DispatchDAte >= GetDate() 
And InvalidatedBatchID is Null

Select *
From Setup.MerchGroup
Where MerchGroupId = 35