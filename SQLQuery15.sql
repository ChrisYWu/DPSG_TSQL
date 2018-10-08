select  aa.Description 
,z.DBE
,z.DisplayBuildID
,case when DBE>1 then Max(StatusDate) else StatusDate end as StatusDate
  FROM 
  (select distinct a.[DisplayBuildID], count(b.DisplayBuildExecutionID)as DBE, max(buildstatusdate)StatusDate, Max(BuildStatusID)StatusID
  from [Merch].[Operation].[DisplayBuild] a with (nolock) 
  join [Merch].[Operation].[DisplayBuildExecution] b with (nolock) on a.displaybuildid = b.displaybuildid  
  where  proposedstartdate between '2018-01-01'and '2018-06-26'
  group by a.displaybuildid
  )z

  join [Merch].[Operation].[DisplayBuildStatus] aa with (nolock) on z.StatusID = aa.BuildStatusID 
  group by  z.dbe, z.DisplayBuildID, z.statusDate, aa.description

Select *
From Merch.Operation.DisplayBuild
where  proposedstartdate between '2018-01-01'and '2018-06-26'

Select *
From [Merch].[Operation].[DisplayBuildExecution]