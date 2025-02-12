

select y.*
,y.STDCOMHRS-y.StandardMachine-y.StandardLabor as PlannedLaborWO
from

(select 
x.WLDOCO
,x.WLDCTO
,x.WLMMCU
,x.WLKIT
,x.WLKITL
,x.IMDSC1
,x.IMDSC2
,x.IMSRP1
,x.IMSRP1d
,x.IMPRP4
,x.IMPRP4d
,x.IMSRP4
,x.IMSRP4d
,x.WLOPSQ
,x.WLOPST
,x.OpsDate
,x.DateKey
,x.WLMCU
,x.WCType
,x.WLUORG
,x.WLSOQS
,x.IMUOM1
,x.WOHours
,x.ActHours
,x.WLTRT
,x.IRRUNM as RUNMACH
,x.IRRUNL as RUNLAB
,x.WLTIMB
,x.SETC as PlannedCrew
,x.AvgCrew as ActualCrew
,x.IRSETL as SETUP
, 
			(x.IRRUNM + x.IRRUNL)*x.WLUORG*
				(case when x.WLTIMB='U' then 1 
						when x.WLTIMB='1' then .1 
							when x.WLTIMB='2' then .01 
								when x.WLTIMB='3' then .001 
									when x.WLTIMB='4' then .0001 else 0 end )  as STDHRS
,(x.IRRUNM + x.IRRUNL)*x.WLSOQS*(
case when x.WLTIMB='U' then 1 
						when x.WLTIMB='1' then .1 
							when x.WLTIMB='2' then .01 
								when x.WLTIMB='3' then .001 
									when x.WLTIMB='4' then .0001 else 0 end) as STDCOMHRS
,StandardMachine
,StandardLabor
,ActualMachine
,ActualLabor
,ActualLaborWO
,PlannedMachine
,PlannedLabor
from 



(SELECT [OpsDate]
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
	  ,WCType
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
	,case when IMPRP4='LBR' then WLMACA+WLLABA else 0 end as ActualLaborWO
	,case when IRRUNM=0 or IMPRP4='LBR' then 0 else WLRUNM+WLRUNL end as PlannedMachine
	,case when IRRUNL=0 or IMPRP4='LBR' then 0 else WLRUNM+WLRUNL end as PlannedLabor
	
	
  FROM [PSG_Hub].[dbo].[vF55HRRPTA]
  ) x) y
 