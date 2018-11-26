SELECT
  WLDOCO,
  WLDCTO,
  WLMMCU,
  WLKIT,
  WLKITL,
  IMDSC1,
  IMDSC2,
  IMSRP1,
  IMSRP1d,
  IMPRP4,
  IMPRP4d,
  IMSRP4,
  IMSRP4d,
  WLOPSQ,
  WLOPST,
  OpsDate,
  DateKey,
  WLMCU,
  WCType,
  WLUORG,
  WLSOQS,
  IMUOM1,
  WOHours,
  ActHours,
  WLTRT,
  RUNMACH,
  RUNLAB,
  WLTIMB,
  PlannedCrew,
  ActualCrew,
  SETUP,
  STDHRS,
  STDCOMHRS,
  StandardMachine,
  StandardLabor,
  ActualMachine,
  ActualLabor,
  ActualLaborWO,
  PlannedMachine,
  PlannedLabor,
  STDCOMHRS - StandardMachine - StandardLabor AS PlannedLaborWO
FROM (SELECT
  WLDOCO,
  WLDCTO,
  WLMMCU,
  WLKIT,
  WLKITL,
  IMDSC1,
  IMDSC2,
  IMSRP1,
  IMSRP1d,
  IMPRP4,
  IMPRP4d,
  IMSRP4,
  IMSRP4d,
  WLOPSQ,
  WLOPST,
  OpsDate,
  DateKey,
  WLMCU,
  WCType,
  WLUORG,
  WLSOQS,
  IMUOM1,
  WOHours,
  ActHours,
  WLTRT,
  IRRUNM AS RUNMACH,
  IRRUNL AS RUNLAB,
  WLTIMB,
  SETC AS PlannedCrew,
  AvgCrew AS ActualCrew,
  IRSETL AS SETUP,
  (IRRUNM + IRRUNL)
  * WLUORG * (CASE
    WHEN x.WLTIMB = 'U' THEN 1
    WHEN x.WLTIMB = '1' THEN .1
    WHEN x.WLTIMB = '2' THEN .01
    WHEN x.WLTIMB = '3' THEN .001
    WHEN x.WLTIMB = '4' THEN .0001
    ELSE 0
  END) AS STDHRS,
  (IRRUNM + IRRUNL)
  * WLSOQS * (CASE
    WHEN x.WLTIMB = 'U' THEN 1
    WHEN x.WLTIMB = '1' THEN .1
    WHEN x.WLTIMB = '2' THEN .01
    WHEN x.WLTIMB = '3' THEN .001
    WHEN x.WLTIMB = '4' THEN .0001
    ELSE 0
  END)
  AS STDCOMHRS,
  StandardMachine,
  StandardLabor,
  ActualMachine,
  ActualLabor,
  ActualLaborWO,
  PlannedMachine,
  PlannedLabor
FROM (SELECT
  OpsDate,
  DateKey,
  WLSTRX,
  WLDOCO,
  WLDCTO,
  WLMMCU,
  WLMCU,
  WLOPSQ,
  WLOPST,
  WLTRT,
  WLTIMB,
  WLKIT,
  WLKITL,
  IMDSC1,
  IMDSC2,
  IMSRP1,
  IMSRP1d,
  IMPRP4,
  IMPRP4d,
  IMSRP4,
  IMSRP4d,
  IMSRP5,
  IMSRP5d,
  IMUOM1,
  WLUORG,
  WLSOQS,
  WLRUNM,
  WLRUNL,
  WLMACA,
  WLLABA,
  IRRUNM,
  IRRUNL,
  IRSETL,
  SETC,
  AvgCrew,
  WCType,
  WLMACA + WLLABA AS ActHours,
  WLRUNL + WLRUNM AS WOHours,
  CASE
    WHEN IRRUNM = 0 OR
      IMPRP4 = 'LBR' THEN 0
    ELSE (IRRUNM + IRRUNL)
      * WLSOQS * (CASE
        WHEN wltimb = 'U' THEN 1
        WHEN wltimb = '1' THEN .1
        WHEN wltimb = '2' THEN .01
        WHEN wltimb = '3' THEN .001
        WHEN wltimb = '4' THEN .0001
        ELSE 0
      END)
  END AS StandardMachine,
  CASE
    WHEN IRRUNL = 0 OR
      IMPRP4 = 'LBR' THEN 0
    ELSE (IRRUNM + IRRUNL)
      * WLSOQS * (CASE
        WHEN wltimb = 'U' THEN 1
        WHEN wltimb = '1' THEN .1
        WHEN wltimb = '2' THEN .01
        WHEN wltimb = '3' THEN .001
        WHEN wltimb = '4' THEN .0001
        ELSE 0
      END)
  END AS StandardLabor,
  CASE
    WHEN WCType = 'M' and
      IMPRP4 <> 'LBR' THEN WLMACA + WLLABA
    ELSE 0
  END AS ActualMachine,
  CASE
    WHEN WCType = 'L' and
      IMPRP4 <> 'LBR' THEN WLMACA + WLLABA
    ELSE 0
  END AS ActualLabor,
  CASE
    WHEN IMPRP4 = 'LBR' THEN WLMACA + WLLABA
    ELSE 0
  END AS ActualLaborWO,
  CASE
    WHEN IRRUNM = 0 OR
      IMPRP4 = 'LBR' THEN 0
    ELSE WLRUNM + WLRUNL
  END AS PlannedMachine,
  CASE
    WHEN IRRUNL = 0 OR
      IMPRP4 = 'LBR' THEN 0
    ELSE WLRUNM + WLRUNL
  END AS PlannedLabor
FROM dbo.vF55HRRPTA) AS x) AS y 