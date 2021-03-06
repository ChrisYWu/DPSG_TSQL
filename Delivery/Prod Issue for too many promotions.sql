USE [Merch]
GO

Drop Proc [Operation].[pGetDisplayBuildWithLatestStatusByRouteID1]
Go

/****** Object:  StoredProcedure [Operation].[pGetDisplayBuildWithLatestStatusByRouteID]    Script Date: 2/24/2017 9:29:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec Operation.pGetDisplayBuildWithLatestStatusByRouteID1 113801202, 1
exec Operation.pGetDisplayBuildWithLatestStatusByRouteID1 102700102
exec Operation.pGetDisplayBuildWithLatestStatusByRouteID 102700102

Select * From Operation.DisplayBuild

Note 20170223, Need to update Dev, INT, QA and eventually Prod
*/

Alter Proc [Operation].[pGetDisplayBuildWithLatestStatusByRouteID]
(
	@RouteNumber Int,
	@Debug bit = 0
)
AS
Begin
    Set NoCount On;
    Declare @RouteID Int, @ConfigPStartDate DateTime, @ConfigPEndDate DateTime

	Select @RouteID = RouteID
    From SAP.Route WITH (NOLOCK)
    Where SAPRouteNumber = @RouteNumber

	Select @ConfigPStartDate = DATEADD(DAY,
								(
									SELECT CONVERT( INT, value * -1)
									FROM BCMyDay.Config WITH (NOLOCK)
									WHERE [Key] = 'DSD_PROMOTION_DOWNLOAD_DURATION_PAST'
								), DateAdd(Day, -1, GetDate()));

	Select @ConfigPEndDate = DATEADD(DAY,
								(
									SELECT CONVERT( INT, value)
									FROM BCMyDay.Config WITH (NOLOCK)
									WHERE [Key] = 'DSD_PROMOTION_DOWNLOAD_DURATION_FUTURE'
								), GetDate());

	If @Debug = 1
	Begin
		Select '--Routes--' Debug
		Select @ConfigPStartDate, @ConfigPEndDate
	End

	------------------------------
	Declare @RouteIDs Table
	(
		RouteID int
	)

	Insert Into @RouteIDs Values (@RouteID)
	Insert Into @RouteIDs
    Select RouteID
    From SAP.Route
    Where SalesGroup IN
    (
        Select SalesGroup
        From SAP.Route
        Where RouteID = @RouteID
        And DISPLAYAllowance = 1
        And SalesGroup NOT IN
        (
            SELECT SalesGroupID
            FROM SAP.RouteSalesGroupExclusion WITH (NOLOCK)
        )
        And IsNull(Active, 0) = 1
    )
    And IsNull(Active, 0) = 1

	If @Debug = 1
	Begin
		Select '--Routes--' Debug
		Select *
		From @RouteIDs
	End
	---------------------------------------

	Declare @PromotionIDs Table
	(
		PromotionID int
	)

	Insert Into @PromotionIDs
	Select Distinct pb.PromotionID
	From PreCal.PromotionBranch pb
	Join SAP.Route r on pb.BranchID = r.BranchID
	Join @RouteIDs rt on r.RouteID = rt.RouteID
	Join SAP.RouteSchedule rs on r.RouteID = rs.RouteID
	Join SAP.Account a on rs.AccountID = a.AccountID
	Join PreCal.PromotionLocalChain pcl on pcl.PromotionID = pb.PromotionID And a.LocalChainID = pcl.LocalChainID
	Where pb.PromotionStartDate < @ConfigPEndDate
	And pb.PromotionEndDate > @ConfigPStartDate

	If @Debug = 1
	Begin
		Select '--Promotions--' Debug
		Select *
		From @PromotionIDs
	End

	---------------------------------------------------------------------
	Select db.DisplayBuildID, db.SAPAccountNumber, rp.PromotionID, rp.PromotionName, rp.PromotionDescription, db.DisplayLocationID, db.DisplayTypeID, db.RequiresDisplay, db.LastModifiedBy DisplayBuildLastModifiedBy,
			CONVERT(VARCHAR(10), db.ProposedStartDate, 126) ProposedStartDate, CONVERT(VARCHAR(10), db.ProposedEndDate, 126) ProposedEndDate, 
			db.BuildInstruction, 
			ab.RelativeURL, ab.AbsoluteURL, abc.StorageAccount, abc.Container, abc.AccessLevel, abc.ConnectionString,
			db.InstructionImageName,
			dbe.ClientTime, dbe.ClientTimeZone, dbe.ClientAppSource, dbe.GSN ExecutionGSN, dbe.BuildStatusID, dbe.DisplayLocationID ExecutionDisplayLocationID, dbe.DisplayTypeID ExecutionDisplayTypeID, dbe.BuildRefusalReasonID, 
			dbe.BuildNote, 
			abe.RelativeURL ExecRelativeURL, abe.AbsoluteURL ExecAbsoluteURL, abce.StorageAccount ExecStorageAccount, 
			abce.Container ExecContainer, abce.AccessLevel ExecAccessLevel, abce.ConnectionString ExecConnectionString,	dbe.ImageName
	From Operation.DisplayBuild db
	Join @PromotionIDs vp on vp.PromotionID = db.PromotionID
	Join Playbook.RetailPromotion rp on db.PromotionID = rp.PromotionID
	Join SAP.Account a on db.SAPAccountNumber = a.SAPAccountNumber
	Join SAP.RouteSchedule rs on rs.AccountID = a.AccountID
	Join @RouteIDs rt on rs.RouteID = rt.RouteID 
	Left Join Operation.DisplayBuildExecution dbe on dbe.DisplayBuildExecutionID = db.LatestExecutionID
	Left Join Merch.Operation.AzureBlobStorage ab on db.InstructionImageBlobID = ab.BlobID
	Left Join Merch.Setup.AzureBlobContainer abc on ab.ContainerID = abc.ContainerID
	Left Join Merch.Operation.AzureBlobStorage abe on dbe.ImageBlobID = abe.BlobID
	Left Join Merch.Setup.AzureBlobContainer abce on abe.ContainerID = abce.ContainerID
	---------------------------------------------------------------------

End

Go

