with rankAdmission as (
    select 
    subject_id, 
    hadm_id,
    admittime,
    hospital_expire_flag,
    ROW_NUMBER() over (Partition by subject_id order by subject_id,admittime desc) as RowNum
    from admissions
), 
latestAdmissions as (
    select subject_id, hadm_id, hospital_expire_flag
    from rankAdmission
    where RowNum = 1
    order by subject_id
) ,
icd_codes as (
    select t1.subject_id, t1.hadm_id, t1.hospital_expire_flag, t2.icd_code, t2.icd_version
    from latestAdmissions as t1 join diagnoses_icd as t2 
    on t1.subject_id = t2.subject_id and t1.hadm_id = t2.hadm_id   
) , 
meningitis as (
    select t1.subject_id, t1.hadm_id, t1.hospital_expire_flag
    from icd_codes as t1 join d_icd_diagnoses as t2
    on t1.icd_code = t2.icd_code and t1.icd_version = t2.icd_version and t2.long_title like '%Meningitis%'
) , 
includeGender as (
    select t1.subject_id, t1.hadm_id, t1.hospital_expire_flag, t2.gender
    from meningitis as t1 join patients as t2
    on t1.subject_id = t2.subject_id
) , 
males as (
    select gender, hospital_expire_flag
    from includeGender 
    where gender = 'M' 
) , 
malesMortality as (
    select
    gender, round(avg(hospital_expire_flag)*100, 2)   as "mortality_rate"
FROM
    males 
    group by gender
), 
females as (
    select gender, hospital_expire_flag
    from includeGender 
    where gender = 'F' 
) , 
femalesMortality as (
    select
    gender, round(avg(hospital_expire_flag)*100, 2)  as "mortality_rate"
FROM
    females 
    group by gender
)   

select *
from (select *
from malesMortality 
union 
select * 
from femalesMortality) as t
order by "mortality_rate", gender desc