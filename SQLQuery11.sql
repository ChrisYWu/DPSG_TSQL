/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [PartyID]
      ,[Phone]
      ,[Email]
      ,[Role]
      ,[TimeZoneOffset]
  FROM [Merch].[Notify].[Party]
  Where partyID = 'ALVLX013'