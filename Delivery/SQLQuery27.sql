
SELECT a.accountname, d.DispatchID, d.sequence,d.SAPAccountNumber,d.BatchID,d.InvalidatedBatchID, d.LastModified, d.LastModifiedBy, d.GSN
  FROM [Merch].[Planning].[Dispatch] d
  join portal_Data.sap.account a on a.sapaccountnumber = d.SAPAccountNumber
  where routeid=3051 and merchgroupid=297 and dispatchdate='2018-03-30';

  select *
  from setup.merchgroup
  where merchgroupid = 297

  select *
  from sap.branch
  where sapbranchID = '1094'


  Select *
  From Operation.GSNActivityLog
  Where GSN = 'BROJX564'
  And  operationdate='2018-03-30'
  order by clienttime
