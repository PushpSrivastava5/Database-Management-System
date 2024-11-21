with groupedDiagnoses as (
    select t1.subject_id, t1.hadm_id, t1.hospital_expire_flag, t2.icd_code, t2.icd_version 
    from admissions as t1 join diagnoses_icd as t2
    on t1.subject_id = t2.subject_id and t1.hadm_id = t2.hadm_id
), patientCountDiagnoses as (
    select distinct subject_id,icd_code, icd_version
    from groupedDiagnoses
    group by icd_code, icd_version, subject_id
) , countP as (
    select icd_code, icd_version, count(*) as count2
    from patientCountDiagnoses
    group by icd_code, icd_version
)
,patientDeath as (
    select distinct subject_id, icd_code, icd_version
    from groupedDiagnoses
    where hospital_expire_flag = 1
) , countDeath as (
    select icd_code, icd_version, count(*) as count1
    from patientDeath
    group by icd_code, icd_version
)
 , mortality_rate as (
    select icd_code, icd_version, avg(hospital_expire_flag) as mortality_rate1
    from groupedDiagnoses 
    group by icd_code, icd_version
    order by mortality_rate1 desc
    limit 245
), patientSurvive as (
    select *
    from patientCountDiagnoses
    where (icd_code, icd_version) in (select icd_code, icd_version
    from mortality_rate)
    except 
    select *
    from patientDeath
    where (icd_code, icd_version) in (select icd_code, icd_version
    from mortality_rate)
) , WithAge as (
    select patientSurvive.subject_id, patientSurvive.icd_code, patientSurvive.icd_version, patients.anchor_age
    from patientSurvive join patients
    on patientSurvive.subject_id = patients.subject_id 
    group by patientSurvive.subject_id, patientSurvive.icd_code, patientSurvive.icd_version, patients.anchor_age
), averageAgeIntermediate as (
    select icd_code, icd_version, avg(anchor_age) as survived_avg_age
    from WithAge
    group by icd_code, icd_version
), averageAge as (
    select t2.long_title, round(t1.survived_avg_age,2) as survived_avg_age 
    from averageAgeIntermediate as t1 join d_icd_diagnoses as t2
    on t1.icd_code = t2.icd_code and t1.icd_version = t2.icd_version
    order by t2.long_title, t1.survived_avg_age desc
)  

select *
from averageAge