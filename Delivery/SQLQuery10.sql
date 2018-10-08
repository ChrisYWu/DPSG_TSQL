use [DSDDelivery]
Go



	Select Distinct b.RMLocationID, b.BranchName, RouteNumber, RouteName
	From Operation.Delivery d
	Join Portal_Data.SAP.Route r On d.RouteNumber = r.SAPRouteNumber
	Join Portal_Data.SAP.Branch b on r.BranchID = b.BranchID
	Where 
	(
		(
			--@Inverse = 0
			--And
			RouteNumber not in
			(
				Select Distinct RouteNumber
				From Operation.Delivery
				Where StopType = '4:Break'
			)
		)
		--Or
		--(
		--	@Inverse = 1
		--	And
		--	RouteNumber in
		--	(
		--		Select Distinct RouteNumber
		--		From Operation.Delivery
		--		Where StopType = '4:Break'
		--	)
		--)
	)
	And DeliveryDate = Convert(Date, GetDate())
	Order By b.BranchName, RouteName, RouteNumber