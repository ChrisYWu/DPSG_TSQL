use Merch
go

Select *
from SEtup.Person
Where Lastname = 'Ellis'

Select *
from SEtup.Person
Where Lastname = 'Jones'



Select *
From Operation.MerchStopCheckIn
Where GSN = 'JONDX063'
And DispatchDate = '2018-07-05'



Select *
From Planning.Dispatch
Where GSN = 'JONDX063'
And DispatchDate = '2018-07-05'
Order By Sequence

Select *
From Planning.Dispatch
Where GSN = 'JONDX063'
And DispatchDate = '2018-07-05'
Order By Sequence

Select *
From SEtup.Person
Where GSN = 'WASNT001'

Select *
From SEtup.UserLocation
Where GSN = 'WASNT001'

Select *
From SAP.Branch
Where sAPBranchID = '1103'
