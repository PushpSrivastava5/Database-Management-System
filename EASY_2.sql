select subject_id, count(subject_id) as num_admissions from admissions group by subject_id order by count(subject_id) desc,subject_id asc limit 1