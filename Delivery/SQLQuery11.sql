use Portal_Data
Go
 
Declare @startdate as date
Declare @enddate as date
 
Select @startdate = DateAdd(day, -5 - DatePart(dw, Convert(Date, GetDate())), Convert(Date, GetDate()))
Select @enddate = DateAdd(Day, 7, @startdate)

--set @startdate = '2016-11-01'
--set @enddate = '2016-11-07'
 
Select @StartDate StartDate, DateAdd(Day, -1, @EndDate) EndDate, @@SERVERNAME Server

Declare @ExceptionCount int
 
select @ExceptionCount = count(username)
from Shared.ExceptionLog
where
LastModified >= @startdate -- Monday of the week
and LastModified <= @enddate  -- Sunday of the week
and not detail like 'Claim Provider Trace:%' and Source not like 'BMCC%' 

Declare @TotalCount int
 
select @TotalCount = count(CreatedBy) 
from Playbook.RetailPromotion
where
CreatedDate >= @startdate -- Monday of the week 
and CreatedDate <= @enddate  -- Sunday of the week 

Select @StartDate StartDate, DateAdd(Day, -1, @EndDate) EndDate, @ExceptionCount ExceptionCount, @TotalCount TotalCount  
-- Details from Exception table

select @StartDate StartDate, DateAdd(Day, -1, @EndDate) EndDate, Source, detail, detail detail1, count(*)
from Shared.ExceptionLog
where 
LastModified >= @startdate -- Monday of the week
and LastModified <= @enddate  -- Sunday of the week
and not detail like 'Claim Provider Trace:%' and Source not like 'BMCC%' 
--and not detail like 'Error occurred in formating priorities: Unable to get property%'
group by Source, detail
order by Source, detail
