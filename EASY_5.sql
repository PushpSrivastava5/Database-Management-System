select p.subject_id, p.anchor_age, count(p.subject_id) 
from icustays as icu join patients as p
on icu.subject_id = p.subject_id
where icu.first_careunit = 'Coronary Care Unit (CCU)'
group by p.subject_id
having count(p.subject_id) = (select count(p.subject_id) from icustays as icu join patients as p on icu.subject_id = p.subject_id where icu.first_careunit = 'Coronary Care Unit (CCU)' group by p.subject_id order by count desc, p.anchor_age desc, p.subject_id DESC limit 1)
order by count desc, p.anchor_age desc, p.subject_id desc