/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct [DeletedOn]
  FROM [Merch].[Archive].[Planning_Dispatch]
  order by DeletedOn desc


use merch
go

select datediff(day, getdate(), min(DispatchDate))
from planning.dispatch



select *
from setup.merchgroup

exec [Planning].[pGetMornitoringLanding] @MerchGroupID = 7, @DispatchDAte = '2018-01-23', @SearchPhrase=''

