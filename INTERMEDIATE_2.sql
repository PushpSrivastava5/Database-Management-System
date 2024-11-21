select drug, count(drug) as prescription_count
from prescriptions as p join admissions as a
on p.subject_id = a.subject_id and p.hadm_id = a.hadm_id and EXTRACT(EPOCH FROM (p.starttime - a.admittime))<=43200 and EXTRACT(EPOCH FROM (p.starttime - a.admittime))>=0
group by drug
order by count(drug) desc, drug desc
limit 1000