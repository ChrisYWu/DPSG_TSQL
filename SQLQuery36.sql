use [Merch]
Go

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT datediff(second, Max(Date_Modified), Min(Date_Modified)), Max(Date_Modified), Min(Date_Modified)
  FROM [Merch].[Staging].[RS_STOP]