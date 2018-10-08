

Select Count(*)
From Setup.MerchGroup mg
Join Planning.Route r on mg.merchgroupid = r.merchgroupid
Where SAPBranchID <> 1084

Select Distinct DefaultOwnerGSN
From Setup.MerchGroup 
Where SAPBranchID <> 1084

Select *
From SAP.Branch
Where SAPBranchID = '1084'

Select Count(*)
From Setup.Store s
Join Setup.MerchGroup mg on mg.MerchGroupID = s.MerchGroupID
Where SAPBranchID <> '1084'


