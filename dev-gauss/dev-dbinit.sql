CREATE ROLE gauss WITH LOGIN ENCRYPTED PASSWORD 'gauss';
CREATE DATABASE gauss_web WITH OWNER gauss;
ALTER USER gauss CREATEDB;
