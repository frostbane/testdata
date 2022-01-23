-- execute as database super user
--    psql -U postgres < /cxt/cnf/script/00-database.sql

drop user if exists testdata;
create user testdata with password 'a7a2E';
alter user testdata with login;
alter user testdata with createdb;

drop database if exists testdata;
create database testdata;

grant all privileges on database testdata to testdata;
alter database testdata owner to testdata;
