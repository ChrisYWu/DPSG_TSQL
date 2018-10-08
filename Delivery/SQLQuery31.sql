use Portal_Data
Go

Select b.BranchName, b.SAPBranchID, *
From Person.UserProfile up
Join SAP.Branch b on up.PrimaryBranchID = b.BranchID
Where LastName = 'Gomez' And FirstName = 'Anthony'

--This is the one we what in Chico
--GOMAX515
--Merchandiser

use Merch
Go

Select *
From Setup.MerchGroup
Where SAPBranchID = 1132

Select d.*, a.AccountName, GroupName
From Planning.Dispatch d
Join Setup.MerchGroup mg on d.MerchGroupID = mg.MerchGroupID
Join SAP.Account a on d.SAPAccountNumber = a.SAPAccountNumber
Where DispatchDate = Convert(Date, GetDate())
And mg.SAPBranchID = 1132
And InvalidatedBatchID is null
And GSN = 'GOMAX515'
Order By Sequence


