select count(*) 
from (select count(*)
from labevents as lab join admissions as a 
on lab.hadm_id = a.hadm_id
where lab.flag = 'abnormal' and a.hospital_expire_flag = 1
group by lab.subject_id) as f