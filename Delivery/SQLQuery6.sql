use Portal_Data
Go

select *
from (
Select * From OpenQuery(
	COP, 
	'
	SELECT 
	D.CNTRY_CODE, D.REGION_FIPS, D.REGION_ABRV, 
	D.REGION_NM, D.ROW_MOD_DT
	FROM CAP_DM.DM_REGION D 
	'
	)
) cop
	----------------------------------------
