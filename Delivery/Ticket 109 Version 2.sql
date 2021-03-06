USE [Merch]
GO

Alter Table Planning.Dispatch
Add NewSequence int
Go

/****** Object:  StoredProcedure [Planning].[pDispatch]    Script Date: 2/27/2017 12:47:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec Planning.pGetPreDispatch @MerchGroupID = 101, @GSN = 'System'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @ReleaseBy = 'WUXYX001'


exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-08-09', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-08-10', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-08-11', @ReleaseBy = 'WUXYX001'

exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-06-27', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-06-28', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-06-29', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-06-30', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-1', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-2', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-3', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-4', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-5', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-6', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-7', @ReleaseBy = 'WUXYX001'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @DispatchDate = '2016-7-8', @ReleaseBy = 'WUXYX001'

exec Planning.pDispatch @MerchGroupID = 257, @DispatchNote = 'Wu Test 12', @DispatchDate = '2017-02-28', @ReleaseBy = 'WUXYX001'


Select *
From Planning.Dispatch
Where MerchGroupID = 101
And DispatchDate = '2016-10-13'
And GSN = 'TATWD001'

Select *
From Planning.PreDispatch
Where MerchGroupID = 101
And DispatchDate = '2016-10-13'
And GSN = 'TATWD001'

Update 
Planning.PreDispatch
Set SAPAccountNumber = 11989999
Where MerchGroupID = 101
And DispatchDate = '2016-10-13'
And GSN = 'TATWD001'
And Sequence = 4

--Select d.SAPAccountNumber, AccountName, SameStoreSequence, Max(StoreVisitStatusID) MaxStoreVisitStatusID, Min(StoreVisitStatusID) MinStoreVisitStatusID, Count(*) TotalCount
--From Planning.Dispatch d
--Join SAP.Account a on d.SAPAccountNumber = a.SAPAccountNumber
--Where GSN = 'CHARA001'
--And DispatchDate = Convert(Date, GetDate())
--Group By d.SAPAccountNumber, SameStoreSequence, AccountName

--Select *
--From Planning.Dispatch
--Where SAPAccountNumber = 11327268
--And GSN = 'CHARA001'
--And DispatchDate = Convert(Date, GetDate())

--Select d.SAPAccountNumber, AccountName, SameStoreSequence, Max(StoreVisitStatusID) MaxStoreVisitStatusID, Min(StoreVisitStatusID) MinStoreVisitStatusID, Count(*) TotalCount
--From Planning.Dispatch d
--Join SAP.Account a on d.SAPAccountNumber = a.SAPAccountNumber
--Where GSN = 'CHARA001'
--And DispatchDate = DateAdd(day, -3, Convert(Date, GetDate()))
--Group By d.SAPAccountNumber, SameStoreSequence, AccountName

*/

