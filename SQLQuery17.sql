USE [Merch]
GO
/****** Object:  StoredProcedure [Notify].[p0InitialMerchCall]    Script Date: 7/20/2018 1:50:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [Notify].[p0InitialMerchCall]
As

Delete Notify.StoreDeliveryMechandiser 
Where DeliveryDateUTC = Convert(Date, GetDate())

Insert Into Notify.StoreDeliveryMechandiser(DeliveryDAteUTC, SAPAccountNumber, PartyID, DepartureTime, KnownDepartureTime, IsEstimated)
Select Distinct d.DispatchDate, d.SAPAccountNumber,  
		--d.GSN, 
		--Case When d.GSN in ('LEAWG001', 'HAWAX504') Then 'WUXYX001' Else d.GSN End GSN, 
		'BINNX001' GSN, 
		Coalesce(ds.CheckOutTime, ds.EstimatedDepartureTime, 
		DateAdd(second, ds.ServiceTime, ds.PlannedArrival), 
		DateAdd(second, ps.ServiceTime, ps.PlannedArrival)) DepartueTime, 
		Coalesce(ds.CheckOutTime, ds.EstimatedDepartureTime, 
		DateAdd(second, ds.ServiceTime, ds.PlannedArrival), 
		DateAdd(second, ps.ServiceTime, ps.PlannedArrival)) KnownDepartueTime, 
	Case When ds.CheckOutTime is null Then 1 Else 0 End IsEstimated 
From DPSGSHAREDCLSTR.Merch.Planning.Dispatch d
Join DPSGSHAREDCLSTR.Merch.Setup.MerchGroup m on d.MerchGroupID = m.MerchGroupID
Left Join DPSGSHAREDCLSTR.Merch.Mesh.DeliveryStop ds on d.SAPAccountNumber = ds.SAPAccountNumber and ds.DeliveryDateUTC = d.DispatchDate
Left Join DPSGSHAREDCLSTR.Merch.Mesh.PlannedStop ps on d.SAPAccountNumber = ps.SAPAccountNumber and ps.DeliveryDateUTC = d.DispatchDate
Where SAPBranchID = 1120
And DispatchDate = Convert(Date, GetDate())
And InvalidatedBatchID is null

Insert Into Notify.StoreDeliveryTimeTrail
    (DeliveryDateUTC
    ,SAPAccountNumber
    ,DepartureTime
    ,IsEstimated
    ,ReportTimeLocal)
Select DeliveryDateUTC, SAPAccountNumber, DepartureTime, IsEstimated, GetDate() 
From Notify.StoreDeliveryMechandiser
Where DeliveryDateUTC = Convert(Date, GetDate())
