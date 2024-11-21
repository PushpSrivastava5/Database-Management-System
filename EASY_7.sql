select t.pharmacy_id, count(t.pharmacy_id) as num_patients_visited
from
(select distinct pharmacy_id, subject_id
from prescriptions
group by subject_id, pharmacy_id) as t
group by pharmacy_id
order by pharmacy_id