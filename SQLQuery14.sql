USE [Portal_Data]
GO
/****** Object:  StoredProcedure [PreCal].[pReMapBCPromotions5]    Script Date: 6/7/2018 10:57:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Proc [PreCal].[pReMapBCPromotions5]
(
	@BackToDate Date = null,
	@Debug bit = 0
)
AS
Begin
	Set NoCount On;

	If (@BackToDate is null)
	Begin
		Set @BackToDate = DateAdd(Year, -100, GetDate())
	End

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BackToDate BackToDate
	End

	--- GeoRelevancy Expansion with Date Cut
	Create Table #PromoGeoR
	(
		PromotionID int,
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int, 
		BottlerID int, 
		StateID int, 
		HierDefined int,   --- Hierachy Defined 
		StateDefined int,  --- StateDefined
		--DSDHierDefined int,  --- DSDHierDefined
		TYP int			   --- State Transalation Status
	)

	Insert Into #PromoGeoR
	Select pgr.PromotionID, SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, StateID, 
		Case When (Coalesce(		
			Case When SystemID = 0 Then Null Else SystemID End, 
			Case When ZoneID = 0 Then Null Else ZoneID End, 
			Case When DivisionID = 0 Then Null Else DivisionID End, 
			Case When BCRegionID = 0 Then Null Else BCRegionID End, 
			Case When BottlerID = 0 Then Null Else BottlerID End, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		--Case When (Coalesce(		
		--	Case When BUID = 0 Then Null Else BUID End, 
		--	Case When RegionID = 0 Then Null Else RegionID End, 
		--	Case When BranchID = 0 Then Null Else BranchID End, 
		--	Case When AreaID = 0 Then Null Else AreaID End, 0) > 0) Then 1 Else 0 End DSDHierDefined, 
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where rp.PromotionEndDate > @BackToDate
	And (
		Coalesce(		
			Case When SystemID = 0 Then Null Else SystemID End, 
			Case When ZoneID = 0 Then Null Else ZoneID End, 
			Case When DivisionID = 0 Then Null Else DivisionID End, 
			Case When BCRegionID = 0 Then Null Else BCRegionID End, 
			Case When BottlerID = 0 Then Null Else BottlerID End, 
			Case When StateID = 0 Then Null Else StateID End, 0) > 0
	)

	If (@Debug = 1)
	Begin
		Select '---- Creating #PromoGeoR Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfGeoRelevancy From #PromoGeoR
	End

	-- 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All BC Promotion For StateOnly
	Update pgr
	Set TYP = Case When t.HierP > 0 And t.StateP > 0 Then 2 
				   When t.HierP > 0 Then 3 
				   When t.StateP > 0 Then 4 
				   Else 5 End
	From #PromoGeoR pgr
	Join (
	Select PromotionID, Sum(HierDefined) HierP, Sum(StateDefined) StateP
	From #PromoGeoR
	Group By PromotionID) t on pgr.PromotionID = t.PromotionID

	-------------------------------------
	Delete #PromoGeoR
	Where PromotionID in 
	(
		Select Distinct PromotionID
		From Playbook.PromotionGeoRelevancy 
		Where 
			Coalesce(		
				Case When BUID = 0 Then Null Else BUID End, 
				Case When RegionID = 0 Then Null Else RegionID End, 
				Case When BranchID = 0 Then Null Else BranchID End, 
				Case When AreaID = 0 Then Null Else AreaID End, 0) > 0 
	)
	And TYP = 4
	If (@Debug = 1)
	Begin
		Select '---- Reducing #PromoGeoR Table for True StateOnly(Non-DSD) done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfGeoRelevancy From #PromoGeoR
	End
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--

	Insert Into #PromoGeoR(PromotionID, SystemID, TYP)
	Select PromotionID, SystemID, 6
	From (Select Distinct SystemID From PreCal.BottlerHier) a,
	(Select Distinct PromotionID From #PromoGeoR Where TYP = 4) Temp

	Update #PromoGeoR
	Set TYP = 2
	Where TYP in (4,6)

	If (@Debug = 1)
	Begin
		Select '---- Promotion Classification done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		--- Only Valid Type for State is 2 and 3
		Select TYP, Count(*) CountOfPromotions 
		From (Select Distinct PromotionID, TYP From #PromoGeoR) temp 
		Group By TYP Order By TYP 
	End

	--->>>> This is where I stopped ----
	----- BTTLR driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		BottlerID int  not null
	)

	Create Clustered Index IDX_PGRforBC_PromotionID_BottlerID ON #PGR(PromotionID, BottlerID)

	-- Geo Hier Expansion
	Insert Into #PGR(PromotionID, BottlerID)
	Select Distinct pgr.PromotionID, v.BottlerID
	From #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.SystemID = v.SystemID
	Where TYP = 3
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.ZoneID = v.ZoneID
	Where TYP = 3 And pgr.SystemID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.DivisionID = v.DivisionID
	Where TYP = 3 And pgr.SystemID is null And pgr.ZoneID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	From #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.RegionID = v.RegionID
	Where TYP = 3 And pgr.SystemID is null And pgr.ZoneID is null and pgr.DivisionID is null
	Union
	Select Distinct pgr.PromotionID, pgr.BottlerID
	From #PromoGeoR pgr
	Where TYP = 3 And pgr.BottlerID is not null

	If (@Debug = 1)
	Begin
		Select '---- Type 2 Expanded ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBottlersForType2 From #PGR
	End

	-- State & Hier
	Insert Into #PGR(PromotionID, BottlerID)
	Select r.PromotionID, r.BottlerID
	From (
		Select Distinct pgr.PromotionID, v.BottlerID
		From #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.SystemID = v.SystemID
		Where TYP = 2
		Union
		Select Distinct pgr.PromotionID, v.BottlerID
		from #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.ZoneID = v.ZoneID
		Where TYP = 2 And Coalesce(pgr.SystemID, -1) = -1
		Union
		Select Distinct pgr.PromotionID, v.BottlerID
		from #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.DivisionID = v.DivisionID
		Where TYP = 2 And Coalesce(pgr.SystemID, pgr.ZoneID, -1) = -1
		Union
		Select Distinct pgr.PromotionID, v.BottlerID
		From #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.RegionID = v.RegionID
		Where TYP = 2 And Coalesce(pgr.SystemID, pgr.ZoneID, pgr.DivisionID, -1) = -1
		Union
		Select Distinct pgr.PromotionID, pgr.BottlerID
		From #PromoGeoR pgr
		Where TYP = 2 And Coalesce(pgr.BottlerID, -1) = -1
	) l
	Join (
		Select Distinct PromotionID, h.BottlerID
		From #PromoGeoR pgr
		Join PreCal.BottlerState h on pgr.StateID = h.StateRegionID
		Where TYP = 2) r On l.PromotionID = r.PromotionID And l.BottlerID = r.BottlerID
	
	If (@Debug = 1)
	Begin
		Select '---- All expansion(2 and 3) done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBottlersForType2And3 From #PGR
		--Select * From #PGR
	End

	--- Filtering
	--~~~~~~~~~~~~ Stage 3. Bottler Chain Trademark territoties correlation ~~~~~~~~--
	Select Distinct pgh.PromotionID, pgh.BottlerID, rci.RevRollupChainTypeID ChainGroupID
	Into #ReducedPGR
	From 
	#PGR pgh,
	(
		Select PromotionID, b.TrademarkID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.BrandID = b.BrandID)
		Union
		Select PromotionID, TrademarkID
		From Playbook.PromotionBrand With (nolock)) ptm,
	(
		Select PromotionID, LocalChainID
		From Playbook.PromotionAccount With (nolock) Where Coalesce(LocalChainID, 0) > 0
		Union
		Select PromotionID, lc.LocalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) Where Coalesce(pa.RegionalChainID, 0) > 0
		Union
		Select PromotionID, lc.LocalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join SAP.RegionalChain rc on pa.NationalChainID = rc.NationalChainID
		Join SAP.LocalChain lc on rc.RegionalChainID = lc.RegionalChainID Where Coalesce(pa.NationalChainID, 0) > 0
	) pc,
	BC.tBottlerChainTradeMark tmap With (nolock),
	MSTR.DimChainHier rci
	Where ptm.PromotionID = pgh.PromotionID
	And pc.PromotionID = pgh.PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.BottlerID = pgh.BottlerID
	And pc.LocalChainID = rci.LocalChainID

	If (@Debug = 1)
	Begin
		Select '---- Promo~Bottler relations after terrirory reduction ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromotions_ReducedByTerrirotyMap From #ReducedPGR
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	----- Commiting -----
	Begin Transaction
		Truncate Table PreCal.PromotionBottlerChainGroup

		Insert Into PreCal.PromotionBottlerChainGroup(BottlerID, RegionID, PromotionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
		Select pgr.BottlerID, s.RegionID, pgr.PromotionID, pgr.ChainGroupID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
		From #ReducedPGR pgr
		Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
		Join PreCal.BottlerHier s on pgr.BottlerID = s.BottlerID

		Truncate Table PreCal.PromotionRegionChainGroup

		Insert Into PreCal.PromotionRegionChainGroup(PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
		Select Distinct PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion
		From PreCal.PromotionBottlerChainGroup pb
	Commit Transaction

	If (@Debug = 1)
	Begin
		Select '---- Commiting done. That''s it ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) PromoBottlerCnt From PreCal.PromotionBottlerChainGroup
		Select Count(Distinct PromotionID) PromoCnt From PreCal.PromotionBottlerChainGroup
		Select Count(Distinct BottlerID) BottlerCnt From PreCal.PromotionBottlerChainGroup
		Select Min(PromotionEndDate) MinPromotionEndDate From PreCal.PromotionBottlerChainGroup

		Select Count(*) PromoRegionCnt From PreCal.PromotionRegionChainGroup
		Select Count(Distinct PromotionID) PromoCnt From PreCal.PromotionRegionChainGroup
		Select Count(Distinct RegionID) RegionCnt From PreCal.PromotionRegionChainGroup
		Select Min(PromotionEndDate) MinPromotionEndDate From PreCal.PromotionRegionChainGroup
	End

End

