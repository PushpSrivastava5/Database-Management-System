with combine as (select lab.subject_id, lab.hadm_id, icu.stay_id, icu.los 
from labevents as lab join icustays as icu
on lab.subject_id = icu.subject_id and lab.hadm_id = icu.hadm_id
where icu.los is not NULL and lab.itemid = 50878), combine2 as (
    select subject_id, avg(los) as "avg_stay_duration"
    from combine 
    group by subject_id, hadm_id
    order by "avg_stay_duration" desc, subject_id desc
    limit 1000
)
select *
from combine2