select p.subject_id, p.anchor_age
from patients as p join procedures_icd as pi
on p.subject_id = pi.subject_id
where p.anchor_age<50 and p.subject_id in (select distinct p1.subject_id
from procedures_icd as p1 join procedures_icd as p2
on p1.subject_id = p2.subject_id and p1.icd_code = p2.icd_code and p1.icd_version = p2.icd_version and p1.hadm_id <> p2.hadm_id
group by p1.subject_id
order by p1.subject_id) 
group by p.subject_id
order by p.subject_id, p.anchor_age