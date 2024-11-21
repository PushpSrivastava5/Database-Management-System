select distinct a.subject_id, count(a.subject_id)
from icustays as icu join admissions as a 
on icu.subject_id = a.subject_id
group by a.subject_id, a.hadm_id
having count(a.subject_id) >= 5
order by count(a.subject_id) desc, subject_id desc
limit 1000