USE Merch
GO

If Exists (Select * From sys.procedures Where Name = 'pUploadRouteCheckout')
Begin
	Drop Proc Mesh.pUploadRouteCheckout
	Print '* Mesh.pUploadRouteCheckout'
End 
Go

----------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec Mesh.pUploadRouteCheckout @DeliveryDateUTC = '2018-02-15', @RouteID = 110901504
exec Mesh.pUploadRouteCheckout @RouteID = 110901504

{ 
	DeliveryDateUTC: "2018-02-15T00:00:00", 
	RouteID: 110901599,
	ActualStartTime: "2018-02-21T18:10:30",
	ActualStartGSN: "WUXYX002",
	FirstName: "Chris",
	LastName: "Wu",
	PhoneNumber: "972-333-0000",
	Latitude: 42.595788,
	Longitude: -94.998123,
	LastModifiedUTC: "2018-02-21T18:25:07"
}

*/


Create Proc Mesh.pUploadRouteCheckout
(
	@RouteID int,
	@ActualStartTime DateTime,
	@ActualStartGSN varchar(50),
	@FirstName varchar(50),
	@LastName varchar(50),
	@PhoneNumber varchar(50),
	@Latitude decimal(10, 7),
	@Longitude decimal(10, 7),
	@DeliveryDateUTC date = null,
	@LastModifiedUTC datetime2(0) = null
)
As
    Set NoCount On;

	Declare @OutputMessage varchar(100)
		
	If @DeliveryDateUTC is null
		Set @DeliveryDateUTC = convert(date, GetUTCDate())

	If @LastModifiedUTC is null
		Set @LastModifiedUTC = @ActualStartTime

	If Exists (Select DeliveryRouteID From Mesh.DeliveryRoute Where RouteID = @RouteID and @DeliveryDateUTC = DeliveryDateUTC)
	Begin
		Update Mesh.DeliveryRoute
			Set ActualStartTime = @ActualStartTime,
				ActualStartGSN = @ActualStartGSN,
				ActualStartFirstname = @FirstName,
				ActualStartLastName	= @LastName,
				ActualStartPhoneNumber = @PhoneNumber,
				ActualStartLatitude = @Latitude,
				ActualStartLongitude = @Longitude,
				LastModifiedBy = @ActualStartGSN,
				LastModifiedUTC = @LastModifiedUTC,
				LocalSynctime = GetDate()
		Where RouteID = @RouteID and @DeliveryDateUTC = DeliveryDateUTC
		Set @OutputMessage = 'OK'
	End
	Else 
	Begin
		Declare @DateString varchar(20)
		Set @DateString = Convert(varchar(20), @DeliveryDateUTC)
		RAISERROR (N'[ClientDataError]{Mesh.pUploadRouteCheckout}: No route found for @RouteID=%i and @DeliveryDateUTC=%s', -- Message text.  
           16, -- Severity,  
           1, -- State,  
           @RouteID, -- First argument.  
           @DateString); -- Second argument.  
	End

GO

Print 'Mesh.pUploadRouteCheckout created'
Go

--
exec Mesh.pUploadRouteCheckout @DeliveryDateUTC = '2018-02-15', @RouteID = 110901599,
	@ActualStartTime = '2018-02-21 18:09:30',
	@ActualStartGSN = 'WUXYX002',
	@FirstName = 'Chris',
	@LastName = 'Wu',
	@PhoneNumber = '972-333-0000',
	@Latitude = 42.595700,
	@Longitude = -94.998000,
	@LastModifiedUTC = '2018-02-21 18:10:44'
--exec Mesh.pUploadRouteCheckout @RouteID = 110901599,
--	@ActualStartTime = '2018-02-21 18:09:30',
--	@ActualStartGSN = 'WUXYX002',
--	@FirstName = 'Chris',
--	@LastName = 'Wu',
--	@PhoneNumber = '972-333-0000',
--	@Latitude = 42.595700,
--	@Longitude = -94.998000,
--	@LastModifiedUTC = '2018-02-21 18:10:44'

--exec Mesh.pUploadRouteCheckout @RouteID = 102000451,
--	@ActualStartTime = '2018-02-21 18:09:30',
--	@ActualStartGSN = 'WUXYX002',
--	@FirstName = 'Chris',
--	@LastName = 'Wu',
--	@PhoneNumber = '972-333-0000',
--	@Latitude = 42.595700,
--	@Longitude = -94.998000,
--	@LastModifiedUTC = '2018-02-21 18:10:44'

--exec Mesh.pUploadRouteCheckout @RouteID = 110901504
--exec Mesh.pUploadRouteCheckout @RouteID = 102000451
--exec Mesh.pUploadRouteCheckout @RouteID = 101600004

