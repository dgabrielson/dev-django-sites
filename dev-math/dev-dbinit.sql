CREATE ROLE mathapp WITH LOGIN ENCRYPTED PASSWORD 'devtest';
CREATE DATABASE math_site WITH OWNER mathapp;
ALTER USER mathapp CREATEDB;
