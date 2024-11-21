select diagnoses_icd.subject_id as subject_id, patients.anchor_age as anchor_age 
from diagnoses_icd, icustays, patients 
where diagnoses_icd.subject_id = patients.subject_id and patients.subject_id = icustays.subject_id and diagnoses_icd.icd_code in (select icd_code from d_icd_diagnoses where long_title = 'Typhoid fever') 
group by diagnoses_icd.subject_id, patients.anchor_age
order by diagnoses_icd.subject_id, patients.anchor_age 