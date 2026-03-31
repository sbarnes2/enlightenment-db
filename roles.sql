--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:5t7hJJBcMeAfZCAAvBPtVw==$zy1aJdm+RhhUdoZiiosPK+B2J2zMCcXGGuOvipbmots=:fy7W7A121O2EzBOE87+/0NTDLTorGrCQRQRZtupK0S4=';

--
-- User Configurations
--






--
-- PostgreSQL database cluster dump complete
--

