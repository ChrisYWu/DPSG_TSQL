USE [Merch]
GO
/****** Object:  StoredProcedure [Planning].[pGetPreDispatch]    Script Date: 2/27/2017 1:39:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec Planning.pGetPreDispatch @MerchGroupID = 257, @DispatchDate = '2017-02-21', @GSN = 'System'

exec Planning.pGetPreDispatch @MerchGroupID = 257, @GSN = 'System'
exec Planning.pDispatch @MerchGroupID = 101, @DispatchNote = 'Wu Test', @ReleaseBy = 'WUXYX001'

exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-08-09', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-08-10', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-08-11', @GSN = 'System'


exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-06-11', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-06-27', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-06-28', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-06-29', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-06-30', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-1', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-2', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-3', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-4', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-5', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-6', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-7', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-8', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-9', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-10', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-11', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-12', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-13', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-14', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-15', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-16', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-17', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-18', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 101, @DispatchDate = '2016-07-19', @GSN = 'System'
exec Planning.pGetPreDispatch @MerchGroupID = 226, @DispatchDate = '2017-02-24', @GSN = 'System'


*/

ALTER Proc [Planning].[pGetPreDispatch]
(
	@MerchGroupID int,
	@DispatchDate date = null,
	@GSN varchar(50)
)
As
	DECLARE @LocalTimeZone VARCHAR(5)
	DECLARE @LocalOffsetToUTC INT

	SELECT @LocalTimeZone= TimeZone, @LocalOffsetToUTC= OffsetToUTC  FROM [Setup].[GetTimeZoneWithOffsetToUTC](@MerchGroupID)

	
	If @DispatchDate Is Null
	Begin
		Set @DispatchDate = Convert(Date, GetDate())
	End


	If Not Exists(Select * From Planning.PreDispatch Where MerchGroupID = @MerchGroupID And DispatchDate = @DispatchDate)
	Begin
		Insert Into Planning.PreDispatch(DispatchDate, MerchGroupID, SAPAccountNumber, Sequence, GSN, RouteID, LastModified, LastModifiedBy)
		Select @DispatchDate DispatchDate, rsw.MerchGroupID, rsw.SAPAccountNumber, rsw.Sequence, GSN, rsw.RouteID, SYSDATETIME(), @GSN
		From Planning.RouteMerchandiser rm 
		Join Planning.RouteStoreWeekday rsw on rm.RouteID = rsw.RouteID and rm.DayOfWeek = rsw.DayOfWeek
		Where DatePart(dw, @DispatchDate) = rm.DayOfWeek
		And @MerchGroupID = MerchGroupID

		
		Update d
		Set d.SameStoreSequence = t.SameStoreSequence
		From Planning.PreDispatch d
		Join (
			Select DisPatchDate, MerchGroupID, RouteID, GSN, Sequence, SAPAccountNumber,
				Row_Number() Over (Partition By MerchGroupID, DispatchDate, GSN, SAPAccountNumber Order By Sequence) SameStoreSequence
			From Planning.PreDispatch
			Where MerchGroupID = @MerchGroupID And DispatchDate = @DispatchDate
		) t on d.DispatchDate = t.DispatchDate And d.GSN = t.GSN and d.Sequence = t.Sequence and d.SAPAccountNumber = t.SAPAccountNumber And d.MerchGroupID = t.MerchGroupID

	End
		
	Select * into #DipatchTable from 
	(
	Select pd.DispatchDate, pd.MerchGroupID, pd.SAPAccountNumber, a.AccountName, pd.RouteID, r.RouteName, pd.Sequence, pd.GSN, IsNull(p.FirstName, '+ Add') FirstName, IsNull(p.LastName, 'Merchandiser') LastName, pd.LastModified, pd.LastModifiedBy, IsNull(ab.AbsoluteURL, '') AbsoluteURL
	, (CASE WHEN d.StoreVisitStatusID = 3 THEN 'GREEN' WHEN d.StoreVisitStatusID = 2 THEN 'GRAY' ELSE '' END) as CheckInGSN
	,(CASE WHEN ISNULL(sd.ActualArrival, '') != '' THEN  Isnull(LTRIM(RIGHT(CONVERT(CHAR(19),DateAdd(hour, -1 * @LocalOffsetToUTC, sd.ActualArrival),100),7)), '') + ' ' +  ' DELIVERED'
		   WHEN ISNULL(sd.PlannedArrival, '') != '' THEN Isnull(LTRIM(RIGHT(CONVERT(CHAR(19),DateAdd(hour, -1 * @LocalOffsetToUTC, sd.PlannedArrival),100),7)), '') + ' ' +  ' SCHEDULE'
		   ELSE 'NO  DELIVERY'
	  END) ActualArrival
	   
	From Planning.PreDispatch pd
	Join SAP.Account a on pd.SAPAccountNumber = a.SAPAccountNumber
	Join Planning.Route r on pd.RouteID = r.RouteID
	Left Join Setup.Person p on pd.GSN = p.GSN
	Left Join Setup.ProfileImage pimage on pimage.GSN = p.GSN
	LEFT JOIN Operation.AzureBlobStorage ab on ab.BlobID = pimage.ImageBlobID
	LEFT JOIN Planning.Dispatch d on d.RouteID = pd.RouteID and d.DispatchDate = pd.DispatchDate and d.GSN = pd.GSN and d.SAPAccountNumber = pd.SAPAccountNumber 
	and d.Sequence = pd.Sequence and d.InValidatedBatchID is NULL
	LEFT JOIN Operation.StoreDelivery sd on sd.SAPAccountNumber = pd.SAPAccountNumber and sd.DeliveryDate = pd.DispatchDate
	Where @DispatchDate = pd.DispatchDate
	And pd.MerchGroupID = @MerchGroupID
	AND a.Active= 1
	Union
	Select @DispatchDate, @MerchGroupID, '' SAPAccountNumber, '' AccountName, RouteID, RouteName, -1 Sequence, '' GSN, '+ Add' FirstName, 'Merchandiser' LastName, GetDate() LastModified, null LastModifiedBy,  '' AbsoluteURL
	 ,'' CheckInGSN, '' ActualArrival
	From Planning.Route
	Where MerchGroupID = @MerchGroupID
	And RouteID Not In (
		Select Distinct RouteID
		From Planning.PreDispatch
		Where DispatchDate = @DispatchDate --@DispatchDate
		And MerchGroupID = @MerchGroupID--@MerchGroupID
	)
	)T
	Order by RouteID, Sequence

	---Get the count of promotions that needs to be displayed by sapaccountnumber
	select b.SAPAccountNumber,Count(distinct PromotionID) as DisplayTaskCount into #DisplayCount 
	from [Operation].[DisplayBuild] b
	INNER JOIN #DipatchTable d ON b.SAPAccountNumber = d.SAPAccountNumber
	where @DispatchDate>=ProposedStartDate and  @DispatchDate<=ProposedEndDate and BuildDate is null	
	and b.RequiresDisplay = 1 and b.PromotionExecutionStatusID = 2
	group by b.SAPAccountNumber

	Select t.*,isNULL(d.DisplayTaskCount,0) as DisplayTaskCount 
	from #DipatchTable t
	Left JOIN #DisplayCount d ON t.SAPAccountNumber = d.SAPAccountNumber
	Order by t.RouteID, t.Sequence

	
	-- Last Scheduled Date
	SELECT isnull(Count([ReleaseTime]),0) as ScheduleDateCount	
  FROM [Planning].[DispatchBatch] d
  Inner Join [Setup].[Person] p On p.GSN = d.ReleaedBy
  Where merchgroupid = @MerchGroupID and dispatchdate=@DispatchDate
  


