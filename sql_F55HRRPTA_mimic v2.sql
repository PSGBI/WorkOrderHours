 SELECT opsdate,
       datekey,
       wlstrx,
       wldoco,
       wldcto,
       wlmmcu,
       wlmcu,
       wlopsq,
       wlopst,
       WLTRT,
	   
       wlkit,
       wlkitl,
       imdsc1,
       imdsc2,
       imsrp1,
       imsrp1d,
       imprp4,
       imprp4d,
       imsrp4,
       imsrp4d,
       imsrp5,
       imsrp5d,
       imuom1,
       wluorg,
       wlsoqs,
       wlrunm,
       wlrunl,
       wlmaca,
       wllaba,
       irrunm,
       irrunl,
       irsetl,
       SETC
FROM   (SELECT DISTINCT c.sqldate            AS OpsDate,
                        c.datekey,
                        wor.wlstrx,
                        wor.wldoco,
                        wor.wldcto,
                        wor.wlmmcu,
                        wor.wlmcu,
                        wor.wlopsq,
                        wor.wlopst,
                        wor.WLTRT,
						
                        wor.wlkit,
                        wor.wlkitl,
                        im.imdsc1,
                        im.imdsc2,
                        im.imsrp1,
                        s1.dimdesc1          AS IMSRP1d,
                        im.imprp4,
                        p4.dimdesc1          AS IMPRP4d,
                        im.imsrp4,
                        s4.dimdesc1          AS IMSRP4d,
                        im.imsrp5,
                        s5.dimdesc1          AS IMSRP5d,
                        im.imuom1,
                        wor.wluorg,
                        wor.wlsoqs,
                        wor.wlrunm,
                        wor.wlrunl,
                        wor.wlmaca,
                        wor.wllaba,
                        Isnull(rm.irrunm, 0) AS IRRUNM,
                        Isnull(rm.irrunl, 0) AS IRRUNL,
                        Isnull(rm.irsetl, 0) AS IRSETL,
                        cs.SETC
        FROM   dbo.vf3112_workorderrouting AS wor
               LEFT OUTER JOIN dbo.f4801_workordermaster AS wom
                            ON wom.wadoco = wor.wldoco
                               AND wom.wammcu = wor.wlmmcu
               LEFT OUTER JOIN dbo.vf4101_itemmaster AS im
                            ON im.imitm = wor.wlkit
               LEFT OUTER JOIN dbo.vf3003_routingmaster AS rm
                            ON rm.irkit = wor.wlkit
                               AND rm.irmmcu = wor.wlmmcu
                               --AND rm.irmcu = wor.wlmcu
                               AND rm.iropsq = wor.wlopsq
                               AND rm.irtrt = wor.wltrt
               LEFT OUTER JOIN dbo.dimproductlevels AS s1
                            ON s1.dimcode = im.imsrp1
                               AND s1.productlevel = 'SRP1'
               LEFT OUTER JOIN dbo.dimproductlevels AS s4
                            ON s4.dimcode = im.imsrp4
                               AND s4.productlevel = 'SRP4'
               LEFT OUTER JOIN dbo.dimproductlevels AS s5
                            ON s5.dimcode = im.imsrp5
                               AND s5.productlevel = 'SRP5'
               LEFT OUTER JOIN dbo.dimproductlevels AS p4
                            ON p4.dimcode = im.imprp4
                               AND p4.productlevel = 'PRP4'
               LEFT OUTER JOIN dbo.dim_calendar AS c
                            ON c.juliandate = wor.wlstrx
			   left outer join dbo.dim_crewsize cs on cs.MCU=wor.WLMCU and cs.MMCU=wor.WLMMCU
        WHERE  ( Len(Rtrim(Ltrim(wor.wlmcu))) >= 5 )) AS x  
		