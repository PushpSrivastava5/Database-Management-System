select t1.subject_id as subject_id, t1.gender as gender, t2.total_admissions as total_admissions, t2.last as last_admission, t2.first as first_admission, t1.diagnosis_count  
from (select icd.subject_id as subject_id, p.gender as gender , icd.count as diagnosis_count
from (select subject_id, count(*) as count, icd_code
from diagnoses_icd
where icd_code = '5723'
group by subject_id, icd_code) icd, patients p
where icd.subject_id = p.subject_id and icd.icd_code = '5723' 
group by icd.subject_id, icd.count ,icd.icd_code, p.gender) as t1
join 
(with firstAndLast as (
    select subject_id, 
    min(admittime) as first, 
    max(admittime) as last, count(subject_id) as total_admissions
    from admissions
    group by subject_id
)
select subject_id, first, last, total_admissions
from firstAndLast
group by subject_id, first, last, total_admissions) as t2
on t1.subject_id = t2.subject_id
group by t1.subject_id, t1.gender, t2.total_admissions, t2.last, t2.first, t1.diagnosis_count 
order by t2.total_admissions desc, t1.diagnosis_count desc, t2.last desc, t2.first desc, t1.gender desc, t1.subject_id desc  
limit 1000