Use Portal_DAta
Go

Declare @PromotionID int
SEt @PromotionID = 144042

Select * From PreCal.PromotionBottlerChainGroup
Where PromotionID = @PromotionID


Select * From PreCal.PromotionRegionChainGroup
Where PromotionID = @PromotionID


USE Master
GO
SELECT * 
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
GO

