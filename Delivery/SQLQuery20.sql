USE [Merch]
GO

If Exists (Select * From sys.procedures Where Name = 'pLoadDeliverySchedulePeriodically')
Begin
	Drop Proc ETL.pLoadDeliverySchedulePeriodically
	Print '* ETL.pLoadDeliverySchedulePeriodically'
End 
Go

----------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec [ETL].[pLoadDeliverySchedulePeriodically]

exec [ETL].[pLoadDeliverySchedulePeriodically] @DispatchDate = '2018-01-20'

*/

Create Proc [ETL].[pLoadDeliverySchedulePeriodically]
(
	@DispatchDate Datetime = null
)
As
	SET NOCOUNT ON;  
	Declare @Query varchar(1024)

	If @DispatchDate is null
		Set @DispatchDate = GetDate()

	--Set @Query = 'Insert Into Staging.RNDeliverySchedule Select * From OpenQuery(' 
	Set @Query = 'Select * From OpenQuery(' 
	Set @Query += 'RN' +  ', ''';
	Set @Query += ' SELECT  R.*
					FROM TSDBA.RS_ROUTE R
					WHERE TO_CHAR(R.START_TIME, ''''YYYY-MM-DD'''') = ';
	Set @Query += ' ' + dbo.[udfConvertToPLSqlTimeFilter](@DispatchDate)
	Set @Query += ' AND RowNum < 10 ';
	Set @Query += ''')'	
	--Select @Query
	Exec(@Query)






	--Truncate Table Staging.RNDeliverySchedule 

	----Set @Query = 'Insert Into Staging.RNDeliverySchedule Select * From OpenQuery(' 
	--Set @Query = 'Select * From OpenQuery(' 
	--Set @Query += 'RN' +  ', ''';
	--Set @Query += ' SELECT  S.LOCATION_REGION_ID SALESOFFICE_ID, S.LOCATION_ID ACCOUNT_NUMBER, 
	--				R.DRIVER1_ID, E.FIRST_NAME DRIVER_FNAME, E.LAST_NAME DRIVER_LNAME, E.WORK_PHONE_NUMBER DRIVER_PHONE_NUM, 
	--				S.ARRIVAL, R.START_TIME, R.DATE_MODIFIED
	--				FROM TSDBA.RS_ROUTE R, TSDBA.RS_STOP S, TSDBA.TS_EMPLOYEE E     
	--				WHERE TO_CHAR(R.START_TIME, ''''YYYY-MM-DD'''') = ';
	--Set @Query += ' ' + dbo.[udfConvertToPLSqlTimeFilter](@DispatchDate)
	--Set @Query += ' AND S.RN_SESSION_PKEY = R.RN_SESSION_PKEY      
	--				AND S.ROUTE_PKEY = R.PKEY       
	--				AND S.SEQUENCE_NUMBER != -1      
	--				AND R.DRIVER1_ID = E.ID 
	--				AND RowNum < 10 ';
	--Set @Query += ''')'	
	----Select @Query
	--Exec(@Query)

Go
