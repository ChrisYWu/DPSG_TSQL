use Merch
Go

Select *
From Setup.MerchGroup
Where GroupName = 'Northlake 5'

Select Distinct Convert(varchar(20), SAPAccountNumber) + ','
From Planning.Predispatch
Where MerchGroupID = 128
And DispatchDate = Convert(Date, GetDate())
And SAPAccountNumber > -1



