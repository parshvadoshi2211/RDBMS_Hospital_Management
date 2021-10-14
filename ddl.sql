set search_path to hospital
 create table patient ( PATIENT_ID SERIAL PRIMARY KEY, patient_name varchar(30)
NOT NULL, gender char(1) check(gender in('M','O','F')) NOT NULL, date_of_birth date
NOT NULL, Contact decimal(10,0) NOT NULL, blood_group char(3) check(blood_group
in('A+','A-','B+','B-','O+','O-','AB+','AB-')),
Address varchar(50) NOT NULL);
 /* 1,2,3,4,5 */
create table department( department_id varchar(7) primary key check( department_id like
'dept%'), department_name varchar(15) not null unique );
 /* dept101,dept102*/
create table shift( shift_id varchar(2) primary key check(shift_id like's%'), shift_name
varchar(9) unique not null check(shift_name in ('MORNING','AFTERNOON','NIGHT')),
timing varchar(8) not null unique check(timing in('06-to-14','14-to-22','22-to-06')) );
 /* s1,s2,s3(FIXED) */
create table doctor( doctor_id varchar(9) PRIMARY KEY check(doctor_id like 'doc%'),
DOCTOR_name varchar(30) NOT NULL, gender char(1) check(gender in('M','O','F')) NOT
NULL, date_of_birth date NOT NULL, contact decimal(10,0) not null, address varchar(50)
not null, Qualification varchar(20) NOT NULL, consultation_charge decimal(4,0) NOT
NULL, department_id varchar(7) references department(department_id) not null , shift_id
varchar(2) references shift(shift_id) on update cascade on delete restrict );
/* doc id -> docxxxyyy x->department y->doctor number*/
ALTER TABLE DEPARTMENT add head_of_department varchar(9) REFERENCES
DOCTOR(DOCTOR_ID) UNIQUE ;
 create table room_category( category_id varchar(4) primary key check(category_id like
'cat%'), category_type varchar(12) not null check(category_type in
('private','semi-private','general')), category_charges decimal(5) not null unique );
/*cat1,cat2,cat3*/
CREATE TABLE ROOM( ROOM_ID DECIMAL(3,0) PRIMARY KEY, CATEGORY_ID
CHAR(4) REFERENCES ROOM_CATEGORY(CATEGORY_ID) on update cascade on
delete restrict );
/*101,102,201*/
create table operation( operation_id varchar(5) primary key CHECK(operation_id like
'OP%'), operation_type varchar(50) NOT NULL, operation_charges decimal(7,0) NOT
NULL );
/*OP001,OP002*/ 
create table visit( visit_id BIGSERIAL primary key, disease varchar(15) not null, visit_date
DATE NOT NULL, discharge_date Date, patient_id INT references patient(patient_id) on
update cascade on delete restrict NOT NULL, doctor_id varchar(9) references
doctor(doctor_id) on update cascade on delete restrict NOT NULL , room_id decimal(3,0)
references room(room_id) on update cascade on delete restrict default null, operation_id
varchar(5) references operation(operation_id) on update cascade on delete restrict default null
);
 /* BIG SERIAL 1,2,3,4,5 */ /*If room id is null it is considered patient is not admitted If
operation id is null it is considered patient has not gone under any operation */
create table prescribed_medicine( visit_id BIGINT references visit(visit_id) on update
cascade on delete restrict, medicine_name varchar(20) NOT NULL, dose decimal(3,0) NOT
NULL, morning_intake BOOLEAN , afternoon_intake BOOLEAN, night_intake
BOOLEAN, primary key(visit_id,medicine_name), intake_suggestion BOOLEAN default
false );
 CREATE TABLE NURSE( NURSE_ID varchar(4) PRIMARY KEY CHECK(NURSE_ID
LIKE 'N%'), NURSE_name varchar(30) NOT NULL, gender char(1) check(gender
in('M','O','F')) NOT NULL, date_of_birth date NOT NULL, contact decimal(10,0) not null,
address varchar(50) not null, Shift_id char(2) references shift(shift_id) on update cascade on
delete restrict, room_id decimal(3,0) references room(room_id) on update cascade on delete
restrict );
/*N001,N003,N004*/
create table leave (nurse_id varchar(4) references nurse(nurse_id) not null,leave_date
date,reason varchar(50), substitute_id varchar(4) references nurse(nurse_id) DEFAULT
NULL, primary key(NURSE_ID,LEAVE_DATE));
create table bill( invoice_number BIGSERIAL PRIMARY KEY, consultation_charges
decimal(4,0) not null,
 room_charges decimal(6) DEFAULT 0 NOT NULL,
 operation_charges decimal(7,0) DEFAULT 0 NOT NULL,
 total_amount decimal(8,0) NOT NULL,
 visit_id BIGINT references visit(visit_id) on update cascade on delete restrict not null
UNIQUE );
 /*BIGSERIAL 1,2,3,4,5 */