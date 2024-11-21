select distinct averageICU.subject_id, FiveStays.numberOfStays as total_stays, averageICU.averagetime as avg_length_of_stay
from 
(select subject_id, avg(los) as averagetime
from icustays 
where los is not NULL and stay_id is not NULL and (first_careunit like '%MICU%' or last_careunit like '%MICU%')-- # where los is not NULL
group by subject_id
order by subject_id) as averageICU 
join 
( select subject_id, count(subject_id) as numberOfStays
from icustays
where los is not NULL and stay_id is not NULL and (first_careunit like '%MICU%' or last_careunit like '%MICU%')
group by subject_id 
having count(distinct stay_id) >= 5) as FiveStays
on averageICU.subject_id = FiveStays.subject_id 
order by averageICU.averagetime desc, FiveStays.numberOfStays desc, averageICU.subject_id desc
limit 500