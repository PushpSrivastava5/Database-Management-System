with heartCondition as (
    select subject_id, hadm_id
    from diagnoses_icd
    where icd_code like 'I21%'
), notLast as (
    select distinct t1.subject_id
    from heartCondition as t1 join admissions as t2
    on t1.subject_id = t2.subject_id and t1.hadm_id <> t2.hadm_id
    where t2.admittime > (select dischtime from admissions where subject_id = t1.subject_id and hadm_id = t1.hadm_id)
)
select *
from notLast
order by subject_id desc
limit 1000