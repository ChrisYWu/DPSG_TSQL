Use Merch
Go

Select b.SAPBranchID, b.BranchName, a.*
From SAP.Account a
Join SAP.Branch b on a.BranchID = b.BranchID
Where SAPAccountNumber in (12268689,11278662,11278635,11303382,11292723)

Select *
From Setup.UserLocation
Where GSN = 'GUPPX008'
Order By SAPBranchID

Select mg.GroupName, a.AccountName, s.*
From Setup.Store s
Join Setup.MerchGroup mg on s.MerchGroupID = mg.MerchGroupID
Join SAP.Account a on s.SAPAccountNumber = a.SAPAccountNumber
Where s.SAPAccountNumber in (12268689,11278662,11278635,11303382,11292723)
Order By SAPAccountNumber

Exec Operation.pGetMerchStoreDelivery @DeliveryDate='2018-06-13', 
							@SAPAccountNumber='12268689,11278662,11278635,11303382,11292723', 
							@IsDetailNeeded=0, 
							@Debug=0

exec Planning.pGetPreDispatch @MerchGroupID = 28, @DispatchDate = '2018-06-13', @GSN = 'System'