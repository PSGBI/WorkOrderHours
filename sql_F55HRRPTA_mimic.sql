
select * from
(SELECT distinct
  c.SQLDate AS OpsDate,
  c.DateKey,
  wor.WLSTRX,
  wor.WLDOCO,
  wor.WLDCTO,
  WLMMCU,
   WLMCU,
   WLOPSQ,
  wor.WLOPST,
  ISNULL(rm.IRTRT,
  '') AS IRTRT,
  wor.wlkit,
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
  ISNULL(rm.IRRUNM, 0) as IRRUNM,
  ISNULL(rm.IRRUNL, 0) as IRRUNL,
  ISNULL(rm.IRSETL, 0) as IRSETL,
  rm.IRSETC
  ,wor.WLSETC
FROM dbo.vF3112_WorkOrderRouting AS wor
LEFT OUTER JOIN dbo.F4801_WorkOrderMaster AS wom
  ON wom.WADOCO = wor.WLDOCO
  AND wom.WAMMCU = wor.WLMMCU
LEFT OUTER JOIN dbo.vF4101_ItemMaster AS im
  ON im.IMITM = wor.WLKIT
LEFT OUTER JOIN dbo.vF3003_RoutingMaster AS rm
  ON rm.IRKIT = wor.WLKIT
  AND rm.IRMMCU = wor.WLMMCU
  and rm.IRMCU=wor.WLMCU
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
WHERE (LEN(RTRIM(LTRIM(wor.WLMCU))) >= 5)
) x