WITH CTE_Transfer AS (
    SELECT
        p1.neighborhood,
        COUNT(t1.pxfer_date) AS Transfer_Count
    FROM transfer AS t1
    JOIN TSBv_PARCELMASTER AS p1 ON t1.lrsn = p1.lrsn
    WHERE t1.pxfer_date > '20201231'
        AND t1.pxfer_date < '20240101'
        AND p1.EffStatus = 'A'
        AND p1.neighborhood <> '0'
    GROUP BY p1.neighborhood
)

SELECT
    CASE
        WHEN p.neighborhood IN (
            27,35,36,37,38,39,47,95,101,102,103,104,106,108,109,110,
            1001,1002,1003,1004,1005,1006,1007,1008,1010,1019,1410,1411,1412,1413,1420,1430,1440,1450,1460,1501,1502,1503,1504,1505,1506,1507,1511,1512,1513,1514,1515,1998,1999,
            2001,2010,2015,2105,2115,2125,2135,2145,2155,2201,2202,2203,2205,2206,2207,2210,2211,2212,2215,2216,2540,2996,2997,2998,2999,
            3502,3503,3504,3505,3506,3517,3523,3701,3702,3702,3998,3999,
            4018,4019,4020,4021,4201,4202,4203,4204,4833,4840,4997,4998,4999,
            5001,5004,5009,5010,5012,5015,5018,5020,5021,5024,5030,5033,5036,5039,5042,5045,5048,5051,5053,5054,5056,5057,5060,5063,5066,5069,5072,5075,5078,5081,5703,5750,5753,5756,5759,5762,5765,5850,5853,5856,
            6036,6100,6101,6102,6103,6104,6105,6106,6107,6108,6109,6110,6111,6112,6113,6114,6115,6116,6117,6118,6119,6120,6121,6122,6123,6130,
            9201,9202,9203,9205,9208,9209,9210,9214,9217,9219,9104,9111,9115,9119,1000,1020,5000,5002,6000,6002,9100
            ) THEN 'Year_1'
        WHEN p.neighborhood IN (
            1,2,15,16,17,33,
            1301,1302,1303,1304,1305,1601,1602,1603,1604,1605,1606,1607,1608,1609,1610,1611,1612,1613,1614,1615,1616,
            2051,2075,2501,2512,2515,2517,2518,2519,2520,2522,2524,
            3203,3204,3205,3220,3221,3270,3271,3280,3290,3507,3520,3535,
            4024,4029,4033,4034,4037,4039,4041,4042,4129,
            5700,5701,5800,5802,5803,5804,5805,5806,5820,5825,5868,5900,5901,5902,5903,5950,
            6027,6028,6030,6031,6060,6061,6062,6320,6320,6330,6340,6350,6360,6380,
            9204,9212,9213,9216,9218,9207,9220,9221,9223,9107,9109,9110,9113,9222,9117                  
            ) THEN 'Year_2'
        WHEN p.neighborhood IN (
            3,4,6,7,8,9,10,12,13,25,26,43,
            1101,1102,1103,1201,1211,1212,1251,1256,1260,1262,1264,1265,
            2503,2505,2507,2509,2514,2525,2526,2527,2528,2529,2552,2553,
            3009,3010,3020,3030,3040,3060,3090,3508,3509,3518,3519,3522,3740,3741,3742,3743,
            4022,4025,4030,4031,4032,4035,4036,4040,4044,4045,4046,4050,4051,4052,4060,4061,4062,4150,
            5300,5400,5401,5402,5403,5405,5406,5407,5420,5500,5501,5600,
            6024,6025,6026,6032,6034,6035,6039,6041,6044,6046,6048,6055,6056,6065,6066,6067,6070,6075,6076,
            9102,9103,9112,9118,9105,9106,9120,9108,9314,9305,9306,9312,9601
            ) THEN 'Year_3'
        WHEN p.neighborhood IN (
            14,18,19,20,21,22,23,24,28,29,30,31,32,34,40,44,45,
            1203,1205,1252,1253,1259,
            2040,2041,2055,2508,2510,2511,2513,2532,
            3230,3231,3242,3401,3410,3420,3427,3430,3435,3521,3524,3527,
            4001,4002,4003,4004,4005,4023,4026,4027,4028,4038,4047,4100,4214,
            5200,5201,5202,5203,5204,5205,5206,5207,5208,5209,5210,5211,5212,5216,5218,5228,5250,
            6450,6452,6453,6454,6455,6456,6457,6460,6461,6463,6465,
            9302,9303,9304,9307,9308,9309,9310,9311,9315,9404,9403,9412,9414,9407,9501,9503
            ) THEN 'Year_4'
        WHEN p.neighborhood IN (
            42,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,
            1202,1204,1250,1254,1255,1257,1801,1802,1803,1804,1805,1806,1807,1808,1809,1810,1811,1812,1813,1814,1816,1817,1818,1819,1820,1821,1822,1823,1824,1828,1829,1831,1832,1833,
            2020,2023,2025,2050,2060,2070,2550,2555,2801,2802,2803,2804,2805,2806,2807,2808,2810,2811,2813,2814,2815,
            3201,3202,3229,3510,3511,3512,3801,3802,3803,3804,3805,3806,3807,3808,3809,3810,3811,3812,3813,3814,3815,3816,3817,3818,3819,3820,3822,
            4006,4007,4008,4009,4010,4011,4012,4801,4802,4803,4804,4805,4806,4807,4808,4809,4810,4811,4812,4813,4814,4815,4816,4817,4818,4819,4820,4821,4822,4823,4824,4825,4826,4827,4828,4829,4830,4831,4832,4834,4835,4836,4837,4839,4841,4842,4843,4844,4846,4848,4849,4851,
            5100,5101,5110,5111,5112,5113,5114,
            6010,6012,6018,6021,6022,6023,6085,6200,6201,6801,6802,6803,6804,6805,
            9401,9405,9406,9409,9411,9413,9415,9416,9417,9418
            ) THEN 'Year_5'
        ELSE 'Other'
    END AS Reval_Year,
    p.neighborhood AS GEO,
    COUNT(p.neighborhood) AS Parcel_Count,
    ct.Transfer_Count
    
FROM TSBv_PARCELMASTER AS p
    FULL JOIN CTE_Transfer AS ct ON p.neighborhood = ct.neighborhood

WHERE p.EffStatus = 'A'
    AND p.neighborhood <> '0'

GROUP BY 
p.neighborhood,
ct.Transfer_Count

ORDER BY GEO