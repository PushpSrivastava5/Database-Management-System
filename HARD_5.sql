with recursive first500Admissions1 as (
    select t1.subject_id, t1.hadm_id, t2.icd_code, t2.icd_version,t1.admittime, t1.dischtime
from (select subject_id, hadm_id, admittime, dischtime
    from admissions 
    order by admittime
    limit 500) as t1
    join 
    diagnoses_icd as t2
    on t1.subject_id = t2.subject_id and t1.hadm_id = t2.hadm_id
    order by subject_id
) , first500Admissions as (
    select subject_id, hadm_id, icd_code, icd_version, admittime, dischtime
    from first500Admissions1
    where admittime <= dischtime
),
graph_edges as (
    select distinct table1.subject_id as from_node, table2.subject_id as to_node 
    from first500Admissions as table1
    join first500Admissions as table2
    on table1.subject_id <> table2.subject_id and (table1.admittime <= table2.dischtime and table2.admittime<=table1.dischtime) and table1.icd_code = table2.icd_code and table1.icd_version = table2.icd_version
    group by from_node, to_node
) , 

graph_nodes as (
    select t1.subject_id
from (select subject_id, hadm_id, admittime, dischtime
    from first500Admissions 
    order by admittime) as t1
    join 
    diagnoses_icd as t2
    on t1.subject_id = t2.subject_id and t1.hadm_id = t2.hadm_id
group by t1.subject_id
order by t1.subject_id
) 
,  Reaches(from_node, to_node, path_length) AS (
    select from_node, to_node, 1 AS path_length
    from graph_edges
    where from_node = 10001725 
    union
    select
        R1.from_node, R2.to_node, R1.path_length + 1
    from
    Reaches R1
    join
    graph_edges R2
    on R1.to_node = R2.from_node and R1.from_node <> R2.to_node
    where R1.path_length < 5 -- Limit the recursion to 5 iterations
)

select
    case
        when exists (select 1 from (select * from Reaches where to_node = 19438360 ) as t) then 'True'
        else 'False'
    end as pathexists