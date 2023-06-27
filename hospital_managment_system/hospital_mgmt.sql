use h_mgmt
go

   -- Patient Information Table creation
create table patient_info(
    patient_id int PRIMARY KEY,
    [patient name] NVARCHAR(50),
    [contact number] bigint ,
    e_mail NVARCHAR(150),
    [patient address] nvarchar(150),
    gender char(20),
    [patient entry date] date
	);

	--Doctor inforamation Table creation
create table doctor_info(
    [doctor id] int PRIMARY key,
    [doctor name] nvarchar(50),
    [doctor contact_No] bigint
)

	--Patients Attended By Doctor Table Creation. This Table Is Link With Patient_info and Doctor_info table
CREATE TABLE PatientsAttendbydoc(
    patient_id int,
    [doctor id] int ,
    disease_detect NVARCHAR(50),
    check_date DATE,
    [check_day (H:M)]  VARCHAR(20),
    FOREIGN key (patient_id) REFERENCES patient_info(patient_id),
    FOREIGN key ([doctor id]) REFERENCES doctor_info([doctor id])
)

	--Treatment Of Patient Started  Table Creation. This Table Is Link With Patient_info and Doctor_info table
create table start_treatment_of_patient(
    start_check date,
    patient_id int,
    [doctor id] int ,
    treatment_start date,
    complete_treatment date,
    FOREIGN key (patient_id) REFERENCES patient_info(patient_id),
    FOREIGN key ([doctor id]) REFERENCES doctor_info([doctor id])
)

	--Patient Is Discharged Table Creation. This Table Is Link With Patient_info
create  table patient_discharge_info(
    discharge_date date,
    [patient name] NVARCHAR(50),
    patient_id int,
	FOREIGN key (patient_id) REFERENCES patient_info(patient_id)
)

         ---INSERT VALUES
insert into patient_info( patient_id ,[patient name],[contact number],e_mail,[patient address],gender ,[patient entry date] )

VALUES(6821,'surya',8823123423,'surya23@gmail.com','wz-d-65 nagli najafghar,delhi','male','2014-01-25'),
(5821,'seeta',6823123423,'seeta@gmail.com','wz-d-61 dawarka ,delhi','female','2014-02-01'),
(6453,'geet',4523123423,'geet23@gmail.com','wz-d-61 najafghar,delhi','male','2014-01-12')


insert into doctor_info VALUES(2132,'Dr Rakesh',9821074705)
insert into doctor_info VALUES(2154,'Dr mohit',8210734305)
insert into doctor_info VALUES(2111,'Dr Preeti',2210734305)
insert into doctor_info VALUES(2122,'Dr srya',5621073435)


insert  into PatientsAttendbydoc(patient_id ,[doctor id]  ,disease_detect ,check_date ,[check_day (H:M)]) 
values(6453,2111,'fever','2014-01-12','friday'),
(6821,2111,'losse motion','2014-01-25','monday'),
(5821,2122,'cancer','2014-02-02','friday')


insert into start_treatment_of_patient(start_check,patient_id,[doctor id],treatment_start,complete_treatment) 
values
('2014-01-12',6453,2111,'2014-01-12','2014-01-15'),
('2014-01-25',6821,2111,'2014-01-25','2014-01-29'),
('2014-01-25',5821,2122,'2014-02-10','2015-01-12')


---SELECT QUERY
select * from doctor_info
select * from patient_info
select *from PatientsAttendbydoc
select*from start_treatment_of_patient

-----Stored procedure for patient infornation
create PROCEDURE sp_patient_info
@patient_id INT
as
begin
    select*from patient_info where patient_id=@patient_id
end


    --Stored procedure for check disease by patient id
create PROCEDURE sp_patient_disease_ckeck
@patient_id INT
as
begin
    select*from PatientsAttendbydoc where patient_id=@patient_id
end


------stored procedure for check doc detail by doc  id
create proc sp_doc_detail
@doc_id INT
as
begin
  select *from doctor_info where [doctor id]=@doc_id
end


------ Stored procedure with give all information about doc ,patient,disease
create proc sp_all_detail
@patient_id INT
with encryption
as
begin
 select * from PatientsAttendbydoc 
 join doctor_info
 on doctor_info.[doctor id]=PatientsAttendbydoc.[doctor id] where patient_id=@patient_id
