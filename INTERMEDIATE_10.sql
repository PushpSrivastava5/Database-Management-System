select pa.subject_id, pa.anchor_year, pr.drug
from (select t1.subject_id, t1.drug
from prescriptions as t1
join
prescriptions as t2
on t1.subject_id = t2.subject_id and t1.hadm_id <> t2.hadm_id and t1.drug = t2.drug
group by t1.subject_id, t1.drug
order by t1.subject_id, t1.drug) as pr
join 
patients as pa
on pr.subject_id = pa.subject_id
group by pa.subject_id, pa.anchor_year, pr.drug
order by pa.subject_id desc, pa.anchor_year desc, pr.drug desc
limit 1000