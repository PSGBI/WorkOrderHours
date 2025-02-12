

SELECT [OpsDate]
      ,[DateKey]
      ,[WLSTRX]
      ,[WLDOCO]
      ,[WLDCTO]
      ,[WLMMCU]
      ,[WLMCU]
      ,[WLOPSQ]
      ,[WLOPST]
      ,[WLTRT]
	  ,WLTIMB
      ,[WLKIT]
      ,[WLKITL]
      ,[IMDSC1]
      ,[IMDSC2]
      ,[IMSRP1]
      ,[IMSRP1d]
      ,[IMPRP4]
      ,[IMPRP4d]
      ,[IMSRP4]
      ,[IMSRP4d]
      ,[IMSRP5]
      ,[IMSRP5d]
      ,[IMUOM1]
      ,[WLUORG]
      ,[WLSOQS]
      ,[WLRUNM]
      ,[WLRUNL]
      ,[WLMACA]
      ,[WLLABA]
      ,[IRRUNM]
      ,[IRRUNL]
      ,[IRSETL]
      ,[SETC]
      ,[AvgCrew]
	  ,WLMACA+WLLABA as ActHours
	  ,WLRUNL+WLRUNM as WOHours
	  ,Case when IRRUNM = 0 or IMPRP4='LBR' then 0 else 
			(IRRUNM + IRRUNL)*WLSOQS*
				(case when wltimb='U' then 1 
						when wltimb='1' then .1 
							when wltimb='2' then .01 
								when wltimb='3' then .001 
									when wltimb='4' then .0001 else 0 end ) end as StandardMachine
	,Case when IRRUNL = 0 or IMPRP4='LBR' then 0 else 
			(IRRUNM + IRRUNL)*WLSOQS*
				(case when wltimb='U' then 1 
						when wltimb='1' then .1 
							when wltimb='2' then .01 
								when wltimb='3' then .001 
									when wltimb='4' then .0001 else 0 end ) end as StandardLabor
	,case when WCType='M' and IMPRP4<>'LBR' then WLMACA+WLLABA else 0 end as ActualMachine
	,case when WCType='L' and IMPRP4<>'LBR' then WLMACA+WLLABA else 0 end as ActualLabor
	,case when WCType='L' and IMPRP4='LBR' then WLMACA+WLLABA else 0 end as ActualLaborWO
	
  FROM [PSG_Hub].[dbo].[vF55HRRPTA]
  where WLDOCO=996709