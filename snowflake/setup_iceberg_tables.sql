use role accountadmin;
create database demo_testdb;

// external volume can have multiple locations and across clouds
create or replace external volume demo_int_vol
storage_locations = (
(name = 'my_test_loc'
 storage_provider='snowflake')
);

//alter account set external_volume = 'demo_int_vol';
alter database demo_testdb set external_volume = 'demo_int_vol';
alter database demo_testdb set catalog = 'snowflake';

desc external volume demo_int_vol;
SHOW PARAMETERS IN DATABASE demo_testdb;
drop table user_info;

//creating an iceberg table is as simple as creating a native table!    
create iceberg table user_info if not exists (
     username string,
    email string
);
   // external_volume = demo_int_vol
   // catalog = snowflake
   // base_location = 'demo';

insert into user_info values 
  ('alice', 'alice@example.com'),
  ('bob',   'bob@example.com'),
  ('harvey', 'harvey@example.com'),
  ('carol', 'carol@example.com');

select * from user_info;
select system$get_iceberg_table_information('user_info');

create or replace iceberg table user_info_clone CLONE user_info;
select * from user_info_clone;

create iceberg table user_info_ctas if not exists 
as select * from user_info;

select * from user_info_ctas;
show iceberg tables;

drop table user_info;
drop table user_info_clone;