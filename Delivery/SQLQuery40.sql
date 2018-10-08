use Merch
Go

Select *
From Planning.Dispatch
Where GSN = 'CLEGX005'
And InvalidatedBatchId is null
And dispatchDate = '2018-07-02'
Order By SEquence Desc

exec Planning.pGetMerchSchedule @MerchGroupID = 24
	, @GSN = 'CLEGX005'
	, @StartDispatchDate = '2018-07-02'
