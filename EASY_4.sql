select count(*)
from procedures_icd as p join procedures_icd as pi
on p.subject_id = pi.subject_id
where p.subject_id = '10000117'
group by p.icd_version, p.icd_code