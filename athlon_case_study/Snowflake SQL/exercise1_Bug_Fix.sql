with
dimdate as 
(
    select * from 
    (
        values
      (DATE('2021-12-30'),DATE('2021-12-29')),
      (DATE('2021-12-29'),DATE('2021-12-28')),
      (DATE('2021-12-28'),DATE('2021-12-27')),
      (DATE('2021-12-27'),DATE('2021-12-26')),
      (DATE('2021-12-26'),DATE('2021-12-25'))

        ) as a (date,load_date) where  date =DATE('2021-12-29')
),

DS_S_BE_ATLAS_REL as 
(
    select * from 
    (
        values
      (1,DATE('2021-12-29'),DATE('2021-12-30'),NULL,CAST('2021-12-29 17:54:12.000' as timestamp),'D'),
      (2,DATE('2021-12-28'),DATE('2021-12-29'),NULL,CAST('2021-12-28 15:54:12.000' as timestamp),'U'),
      (3,DATE('2021-12-27'),DATE('2021-12-28'),NULL,CAST('2021-12-27 15:54:12.000' as timestamp),'D'),
      (1,DATE('2021-12-26'),DATE('2021-12-27'),NULL,CAST('2021-12-26 16:54:12.000' as timestamp),'U'),
      (1,DATE('2021-12-25'),DATE('2021-12-26'),CAST('2021-12-25 12:54:12.000' as timestamp),NULL,'I'),
      (2,DATE('2021-12-25'),DATE('2021-12-26'),CAST('2021-12-25 12:54:12.000' as timestamp),NULL,'I'),
      (3,DATE('2021-12-25'),DATE('2021-12-26'),CAST('2021-12-25 12:54:12.000' as timestamp),NULL,'I')

        ) as a (nr,dss_start_date,dss_end_date,dss_insert_time,dss_update_time,dss_crud)
)

select *
from 
(
select  row_number() over (PARTITION by nr order by ifnull(dss_update_time,'1800-01-01') desc) as rownum, 
 * 
from DS_S_BE_ATLAS_REL rel
inner join dimdate dd on --dd.load_date between dss_start_date and dss_end_date
 dd.load_date >= rel.dss_start_date and dd.load_date < rel.dss_end_date
)
where rownum = 1 and dss_crud != 'D'
