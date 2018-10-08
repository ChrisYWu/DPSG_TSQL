use DSDDelivery
Go

Truncate Table Operation.Delivery
--Truncate Table Archive.Delivery


exec ETL.pLoadDeliveryPlanFromRN
exec ETL.pMergeDeliveryPlan
exec ETL.pProcessPlannedDelivery


Select *
From Operation.Delivery

--Select *
--From Staging.RNDeliveryPlan
--Where RNKey is null

--Where DriverID = '419053'
--order by arrivaltime


--Where Route_Number = '112401440'
--And ArrivalTime = '2017-02-21 12:00:00'
--And STOP_ID = 11241508
--And DriverID = 419053
--And Stop_Type = 'BranchStart'

--Where DriverID = 'F02'

--  (2017-02-21, 112401440, 2017-02-21 12:00:00, 1:BranchStart, 11241508, 419053).