end

sp_helptext sp_allDetails

create procedure sp_allDetails  
 @patient int  
as  
begin  
select patient_info.patient_id, patient_info.[patient name], patient_info.[contact number], patient_info.e_mail, patient_info.gender, patient_info.[patient address], patient_info.[patient entry date],
doctor_info.[doctor id], doctor_info.[doctor name], doctor_info.[doctor contact_No],
PatientsAttendbydoc.disease_detect, PatientsAttendbydoc.check_date, PatientsAttendbydoc.[check_day (H:M)],
start_treatment_of_patient.start_check, start_treatment_of_patient.treatment_start, start_treatment_of_patient.complete_treatment
from patient_info  
inner join PatientsAttendbydoc on patient_info.patient_id = PatientsAttendbydoc.patient_id  
inner join start_treatment_of_patient on patient_info.patient_id = start_treatment_of_patient.patient_id  
inner join doctor_info on doctor_info.[doctor id] = PatientsAttendbydoc.[doctor id]
where patient_info.patient_id = @patient
end

----create table for trigger

CREATE table new_patient_infomation(
    id int identity,
    Audit_Info NVARCHAR(200)
)

CREATE table new_doctor_infomation(
    id int identity,
    Audit_Info NVARCHAR(200)
)

CREATE table leave_doctor_infomation(
    id int identity,
    Audit_Info NVARCHAR(200)
)


----INSERT TRIGGER ON PATINT AUTO mATICALLY ENTER THE DATA IN ANOTHER TABLe
create TRIGGER tr_enter_new_info
on patient_info
for INSERT
AS 
BEGIN
       declare @id INT
       select @id=patient_id from inserted
       insert into new_patient_infomation values('new patient with patient_number='+ CAST(@id as nvarchar(5))+'is added at'+ cast(GETDATE() as nvarchar(20)))
end


-----create insert triggrer
create TRIGGER new_doc_info
on doctor_info
for insert 
as 
BEGIN
  DECLARE @id INT
  SELECT @id= [doctor id] from inserted
  INSERT into new_doctor_infomation values('new doctor id =' + cast(@id as nvarchar(5)) + 'on date is ' + cast(GETDATE() as nvarchar(20)))

end



---doctor leave firm delete trigger
create TRIGGER leave_firm_doc_info
on doctor_info
for delete 
as 
BEGIN
  DECLARE @id INT
  SELECT @id= [doctor id] from deleted
  INSERT into leave_doctor_infomation values('new doctor id = ' + cast(@id as nvarchar(5))  + ' leave on date is ' +  cast(GETDATE() as nvarchar(20)))

end


insert into patient_info( patient_id ,[patient name],[contact number],e_mail,[patient address],gender ,[patient entry date] )
VALUES(2212,'rohan',8823212345,'rohan23@gmail.com','wz-d-65 nagli najafghar,delhi','male','2014-01-21')

insert into doctor_info values(2229,'Dr vipul',12343134455)


	--selecting the trigger tables
select * from  new_doctor_infomation
select * from leave_doctor_infomation
select * from  new_patient_infomation


	--crearting the view that dosplays all the records and all details
create view full_details
as
	select patient_info.patient_id, patient_info.[patient name], patient_info.[contact number], patient_info.e_mail, patient_info.gender, patient_info.[patient address], patient_info.[patient entry date],
	doctor_info.[doctor id], doctor_info.[doctor name], doctor_info.[doctor contact_No],
	PatientsAttendbydoc.disease_detect, PatientsAttendbydoc.check_date, PatientsAttendbydoc.[check_day (H:M)],
	start_treatment_of_patient.start_check, start_treatment_of_patient.treatment_start, start_treatment_of_patient.complete_treatment
	from patient_info  
	left join PatientsAttendbydoc on patient_info.patient_id = PatientsAttendbydoc.patient_id  
	inner join start_treatment_of_patient on patient_info.patient_id = start_treatment_of_patient.patient_id  
	left join doctor_info on doctor_info.[doctor id] = PatientsAttendbydoc.[doctor id]

	-- selecting or displaying the view
select * from full_details