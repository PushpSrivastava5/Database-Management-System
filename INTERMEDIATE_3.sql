select subject_id, count(*) as  diagnoses_count from (select subject_id, count(*) 
from drgcodes
where description like '%ALCOHOLIC%'
group by subject_id, hadm_id, description) as t
where subject_id in (select subject_id from drgcodes where description like '%ALCOHOLIC%' group by subject_id having count(distinct hadm_id)>1)
group by t.subject_id
order by count(*) desc, t.subject_id desc