ALTER Proc [Planning].[pDispatch]
(
	@MerchGroupID int,
	@DispatchNote varchar(2000),
	@DispatchDate date = null,
	@ReleaseBy varchar(500)
)
As
Begin
	-------------------------------------
	Declare @BatchID Int
	Declare @DispatchInfo varchar(1000)
	Set @DispatchInfo = 'OK'

	If( @DispatchDate is null)
		Set @DispatchDate  = Convert(Date, GetDate())

	Begin Transaction;  
  
	Begin Try  
		-------------------------------------
		Insert Into Planning.DispatchBatch(MerchGroupID, DispatchDate, BatchNote, ReleaseTime, ReleaedBy)
		Values(@MerchGroupID, @DispatchDate, @DispatchNote, SYSUTCDATETIME(), @ReleaseBy)

		Select @BatchID = SCOPE_IDENTITY();

		-------------------------------------
		With Dispatch As
		(
			Select * 
			From Planning.Dispatch 
			Where MerchGroupID = @MerchGroupID
			And DispatchDate = @DispatchDate
			And InvalidatedBatchID is null
		)

		Merge Dispatch as t
		Using (Select * From Planning.PreDispatch Where DispatchDate = @DispatchDate And MerchGroupID = @MerchGroupID) as s
		On (t.DispatchDate = s.DispatchDate And 
			t.MerchGroupID = s.MerchGroupID And 
			t.SAPAccountNumber = s.SAPAccountNumber And 
			t.SameStoreSequence = s.SameStoreSequence And 
			t.GSN = s.GSN And
			t.RouteID = s.RouteID)
		When Matched And t.Sequence <> s.Sequence
			Then Update Set
			t.NewSequence = s.Sequence
		When Not Matched By Source And (t.DispatchDate = @DispatchDate And t.MerchGroupID = @MerchGroupID And t.InvalidatedBatchID is null)
			Then Update Set InvalidatedBatchID = @BatchID, LastModified = SYSUTCDATETIME(), LastModifiedBy = @ReleaseBy, ChangeNote = isnull(ChangeNote, '') + '*Invalided at batch ' + Convert(varchar(100), @BatchID)
		When Not Matched By Target
			Then Insert(DispatchDate, MerchGroupID, SAPAccountNumber, Sequence, SameStoreSequence, GSN, RouteID, BatchID, LastModified, LastModifiedBy, ChangeNote) 
			Values(s.DispatchDate, s.MerchGroupID, s.SAPAccountNumber, s.Sequence, s.SameStoreSequence, s.GSN, s.RouteID, @BatchID, SYSUTCDATETIME(), @ReleaseBy, '*Released at batch ' + Convert(varchar(100), @BatchID));

		----------------------------------
		Insert Planning.Dispatch(DispatchDate, MerchGroupID, SAPAccountNumber, Sequence, SameStoreSequence, GSN, RouteID, BatchID, LastModified, LastModifiedBy, ChangeNote) 
		Select DispatchDate, MerchGroupID, SAPAccountNumber, NewSequence, SameStoreSequence, GSN, RouteID, @BatchID, SYSUTCDATETIME(), @ReleaseBy, '*Released at batch ' + Convert(varchar(100), @BatchID)
		From Planning.Dispatch 
		Where MerchGroupID = @MerchGroupID
		And DispatchDate = @DispatchDate
		And InvalidatedBatchID is null
		And NewSequence is not null

		Update Planning.Dispatch 
		Set InvalidatedBatchID = @BatchID, 
			LastModified = SYSUTCDATETIME(), 
			LastModifiedBy = @ReleaseBy, 
			ChangeNote = isnull(ChangeNote, '') + '*Invalided at batch ' + Convert(varchar(100), @BatchID), 
			NewSequence = null
		Where MerchGroupID = @MerchGroupID
		And DispatchDate = @DispatchDate
		And InvalidatedBatchID is null
		And NewSequence is not null;

		----------------------------------
		With Dispatch As
		(
			Select * 
			From Planning.Dispatch 
			Where MerchGroupID = @MerchGroupID
			And DispatchDate = @DispatchDate
			And InvalidatedBatchID is null
		),
		MaxVisitStatus 
		As
		(
			Select GSN, SAPAccountNumber, SameStoreSequence, Max(StoreVisitStatusID) MaxStoreVisitStatusID
			From Planning.Dispatch
			Where MerchGroupID = @MerchGroupID
			And DispatchDate = @DispatchDate
			Group By GSN, SAPAccountNumber, SameStoreSequence
		)
		
		Update d
		Set d.StoreVisitStatusID = m.MaxStoreVisitStatusID
		From Dispatch d
		Join MaxVisitStatus m
		On d.GSN = m.GSN And d.SAPAccountNumber = m.SAPAccountNumber And d.SameStoreSequence = m.SameStoreSequence

		----------------------------------
	End Try

	Begin Catch
		Select @DispatchInfo = ERROR_MESSAGE()
		IF @@TRANCOUNT > 0  
			Rollback Transaction;  
	End Catch;
	
	IF @@TRANCOUNT > 0  
		Commit Transaction;  

	Select @DispatchInfo DispatchInfo, @BatchID BatchID
End
