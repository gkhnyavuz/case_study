with
CONTRACT_DETAIL  as 
(
    select * from 
    (
        values
      (1,DATE('2021-12-29'),'NL','EV'),
      (2,DATE('2021-12-28'),'NL','EV'),
      (3,DATE('2020-12-27'),'NL','EV'),
      (4,DATE('2019-12-26'),'NL','FV'),
      (5,DATE('2019-12-25'),'NL','EV'),
      (6,DATE('2018-12-25'),'BE','EV'),
      (7,DATE('2018-12-25'),'BE','EV'),
      (8,DATE('2018-12-25'),'NL','EV'),
      (9,DATE('2018-12-25'),'NL','EV')

        ) as a (IDCONTRACT,CONTRACTSTARTDATE,COUNTRYCODE,FUELTYPE)
),

A as 
(
      SELECT      COUNTRYCODE,
                  YEAR(CONTRACTSTARTDATE) AS YEAR,
                  FUELTYPE,
                  COUNT(*) EV_COUNT
      FROM        CONTRACT_DETAIL  
      GROUP BY    1,2,3
),

B as 
(
      SELECT      *, 
                  SUM(EV_COUNT) OVER(PARTITION BY YEAR,COUNTRYCODE) as VEHICLE_COUNT,
                  SUM(EV_COUNT) OVER(PARTITION BY YEAR)             as OVERALL_YEAR_VEHICLE_COUNT
      FROM        A  

)

SELECT YEAR,
COUNTRYCODE,
EV_COUNT,
VEHICLE_COUNT,
CAST(EV_COUNT / VEHICLE_COUNT * 100 AS NUMERIC(5,2))                   as EV_PERCENTAGE,
CAST(VEHICLE_COUNT / OVERALL_YEAR_VEHICLE_COUNT * 100 AS NUMERIC(5,2)) as EV_CONTRIBUTES_PERCENTAGE 
FROM B WHERE FUELTYPE = 'EV'
