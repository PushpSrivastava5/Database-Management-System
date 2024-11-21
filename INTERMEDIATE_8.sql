with heart_disease as (
    select subject_id, hadm_id, icd_code
    from diagnoses_icd
    where icd_code like 'V4%'
    order by subject_id, hadm_id, icd_code
), admissionCount_up as (
    select subject_id, hadm_id, count(distinct icd_code) as distinct_diagnoses_count
    from diagnoses_icd
    where icd_code like 'V4%'
    group by subject_id, hadm_id
    having count(*)>1

), admissionCount as (
    select subject_id, distinct_diagnoses_count
    from admissionCount_up
)
,drugName as (
    select t1.subject_id, t1.hadm_id, t2.drug
    from heart_disease as t1 join prescriptions as t2
    on t1.subject_id = t2.subject_id and t1.hadm_id = t2.hadm_id
    where (t2.drug ilike '%prochlorperazine%' or t2.drug ilike '%bupropion%') and t1.subject_id in (select subject_id from admissionCount)
    order by t1.subject_id, t1.hadm_id, t2.drug
) , combination as (
    select t1.subject_id, t1.hadm_id, t3.distinct_diagnoses_count, t1.drug
    from drugName as t1 join admissionCount_up as t3
    on t1.subject_id = t3.subject_id and t1.hadm_id = t3.hadm_id
    group by t1.subject_id, t1.hadm_id, t3.distinct_diagnoses_count, t1.drug
    order by t3.distinct_diagnoses_count desc, t1.subject_id desc, t1.hadm_id desc, t1.drug asc 
)
select *
from combination