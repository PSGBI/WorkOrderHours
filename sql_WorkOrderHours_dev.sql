
with crew as (
SELECT
distinct

s.workorder_id as WLDOCO
,s.workcenter as WLMCU
,cast(convert(numeric,s.operation) as int) as WLOPSQ
,s.crew_size  as ActualCrewSize
FROM vOPS_Seamless s)

select 
r.[OpsDate]
      ,r.[DateKey]
      ,r.[WLSTRX]
      ,r.[WLDOCO]
      ,r.[WLDCTO]
      ,r.[WLMMCU]
      ,r.[WLMCU]
      ,r.[WLOPSQ]
      ,r.[WLOPST]
      ,r.[IRTRT]
      ,r.[WLKITL]
      ,r.[IMDSC1]
      ,r.[IMDSC2]
      ,r.[IMSRP1]
      ,r.[IMSRP1d]
      ,r.[IMPRP4]
      ,r.[IMPRP4d]
      ,r.[IMSRP4]
      ,r.[IMSRP4d]
      ,r.[IMSRP5]
      ,r.[IMSRP5d]
      ,r.[IMUOM1]
      ,r.[WLUORG]
      ,r.[WLSOQS]
      ,r.[RunMach]
      ,r.[RunLab]
      ,r.[Setup]
	  ,r.PlannedCrewSize
	  --,case when r.PlannedCrewSize is null or r.PlannedCrewSize='' then c.ActualCrewSize else r.PlannedCrewSize end as PlannedCrewSize
,c.ActualCrewSize
from vF55HRRPTA r left join crew c on  c.WLDOCO=r.WLDOCO
												and c.WLMCU=r.WLMCU
												and c.WLOPSQ=r.WLOPSQ
												where c.ActualCrewSize is  null or r.PlannedCrewSize is null
												