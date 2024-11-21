select a.subject_id, a.hadm_id, icd2.icd_code, icd1.long_title
from admissions a, d_icd_diagnoses icd1, diagnoses_icd icd2
where a.subject_id = icd2.subject_id and a.hadm_id = icd2.hadm_id and icd2.icd_code = icd1.icd_code and icd2.icd_version = icd1.icd_version  and a.admission_type = 'URGENT' and a.hospital_expire_flag = 1
and icd1.long_title is not NULL 
group by a.subject_id, a.hadm_id, icd2.icd_code, icd1.long_title
order by a.subject_id desc, a.hadm_id desc, icd2.icd_code desc, icd1.long_title desc
limit 1000