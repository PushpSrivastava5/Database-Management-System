with procedureWithAdmission AS (
    select subject_id, hadm_id, icd_code, icd_version
    from procedures_icd
), combineSubject AS (                                                -- # stores all the admissions along with time spent in icu 
    select subject_id, hadm_id, COALESCE(SUM(los), 0) AS clubIcuStays 
    from icustays
    group BY subject_id, hadm_id
), combine AS (
    select t1.subject_id, t1.hadm_id, t1.icd_code, t1.icd_version, COALESCE(t2.clubIcuStays, 0) AS clubIcuStays
    from procedureWithAdmission AS t1
    left join combineSubject AS t2
    ON t1.subject_id = t2.subject_id AND t1.hadm_id = t2.hadm_id 
), combineProcedure as (
    select icd_code, icd_version, avg(clubIcuStays) as average
    from combine
    group by icd_code, icd_version
    order by icd_code, icd_version 
), includeProcedure as (
    select t1.subject_id, t1.hadm_id,t1.icd_code, t1.icd_version, t2.clubIcuStays -- # admission with icd_code and icd_version, icu stay in that admission 
    from combineSubject as t2 join procedures_icd as t1
    on t2.subject_id = t1.subject_id and t2.hadm_id = t1.hadm_id
    group by t1.subject_id, t1.icd_code, t1.icd_version, t2.clubIcuStays, t1.hadm_id
	order by t1.icd_code, t1.icd_version
)
,  lessThanAvg as (
    select t2.subject_id, t1.icd_code, t1.icd_version
    from includeProcedure t2, combineProcedure t1
    where t2.icd_code = t1.icd_code and t2.icd_version = t1.icd_version and t1.average > t2.clubIcuStays
    group by t2.subject_id, t1.icd_code, t1.icd_version
    order by t2.subject_id, t1.icd_code, t1.icd_version
), includeGender as (
    select t1.subject_id, t2.gender,t1.icd_code, t1.icd_version
    from lessThanAvg as t1 join patients as t2
    on t1.subject_id = t2.subject_id  
    group by t1.subject_id, t2.gender,t1.icd_code, t1.icd_version
    order by t1.subject_id asc, t1.icd_code desc, t1.icd_version desc, t2.gender asc 

)
select *
from includeGender
limit 1000