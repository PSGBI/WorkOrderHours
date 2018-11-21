SELECT
  x.OpsDate,
  x.DateKey,
  x.WLSTRX,
  x.WLDOCO,
  x.WLDCTO,
  x.WLMMCU,
  x.WLMCU,
  x.WLOPSQ,
  x.WLOPST,
  x.WLTRT,
  x.WLTIMB,
  x.WLKIT,
  x.WLKITL,
  x.IMDSC1,
  x.IMDSC2,
  x.IMSRP1,
  x.IMSRP1d,
  x.IMPRP4,
  x.IMPRP4d,
  x.IMSRP4,
  x.IMSRP4d,
  x.IMSRP5,
  x.IMSRP5d,
  x.IMUOM1,
  x.WLUORG,
  x.WLSOQS,
  x.WLRUNM,
  x.WLRUNL,
  x.WLMACA,
  x.WLLABA,
  x.IRRUNM,
  x.IRRUNL,
  x.IRSETL,
  x.SETC,
  wcm.iwsetc/10 as IWSETC,
  wcm.IWPILC as WCType,
  CASE
    WHEN AvgCrew IS NULL OR
      AvgCrew = '' THEN SETC
    ELSE AvgCrew
  END AS AvgCrew
FROM (SELECT DISTINCT
  c.SQLDate AS OpsDate,
  c.DateKey,
  wor.WLSTRX,
  wor.WLDOCO,
  wor.WLDCTO,
  wor.WLMMCU,
  wor.WLMCU,
  wor.WLOPSQ,
  wor.WLOPST,
  wor.WLTRT,
  wor.WLTIMB,
  wor.WLKIT,
  wor.WLKITL,
  im.IMDSC1,
  im.IMDSC2,
  im.IMSRP1,
  s1.dimDesc1 AS IMSRP1d,
  im.IMPRP4,
  p4.dimDesc1 AS IMPRP4d,
  im.IMSRP4,
  s4.dimDesc1 AS IMSRP4d,
  im.IMSRP5,
  s5.dimDesc1 AS IMSRP5d,
  im.IMUOM1,
  wor.WLUORG,
  wor.WLSOQS,
  wor.WLRUNM,
  wor.WLRUNL,
  wor.WLMACA,
  wor.WLLABA,
  ISNULL(rm.IRRUNM, 0) AS IRRUNM,
  ISNULL(rm.IRRUNL, 0) AS IRRUNL,
  ISNULL(rm.IRSETL, 0) AS IRSETL,
  cs.SETC
FROM dbo.vF3112_WorkOrderRouting AS wor
LEFT OUTER JOIN dbo.F4801_WorkOrderMaster AS wom
  ON wom.WADOCO = wor.WLDOCO
  AND wom.WAMMCU = wor.WLMMCU
LEFT OUTER JOIN dbo.vF4101_ItemMaster AS im
  ON im.IMITM = wor.WLKIT
LEFT OUTER JOIN dbo.vF3003_RoutingMaster AS rm
  ON rm.IRKIT = wor.WLKIT
  AND rm.IRMMCU = wor.WLMMCU
  AND rm.IROPSQ = wor.WLOPSQ
  AND rm.IRTRT = wor.WLTRT
LEFT OUTER JOIN dbo.dimProductLevels AS s1
  ON s1.dimCode = im.IMSRP1
  AND s1.ProductLevel = 'SRP1'
LEFT OUTER JOIN dbo.dimProductLevels AS s4
  ON s4.dimCode = im.IMSRP4
  AND s4.ProductLevel = 'SRP4'
LEFT OUTER JOIN dbo.dimProductLevels AS s5
  ON s5.dimCode = im.IMSRP5
  AND s5.ProductLevel = 'SRP5'
LEFT OUTER JOIN dbo.dimProductLevels AS p4
  ON p4.dimCode = im.IMPRP4
  AND p4.ProductLevel = 'PRP4'
LEFT OUTER JOIN dbo.dim_Calendar AS c
  ON c.JulianDate = wor.WLSTRX
LEFT OUTER JOIN dbo.dim_CrewSize AS cs
  ON cs.MCU = wor.WLMCU
  AND cs.MMCU = wor.WLMMCU
WHERE (LEN(RTRIM(LTRIM(wor.WLMCU))) >= 5)) AS x
LEFT OUTER JOIN (SELECT
  workorder_id,
  operation,
  AVG(crew_size) AS AvgCrew
FROM dbo.vOPS_Seamless AS s
GROUP BY workorder_id,
         operation) AS cr
  ON cr.workorder_id = x.WLDOCO
  AND CAST(CONVERT(numeric, cr.operation) AS int) = x.WLOPSQ
left outer join F30006_WorkCenterMaster wcm on ltrim(rtrim(wcm.IWMMCU))=x.WLMMCU and ltrim(rtrim(wcm.IWMCU))=x.WLMCU
  