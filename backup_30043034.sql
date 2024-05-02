--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: log_transaction(integer, integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: binxenlightenmentdb
--

CREATE PROCEDURE public.log_transaction(IN transaction_user integer, IN for_user integer, IN transaction_type integer, IN transaction_data character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO transaction_log (transaction_user_id,target_userid,transaction_type_id,transaction_data)
    VALUES(transaction_user,for_user,transaction_type,transaction_data);
END
$$;


ALTER PROCEDURE public.log_transaction(IN transaction_user integer, IN for_user integer, IN transaction_type integer, IN transaction_data character varying) OWNER TO binxenlightenmentdb;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    doc_id character varying(100),
    documentname character varying(150) NOT NULL,
    rev character varying(50) NOT NULL,
    department character varying(100) NOT NULL,
    documentcode character varying(50) NOT NULL,
    documenttype character varying(50) NOT NULL,
    documentnumber character varying(20) NOT NULL,
    risklevel character varying(50) NOT NULL
);


ALTER TABLE public.documents OWNER TO binxenlightenmentdb;

--
-- Name: users; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100),
    email_address character varying,
    firstname character varying(100),
    surname character varying(100),
    active boolean DEFAULT true,
    is_admin boolean DEFAULT false NOT NULL,
    is_manager boolean DEFAULT false NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying,
    primary_title_id integer
);


ALTER TABLE public.users OWNER TO binxenlightenmentdb;

--
-- Name: userstate; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.userstate (
    id integer NOT NULL,
    employee_name character varying(100) NOT NULL,
    qt9_document_code character varying(100) NOT NULL,
    revision character varying(100) NOT NULL,
    title character varying(100) NOT NULL,
    trained character varying(100) NOT NULL
);


ALTER TABLE public.userstate OWNER TO binxenlightenmentdb;

--
-- Name: current_state_documents_view; Type: VIEW; Schema: public; Owner: binxenlightenmentdb
--

CREATE VIEW public.current_state_documents_view AS
 SELECT u.id,
    d.doc_id,
    us.qt9_document_code AS documentcode,
    us.revision AS rev,
    us.trained
   FROM ((public.userstate us
     JOIN public.users u ON (((u.username)::text = (us.employee_name)::text)))
     JOIN public.documents d ON (((d.documentcode)::text = (us.qt9_document_code)::text)));


ALTER VIEW public.current_state_documents_view OWNER TO binxenlightenmentdb;

--
-- Name: training_record; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.training_record (
    id integer NOT NULL,
    doc_id integer NOT NULL,
    risk_level integer NOT NULL,
    revision integer NOT NULL,
    userid integer NOT NULL,
    run_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    needs_verification boolean DEFAULT false,
    trained boolean DEFAULT false,
    verified boolean DEFAULT false,
    verified_by integer DEFAULT 0 NOT NULL,
    current_escalation_level integer DEFAULT 0 NOT NULL,
    date_verified date,
    old_revision integer DEFAULT 0,
    training_complete_date timestamp without time zone
);


ALTER TABLE public.training_record OWNER TO binxenlightenmentdb;

--
-- Name: current_training_history_view; Type: VIEW; Schema: public; Owner: binxenlightenmentdb
--

CREATE VIEW public.current_training_history_view AS
 SELECT t1.doc_id,
    t1.risk_level,
    t1.revision,
    t1.userid,
    t1.run_date,
    t1.needs_verification,
    t1.trained,
    t1.verified,
    t1.verified_by,
    t1.current_escalation_level,
    t1.date_verified,
    t1.old_revision,
    t1.training_complete_date
   FROM (public.training_record t1
     JOIN ( SELECT training_record.doc_id,
            training_record.userid,
            max(training_record.training_complete_date) AS maxtrain
           FROM public.training_record
          GROUP BY training_record.userid, training_record.doc_id) t ON (((t1.training_complete_date = t.maxtrain) AND (t1.doc_id = t.doc_id) AND (t1.userid = t.userid))));


ALTER VIEW public.current_training_history_view OWNER TO binxenlightenmentdb;

--
-- Name: departmental_breakdown_raw; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.departmental_breakdown_raw (
    qt9_document_code character varying(20),
    title character varying(100),
    job_function character varying(50),
    team_name character varying(20),
    doc_id integer
);


ALTER TABLE public.departmental_breakdown_raw OWNER TO binxenlightenmentdb;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: email_log; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.email_log (
    id integer NOT NULL,
    userid integer NOT NULL,
    escalation_level integer NOT NULL,
    email_sent_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.email_log OWNER TO binxenlightenmentdb;

--
-- Name: email_log_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.email_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.email_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: escalation; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.escalation (
    id integer NOT NULL,
    escalation_level integer NOT NULL,
    delay_days integer NOT NULL,
    message character varying(200)
);


ALTER TABLE public.escalation OWNER TO binxenlightenmentdb;

--
-- Name: escalation_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.escalation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.escalation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: escalation_state; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.escalation_state (
    id integer NOT NULL,
    delay_in_hours integer,
    state_name character varying(100),
    email_text character varying(250)
);


ALTER TABLE public.escalation_state OWNER TO binxenlightenmentdb;

--
-- Name: job_documents; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.job_documents (
    id integer NOT NULL,
    doc_id integer NOT NULL,
    job_id integer NOT NULL,
    active boolean DEFAULT true
);


ALTER TABLE public.job_documents OWNER TO binxenlightenmentdb;

--
-- Name: job_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.job_documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.job_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: job_titles; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.job_titles (
    id integer NOT NULL,
    team_id integer,
    name character varying(150),
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.job_titles OWNER TO binxenlightenmentdb;

--
-- Name: job_titles_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.job_titles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.job_titles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: relationship; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.relationship (
    id integer NOT NULL,
    manager_email character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL
);


ALTER TABLE public.relationship OWNER TO binxenlightenmentdb;

--
-- Name: managers; Type: VIEW; Schema: public; Owner: binxenlightenmentdb
--

CREATE VIEW public.managers AS
 SELECT DISTINCT u.id,
    u.username,
    u.email_address,
    u.firstname,
    u.surname
   FROM (public.relationship r
     JOIN public.users u ON (((u.email_address)::text = (r.manager_email)::text)))
  ORDER BY u.id;


ALTER VIEW public.managers OWNER TO binxenlightenmentdb;

--
-- Name: orgchart; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.orgchart (
    id integer NOT NULL,
    user_id integer,
    manager_id integer
);


ALTER TABLE public.orgchart OWNER TO binxenlightenmentdb;

--
-- Name: orgchart_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.orgchart ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.orgchart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: relationship_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.relationship ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.relationship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.team_members (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_is_manager boolean NOT NULL,
    team_id integer
);


ALTER TABLE public.team_members OWNER TO binxenlightenmentdb;

--
-- Name: team_members_id_id; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

CREATE SEQUENCE public.team_members_id_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_members_id_id OWNER TO binxenlightenmentdb;

--
-- Name: team_members_id_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: binxenlightenmentdb
--

ALTER SEQUENCE public.team_members_id_id OWNED BY public.team_members.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.teams OWNER TO binxenlightenmentdb;

--
-- Name: training_history; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.training_history (
    id integer NOT NULL,
    userid integer NOT NULL,
    documentid integer NOT NULL,
    usercurrentrevision character varying(10),
    training_complete boolean,
    training_complete_date timestamp without time zone
);


ALTER TABLE public.training_history OWNER TO binxenlightenmentdb;

--
-- Name: training_record_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.training_record ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.training_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: training_status_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.training_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.training_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transaction_log; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.transaction_log (
    id integer NOT NULL,
    transaction_user_id integer NOT NULL,
    target_userid integer NOT NULL,
    transaction_type_id integer NOT NULL,
    transaction_data character varying(250),
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.transaction_log OWNER TO binxenlightenmentdb;

--
-- Name: transaction_log_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.transaction_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transaction_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transaction_type; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.transaction_type (
    id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    type_text character varying(250)
);


ALTER TABLE public.transaction_type OWNER TO binxenlightenmentdb;

--
-- Name: transaction_type_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.transaction_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transaction_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_jobtitle; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.user_jobtitle (
    id integer NOT NULL,
    user_id integer NOT NULL,
    job_title_id integer NOT NULL
);


ALTER TABLE public.user_jobtitle OWNER TO binxenlightenmentdb;

--
-- Name: user_jobtitle_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.user_jobtitle ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.user_jobtitle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_training_needed; Type: VIEW; Schema: public; Owner: binxenlightenmentdb
--

CREATE VIEW public.user_training_needed AS
 SELECT DISTINCT ts.userid,
    u.username,
    u.email_address,
    dl.doc_id AS documentid,
    dl.documentcode AS documentqtid,
    dl.documentname AS documenttitle,
    ts.usercurrentrevision,
    csd.rev,
    dl.risklevel
   FROM (((public.training_history ts
     JOIN public.documents dl ON (((dl.doc_id)::integer = ts.documentid)))
     JOIN public.current_state_documents_view csd ON (((csd.documentcode)::text = (dl.documentcode)::text)))
     JOIN public.users u ON ((u.id = ts.userid)))
  WHERE (((ts.usercurrentrevision)::integer < (csd.rev)::integer) OR ((ts.training_complete_date IS NULL) AND ((ts.usercurrentrevision)::text = '0'::text)))
  ORDER BY ts.userid, dl.documentcode;


ALTER VIEW public.user_training_needed OWNER TO binxenlightenmentdb;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: userstate_id_seq; Type: SEQUENCE; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE public.userstate ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.userstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: userstate_raw; Type: TABLE; Schema: public; Owner: binxenlightenmentdb
--

CREATE TABLE public.userstate_raw (
    employeename character varying(100),
    qt9_document_code character varying(100),
    revision character varying(100),
    title character varying(100),
    trained character varying(10)
);


ALTER TABLE public.userstate_raw OWNER TO binxenlightenmentdb;

--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_id'::regclass);


--
-- Data for Name: departmental_breakdown_raw; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.departmental_breakdown_raw (qt9_document_code, title, job_function, team_name, doc_id) FROM stdin;
QT9 Document Code	Title	Job Function	Team Name	\N
CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	CEO	C-Suite	\N
CO-QA-POL-010	Policy for Control of Infrastructure Environment and Equipment	CEO	C-Suite	\N
CO-QC-POL-018	Quality Control Policy	CEO	C-Suite	\N
CO-SUP-POL-017	"Policy for Customer Interface Order Handling Product Storage & Distribution"	CEO	C-Suite	\N
CO-QA-POL-019	Quality Policy	CEO	C-Suite	\N
CO-QA-SOP-043	Training Procedure	CEO	C-Suite	\N
CO-IT-POL-022	Access Control Policy	CEO	C-Suite	\N
CO-IT-POL-023	Asset Management Policy	CEO	C-Suite	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	CEO	C-Suite	\N
CO-IT-POL-025	Code of Conduct	CEO	C-Suite	\N
CO-IT-POL-026	Cryptography Policy	CEO	C-Suite	\N
CO-IT-POL-027	Human Resource Security Policy	CEO	C-Suite	\N
CO-IT-POL-028	Information Security Policy	CEO	C-Suite	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	CEO	C-Suite	\N
CO-IT-POL-030	Physical Security Policy	CEO	C-Suite	\N
CO-IT-POL-031	Responsible Disclosure Policy	CEO	C-Suite	\N
CO-IT-POL-032	Risk Management 	CEO	C-Suite	\N
CO-IT-POL-033	Third Party Management	CEO	C-Suite	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	CEO	C-Suite	\N
CO-QA-POL-006	Policy for Document Control and Change Management	CEO	C-Suite	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	CEO	C-Suite	\N
CO-QA-SOP-012	Annual Quality Objectives 	CEO	C-Suite	\N
CO-QA-POL-021	Quality Manual	CEO	C-Suite	\N
CO-QA-POL-019	Quality Policy	CEO	C-Suite	\N
CO-QA-POL-043	Training Procedure	CEO	C-Suite	\N
CO-IT-SOP-044	"IT Management Backup and Support"	CEO	C-Suite	\N
CO-CS-POL-012	Policy for Customer Feedback and Device Vigilance	CEO	C-Suite	\N
CO-QA-POL-013	Policy for Complaints and Vigilance	CEO	C-Suite	\N
CO-QA-POL-020	Risk Management Policy	CEO	C-Suite	\N
CO-QA-POL-014	Policy for Control of Non Conformance 	CEO	C-Suite	\N
CO-QA-SOP-025	Management Review	CEO	C-Suite	\N
CO-HR-POL-007	Training Policy	CEO	C-Suite	\N
CO-QA-SOP-274	Applicable Standards Management Procedure	COO	C-Suite	\N
CO-H&S-P-001	Health & Safety Policy	COO	C-Suite	\N
CO-H&S-P-002	PAT Policy	COO	C-Suite	\N
CO-H&S-PRO-001	Health and Safety Fire Related Procedures	COO	C-Suite	\N
CO-H&S-PRO-002	Chemical COSHH Guidance	COO	C-Suite	\N
CO-H&S-PRO-003	Health and Safety Manual Handling	COO	C-Suite	\N
CO-H&S-PRO-004	Health & Safety Incident and Near Miss Reporting Procedure	COO	C-Suite	\N
CO-DES-SOP-029	Design and Development Procedure	COO	C-Suite	\N
CO-DES-SOP-243	CE Mark/Technical File Procedure	COO	C-Suite	\N
CO-DES-SOP-041	Design Review Work Instruction	COO	C-Suite	\N
CO-DES-SOP-042	Creation and maintenance of a Device Master Record	COO	C-Suite	\N
CO-QA-SOP-140	Document Control & Control of Quality Records	COO	C-Suite	\N
CO-QA-SOP-139	Change Management	COO	C-Suite	\N
CO-QA-SOP-028	Quality Records	COO	C-Suite	\N
CO-SAM-SOP-009	Control of Marketing and Promotion	COO	C-Suite	\N
CO-LAB-SOP-295	Environmental Contamination Monitoring	COO	C-Suite	\N
CO-LAB-SOP-155	Lab book write up	COO	C-Suite	\N
CO-LAB-SOP-156	Lab rough notes	COO	C-Suite	\N
CO-LAB-SOP-103	Environmental Control in the Laboratory	COO	C-Suite	\N
CO-LAB-SOP-145	Storage and Safe handling of Biohazardous Materials	COO	C-Suite	\N
CO-LAB-SOP-151	Management and Control of Critical and Controlled equipment	COO	C-Suite	\N
CO-QC-SOP-094	Procedure to control chemical and biological spillages	COO	C-Suite	\N
CO-LAB-SOP-288	Assessment of Potentiostat Performance	COO	C-Suite	\N
CO-LAB-SOP-158	Use of NanoDrop SP2000 Spectrophotometer for quantifying nucleic acid and protein samples	COO	C-Suite	\N
CO-LAB-SOP-149	Introducing New Laboratory Equipment	COO	C-Suite	\N
CO-LAB-SOP-135	Use and Completion of MFG documents	COO	C-Suite	\N
CO-LAB-SOP-170	Rapid PCR Rig Work Instructions	COO	C-Suite	\N
CO-LAB-SOP-178	Signal Analyser	COO	C-Suite	\N
CO-CA-SOP-081	Collection of Human samples for QA purposes	COO	C-Suite	\N
CO-QA-SOP-003	Non Conformance Procedure	COO	C-Suite	\N
CO-QA-SOP-004	Internal Audit	COO	C-Suite	\N
CO-QA-SOP-077	Supplier Audit Procedure	COO	C-Suite	\N
CO-QA-SOP-076	Product Complaint Handling	COO	C-Suite	\N
CO-QA-SOP-345	Tools for Root Cause Analysis	COO	C-Suite	\N
CO-QA-SOP-267	Post Market Surveillance	COO	C-Suite	\N
CO-QA-SOP-099	Deviation procedure	COO	C-Suite	\N
CO-QA-SOP-093	CAPA Procedure	COO	C-Suite	\N
CO-CA-POL-009	Policy for Verification and Validation	COO	C-Suite	\N
CO-QA-SOP-285	Hazard Analysis Procedure	COO	C-Suite	\N
CO-QA-SOP-284	FMEA Procedure	COO	C-Suite	\N
CO-QA-SOP-283	Product Risk Management 	COO	C-Suite	\N
CO-SUP-SOP-068	Purchasing SOP	COO	C-Suite	\N
CO-SUP-SOP-072	"Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling"	COO	C-Suite	\N
CO-SUP-SOP-280	Setting Expiry Dates for Incoming Materials	COO	C-Suite	\N
CO-OPS-SOP-192	Verification Testing Process SOP	COO	C-Suite	\N
CO-OPS-SOP-188	Process Validation	COO	C-Suite	\N
CO-OPS-SOP-002	Planning for Process Validation	COO	C-Suite	\N
CO-OPS-SOP-032	Validation of Automated Equipment and Quality System Software	COO	C-Suite	\N
CO-OPS-SOP-034	Test Method Validation	COO	C-Suite	\N
CO-IT-POL-022	Access Control Policy	COO	C-Suite	\N
CO-IT-POL-023	Asset Management Policy	COO	C-Suite	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	COO	C-Suite	\N
CO-IT-POL-025	Code of Conduct	COO	C-Suite	\N
CO-IT-POL-026	Cryptography Policy	COO	C-Suite	\N
CO-IT-POL-027	Human Resource Security Policy	COO	C-Suite	\N
CO-IT-POL-028	Information Security Policy	COO	C-Suite	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	COO	C-Suite	\N
CO-IT-POL-030	Physical Security Policy	COO	C-Suite	\N
CO-IT-POL-031	Responsible Disclosure Policy	COO	C-Suite	\N
CO-IT-POL-032	Risk Management 	COO	C-Suite	\N
CO-IT-POL-033	Third Party Management	COO	C-Suite	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	COO	C-Suite	\N
CO-QA-SOP-031	Revising and Introducing Documents in QT9	COO	C-Suite	\N
CO-QA-SOP-026	Use of Sharepoint	COO	C-Suite	\N
CO-QA-POL-006	Policy for Document Control and Change Management	COO	C-Suite	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	COO	C-Suite	\N
CO-QA-SOP-012	Annual Quality Objectives 	COO	C-Suite	\N
CO-QA-POL-021	Quality Manual	COO	C-Suite	\N
CO-QA-POL-019	Quality Policy	COO	C-Suite	\N
CO-QA-SOP-043	Training Procedure	COO	C-Suite	\N
CO-IT-SOP-044	"IT Management Backup and Support"	COO	C-Suite	\N
CO-CS-POL-012	Policy for Customer Feedback and Device Vigilance	COO	C-Suite	\N
CO-QA-POL-013	Policy for Complaints and Vigilance	COO	C-Suite	\N
CO-QA-POL-020	Risk Management Policy	COO	C-Suite	\N
CO-QA-POL-014	Policy for Control of Non Conformance 	COO	C-Suite	\N
CO-QA-SOP-025	Management Review	COO	C-Suite	\N
CO-HR-POL-007	Training Policy	COO	C-Suite	\N
CO-QA-SOP-007	"Correction Removal and Recall Procedure"	COO	C-Suite	\N
CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	CFO	C-Suite	\N
CO-SUP-SOP-068	Purchasing SOP	CFO	C-Suite	\N
CO-SUP-SOP-069	Supplier Evaluation SOP	CFO	C-Suite	\N
CO-SUP-SOP-070	"Supplier Risk Assessment Approval and Monitoring Procedure"	CFO	C-Suite	\N
CO-IT-POL-022	Access Control Policy	CFO	C-Suite	\N
CO-IT-POL-023	Asset Management Policy	CFO	C-Suite	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	CFO	C-Suite	\N
CO-IT-POL-025	Code of Conduct	CFO	C-Suite	\N
CO-IT-POL-026	Cryptography Policy	CFO	C-Suite	\N
CO-IT-POL-027	Human Resource Security Policy	CFO	C-Suite	\N
CO-IT-POL-028	Information Security Policy	CFO	C-Suite	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	CFO	C-Suite	\N
CO-IT-POL-030	Physical Security Policy	CFO	C-Suite	\N
CO-IT-POL-031	Responsible Disclosure Policy	CFO	C-Suite	\N
CO-IT-POL-032	Risk Management 	CFO	C-Suite	\N
CO-IT-POL-033	Third Party Management	CFO	C-Suite	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	CFO	C-Suite	\N
CO-QA-POL-006	Policy for Document Control and Change Management	CFO	C-Suite	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	CFO	C-Suite	\N
CO-IT-SOP-044	IT Management Back Up and Support	CFO	C-Suite	\N
CO-QA-SOP-012	Annual Quality Objectives 	CFO	C-Suite	\N
CO-QA-POL-021	Quality Manual	CFO	C-Suite	\N
CO-QA-POL-019	Quality Policy	CFO	C-Suite	\N
CO-QA-SOP-043	Training Procedure	CFO	C-Suite	\N
CO-CS-POL-012	Policy for Customer Feedback and Device Vigilance	CFO	C-Suite	\N
CO-QA-POL-013	Policy for Complaints and Vigilance	CFO	C-Suite	\N
CO-QA-POL-020	Risk Management Policy	CFO	C-Suite	\N
CO-QA-POL-014	Policy for Control of Non Conformance 	CFO	C-Suite	\N
CO-QA-SOP-025	Management Review	CFO	C-Suite	\N
CO-HR-POL-007	Training Policy	CFO	C-Suite	\N
CO-IT-POL-022	Access Control Policy	CCO	C-Suite	\N
CO-IT-POL-023	Asset Management Policy	CCO	C-Suite	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	CCO	C-Suite	\N
CO-IT-POL-025	Code of Conduct	CCO	C-Suite	\N
CO-IT-POL-026	Cryptography Policy	CCO	C-Suite	\N
CO-IT-POL-027	Human Resource Security Policy	CCO	C-Suite	\N
CO-IT-POL-028	Information Security Policy	CCO	C-Suite	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	CCO	C-Suite	\N
CO-IT-POL-030	Physical Security Policy	CCO	C-Suite	\N
CO-IT-POL-031	Responsible Disclosure Policy	CCO	C-Suite	\N
CO-IT-POL-032	Risk Management 	CCO	C-Suite	\N
CO-IT-POL-033	Third Party Management	CCO	C-Suite	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	CCO	C-Suite	\N
CO-QA-POL-006	Policy for Document Control and Change Management	CCO	C-Suite	\N
CO-QA-SOP-043	Training Procedure	CCO	C-Suite	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	CCO	C-Suite	\N
CO-QA-SOP-012	Annual Quality Objectives 	CCO	C-Suite	\N
CO-QA-POL-021	Quality Manual	CCO	C-Suite	\N
CO-QA-POL-019	Quality Policy	CCO	C-Suite	\N
CO-QA-POL-043	Training Procedure	CCO	C-Suite	\N
CO-CS-POL-012	Policy for Customer Feedback and Device Vigilance	CCO	C-Suite	\N
CO-QA-POL-013	Policy for Complaints and Vigilance	CCO	C-Suite	\N
CO-QA-POL-020	Risk Management Policy	CCO	C-Suite	\N
CO-QA-POL-014	Policy for Control of Non Conformance 	CCO	C-Suite	\N
CO-QA-SOP-025	Management Review	CCO	C-Suite	\N
CO-HR-POL-007	Training Policy	CCO	C-Suite	\N
CO-QA-SOP-140	Document Control & Control of Quality Records	Human Resources	Human Resources	\N
CO-QA-SOP-028	Quality Records	Human Resources	Human Resources	\N
CO-QA-SOP-025	Management Review	Human Resources	Human Resources	\N
CO-QA-POL-006	Policy for Document Control and Change Management	Human Resources	Human Resources	\N
CO-HR-POL-007	Training Policy	Human Resources	Human Resources	\N
CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	Human Resources	Human Resources	\N
CO-IT-POL-022	Access Control Policy	Human Resources	Human Resources	\N
CO-IT-POL-023	Asset Management Policy	Human Resources	Human Resources	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	Human Resources	Human Resources	\N
CO-IT-POL-025	Code of Conduct	Human Resources	Human Resources	\N
CO-IT-POL-026	Cryptography Policy	Human Resources	Human Resources	\N
CO-IT-POL-027	Human Resource Security Policy	Human Resources	Human Resources	\N
CO-IT-POL-028	Information Security Policy	Human Resources	Human Resources	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	Human Resources	Human Resources	\N
CO-IT-POL-030	Physical Security Policy	Human Resources	Human Resources	\N
CO-IT-POL-031	Responsible Disclosure Policy	Human Resources	Human Resources	\N
CO-IT-POL-032	Risk Management 	Human Resources	Human Resources	\N
CO-IT-POL-033	Third Party Management	Human Resources	Human Resources	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	Human Resources	Human Resources	\N
CO-QA-SOP-031	Revising and Introducing Documents in QT9	Human Resources	Human Resources	\N
CO-QA-SOP-237	QT9 Periodic Review and Making Document Obsolete	Human Resources	Human Resources	\N
CO-QA-SOP-098	Document Matrix	Human Resources	Human Resources	\N
CO-QA-SOP-026	Use of Sharepoint	Human Resources	Human Resources	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	Human Resources	Human Resources	\N
CO-IT-SOP-044	IT Management Back Up and Support	Human Resources	Human Resources	\N
CO-QA-SOP-012	Annual Quality Objectives 	Human Resources	Human Resources	\N
CO-QA-POL-021	Quality Manual	Human Resources	Human Resources	\N
CO-QA-POL-019	Quality Policy	Human Resources	Human Resources	\N
CO-QA-SOP-043	Training Procedure	Human Resources	Human Resources	\N
CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	Human Resources	Human Resources	\N
CO-CS-SOP-249	io Insepction using Data Collection Cartridge	Global Customer Support	Customer Support	\N
CO-H&S-P-001	Health & Safety Policy	Global Customer Support	Customer Support	\N
CO-LAB-SOP-095	External and repair Cleaning for io readers used at Atlas	Global Customer Support	Customer Support	\N
CO-LAB-SOP-163	Running End to End CT cartridges on io Readers	Global Customer Support	Customer Support	\N
CO-OPS-PTL-048	IO Release Procedure for Refurbished and Reworked Readers	Global Customer Support	Customer Support	\N
CO-QA-SOP-028	Quality Records	Global Customer Support	Customer Support	\N
CO-QA-SOP-139	Change Management	Global Customer Support	Customer Support	\N
CO-QA-SOP-140	Document Control & Control of Quality Records	Global Customer Support	Customer Support	\N
CO-QA-SOP-267	Post Market Surveillance	Global Customer Support	Customer Support	\N
CO-QA-SOP-274	Applicable Standards Management Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	Global Customer Support	Customer Support	\N
CO-SAM-SOP-009	Control of Marketing and Promotion	Global Customer Support	Customer Support	\N
CO-SUP-SOP-002	Intrument service and repair	Global Customer Support	Customer Support	\N
CO-SUP-SOP-068	Purchasing SOP	Global Customer Support	Customer Support	\N
CO-SUP-SOP-069	Supplier Evaluation SOP	Global Customer Support	Customer Support	\N
CO-SUP-SOP-070	"Supplier Risk Assessment Approval and Monitoring Procedure"	Global Customer Support	Customer Support	\N
CO-IT-POL-022	Access Control Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-023	Asset Management Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	Global Customer Support	Customer Support	\N
CO-IT-POL-025	Code of Conduct	Global Customer Support	Customer Support	\N
CO-IT-POL-026	Cryptography Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-027	Human Resource Security Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-028	Information Security Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	Global Customer Support	Customer Support	\N
CO-IT-POL-030	Physical Security Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-031	Responsible Disclosure Policy	Global Customer Support	Customer Support	\N
CO-IT-POL-032	Risk Management 	Global Customer Support	Customer Support	\N
CO-IT-POL-033	Third Party Management	Global Customer Support	Customer Support	\N
CO-QA-SOP-026	Use of Sharepoint	Global Customer Support	Customer Support	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	Global Customer Support	Customer Support	\N
CO-QA-SOP-031	Revising and Introducing Documents in QT9	Global Customer Support	Customer Support	\N
CO-QA-SOP-098	Document Matrix	Global Customer Support	Customer Support	\N
CO-QA-SOP-237	QT9 - Periodic Review and Making Documents Obsolete	Global Customer Support	Customer Support	\N
CO-IT-SOP-044	IT Management Back Up and Support	Global Customer Support	Customer Support	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	Global Customer Support	Customer Support	\N
CO-QA-POL-019	Quality Policy	Global Customer Support	Customer Support	\N
CO-QA-POL-021	Quality Manual	Global Customer Support	Customer Support	\N
CO-QA-SOP-012	Annual Quality Objectives 	Global Customer Support	Customer Support	\N
CO-QA-SOP-043	Training Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-003	Non Conformance Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-011	Supplier Corrective Action Response Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-093	CAPA Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-099	Deviation Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-345	Root Cause Analysis	Global Customer Support	Customer Support	\N
CO-QA-SOP-007	"Correction Removal and Recall Procedure"	Global Customer Support	Customer Support	\N
CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	Global Customer Support	Customer Support	\N
CO-QA-SOP-016	Identification and Traceability	Global Customer Support	Customer Support	\N
CO-HR-POL-007	Training Policy	Global Customer Support	Customer Support	\N
CO-QA-POL-006	Policy for Document Control and Change Management	Global Customer Support	Customer Support	\N
CO-QA-SOP-025	Management Review	Global Customer Support	Customer Support	\N
CO-QA-POL-013	Policy for Complaints and Vigilance	Global Customer Support	Customer Support	\N
CO-QA-POL-020	Risk Management Policy	Global Customer Support	Customer Support	\N
CO-CS-POL-012	Policy for Customer Feedback	Global Customer Support	Customer Support	\N
CO-QA-POL-014	Policy for the Control of Non-Conforming product and Corrective/Preventive Action	Global Customer Support	Customer Support	\N
CO-CS-SOP-249	io Insepction using Data Collection Cartridge	Field Service Engineer	Customer Service	\N
CO-H&S-P-001	Health & Safety Policy	Field Service Engineer	Customer Service	\N
CO-QA-SOP-140	Document Control & Control of Quality Records	Field Service Engineer	Customer Service	\N
CO-QA-SOP-139	Change Management	Field Service Engineer	Customer Service	\N
CO-QA-SOP-028	Quality Records	Field Service Engineer	Customer Service	\N
CO-LAB-SOP-095	External and repair Cleaning for io readers used at Atlas	Field Service Engineer	Customer Service	\N
CO-LAB-SOP-163	Running End to End CT cartridges on io Readers	Field Service Engineer	Customer Service	\N
CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	Field Service Engineer	Customer Service	\N
CO-SUP-SOP-002	Intrument service and repair	Field Service Engineer	Customer Service	\N
CO-OPS-PTL-048	IO Release Procedure for Refurbished and Reworked Readers	Field Service Engineer	Customer Service	\N
CO-SUP-SOP-068	Purchasing SOP	Field Service Engineer	Customer Service	\N
CO-SUP-SOP-069	Supplier Evaluation SOP	Field Service Engineer	Customer Service	\N
CO-SUP-SOP-070	"Supplier Risk Assessment Approval and Monitoring Procedure"	Field Service Engineer	Customer Service	\N
CO-IT-POL-022	Access Control Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-023	Asset Management Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	Field Service Engineer	Customer Service	\N
CO-IT-POL-025	Code of Conduct	Field Service Engineer	Customer Service	\N
CO-IT-POL-026	Cryptography Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-027	Human Resource Security Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-028	Information Security Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	Field Service Engineer	Customer Service	\N
CO-IT-POL-030	Physical Security Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-031	Responsible Disclosure Policy	Field Service Engineer	Customer Service	\N
CO-IT-POL-032	Risk Management 	Field Service Engineer	Customer Service	\N
CO-IT-POL-033	Third Party Management	Field Service Engineer	Customer Service	\N
CO-QA-SOP-026	Use of Sharepoint	Field Service Engineer	Customer Service	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	Field Service Engineer	Customer Service	\N
CO-QA-SOP-098	Document Matrix	Field Service Engineer	Customer Service	\N
CO-QA-SOP-237	QT9 Periodic Review and Making Document Obsolete	Field Service Engineer	Customer Service	\N
CO-QA-SOP-031	Revising and Introducing Documents in QT9	Field Service Engineer	Customer Service	\N
CO-QA-POL-015	Policy for the use of Electronic Signatures within binx health	Field Service Engineer	Customer Service	\N
CO-QA-POL-021	Quality Manual	Field Service Engineer	Customer Service	\N
CO-HR-POL-007	Training Policy	Field Service Engineer	Customer Service	\N
CO-QA-POL-019	Quality Policy	Field Service Engineer	Customer Service	\N
CO-IT-SOP-044	"IT Management Backup and Support"	Field Service Engineer	Customer Service	\N
CO-QA-SOP-043	Training Procedure	Field Service Engineer	Customer Service	\N
CO-QA-SOP-099	Deviation Procedure	Field Service Engineer	Customer Service	\N
CO-QA-SOP-345	Root Cause Analysis	Field Service Engineer	Customer Service	\N
CO-QA-SOP-003	Non Conformance Procedure	Field Service Engineer	Customer Service	\N
CO-QA-SOP-011	Supplier Corrective Action Response Procedure	Field Service Engineer	Customer Service	\N
CO-QA-SOP-093	CAPA Procedure	Field Service Engineer	Customer Service	\N
CO-QA-SOP-007	"Correction Removal and Recall Procedure "	Field Service Engineer	Customer Service	\N
CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	Field Service Engineer	Customer Service	\N
CO-QA-SOP-016	Identification and Traceability	Field Service Engineer	Customer Service	\N
CO-QA-SOP-140	Document Control & Control of Quality Records	Customer Support	Customer Support	\N
CO-QA-SOP-139	Change Management	Customer Support	Customer Support	\N
CO-QA-SOP-028	Quality Records	Customer Support	Customer Support	\N
CO-SUP-SOP-048	Raise PO Non Stock and Services	Customer Support	Customer Support	\N
CO-SUP-SOP-049	Receive non sock PO 	Customer Support	Customer Support	\N
CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	Customer Support	Customer Support	\N
CO-QA-SOP-267	Post Market Surveillance	Customer Support	Customer Support	\N
CO-HR-POL-007	Training Policy	Customer Support	Customer Support	\N
CO-SUP-SOP-068	Purchasing SOP	Customer Support	Customer Support	\N
CO-SUP-SOP-069	Supplier Evaluation SOP	Customer Support	Customer Support	\N
CO-SUP-SOP-070	"Supplier Risk Assessment Approval and Monitoring Procedure"	Customer Support	Customer Support	\N
CO-IT-POL-022	Access Control Policy	Customer Support	Customer Support	\N
CO-IT-POL-023	Asset Management Policy	Customer Support	Customer Support	\N
CO-IT-POL-024	Business Continuity and Disaster Recovery	Customer Support	Customer Support	\N
CO-IT-POL-025	Code of Conduct	Customer Support	Customer Support	\N
CO-IT-POL-026	Cryptography Policy	Customer Support	Customer Support	\N
CO-IT-POL-027	Human Resource Security Policy	Customer Support	Customer Support	\N
CO-IT-POL-028	Information Security Policy	Customer Support	Customer Support	\N
CO-IT-POL-029	Information Security Roles and Responsibilities	Customer Support	Customer Support	\N
CO-IT-POL-030	Physical Security Policy	Customer Support	Customer Support	\N
CO-IT-POL-031	Responsible Disclosure Policy	Customer Support	Customer Support	\N
CO-IT-POL-032	Risk Management 	Customer Support	Customer Support	\N
CO-IT-POL-033	Third Party Management	Customer Support	Customer Support	\N
CO-QA-SOP-030	Accessing and Finding Documents in QT9	Customer Support	Customer Support	\N
CO-QA-SOP-098	Document Matrix	Customer Support	Customer Support	\N
CO-QA-SOP-237	QT9 Periodic Review and Making Document Obsolete	Customer Support	Customer Support	\N
CO-QA-SOP-031	Revising and Introducing Documents in QT9	Customer Support	Customer Support	\N
CO-QA-SOP-026	Use of Sharepoint	Customer Support	Customer Support	\N
CO-IT-SOP-044	IT Management Back Up and Support	Customer Support	Customer Support	\N
CO-QA-SOP-012	Annual Quality Objectives 	Customer Support	Customer Support	\N
CO-QA-POL-015	Policy for Use of Electronic Signatures within binx health	Customer Support	Customer Support	\N
CO-QA-POL-021	Quality Manual	Customer Support	Customer Support	\N
CO-QA-POL-019	Quality Policy	Customer Support	Customer Support	\N
CO-QA-SOP-043	Training Procedure	Customer Support	Customer Support	\N
CO-QA-SOP-003	Non-conforming Product Procedure	Customer Support	Customer Support	\N
CO-QA-SOP-093	Corrective and Preventive Action procedure	Customer Support	Customer Support	\N
CO-QA-SOP-011	Supplier Corrective Action Procedure	Customer Support	Customer Support	\N
CO-QA-SOP-345	Root Cause Analysis	Customer Support	Customer Support	\N
CO-QA-SOP-099	Deviation Procedure	Customer Support	Customer Support	\N
CO-QA-SOP-007	"Correction Removal and Recall Procedure "	Customer Support	Customer Support	\N
CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	Customer Support	Customer Support	\N
CO-QA-SOP-016	Identification and Traceability	Customer Support	Customer Support	\N
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.documents (id, doc_id, documentname, rev, department, documentcode, documenttype, documentnumber, risklevel) FROM stdin;
3	16	Software Development Procedure	4	Design	CO-DES-SOP-004	Standard Operating Procedure		0
4	17	Procedure for Commercial Storage and Distribution	2	Supply Chain	CO-SUP-SOP-001	Standard Operating Procedure		0
5	18	Instrument Service & Repair Procedure	5	Customer Support	CO-CS-SOP-368	Standard Operating Procedure		0
6	19	Procedure for Inventry Control and BIP	1	Supply Chain	CO-SUP-SOP-003	Standard Operating Procedure		0
7	21	New Customer Procedure	2	Supply Chain	CO-SUP-SOP-005	Standard Operating Procedure		0
8	22	Equipment Fulfilment and Field Visit SOP for non-stock instruments	2	Supply Chain	CO-SUP-SOP-006	Standard Operating Procedure		0
9	24	Planning for Process Validation	3	Operations	CO-OPS-SOP-002	Standard Operating Procedure		0
10	38	Customer Returns	2	Supply Chain	CO-SUP-SOP-013	Standard Operating Procedure		0
11	40	Critical to Quality and Reagent Design Control	2	Design	CO-DES-SOP-371	Standard Operating Procedure		0
12	41	Reagent Design Transfer process	2	Design	CO-DES-SOP-372	Standard Operating Procedure		0
13	65	Document Control Procedure  Projects	19	Quality Assurance	CO-QA-SOP-140	Standard Operating Procedure		0
14	66	Document Matrix	7	Quality Assurance	CO-QA-SOP-098	Standard Operating Procedure		0
15	69	Document and Records Archiving	5	Quality Assurance	CO-QA-SOP-005	Standard Operating Procedure		0
16	70	Nonconforming Product Procedure	18	Quality Assurance	CO-QA-SOP-003	Standard Operating Procedure		0
17	71	Internal Audit	12	Quality Assurance	CO-QA-SOP-004	Standard Operating Procedure		0
18	73	Vigilance and Medical Reporting Procedure	7	Quality Assurance	CO-QA-SOP-326	Standard Operating Procedure		0
19	74	Correction Removal and Recall Procedure	5	Quality Assurance	CO-QA-SOP-007	Standard Operating Procedure		0
20	85	Quality Control	2	Supply Chain	CO-SUP-SOP-025	Standard Operating Procedure		0
21	144	Root Cause Analysis	4	Quality Assurance	CO-QA-SOP-345	Standard Operating Procedure		0
22	146	Post Market Surveillance	8	Quality Assurance	CO-QA-SOP-267	Standard Operating Procedure		0
23	147	Supplier Corrective Action Response Procedure	6	Quality Assurance	CO-QA-SOP-011	Standard Operating Procedure		0
24	148	Annual Quality Objectives	8	Quality Assurance	CO-QA-SOP-012	Standard Operating Procedure		0
25	151	Qualification and Competence of Auditors	3	Quality Assurance	CO-QA-SOP-015	Standard Operating Procedure		0
26	152	Identification and Traceabillity	2	Quality Assurance	CO-QA-SOP-016	Standard Operating Procedure		0
27	155	Complete QC Inspections	2	Supply Chain	CO-SUP-SOP-037	Standard Operating Procedure		0
28	156	Change of Stock  QC Release	2	Supply Chain	CO-SUP-SOP-038	Standard Operating Procedure		0
29	157	Manage Quality Codes	2	Supply Chain	CO-SUP-SOP-039	Standard Operating Procedure		0
30	158	New Customer Set-Up	2	Supply Chain	CO-SUP-SOP-040	Standard Operating Procedure		0
31	159	Customer Sales Contracts	2	Supply Chain	CO-SUP-SOP-041	Standard Operating Procedure		0
32	160	Enter & Release Sales Orders	2	Supply Chain	CO-SUP-SOP-042	Standard Operating Procedure		0
33	161	Mark Sales Orders as Despatched	2	Supply Chain	CO-SUP-SOP-043	Standard Operating Procedure		0
34	162	Invoice Customers Manually	2	Supply Chain	CO-SUP-SOP-044	Standard Operating Procedure		0
35	163	Cutomer Price Lists	2	Supply Chain	CO-SUP-SOP-045	Standard Operating Procedure		0
36	164	Create New Customer Return	2	Supply Chain	CO-SUP-SOP-046	Standard Operating Procedure		0
37	177	Transfer Orders	2	Supply Chain	CO-SUP-SOP-047	Standard Operating Procedure		0
38	178	Raise PO - non-Stock & Services	3	Supply Chain	CO-SUP-SOP-048	Standard Operating Procedure		0
39	179	Receive Non-Stock PO	4	Supply Chain	CO-SUP-SOP-049	Standard Operating Procedure		0
40	180	Raise PO - Stock Items	2	Supply Chain	CO-SUP-SOP-050	Standard Operating Procedure		0
41	181	Receive Stock Purchase Orders	2	Supply Chain	CO-SUP-SOP-051	Standard Operating Procedure		0
42	182	New Supplier Set-Up	2	Supply Chain	CO-SUP-SOP-052	Standard Operating Procedure		0
43	183	Raise & Release Production Order	2	Supply Chain	CO-SUP-SOP-053	Standard Operating Procedure		0
44	184	Complete Production Order	2	Supply Chain	CO-SUP-SOP-054	Standard Operating Procedure		0
45	185	Goods Movement	2	Supply Chain	CO-SUP-SOP-055	Standard Operating Procedure		0
46	186	Check Sales Order due Date	1	Supply Chain	CO-SUP-SOP-056	Standard Operating Procedure		0
47	208	Consume to Cost Centre or Project	2	Supply Chain	CO-SUP-SOP-057	Standard Operating Procedure		0
48	209	Inspection Plans	2	Supply Chain	CO-SUP-SOP-058	Standard Operating Procedure		0
49	210	Credit Customer Returns	2	Supply Chain	CO-SUP-SOP-059	Standard Operating Procedure		0
50	211	Customer Returns	2	Supply Chain	CO-SUP-SOP-060	Standard Operating Procedure		0
51	212	New Project Set-Up	2	Supply Chain	CO-SUP-SOP-061	Standard Operating Procedure		0
52	213	Add Team Member to a Task	2	Supply Chain	CO-SUP-SOP-062	Standard Operating Procedure		0
53	214	Book Time Against A Project	2	Supply Chain	CO-SUP-SOP-063	Standard Operating Procedure		0
54	215	Create a PO Within a Project	2	Supply Chain	CO-SUP-SOP-064	Standard Operating Procedure		0
55	216	Complete a Time Sheet	2	Supply Chain	CO-SUP-SOP-065	Standard Operating Procedure		0
56	217	SAP Manager Approvals App	2	Supply Chain	CO-SUP-SOP-066	Standard Operating Procedure		0
57	218	Managing Expired Identified Stock	2	Supply Chain	CO-SUP-SOP-067	Standard Operating Procedure		0
58	245	Control of Marketing and Promotion	5	Sales and Marketing	CO-SAM-SOP-009	Standard Operating Procedure		0
59	247	Part No 0001 Agarose	4	Laboratory	CO-LAB-FRM-001	Forms		0
60	248	Glycerol  For molecular biology	4	Laboratory	CO-LAB-FRM-002	Forms		0
61	249	Ethanol  Absolute	6	Laboratory	CO-LAB-FRM-003	Forms		0
62	250	TRIS  TRIZMA  Base	5	Laboratory	CO-LAB-FRM-004	Forms		0
63	251	100bp low MW Ladder	4	Laboratory	CO-LAB-FRM-005	Forms		0
64	252	Triton X-100	4	Laboratory	CO-LAB-FRM-006	Forms		0
2	15	CE Mark/Technical File Procedure	6	Design	CO-DES-SOP-243	Standard Operating Procedure		1
65	253	0.5M EDTA solution	4	Laboratory	CO-LAB-FRM-007	Forms		0
66	335	Use of the LMS Programmable Incubator	2	Laboratory	CO-LAB-SOP-019	Standard Operating Procedure		0
67	254	Part No. 0117 Sterile Syringe filter with 0.2 µm cellulose acetate membrane	6	Laboratory	CO-LAB-FRM-008	Forms		0
68	255	D- + -Trehalose Dihydrate	4	Laboratory	CO-LAB-FRM-009	Forms		0
69	256	2mL ENAT Transport media	4	Laboratory	CO-LAB-FRM-010	Forms		0
70	257	Part no. 0141 Albumin from Bovine serum	5	Laboratory	CO-LAB-FRM-011	Forms		0
71	258	Microbank Cryovials	4	Laboratory	CO-LAB-FRM-012	Forms		0
72	259	Triton x305	6	Laboratory	CO-LAB-FRM-013	Forms		0
73	260	Part No 0180 Brij 58	6	Laboratory	CO-LAB-FRM-014	Forms		0
74	261	Part No 0181 ROSS fill solution pH Electrode	3	Laboratory	CO-LAB-FRM-015	Forms		0
75	262	CT Taqman Probe  FAM	5	Laboratory	CO-LAB-FRM-016	Forms		0
76	263	IC Taqman Probe  FAM	5	Laboratory	CO-LAB-FRM-017	Forms		0
77	264	Agilent Bioanalyzer SOP for RNA 6000 Pico and Nano Kits	4	Laboratory	CO-LAB-SOP-002	Standard Operating Procedure		0
78	265	Validation of Temperature Controlled Equipment	3	Laboratory	CO-LAB-SOP-003	Standard Operating Procedure		0
79	266	Use of the Bolt Mini Gel Tank for protein Electrophoresis	3	Laboratory	CO-LAB-SOP-004	Standard Operating Procedure		0
80	267	Rhychiger Heat Sealer	3	Laboratory	CO-LAB-SOP-005	Standard Operating Procedure		0
81	268	Esco Laminar Flow Cabinet	2	Laboratory	CO-LAB-SOP-006	Standard Operating Procedure		0
82	269	Firmware Up-date	2	Operations	CO-OPS-SOP-007	Standard Operating Procedure		0
83	270	Thermal Test Rig Set Up and Calibration	3	Operations	CO-OPS-SOP-008	Standard Operating Procedure		0
84	271	Reader Peltier Refit procedure	3	Operations	CO-OPS-SOP-009	Standard Operating Procedure		0
85	272	Reagent Deposition and Immobilisation  Pilot Line	4	Laboratory	CO-LAB-SOP-010	Standard Operating Procedure		0
86	273	Eppendorf 5424 Centrifuge	2	Laboratory	CO-LAB-SOP-011	Standard Operating Procedure		0
87	274	Binder KBF-115 Oven	2	Laboratory	CO-LAB-SOP-012	Standard Operating Procedure		0
88	277	Glycerol Solution	3	Operations	CO-OPS-SOP-124	Standard Operating Procedure		0
89	278	IC DNA in TE Buffer 100pg/ul Working Stock Aliquots	3	Operations	CO-OPS-SOP-125	Standard Operating Procedure		0
90	279	Manufacture of IC DNA Reagent’	5	Operations	CO-OPS-SOP-117	Standard Operating Procedure		0
91	280	Manufacture of CT/IC Primer Passivation Reagent	5	Operations	CO-OPS-SOP-118	Standard Operating Procedure		0
92	281	Manufacture of NG1/NG2/IC Primer Passivation Reagent	8	Operations	CO-OPS-SOP-119	Standard Operating Procedure		0
93	282	225mM Potassium phosphate buffer	3	Operations	CO-OPS-SOP-110	Standard Operating Procedure		0
94	283	9.26pc  w.v  NZ Source BSA in 208.3mM Potassium Phosphate buffer	3	Operations	CO-OPS-SOP-114	Standard Operating Procedure		0
95	284	9.26pc  w.v  BSA in 208.3 mM Potassium Phosphate buffer	3	Operations	CO-OPS-SOP-113	Standard Operating Procedure		0
96	285	CTNG Storage Buffer  224.3mM Potassium Phosphate	3	Operations	CO-OPS-SOP-120	Standard Operating Procedure		0
97	286	Material Transfer Agreement	4	Operations	CO-OPS-T-001	Templates		0
98	287	Material Transfer Agreement  binx recipient	2	Operations	CO-OPS-T-002	Templates		0
99	288	binx Purchase Order Form	8	Supply Chain	CO-SUP-T-003	Templates		0
100	289	Design Review Record	2	Design	CO-DES-T-004	Templates		0
101	290	Phase Review Record	2	Design	CO-DES-T-005	Templates		0
102	292	External Change Notification Form	6	Quality Assurance	CO-QA-T-007	Templates		0
103	293	Change Management Form	12	Quality Assurance	CO-QA-T-008	Templates		0
104	294	Template for IQC	6	Quality Control	CO-QC-T-009	Templates		0
105	295	Policy Template	5	Quality Assurance	CO-QA-T-010	Templates		0
106	296	Form Template	5	Quality Assurance	CO-QA-T-011	Templates		0
107	297	Internal Training Form	4	Quality Assurance	CO-QA-T-012	Templates		0
108	301	Lab Cleaning Form	8	Quality Control	CO-QC-T-016	Templates		0
109	304	Manufacturing Partner Ranking Criteria	2	Operations	CO-OPS-T-019	Templates		0
110	305	Development Partner Ranking	2	Operations	CO-OPS-T-020	Templates		0
111	306	Generic PSP Ranking Criteria  template	2	Operations	CO-OPS-T-021	Templates		0
112	307	IVD Directive - Essential Requirements Check List Template	4	Design	CO-DES-T-022	Templates		0
113	308	Solution Preparation Form	3	Quality Control	CO-QC-T-023	Templates		0
114	310	Validation Protocol template	8	Design	CO-DES-T-025	Templates		0
115	311	IT GAMP Evaluation Form	4	Finance	CO-FIN-T-026	Templates		0
116	312	IT Request for Information	3	Finance	CO-FIN-T-027	Templates		0
117	313	Balance Calibration form	3	Quality Control	CO-QC-T-028	Templates		0
118	314	Incubator Monitoring Form	4	Quality Control	CO-QC-T-029	Templates		0
119	315	pH Meter Calibration Form	3	Quality Control	CO-QC-T-030	Templates		0
120	316	Dishwasher User Form	3	Quality Control	CO-QC-T-031	Templates		0
121	317	Equipment Log	3	Quality Control	CO-QC-T-032	Templates		0
122	318	Autoclave Record	5	Quality Control	CO-QC-T-033	Templates		0
123	320	Rework Protocol Template	4	Quality Control	CO-QC-T-035	Templates		0
124	321	Experimental template: Planning	5	Design	CO-DES-T-036	Templates		0
125	322	CTdi452 Probe from atdbio	6	Laboratory	CO-LAB-FRM-018	Forms		0
126	323	Synthetic Uracil containing Amplicon	3	Laboratory	CO-LAB-FRM-019	Forms		0
127	324	Elution Reagent	4	Laboratory	CO-LAB-FRM-020	Forms		0
128	325	NG1  di452 Probe from SGS	5	Laboratory	CO-LAB-FRM-021	Forms		0
129	326	NG2  di452 Probe from SGS	5	Laboratory	CO-LAB-FRM-022	Forms		0
130	327	6x DNA loading dye Atlas Part Number 0327	2	Laboratory	CO-LAB-FRM-023	Forms		0
131	328	GelRed Nucleic Acid Stain Atlas Part Number 0328	2	Laboratory	CO-LAB-FRM-024	Forms		0
132	329	Balance calibration	6	Laboratory	CO-LAB-SOP-013	Standard Operating Procedure		0
133	330	Thermo Orion Star pH meter	4	Laboratory	CO-LAB-SOP-014	Standard Operating Procedure		0
134	331	Use of the ALC PK121 centrifuges  refrigerated and non-refrigerated	3	Laboratory	CO-LAB-SOP-015	Standard Operating Procedure		0
135	332	Use of the Peqlab thermal cyclers	4	Laboratory	CO-LAB-SOP-016	Standard Operating Procedure		0
136	333	Use of the Jenway Spectrophotometer	3	Laboratory	CO-LAB-SOP-017	Standard Operating Procedure		0
137	336	Use of the Hulme Martin Pmpulse heat Sealer	2	Laboratory	CO-LAB-SOP-020	Standard Operating Procedure		0
138	337	Use of Stuart SRT6D Roller Mixer	4	Quality Control	CO-QC-SOP-021	Standard Operating Procedure		0
139	338	Operation & Maintenance of Grant SUB Aqua Pro 5  SAP5  unstirred Water Bath with Labarmor Beads	2	Laboratory	CO-LAB-SOP-022	Standard Operating Procedure		0
140	339	1 x lysis buffer	9	Operations	CO-OPS-SOP-109	Standard Operating Procedure		0
141	340	Potassium Phosphate Buffer	7	Operations	CO-OPS-SOP-127	Standard Operating Procedure		0
142	342	DTT Solution	8	Operations	CO-OPS-SOP-123	Standard Operating Procedure		0
143	343	Detection Surfactants Solution	9	Operations	CO-OPS-SOP-122	Standard Operating Procedure		0
144	344	CTNG T7 Diluent Rev 3.0  NZ source BSA	2	Operations	CO-OPS-SOP-121	Standard Operating Procedure		0
145	345	600pM Stocks of Synthetic Uracil containing Amplicon	3	Operations	CO-OPS-SOP-112	Standard Operating Procedure		0
146	346	50U/uL T7 Exonuclease in CTNG Storage Buffer	4	Operations	CO-OPS-SOP-111	Standard Operating Procedure		0
147	347	Preparation of TV 10 thousand cells/uL Master Stocks	2	Operations	CO-OPS-SOP-128	Standard Operating Procedure		0
148	348	Contrived Vaginal Matrix in eNAT	2	Operations	CO-OPS-SOP-116	Standard Operating Procedure		0
149	350	binx Memorandum Template	7	Quality Assurance	CO-QA-T-038	Templates		0
150	352	binx Report Template	7	Design	CO-DES-T-040	Templates		0
151	353	binx Technical Report Template	7	Design	CO-DES-T-041	Templates		0
152	354	binx Meeting Minutes Template	5	Quality Assurance	CO-QA-T-042	Templates		0
153	355	Mutual Agreement of Confidentiality	5	Operations	CO-OPS-T-043	Templates		0
154	356	Training Competence Assessment Form	4	Quality Assurance	CO-QA-T-044	Templates		0
155	357	Additional Training Form	4	Quality Assurance	CO-QA-T-045	Templates		0
156	359	Individual Training Plan Template	9	Quality Assurance	CO-QA-T-047	Templates		0
157	360	Specimen Signature Log	4	Quality Assurance	CO-QA-T-048	Templates		0
158	361	Document Acceptance Form	5	Quality Assurance	CO-QA-T-049	Templates		0
159	363	Controlled Lab Notes Template	6	Quality Control	CO-QC-T-051	Templates		0
160	364	Supplier Questionnaire - Calibration/Equipment maintenance	4	Supply Chain	CO-SUP-FRM-046	Forms		0
161	365	Supplier Questionnaire - Chemical/Reagent/Microbiological	4	Supply Chain	CO-SUP-FRM-042	Forms		0
162	366	Supplier Questionnaire - Hardware	4	Supply Chain	CO-SUP-FRM-047	Forms		0
163	367	Supplier Questionnaire - Consultant/Services	4	Supply Chain	CO-SUP-FRM-048	Forms		0
164	370	Project Planning Template	4	Design	CO-DES-T-058	Templates		0
165	371	FMEA template	3	Design	CO-DES-T-059	Templates		0
166	372	Verification Testing Protocol template	8	Design	CO-DES-T-060	Templates		0
167	373	Verification Testing Report template	7	Design	CO-DES-T-061	Templates		0
168	374	Risk Management Plan template	3	Design	CO-DES-T-062	Templates		0
169	375	Risk/benefit template	3	Design	CO-DES-T-063	Templates		0
170	376	Risk Management Report template	3	Design	CO-DES-T-064	Templates		0
171	377	Validation Master Plan  or Plan  template	5	Design	CO-DES-T-065	Templates		0
172	378	Validation Matrix template	2	Design	CO-DES-T-066	Templates		0
173	379	Hazard Analysis template	8	Design	CO-DES-T-067	Templates		0
174	380	Experimental Template: Write Up	5	Design	CO-DES-T-068	Templates		0
175	381	Copy Approval Form	3	Sales and Marketing	CO-SAM-T-069	Templates		0
176	383	Detection Reagent Analysis Template	5	Quality Control	CO-QC-T-071	Templates		0
177	385	Microbiology Laboratory Cleaning record	8	Quality Control	CO-QC-T-073	Templates		0
178	388	Environmental Chamber Monitoring Form	3	Quality Control	CO-QC-T-076	Templates		0
179	390	Field Action Implementation Checklist	4	Quality Assurance	CO-QA-T-078	Templates		0
180	391	Field Corrective Action File Review Form	3	Quality Assurance	CO-QA-T-079	Templates		0
181	394	qPCR QC Testing Data Analysis	14	Quality Control	CO-QC-T-082	Templates		0
182	395	product requirements Specification Template	3	Design	CO-DES-T-083	Templates		0
183	396	Pilot Line Electronic Stock Register	5	Design	CO-DES-T-084	Templates		0
184	397	Initial Risk Assessment and Supplier Approval	3	Supply Chain	CO-SUP-FRM-043	Forms		0
185	398	Supplier Re-assessment Approval form	4	Quality Assurance	CO-QA-T-086	Templates		0
186	399	Standard / Guidance Review	4	Quality Assurance	CO-QA-T-087	Templates		0
187	407	Reagent Aliquot From	6	Quality Control	CO-QC-T-095	Templates		0
188	408	Quarterly Reagent Check Record	4	Quality Control	CO-QC-T-096	Templates		0
189	410	Non Approved Supplier SAP by D supplier information	4	Supply Chain	CO-SUP-T-098	Templates		0
190	411	Device Master Record	2	Design	CO-DES-T-099	Templates		0
191	412	Purchase order terms & conditions	3	Supply Chain	CO-SUP-T-100	Templates		0
192	413	Marketing template	2	Sales and Marketing	CO-SAM-T-101	Templates		0
193	414	CTNG Cartridge Cof A	11	Quality Control	CO-QC-T-102	Templates		0
194	415	Lab investigation initiation Template	1	Quality Control	CO-QC-T-103	Templates		0
195	417	T7 QC Testing Data Analysis	7	Quality Control	CO-QC-T-105	Templates		0
196	418	Vigilance Form	3	Quality Assurance	CO-QA-T-106	Templates		0
197	419	Bioanalyzer Cleaning Record	3	Quality Control	CO-QC-T-107	Templates		0
198	421	Archiving Box Contents List	3	Quality Assurance	CO-QA-T-109	Templates		0
199	422	Document Retrieval Request	3	Quality Assurance	CO-QA-T-110	Templates		0
200	423	Generic Cartridge Subassembly Build	3	Operations	CO-OPS-T-111	Templates		0
201	424	Pilot Line Use Log	6	Design	CO-DES-T-112	Templates		0
202	425	Cartridge Stock Take Form	4	Supply Chain	CO-SUP-T-113	Templates		0
203	426	Validation Summary Report	2	Design	CO-DES-T-114	Templates		0
204	427	Incoming Oligo QC Form	3	Quality Control	CO-QC-T-115	Templates		0
205	430	Moby Detection Reagent Analysis Spreadsheet	12	Quality Control	CO-QC-T-118	Templates		0
206	432	QC Laboratory Cleaning Record	4	Quality Control	CO-QC-T-120	Templates		0
207	433	Impulse Sealer Use Log	2	Quality Control	CO-QC-T-121	Templates		0
208	434	Fixed Asset Transfer Form	2	Finance	CO-FIN-FRM-282	Forms		0
209	435	CAPA date extension form	3	Quality Assurance	CO-QA-T-123	Templates		0
210	436	Design Transfer Form	2	Design	CO-DES-T-124	Templates		0
211	437	Software Development Tool Approval	2	Design	CO-DES-T-125	Templates		0
212	438	Soup Approval	2	Design	CO-DES-T-126	Templates		0
213	440	LAB investigation summary report	1	Quality Control	CO-QC-T-128	Templates		0
214	441	Customer Requirements Specification	1	Design	CO-DES-T-129	Templates		0
215	442	Equipment Fulfilment Order	2	Operations	CO-OPS-T-130	Templates		0
216	443	Customer Service Script	1	Customer Support	CO-CS-T-131	Templates		0
217	444	Instrument Trouble Shooting Script	1	Customer Support	CO-CS-T-149	Templates		0
218	446	UK Trade Credit Application	2	Finance	CO-FIN-T-134	Templates		0
219	447	Equipment Return Order	3	Customer Support	CO-CS-T-135	Templates		0
220	448	Reagent Design template	1	Quality Control	CO-QC-T-136	Templates		0
221	449	Limited Laboratory Access Work Note	1	Quality Control	CO-QC-T-137	Templates		0
222	450	Summary technical Documentation  for assay	2	Quality Control	CO-QC-T-138	Templates		0
223	451	Cartridge and Packing Bill of Materials Template	1	Operations	CO-OPS-T-139	Templates		0
224	452	Measuring pH values IQ/OQ Protocol	2	Design	CO-DES-PTL-001	Protocol		0
225	453	Validation of Abacus Guardian	2	Design	CO-DES-PTL-002	Protocol		0
226	454	Reagent Design Transfer Checklist	1	Design	CO-DES-T-140	Templates		0
227	455	Document Signoff Front Sheet	2	Quality Assurance	CO-QA-T-141	Templates		0
228	456	Document and Record Disposition Form	1	Quality Assurance	CO-QA-T-142	Templates		0
229	457	Training Plan Quarterly Sign Off Form	1	Quality Assurance	CO-QA-T-143	Templates		0
230	458	QC io Mainternance Log	2	Quality Control	CO-QC-T-144	Templates		0
231	459	Certificate of Conformance	1	Quality Assurance	CO-QA-T-145	Templates		0
232	460	Temperature controlled equipment	3	Design	CO-DES-PTL-003	Protocol		0
233	461	Monmouth 1200	2	Design	CO-DES-PTL-004	Protocol		0
234	462	IQ/OQ for Agilent Bioanalyzer	2	Design	CO-DES-PTL-005	Protocol		0
235	463	Balance IQ/OQ	3	Design	CO-DES-PTL-006	Protocol		0
236	464	Pilot Line Process & Equipment Validation	3	Design	CO-DES-PTL-007	Protocol		0
237	465	Calibration of V&V Laboratory Timers	3	Design	CO-DES-PTL-008	Protocol		0
238	467	Sharepoint Administration	2	Quality Assurance	CO-QA-SOP-024	Standard Operating Procedure		0
239	468	Management Review	11	Quality Assurance	CO-QA-SOP-025	Standard Operating Procedure		0
240	469	Use of Sharepoint	6	Quality Assurance	CO-QA-SOP-026	Standard Operating Procedure		0
241	470	Quality Records	9	Quality Assurance	CO-QA-SOP-028	Standard Operating Procedure		0
242	471	QT9 SOP Template	1	Quality Assurance	CO-QA-T-146	Templates		0
243	472	Accessing and Finding Documents in QT9	3	Quality Assurance	CO-QA-SOP-030	Standard Operating Procedure		0
244	473	Revising and Introducing Documents in QT9	3	Quality Assurance	CO-QA-SOP-031	Standard Operating Procedure		0
245	474	Validation of Automated Equipment and Quality System Software	3	Operations	CO-OPS-SOP-032	Standard Operating Procedure		0
246	475	T7 Diluent  NZ Source BSA  Solution	3	Operations	CO-OPS-SOP-033	Standard Operating Procedure		0
247	476	Test Method Validation	3	Operations	CO-OPS-SOP-034	Standard Operating Procedure		0
248	477	Engineering Drawing Control	3	Operations	CO-OPS-SOP-035	Standard Operating Procedure		0
249	478	Instrument Engineering Change Management	2	Operations	CO-OPS-SOP-036	Standard Operating Procedure		0
250	481	Purchasing SOP	14	Supply Chain	CO-SUP-SOP-068	Standard Operating Procedure		0
251	483	Design Review Work Instruction	6	Design	CO-DES-SOP-041	Standard Operating Procedure		0
252	484	Creation and Maintenance of a Device Master Record  DMR	4	Design	CO-DES-SOP-042	Standard Operating Procedure		0
253	485	Training Procedure	7	Quality Assurance	CO-QA-SOP-043	Standard Operating Procedure		0
254	486	IT Management Back-UP and Support	5	Information Technology	CO-IT-SOP-044	Standard Operating Procedure		0
255	487	Supplier Evaluation	7	Supply Chain	CO-SUP-SOP-069	Standard Operating Procedure		0
256	488	Supplier Risk Assessment Approval and Monitoring Procedure	5	Supply Chain	CO-SUP-SOP-070	Standard Operating Procedure		0
257	489	Instructions for receipt of incoming Non-Stock goods  assigning GRN numbers and labelling	13	Supply Chain	CO-SUP-SOP-072	Standard Operating Procedure		0
258	490	Standard Cost Roll Up	2	Supply Chain	CO-SUP-SOP-073	Standard Operating Procedure		0
259	491	UK Stock Procurement & Movements  Supply Chain	2	Supply Chain	CO-SUP-SOP-074	Standard Operating Procedure		0
260	492	Order to Cash	2	Supply Chain	CO-SUP-SOP-075	Standard Operating Procedure		0
261	493	Change Management Register	9	Quality Assurance	CO-QA-REG-001	Registers		0
262	497	Supplier Concession Register	1	Quality Assurance	CO-QA-REG-005	Registers		0
263	498	Stakeholder Feedback and Product Complaints Handling Procedure	8	Quality Assurance	CO-QA-SOP-076	Standard Operating Procedure		0
264	500	Supplier Audit Procedure	10	Quality Assurance	CO-QA-SOP-077	Standard Operating Procedure		0
265	501	Bacterial Stock Register	2	Quality Assurance	CO-QA-REG-007	Registers		0
266	502	Preparation of Bacterial Stocks  Master & Working	6	Laboratory	CO-LAB-SOP-078	Standard Operating Procedure		0
267	503	Use and Cleaning of Class II Microbiology Safety Cabinet	7	Laboratory	CO-LAB-SOP-079	Standard Operating Procedure		0
268	504	Use of Agilent Bioanalyzer DNA 1000 kits	6	Laboratory	CO-LAB-SOP-080	Standard Operating Procedure		0
269	505	Collection of In-house Collected Samples	2	Clinical Affairs	CO-CA-SOP-081	Standard Operating Procedure		0
270	506	Use of the Rotary Vane Anemometer	1	Laboratory	CO-LAB-SOP-082	Standard Operating Procedure		0
271	507	Preparation of Trichomonas vaginalis 1 million Genome Equivalents/µL stocks	2	Operations	CO-OPS-SOP-083	Standard Operating Procedure		0
272	508	Preparation of Trichomonas vaginalis 100 thousand Genome Equivalents/µL stocks	2	Operations	CO-OPS-SOP-084	Standard Operating Procedure		0
273	509	Preparation of Chlamydia trachomatis 1 million Genome Equivalents/µL stocks	2	Operations	CO-OPS-SOP-085	Standard Operating Procedure		0
274	510	Preparation of Chlamydia trachomatis 100 thousand Genome Equivalents/µL stocks	2	Operations	CO-OPS-SOP-086	Standard Operating Procedure		0
275	511	Preparation of Neisseria gonorrhoeae 1 million Genome Equivalents/µL stocks	2	Operations	CO-OPS-SOP-087	Standard Operating Procedure		0
276	512	Preparation of Neisseria gonorrhoeae 100 thousand Genome Equivalents/µL stocks	2	Operations	CO-OPS-SOP-088	Standard Operating Procedure		0
277	513	Preparation of vaginal swab samples	4	Operations	CO-OPS-SOP-089	Standard Operating Procedure		0
278	514	MFG for preparing male and female urine with 10% eNAT	3	Operations	CO-OPS-SOP-090	Standard Operating Procedure		0
279	515	Manufacture of TV/IC Detection Reagent	5	Operations	CO-OPS-SOP-091	Standard Operating Procedure		0
280	516	mSTI Cartridge Manufacture	3	Operations	CO-OPS-SOP-092	Standard Operating Procedure		0
281	517	Corrective and Preventive Action Procedure	7	Quality Assurance	CO-QA-SOP-093	Standard Operating Procedure		0
282	518	Tween-20 binx Part Number 0002	2	Laboratory	CO-LAB-FRM-025	Forms		0
283	519	T7 Gene 6 Exonuclease 1000U/µL	8	Laboratory	CO-LAB-FRM-026	Forms		0
284	520	Dimethylsulfoxide Part Number 0227	3	Laboratory	CO-LAB-FRM-027	Forms		0
285	534	Consent for Voluntary Donation of In-house Collected Samples	2	Clinical Affairs	CO-CA-FRM-041	Forms		0
286	535	A Basic Guide to Finding Documents in SharePoint	1	Quality Assurance	CO-QA-JA-001	Job Aid		0
287	536	Heated Detection Rig OQ Procedure	4	Operations	CO-OPS-PTL-009	Protocol		0
288	537	Procedure to Control Chemical and Biological Spillages	5	Quality Control	CO-QC-SOP-094	Standard Operating Procedure		0
289	538	Instrument Cleaning Procedure	5	Laboratory	CO-LAB-SOP-095	Standard Operating Procedure		0
290	539	Analysis of Quality Data	5	Quality Assurance	CO-QA-SOP-096	Standard Operating Procedure		0
291	540	Wireless Temperature and Humidity Monitoring	15	Laboratory	CO-LAB-SOP-097	Standard Operating Procedure		0
292	541	Deviation Procedure	6	Quality Assurance	CO-QA-SOP-099	Standard Operating Procedure		0
293	543	Use of the Grant XB2 Ultrasonic Bath	4	Laboratory	CO-LAB-SOP-102	Standard Operating Procedure		0
294	544	Environmental Controls in the Laboratory	12	Laboratory	CO-LAB-SOP-103	Standard Operating Procedure		0
295	545	CT_IC Detection Reagent	7	Operations	CO-OPS-SOP-104	Standard Operating Procedure		0
296	546	NG1_IC Detection Reagent	8	Operations	CO-OPS-SOP-105	Standard Operating Procedure		0
297	547	Manufacture of NG2/IC Detection Reagent	7	Operations	CO-OPS-SOP-107	Standard Operating Procedure		0
298	548	Laboratory Cleaning	21	Laboratory	CO-LAB-SOP-108	Standard Operating Procedure		0
299	549	Clinical Trial Agreement	2	Clinical Affairs	CO-CA-T-147	Templates		0
300	550	Non-binx-initiated study proposal	1	Clinical Affairs	CO-CA-FRM-044	Forms		0
301	551	Use of the Priorclave Autoclave	8	Laboratory	CO-LAB-SOP-129	Standard Operating Procedure		0
302	552	Heated Detection Rig Work Instructions	2	Laboratory	CO-LAB-SOP-130	Standard Operating Procedure		0
303	553	Pipette Use and Calibration SOP	12	Laboratory	CO-LAB-SOP-131	Standard Operating Procedure		0
304	554	Manufacture of Elution Buffer Revision 2	4	Operations	CO-OPS-SOP-132	Standard Operating Procedure		0
305	555	Manufacture of Brij 58 Solution	8	Operations	CO-OPS-SOP-133	Standard Operating Procedure		0
306	556	Manufacture of Trehalose in PCR Buffer	7	Operations	CO-OPS-SOP-134	Standard Operating Procedure		0
307	557	Guidance for Use and Completion of MFG Documents	3	Laboratory	CO-LAB-SOP-135	Standard Operating Procedure		0
308	558	Manufacturing Lot Number Register	5	Laboratory	CO-LAB-REG-008	Registers		0
309	559	Solution Preparation SOP	6	Laboratory	CO-LAB-SOP-136	Standard Operating Procedure		0
310	560	Variable Temperature Apparatus Monitoring	7	Laboratory	CO-LAB-SOP-137	Standard Operating Procedure		0
311	561	Use of Temperature and Humidity Loggers	4	Laboratory	CO-LAB-SOP-138	Standard Operating Procedure		0
312	562	Change Management Procedure for Product/Project Documents	15	Quality Assurance	CO-QA-SOP-139	Standard Operating Procedure		0
313	563	Policy for Document Control and Change Management	5	Quality Assurance	CO-QA-POL-006	Policy		0
314	566	CTNG T7 Diluent	4	Operations	CO-OPS-SOP-142	Standard Operating Procedure		0
315	569	Template for Laboratory Code of Practice	1	Laboratory	CO-LAB-T-148	Templates		0
316	570	Handling Biological Materials	5	Laboratory	CO-LAB-SOP-145	Standard Operating Procedure		0
317	572	Managing an External Regulatory Visit from the FDA	4	Quality Assurance	CO-QA-SOP-147	Standard Operating Procedure		0
318	573	Training Policy	3	Human Resources	CO-HR-POL-007	Policy		0
319	574	Policy for Purchasing and Management of Suppliers	5	Operations	CO-OPS-POL-008	Policy		0
320	575	Verification and Validation Policy	4	Clinical Affairs	CO-CA-POL-009	Policy		0
321	576	Policy for Control of Infrastructure Environment and Equipment	5	Quality Assurance	CO-QA-POL-010	Policy		0
322	577	WEEE Policy	2	Operations	CO-OPS-POL-011	Policy		0
323	578	Policy for Customer Feedback	5	Customer Support	CO-CS-POL-012	Policy		0
324	579	Policy for Complaints and Vigilance	2	Quality Assurance	CO-QA-POL-013	Policy		0
325	580	Reagent Aliquotting	11	Laboratory	CO-LAB-SOP-148	Standard Operating Procedure		0
326	581	Introducing New Laboratory Equipment	5	Laboratory	CO-LAB-SOP-149	Standard Operating Procedure		0
327	582	Standard Use of Freezers	9	Laboratory	CO-LAB-SOP-150	Standard Operating Procedure		0
328	583	Management and Control of Critical and Controlled Equipment	10	Laboratory	CO-LAB-SOP-151	Standard Operating Procedure		0
329	584	Instrument Failure Reporting SOP	2	Laboratory	CO-LAB-SOP-152	Standard Operating Procedure		0
330	585	Use of UV Cabinets	7	Laboratory	CO-LAB-SOP-153	Standard Operating Procedure		0
331	586	QC Laboratory Cleaning Procedure	5	Quality Control	CO-QC-SOP-154	Standard Operating Procedure		0
332	587	T7 Raw Material Test	12	Quality Control	CO-QC-QCP-039	Quality Control Protocol		0
333	588	Reader Installation Qualification Protocol	14	Operations	CO-OPS-PTL-010	Protocol		0
334	590	Experimental Write Up	8	Laboratory	CO-LAB-SOP-155	Standard Operating Procedure		0
335	591	Control of Controlled Laboratory Notes	9	Laboratory	CO-LAB-SOP-156	Standard Operating Procedure		0
336	593	Use of the NanoDrop ND2000 Spectrophotometer	5	Laboratory	CO-LAB-SOP-158	Standard Operating Procedure		0
337	594	Use of Rotor-Gene Q	4	Laboratory	CO-LAB-SOP-159	Standard Operating Procedure		0
338	595	Use of the Miele Laboratory Glassware Washer G7804	2	Laboratory	CO-LAB-SOP-160	Standard Operating Procedure		0
339	596	Elix Deionised Water System	2	Laboratory	CO-LAB-SOP-161	Standard Operating Procedure		0
340	598	Running Cartridges on io Readers	8	Laboratory	CO-LAB-SOP-163	Standard Operating Procedure		0
341	599	Bambi compressor: Use and Maintenance	3	Laboratory	CO-LAB-SOP-164	Standard Operating Procedure		0
342	600	Windows Software Update	1	Operations	CO-OPS-SOP-165	Standard Operating Procedure		0
343	601	Pneumatics Test Rig Set up and Calibration	2	Operations	CO-OPS-SOP-166	Standard Operating Procedure		0
344	602	Attaching Electrode and Blister Adhesive and Blister Pack and Cover  M600	5	Laboratory	CO-LAB-SOP-167	Standard Operating Procedure		0
345	603	Jenway 3510 model pH Meter	4	Laboratory	CO-LAB-SOP-168	Standard Operating Procedure		0
346	604	Use of Fermant Pouch Sealer	3	Laboratory	CO-LAB-SOP-169	Standard Operating Procedure		0
347	605	Rapid PCR Rig Work Instructions	3	Laboratory	CO-LAB-SOP-170	Standard Operating Procedure		0
348	606	Quality Control Rounding Procedure	3	Quality Control	CO-QC-SOP-171	Standard Operating Procedure		0
349	607	Tool Changes of the Rhychiger Heat Sealer	3	Operations	CO-OPS-SOP-172	Standard Operating Procedure		0
350	608	Laboratory Investigation  LI  Procedure for Invalid Assays and Out of Specification  OOS  Results	3	Quality Control	CO-QC-SOP-173	Standard Operating Procedure		0
351	609	Engineering Rework Procedure	2	Operations	CO-OPS-SOP-174	Standard Operating Procedure		0
352	610	Out of Hours Power Loss and Temperature Monitoring	3	Laboratory	CO-LAB-SOP-175	Standard Operating Procedure		0
353	611	Guidance for the use and completion of IQC documents	2	Laboratory	CO-LAB-SOP-176	Standard Operating Procedure		0
354	612	Operating instruction for the QuantStudio 3D digital PCR system	1	Laboratory	CO-LAB-SOP-177	Standard Operating Procedure		0
355	613	Operating Instructions for Signal Analyser	1	Laboratory	CO-LAB-SOP-178	Standard Operating Procedure		0
356	614	Cleaning Procedure for Microbiology Lab	3	Laboratory	CO-LAB-SOP-179	Standard Operating Procedure		0
357	615	Reconstitution of Lyophilised Materials	3	Laboratory	CO-LAB-SOP-180	Standard Operating Procedure		0
358	616	Use of the Thermomixer HC block	1	Laboratory	CO-LAB-SOP-181	Standard Operating Procedure		0
359	617	Limited Laboratory Access Procedure	2	Laboratory	CO-LAB-SOP-182	Standard Operating Procedure		0
360	618	Use of the Microcentrifuge 24	1	Laboratory	CO-LAB-SOP-183	Standard Operating Procedure		0
361	619	Pilot Line Blister Filling and Sealing Standard Operating Procedure	2	Laboratory	CO-LAB-SOP-184	Standard Operating Procedure		0
362	620	Use of the SB3 Rotator	2	Quality Control	CO-QC-SOP-185	Standard Operating Procedure		0
363	621	Use of the VPUMP Vacuum pump	2	Operations	CO-OPS-SOP-186	Standard Operating Procedure		0
364	622	Force Test Rig Set up and Calibration	3	Operations	CO-OPS-SOP-187	Standard Operating Procedure		0
365	623	Process Validation	4	Operations	CO-OPS-SOP-188	Standard Operating Procedure		0
366	624	QC Monthly Laboratory Checklist	0	Quality Control	CO-QC-FRM-049	Forms		0
367	625	Quality Control Laboratory Code of Practice	3	Quality Control	CO-QC-COP-001	Code of Practice		0
368	626	Rapid PCR Rig OQ Procedure	2	Operations	CO-OPS-PTL-011	Protocol		0
369	627	Incoming Quality Control and Specification for ‘CMO Manufactured io® Cartridges’	8	Laboratory	CO-LAB-FRM-050	Forms		0
370	628	CT/NG ATCC Input Generation	14	Operations	CO-OPS-SOP-189	Standard Operating Procedure		0
371	631	Incoming Quality Control and Specification for ‘NG1 Plasmid in TE buffer’ Materials binx Part Number: 0346	0	Laboratory	CO-LAB-FRM-041	Forms		0
372	632	Incoming Quality Control and Specification for ‘NG2 Plasmid in TE buffer’ Materials binx Part Number: 0347	0	Laboratory	CO-LAB-FRM-042	Forms		0
373	633	Incoming Quality Control and Specification for ‘CT Plasmid in TE buffer’ Materials binx Part Number: 0348	0	Laboratory	CO-LAB-FRM-043	Forms		0
374	636	Preparation of IC DNA in TE buffer 10ng/μl master stock aliquots	3	Operations	CO-OPS-SOP-190	Standard Operating Procedure		0
375	638	Verification Testing Process SOP	3	Operations	CO-OPS-SOP-192	Standard Operating Procedure		0
376	639	WATER FOR MOLECULAR BIOLOGY Part Number 0005	5	Laboratory	CO-LAB-FRM-051	Forms		0
377	641	SODIUM CHLORIDE Part Number 0008	4	Laboratory	CO-LAB-FRM-052	Forms		0
378	642	‘TRIS  TRIZMA®  HYDROCHLORIDE’ Part Number: 0011	5	Laboratory	CO-LAB-FRM-053	Forms		0
379	643	Part No. 0014 ‘Potassium Chloride’	5	Laboratory	CO-LAB-FRM-054	Forms		0
380	644	‘Safe View DNA Stain’  Part Number 0079	5	Laboratory	CO-LAB-FRM-055	Forms		0
381	645	Part No. 0086 Buffer solution pH 7	5	Laboratory	CO-LAB-FRM-056	Forms		0
382	646	Part No. 0085 Buffer solution pH 4	4	Laboratory	CO-LAB-FRM-057	Forms		0
383	647	Part No. 0087 Buffer solution pH 10	5	Laboratory	CO-LAB-FRM-058	Forms		0
384	648	‘50mM dUTP MIX’ Part no. 0088	5	Laboratory	CO-LAB-FRM-059	Forms		0
385	649	Part no. 0089 70% ethanol	4	Laboratory	CO-LAB-FRM-060	Forms		0
386	650	Part No. 0093 CT ME17 Synthetic target HPLC GRADE	6	Laboratory	CO-LAB-FRM-061	Forms		0
387	651	‘Guanidine Thiocyanate’ Part Number: 0094	5	Laboratory	CO-LAB-FRM-062	Forms		0
388	652	‘MES’ Part No. 0095	5	Laboratory	CO-LAB-FRM-063	Forms		0
389	653	Part No. 0104 – Tryptone Soya Broth	2	Laboratory	CO-LAB-FRM-064	Forms		0
390	654	Quality Control Out of Specification Result Investigation Record Form	1	Quality Control	CO-QC-FRM-065	Forms		0
391	655	Quality Control Out of Specification Results Procedure	1	Quality Control	CO-QC-SOP-012	Standard Operating Procedure		0
392	656	C. trachomatis serotype F Elementary Bodies Part No. 0106	5	Laboratory	CO-LAB-FRM-066	Forms		0
393	657	Sarcosine’ Part no: 0108	5	Laboratory	CO-LAB-FRM-067	Forms		0
394	658	1M Magnesium Chloride solution molecular biology grade Part No. 0115	4	Laboratory	CO-LAB-FRM-068	Forms		0
395	659	Part No. 0118 IC Synthetic target HPLC GRADE	6	Laboratory	CO-LAB-FRM-069	Forms		0
396	660	Part No. 0125 Potassium Phospate Monobasic	5	Laboratory	CO-LAB-FRM-070	Forms		0
397	661	Potassium Phosphate Dibasic’ Part No.0147	4	Laboratory	CO-LAB-FRM-071	Forms		0
398	662	‘Part No. 0148 DL-Dithiothreitol’	4	Laboratory	CO-LAB-FRM-072	Forms		0
399	663	1L Nalgene Disposable Filter Unit’ Part No. 0167	4	Laboratory	CO-LAB-FRM-073	Forms		0
400	664	CT synthetic target containing Uracil Part no: 0168	6	Laboratory	CO-LAB-FRM-074	Forms		0
401	665	‘γ Aminobutyric acid’ Part Number: 0178	3	Laboratory	CO-LAB-FRM-075	Forms		0
402	666	Part Number 0188 Vircell CT DNA Control	2	Laboratory	CO-LAB-FRM-076	Forms		0
403	667	‘Albumin from bovine serum – New Zealand Source’ Part Number: 0219	5	Laboratory	CO-LAB-FRM-077	Forms		0
404	668	Part no. 0222 CO2 Gen sachets	3	Laboratory	CO-LAB-FRM-078	Forms		0
405	669	‘Uracil DNA Glycosylase [50 thousand U/mL]’ Part Number 0240	4	Laboratory	CO-LAB-FRM-079	Forms		0
406	670	‘DNase Alert Buffer’ Part Number 0241	3	Laboratory	CO-LAB-FRM-080	Forms		0
407	671	‘DNase Alert Substrate’ Part Number 0242	3	Laboratory	CO-LAB-FRM-081	Forms		0
408	672	Part No. 0248 Pectobacterium atrosepticum chromosomal DNA in TE buffer	4	Laboratory	CO-LAB-FRM-082	Forms		0
409	674	NG1 Synthetic Target Part No 0258	3	Laboratory	CO-LAB-FRM-084	Forms		0
410	675	NG2 Synthetic Target Part no 0259	3	Laboratory	CO-LAB-FRM-085	Forms		0
411	676	‘0260 CT Forward Primer from SGS DNA’	6	Laboratory	CO-LAB-FRM-086	Forms		0
412	677	Part No 0261 ‘CT Reverse Mod Primer’ from SGS DNA	6	Laboratory	CO-LAB-FRM-087	Forms		0
413	678	Incoming Quality Control and Specification for ‘IC Forward Primer’ from SGS DNA: Part number 0262 and 0419	6	Laboratory	CO-LAB-FRM-088	Forms		0
414	679	Part No 0263 ‘IC Reverse Primer’ from SGS DNA	5	Laboratory	CO-LAB-FRM-089	Forms		0
415	680	Part No 0264 ‘NG Target 1 Forward Primer’ from SGS DNA	5	Laboratory	CO-LAB-FRM-090	Forms		0
416	681	Part No 0265 ‘NG Target 1 RA Reverse Primer’ from SGS DNA	5	Laboratory	CO-LAB-FRM-091	Forms		0
417	682	Part No 0266 ‘NG Target 2 Forward Primer’ from SGS DNA	5	Laboratory	CO-LAB-FRM-092	Forms		0
418	683	Part No 0267 ‘NG Target 2 Reverse Primer’ from SGS DNA	5	Laboratory	CO-LAB-FRM-093	Forms		0
419	684	NG1 Taqman Probe HPLC GRADE Part no 0268	3	Laboratory	CO-LAB-FRM-094	Forms		0
420	685	NG2 Taqman probe HPLC GRADE Part No 0269	3	Laboratory	CO-LAB-FRM-095	Forms		0
421	686	‘25U/µL Taq-B DNA Polymerase  Low Glycerol ’ Part Number 0270	3	Laboratory	CO-LAB-FRM-096	Forms		0
422	687	‘0271 gyrA_F_Fwd primer’	3	Laboratory	CO-LAB-FRM-097	Forms		0
423	689	‘Neisseria gonorrhoeae DNA’ Part Number 0273	2	Laboratory	CO-LAB-FRM-099	Forms		0
424	690	‘CT/NG: IC DNA Reagent	8	Laboratory	CO-LAB-FRM-100	Forms		0
425	691	‘CT/NG: NG1/NG2/IC Primer Passivation Reagent	9	Laboratory	CO-LAB-FRM-101	Forms		0
426	692	‘CT/NG: TaqUNG Reagent	8	Laboratory	CO-LAB-FRM-102	Forms		0
427	693	CT/NG: NG1/IC Detection Reagent	8	Laboratory	CO-LAB-FRM-103	Forms		0
428	694	‘CT/NG: NG2/IC Detection Reagent	8	Laboratory	CO-LAB-FRM-104	Forms		0
429	695	CT/NG: CT/IC Primer Passivation Reagent	9	Laboratory	CO-LAB-FRM-105	Forms		0
430	696	‘CT/NG: CT/IC Detection Reagent	8	Laboratory	CO-LAB-FRM-106	Forms		0
431	697	‘IC di275 Probe from SGS’ Part No. 0288	4	Laboratory	CO-LAB-FRM-107	Forms		0
432	698	‘CT di452 Probe from SGS’ Part No. 0289	4	Laboratory	CO-LAB-FRM-108	Forms		0
433	699	Internal Control di275 Probe from ATDBio Part Number 0294	2	Laboratory	CO-LAB-FRM-109	Forms		0
434	700	Part No. 0295 ‘Sterile Syringe Filter with 0.45µm Cellulose Acetate Membrane’	2	Laboratory	CO-LAB-FRM-110	Forms		0
435	701	Part No. 0296 Chlamydia trachomatis serovar F ATCC VR-346	3	Laboratory	CO-LAB-FRM-111	Forms		0
436	702	Part Number 0298 Vircell NG DNA Control	2	Laboratory	CO-LAB-FRM-112	Forms		0
437	703	Part Number 0299 Vircell TV DNA control	2	Laboratory	CO-LAB-FRM-113	Forms		0
438	704	Part Number 0300 Vircell MG DNA Control	2	Laboratory	CO-LAB-FRM-114	Forms		0
439	709	‘Trichomonas vaginalis Cultured Stock’ P/N:0310	2	Laboratory	CO-LAB-FRM-119	Forms		0
440	710	Metronidazole resistant Trichomonas Vaginalis Cultured Stocks Part no. 0312	1	Laboratory	CO-LAB-FRM-120	Forms		0
441	711	Part No. 0316 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.45 µm surfactant-free Cellulose Acetate Membrane’	1	Laboratory	CO-LAB-FRM-121	Forms		0
442	712	Part No. 0317 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane’	1	Laboratory	CO-LAB-FRM-122	Forms		0
443	713	Part No. 0318  NATtrol Chlamydia trachomatis Positive Control	1	Laboratory	CO-LAB-FRM-123	Forms		0
444	714	Part No. 0319 NATrol Neisseria gonorrhoeae Positive Control	2	Laboratory	CO-LAB-FRM-124	Forms		0
445	715	10x TBE electrophoresis buffer Part Number 0326	1	Laboratory	CO-LAB-FRM-125	Forms		0
446	716	50bp DNA Ladder binx Part Number 0329	2	Laboratory	CO-LAB-FRM-126	Forms		0
447	717	‘TV_Alt_6_Fwd’ Part No. 0330 from SGS DNA	2	Laboratory	CO-LAB-FRM-127	Forms		0
448	718	‘TV_Alt_6_Rev’ Part No 0331 from SGS DNA	2	Laboratory	CO-LAB-FRM-128	Forms		0
449	719	‘TV_Alt_A di452 Probe from SGS’ Part Number 0332	2	Laboratory	CO-LAB-FRM-129	Forms		0
450	726	Part No. 0339 ‘NG2_di275_probe’ from SGS DNA	1	Laboratory	CO-LAB-FRM-136	Forms		0
451	727	‘HS anti-Taq mAb  5.7 mg/mL ’ Part no: 0340	2	Laboratory	CO-LAB-FRM-137	Forms		0
452	728	‘Potassium Chloride Solution’ Part Number: 0341	1	Laboratory	CO-LAB-FRM-138	Forms		0
453	729	‘Tris  1M  pH8.0’ Part no: 0342	1	Laboratory	CO-LAB-FRM-139	Forms		0
454	730	Hot Start Taq  PCR Biosystems LTD  P/N:0344	2	Laboratory	CO-LAB-FRM-140	Forms		0
455	731	Part No. 0345 CampyGen  sachets	1	Laboratory	CO-LAB-FRM-141	Forms		0
456	758	SOP to record the details of the manufacture of 75x PCR buffer	3	Operations	CO-OPS-SOP-196	Standard Operating Procedure		0
457	759	Validation -80 Freezer QC Lab	1	Operations	CO-OPS-PTL-013	Protocol		0
458	760	Validation -80 Chest Freezer Micro lab	2	Operations	CO-OPS-PTL-014	Protocol		0
459	761	Validation 2-8 Refrigerator QC Lab	1	Operations	CO-OPS-PTL-015	Protocol		0
460	762	Manufacture of Taq/UNG Reagent	9	Operations	CO-OPS-SOP-197	Standard Operating Procedure		0
461	763	Manufacture of microorganism glycerol stocks	6	Operations	CO-OPS-SOP-198	Standard Operating Procedure		0
462	764	Manufacture of CT/NG Negative Control Samples	7	Laboratory	CO-LAB-SOP-199	Standard Operating Procedure		0
463	765	Manufacture of Chlamydia trachomatis and Neisseria gonorrhoeae positive control samples	8	Operations	CO-OPS-SOP-200	Standard Operating Procedure		0
464	767	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	2	Operations	CO-OPS-SOP-202	Standard Operating Procedure		0
465	768	Manufacture of Wash Buffer II	3	Operations	CO-OPS-SOP-203	Standard Operating Procedure		0
466	770	Manufacture of 200mM Tris pH8.0	4	Operations	CO-OPS-SOP-205	Standard Operating Procedure		0
467	771	Manufacture of 1.5 M Trehalose	2	Operations	CO-OPS-SOP-206	Standard Operating Procedure		0
468	773	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	1	Operations	CO-OPS-SOP-208	Standard Operating Procedure		0
469	774	Preparation of bulk male urine plus 10% eNAT  v/v	1	Operations	CO-OPS-SOP-209	Standard Operating Procedure		0
470	793	Manufacture of Ab-HS Taq/UNG Reagent	2	Operations	CO-OPS-SOP-228	Standard Operating Procedure		0
471	794	Manufacture of CT/TV/IC Primer Buffer Reagent	2	Operations	CO-OPS-SOP-229	Standard Operating Procedure		0
472	796	Validation Protocol -20 freezer/QC lab asset 0330	1	Quality Control	CO-QC-PTL-016	Protocol		0
473	797	Validation Protocol: Thermal cycler IQ/OQ/PQ	4	Operations	CO-OPS-PTL-017	Protocol		0
474	798	Validation Protocol – UV/Vis Nanodrop Spectrophotometer	2	Operations	CO-OPS-PTL-018	Protocol		0
475	799	Validation of Autolab Type III	2	Operations	CO-OPS-PTL-019	Protocol		0
476	800	Validation Protocol Temperature controlled storage/incubation	3	Operations	CO-OPS-PTL-020	Protocol		0
477	801	Validation Protocol for Rotorgene	4	Operations	CO-OPS-PTL-021	Protocol		0
478	802	Validation Protocol - V&V Laboratory Facilities	1	Operations	CO-OPS-PTL-022	Protocol		0
479	803	io Reader - Digital Pressure Regulator Calibration Protocol	2	Operations	CO-OPS-PTL-023	Protocol		0
480	804	io Reader - Pneumatics End Test Protocol	1	Operations	CO-OPS-PTL-024	Protocol		0
481	805	io Reader – Force End Test Protocol	2	Operations	CO-OPS-PTL-025	Protocol		0
482	806	io® Reader – Thermal End Test Protocol	2	Operations	CO-OPS-PTL-026	Protocol		0
483	807	Rapid PCR Rig IQ Protocol	2	Operations	CO-OPS-PTL-027	Protocol		0
484	808	Rapid PCR Rig PQ Procedure	4	Operations	CO-OPS-PTL-028	Protocol		0
485	809	Heated Detection Rig IQ Procedure	2	Operations	CO-OPS-PTL-029	Protocol		0
486	810	Validation Protocol – Heated Detection Rig PQ	7	Operations	CO-OPS-PTL-030	Protocol		0
487	811	EOL thermal test 21011-MET-012 Thermal-PCR Cycle Template for TTDL-No.2.xlsx v4.0	3	Operations	CO-OPS-PTL-031	Protocol		0
488	815	Validation Protocol: 21011-MET012 Thermal - PCR Cycle Results Template Master	2	Operations	CO-OPS-PTL-036	Protocol		0
489	816	Blister Cropping Press IQ and OQ Validation Protocol	1	Operations	CO-OPS-PTL-037	Protocol		0
490	817	Blister Filling Rig and Cropping Press PQ Validation Protocol	3	Operations	CO-OPS-PTL-038	Protocol		0
491	818	OQ Validation Protocol Blister Filling Rig	1	Operations	CO-OPS-PTL-039	Protocol		0
492	819	IQ Validation Protocol Blister Filling Rig	1	Operations	CO-OPS-PTL-040	Protocol		0
493	821	PAN-D-267 Signal Analyzer Validation of functions for outputting V&V tables	1	Operations	CO-OPS-PTL-043	Protocol		0
494	823	New Items	2	Supply Chain	CO-SUP-SOP-231	Standard Operating Procedure		0
495	828	Asset Register	3	Laboratory	CO-LAB-REG-011	Registers		0
496	829	Part No Register	1	Laboratory	CO-LAB-REG-012	Registers		0
497	830	Pipette Register	3	Laboratory	CO-LAB-REG-013	Registers		0
498	831	GRN Register	22	Laboratory	CO-LAB-REG-014	Registers		0
499	832	Stock Item Register	10	Laboratory	CO-LAB-REG-015	Registers		0
500	834	Consumables Register	2	Laboratory	CO-LAB-REG-016	Registers		0
501	835	Equipment Service and Calibration Register	6	Laboratory	CO-LAB-REG-017	Registers		0
502	836	Micro Monthly Laboratory Checklist-Rev_0	0	Quality Control	CO-QC-FRM-046	Forms		0
503	837	Enviromental Monitoring Results Register	2	Laboratory	CO-LAB-REG-018	Registers		0
504	838	Laboratory Investigation Register	1	Laboratory	CO-LAB-REG-019	Registers		0
505	839	Batch Retention Register	1	Laboratory	CO-LAB-REG-020	Registers		0
506	840	Laboratory Responsibilities by Area	9	Laboratory	CO-LAB-REG-021	Registers		0
507	841	Vigilance Register	2	Quality Assurance	CO-QA-REG-022	Registers		0
508	843	Master Archive Register	2	Quality Assurance	CO-QA-REG-023	Registers		0
509	844	Archived Document Retrieval Log	1	Quality Assurance	CO-QA-REG-024	Registers		0
510	845	Supplier Risk Assessment Monitoring List	4	Quality Assurance	CO-QA-REG-025	Registers		0
511	846	IQ Protocol for Binder incubator and humidity chamber	0	Laboratory	CO-LAB-PTL-045	Protocol		0
512	847	OQ protocol for binder incubator and humidity chamber	0	Laboratory	CO-LAB-PTL-046	Protocol		0
513	848	PQ Protocol for binder incubator and humidity chamber	0	Laboratory	CO-LAB-PTL-047	Protocol		0
514	849	Manufacturing Procedure  MFG  Template	1	Operations	CO-OPS-T-152	Templates		0
515	850	Binder incubator and humidity chamber User Requirement Specification	0	Laboratory	CO-LAB-URS-001	User Requirements Specification		0
516	851	Instrument Register	6	Operations	CO-OPS-REG-026	Registers		0
517	852	CL2 Microbiology Laboratory Code of Practice	2	Quality Control	CO-QC-COP-002	Code of Practice		0
518	853	Job Aid Template	2	Quality Assurance	CO-QA-T-153	Templates		0
519	854	Legacy Document Number Crosswalk	6	Quality Assurance	CO-QA-JA-002	Job Aid		0
520	855	QT9 - Periodic Review and Making Documents Obsolete	0	Quality Assurance	CO-QA-SOP-237	Standard Operating Procedure		0
521	857	Microorganism Ampoules Handling SOP	0	Laboratory	CO-LAB-SOP-239	Standard Operating Procedure		0
522	859	Policy for the Control of Non-Conforming Product and Corrective/Preventive Action	4	Quality Assurance	CO-QA-POL-014	Policy		0
523	860	New Microorganism Introduction Checklist Form	0	Laboratory	CO-LAB-FRM-165	Forms		0
524	866	Controlled Laboratory Equipment Software List	3	Information Technology	CO-IT-REG-028	Registers		0
525	867	binx health ltd Master Assay Code Register	7	Operations	CO-OPS-REG-029	Registers		0
526	868	Training Register	6	Human Resources	CO-HR-REG-030	Registers		0
527	869	Donor Number Consent Register	1	Clinical Affairs	CO-CA-REG-031	Registers		0
528	870	Ordering of New Reagents and Chemicals	0	Laboratory	CO-LAB-SOP-241	Standard Operating Procedure		0
529	882	Approved material label	2	Laboratory	CO-LAB-LBL-003	Label		0
530	883	For Indication Only Label	1	Laboratory	CO-LAB-LBL-004	Label		0
531	884	GRN for R&D and Samples Label	3	Laboratory	CO-LAB-LBL-005	Label		0
532	885	Part No GRN Label	3	Laboratory	CO-LAB-LBL-006	Label		0
533	886	Expiry Dates Label	3	Laboratory	CO-LAB-LBL-007	Label		0
534	887	Pipette Calibration Label	1	Laboratory	CO-LAB-LBL-008	Label		0
535	888	Quarantine - Failed calibration Label	2	Laboratory	CO-LAB-LBL-009	Label		0
536	889	Failed Testing - Not in use Label	2	Laboratory	CO-LAB-LBL-010	Label		0
537	890	Solutions labels	3	Laboratory	CO-LAB-LBL-011	Label		0
538	891	Code Review	0	Software Development	CO-SD-FRM-171	Forms		0
539	892	General Calibration Label	2	Laboratory	CO-LAB-LBL-012	Label		0
540	893	In process MFG material label	3	Laboratory	CO-LAB-LBL-013	Label		0
541	894	Quarantined material label	3	Laboratory	CO-LAB-LBL-014	Label		0
542	895	Consumables Label	2	Laboratory	CO-LAB-LBL-015	Label		0
543	896	MBG water label	3	Laboratory	CO-LAB-LBL-016	Label		0
544	897	Equipment Under Qualification Label	2	Laboratory	CO-LAB-LBL-017	Label		0
545	899	Asset Calibration Label	2	Laboratory	CO-LAB-LBL-019	Label		0
546	900	SAP Stock Item Label	2	Laboratory	CO-LAB-LBL-020	Label		0
547	901	Cartridge Materials Label	1	Laboratory	CO-LAB-LBL-021	Label		0
548	902	Quarantine Stock Item Label	1	Laboratory	CO-LAB-LBL-022	Label		0
549	903	Pilot Line Materials Label	1	Laboratory	CO-LAB-LBL-023	Label		0
550	904	Elution Reagent Label	4	Laboratory	CO-LAB-LBL-024	Label		0
551	905	Equipment Not Maintained Do Not Use Label	2	Laboratory	CO-LAB-LBL-025	Label		0
552	906	CIR Label	2	Laboratory	CO-LAB-LBL-026	Label		0
553	907	Interim CTNG CLIA Waiver Outer Shipper Label	1	Operations	CO-OPS-LBL-027	Label		0
554	908	UN3316 cartridge label - use Avery J8173 labels to print	1	Operations	CO-OPS-LBL-028	Label		0
555	909	QT9 Administration	2	Quality Assurance	CO-QA-SOP-244	Standard Operating Procedure		0
556	912	io Release Record  following repair or refurbishment	3	Operations	CO-OPS-PTL-048	Protocol		0
557	914	Policy for the Use of Electronic Signatures within binx health	0	Quality Assurance	CO-QA-POL-015	Policy		0
558	915	CTNG QC Cartridge Analysis Module	0	Quality Control	CO-QC-T-155	Templates		0
559	916	Use of CO-QC-T-155: CTNG QC Cartridge Analysis Module	0	Quality Control	CO-QC-JA-004	Job Aid		0
560	917	URS for Temperature Monitoring System	1	Operations	CO-OPS-URS-002	User Requirements Specification		0
561	920	Procedure For Customer Service	2	Customer Support	CO-CS-SOP-248	Standard Operating Procedure		0
562	925	vT flow and leak tester- FAT protocol	0	Operations	CO-OPS-PTL-049	Protocol		0
563	926	Factory Acceptance Test  FAT   TQC in-line leak test equipment	0	Operations	CO-OPS-PTL-050	Protocol		0
564	927	Factory Acceptance Test  FAT  Sprint B+ In-line Leak Tester	0	Operations	CO-OPS-PTL-051	Protocol		0
565	928	User Requirement Specification for the vT off-line flow and leak test equipment	0	Operations	CO-OPS-URS-006	User Requirements Specification		0
566	929	TQC leak tester- User Requirement Specification	0	Operations	CO-OPS-URS-007	User Requirements Specification		0
567	930	Sprint B+ leak tester- User Requirement Specification	0	Operations	CO-OPS-URS-008	User Requirements Specification		0
568	932	Use of the Management Review Module in QT9	1	Quality Assurance	CO-QA-JA-006	Job Aid		0
569	933	User Requirement Specification for pH/mV/°C Meter	1	Operations	CO-OPS-URS-009	User Requirements Specification		0
570	934	User Requirement Specification for temperature-controlled equipment	0	Operations	CO-OPS-URS-010	User Requirements Specification		0
571	935	User Requirement Specification for back up power supply	0	Operations	CO-OPS-URS-011	User Requirements Specification		0
572	936	User Requirement Specification for a Production Enclosure	0	Operations	CO-OPS-URS-012	User Requirements Specification		0
573	937	User requirement specification for class 2 microbiological safety cabinet	0	Operations	CO-OPS-URS-013	User Requirements Specification		0
574	938	io Insepction using Data Collection Cartridge	0	Customer Support	CO-CS-SOP-249	Standard Operating Procedure		0
575	939	io Inspection using Data Collection Cartridge Form	0	Customer Support	CO-CS-FRM-175	Forms		0
576	941	User requirement specification for a filter integrity tester	0	Operations	CO-OPS-URS-014	User Requirements Specification		0
577	942	User requirement specification for a cooled incubator	0	Operations	CO-OPS-URS-015	User Requirements Specification		0
578	946	User Requirement Specification for ByD for binx Reagent Manufacturing Facility	0	Supply Chain	CO-SUP-URS-017	User Requirements Specification		0
579	947	Regulatory Change Assessment	0	Regulatory	CO-REG-T-157	Templates		0
580	948	Reagent Handling Processor for Scienion Dispense Equipment	0	Operations	CO-OPS-URS-018	User Requirements Specification		0
581	949	User Requirement Specification  URS  template	0	Quality Assurance	CO-QA-T-158	Templates		0
582	951	binx health Vendor Information Form	0	Supply Chain	CO-SUP-FRM-177	Forms		0
583	952	Use of Benchmark Roto-Therm Plus Hybridisation oven	1	Production line 1 - Oak House	CO-PRD1-SOP-252	Standard Operating Procedure		0
584	956	User Requirement Specification for a Balance	1	Operations	CO-OPS-URS-019	User Requirements Specification		0
585	957	Autoclave Biological Indicator Check Form	0	Laboratory	CO-LAB-T-159	Templates		0
586	959	Use & Cleaning of the Monmouth Scientific Model Guardian 1800 Production Enclosure in Oak House	1	Production line 1 - Oak House	CO-PRD1-SOP-254	Standard Operating Procedure		0
587	961	Mini Fuge Plus centrifuge SOP	0	Production line 1 - Oak House	CO-PRD1-SOP-255	Standard Operating Procedure		0
588	963	Velp Scientific WIZARD IR Infrared Vortex Mixer SOP	0	Production line 1 - Oak House	CO-PRD1-SOP-256	Standard Operating Procedure		0
589	964	Standard Use of Oak House Freezers	1	Production line 1 - Oak House	CO-PRD1-SOP-257	Standard Operating Procedure		0
590	965	GRN Form for incoming goods	1	Supply Chain	CO-SUP-FRM-178	Forms		0
591	966	Use of Oak House N2400-3010 Magnetic Stirrer	0	Production line 1 - Oak House	CO-PRD1-SOP-258	Standard Operating Procedure		0
592	967	Standard Use of Oak House Fridges	1	Production line 1 - Oak House	CO-PRD1-SOP-259	Standard Operating Procedure		0
593	968	Class II MSC Monthly Airflow Check Form	1	Laboratory	CO-LAB-FRM-180	Forms		0
594	969	Process Requirement Specification for CO-OPS-PTL-010	0	Operations	CO-OPS-URS-020	User Requirements Specification		0
595	970	Reagent Production Policy	0	Production line 1 - Oak House	CO-PRD1-POL-016	Policy		0
596	971	Oak House Production Facility Code of Practice	0	Production line 1 - Oak House	CO-PRD1-COP-003	Code of Practice		0
597	972	Use of Logmore dataloggers	0	Production line 1 - Oak House	CO-PRD1-SOP-260	Standard Operating Procedure		0
598	973	Oak House Production Facility Cleaning Record	1	Production line 1 - Oak House	CO-PRD1-T-160	Templates		0
599	974	Cleaning Procedure for Oak House Production Facility	3	Production line 1 - Oak House	CO-PRD1-SOP-261	Standard Operating Procedure		0
600	975	Oak House Monthly Production Facility Checklist	1	Production line 1 - Oak House	CO-PRD1-FRM-181	Forms		0
601	977	Entry and Exit to the Oak House Production Facility and Production Suite	0	Production line 1 - Oak House	CO-PRD1-SOP-263	Standard Operating Procedure		0
602	978	Air conditioning	1	Production line 1 - Oak House	CO-PRD1-JA-008	Job Aid		0
603	980	Eupry temperature monitoring system	1	Production line 1 - Oak House	CO-PRD1-SOP-264	Standard Operating Procedure		0
604	981	Oak House Emergency Procedures	0	Production line 1 - Oak House	CO-PRD1-SOP-265	Standard Operating Procedure		0
605	983	Transfer of reagent QC samples	2	Production line 1 - Oak House	CO-PRD1-SOP-268	Standard Operating Procedure		0
606	984	Storage temperature labels	0	Production line 1 - Oak House	CO-PRD1-LBL-029	Label		0
607	985	Pipette Internal Verification Form	2	Production line 1 - Oak House	CO-PRD1-FRM-182	Forms		0
608	986	Oak House Pipette Use and Calibration SOP	2	Production line 1 - Oak House	CO-PRD1-SOP-269	Standard Operating Procedure		0
609	987	Certificate of conformance – CT IC detection reagent	1	Production line 1 - Oak House	CO-PRD1-FRM-183	Forms		0
610	988	Certificate of conformance - CT IC primer passivation reagent	1	Production line 1 - Oak House	CO-PRD1-FRM-184	Forms		0
611	989	Certificate of Conformance - IC DNA reagent	1	Production line 1 - Oak House	CO-PRD1-FRM-185	Forms		0
612	990	Certificate of Conformance - NG1 IC detection reagent	1	Production line 1 - Oak House	CO-PRD1-FRM-186	Forms		0
613	991	Certificate of Conformance - NG2 IC detection reagent	1	Production line 1 - Oak House	CO-PRD1-FRM-187	Forms		0
614	992	Certificate of Conformance - NG1 NG2 IC primer passivation reagent	1	Production line 1 - Oak House	CO-PRD1-FRM-188	Forms		0
615	993	Certificate of Conformance - Taq UNG	1	Production line 1 - Oak House	CO-PRD1-FRM-189	Forms		0
616	995	Shipment note	0	Production line 1 - Oak House	CO-PRD1-FRM-190	Forms		0
617	996	Use of the Pacplus Impulse Heat Sealer	0	Production line 1 - Oak House	CO-PRD1-SOP-271	Standard Operating Procedure		0
618	999	Reagent Shipping Worksheet	2	Production line 1 - Oak House	CO-PRD1-FRM-191	Forms		0
623	1004	At-Home Vaginal Swab Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-005	Instructions For Use		0
624	1005	At-Home Vaginal Swab Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-006	Instructions For Use		0
626	1007	At-Home Vaginal Swab Collection Kit IFU  Spanish Digital Print	4	Digital Product Technology	CO-DPT-IFU-008	Instructions For Use		0
627	1008	At-Home Female Triple Site Collection Kit IFU  English Print Version	5	Digital Product Technology	CO-DPT-IFU-009	Instructions For Use		0
628	1009	At-Home Female Triple Site Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-010	Instructions For Use		0
629	1010	At-Home Female Triple Site Collection Kit IFU  English Digital Version	5	Digital Product Technology	CO-DPT-IFU-011	Instructions For Use		0
630	1011	At-Home Female Triple Site Collection Kit IFU  Spanish Digital Version	5	Digital Product Technology	CO-DPT-IFU-012	Instructions For Use		0
631	1012	123 At-Home Card  English Version	2	Digital Product Technology	CO-DPT-IFU-013	Instructions For Use		0
632	1013	At-Home Male Triple Site Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-014	Instructions For Use		0
619	1000	At-Home Blood Spot Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-001	Instructions For Use		1
625	1006	At-Home Vaginal Swab Collection Kit IFU  English Digital Version	4	Digital Product Technology	CO-DPT-IFU-007	Instructions For Use		1
621	1002	At-Home Blood Spot Collection Kit IFU  English Digital Version	4	Digital Product Technology	CO-DPT-IFU-003	Instructions For Use		1
633	1014	At-Home Male Triple Site Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-015	Instructions For Use		0
634	1015	At-Home Male Triple Site Collection Kit IFU  English Digital Version	4	Digital Product Technology	CO-DPT-IFU-016	Instructions For Use		0
635	1016	At-Home Male Triple Site Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	CO-DPT-IFU-017	Instructions For Use		0
636	1017	At-Home Urine Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-018	Instructions For Use		0
637	1018	At-Home Urine Collection Kit IFU  Spanish Print Version	4	Digital Product Technology	CO-DPT-IFU-019	Instructions For Use		0
638	1019	At-Home Urine Collection Kit IFU  English Digital Version	4	Digital Product Technology	CO-DPT-IFU-020	Instructions For Use		0
639	1020	At-Home Urine Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	CO-DPT-IFU-021	Instructions For Use		0
640	1021	Blood Card Collection Kit IFU  Using ADx Card Fasting  English Print Version	2	Digital Product Technology	CO-DPT-IFU-022	Instructions For Use		0
641	1022	Blood Card Collection Kit IFU  Using the ADx Card Fasting  English Digital Version	2	Digital Product Technology	CO-DPT-IFU-023	Instructions For Use		0
642	1023	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting  English Print Version	2	Digital Product Technology	CO-DPT-IFU-024	Instructions For Use		0
643	1024	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting   English Digital Version	2	Digital Product Technology	CO-DPT-IFU-025	Instructions For Use		0
644	1025	It s as Easy as 123 Ft. the ADx Card Collection Method   English Version	2	Digital Product Technology	CO-DPT-IFU-026	Instructions For Use		0
645	1026	STI Sample Tube/Swab Preparation Card  English Version	2	Digital Product Technology	CO-DPT-IFU-027	Instructions For Use		0
646	1027	binx Nasal Swab For Individual Setting  English Print Version	10	Digital Product Technology	CO-DPT-IFU-028	Instructions For Use		0
647	1028	binx Nasal Swab For Group Setting  English Print Version	7	Digital Product Technology	CO-DPT-IFU-029	Instructions For Use		0
648	1029	binx At-Home Collection Kit Individual_Broad  English Version	4	Digital Product Technology	CO-DPT-IFU-031	Instructions For Use		0
649	1030	binx At-Home Collection Kit IFU Group_Broad  English Version	4	Digital Product Technology	CO-DPT-IFU-032	Instructions For Use		0
650	1031	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping  English Version	5	Digital Product Technology	CO-DPT-IFU-033	Instructions For Use		0
651	1032	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location  English Version	5	Digital Product Technology	CO-DPT-IFU-035	Instructions For Use		0
652	1033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad  English Version	4	Digital Product Technology	CO-DPT-IFU-036	Instructions For Use		0
653	1034	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad  English Version	4	Digital Product Technology	CO-DPT-IFU-037	Instructions For Use		0
654	1035	Outer bag label Nasal PCR Bag Bulk Kit	0	Digital Product Technology	CO-DPT-ART-001	Artwork		0
655	1037	Return STI Kit Sample Collection Video Transcript	0	Digital Product Technology	CO-DPT-VID-001	Instructional Videos		0
656	1039	Oral Swab Sample Collection Video Transcript	0	Digital Product Technology	CO-DPT-VID-003	Instructional Videos		0
657	1040	Dry Blood Spot Card Video Transcript	0	Digital Product Technology	CO-DPT-VID-004	Instructional Videos		0
658	1041	Urine Sample Collection Video Transcript	0	Digital Product Technology	CO-DPT-VID-005	Instructional Videos		0
659	1042	Vaginal Swab Sample Collection Video Transcript	0	Digital Product Technology	CO-DPT-VID-006	Instructional Videos		0
660	1043	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit IFU  English Version	2	Digital Product Technology	CO-DPT-IFU-038	Instructions For Use		0
661	1044	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit for Group Settings  English Version	2	Digital Product Technology	CO-DPT-IFU-039	Instructions For Use		0
662	1045	TV Synthetic Target  P/N 0418	0	Laboratory	CO-LAB-FRM-192	Forms		0
663	1046	Anal Swab Sample Collection Video Transcript	0	Digital Product Technology	CO-DPT-VID-007	Instructional Videos		0
664	1047	At-Home Blood Spot Collection Kit USPS IFU  English Print Version	2	Digital Product Technology	CO-DPT-IFU-040	Instructions For Use		0
665	1048	At-Home Blood Spot Collection Kit USPS IFU  Spanish Print Version	0	Digital Product Technology	CO-DPT-IFU-041	Instructions For Use		0
666	1049	At-Home Blood Spot Collection Kit USPS IFU  English Digital Version	0	Digital Product Technology	CO-DPT-IFU-042	Instructions For Use		0
667	1050	At-Home Blood Spot Collection Kit USPS IFU  Spanish Digital Version	0	Digital Product Technology	CO-DPT-IFU-043	Instructions For Use		0
668	1052	Certificate of Conformance template	1	Production line 1 - Oak House	CO-PRD1-T-163	Templates		0
669	1053	Instructional Video Template	0	Quality Assurance	CO-QA-T-164	Templates		0
670	1055	Temperature only label	0	Production line 1 - Oak House	CO-PRD1-LBL-030	Label		0
671	1056	COVID Consent	0	Digital Product Technology	CO-DPT-WEB-001	Website Content		0
672	1059	Privacy Policy	0	Digital Product Technology	CO-DPT-WEB-003	Website Content		0
673	1060	Terms of Service	0	Digital Product Technology	CO-DPT-WEB-004	Website Content		0
674	1061	Non-COVID Consent	0	Digital Product Technology	CO-DPT-WEB-005	Website Content		0
675	1062	Manufacturing Batch Record  MBR  Template	1	Production line 1 - Oak House	CO-PRD1-T-165	Templates		0
676	1063	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU for return at a drop-off location  English Print Version	0	Digital Product Technology	CO-DPT-IFU-044	Instructions For Use		0
677	1064	Auditor Qualification	0	Quality Assurance	CO-QA-FRM-193	Forms		0
678	1065	Auditor Competency Assessment	0	Quality Assurance	CO-QA-FRM-194	Forms		0
679	1066	MOBY Detection Reagent Spreadsheet Validation Protocol	0	Quality Control	CO-QC-PTL-060	Protocol		0
680	1067	Intruder Alarm	0	Production line 1 - Oak House	CO-PRD1-JA-009	Job Aid		0
681	1068	Purchase Order Request	0	Supply Chain	CO-SUP-FRM-195	Forms		0
682	1069	Device Specific List of Applicable Standards Form Template	0	Quality Assurance	CO-QA-T-166	Templates		0
683	1070	Applicable Standards Management Procedure	0	Quality Assurance	CO-QA-SOP-274	Standard Operating Procedure		0
684	1071	Master List of Applicable Standards Form Template	0	Quality Assurance	CO-QA-REG-032	Registers		0
685	1072	T7 Raw Material Spreadsheet Validation	0	Quality Control	CO-QC-PTL-061	Protocol		0
686	1073	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test  Part no. 0225	0	Quality Control	CO-QC-PTL-062	Protocol		0
687	1075	Auditor register	0	Quality Assurance	CO-QA-REG-033	Registers		0
688	1076	QC testing and release of UNG raw material	2	Quality Control	CO-QC-PTL-064	Protocol		0
689	1077	Taq-B raw material and CT/NG Taq UNG Reagent Validation	2	Quality Control	CO-QC-PTL-065	Protocol		0
690	1078	CTNG CT/IC Primer passivation	2	Quality Control	CO-QC-PTL-066	Protocol		0
691	1079	CTNG NG/IC Primer passivation Validation	2	Quality Control	CO-QC-PTL-067	Protocol		0
692	1080	CTNG Detection Reagent Validation	3	Quality Control	CO-QC-PTL-068	Protocol		0
693	1081	Installation and Training - binx io	0	Customer Support	CO-CS-SOP-275	Standard Operating Procedure		0
694	1082	Testing and Release of Raw Materials & Formulated Reagents	8	Quality Control	CO-QC-PTL-069	Protocol		0
695	1083	Manufacture of CTNG Cartridge Reagents	1	Quality Control	CO-QC-PTL-070	Protocol		0
696	1084	Manufacture of Cartridge Reagents	1	Quality Control	CO-QC-PTL-071	Protocol		0
697	1085	dPCR Performance Qualification	2	Quality Control	CO-QC-PTL-072	Protocol		0
698	1086	QC Release of CT/NG Cartridge	1	Quality Control	CO-QC-PTL-073	Protocol		0
699	1087	CT/NG Cartridge QC Test Analysis Template Validation Protocol	1	Quality Control	CO-QC-PTL-074	Protocol		0
700	1088	COVID Consent  Spanish	0	Digital Product Technology	CO-DPT-WEB-006	Website Content		0
701	1089	Privacy Policy  UTI Spanish	0	Digital Product Technology	CO-DPT-WEB-007	Website Content		0
702	1090	Non-COVID Consent  Spanish	0	Digital Product Technology	CO-DPT-WEB-008	Website Content		0
703	1091	South Dakota Waiver Consent and Release of Information  Spanish	0	Digital Product Technology	CO-DPT-WEB-009	Website Content		0
704	1092	Terms of Service  Spanish	0	Digital Product Technology	CO-DPT-WEB-010	Website Content		0
705	1093	Inner lid activation label  STI/ODX	0	Digital Product Technology	CO-DPT-ART-002	Artwork		0
706	1094	Self-Collection Validation Summary	0	Digital Product Technology	CO-DPT-JA-010	Job Aid		0
707	1095	US Trade Credit Application	0	Finance	CO-FIN-T-167	Templates		0
708	1096	Label printing	0	Production line 1 - Oak House	CO-PRD1-SOP-276	Standard Operating Procedure		0
709	1097	Oak House Environmental Control System Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-075	Protocol		0
710	1098	UTI Screening Box	0	Digital Product Technology	CO-DPT-FEA-002	Digital Feature		0
711	1099	Digital Feature Template	0	Digital Product Technology	CO-DPT-T-168	Templates		0
712	1100	Instructions for Receipt of incoming Stock goods assigning GRN No.s & Labelling	3	Supply Chain	CO-SUP-SOP-277	Standard Operating Procedure		0
713	1101	Pilot Line Electronic Stock Control	8	Supply Chain	CO-SUP-SOP-278	Standard Operating Procedure		0
714	1102	Stock take procedure	4	Supply Chain	CO-SUP-SOP-279	Standard Operating Procedure		0
715	1103	Setting Expiry Dates for Incoming Materials	8	Supply Chain	CO-SUP-SOP-280	Standard Operating Procedure		0
716	1104	Cartridge Component Stock Control Procedure	7	Supply Chain	CO-SUP-SOP-281	Standard Operating Procedure		0
717	1105	Policy for Commercial Operations	3	Supply Chain	CO-SUP-POL-017	Policy		0
718	1106	QC Sample Handling and Retention Procedure	1	Quality Control	CO-QC-SOP-282	Standard Operating Procedure		0
719	1107	Quality Control Policy	5	Quality Control	CO-QC-POL-018	Policy		0
720	1108	Product Risk Management Procedure	4	Quality Assurance	CO-QA-SOP-283	Standard Operating Procedure		0
721	1109	FMEA Procedure	7	Quality Assurance	CO-QA-SOP-284	Standard Operating Procedure		0
722	1110	Hazard Analysis Procedure	7	Quality Assurance	CO-QA-SOP-285	Standard Operating Procedure		0
723	1111	Quality Policy	6	Quality Assurance	CO-QA-POL-019	Policy		0
724	1112	Risk Management Policy	9	Quality Assurance	CO-QA-POL-020	Policy		0
725	1113	Quality Manual	10	Quality Assurance	CO-QA-POL-021	Policy		0
726	1114	QC Sample Retention Register	2	Quality Control	CO-QC-REG-034	Registers		0
727	1115	QC Retention Box Label	0	Quality Control	CO-QC-LBL-031	Label		0
728	1116	Excess Raw Material Label	0	Quality Control	CO-QC-LBL-032	Label		0
729	1117	Use of CO-QC-T-118: Detection Reagent Analysis Spreadsheet	1	Quality Control	CO-QC-JA-011	Job Aid		0
730	1118	Job Aid: A Guide to QC Cartridge Inspections	0	Quality Control	CO-QC-JA-012	Job Aid		0
731	1119	Procedure for the Release of io Instruments	3	Quality Control	CO-QC-SOP-286	Standard Operating Procedure		0
732	1120	Introduction of New microorganisms SOP	1	Laboratory	CO-LAB-SOP-287	Standard Operating Procedure		0
733	1121	Assessment of Potentiostat Performance	4	Laboratory	CO-LAB-SOP-288	Standard Operating Procedure		0
734	1122	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test  Part 0248	7	Quality Control	CO-QC-QCP-052	Quality Control Protocol		0
735	1123	Standard Procedures for use in the Development of the CT/NG Assay	2	Laboratory	CO-LAB-SOP-289	Standard Operating Procedure		0
736	1124	SOP for running clinical samples in io® instruments	4	Laboratory	CO-LAB-SOP-290	Standard Operating Procedure		0
737	1125	Preparation of 10X and 1X TAE Buffer	4	Laboratory	CO-LAB-SOP-291	Standard Operating Procedure		0
738	1126	Preparation of Tryptone Soya Broth  TSB  and Tryptone Soya Agar  TSA	4	Laboratory	CO-LAB-SOP-292	Standard Operating Procedure		0
739	1127	dPCR Quantification of CT and NG Vircell Inputs	2	Quality Control	CO-QC-SOP-293	Standard Operating Procedure		0
740	1128	Standard Way of Making CT Dilutions	4	Laboratory	CO-LAB-SOP-294	Standard Operating Procedure		0
741	1129	Environmental Contamination testing	6	Laboratory	CO-LAB-SOP-295	Standard Operating Procedure		0
742	1133	io Reader interface - barcode scan rate	3	Quality Control	CO-QC-SOP-299	Standard Operating Procedure		0
743	1134	Preparation of Sub-circuit cards for voltammetric detection	5	Laboratory	CO-LAB-SOP-300	Standard Operating Procedure		0
744	1135	Preparation Microbiological Broth & Agar	4	Laboratory	CO-LAB-SOP-301	Standard Operating Procedure		0
745	1136	Preparation and use of agarose gels	5	Laboratory	CO-LAB-SOP-302	Standard Operating Procedure		0
746	1137	NG2 Plasmid Quantification - qPCR Test  Part No. 0347	1	Quality Control	CO-QC-QCP-053	Quality Control Protocol		0
747	1138	NG1 Plasmid Quantification - qPCR Test  Part No. 0346	1	Quality Control	CO-QC-QCP-054	Quality Control Protocol		0
748	1139	CT Plasmid Quantification - qPCR Test  Part No. 0348	1	Quality Control	CO-QC-QCP-055	Quality Control Protocol		0
749	1140	Release procedure for CT/NG cartridge	27	Quality Control	CO-QC-QCP-056	Quality Control Protocol		0
750	1141	CTNG CTIC NG1IC and NG2IC Detection Reagents QC test	6	Quality Control	CO-QC-QCP-057	Quality Control Protocol		0
751	1142	Material Electrochemical Signal Interference - Electrochemical detection assessment	1	Quality Control	CO-QC-QCP-058	Quality Control Protocol		0
752	1143	CT/NG Collection Kit Batch Release	2	Quality Control	CO-QC-QCP-059	Quality Control Protocol		0
753	1144	CT/NG Relabelled Cartridge Batch Release Procedure	2	Quality Control	CO-QC-QCP-060	Quality Control Protocol		0
754	1145	Electrode Electrochemical Functionality QC Assessment	7	Quality Control	CO-QC-QCP-061	Quality Control Protocol		0
755	1146	QC release procedure for the Io Reader	8	Quality Control	CO-QC-QCP-062	Quality Control Protocol		0
756	1147	CT/NG: NG2/IC detection reagent Heated io detection rig	11	Quality Control	CO-QC-QCP-063	Quality Control Protocol		0
757	1148	CT/NG: NG1/IC Detection Reagent	11	Quality Control	CO-QC-QCP-064	Quality Control Protocol		0
758	1149	CT/NG: CT/IC Detection Reagent Heated io detection rig	11	Quality Control	CO-QC-QCP-065	Quality Control Protocol		0
759	1150	CT/NG: NG1/NG2/IC Primer-Passivation Reagent qPCR test	7	Quality Control	CO-QC-QCP-066	Quality Control Protocol		0
760	1151	CT/NG: CT/IC Primer-Passivation Reagent	9	Quality Control	CO-QC-QCP-067	Quality Control Protocol		0
761	1152	CT/NG Taq-UNG reagent qPCR test  MOB-D-0277	11	Quality Control	CO-QC-QCP-068	Quality Control Protocol		0
762	1153	CT/NG: IC DNA Reagent qPCR Test	10	Quality Control	CO-QC-QCP-069	Quality Control Protocol		0
763	1154	UNG 50 U/uL Part no. 0240	7	Quality Control	CO-QC-QCP-070	Quality Control Protocol		0
764	1155	Enzymatics Taq-B 25U/ul  Part 0270	8	Quality Control	CO-QC-QCP-071	Quality Control Protocol		0
765	1156	Oak House Out of Hours Procedures	0	Production line 1 - Oak House	CO-PRD1-SOP-303	Standard Operating Procedure		0
766	1157	QT9 Feedback Module Job Aid	2	Quality Assurance	CO-QA-JA-013	Job Aid		0
767	1158	QT9 Corrective Action Module Job Aid	0	Quality Assurance	CO-QA-JA-014	Job Aid		0
768	1159	QT9 Nonconforming Product Job Aid	2	Quality Assurance	CO-QA-JA-015	Job Aid		0
769	1160	QT9 Preventive Action Module Job Aid	0	Quality Assurance	CO-QA-JA-016	Job Aid		0
770	1161	User Requirement Specification for the binx Cartridge Reagent Manufacturing Lab UK	1	Production line 1 - Oak House	CO-PRD1-URS-021	User Requirements Specification		0
771	1162	Management of Critical and Controlled Equipment at Oak House Production Facility	0	Production line 1 - Oak House	CO-PRD1-SOP-304	Standard Operating Procedure		0
772	1164	Use of ME2002T/00 and ML104T/00 balances in the Oak House Production Facility	1	Production line 1 - Oak House	CO-PRD1-SOP-305	Standard Operating Procedure		0
773	1167	Manufacture of NG1/IC Detection Reagent	5	Production line 1 - Oak House	CO-PRD1-FRM-197	Forms		0
774	1168	Manufacture of NG2/IC Detection Reagent	5	Production line 1 - Oak House	CO-PRD1-FRM-198	Forms		0
775	1169	Manufacture of CT/IC Detection Reagent	6	Production line 1 - Oak House	CO-PRD1-FRM-199	Forms		0
776	1170	Manufacture of CT/IC Primer Passivation Reagent	3	Production line 1 - Oak House	CO-PRD1-FRM-200	Forms		0
777	1171	Manufacture of NG1/NG2/IC Primer Passivation Reagent	3	Production line 1 - Oak House	CO-PRD1-FRM-201	Forms		0
778	1172	Manufacture of CT/NG Taq/UNG Reagent	4	Production line 1 - Oak House	CO-PRD1-FRM-202	Forms		0
779	1173	Manufacture of IC DNA Reagent	4	Production line 1 - Oak House	CO-PRD1-FRM-203	Forms		0
780	1174	ME2002T/00 and ML104T/00 Balance Weight Verification Form	1	Production line 1 - Oak House	CO-PRD1-FRM-212	Forms		0
781	1175	QT9 Internal Audit Module Job Aid	1	Quality Assurance	CO-QA-JA-018	Job Aid		0
782	1176	Manufacturing Overview for the binx Cartridge Reagent Manufacturing Facility	1	Production line 1 - Oak House	CO-PRD1-SOP-306	Standard Operating Procedure		0
783	1178	A Guide for QC Document Filing	0	Quality Control	CO-QC-JA-019	Job Aid		0
784	1179	Use of IKA Digital Roller Mixer	0	Production line 1 - Oak House	CO-PRD1-SOP-308	Standard Operating Procedure		0
785	1180	Access Control Policy	0	Information Technology	CO-IT-POL-022	Policy		0
786	1181	Asset Management Policy	0	Information Technology	CO-IT-POL-023	Policy		0
787	1182	Business Continuity and Disaster Recovery	0	Information Technology	CO-IT-POL-024	Policy		0
788	1183	Code of Conduct	0	Information Technology	CO-IT-POL-025	Policy		0
789	1184	Cryptography Policy	0	Information Technology	CO-IT-POL-026	Policy		0
790	1185	Human Resource Security Policy	0	Information Technology	CO-IT-POL-027	Policy		0
791	1186	Information Security Policy	0	Information Technology	CO-IT-POL-028	Policy		0
792	1187	Information Security Roles and Responsibilities	0	Information Technology	CO-IT-POL-029	Policy		0
793	1188	Physical Security Policy	0	Information Technology	CO-IT-POL-030	Policy		0
794	1189	Responsible Disclosure Policy	0	Information Technology	CO-IT-POL-031	Policy		0
795	1190	Risk Management	0	Information Technology	CO-IT-POL-032	Policy		0
796	1191	Third Party Management	0	Information Technology	CO-IT-POL-033	Policy		0
797	1193	Process Validation of CO-QC-QCP-069 and CO-QC-QCP-052. IC DNA Reagent and Raw Material Testing	0	Quality Control	CO-QC-PTL-077	Protocol		0
798	1194	Use of the Uninterruptible Power Supply	0	Production line 1 - Oak House	CO-PRD1-SOP-309	Standard Operating Procedure		0
799	1195	Cartridge Defects Library	0	Operations	CO-OPS-JA-020	Job Aid		0
800	1196	Oak House Equipment Service and Calibration Register	1	Production line 1 - Oak House	CO-PRD1-REG-035	Registers		0
801	1197	Oak House Pipette Register	0	Production line 1 - Oak House	CO-PRD1-REG-036	Registers		0
802	1198	Oak House Jenway 3510 pH Meter Asset 1143 Validation Protocol	1	Production line 1 - Oak House	CO-PRD1-PTL-078	Protocol		0
803	1199	Intermediate reagent labels	0	Production line 1 - Oak House	CO-PRD1-LBL-033	Label		0
804	1208	The use of Calibrated Clocks/Timers	0	Production line 1 - Oak House	CO-PRD1-SOP-310	Standard Operating Procedure		0
805	1209	Calibrated Clock/Timer verification form	0	Production line 1 - Oak House	CO-PRD1-FRM-204	Forms		0
806	1210	pH Meter Calibration form - 3 point	2	Production line 1 - Oak House	CO-PRD1-FRM-211	Forms		0
807	1211	Use of the Rotary Vane Anemometer in Oak House	0	Production line 1 - Oak House	CO-PRD1-SOP-311	Standard Operating Procedure		0
808	1212	Eupry Temperature Monitoring System Validation	0	Production line 1 - Oak House	CO-PRD1-PTL-086	Protocol		0
809	1213	Guidance for the completion of Reagent Production Manufacturing Batch Records  MBRs	0	Production line 1 - Oak House	CO-PRD1-SOP-312	Standard Operating Procedure		0
810	1214	Use of Membrane Filters in the binx Reagent Manufacturing Facility	1	Production line 1 - Oak House	CO-PRD1-SOP-313	Standard Operating Procedure		0
811	1215	URS for a Hydridisation Oven  Benchmark Roto-Therm Plus H2024-E	0	Production line 1 - Oak House	CO-PRD1-URS-022	User Requirements Specification		0
812	1221	Equipment Maintenance and Calibration Form	0	Production line 1 - Oak House	CO-PRD1-FRM-205	Forms		0
813	1222	The use of the calibrated temperature probe	0	Production line 1 - Oak House	CO-PRD1-SOP-318	Standard Operating Procedure		0
814	1223	Jenway 3510 model pH Meter with ATC probe and 924 30 6.0mm model Tris electrode SOP in Oak House	2	Production line 1 - Oak House	CO-PRD1-SOP-319	Standard Operating Procedure		0
815	1224	QT9 SCAR Module Job Aid	0	Quality Assurance	CO-QA-JA-021	Job Aid		0
816	1225	Water/Eultion Buffer  aliquot form	0	Laboratory	CO-LAB-FRM-206	Forms		0
817	1226	Manipulated Material Aliquot form	0	Laboratory	CO-LAB-FRM-207	Forms		0
818	1227	Oak House Supply Chain Reagent Production Process Flow	4	Supply Chain	CO-SUP-SOP-320	Standard Operating Procedure		0
819	1228	STI Barcodes - 8 count label	0	Digital Product Technology	CO-DPT-ART-003	Artwork		0
820	1229	ADX Blood Card Barcode QR Labels	0	Digital Product Technology	CO-DPT-ART-004	Artwork		0
821	1230	COVID Pre-Printed PCR Label	1	Digital Product Technology	CO-DPT-ART-005	Artwork		0
822	1231	COVID Pre-Printed PCR Label - 1D Barcode	0	Digital Product Technology	CO-DPT-ART-006	Artwork		0
823	1232	COVID Broad Kit QRX Barcode 2 Part Label	0	Digital Product Technology	CO-DPT-ART-007	Artwork		0
824	1233	Incoming Goods Procedure for deliveries into Oak House Manufacturing Site	2	Supply Chain	CO-SUP-SOP-321	Standard Operating Procedure		0
825	1235	Oak House Mettler Toledo ME2002T_00 Precision Balance Asset 1170 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-087	Protocol		0
826	1236	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1171 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-088	Protocol		0
827	1237	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1172 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-089	Protocol		0
828	1238	Vaginal STI Sample Collection Sticker	0	Digital Product Technology	CO-DPT-ART-008	Artwork		0
829	1239	Oral STI Sample Collection Sticker	0	Digital Product Technology	CO-DPT-ART-009	Artwork		0
830	1240	Anal STI Sample Collection Sticker	0	Digital Product Technology	CO-DPT-ART-010	Artwork		0
831	1241	Urine STI Sample Collection Sticker	0	Digital Product Technology	CO-DPT-ART-011	Artwork		0
832	1243	Oak House Cycle Counting stock sheet	0	Supply Chain	CO-SUP-FRM-209	Forms		0
833	1244	Supply Team Oak House Operations	1	Supply Chain	CO-SUP-SOP-322	Standard Operating Procedure		0
834	1245	Demand Planning	0	Supply Chain	CO-SUP-SOP-323	Standard Operating Procedure		0
835	1246	Packaging and Shipping Procedure for binx Cartridge Reagent	2	Supply Chain	CO-SUP-SOP-324	Standard Operating Procedure		0
836	1248	Oak House Re-Order form for Supply Chain	0	Supply Chain	CO-SUP-FRM-210	Forms		0
837	1249	CT IC Detection Reagent Vial Label	2	Production line 1 - Oak House	CO-PRD1-LBL-034	Label		0
838	1250	CT IC Primer Passivation Reagent Vial Label	1	Production line 1 - Oak House	CO-PRD1-LBL-035	Label		0
839	1251	NG1 IC Detection Reagent Vial Label	1	Production line 1 - Oak House	CO-PRD1-LBL-036	Label		0
840	1252	NG2 IC Detection Reagent Vial Label	1	Production line 1 - Oak House	CO-PRD1-LBL-037	Label		0
841	1253	NG1 NG2 IC Primer Passivation Reagent Vial Label	1	Production line 1 - Oak House	CO-PRD1-LBL-038	Label		0
842	1254	CT NG Taq UNG Reagent Vial Label	1	Production line 1 - Oak House	CO-PRD1-LBL-039	Label		0
843	1255	IC DNA Reagent Vial Label	1	Production line 1 - Oak House	CO-PRD1-LBL-040	Label		0
844	1256	CT IC Detection Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-041	Label		0
845	1257	CT IC Primer Passivation Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-042	Label		0
846	1258	NG1 IC Detection Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-043	Label		0
847	1259	NG2 IC Detection Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-044	Label		0
848	1260	NG1 NG2 IC Primer Passivation Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-045	Label		0
849	1261	CT NG Taq UNG Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-046	Label		0
850	1262	IC DNA Reagent Box Label	2	Production line 1 - Oak House	CO-PRD1-LBL-047	Label		0
851	1263	Dry Ice Job aid  Oak House	0	Supply Chain	CO-SUP-JA-023	Job Aid		0
852	1266	URS for temp-controlled equipment for Oak House: Refrigerator Models: RLDF0519 and RLDF1519  freestanding and under bench   -20°C Freezer Models: RLV	0	Production line 1 - Oak House	CO-PRD1-URS-025	User Requirements Specification		0
853	1267	User Requirement Specification for a Wireless Temperature and Humidity Monitoring System for Oak House Production and Storage Facility	0	Production line 1 - Oak House	CO-PRD1-URS-026	User Requirements Specification		0
971	1437	2.600.008  CG Male  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-008	Bill of Materials		0
854	1274	Oak House Commercial Invoice - Cartridge Reagent  -20°c	1	Supply Chain	CO-SUP-T-171	Templates		0
855	1275	Oak House Packing List - Cartridge Reagent  2-8°c	1	Supply Chain	CO-SUP-T-172	Templates		0
856	1276	Oak House Lab Replenishment Form	0	Supply Chain	CO-SUP-FRM-213	Forms		0
857	1278	Oak House Haier DW-86L338J Freezer 1155 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-090	Protocol		0
858	1279	Oak House Labcold RLDF1519 Fridge 1157 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-091	Protocol		0
859	1280	Oak House Labcold RLDF1519 Fridge 1159 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-092	Protocol		0
860	1281	Oak House Labcold RLDF0519 Fridge 1161 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-093	Protocol		0
861	1289	Oak House Labcold RLVF1517 Freezer 1158 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-094	Protocol		0
862	1290	Oak House Labcold RLVF0417 Freezer 1162 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-095	Protocol		0
863	1291	Oak House Labcold RLVF1517 Freezer 1183 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-096	Protocol		0
864	1292	Oak House Labcold RLDF1519 Fridge 1207 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-097	Protocol		0
865	1293	Oak House Labcold RLVF1517 Freezer 1208 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-098	Protocol		0
866	1302	User Requirements Specification for a Monmouth Scientific Model Guardian 1800 production enclosure	0	Production line 1 - Oak House	CO-PRD1-URS-027	User Requirements Specification		0
867	1304	Reagent component pick list form	4	Supply Chain	CO-SUP-T-178	Templates		0
868	1305	CT IC Detection Reagent Component pick list form	4	Supply Chain	CO-SUP-FRM-214	Forms		0
869	1306	CT IC Primer Passivation Reagent Component Pick List Form	2	Supply Chain	CO-SUP-FRM-215	Forms		0
870	1307	NG1 IC Detection Reagent Component Pick List Form	2	Supply Chain	CO-SUP-FRM-216	Forms		0
871	1308	NG2 IC Detection Reagent Component Pick List Form	2	Supply Chain	CO-SUP-FRM-217	Forms		0
872	1309	NG1 NG2 IC Primer Passivation Reagent Component Pick List Form	2	Supply Chain	CO-SUP-FRM-218	Forms		0
873	1310	CT NG Taq UNG Reagent Component Pick List Form	2	Supply Chain	CO-SUP-FRM-219	Forms		0
874	1311	IC DNA Reagent Component Pick List Form	2	Supply Chain	CO-SUP-FRM-220	Forms		0
875	1312	Consumption on Cost Center	0	Supply Chain	CO-SUP-JA-024	Job Aid		0
876	1313	Creating stock and non-stock purchase orders from purchase request	0	Supply Chain	CO-SUP-JA-025	Job Aid		0
877	1314	Production Requests to Production Orders	0	Supply Chain	CO-SUP-JA-026	Job Aid		0
878	1315	Raising Inspection flag on stock material  SAP ByD	0	Supply Chain	CO-SUP-JA-027	Job Aid		0
879	1316	Running Purchasing and Production Exception Reports	0	Supply Chain	CO-SUP-JA-028	Job Aid		0
880	1317	Purchase Order Acknowledgements	0	Supply Chain	CO-SUP-JA-029	Job Aid		0
881	1318	Manual MRP Process  binx ERP system  and Releasing Purchase / Production Proposals	0	Supply Chain	CO-SUP-JA-030	Job Aid		0
882	1319	Automatic MRP run set up and edit	0	Supply Chain	CO-SUP-JA-031	Job Aid		0
883	1320	Goods Movements	0	Supply Chain	CO-SUP-JA-032	Job Aid		0
884	1322	Raise Purchase Order – Non-stock & Services	0	Supply Chain	CO-SUP-JA-034	Job Aid		0
885	1324	New Stock Adjustment	0	Supply Chain	CO-SUP-JA-036	Job Aid		0
886	1325	Expiry Date Amendment	0	Supply Chain	CO-SUP-JA-037	Job Aid		0
887	1326	Transfer Order	0	Supply Chain	CO-SUP-JA-038	Job Aid		0
888	1327	Oak House Work Order Preparation	0	Supply Chain	CO-SUP-JA-039	Job Aid		0
889	1328	Oak House Work Order Completion	0	Supply Chain	CO-SUP-JA-040	Job Aid		0
890	1329	Oak House Work Order Completion	0	Supply Chain	CO-SUP-JA-041	Job Aid		0
891	1330	Oak House MSC1800 Production Enclosure Asset 1168 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-099	Protocol		0
892	1331	BAO Sassy Little Box	0	Digital Product Technology	CO-DPT-ART-012	Artwork		0
893	1332	Oak House Roto-Therm H2024-E Hybridisation Oven Asset 1113 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-100	Protocol		0
894	1333	Template for IQC for Oak House	1	Production line 1 - Oak House	CO-PRD1-T-179	Templates		0
895	1335	Supply Team Policy for Oak House Production Suite Operations	0	Supply Chain	CO-SUP-POL-034	Policy		0
896	1337	CIR Job Aid	1	Laboratory	CO-LAB-JA-043	Job Aid		0
897	1339	Potassium Chloride Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-223	Forms		0
898	1341	Potassium phosphate dibasic Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-225	Forms		0
899	1342	Taq-B Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-226	Forms		0
900	1343	NG2 di452 probe Oak House production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-227	Forms		0
901	1344	UNG Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-228	Forms		0
902	1345	MBG Water Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-229	Forms		0
903	1346	Hybridization Oven Verification and Calibration Form	0	Production line 1 - Oak House	CO-PRD1-FRM-230	Forms		0
904	1347	0.5M EDTA Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-231	Forms		0
905	1348	Brij- 58 Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-232	Forms		0
906	1349	Glycerol Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-233	Forms		0
907	1350	Potassium phosphate monobasic Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-234	Forms		0
908	1351	Trehalose dihydrate Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-235	Forms		0
909	1352	Triton X305 Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-236	Forms		0
910	1353	Trizma base Oak House production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-237	Forms		0
911	1354	Trizma hydrochloride Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-238	Forms		0
912	1355	Magnesium chloride Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-239	Forms		0
913	1356	Ethanol Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-240	Forms		0
914	1357	T7 exonuclease Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-241	Forms		0
915	1358	dUTP mix Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-242	Forms		0
916	1359	y-Aminobutyric acid  GABA  Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-243	Forms		0
917	1360	Albumin from bovine serum  BSA  Oak House Production IQC	3	Production line 1 - Oak House	CO-PRD1-FRM-244	Forms		0
918	1361	DL-dithiothreitol  DTT  Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-245	Forms		0
919	1362	CT di452 probe Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-246	Forms		0
920	1363	IC di275 probe Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-247	Forms		0
921	1364	NG1 di452 probe Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-248	Forms		0
922	1365	CT forward primer Oak House production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-249	Forms		0
923	1366	CT reverse primer Oak House Production IQC	2	Production line 1 - Oak House	CO-PRD1-FRM-250	Forms		0
924	1367	IC  forward primer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-251	Forms		0
925	1368	IC reverse primer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-252	Forms		0
926	1369	NG1 forward primer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-253	Forms		0
927	1370	NG1 Reverse primer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-254	Forms		0
928	1371	NG2 forward primer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-255	Forms		0
929	1372	NG2 reverse primer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-256	Forms		0
930	1373	Pectobacterium atrosepticum  IC  DNA buffer Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-257	Forms		0
931	1374	Validation of Oak House CT/NG reagent process	1	Production line 1 - Oak House	CO-PRD1-PTL-101	Protocol		0
932	1375	Keyence LM Series - User Requirements Specification	0	Operations	CO-OPS-URS-028	User Requirements Specification		0
933	1376	Production suite air conditioning job aid	0	Production line 1 - Oak House	CO-PRD1-JA-044	Job Aid		0
934	1377	pH Buffer Bottle 10.01 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-258	Forms		0
935	1378	pH Buffer Bottle 7.00 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-259	Forms		0
936	1379	pH Buffer Bottle 4.01 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-260	Forms		0
937	1380	Sartorius Minisart™ NML Syringe Filters Sterile  0.45 µm  Male Luer Lock Oak House IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-261	Forms		0
938	1381	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQ	0	Production line 1 - Oak House	CO-PRD1-FRM-262	Forms		0
939	1382	Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Slip Oak House IQC	1	Production line 1 - Oak House	CO-PRD1-FRM-263	Forms		0
940	1383	ERP GRN for Oak House Label-Rev_0	0	Production line 1 - Oak House	CO-PRD1-LBL-048	Label		0
941	1384	Quarantined ERP GRN material label-Rev_0	0	Production line 1 - Oak House	CO-PRD1-LBL-049	Label		0
942	1385	SAP Code ERP GRN Label-Rev_0	0	Production line 1 - Oak House	CO-PRD1-LBL-050	Label		0
943	1390	Oak House APC Schneider UPS Asset  1116 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-102	Protocol		0
944	1391	Oak House APC Schneider UPS Asset  1117 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-103	Protocol		0
945	1392	Oak House APC Schneider UPS Asset  1118 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-104	Protocol		0
946	1393	Oak House APC Schneider UPS Asset  1176 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-105	Protocol		0
947	1394	Oak House APC Schneider UPS Asset  1177 Validation Protocol	0	Production line 1 - Oak House	CO-PRD1-PTL-106	Protocol		0
948	1398	Demand Plan - Plan and Release	0	Supply Chain	CO-SUP-JA-047	Job Aid		0
949	1402	Promotional Materials Checklist	0	Sales and Marketing	CO-SAM-JA-048	Job Aid		0
950	1403	Use of Acronyms in Marketing Materials	0	Sales and Marketing	CO-SAM-JA-049	Job Aid		0
951	1405	Job Aid _Field Service-Instrument cleaning	0	Customer Support	CO-CS-JA-050	Job Aid		0
952	1415	Oak House Commercial Invoice - Cartridge Reagent  2-8°c	1	Supply Chain	CO-SUP-T-182	Templates		0
953	1416	Oak House Packing List - Cartridge Reagent  -20°c	1	Supply Chain	CO-SUP-T-183	Templates		0
954	1417	binx Commercial Invoice  Misc. shipments	1	Supply Chain	CO-SUP-T-184	Templates		0
955	1418	binx Packing List  Misc shipments	1	Supply Chain	CO-SUP-T-185	Templates		0
956	1419	Use of Elpro data loggers	0	Supply Chain	CO-SUP-JA-055	Job Aid		0
957	1420	Use of Sensitech data loggers	0	Supply Chain	CO-SUP-JA-056	Job Aid		0
958	1421	Shipping Contents Label	0	Supply Chain	CO-SUP-LBL-051	Label		0
959	1422	URS for Female Urine Clinical Study Database	0	Laboratory	CO-LAB-URS-029	User Requirements Specification		0
960	1423	Verification Testing Protocol for Female Urine Database	0	Laboratory	CO-LAB-PTL-186	Protocol		0
961	1424	Female Urine Database	0	Laboratory	CO-LAB-REG-037	Registers		0
962	1426	Third Party Sale and Purchase Orders Process	0	Supply Chain	CO-SUP-JA-057	Job Aid		0
963	1428	Digital BOM Template	0	Digital Product Technology	CO-DPT-T-187	Templates		0
964	1430	2.600.003  CG3 Male  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-001	Bill of Materials		0
965	1431	2.600.002  CG + Blood Male  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-002	Bill of Materials		0
966	1432	2.600.004  CG + Blood + Blood Male  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-003	Bill of Materials		0
967	1433	2.600.500  Blood Unisex  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-004	Bill of Materials		0
968	1434	2.600.006  CG3 + Blood Male  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-005	Bill of Materials		0
969	1435	2.600.006-001  CG3 + Blood Male BAO  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-006	Bill of Materials		0
970	1436	2.600.007  CG3 + Blood + Blood Male  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-007	Bill of Materials		0
972	1438	2.600.902  CG + Blood Female  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-009	Bill of Materials		0
973	1439	2.600.903  CG3 Female  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-010	Bill of Materials		0
974	1440	2.600.904  CG + Blood + Blood Female  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-011	Bill of Materials		0
975	1441	2.600.905  Blood + Blood Unisex  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-012	Bill of Materials		0
976	1442	2.600.906  CG3 + Blood Female  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-013	Bill of Materials		0
977	1443	2.600.907  CG3 + Blood + Blood Female  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-014	Bill of Materials		0
978	1444	2.600.908  CG Female  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-015	Bill of Materials		0
979	1445	2.600.909  HIV USPS Blood Card  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-016	Bill of Materials		0
980	1446	2.601.002  CG + Blood Male AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-017	Bill of Materials		0
981	1447	2.601.003  CG Male AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-018	Bill of Materials		0
982	1448	2.601.005  Blood Unisex AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-019	Bill of Materials		0
983	1449	2.601.006  CG3 + Blood Male AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-020	Bill of Materials		0
984	1450	2.601.008  CG Male AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-021	Bill of Materials		0
985	1451	2.601.902  CG + Blood Female AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-022	Bill of Materials		0
986	1452	2.601.903  CG3 Female AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-023	Bill of Materials		0
987	1453	2.601.906  CG3 + Blood Female AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-024	Bill of Materials		0
988	1454	2.601.908  CG Female AG  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-025	Bill of Materials		0
989	1455	2.800.001  ADX Blood Card  1  Fasting  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-026	Bill of Materials		0
990	1456	2.800.002  ADX Blood Card  2  Fasting  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-027	Bill of Materials		0
991	1457	2.801.001  ADX Blood Card  1 Non-fasting  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-028	Bill of Materials		0
992	1458	2.801.002  ADX Blood Card  2 Non-fasting  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-029	Bill of Materials		0
993	1459	5.900.444  Blood Collection Drop-in Pack  Kit BOM	0	Digital Product Technology	CO-DPT-BOM-030	Bill of Materials		0
994	1462	Manufacturing Overview for Detection Reagents	2	Production line 1 - Oak House	CO-PRD1-SOP-355	Standard Operating Procedure		0
995	1463	EU Regulatory Strategy and Process	0	Quality Assurance	CO-QA-SOP-356	Standard Operating Procedure		0
996	1464	EU Performance Evaluation	1	Quality Assurance	CO-QA-SOP-357	Standard Operating Procedure		0
997	1466	Post Market Performance Follow-up Plan Template	0	Quality Assurance	CO-QA-T-189	Templates		0
998	1467	Post Market Performance Follow-up Report Template	0	Quality Assurance	CO-QA-T-190	Templates		0
999	1469	Post Market Surveillance Plan Template	0	Quality Assurance	CO-QA-T-192	Templates		0
1000	1470	Post Market Surveillance Report Template	0	Quality Assurance	CO-QA-T-193	Templates		0
1001	1471	Declaration of Conformity Template	0	Quality Assurance	CO-QA-T-194	Templates		0
1002	1473	Field Service Report Form	0	Customer Support	CO-CS-FRM-267	Forms		0
1003	1474	GSPR Template	0	Quality Assurance	CO-QA-T-196	Templates		0
1004	1475	Summary Technical Documentation  STED  Template	0	Quality Assurance	CO-QA-T-197	Templates		0
1005	1476	binx io Field Service Procedure	0	Customer Support	CO-CS-SOP-358	Standard Operating Procedure		0
1006	1484	Eupry Calibration Cover Sheet	0	Laboratory	CO-LAB-T-198	Templates		0
1007	1486	Oak House Manufacturing Overview SOP Template	0	Production line 1 - Oak House	CO-PRD1-T-199	Templates		0
1008	1487	Manufacturing Batch Record  MBR  Template - DEV#28	0	Production line 1 - Oak House	CO-PRD1-T-200	Templates		0
1009	1488	Shipping Specification Template	0	Supply Chain	CO-SUP-T-201	Templates		0
1010	1489	Shipping Specifications Procedure	0	Supply Chain	CO-SUP-SOP-363	Standard Operating Procedure		0
1011	1490	Shipping Specification: CT/NG io Cartridge	0	Supply Chain	CO-SUP-FRM-269	Forms		0
1012	1496	Cold Chain Shipping Policy	0	Supply Chain	CO-SUP-POL-035	Policy		0
1013	1497	Incident and Near Miss Reporting Form	4	Health and Safety	CO-H&S-T-204	Templates		0
1014	1498	Health and Safety Risk Assessment Template	1	Health and Safety	CO-H&S-T-202	Templates		0
1015	1499	Blank Form for H&S COSHH assessments	5	Health and Safety	CO-H&S-T-203	Templates		0
1016	1500	COSHH Assessment - General Chemicals	6	Health and Safety	CO-H&S-COSHH-001	COSHH Assessment		0
1017	1501	COSHH Assessment - Oxidising Agents	6	Health and Safety	CO-H&S-COSHH-002	COSHH Assessment		0
1018	1502	COSHH Assessment - Flammable Materials	6	Health and Safety	CO-H&S-COSHH-003	COSHH Assessment		0
1019	1503	COSHH Assessment - Chlorinated Solvents	6	Health and Safety	CO-H&S-COSHH-004	COSHH Assessment		0
1020	1504	COSHH Assessment - Corrosive Bases	6	Health and Safety	CO-H&S-COSHH-005	COSHH Assessment		0
1021	1505	COSH-Assessment - Corrosive Acids	6	Health and Safety	CO-H&S-COSHH-006	COSHH Assessment		0
1022	1506	COSHH assessment  - General Hazard Group 2 organisms	5	Health and Safety	CO-H&S-COSHH-007	COSHH Assessment		0
1023	1507	COSHH assessment  - Hazard Group 2 respiratory pathogens	5	Health and Safety	CO-H&S-COSHH-008	COSHH Assessment		0
1024	1508	COSHH Assessment - Hazard Group 1 Pathogens	4	Health and Safety	CO-H&S-COSHH-009	COSHH Assessment		0
1025	1509	COSHH assessment - clinical samples	6	Health and Safety	CO-H&S-COSHH-010	COSHH Assessment		0
1026	1510	COSHH Assessment - Inactivated Micro-organisms	5	Health and Safety	CO-H&S-COSHH-012	COSHH Assessment		0
1027	1511	COSHH Assessment  - Dry Ice	4	Health and Safety	CO-H&S-COSHH-013	COSHH Assessment		0
1028	1512	COSHH Assessment - Compressed Gases	1	Health and Safety	CO-H&S-COSHH-014	COSHH Assessment		0
1029	1513	Risk Assessment - binx Health Office and non-laboratory areas	5	Health and Safety	CO-H&S-RA-001	H&S Risk Assessments		0
1030	1514	Risk Assessment for use of Microorganisms	7	Health and Safety	CO-H&S-RA-002	H&S Risk Assessments		0
1031	1515	Risk Assessment - Laboratory Areas  excluding Microbiology and Pilot line	5	Health and Safety	CO-H&S-RA-003	H&S Risk Assessments		0
1032	1516	Risk Assessment - io® reader / assay development tools	5	Health and Safety	CO-H&S-RA-004	H&S Risk Assessments		0
1033	1517	Flammable & Explosive Substances Risk Assessment for  binx health Ltd  Derby Court and Unit 6	4	Health and Safety	CO-H&S-RA-005	H&S Risk Assessments		0
1034	1518	Risk Assessment - use of UV irradiation in the binx health Laboratories	5	Health and Safety	CO-H&S-RA-006	H&S Risk Assessments		0
1035	1519	Risk Assessment - Pilot line Laboratory area	5	Health and Safety	CO-H&S-RA-007	H&S Risk Assessments		0
1036	1520	Risk Assessment for binx Health Employees	4	Health and Safety	CO-H&S-RA-008	H&S Risk Assessments		0
1037	1521	Risk Assessment for use of Chemicals	3	Health and Safety	CO-H&S-RA-009	H&S Risk Assessments		0
1038	1522	Risk Assessment for work-related stress	2	Health and Safety	CO-H&S-RA-010	H&S Risk Assessments		0
1039	1523	Covid-19 Risk Assessment binx Health ltd	6	Health and Safety	CO-H&S-RA-011	H&S Risk Assessments		0
1040	1524	Health and Safety Risk Assessment for Use of a Butane Torch	1	Health and Safety	CO-H&S-RA-012	H&S Risk Assessments		0
1041	1525	Health & Safety Fire Related Procedures	9	Health and Safety	CO-H&S-PRO-001	H&S Procedures		0
1042	1526	Chemical and Biological COSHH Guidance	8	Health and Safety	CO-H&S-PRO-002	H&S Procedures		0
1043	1527	Manual Lifting Procedure	5	Health and Safety	CO-H&S-PRO-003	H&S Procedures		0
1044	1528	Accident Incident and near miss reporting procedure	4	Health and Safety	CO-H&S-PRO-004	H&S Procedures		0
1045	1529	Health and Safety Risk Assessment Procedure	1	Health and Safety	CO-H&S-PRO-005	H&S Procedures		0
1046	1530	Health and Safety Legislation Review Procedure	1	Health and Safety	CO-H&S-PRO-006	H&S Procedures		0
1047	1531	Fire evacuation procedure for Oak House	1	Health and Safety	CO-H&S-PRO-007	H&S Procedures		0
1048	1532	Health and Safety Policy	9	Health and Safety	CO-H&S-P-001	H&S Policy		0
1049	1533	PAT Policy	6	Health and Safety	CO-H&S-P-002	H&S Policy		0
1050	1534	Health and Safety Stress Management Policy	1	Health and Safety	CO-H&S-P-003	H&S Policy		0
1051	1535	Coronavirus  COVID-19  Policy on employees being vaccinated	1	Health and Safety	CO-H&S-P-004	H&S Policy		0
1052	1536	Risk Assessment - Fire - Derby Court and Unit 6	6	Health and Safety	CO-H&S-RA-013	H&S Risk Assessments		0
1053	1537	binx io RMA Number Request Form	0	Customer Support	CO-CS-FRM-275	Forms		0
1054	1538	Health and Safety Risk Assessment Oak House Facility	2	Health and Safety	CO-H&S-RA-014	H&S Risk Assessments		0
1055	1539	Health and Safety Risk Assessment Oak House Production Activities	2	Health and Safety	CO-H&S-RA-015	H&S Risk Assessments		0
1056	1540	Health and Safety Risk Assessment Incoming-Outgoing goods and Packaging	2	Health and Safety	CO-H&S-RA-016	H&S Risk Assessments		0
1057	1541	Health and Safety Oak House Fire Risk Assessment	1	Health and Safety	CO-H&S-RA-017	H&S Risk Assessments		0
1058	1542	Health and Safety Risk Assessment Oak House Covid-19	2	Health and Safety	CO-H&S-RA-018	H&S Risk Assessments		0
1059	1543	Order to Cash Process	0	Operations	CO-OPS-SOP-364	Standard Operating Procedure		0
1060	1544	High Risk Temperature Controlled Asset Sign	0	Laboratory	CO-LAB-FRM-276	Forms		0
1061	1545	Low Risk Temperature Controlled Asset Sign	0	Laboratory	CO-LAB-FRM-277	Forms		0
1062	1546	Asset Not Temperature Controlled Sign	0	Laboratory	CO-LAB-FRM-278	Forms		0
1063	1549	io Instrument Failure - For Engineering Inspection Label	0	Quality Control	CO-QC-LBL-052	Label		0
1064	1550	Manufacturing Overview for Primer/Passivation Reagents	0	Production line 1 - Oak House	CO-PRD1-SOP-365	Standard Operating Procedure		0
1065	1553	AirSea Dry Ice Shipper Packing Instructions	0	Supply Chain	CO-SUP-JA-061	Job Aid		0
1066	1554	AirSea 2-8°c Shipper Packing Instructions	0	Supply Chain	CO-SUP-JA-062	Job Aid		0
1067	1555	Softbox TempCell F39  13-48  Dry ice shipper packing instructions	0	Supply Chain	CO-SUP-JA-063	Job Aid		0
1068	1556	Softbox TempCell PRO shipper packing instructions	0	Supply Chain	CO-SUP-JA-064	Job Aid		0
1069	1557	Softbox TempCell MAX shipper packing instructions	0	Supply Chain	CO-SUP-JA-065	Job Aid		0
1070	1559	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox PRO Shipper	0	Supply Chain	CO-SUP-JA-067	Job Aid		0
1071	1560	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox MAX Shipper	0	Supply Chain	CO-SUP-JA-068	Job Aid		0
1072	1561	Customer Installation and Training Job Aid binx io	0	Customer Support	CO-CS-JA-069	Job Aid		0
1073	1562	Manufacturing Overview for IC DNA Reagent	0	Production line 1 - Oak House	CO-PRD1-SOP-369	Standard Operating Procedure		0
1074	1563	Manufacturing Overview for CT/NG Taq/UNG Reagent	0	Production line 1 - Oak House	CO-PRD1-SOP-370	Standard Operating Procedure		0
1075	1564	Protecting Light Sensitive Reagents with Tin Foil at the Oak House Manufacturing Facility	0	Production line 1 - Oak House	CO-PRD1-JA-070	Job Aid		0
1076	1565	Employee Unique Initial Register	0	Quality Assurance	CO-QA-REG-041	Registers		0
1077	1566	Field Service - Submitting Documents for QA Approval	0	Customer Support	CO-CS-JA-071	Job Aid		0
1078	1567	VAL2023-06 NetSuite Test Specification_QT9	1	Operations	CO-OPS-PTL-108	Protocol		0
1079	1568	Sterivex-GP Pressure Filter Unit IQC Form	0	Production line 1 - Oak House	CO-PRD1-FRM-279	Forms		0
1080	1569	EU Performance Evaluation Plan Template	0	Quality Assurance	CO-QA-T-206	Templates		0
1081	1570	EU Performance Evaluation Report Template	0	Quality Assurance	CO-QA-T-207	Templates		0
1082	1571	QC CT/NG 2:2 Input Manufactured Under CO-OPS-SOP-189 Validation Protocol	0	Quality Control	CO-QC-PTL-109	Protocol		0
1083	1583	SAP Stock Item Label  Green	0	Laboratory	CO-LAB-LBL-053	Label		0
1084	1584	GRN for R&D and Samples Label  Silver	0	Laboratory	CO-LAB-LBL-054	Label		0
1085	1585	Installation and Operational  Qualification Protocols for Jenway 924 030 6.0 mm Tris Buffer pH Electrode  Asset  to be used with	0	Production line 1 - Oak House	CO-PRD1-PTL-110	Protocol		0
1086	1588	IT System Change Request Form	0	Information Technology	CO-IT-FRM-005	Forms		0
1087	1594	Policy for Production Specification Transfer to Contract Manufacturers	0	Operations	CO-OPS-POL-037	Policy		0
1088	1596	Project Plan	1	Project Management Office	CO-PMO-T-209	Templates		0
1089	1598	Pipette Handling -Job Aid	0	Production line 1 - Oak House	CO-PRD1-JA-081	Job Aid		0
1	14	Design and Development Procedure	10	Design	CO-DES-SOP-029	Standard Operating Procedure		1
620	1001	At-Home Blood Spot Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-002	Instructions For Use		1
622	1003	At-Home Blood Spot Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	CO-DPT-IFU-004	Instructions For Use		1
\.


--
-- Data for Name: email_log; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.email_log (id, userid, escalation_level, email_sent_date) FROM stdin;
\.


--
-- Data for Name: escalation; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.escalation (id, escalation_level, delay_days, message) FROM stdin;
\.


--
-- Data for Name: escalation_state; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.escalation_state (id, delay_in_hours, state_name, email_text) FROM stdin;
1	1	Inform	A new version of the Document [document number] [document title] has been published. Please review and document your training in the next three (3) weeks
2	4	Warn 1	A new version of the Document [document number] [document title] has been published. Please review and document your training.
3	8	Warn 2	A new version of the Document [document number] [document title] has been published. Please review and document your training. In one (1) week, an email notification will be sent to your direct supervisor. 
4	16	Overdue	A new version of the Document [document number] [document title] has been published. This training is considered overdue. This notification has been escalated to your direct supervisor.
\.


--
-- Data for Name: job_documents; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.job_documents (id, doc_id, job_id, active) FROM stdin;
1	573	3	t
2	486	3	t
3	595	3	t
4	470	3	t
5	574	3	t
6	65	3	t
7	595	3	t
8	1078	3	t
9	573	0	t
10	486	0	t
11	595	0	t
12	470	0	t
13	574	0	t
14	65	0	t
15	595	0	t
16	1078	0	t
17	573	2	t
18	486	2	t
19	595	2	t
20	470	2	t
21	574	2	t
22	65	2	t
23	595	2	t
24	1078	2	t
25	573	1	t
26	486	1	t
27	595	1	t
28	470	1	t
29	574	1	t
30	65	1	t
31	595	1	t
32	1078	1	t
33	573	4	t
34	486	4	t
35	595	4	t
36	470	4	t
37	574	4	t
38	65	4	t
39	595	4	t
40	1078	4	t
1	573	3	t
2	486	3	t
3	595	3	t
4	470	3	t
5	574	3	t
6	65	3	t
7	595	3	t
8	1078	3	t
9	573	0	t
10	486	0	t
11	595	0	t
12	470	0	t
13	574	0	t
14	65	0	t
15	595	0	t
16	1078	0	t
17	573	2	t
18	486	2	t
19	595	2	t
20	470	2	t
21	574	2	t
22	65	2	t
23	595	2	t
24	1078	2	t
25	573	1	t
26	486	1	t
27	595	1	t
28	470	1	t
29	574	1	t
30	65	1	t
31	595	1	t
32	1078	1	t
33	573	4	t
34	486	4	t
35	595	4	t
36	470	4	t
37	574	4	t
38	65	4	t
39	595	4	t
40	1078	4	t
41	1052	5	t
42	1052	3	t
43	1000	5	t
44	1006	5	t
45	1000	3	t
46	1002	3	t
47	1006	26	t
48	1006	28	t
49	1000	5	t
50	486	4	t
51	486	3	t
52	486	2	t
53	486	1	t
54	1001	26	t
69	1005	26	t
70	1011	26	t
71	1007	26	t
72	1013	26	t
\.


--
-- Data for Name: job_titles; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.job_titles (id, team_id, name, active) FROM stdin;
1	4	Senior Project Engineer	t
2	4	Systems Engineer	t
3	4	Senior Software Engineer	t
4	4	Engineering Technician	t
0	4	Senior Director	t
5	4	Tech Lead	t
10	0	Chief Operations Officer & U.K site head 	t
13	4	test role	f
12	4	My Role	f
14	4	New Role	f
15	4	Hamster Herder	f
16	4	New Job	f
19	4	Lemon Squeezer	f
17	4	Different Role	f
20	4	Vampire Hunter	f
21	4	Pencil Sharpener	f
22	4	Teddy Stuffer	f
23	4	Doll Dresser	f
24	0	Senior Director	t
18	4	cat herder	f
26	4	Cat Herder	t
27	4	Product Owner	f
28	4	Employee - Sean Barnes	t
\.


--
-- Data for Name: orgchart; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.orgchart (id, user_id, manager_id) FROM stdin;
1	4	71
2	5	71
3	6	71
4	7	71
5	8	12
6	9	12
7	10	12
8	11	12
9	12	55
10	13	55
11	14	55
12	15	55
13	16	55
14	17	55
15	18	55
16	19	55
17	20	56
18	21	56
19	22	56
20	23	56
21	24	56
22	25	56
23	26	20
24	27	20
25	28	20
26	29	20
27	30	20
28	31	20
29	32	21
30	33	21
31	34	21
32	35	21
33	36	21
34	37	100
35	38	45
36	39	45
37	40	45
38	41	45
39	42	13
40	43	22
41	44	22
42	45	22
43	46	22
44	47	29
45	48	29
46	54	14
47	55	102
48	56	102
49	57	31
50	58	31
51	59	68
52	60	68
53	61	68
54	62	1
55	63	9
56	64	9
57	65	9
58	66	9
59	67	24
60	68	24
61	69	17
62	70	17
63	71	25
64	72	25
65	73	25
66	74	25
67	87	18
68	88	23
69	88	19
70	89	41
71	90	93
72	91	2
73	92	2
74	93	2
75	94	2
76	95	2
77	96	95
78	97	95
79	98	95
80	99	95
81	100	3
82	101	3
83	102	102
86	4	71
87	5	71
88	6	71
89	7	71
90	8	12
91	9	12
92	10	12
93	11	12
94	12	55
95	13	55
96	14	55
97	15	55
98	16	55
99	17	55
100	18	55
101	19	55
102	20	56
103	21	56
104	22	56
105	23	56
106	24	56
107	25	56
108	26	20
109	27	20
110	28	20
111	29	20
112	30	20
113	31	20
114	32	21
115	33	21
116	34	21
117	35	21
118	36	21
119	37	100
120	38	45
121	39	45
122	40	45
123	41	45
124	42	13
125	43	22
126	44	22
127	45	22
128	46	22
129	47	29
130	48	29
131	54	14
132	55	102
133	56	102
134	57	31
135	58	31
136	59	68
137	60	68
138	61	68
139	62	1
140	63	9
141	64	9
142	65	9
143	66	9
144	67	24
145	68	24
146	69	17
147	70	17
148	71	25
149	72	25
150	73	25
151	74	25
152	87	18
153	88	23
154	88	19
155	89	41
156	90	93
157	91	2
158	92	2
159	93	2
160	94	2
161	95	2
162	96	95
163	97	95
164	98	95
165	99	95
166	100	3
167	101	3
168	102	102
\.


--
-- Data for Name: relationship; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.relationship (id, manager_email, user_email) FROM stdin;
1	mike.karsonovich@mybinxhealth.com	dan.milano@mybinxhealth.com
2	mike.karsonovich@mybinxhealth.com	sarah.thomas@mybinxhealth.com
3	mike.karsonovich@mybinxhealth.com	abby.wright@mybinxhealth.com
4	rose.burt@mybinxhealth.com	paul.buxton@mybinxhealth.com
5	rose.burt@mybinxhealth.com	luke.chess@mybinxhealth.com
6	rose.burt@mybinxhealth.com	sarah.forster@mybinxhealth.com
7	rose.burt@mybinxhealth.com	jesna.kattil@mybinxhealth.com
8	stella.chistyakov@mybinxhealth.com	matt.crowley@mybinxhealth.com
9	stella.chistyakov@mybinxhealth.com	sheila.mirasolo@mybinxhealth.com
10	stella.chistyakov@mybinxhealth.com	patti.titus@mybinxhealth.com
11	stella.chistyakov@mybinxhealth.com	gaby.wirth@mybinxhealth.com
12	jack.crowley@mybinxhealth.com	stella.chistyakov@mybinxhealth.com
13	jack.crowley@mybinxhealth.com	jenna.hanson@mybinxhealth.com
14	jack.crowley@mybinxhealth.com	alex.kramer@mybinxhealth.com
15	jack.crowley@mybinxhealth.com	maggie.lefaivre@mybinxhealth.com
16	jack.crowley@mybinxhealth.com	ed.leftin@mybinxhealth.com
17	jack.crowley@mybinxhealth.com	pia.olson@mybinxhealth.com
18	jack.crowley@mybinxhealth.com	taylor.santos@mybinxhealth.com
19	jack.crowley@mybinxhealth.com	tim.stewart@mybinxhealth.com
20	anna.dixon@mybinxhealth.com	john.dowell@mybinxhealth.com
21	anna.dixon@mybinxhealth.com	henry.fatoyinbo@mybinxhealth.com
22	anna.dixon@mybinxhealth.com	laura.kemp@mybinxhealth.com
23	anna.dixon@mybinxhealth.com	tim.stewart@mybinxhealth.com
24	anna.dixon@mybinxhealth.com	tony.moran@mybinxhealth.com
25	anna.dixon@mybinxhealth.com	ben.reynolds@mybinxhealth.com
26	john.dowell@mybinxhealth.com	victoria.catarau@mybinxhealth.com
27	john.dowell@mybinxhealth.com	arman.hossainzadeh@mybinxhealth.com
28	john.dowell@mybinxhealth.com	ian.kelly@mybinxhealth.com
29	john.dowell@mybinxhealth.com	scott.kerr@mybinxhealth.com
30	john.dowell@mybinxhealth.com	liam.liu@mybinxhealth.com
31	john.dowell@mybinxhealth.com	camilo.madriz@mybinxhealth.com
32	henry.fatoyinbo@mybinxhealth.com	alan.alpert@mybinxhealth.com
33	henry.fatoyinbo@mybinxhealth.com	sean.barnes@mybinxhealth.com
34	henry.fatoyinbo@mybinxhealth.com	jawaad.bhatti@mybinxhealth.com
35	henry.fatoyinbo@mybinxhealth.com	antony.brown@mybinxhealth.com
36	henry.fatoyinbo@mybinxhealth.com	ian.moore@mybinxhealth.com
37	kalli.glanz@mybinxhealth.com	alyssa.amidei@mybinxhealth.com
38	victoria.hall@mybinxhealth.com	juliet.coulson@mybinxhealth.com
39	victoria.hall@mybinxhealth.com	anna.domanska@mybinxhealth.com
40	victoria.hall@mybinxhealth.com	evaldas.mel@mybinxhealth.com
41	victoria.hall@mybinxhealth.com	mike.storm@mybinxhealth.com
42	jenna.hanson@mybinxhealth.com	stephanie.rideout@mybinxhealth.com
43	laura.kemp@mybinxhealth.com	katherine.danaher@mybinxhealth.com
44	laura.kemp@mybinxhealth.com	matthieu.fabrega@mybinxhealth.com
45	laura.kemp@mybinxhealth.com	victoria.hall@mybinxhealth.com
46	laura.kemp@mybinxhealth.com	grace.newman@mybinxhealth.com
47	scott.kerr@mybinxhealth.com	brygida.kulesza-orlowska@mybinxhealth.com
48	scott.kerr@mybinxhealth.com	olivia.steward@mybinxhealth.com
49	suzy.korreck@mybinxhealth.com	jennifer.araujo@mybinxhealth.com
50	suzy.korreck@mybinxhealth.com	jenna.chicoine@mybinxhealth.com
51	suzy.korreck@mybinxhealth.com	shirley.freeman@mybinxhealth.com
52	suzy.korreck@mybinxhealth.com	wendy.kivens@mybinxhealth.com
53	suzy.korreck@mybinxhealth.com	paul.rolls@mybinxhealth.com
54	alex.kramer@mybinxhealth.com	buck.brady@mybinxhealth.com
55	jeff.luber@mybinxhealth.com	jack.crowley@mybinxhealth.com
56	jeff.luber@mybinxhealth.com	anna.dixon@mybinxhealth.com
57	camilo.madriz@mybinxhealth.com	tomos.morris@mybinxhealth.com
58	camilo.madriz@mybinxhealth.com	calum.rae@mybinxhealth.com
59	austin.main@mybinxhealth.com	emma.bird@mybinxhealth.com
60	austin.main@mybinxhealth.com	darren.gerrish@mybinxhealth.com
61	austin.main@mybinxhealth.com	justin.lebrocq@mybinxhealth.com
62	dan.milano@mybinxhealth.com	alex.tsang@mybinxhealth.com
63	sheila.mirasolo@mybinxhealth.com	mallory.caron@mybinxhealth.com
64	sheila.mirasolo@mybinxhealth.com	chelsea.murphy@mybinxhealth.com
65	sheila.mirasolo@mybinxhealth.com	sasha.carr@mybinxhealth.com
66	sheila.mirasolo@mybinxhealth.com	clerveau.toussaint@mybinxhealth.com
67	tony.moran@mybinxhealth.com	kay.kelly@mybinxhealth.com
68	tony.moran@mybinxhealth.com	austin.main@mybinxhealth.com
69	pia.olson@mybinxhealth.com	ashley.brown@mybinxhealth.com
70	pia.olson@mybinxhealth.com	amber.ralf@mybinxhealth.com
71	ben.reynolds@mybinxhealth.com	rose.burt@mybinxhealth.com
72	ben.reynolds@mybinxhealth.com	lloyd.peacock@mybinxhealth.com
73	ben.reynolds@mybinxhealth.com	karen.schneider@mybinxhealth.com
74	ben.reynolds@mybinxhealth.com	jj.watson@mybinxhealth.com
75	mike.karsonovich@mybinxhealth.com	reid.clanton@mybinxhealth.com
76	mike.karsonovich@mybinxhealth.com	rich.dibiase@mybinxhealth.com
77	mike.karsonovich@mybinxhealth.com	juan.gutierrez@mybinxhealth.com
78	mike.karsonovich@mybinxhealth.com	justin.laxton@mybinxhealth.com
79	mike.karsonovich@mybinxhealth.com	erin.mccormick@mybinxhealth.com
80	mike.karsonovich@mybinxhealth.com	susan.ocasio@mybinxhealth.com
81	mike.karsonovich@mybinxhealth.com	shawna.osborn@mybinxhealth.com
82	mike.karsonovich@mybinxhealth.com	cathy.otto@mybinxhealth.com
83	mike.karsonovich@mybinxhealth.com	dori.repuyan@mybinxhealth.com
84	mike.karsonovich@mybinxhealth.com	geoffrey.richman@mybinxhealth.com
85	mike.karsonovich@mybinxhealth.com	pam.villalba@mybinxhealth.com
86	mike.karsonovich@mybinxhealth.com	emily.wiitala@mybinxhealth.com
87	taylor.santos@mybinxhealth.com	kennedy.daiger@mybinxhealth.com
88	tim.stewart@mybinxhealth.com	gregg.kelley@mybinxhealth.com
89	mike.storm@mybinxhealth.com	ellis.lambert@mybinxhealth.com
90	nasa.suon@mybinxhealth.com	evan.bartlett@mybinxhealth.com
91	sarah.thomas@mybinxhealth.com	rachel.korwek@mybinxhealth.com
92	sarah.thomas@mybinxhealth.com	tracie.medairos@mybinxhealth.com
93	sarah.thomas@mybinxhealth.com	nasa.suon@mybinxhealth.com
94	sarah.thomas@mybinxhealth.com	nicole.freeman@mybinxhealth.com
95	sarah.thomas@mybinxhealth.com	misty.woods-barnett@mybinxhealth.com
96	misty.woods-barnett@mybinxhealth.com	monique.doyle@mybinxhealth.com
97	misty.woods-barnett@mybinxhealth.com	dustin.johnson@mybinxhealth.com
98	misty.woods-barnett@mybinxhealth.com	alexia.osei-dabankah@mybinxhealth.com
99	misty.woods-barnett@mybinxhealth.com	reno.torres@mybinxhealth.com
100	abby.wright@mybinxhealth.com	kalli.glanz@mybinxhealth.com
101	abby.wright@mybinxhealth.com	alyssa.luber@mybinxhealth.com
102	jeff.luber@mybinxhealth.com	jeff.luber@mybinxhealth.com
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.team_members (id, user_id, user_is_manager, team_id) FROM stdin;
8	1	f	-1
9	2	f	-1
10	3	f	-1
12	5	f	-1
13	6	f	-1
14	7	f	-1
15	8	f	-1
16	9	f	-1
17	10	f	-1
18	11	f	-1
19	12	f	-1
20	13	f	-1
22	15	f	-1
23	16	f	-1
24	17	f	-1
25	18	f	-1
26	19	f	-1
27	20	f	-1
28	22	f	-1
29	23	f	-1
30	24	f	-1
31	25	f	-1
32	26	f	-1
33	27	f	-1
34	28	f	-1
35	29	f	-1
36	30	f	-1
37	31	f	-1
2	32	f	4
3	33	f	4
4	34	f	4
6	36	f	4
39	38	f	-1
40	39	f	-1
41	40	f	-1
42	41	f	-1
43	42	f	-1
44	43	f	-1
45	44	f	-1
46	45	f	-1
47	46	f	-1
49	48	f	-1
50	49	f	-1
51	50	f	-1
52	51	f	-1
53	52	f	-1
54	53	f	-1
55	54	f	-1
56	55	f	-1
57	57	f	-1
58	58	f	-1
59	59	f	-1
60	60	f	-1
61	61	f	-1
62	62	f	-1
63	63	f	-1
64	64	f	-1
65	65	f	-1
66	66	f	-1
67	67	f	-1
68	68	f	-1
69	69	f	-1
70	70	f	-1
71	71	f	-1
72	72	f	-1
73	73	f	-1
74	74	f	-1
75	75	f	-1
76	76	f	-1
77	77	f	-1
78	78	f	-1
79	79	f	-1
80	80	f	-1
81	81	f	-1
82	82	f	-1
83	83	f	-1
84	84	f	-1
85	85	f	-1
86	86	f	-1
87	87	f	-1
88	88	f	-1
89	89	f	-1
90	90	f	-1
91	91	f	-1
92	92	f	-1
93	93	f	-1
94	94	f	-1
95	95	f	-1
96	96	f	-1
97	97	f	-1
98	98	f	-1
99	99	f	-1
100	105	t	13
101	106	f	13
5	35	f	4
1	21	t	4
11	4	f	-1
21	14	f	-1
3	124	f	4
1	122	f	-1
2	123	f	-1
7	56	t	5
48	47	f	-1
38	37	f	-1
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.teams (id, name) FROM stdin;
7	Human Resources
2	POC Sales
11	Quality Control & Technical Product
10	Quality Assurance
8	Logistics & Supply Chain
12	Product Development
6	Accounting
9	Operations
4	Systems Engineering
3	Global Customer Support
13	Application Test Team
1	Commercial
0	binx
5	executives
\.


--
-- Data for Name: training_history; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.training_history (id, userid, documentid, usercurrentrevision, training_complete, training_complete_date) FROM stdin;
1	102	990	0	t	2023-11-28 15:38:30.4743
2	102	975	2	t	2023-11-28 15:38:30.475104
3	102	848	2	t	2023-11-28 15:38:30.475119
4	102	571	0	t	2023-11-28 15:38:30.475124
5	102	765	0	t	2023-11-28 15:38:30.475128
6	102	32	9	t	2023-11-28 15:38:30.475132
7	102	115	10	t	2023-11-28 15:38:30.475136
8	102	719	6	t	2023-11-28 15:38:30.475139
9	102	199	4	t	2023-11-28 15:38:30.475143
10	102	204	18	t	2023-11-28 15:38:30.475147
11	102	871	7	t	2023-11-28 15:38:30.47515
12	102	558	15	t	2023-11-28 15:38:30.475154
13	102	664	4	t	2023-11-28 15:38:30.475157
14	102	391	5	t	2023-11-28 15:38:30.475161
15	102	158	8	t	2023-11-28 15:38:30.475164
16	102	915	17	t	2023-11-28 15:38:30.475168
17	102	251	10	t	2023-11-28 15:38:30.475172
18	102	376	8	t	2023-11-28 15:38:30.475176
19	102	523	7	t	2023-11-28 15:38:30.475199
20	102	867	4	t	2023-11-28 15:38:30.475208
21	102	1020	7	f	2023-11-28 15:38:30.475212
22	102	477	6	t	2023-11-28 15:38:30.475234
23	102	326	5	t	2023-11-28 15:38:30.475241
24	102	1030	7	t	2023-11-28 15:38:30.475245
25	102	299	8	f	2023-11-28 15:38:30.475249
26	102	490	5	t	2023-11-28 15:38:30.475253
27	102	168	9	t	2023-11-28 15:38:30.475258
28	102	165	5	t	2023-11-28 15:38:30.475262
29	102	1065	2	t	2023-11-28 15:38:30.475266
30	102	284	4	t	2023-11-28 15:38:30.475269
31	102	947	3	t	2023-11-28 15:38:30.475273
32	102	93	4	t	2023-11-28 15:38:30.475277
33	102	1012	3	f	2023-11-28 15:38:30.47529
34	102	373	6	f	2023-11-28 15:38:30.475294
35	102	782	6	t	2023-11-28 15:38:30.475299
36	102	981	6	t	2023-11-28 15:38:30.475302
37	102	92	4	t	2023-11-28 15:38:30.475306
38	102	687	14	t	2023-11-28 15:38:30.47531
39	102	1053	7	t	2023-11-28 15:38:30.475313
40	102	236	5	f	2023-11-28 15:38:30.475317
41	102	459	7	t	2023-11-28 15:38:30.475321
42	102	153	3	t	2023-11-28 15:38:30.475324
43	102	870	0	t	2023-11-28 15:38:30.475328
44	102	96	0	t	2023-11-28 15:38:30.475332
45	102	824	0	t	2023-11-28 15:38:30.475335
46	102	552	0	t	2023-11-28 15:38:30.475339
47	102	648	0	t	2023-11-28 15:38:30.475343
48	102	181	0	t	2023-11-28 15:38:30.475346
49	102	890	0	t	2023-11-28 15:38:30.47535
50	102	36	0	t	2023-11-28 15:38:30.47536
51	102	64	0	t	2023-11-28 15:38:30.475364
52	102	377	0	t	2023-11-28 15:38:30.475367
53	102	127	0	t	2023-11-28 15:38:30.475371
54	102	1006	0	t	2023-11-28 15:38:30.475375
55	56	990	0	t	2023-11-28 15:38:30.475379
56	56	975	2	t	2023-11-28 15:38:30.475383
57	56	848	2	t	2023-11-28 15:38:30.475386
58	56	765	0	t	2023-11-28 15:38:30.47539
59	56	32	9	t	2023-11-28 15:38:30.475393
60	56	45	6	t	2023-11-28 15:38:30.475397
61	56	635	9	t	2023-11-28 15:38:30.4754
62	56	184	8	t	2023-11-28 15:38:30.475404
63	56	221	5	t	2023-11-28 15:38:30.475408
64	56	840	4	t	2023-11-28 15:38:30.475411
65	56	115	10	t	2023-11-28 15:38:30.475415
66	56	719	6	t	2023-11-28 15:38:30.475418
67	56	876	6	t	2023-11-28 15:38:30.475421
68	56	574	3	t	2023-11-28 15:38:30.475426
69	56	204	18	t	2023-11-28 15:38:30.475429
70	56	558	15	t	2023-11-28 15:38:30.475432
71	56	391	5	t	2023-11-28 15:38:30.475436
72	56	158	8	t	2023-11-28 15:38:30.475439
73	56	511	5	f	2023-11-28 15:38:30.475443
74	56	505	6	t	2023-11-28 15:38:30.475468
75	56	330	8	t	2023-11-28 15:38:30.475493
76	56	354	9	t	2023-11-28 15:38:30.475497
77	56	193	12	t	2023-11-28 15:38:30.475514
78	56	307	4	t	2023-11-28 15:38:30.475518
79	56	518	10	t	2023-11-28 15:38:30.475522
80	56	639	5	t	2023-11-28 15:38:30.475526
81	56	587	4	t	2023-11-28 15:38:30.475529
82	56	661	5	f	2023-11-28 15:38:30.475577
83	56	438	5	f	2023-11-28 15:38:30.475582
84	56	436	3	t	2023-11-28 15:38:30.475586
85	56	254	3	t	2023-11-28 15:38:30.47559
86	56	190	1	t	2023-11-28 15:38:30.475594
87	56	620	2	t	2023-11-28 15:38:30.475621
88	56	915	17	f	2023-11-28 15:38:30.475626
89	56	528	12	f	2023-11-28 15:38:30.475629
90	56	251	10	f	2023-11-28 15:38:30.475654
91	56	376	8	f	2023-11-28 15:38:30.475686
92	56	867	4	f	2023-11-28 15:38:30.475691
93	56	1020	7	f	2023-11-28 15:38:30.475696
94	56	326	5	t	2023-11-28 15:38:30.475699
95	56	1030	7	t	2023-11-28 15:38:30.475703
96	56	299	8	f	2023-11-28 15:38:30.475706
97	56	168	9	t	2023-11-28 15:38:30.47571
98	56	1065	2	t	2023-11-28 15:38:30.475713
99	56	284	4	t	2023-11-28 15:38:30.475716
100	56	617	8	t	2023-11-28 15:38:30.47572
101	56	947	3	f	2023-11-28 15:38:30.475724
102	56	373	6	f	2023-11-28 15:38:30.475728
103	56	394	1	t	2023-11-28 15:38:30.475731
104	56	782	6	t	2023-11-28 15:38:30.475735
105	56	981	6	t	2023-11-28 15:38:30.475746
106	56	92	4	t	2023-11-28 15:38:30.47575
107	56	687	14	f	2023-11-28 15:38:30.475754
108	56	395	13	t	2023-11-28 15:38:30.475757
109	56	565	8	t	2023-11-28 15:38:30.475761
110	56	459	7	t	2023-11-28 15:38:30.475765
111	56	153	3	t	2023-11-28 15:38:30.475768
112	56	859	4	t	2023-11-28 15:38:30.475772
113	56	658	3	t	2023-11-28 15:38:30.475775
114	56	202	3	t	2023-11-28 15:38:30.475779
115	56	725	3	t	2023-11-28 15:38:30.475782
116	56	870	0	f	2023-11-28 15:38:30.475786
117	56	96	0	f	2023-11-28 15:38:30.475801
118	56	824	0	f	2023-11-28 15:38:30.475805
119	56	552	0	f	2023-11-28 15:38:30.475808
120	56	648	0	f	2023-11-28 15:38:30.475812
121	56	181	0	f	2023-11-28 15:38:30.475815
122	56	890	0	f	2023-11-28 15:38:30.475819
123	56	36	0	f	2023-11-28 15:38:30.475822
124	56	64	0	f	2023-11-28 15:38:30.475826
125	56	377	0	f	2023-11-28 15:38:30.475829
126	56	127	0	f	2023-11-28 15:38:30.475832
127	56	1006	0	f	2023-11-28 15:38:30.475836
128	101	990	0	t	2023-11-28 15:38:30.475868
129	101	975	2	t	2023-11-28 15:38:30.475871
130	101	848	2	t	2023-11-28 15:38:30.475875
131	101	204	18	t	2023-11-28 15:38:30.475898
132	101	871	7	f	2023-11-28 15:38:30.475902
133	101	558	15	f	2023-11-28 15:38:30.475907
134	101	664	4	t	2023-11-28 15:38:30.475911
135	101	391	5	t	2023-11-28 15:38:30.475915
136	101	158	8	t	2023-11-28 15:38:30.475919
137	101	511	5	f	2023-11-28 15:38:30.475922
138	101	982	10	t	2023-11-28 15:38:30.475926
139	101	376	8	f	2023-11-28 15:38:30.47593
140	101	1020	7	f	2023-11-28 15:38:30.475933
141	101	1030	7	t	2023-11-28 15:38:30.475937
142	101	299	8	f	2023-11-28 15:38:30.47594
143	101	168	9	f	2023-11-28 15:38:30.475944
144	101	1065	2	t	2023-11-28 15:38:30.475947
145	101	373	6	f	2023-11-28 15:38:30.475951
146	101	236	5	f	2023-11-28 15:38:30.475954
147	101	459	7	t	2023-11-28 15:38:30.475958
148	101	870	0	f	2023-11-28 15:38:30.475961
149	101	96	0	f	2023-11-28 15:38:30.475965
150	101	824	0	f	2023-11-28 15:38:30.475968
151	101	552	0	f	2023-11-28 15:38:30.475971
152	101	648	0	f	2023-11-28 15:38:30.475975
153	101	181	0	f	2023-11-28 15:38:30.475978
154	101	890	0	f	2023-11-28 15:38:30.475982
155	101	36	0	f	2023-11-28 15:38:30.475985
156	101	64	0	f	2023-11-28 15:38:30.475989
157	101	377	0	f	2023-11-28 15:38:30.475992
158	101	127	0	f	2023-11-28 15:38:30.475996
159	101	1006	0	f	2023-11-28 15:38:30.476197
160	37	870	0	f	2023-11-28 15:38:30.476205
161	37	96	0	f	2023-11-28 15:38:30.476213
162	37	824	0	f	2023-11-28 15:38:30.476217
163	37	552	0	f	2023-11-28 15:38:30.47622
164	37	648	0	f	2023-11-28 15:38:30.476224
165	37	181	0	f	2023-11-28 15:38:30.476228
166	37	890	0	f	2023-11-28 15:38:30.476232
167	37	36	0	f	2023-11-28 15:38:30.476236
168	37	64	0	f	2023-11-28 15:38:30.47624
169	37	377	0	f	2023-11-28 15:38:30.476243
170	37	127	0	f	2023-11-28 15:38:30.476247
171	37	1006	0	f	2023-11-28 15:38:30.476251
172	2	990	0	f	2023-11-28 15:38:30.476255
173	2	975	2	f	2023-11-28 15:38:30.476258
174	2	848	2	f	2023-11-28 15:38:30.476262
175	2	571	0	f	2023-11-28 15:38:30.476266
176	2	765	0	f	2023-11-28 15:38:30.47627
177	2	664	4	f	2023-11-28 15:38:30.476273
178	2	391	5	f	2023-11-28 15:38:30.476277
179	2	158	8	f	2023-11-28 15:38:30.47628
180	2	511	5	f	2023-11-28 15:38:30.476284
181	2	376	8	f	2023-11-28 15:38:30.476287
182	2	523	7	f	2023-11-28 15:38:30.476291
183	2	201	5	t	2023-11-28 15:38:30.476295
184	2	1020	7	f	2023-11-28 15:38:30.476298
185	2	299	8	f	2023-11-28 15:38:30.476302
186	2	168	9	f	2023-11-28 15:38:30.476306
187	2	165	5	f	2023-11-28 15:38:30.476309
188	2	1065	2	f	2023-11-28 15:38:30.476313
189	2	373	6	f	2023-11-28 15:38:30.47633
190	2	459	7	f	2023-11-28 15:38:30.476334
191	2	870	0	f	2023-11-28 15:38:30.476338
192	2	96	0	f	2023-11-28 15:38:30.476341
193	2	824	0	f	2023-11-28 15:38:30.476349
194	2	552	0	f	2023-11-28 15:38:30.476352
195	2	648	0	f	2023-11-28 15:38:30.476356
196	2	181	0	f	2023-11-28 15:38:30.476359
197	2	890	0	f	2023-11-28 15:38:30.476363
198	2	36	0	f	2023-11-28 15:38:30.476366
199	2	64	0	f	2023-11-28 15:38:30.47637
200	2	377	0	f	2023-11-28 15:38:30.476374
201	2	127	0	f	2023-11-28 15:38:30.476377
202	2	1006	0	f	2023-11-28 15:38:30.476381
203	92	990	0	t	2023-11-28 15:38:30.476384
204	92	391	5	t	2023-11-28 15:38:30.476389
205	92	158	8	t	2023-11-28 15:38:30.476393
206	92	376	8	f	2023-11-28 15:38:30.476396
207	92	523	7	f	2023-11-28 15:38:30.4764
208	92	1030	7	f	2023-11-28 15:38:30.476404
209	92	299	8	f	2023-11-28 15:38:30.476407
210	92	168	9	t	2023-11-28 15:38:30.476412
211	92	1065	2	t	2023-11-28 15:38:30.476416
212	92	373	6	f	2023-11-28 15:38:30.476419
213	92	459	7	f	2023-11-28 15:38:30.476424
214	92	870	0	f	2023-11-28 15:38:30.476428
215	92	96	0	f	2023-11-28 15:38:30.476431
216	92	824	0	f	2023-11-28 15:38:30.476438
217	92	552	0	f	2023-11-28 15:38:30.476442
218	92	648	0	f	2023-11-28 15:38:30.476446
219	92	181	0	f	2023-11-28 15:38:30.476449
220	92	890	0	f	2023-11-28 15:38:30.476453
221	92	36	0	f	2023-11-28 15:38:30.476456
222	92	64	0	f	2023-11-28 15:38:30.47646
223	92	377	0	f	2023-11-28 15:38:30.476464
224	92	127	0	f	2023-11-28 15:38:30.476467
225	92	1006	0	f	2023-11-28 15:38:30.476473
226	93	209	0	t	2023-11-28 15:38:30.476477
227	93	990	0	t	2023-11-28 15:38:30.47648
228	93	32	9	f	2023-11-28 15:38:30.476484
229	93	204	18	t	2023-11-28 15:38:30.476487
230	93	558	15	f	2023-11-28 15:38:30.47649
231	93	391	5	t	2023-11-28 15:38:30.476494
232	93	158	8	t	2023-11-28 15:38:30.476497
233	93	137	5	t	2023-11-28 15:38:30.476501
234	93	486	8	t	2023-11-28 15:38:30.476505
235	93	915	17	f	2023-11-28 15:38:30.476508
236	93	376	8	f	2023-11-28 15:38:30.476511
237	93	523	7	f	2023-11-28 15:38:30.476515
238	93	477	6	t	2023-11-28 15:38:30.476518
239	93	1030	7	t	2023-11-28 15:38:30.476521
240	93	168	9	f	2023-11-28 15:38:30.476526
241	93	1065	2	t	2023-11-28 15:38:30.476529
242	93	373	6	f	2023-11-28 15:38:30.476532
243	93	701	3	t	2023-11-28 15:38:30.476536
244	93	687	14	f	2023-11-28 15:38:30.476548
245	93	1053	7	t	2023-11-28 15:38:30.476552
246	93	236	5	f	2023-11-28 15:38:30.476555
247	93	459	7	t	2023-11-28 15:38:30.476559
248	93	870	0	f	2023-11-28 15:38:30.476562
249	93	96	0	f	2023-11-28 15:38:30.476566
250	93	824	0	f	2023-11-28 15:38:30.476569
251	93	552	0	f	2023-11-28 15:38:30.476572
252	93	648	0	f	2023-11-28 15:38:30.476576
253	93	181	0	f	2023-11-28 15:38:30.476579
254	93	890	0	f	2023-11-28 15:38:30.476582
255	93	36	0	f	2023-11-28 15:38:30.476586
256	93	64	0	f	2023-11-28 15:38:30.476589
257	93	377	0	f	2023-11-28 15:38:30.476592
258	93	127	0	f	2023-11-28 15:38:30.476596
259	93	1006	0	f	2023-11-28 15:38:30.476599
260	98	975	2	t	2023-11-28 15:38:30.476603
261	98	848	2	t	2023-11-28 15:38:30.476607
262	98	32	9	f	2023-11-28 15:38:30.476611
263	98	446	1	t	2023-11-28 15:38:30.476615
264	98	635	9	t	2023-11-28 15:38:30.476619
265	98	840	4	t	2023-11-28 15:38:30.476623
266	98	204	18	t	2023-11-28 15:38:30.476627
267	98	558	15	t	2023-11-28 15:38:30.476631
268	98	664	4	t	2023-11-28 15:38:30.476634
269	98	391	5	t	2023-11-28 15:38:30.476638
270	98	158	8	t	2023-11-28 15:38:30.476642
271	98	61	3	t	2023-11-28 15:38:30.476646
272	98	585	4	t	2023-11-28 15:38:30.47667
273	98	915	17	f	2023-11-28 15:38:30.476681
274	98	376	8	f	2023-11-28 15:38:30.476688
275	98	523	7	f	2023-11-28 15:38:30.476693
276	98	1020	7	f	2023-11-28 15:38:30.476697
277	98	1030	7	t	2023-11-28 15:38:30.476701
278	98	299	8	f	2023-11-28 15:38:30.476705
279	98	168	9	f	2023-11-28 15:38:30.476709
280	98	1065	2	t	2023-11-28 15:38:30.476713
281	98	373	6	f	2023-11-28 15:38:30.476717
282	98	687	14	f	2023-11-28 15:38:30.476721
283	98	1053	7	t	2023-11-28 15:38:30.476725
284	98	236	5	f	2023-11-28 15:38:30.476729
285	98	459	7	t	2023-11-28 15:38:30.476733
286	98	870	0	f	2023-11-28 15:38:30.476737
287	98	96	0	f	2023-11-28 15:38:30.47674
288	98	824	0	f	2023-11-28 15:38:30.476744
289	98	552	0	f	2023-11-28 15:38:30.476748
290	98	648	0	f	2023-11-28 15:38:30.476752
291	98	181	0	f	2023-11-28 15:38:30.476756
292	98	890	0	f	2023-11-28 15:38:30.47676
293	98	36	0	f	2023-11-28 15:38:30.476764
294	98	64	0	f	2023-11-28 15:38:30.476768
295	98	377	0	f	2023-11-28 15:38:30.476772
296	98	127	0	f	2023-11-28 15:38:30.476776
297	98	1006	0	f	2023-11-28 15:38:30.47678
298	90	32	9	f	2023-11-28 15:38:30.476785
299	90	204	18	t	2023-11-28 15:38:30.476813
300	90	558	15	t	2023-11-28 15:38:30.476818
301	90	391	5	t	2023-11-28 15:38:30.476822
302	90	158	8	t	2023-11-28 15:38:30.476825
303	90	109	2	t	2023-11-28 15:38:30.476829
304	90	137	5	t	2023-11-28 15:38:30.476833
305	90	486	8	t	2023-11-28 15:38:30.476837
306	90	915	17	t	2023-11-28 15:38:30.47684
307	90	251	10	f	2023-11-28 15:38:30.476844
308	90	376	8	f	2023-11-28 15:38:30.476848
309	90	523	7	t	2023-11-28 15:38:30.476851
310	90	477	6	t	2023-11-28 15:38:30.476855
311	90	1030	7	t	2023-11-28 15:38:30.476859
312	90	168	9	t	2023-11-28 15:38:30.476863
313	90	1065	2	t	2023-11-28 15:38:30.476867
314	90	373	6	f	2023-11-28 15:38:30.476871
315	90	701	3	t	2023-11-28 15:38:30.476874
316	90	687	14	f	2023-11-28 15:38:30.476943
317	90	1053	7	t	2023-11-28 15:38:30.476948
318	90	236	5	f	2023-11-28 15:38:30.476952
319	90	459	7	t	2023-11-28 15:38:30.476955
320	90	870	0	f	2023-11-28 15:38:30.476959
321	90	96	0	f	2023-11-28 15:38:30.476963
322	90	824	0	f	2023-11-28 15:38:30.476966
323	90	552	0	f	2023-11-28 15:38:30.47697
324	90	648	0	f	2023-11-28 15:38:30.476974
325	90	181	0	f	2023-11-28 15:38:30.476977
326	90	890	0	f	2023-11-28 15:38:30.476981
327	90	36	0	f	2023-11-28 15:38:30.476994
328	90	64	0	f	2023-11-28 15:38:30.477003
329	90	377	0	f	2023-11-28 15:38:30.477007
330	90	127	0	f	2023-11-28 15:38:30.477011
331	90	1006	0	f	2023-11-28 15:38:30.477015
332	99	32	9	t	2023-11-28 15:38:30.477019
333	99	204	18	t	2023-11-28 15:38:30.477022
334	99	558	15	t	2023-11-28 15:38:30.477026
335	99	391	5	t	2023-11-28 15:38:30.477029
336	99	158	8	t	2023-11-28 15:38:30.477033
337	99	376	8	f	2023-11-28 15:38:30.477037
338	99	523	7	t	2023-11-28 15:38:30.47704
339	99	168	9	t	2023-11-28 15:38:30.477044
340	99	1065	2	t	2023-11-28 15:38:30.477052
341	99	373	6	f	2023-11-28 15:38:30.477056
342	99	687	14	f	2023-11-28 15:38:30.47706
343	99	1053	7	t	2023-11-28 15:38:30.477064
344	99	236	5	f	2023-11-28 15:38:30.477068
345	99	459	7	t	2023-11-28 15:38:30.477071
346	99	870	0	f	2023-11-28 15:38:30.477075
347	99	96	0	f	2023-11-28 15:38:30.477078
348	99	824	0	f	2023-11-28 15:38:30.477082
349	99	552	0	f	2023-11-28 15:38:30.477085
350	99	648	0	f	2023-11-28 15:38:30.477089
351	99	181	0	f	2023-11-28 15:38:30.477092
352	99	890	0	f	2023-11-28 15:38:30.477096
353	99	36	0	f	2023-11-28 15:38:30.4771
354	99	64	0	f	2023-11-28 15:38:30.477103
355	99	377	0	f	2023-11-28 15:38:30.477116
356	99	127	0	f	2023-11-28 15:38:30.47712
357	99	1006	0	f	2023-11-28 15:38:30.477127
358	91	990	0	f	2023-11-28 15:38:30.477142
359	91	558	15	f	2023-11-28 15:38:30.477146
360	91	391	5	f	2023-11-28 15:38:30.477149
361	91	158	8	f	2023-11-28 15:38:30.477153
362	91	109	2	f	2023-11-28 15:38:30.477157
363	91	376	8	f	2023-11-28 15:38:30.47716
364	91	1030	7	f	2023-11-28 15:38:30.477164
365	91	299	8	f	2023-11-28 15:38:30.477168
366	91	168	9	f	2023-11-28 15:38:30.477173
367	91	1065	2	f	2023-11-28 15:38:30.477177
368	91	373	6	f	2023-11-28 15:38:30.47718
369	91	687	14	f	2023-11-28 15:38:30.477184
370	91	1053	7	f	2023-11-28 15:38:30.477187
371	91	236	5	f	2023-11-28 15:38:30.477191
372	91	459	7	f	2023-11-28 15:38:30.477195
373	91	870	0	f	2023-11-28 15:38:30.477198
374	91	96	0	f	2023-11-28 15:38:30.477202
375	91	824	0	f	2023-11-28 15:38:30.477206
376	91	552	0	f	2023-11-28 15:38:30.477209
377	91	648	0	f	2023-11-28 15:38:30.477213
378	91	181	0	f	2023-11-28 15:38:30.477216
379	91	890	0	f	2023-11-28 15:38:30.47722
380	91	36	0	f	2023-11-28 15:38:30.477224
381	91	64	0	f	2023-11-28 15:38:30.477227
382	91	377	0	f	2023-11-28 15:38:30.477231
383	91	127	0	f	2023-11-28 15:38:30.477236
384	91	1006	0	f	2023-11-28 15:38:30.477239
385	35	990	0	t	2023-11-28 15:38:30.477243
386	35	975	2	t	2023-11-28 15:38:30.477247
387	35	848	2	t	2023-11-28 15:38:30.477251
388	35	571	0	t	2023-11-28 15:38:30.477254
389	35	765	0	t	2023-11-28 15:38:30.477258
390	35	898	3	t	2023-11-28 15:38:30.477262
391	35	500	5	t	2023-11-28 15:38:30.477267
392	35	294	5	t	2023-11-28 15:38:30.477271
393	35	909	5	t	2023-11-28 15:38:30.477275
394	35	1060	5	t	2023-11-28 15:38:30.477279
395	35	968	5	t	2023-11-28 15:38:30.477283
396	35	433	5	t	2023-11-28 15:38:30.477287
397	35	342	5	t	2023-11-28 15:38:30.477291
398	35	1074	5	t	2023-11-28 15:38:30.477295
399	35	757	4	t	2023-11-28 15:38:30.477299
400	35	270	6	t	2023-11-28 15:38:30.477303
401	35	443	5	t	2023-11-28 15:38:30.477306
402	35	32	9	t	2023-11-28 15:38:30.47731
403	35	45	6	t	2023-11-28 15:38:30.477313
404	35	635	9	t	2023-11-28 15:38:30.477317
405	35	184	8	t	2023-11-28 15:38:30.477321
406	35	221	5	t	2023-11-28 15:38:30.477324
407	35	840	4	t	2023-11-28 15:38:30.477328
408	35	961	3	t	2023-11-28 15:38:30.477332
409	35	340	4	t	2023-11-28 15:38:30.47747
410	35	345	5	t	2023-11-28 15:38:30.477478
411	35	37	3	t	2023-11-28 15:38:30.477483
412	35	772	5	t	2023-11-28 15:38:30.477488
413	35	407	4	t	2023-11-28 15:38:30.477492
414	35	1043	3	t	2023-11-28 15:38:30.477496
415	35	800	3	t	2023-11-28 15:38:30.4775
416	35	889	6	t	2023-11-28 15:38:30.477507
417	35	115	10	t	2023-11-28 15:38:30.477512
418	35	719	6	t	2023-11-28 15:38:30.477516
419	35	876	6	t	2023-11-28 15:38:30.477519
420	35	199	4	t	2023-11-28 15:38:30.477523
421	35	574	3	t	2023-11-28 15:38:30.477527
422	35	204	18	t	2023-11-28 15:38:30.477531
423	35	871	7	f	2023-11-28 15:38:30.477535
424	35	558	15	t	2023-11-28 15:38:30.477539
425	35	516	3	t	2023-11-28 15:38:30.477543
426	35	391	5	t	2023-11-28 15:38:30.477546
427	35	7	2	t	2023-11-28 15:38:30.47755
428	35	158	8	t	2023-11-28 15:38:30.477554
429	35	61	3	t	2023-11-28 15:38:30.477558
430	35	585	4	t	2023-11-28 15:38:30.477562
431	35	728	2	t	2023-11-28 15:38:30.477567
432	35	78	2	t	2023-11-28 15:38:30.477571
433	35	570	2	t	2023-11-28 15:38:30.477577
434	35	1048	5	t	2023-11-28 15:38:30.477582
435	35	869	3	t	2023-11-28 15:38:30.477586
436	35	330	8	t	2023-11-28 15:38:30.47759
437	35	354	9	t	2023-11-28 15:38:30.477594
438	35	384	6	t	2023-11-28 15:38:30.477598
439	35	193	12	t	2023-11-28 15:38:30.477603
440	35	307	4	t	2023-11-28 15:38:30.477607
441	35	518	10	t	2023-11-28 15:38:30.477611
442	35	960	7	t	2023-11-28 15:38:30.477615
443	35	673	20	t	2023-11-28 15:38:30.47762
444	35	639	5	t	2023-11-28 15:38:30.477624
445	35	996	4	t	2023-11-28 15:38:30.477628
446	35	438	5	t	2023-11-28 15:38:30.477631
447	35	365	3	t	2023-11-28 15:38:30.477635
448	35	137	5	t	2023-11-28 15:38:30.477639
449	35	486	8	t	2023-11-28 15:38:30.477643
450	35	666	3	t	2023-11-28 15:38:30.477647
451	35	616	3	t	2023-11-28 15:38:30.477651
452	35	276	1	t	2023-11-28 15:38:30.477655
453	35	641	2	t	2023-11-28 15:38:30.477659
454	35	187	2	t	2023-11-28 15:38:30.477663
455	35	733	3	t	2023-11-28 15:38:30.477667
456	35	581	3	t	2023-11-28 15:38:30.477671
457	35	864	5	t	2023-11-28 15:38:30.477675
458	35	151	3	t	2023-11-28 15:38:30.477679
459	35	254	3	t	2023-11-28 15:38:30.477682
460	35	813	2	t	2023-11-28 15:38:30.477686
461	35	1054	3	t	2023-11-28 15:38:30.477703
462	35	291	2	t	2023-11-28 15:38:30.477707
463	35	1000	2	t	2023-11-28 15:38:30.477712
464	35	902	2	t	2023-11-28 15:38:30.477716
465	35	190	1	t	2023-11-28 15:38:30.47772
466	35	182	2	t	2023-11-28 15:38:30.477724
467	35	258	1	t	2023-11-28 15:38:30.477728
468	35	620	2	t	2023-11-28 15:38:30.477731
469	35	915	17	t	2023-11-28 15:38:30.477735
470	35	528	12	t	2023-11-28 15:38:30.477739
471	35	251	10	t	2023-11-28 15:38:30.477743
472	35	376	8	t	2023-11-28 15:38:30.477746
473	35	523	7	t	2023-11-28 15:38:30.477771
474	35	201	5	t	2023-11-28 15:38:30.477775
475	35	867	4	t	2023-11-28 15:38:30.477779
476	35	1020	7	f	2023-11-28 15:38:30.477783
477	35	452	3	t	2023-11-28 15:38:30.477787
478	35	477	6	t	2023-11-28 15:38:30.477791
479	35	326	5	t	2023-11-28 15:38:30.477794
480	35	1030	7	t	2023-11-28 15:38:30.477798
481	35	299	8	f	2023-11-28 15:38:30.477802
482	35	490	5	t	2023-11-28 15:38:30.477806
483	35	189	3	t	2023-11-28 15:38:30.477811
484	35	763	1	t	2023-11-28 15:38:30.477815
485	35	358	2	t	2023-11-28 15:38:30.47782
486	35	168	9	t	2023-11-28 15:38:30.477824
487	35	165	5	t	2023-11-28 15:38:30.477828
488	35	1065	2	t	2023-11-28 15:38:30.477832
489	35	435	4	t	2023-11-28 15:38:30.477837
490	35	284	4	t	2023-11-28 15:38:30.477841
491	35	617	8	t	2023-11-28 15:38:30.477845
492	35	947	3	t	2023-11-28 15:38:30.477849
493	35	1005	2	t	2023-11-28 15:38:30.477852
494	35	93	4	t	2023-11-28 15:38:30.477859
495	35	964	5	t	2023-11-28 15:38:30.477863
496	35	1012	3	f	2023-11-28 15:38:30.477867
497	35	373	6	f	2023-11-28 15:38:30.477871
498	35	701	3	t	2023-11-28 15:38:30.477875
499	35	782	6	t	2023-11-28 15:38:30.477923
500	35	981	6	t	2023-11-28 15:38:30.477927
501	35	92	4	t	2023-11-28 15:38:30.477931
502	35	687	14	t	2023-11-28 15:38:30.477935
503	35	1053	7	t	2023-11-28 15:38:30.477939
504	35	707	7	t	2023-11-28 15:38:30.477943
505	35	395	13	t	2023-11-28 15:38:30.477946
506	35	565	8	t	2023-11-28 15:38:30.47795
507	35	989	8	t	2023-11-28 15:38:30.477954
508	35	236	5	f	2023-11-28 15:38:30.477958
509	35	410	3	f	2023-11-28 15:38:30.477962
510	35	685	3	t	2023-11-28 15:38:30.477966
511	35	459	7	t	2023-11-28 15:38:30.47797
512	35	153	3	t	2023-11-28 15:38:30.477973
513	35	859	4	t	2023-11-28 15:38:30.477977
514	35	658	3	t	2023-11-28 15:38:30.477981
515	35	202	3	t	2023-11-28 15:38:30.477985
516	35	725	3	t	2023-11-28 15:38:30.47799
517	35	870	0	t	2023-11-28 15:38:30.477994
518	35	96	0	t	2023-11-28 15:38:30.477998
519	35	824	0	t	2023-11-28 15:38:30.478002
520	35	552	0	t	2023-11-28 15:38:30.478005
521	35	648	0	t	2023-11-28 15:38:30.478009
522	35	181	0	t	2023-11-28 15:38:30.478013
523	35	890	0	t	2023-11-28 15:38:30.478017
524	35	36	0	t	2023-11-28 15:38:30.478021
525	35	64	0	t	2023-11-28 15:38:30.478024
526	35	377	0	t	2023-11-28 15:38:30.478028
527	35	127	0	t	2023-11-28 15:38:30.478044
528	35	1006	0	t	2023-11-28 15:38:30.478047
529	21	500	5	f	2023-11-28 15:38:30.478059
530	21	294	5	f	2023-11-28 15:38:30.478063
531	21	909	5	f	2023-11-28 15:38:30.478067
532	21	1060	5	f	2023-11-28 15:38:30.478071
533	21	968	5	f	2023-11-28 15:38:30.478075
534	21	433	5	f	2023-11-28 15:38:30.47808
535	21	342	5	f	2023-11-28 15:38:30.478084
536	21	1074	5	f	2023-11-28 15:38:30.478088
537	21	757	4	f	2023-11-28 15:38:30.478092
538	21	270	6	f	2023-11-28 15:38:30.478096
539	21	443	5	f	2023-11-28 15:38:30.4781
540	21	32	9	f	2023-11-28 15:38:30.478103
541	21	635	9	f	2023-11-28 15:38:30.478107
542	21	184	8	f	2023-11-28 15:38:30.478112
543	21	221	5	f	2023-11-28 15:38:30.478116
544	21	840	4	f	2023-11-28 15:38:30.478134
545	21	961	3	f	2023-11-28 15:38:30.478139
546	21	340	4	f	2023-11-28 15:38:30.478151
547	21	345	5	f	2023-11-28 15:38:30.478155
548	21	37	3	f	2023-11-28 15:38:30.478159
549	21	772	5	f	2023-11-28 15:38:30.478163
550	21	407	4	f	2023-11-28 15:38:30.478167
551	21	1043	3	f	2023-11-28 15:38:30.478171
552	21	800	3	f	2023-11-28 15:38:30.478175
553	21	115	10	f	2023-11-28 15:38:30.478179
554	21	719	6	f	2023-11-28 15:38:30.478183
555	21	876	6	f	2023-11-28 15:38:30.478187
556	21	199	4	f	2023-11-28 15:38:30.478192
557	21	574	3	f	2023-11-28 15:38:30.478196
558	21	204	18	f	2023-11-28 15:38:30.4782
559	21	871	7	f	2023-11-28 15:38:30.478204
560	21	558	15	f	2023-11-28 15:38:30.478215
561	21	516	3	f	2023-11-28 15:38:30.478227
562	21	391	5	f	2023-11-28 15:38:30.478231
563	21	7	2	f	2023-11-28 15:38:30.478237
564	21	158	8	f	2023-11-28 15:38:30.478241
565	21	330	8	f	2023-11-28 15:38:30.478245
566	21	354	9	f	2023-11-28 15:38:30.478249
567	21	193	12	f	2023-11-28 15:38:30.478253
568	21	307	4	f	2023-11-28 15:38:30.478257
569	21	518	10	f	2023-11-28 15:38:30.478261
570	21	673	20	f	2023-11-28 15:38:30.478265
571	21	639	5	f	2023-11-28 15:38:30.478296
572	21	187	2	f	2023-11-28 15:38:30.4783
573	21	733	3	f	2023-11-28 15:38:30.478304
574	21	581	3	f	2023-11-28 15:38:30.478308
575	21	1000	2	f	2023-11-28 15:38:30.478312
576	21	915	17	f	2023-11-28 15:38:30.478316
577	21	528	12	f	2023-11-28 15:38:30.47832
578	21	376	8	f	2023-11-28 15:38:30.478324
579	21	201	5	t	2023-11-28 15:38:30.478329
580	21	1020	7	f	2023-11-28 15:38:30.478333
581	21	326	5	f	2023-11-28 15:38:30.478336
582	21	1030	7	f	2023-11-28 15:38:30.47834
583	21	299	8	f	2023-11-28 15:38:30.478344
584	21	490	5	f	2023-11-28 15:38:30.478348
585	21	763	1	f	2023-11-28 15:38:30.478353
586	21	168	9	f	2023-11-28 15:38:30.478359
587	21	165	5	f	2023-11-28 15:38:30.478363
588	21	1065	2	f	2023-11-28 15:38:30.478366
589	21	435	4	f	2023-11-28 15:38:30.47837
590	21	284	4	f	2023-11-28 15:38:30.478374
591	21	617	8	f	2023-11-28 15:38:30.478378
592	21	947	3	f	2023-11-28 15:38:30.478382
593	21	987	4	f	2023-11-28 15:38:30.478386
594	21	373	6	f	2023-11-28 15:38:30.47839
595	21	701	3	f	2023-11-28 15:38:30.478394
596	21	782	6	f	2023-11-28 15:38:30.478398
597	21	981	6	f	2023-11-28 15:38:30.478402
598	21	92	4	f	2023-11-28 15:38:30.478406
599	21	687	14	f	2023-11-28 15:38:30.478411
600	21	1053	7	f	2023-11-28 15:38:30.478415
601	21	685	3	f	2023-11-28 15:38:30.478419
602	21	459	7	f	2023-11-28 15:38:30.478422
603	21	870	0	f	2023-11-28 15:38:30.478426
604	21	96	0	f	2023-11-28 15:38:30.47843
605	21	824	0	f	2023-11-28 15:38:30.478434
606	21	552	0	f	2023-11-28 15:38:30.478446
607	21	648	0	f	2023-11-28 15:38:30.478458
608	21	181	0	f	2023-11-28 15:38:30.478461
609	21	890	0	f	2023-11-28 15:38:30.478465
610	21	36	0	f	2023-11-28 15:38:30.478469
611	21	64	0	f	2023-11-28 15:38:30.478473
612	21	377	0	f	2023-11-28 15:38:30.478477
613	21	127	0	f	2023-11-28 15:38:30.478481
614	21	1006	0	f	2023-11-28 15:38:30.478485
615	36	990	0	t	2023-11-28 15:38:30.478489
616	36	975	2	t	2023-11-28 15:38:30.478493
617	36	848	2	t	2023-11-28 15:38:30.478496
618	36	571	0	t	2023-11-28 15:38:30.4785
619	36	32	9	t	2023-11-28 15:38:30.478504
620	36	45	6	t	2023-11-28 15:38:30.478507
621	36	635	9	t	2023-11-28 15:38:30.478511
622	36	184	8	t	2023-11-28 15:38:30.478515
623	36	221	5	t	2023-11-28 15:38:30.478518
624	36	840	4	t	2023-11-28 15:38:30.478522
625	36	961	3	t	2023-11-28 15:38:30.478525
626	36	340	4	t	2023-11-28 15:38:30.478529
627	36	345	5	f	2023-11-28 15:38:30.478547
628	36	37	3	t	2023-11-28 15:38:30.478551
629	36	772	3	t	2023-11-28 15:38:30.478555
630	36	199	4	t	2023-11-28 15:38:30.47859
631	36	204	18	t	2023-11-28 15:38:30.478594
632	36	871	7	f	2023-11-28 15:38:30.478598
633	36	558	15	t	2023-11-28 15:38:30.478602
634	36	391	5	t	2023-11-28 15:38:30.478606
635	36	7	2	t	2023-11-28 15:38:30.47861
636	36	158	8	t	2023-11-28 15:38:30.478613
637	36	330	8	t	2023-11-28 15:38:30.478617
638	36	354	9	t	2023-11-28 15:38:30.478621
639	36	193	12	t	2023-11-28 15:38:30.478638
640	36	307	4	t	2023-11-28 15:38:30.478642
641	36	518	10	t	2023-11-28 15:38:30.478645
642	36	673	20	t	2023-11-28 15:38:30.478649
643	36	639	5	t	2023-11-28 15:38:30.478653
644	36	438	5	f	2023-11-28 15:38:30.478657
645	36	416	4	t	2023-11-28 15:38:30.478661
646	36	137	5	t	2023-11-28 15:38:30.478665
647	36	486	8	t	2023-11-28 15:38:30.478668
648	36	276	1	t	2023-11-28 15:38:30.478672
649	36	641	2	t	2023-11-28 15:38:30.478679
650	36	187	2	t	2023-11-28 15:38:30.478682
651	36	733	3	t	2023-11-28 15:38:30.478686
652	36	581	3	t	2023-11-28 15:38:30.47869
653	36	864	5	t	2023-11-28 15:38:30.478693
654	36	997	2	t	2023-11-28 15:38:30.478697
655	36	254	3	t	2023-11-28 15:38:30.478702
656	36	1054	3	t	2023-11-28 15:38:30.478706
657	36	1000	2	t	2023-11-28 15:38:30.47871
658	36	190	1	t	2023-11-28 15:38:30.478713
659	36	182	2	t	2023-11-28 15:38:30.478717
660	36	258	1	t	2023-11-28 15:38:30.478721
661	36	620	2	t	2023-11-28 15:38:30.478724
662	36	915	17	t	2023-11-28 15:38:30.478728
663	36	477	6	t	2023-11-28 15:38:30.478732
664	36	1030	7	t	2023-11-28 15:38:30.478736
665	36	299	8	f	2023-11-28 15:38:30.478739
666	36	763	1	t	2023-11-28 15:38:30.478743
667	36	358	2	t	2023-11-28 15:38:30.478747
668	36	168	9	t	2023-11-28 15:38:30.47875
669	36	165	5	t	2023-11-28 15:38:30.478754
670	36	1065	2	t	2023-11-28 15:38:30.478758
671	36	435	4	t	2023-11-28 15:38:30.478761
672	36	617	8	t	2023-11-28 15:38:30.478765
673	36	947	3	t	2023-11-28 15:38:30.478769
674	36	987	4	t	2023-11-28 15:38:30.478772
675	36	373	6	f	2023-11-28 15:38:30.478776
676	36	687	14	f	2023-11-28 15:38:30.478779
677	36	707	7	t	2023-11-28 15:38:30.478783
678	36	395	13	t	2023-11-28 15:38:30.478787
679	36	459	7	t	2023-11-28 15:38:30.478791
680	36	153	3	t	2023-11-28 15:38:30.478794
681	36	859	4	t	2023-11-28 15:38:30.478798
682	36	202	3	t	2023-11-28 15:38:30.478802
683	36	870	0	f	2023-11-28 15:38:30.478818
684	36	96	0	f	2023-11-28 15:38:30.478822
685	36	824	0	f	2023-11-28 15:38:30.478826
686	36	552	0	f	2023-11-28 15:38:30.478829
687	36	648	0	f	2023-11-28 15:38:30.478833
688	36	181	0	f	2023-11-28 15:38:30.478837
689	36	890	0	f	2023-11-28 15:38:30.47884
690	36	36	0	f	2023-11-28 15:38:30.478844
691	36	64	0	f	2023-11-28 15:38:30.478848
692	36	377	0	f	2023-11-28 15:38:30.478851
693	36	127	0	f	2023-11-28 15:38:30.478855
694	36	1006	0	f	2023-11-28 15:38:30.478859
695	34	990	0	t	2023-11-28 15:38:30.478863
696	34	975	2	f	2023-11-28 15:38:30.478867
697	34	848	2	f	2023-11-28 15:38:30.478871
698	34	571	0	t	2023-11-28 15:38:30.478894
699	34	32	9	f	2023-11-28 15:38:30.478898
700	34	446	1	t	2023-11-28 15:38:30.478902
701	34	635	9	t	2023-11-28 15:38:30.478906
702	34	184	8	t	2023-11-28 15:38:30.47891
703	34	221	5	f	2023-11-28 15:38:30.478913
704	34	840	4	t	2023-11-28 15:38:30.478917
705	34	115	10	t	2023-11-28 15:38:30.478921
706	34	876	6	t	2023-11-28 15:38:30.478925
707	34	204	18	f	2023-11-28 15:38:30.478929
708	34	871	7	f	2023-11-28 15:38:30.478932
709	34	558	15	f	2023-11-28 15:38:30.478936
710	34	391	5	t	2023-11-28 15:38:30.478941
711	34	158	8	t	2023-11-28 15:38:30.478945
712	34	971	5	t	2023-11-28 15:38:30.478949
713	34	61	3	t	2023-11-28 15:38:30.478953
714	34	585	4	t	2023-11-28 15:38:30.478957
715	34	193	12	t	2023-11-28 15:38:30.478961
716	34	915	17	f	2023-11-28 15:38:30.478965
717	34	376	8	f	2023-11-28 15:38:30.478968
718	34	326	5	f	2023-11-28 15:38:30.478973
719	34	1030	7	f	2023-11-28 15:38:30.478976
720	34	299	8	f	2023-11-28 15:38:30.47898
721	34	763	1	t	2023-11-28 15:38:30.478984
722	34	168	9	f	2023-11-28 15:38:30.478987
723	34	1065	2	t	2023-11-28 15:38:30.478991
724	34	687	14	f	2023-11-28 15:38:30.478995
725	34	1053	7	t	2023-11-28 15:38:30.478999
726	34	459	7	t	2023-11-28 15:38:30.479002
727	34	153	3	t	2023-11-28 15:38:30.479006
728	34	870	0	f	2023-11-28 15:38:30.47901
729	34	96	0	f	2023-11-28 15:38:30.479014
730	34	824	0	f	2023-11-28 15:38:30.479018
731	34	552	0	f	2023-11-28 15:38:30.479021
732	34	648	0	f	2023-11-28 15:38:30.479025
733	34	181	0	f	2023-11-28 15:38:30.479034
734	34	890	0	f	2023-11-28 15:38:30.479038
735	34	36	0	f	2023-11-28 15:38:30.479042
736	34	64	0	f	2023-11-28 15:38:30.479045
737	34	377	0	f	2023-11-28 15:38:30.479049
738	34	127	0	f	2023-11-28 15:38:30.479065
739	34	1006	0	f	2023-11-28 15:38:30.479069
740	33	990	0	t	2023-11-28 15:38:30.479073
741	33	975	2	t	2023-11-28 15:38:30.479077
742	33	848	2	t	2023-11-28 15:38:30.479081
743	33	571	0	t	2023-11-28 15:38:30.479084
744	33	32	9	t	2023-11-28 15:38:30.479088
745	33	115	10	t	2023-11-28 15:38:30.479092
746	33	199	4	t	2023-11-28 15:38:30.479096
747	33	204	18	t	2023-11-28 15:38:30.4791
748	33	871	7	t	2023-11-28 15:38:30.479104
749	33	558	15	f	2023-11-28 15:38:30.479108
750	33	664	4	t	2023-11-28 15:38:30.479111
751	33	391	5	t	2023-11-28 15:38:30.479115
752	33	158	8	t	2023-11-28 15:38:30.479119
753	33	915	17	t	2023-11-28 15:38:30.479122
754	33	376	8	f	2023-11-28 15:38:30.479126
755	33	523	7	f	2023-11-28 15:38:30.47913
756	33	1030	7	f	2023-11-28 15:38:30.479133
757	33	299	8	t	2023-11-28 15:38:30.479137
758	33	168	9	f	2023-11-28 15:38:30.479141
759	33	1065	2	t	2023-11-28 15:38:30.479144
760	33	284	4	t	2023-11-28 15:38:30.479148
761	33	782	6	t	2023-11-28 15:38:30.479152
762	33	981	6	t	2023-11-28 15:38:30.479156
763	33	92	4	t	2023-11-28 15:38:30.479159
764	33	687	14	t	2023-11-28 15:38:30.479163
765	33	1053	7	f	2023-11-28 15:38:30.479167
766	33	236	5	t	2023-11-28 15:38:30.479172
767	33	459	7	t	2023-11-28 15:38:30.479176
768	33	870	0	t	2023-11-28 15:38:30.479179
769	33	96	0	f	2023-11-28 15:38:30.479183
770	33	824	0	f	2023-11-28 15:38:30.479187
771	33	552	0	f	2023-11-28 15:38:30.47919
772	33	648	0	f	2023-11-28 15:38:30.479194
773	33	181	0	f	2023-11-28 15:38:30.479198
774	33	890	0	f	2023-11-28 15:38:30.479201
775	33	36	0	f	2023-11-28 15:38:30.479285
776	33	64	0	f	2023-11-28 15:38:30.47929
777	33	377	0	f	2023-11-28 15:38:30.479294
778	33	127	0	f	2023-11-28 15:38:30.479297
779	33	1006	0	f	2023-11-28 15:38:30.479301
780	32	990	0	t	2023-11-28 15:38:30.479305
781	32	975	2	t	2023-11-28 15:38:30.479309
782	32	848	2	t	2023-11-28 15:38:30.479313
783	32	571	0	t	2023-11-28 15:38:30.479317
784	32	765	0	t	2023-11-28 15:38:30.479321
785	32	32	9	t	2023-11-28 15:38:30.479324
786	32	115	10	t	2023-11-28 15:38:30.479328
787	32	719	6	t	2023-11-28 15:38:30.47936
788	32	199	4	t	2023-11-28 15:38:30.479364
789	32	204	18	t	2023-11-28 15:38:30.479383
790	32	871	7	t	2023-11-28 15:38:30.479387
791	32	558	15	t	2023-11-28 15:38:30.479391
792	32	664	4	t	2023-11-28 15:38:30.479395
793	32	391	5	t	2023-11-28 15:38:30.479398
794	32	158	8	t	2023-11-28 15:38:30.479402
795	32	915	17	t	2023-11-28 15:38:30.479406
796	32	251	10	t	2023-11-28 15:38:30.47941
797	32	376	8	t	2023-11-28 15:38:30.479413
798	32	523	7	t	2023-11-28 15:38:30.479417
799	32	867	4	t	2023-11-28 15:38:30.479421
800	32	1020	7	f	2023-11-28 15:38:30.479425
801	32	477	6	t	2023-11-28 15:38:30.479428
802	32	326	5	t	2023-11-28 15:38:30.479432
803	32	1030	7	t	2023-11-28 15:38:30.479436
804	32	299	8	f	2023-11-28 15:38:30.47944
805	32	490	5	t	2023-11-28 15:38:30.479443
806	32	168	9	t	2023-11-28 15:38:30.479448
807	32	165	5	t	2023-11-28 15:38:30.479452
808	32	1065	2	t	2023-11-28 15:38:30.479456
809	32	284	4	t	2023-11-28 15:38:30.47946
810	32	947	3	t	2023-11-28 15:38:30.479463
811	32	93	4	t	2023-11-28 15:38:30.479467
812	32	1012	3	f	2023-11-28 15:38:30.479471
813	32	373	6	f	2023-11-28 15:38:30.479475
814	32	782	6	t	2023-11-28 15:38:30.479478
815	32	981	6	t	2023-11-28 15:38:30.479482
816	32	92	4	t	2023-11-28 15:38:30.479492
817	32	687	14	t	2023-11-28 15:38:30.479495
818	32	1053	7	t	2023-11-28 15:38:30.479499
819	32	236	5	t	2023-11-28 15:38:30.479503
820	32	459	7	t	2023-11-28 15:38:30.479507
821	32	153	3	t	2023-11-28 15:38:30.47951
822	32	870	0	t	2023-11-28 15:38:30.479514
823	32	96	0	t	2023-11-28 15:38:30.479518
824	32	824	0	t	2023-11-28 15:38:30.479521
825	32	552	0	t	2023-11-28 15:38:30.479525
826	32	648	0	t	2023-11-28 15:38:30.479529
827	32	181	0	t	2023-11-28 15:38:30.479533
828	32	890	0	t	2023-11-28 15:38:30.479542
829	32	36	0	t	2023-11-28 15:38:30.479546
830	32	64	0	t	2023-11-28 15:38:30.47955
831	32	377	0	t	2023-11-28 15:38:30.479554
832	32	127	0	t	2023-11-28 15:38:30.479557
833	32	1006	0	t	2023-11-28 15:38:30.479561
\.


--
-- Data for Name: training_record; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.training_record (id, doc_id, risk_level, revision, userid, run_date, needs_verification, trained, verified, verified_by, current_escalation_level, date_verified, old_revision, training_complete_date) FROM stdin;
863	1000	1	4	32	2024-04-18 10:46:05.211511+00	t	t	f	0	0	\N	0	2024-04-18 10:46:05.211511
823	1187	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
909	486	0	5	21	2024-04-18 15:16:28.123032+00	f	t	f	0	0	\N	0	2024-04-18 15:16:28.123032
937	595	0	2	35	2024-04-18 15:25:53.381183+00	f	t	f	0	0	\N	2	2024-04-18 15:25:53.381183
952	574	0	5	32	\N	f	t	f	0	0	\N	0	2024-04-29 13:15:35.309933
122	70	0	18	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
700	70	0	18	93	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
614	70	0	18	90	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
570	70	0	18	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
490	70	0	18	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
380	70	0	18	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
264	70	0	18	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
219	70	0	18	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
171	70	0	18	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
852	146	0	8	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
806	146	0	8	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
744	146	0	8	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
584	146	0	8	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
402	146	0	8	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
188	146	0	8	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
137	146	0	8	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
54	146	0	8	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	7	2024-04-07 13:56:01.924068
493	152	0	2	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
386	152	0	2	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
267	152	0	2	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
126	152	0	2	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
474	271	0	3	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
795	468	0	11	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	10	2024-04-07 13:56:01.924068
838	469	0	6	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
796	469	0	6	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
767	469	0	6	99	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
864	1006	1	4	33	2024-04-18 11:06:32.660686+00	t	t	f	0	0	\N	0	2024-04-18 11:06:32.660686
910	486	0	5	21	2024-04-18 15:16:46.137914+00	f	t	f	0	0	\N	0	2024-04-18 15:16:46.137914
938	573	0	3	124	2024-04-18 15:50:30.148458+00	f	t	f	0	0	\N	0	2024-04-18 15:50:30.148458
186	65	0	19	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
735	469	0	6	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
702	469	0	6	93	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
673	469	0	6	92	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
646	469	0	6	91	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
616	469	0	6	90	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
573	469	0	6	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
494	469	0	6	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
387	469	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
268	469	0	6	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
221	469	0	6	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
174	469	0	6	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
127	469	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
47	469	0	6	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
839	470	0	9	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
797	470	0	9	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
768	470	0	9	99	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
736	470	0	9	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
703	470	0	9	93	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
674	470	0	9	92	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
647	470	0	9	91	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
617	470	0	9	90	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
574	470	0	9	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
495	470	0	9	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
388	470	0	9	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
269	470	0	9	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
222	470	0	9	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
175	470	0	9	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
128	470	0	9	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
48	470	0	9	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
840	472	0	3	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
798	472	0	3	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
737	472	0	3	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
575	472	0	3	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
496	472	0	3	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
822	1186	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
363	474	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
865	470	0	9	35	2024-04-18 14:46:12.470731+00	f	t	f	0	0	\N	9	2024-04-18 14:46:12.470731
911	470	0	9	35	2024-04-18 15:17:19.175701+00	f	t	f	0	0	\N	9	2024-04-18 15:17:19.175701
912	470	0	9	35	2024-04-18 15:17:19.837663+00	f	t	f	0	0	\N	9	2024-04-18 15:17:19.837663
913	595	0	2	35	2024-04-18 15:17:23.799765+00	f	t	f	0	0	\N	0	2024-04-18 15:17:23.799765
939	573	0	3	32	2024-04-18 15:53:39.808405+00	f	t	f	0	0	\N	0	2024-04-18 15:53:39.808405
389	472	0	3	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
270	472	0	3	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
223	472	0	3	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
176	472	0	3	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
49	472	0	3	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
841	473	0	3	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
799	473	0	3	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
738	473	0	3	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
576	473	0	3	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
497	473	0	3	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
390	473	0	3	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
271	473	0	3	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
224	473	0	3	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
177	473	0	3	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
50	473	0	3	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
526	484	0	4	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
290	484	0	4	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
62	484	0	4	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
278	65	0	19	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
230	65	0	19	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
828	486	0	5	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
790	486	0	5	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
730	486	0	5	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
215	486	0	5	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
164	486	0	5	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
40	486	0	5	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
848	541	0	6	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
581	541	0	6	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
397	541	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
276	541	0	6	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
184	541	0	6	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
134	541	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
293	1500	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
65	1500	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
294	1501	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
66	1501	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
295	1502	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
67	1502	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
296	1503	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
68	1503	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
297	1504	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
69	1504	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
298	1505	0	6	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
70	1505	0	6	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	5	2024-04-07 13:56:01.924068
439	1513	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
310	1513	0	5	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
81	1513	0	5	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
440	1515	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
311	1515	0	5	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
82	1515	0	5	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
442	1517	0	4	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
313	1517	0	4	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
84	1517	0	4	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
444	1518	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
443	1518	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
316	1519	0	5	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
87	1519	0	5	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
317	1520	0	4	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
88	1520	0	4	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
285	505	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
231	855	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
866	573	0	3	35	2024-04-18 14:46:29.064343+00	f	t	f	0	0	\N	3	2024-04-18 14:46:29.064343
914	573	0	3	21	2024-04-18 15:18:34.352332+00	f	t	f	0	0	\N	3	2024-04-18 15:18:34.352332
940	573	0	3	36	2024-04-19 12:02:42.127563+00	f	t	f	0	0	\N	0	2024-04-19 12:02:42.127563
459	548	0	21	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	20	2024-04-07 13:56:01.924068
339	548	0	21	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	20	2024-04-07 13:56:01.924068
103	548	0	21	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	20	2024-04-07 13:56:01.924068
549	570	0	5	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
461	570	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
342	570	0	5	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
104	570	0	5	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
400	572	0	4	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
814	573	0	3	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
777	573	0	3	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
751	573	0	3	99	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
713	573	0	3	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
680	573	0	3	93	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
656	573	0	3	92	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
629	573	0	3	91	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
595	573	0	3	90	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
528	573	0	3	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
432	573	0	3	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
292	573	0	3	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
241	573	0	3	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
201	573	0	3	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
150	573	0	3	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
64	573	0	3	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
27	573	0	3	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	2	2024-04-07 13:56:01.924068
471	574	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
357	574	0	5	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
108	574	0	5	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
809	575	0	4	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
522	575	0	4	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
429	575	0	4	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
284	575	0	4	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
145	575	0	4	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
58	575	0	4	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
485	576	0	5	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
117	576	0	5	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
810	578	0	5	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
286	578	0	5	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
146	578	0	5	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	4	2024-04-07 13:56:01.924068
564	579	0	2	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
867	470	0	9	35	2024-04-18 15:09:41.906519+00	f	t	f	0	0	\N	9	2024-04-18 15:09:41.906519
868	470	0	9	35	2024-04-18 15:10:49.888606+00	f	t	f	0	0	\N	9	2024-04-18 15:10:49.888606
869	470	0	9	35	2024-04-18 15:10:50.071821+00	f	t	f	0	0	\N	9	2024-04-18 15:10:50.071821
870	470	0	9	35	2024-04-18 15:10:50.283514+00	f	t	f	0	0	\N	9	2024-04-18 15:10:50.283514
873	470	0	9	35	2024-04-18 15:10:53.234157+00	f	t	f	0	0	\N	9	2024-04-18 15:10:53.234157
874	470	0	9	35	2024-04-18 15:10:54.709379+00	f	t	f	0	0	\N	9	2024-04-18 15:10:54.709379
875	470	0	9	35	2024-04-18 15:10:55.958818+00	f	t	f	0	0	\N	9	2024-04-18 15:10:55.958818
876	470	0	9	35	2024-04-18 15:10:56.396189+00	f	t	f	0	0	\N	9	2024-04-18 15:10:56.396189
877	470	0	9	35	2024-04-18 15:10:56.559549+00	f	t	f	0	0	\N	9	2024-04-18 15:10:56.559549
878	470	0	9	35	2024-04-18 15:10:56.935948+00	f	t	f	0	0	\N	9	2024-04-18 15:10:56.935948
915	573	0	3	21	2024-04-18 15:18:50.879699+00	f	t	f	0	0	\N	3	2024-04-18 15:18:50.879699
916	573	0	3	21	2024-04-18 15:18:52.186828+00	f	t	f	0	0	\N	3	2024-04-18 15:18:52.186828
941	1078	0	2	33	2024-04-29 09:14:04.015238+00	f	t	f	0	0	\N	0	2024-04-29 09:14:04.015238
505	620	0	2	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
412	620	0	2	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	1	2024-04-07 13:56:01.924068
855	1109	0	7	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
587	1109	0	7	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
405	1109	0	7	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
233	1109	0	7	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
191	1109	0	7	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
139	1109	0	7	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
856	1110	0	7	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
588	1110	0	7	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
406	1110	0	7	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
234	1110	0	7	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
192	1110	0	7	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
140	1110	0	7	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	6	2024-04-07 13:56:01.924068
871	470	0	9	35	2024-04-18 15:10:51.658311+00	f	t	f	0	0	\N	9	2024-04-18 15:10:51.658311
872	470	0	9	35	2024-04-18 15:10:52.915959+00	f	t	f	0	0	\N	9	2024-04-18 15:10:52.915959
917	1078	0	2	32	2024-04-18 15:19:06.478596+00	f	t	f	0	0	\N	0	2024-04-18 15:19:06.478596
942	1052	0	1	33	2024-04-29 09:19:44.465836+00	f	t	f	0	0	\N	0	2024-04-29 09:19:44.465836
583	65	0	19	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
568	1112	0	9	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
488	1112	0	9	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
378	1112	0	9	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
120	1112	0	9	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	8	2024-04-07 13:56:01.924068
834	1113	0	10	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
793	1113	0	10	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
766	1113	0	10	99	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
732	1113	0	10	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
699	1113	0	10	93	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
671	1113	0	10	92	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
644	1113	0	10	91	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
613	1113	0	10	90	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
569	1113	0	10	56	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
489	1113	0	10	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
379	1113	0	10	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
263	1113	0	10	34	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
218	1113	0	10	33	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
170	1113	0	10	32	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
121	1113	0	10	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
44	1113	0	10	2	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	9	2024-04-07 13:56:01.924068
355	1124	0	4	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	3	2024-04-07 13:56:01.924068
661	1184	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
879	470	0	9	35	2024-04-18 15:11:15.964297+00	f	t	f	0	0	\N	9	2024-04-18 15:11:15.964297
880	1002	1	4	32	2024-04-18 15:11:33.406327+00	t	t	f	0	0	\N	0	2024-04-18 15:11:33.406327
881	1000	1	4	32	2024-04-18 15:11:37.246227+00	t	t	f	0	0	\N	4	2024-04-18 15:11:37.246227
918	574	0	5	21	2024-04-18 15:19:09.889047+00	f	t	f	0	0	\N	5	2024-04-18 15:19:09.889047
943	1002	1	4	33	2024-04-29 09:54:28.238669+00	t	t	f	0	0	\N	0	2024-04-29 09:54:28.238669
753	1180	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
477	600	0	1	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
273	498	0	8	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
550	581	0	5	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
394	517	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
51	485	0	7	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
272	485	0	7	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
781	1183	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
190	1108	0	4	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
350	604	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
758	1185	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
539	1184	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
554	593	0	5	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
424	489	0	13	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	13	2024-01-01 00:00:00
670	1111	0	6	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
849	562	0	15	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
509	1104	0	7	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
663	1186	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
770	498	0	8	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
156	1184	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
764	1191	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
556	613	0	1	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
641	1191	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
475	474	0	3	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
638	1188	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
791	914	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
775	487	0	7	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
282	481	0	14	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
261	638	0	3	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
42	914	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
189	1070	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
161	1189	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
257	1189	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
113	601	0	2	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
43	1111	0	6	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
632	1182	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
658	1181	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
802	517	0	7	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
578	498	0	8	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
695	598	0	8	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
187	855	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
349	602	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
160	1188	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
728	1190	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
824	1188	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
508	489	0	13	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	13	2024-01-01 00:00:00
331	1191	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
599	1182	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
769	485	0	7	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
677	517	0	7	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
366	478	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
91	1181	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
29	1181	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
698	1111	0	6	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
181	517	0	7	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
96	1186	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
466	598	0	8	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
844	500	0	10	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
35	1187	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
631	1181	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
107	591	0	9	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
446	1181	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
749	487	0	7	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
512	1182	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
340	552	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
356	1134	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
523	505	0	2	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
391	485	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
487	1111	0	6	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
414	1105	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
458	544	0	12	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
640	1190	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
368	601	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
538	1183	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
166	563	0	5	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
344	583	0	10	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
745	73	0	7	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
142	1119	0	3	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
152	1180	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
410	1107	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
428	1104	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
637	1187	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
792	1111	0	6	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
651	562	0	15	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
381	71	0	12	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
38	1190	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
359	912	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
597	1180	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
548	557	0	3	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
453	1188	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
217	914	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
787	1189	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
709	73	0	7	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
501	562	0	15	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
750	488	0	5	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
545	1190	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
727	1189	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
182	539	0	5	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
779	1181	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
110	270	0	3	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
557	1121	0	4	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
563	638	0	3	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
143	481	0	14	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
718	1180	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
667	1190	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
668	1191	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
229	562	0	15	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
481	622	0	3	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
559	24	0	3	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
788	1190	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
52	498	0	8	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
607	1190	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
633	1183	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
258	1190	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
853	1070	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
341	560	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
483	638	0	3	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
450	1185	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
762	1189	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
712	488	0	5	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
513	1183	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
473	270	0	3	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
320	1180	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
679	938	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
375	859	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
115	622	0	3	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
97	1187	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
882	470	0	9	35	2024-04-18 15:13:24.472118+00	f	t	f	0	0	\N	9	2024-04-18 15:13:24.472118
813	15	1	6	102	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	6	2020-01-01 00:00:00.001
527	15	1	6	56	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	6	2020-01-01 00:00:00.001
291	15	1	6	35	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	6	2020-01-01 00:00:00.001
149	15	1	6	32	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	6	2020-01-01 00:00:00.001
63	15	1	6	21	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	6	2020-01-01 00:00:00.001
883	470	0	9	35	2024-04-18 15:13:24.521287+00	f	t	f	0	0	\N	9	2024-04-18 15:13:24.521287
884	470	0	9	35	2024-04-18 15:13:24.650232+00	f	t	f	0	0	\N	9	2024-04-18 15:13:24.650232
885	470	0	9	35	2024-04-18 15:13:24.721713+00	f	t	f	0	0	\N	9	2024-04-18 15:13:24.721713
886	470	0	9	35	2024-04-18 15:13:24.83832+00	f	t	f	0	0	\N	9	2024-04-18 15:13:24.83832
887	470	0	9	35	2024-04-18 15:13:25.522554+00	f	t	f	0	0	\N	9	2024-04-18 15:13:25.522554
888	470	0	9	35	2024-04-18 15:13:25.592161+00	f	t	f	0	0	\N	9	2024-04-18 15:13:25.592161
889	470	0	9	35	2024-04-18 15:13:26.000013+00	f	t	f	0	0	\N	9	2024-04-18 15:13:26.000013
890	470	0	9	35	2024-04-18 15:13:26.171643+00	f	t	f	0	0	\N	9	2024-04-18 15:13:26.171643
891	470	0	9	35	2024-04-18 15:13:26.375497+00	f	t	f	0	0	\N	9	2024-04-18 15:13:26.375497
892	470	0	9	35	2024-04-18 15:13:26.614846+00	f	t	f	0	0	\N	9	2024-04-18 15:13:26.614846
893	470	0	9	35	2024-04-18 15:13:26.740611+00	f	t	f	0	0	\N	9	2024-04-18 15:13:26.740611
894	470	0	9	35	2024-04-18 15:13:28.465326+00	f	t	f	0	0	\N	9	2024-04-18 15:13:28.465326
919	470	0	9	32	2024-04-18 15:19:13.035016+00	f	t	f	0	0	\N	9	2024-04-18 15:19:13.035016
944	1002	1	4	33	2024-04-29 09:55:10.539129+00	t	t	f	0	0	\N	0	2024-04-29 09:55:10.539129
945	1002	1	4	33	2024-04-29 09:55:10.977311+00	t	t	f	0	0	\N	0	2024-04-29 09:55:10.977311
850	65	0	19	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
805	65	0	19	101	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
772	65	0	19	99	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
743	65	0	19	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
708	65	0	19	93	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
623	65	0	19	90	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
502	65	0	19	36	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
399	65	0	19	35	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
136	65	0	19	21	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	18	2024-04-07 13:56:01.924068
835	70	0	18	102	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
733	70	0	18	98	2024-04-07 13:56:01.924068+00	f	f	f	0	0	\N	17	2024-04-07 13:56:01.924068
652	164	0	2	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
858	144	0	4	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
417	179	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
173	148	0	8	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
125	148	0	8	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
794	148	0	8	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
57	245	0	5	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
266	148	0	8	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
220	148	0	8	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
747	179	0	4	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
193	73	0	7	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
645	148	0	8	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
382	74	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
729	1191	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
408	144	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
59	16	0	4	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
782	1184	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
589	144	0	4	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
689	1187	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
555	605	0	3	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
329	1189	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
682	1180	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
567	1111	0	6	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
630	1180	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
821	1185	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
401	855	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
816	1180	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
659	1182	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
153	1181	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
676	498	0	8	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
739	485	0	7	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
778	1180	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
279	855	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
507	481	0	14	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
419	208	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
741	517	0	7	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
543	1188	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
664	1187	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
565	859	0	4	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
566	914	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
551	583	0	10	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
457	538	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
592	481	0	14	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
95	1185	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
281	179	0	4	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
687	1185	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
259	1191	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
553	591	0	9	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
519	1189	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
172	147	0	6	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
409	625	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
30	1182	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
521	1191	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
622	562	0	15	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
324	1184	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
774	481	0	14	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
249	1181	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
398	562	0	15	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
255	1187	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
635	1185	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
165	638	0	3	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
56	73	0	7	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
639	1189	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
209	1186	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
820	1184	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
620	500	0	10	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
34	1186	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
138	1108	0	4	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
418	185	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
205	1182	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
761	1188	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
407	73	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
325	1185	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
90	1180	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
783	1185	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
484	563	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
334	329	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
558	1129	0	6	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
144	487	0	7	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
540	1185	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
168	914	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
690	1188	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
598	1181	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
393	500	0	10	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
287	16	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
464	590	0	8	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
167	859	0	4	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
498	485	0	7	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
862	488	0	5	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
277	562	0	15	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
469	613	0	1	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
683	1181	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
118	859	0	4	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
608	1191	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
662	1185	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
194	144	0	4	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
463	583	0	10	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
99	1189	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
476	478	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
367	600	0	1	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
726	1188	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
374	563	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
41	563	0	5	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
206	1183	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
46	148	0	8	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
719	1181	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
586	1108	0	4	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
32	1184	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
53	855	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
572	148	0	8	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
756	1183	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
336	538	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
260	544	0	12	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
423	488	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
354	619	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
593	489	0	13	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	13	2024-01-01 00:00:00
479	607	0	3	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
411	537	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
425	1100	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
672	148	0	8	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
154	1182	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
825	1189	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
657	1180	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
731	1111	0	6	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
403	1070	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
256	1188	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
654	487	0	7	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
332	265	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
628	488	0	5	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
675	485	0	7	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
748	481	0	14	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
33	1185	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
696	912	0	3	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
422	487	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
185	562	0	15	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
653	481	0	14	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
130	498	0	8	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
612	1111	0	6	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
486	914	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
625	164	0	2	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
384	148	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
351	605	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
116	563	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
765	1111	0	6	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
552	590	0	8	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
837	148	0	8	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
819	1183	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
826	1190	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
817	1181	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
426	1101	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
364	476	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
462	581	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
491	147	0	6	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
169	1111	0	6	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
734	148	0	8	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
605	1188	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
92	1182	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
345	590	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
541	1186	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
180	500	0	10	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
660	1183	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
236	481	0	14	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
626	481	0	14	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
836	147	0	6	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
197	487	0	7	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
135	562	0	15	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
784	1186	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
454	1189	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
665	1188	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
470	619	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
707	562	0	15	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
711	487	0	7	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
759	1186	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
780	1182	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
482	623	0	4	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
227	517	0	7	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
478	601	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
577	485	0	7	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
280	178	0	3	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
420	216	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
240	483	0	6	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
561	476	0	3	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
328	1188	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
525	483	0	6	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
634	1184	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
845	517	0	7	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
755	1182	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
650	517	0	7	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
196	481	0	14	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
210	1187	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
226	498	0	8	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
843	498	0	8	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
710	481	0	14	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
447	1182	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
859	1105	0	3	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
842	485	0	7	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
61	483	0	6	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
244	1525	0	9	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
602	1185	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
691	1189	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
468	605	0	3	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
697	914	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
721	1183	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
800	485	0	7	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
251	1183	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
204	1181	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
705	498	0	8	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
456	1191	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
531	1525	0	9	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
604	1187	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
427	1103	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
786	1188	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
347	598	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
283	487	0	7	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
807	245	0	5	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
546	1191	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
179	498	0	8	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
624	73	0	7	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
562	623	0	4	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
636	1186	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
686	1184	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
321	1181	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
361	269	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
303	1510	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
105	583	0	10	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
829	638	0	3	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
785	1187	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
643	1111	0	6	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
804	562	0	15	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
472	269	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
537	1182	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
445	1180	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
89	1521	0	3	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
93	1183	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
373	638	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
252	1184	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
31	1183	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
343	581	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
467	602	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
776	488	0	5	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
723	1185	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
327	1187	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
253	1185	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
692	1190	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
109	912	0	3	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
155	1183	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
722	1184	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
133	66	0	7	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
609	538	0	5	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
724	1186	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
416	178	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
195	1105	0	3	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
199	16	0	4	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
372	623	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
369	607	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
441	1516	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
600	1183	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
335	336	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
740	498	0	8	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
603	1186	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
591	245	0	5	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
808	488	0	5	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
383	147	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
301	1508	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
757	1184	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
771	562	0	15	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
827	1191	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
254	1186	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
503	855	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
377	1111	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
78	1526	0	8	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
159	1187	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
250	1182	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
611	912	0	3	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
857	73	0	7	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
619	498	0	8	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
621	517	0	7	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
319	1523	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
517	1187	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
106	590	0	8	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
178	485	0	7	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
129	485	0	7	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
203	1180	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
585	1070	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
789	1191	0	0	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
455	1190	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
346	591	0	9	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
71	1506	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
370	609	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
684	1182	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
773	73	0	7	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
448	1183	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
396	66	0	7	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
861	487	0	7	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
701	147	0	6	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
162	1190	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
511	1181	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
132	539	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
514	1184	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
322	1182	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
582	562	0	15	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
854	1108	0	4	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
330	1190	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
237	487	0	7	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
451	1186	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
262	914	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
323	1183	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
348	599	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
337	543	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
114	609	0	2	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
504	537	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
238	488	0	5	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
112	478	0	2	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
560	474	0	3	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
547	544	0	12	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
818	1182	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
518	1188	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
754	1181	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
289	483	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
124	74	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
452	1187	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
615	147	0	6	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
693	1191	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
830	563	0	5	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
98	1188	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
235	73	0	7	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
601	1184	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
590	537	0	5	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
763	1190	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
119	1111	0	6	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
627	487	0	7	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
306	1525	0	9	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
376	914	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
147	16	0	4	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
480	609	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
860	481	0	14	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
338	544	0	12	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
685	1183	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
358	577	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
79	1527	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
610	598	0	8	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
72	1507	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
535	1180	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
678	73	0	7	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
510	1180	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
579	500	0	10	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	10	2024-01-01 00:00:00
642	914	0	0	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
77	1525	0	9	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
232	1108	0	4	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
725	1187	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
131	517	0	7	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
198	488	0	5	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
212	1189	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
37	1189	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
28	1180	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
832	914	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
404	1108	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
720	1182	0	0	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
746	178	0	3	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
353	613	0	1	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
831	859	0	4	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
515	1185	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
225	485	0	7	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
83	1516	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
706	517	0	7	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
333	267	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
516	1186	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
571	71	0	12	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
666	1189	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
542	1187	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
216	859	0	4	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
395	539	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
45	74	0	5	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
213	1190	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
694	538	0	5	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
274	517	0	7	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
163	1191	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
801	498	0	8	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
833	1111	0	6	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
669	914	0	0	92	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
352	611	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
36	1188	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
362	270	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
102	544	0	12	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
430	505	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
158	1186	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
688	1186	0	0	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
594	1103	0	8	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
460	561	0	4	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
533	1527	0	5	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
499	517	0	7	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
265	69	0	5	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
111	477	0	3	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
851	855	0	0	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
207	1184	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
123	71	0	12	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	12	2024-01-01 00:00:00
326	1186	0	0	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
385	151	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
371	622	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
492	148	0	8	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
655	488	0	5	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
544	1189	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
365	477	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
704	485	0	7	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
157	1185	0	0	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
413	1119	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
606	1189	0	0	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
649	498	0	8	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
308	1527	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
618	485	0	7	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
100	1190	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
183	66	0	7	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
248	1180	0	0	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
421	481	0	14	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	14	2024-01-01 00:00:00
208	1185	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
392	498	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
760	1187	0	0	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
94	1184	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
141	537	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
648	485	0	7	91	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
211	1188	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
580	517	0	7	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
536	1181	0	0	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
465	591	0	9	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
449	1184	0	0	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
520	1190	0	0	37	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
742	562	0	15	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	15	2024-01-01 00:00:00
55	1070	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
846	539	0	5	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
895	1000	1	4	33	2024-04-18 15:14:11.428204+00	t	t	f	0	0	\N	0	2024-04-18 15:14:11.428204
896	1078	0	2	21	2024-04-18 15:14:16.212789+00	f	t	f	0	0	\N	0	2024-04-18 15:14:16.212789
920	470	0	9	35	2024-04-18 15:22:50.89554+00	f	t	f	0	0	\N	9	2024-04-18 15:22:50.89554
946	470	0	9	33	2024-04-29 09:56:20.775541+00	f	t	f	0	0	\N	0	2024-04-29 09:56:20.775541
309	1528	0	4	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
506	22	0	2	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
315	1518	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
307	1526	0	8	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
803	66	0	7	101	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
86	1518	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
246	1527	0	5	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
75	1510	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
534	1528	0	4	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
811	16	0	4	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
228	66	0	7	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
438	1528	0	4	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
101	1191	0	0	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
415	22	0	2	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	2	2024-01-01 00:00:00
214	1191	0	0	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
847	66	0	7	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
716	1525	0	9	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
532	1526	0	8	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
85	1518	0	5	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
302	1509	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
74	1509	0	6	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
897	1078	0	2	21	2024-04-18 15:14:19.248163+00	f	t	f	0	0	\N	0	2024-04-18 15:14:19.248163
898	470	0	9	21	2024-04-18 15:14:19.799275+00	f	t	f	0	0	\N	9	2024-04-18 15:14:19.799275
899	1078	0	2	21	2024-04-18 15:14:21.552523+00	f	t	f	0	0	\N	0	2024-04-18 15:14:21.552523
900	470	0	9	21	2024-04-18 15:14:22.600867+00	f	t	f	0	0	\N	9	2024-04-18 15:14:22.600867
901	1002	1	4	32	2024-04-18 15:14:23.16475+00	t	t	f	0	0	\N	0	2024-04-18 15:14:23.16475
902	1078	0	2	21	2024-04-18 15:14:24.268843+00	f	t	f	0	0	\N	0	2024-04-18 15:14:24.268843
903	470	0	9	21	2024-04-18 15:14:25.392959+00	f	t	f	0	0	\N	9	2024-04-18 15:14:25.392959
921	65	0	19	21	2024-04-18 15:24:07.879413+00	f	t	f	0	0	\N	19	2024-04-18 15:24:07.879413
922	470	0	9	35	2024-04-18 15:24:24.195896+00	f	t	f	0	0	\N	9	2024-04-18 15:24:24.195896
923	470	0	9	35	2024-04-18 15:24:24.320162+00	f	t	f	0	0	\N	9	2024-04-18 15:24:24.320162
947	486	0	5	33	2024-04-29 11:00:58.717311+00	f	t	f	0	0	\N	0	2024-04-29 11:00:58.717311
245	1526	0	8	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
39	1191	0	0	2	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	0	2024-01-01 00:00:00
312	1516	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
300	1507	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
360	24	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
318	1521	0	3	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	3	2024-01-01 00:00:00
275	66	0	7	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
247	1528	0	4	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
435	1525	0	9	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
314	1518	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
431	16	0	4	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
299	1506	0	5	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
436	1526	0	8	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	8	2024-01-01 00:00:00
437	1527	0	5	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	5	2024-01-01 00:00:00
500	66	0	7	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	7	2024-01-01 00:00:00
73	1508	0	4	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
717	1528	0	4	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
904	1002	1	4	32	2024-04-18 15:14:40.97625+00	t	t	f	0	0	\N	0	2024-04-18 15:14:40.97625
905	1052	0	1	32	2024-04-18 15:14:46.665621+00	f	t	f	0	0	\N	0	2024-04-18 15:14:46.665621
924	470	0	9	35	2024-04-18 15:24:24.5785+00	f	t	f	0	0	\N	9	2024-04-18 15:24:24.5785
925	470	0	9	35	2024-04-18 15:24:24.740881+00	f	t	f	0	0	\N	9	2024-04-18 15:24:24.740881
948	573	0	3	33	2024-04-29 11:08:59.891788+00	f	t	f	0	0	\N	0	2024-04-29 11:08:59.891788
906	1052	0	1	32	2024-04-18 15:15:11.326158+00	f	t	f	0	0	\N	1	2024-04-18 15:15:11.326158
907	1078	0	2	32	2024-04-18 15:15:13.706628+00	f	t	f	0	0	\N	0	2024-04-18 15:15:13.706628
926	470	0	9	35	2024-04-18 15:24:24.752981+00	f	t	f	0	0	\N	9	2024-04-18 15:24:24.752981
931	573	0	3	35	2024-04-18 15:24:26.367219+00	f	t	f	0	0	\N	3	2024-04-18 15:24:26.367219
932	574	0	5	35	2024-04-18 15:24:29.286464+00	f	t	f	0	0	\N	5	2024-04-18 15:24:29.286464
933	574	0	5	35	2024-04-18 15:24:35.517604+00	f	t	f	0	0	\N	5	2024-04-18 15:24:35.517604
950	470	0	9	35	2024-04-07 00:06:01+00	f	t	f	0	0	\N	9	2024-04-29 13:11:24.969157
908	1078	0	2	32	2024-04-18 15:15:41.721296+00	f	t	f	0	0	\N	0	2024-04-18 15:15:41.721296
927	486	0	5	35	2024-04-18 15:24:25.343638+00	f	t	f	0	0	\N	0	2024-04-18 15:24:25.343638
928	486	0	5	35	2024-04-18 15:24:25.823292+00	f	t	f	0	0	\N	0	2024-04-18 15:24:25.823292
929	573	0	3	35	2024-04-18 15:24:25.942239+00	f	t	f	0	0	\N	3	2024-04-18 15:24:25.942239
930	573	0	3	35	2024-04-18 15:24:26.179651+00	f	t	f	0	0	\N	3	2024-04-18 15:24:26.179651
934	574	0	5	35	2024-04-18 15:24:44.307364+00	f	t	f	0	0	\N	5	2024-04-18 15:24:44.307364
935	65	0	19	35	2024-04-18 15:24:51.187612+00	f	t	f	0	0	\N	19	2024-04-18 15:24:51.187612
936	1078	0	2	35	2024-04-18 15:25:21.375913+00	f	t	f	0	0	\N	0	2024-04-18 15:25:21.375913
951	486	0	5	32	\N	f	t	f	0	0	\N	0	2024-04-29 13:14:23.560837
529	1532	0	9	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
815	1532	0	9	102	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
242	1532	0	9	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
305	1533	0	6	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
596	1532	0	9	90	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
714	1532	0	9	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
304	1532	0	9	35	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
151	1532	0	9	32	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
433	1532	0	9	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
681	1532	0	9	93	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
243	1534	0	1	34	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
76	1532	0	9	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
80	1528	0	4	21	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	4	2024-01-01 00:00:00
715	1534	0	1	98	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	1	2024-01-01 00:00:00
202	1532	0	9	33	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
752	1532	0	9	99	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	9	2024-01-01 00:00:00
434	1533	0	6	36	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
530	1533	0	6	56	2024-04-07 13:56:01.924068+00	f	t	f	0	0	\N	6	2024-01-01 00:00:00
812	14	1	10	102	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
524	14	1	10	56	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
288	14	1	10	35	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
239	14	1	10	34	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
200	14	1	10	33	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
148	14	1	10	32	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
60	14	1	10	21	2024-04-07 13:56:01.924068+00	t	t	t	0	0	2020-01-01	10	2020-01-01 00:00:00.001
\.


--
-- Data for Name: transaction_log; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.transaction_log (id, transaction_user_id, target_userid, transaction_type_id, transaction_data, date) FROM stdin;
\.


--
-- Data for Name: transaction_type; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.transaction_type (id, type_name, type_text) FROM stdin;
1	email_sent	sent initial email to user
2	email_escalation_1	escalated to level 1
3	email_escalation_2	escalated to level 2
4	email_escalation_3	escalated to level 3
5	email_escalation_4	escalated to level 4
6	email_verification	verification email sent
7	user_trained	user ackowledged training
8	manager_verified	manager verified training for user
9	CREATE_USER	Create NEW User
10	SET_USER_ACTIVE_FALSE	delete user
11	ADD_USER_TO_TEAM	Add User to New Team
12	CREATE_NEW_ROLE	Create a new user team role
13	SET_DOCUMENT_RISK_TO_HIGH	Elevate training level of document
14	ASSIGN_DOCUMENT_TO_ROLE	Assign document to user role
15	CREATE_TEAM	Create a new Team
16	ADD_USER_TO_MANAGER	Add User to Manager
17	DELETE_USER_FROM_MANAGER	Delete User from Manager
18	DELETE_USER_ROLE	REmove a role fro a user
19	ASSIGN_DOCUMENT_TO_ROLE	Add a document to a role
20	REMOVE_DOCUMENT_ROLE_ASSIGNMENT	remove a document from a role
21	REMOVE_USER_FROM_TEAM	 Remove an existing user from a team
\.


--
-- Data for Name: user_jobtitle; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.user_jobtitle (id, user_id, job_title_id) FROM stdin;
0	21	0
1	32	3
2	33	3
3	34	2
4	35	1
5	36	4
10	33	5
12	98	5
13	124	2
26	124	3
30	123	5
32	124	1
35	33	28
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.users (id, username, email_address, firstname, surname, active, is_admin, is_manager, role, primary_title_id) FROM stdin;
106	two trainer	two.trainer@mybinxhealth.com	two	trainer	t	f	f	user	\N
119	Andrew Barnes	Andrew.Barnes@mybinxhealth.com	Andrew	Barnes	t	f	f	user	\N
122	Mickey Mouse	Mickey.Mouse@mybinxhealth.com	Mickey	Mouse	t	f	f	user	\N
124	Doctor Brown	Doctor.Brown@mybinxhealth.com	Doctor	Brown	t	f	f	user	\N
105	one trainer	one.trainer@mybinxhealth.com	one	trainer	f	f	f	user	\N
0	system user		system	user	t	f	f	binxenlightenmentdb	\N
21	Henry Fatoyinbo	henry.fatoyinbo@mybinxhealth.com	Henry	Fatoyinbo	t	f	t	admin	0
22	Laura Kemp	laura.kemp@mybinxhealth.com	Laura	Kemp	t	f	t	user	\N
9	Sheila Mirasolo	sheila.mirasolo@mybinxhealth.com	Sheila	Mirasolo	t	f	t	user	\N
117	Doc Brown	doc.brown@mybinxhealth.com	Doc	Brown	t	f	f	user	\N
120	Christine Barnes	Christine.Barnes@mybinxhealth.com	Christine	Barnes	t	f	f	user	\N
32	Alan Alpert	alan.alpert@mybinxhealth.com	Alan	Alpert	t	f	f	admin	3
33	Sean Barnes	sean.barnes@mybinxhealth.com	Sean	Barnes	t	f	f	admin	3
19	Tim Stewart	tim.stewart@mybinxhealth.com	Tim	Stewart	t	f	t	user	\N
34	Jawaad Bhatti	jawaad.bhatti@mybinxhealth.com	Jawaad	Bhatti	t	f	f	user	2
27	Arman Hossainzadeh	arman.hossainzadeh@mybinxhealth.com	Arman	Hossainzadeh	f	f	f	user	\N
123	Doc Brown	Doc.Brown@mybinxhealth.com	Doc	Brown	f	f	f	user	\N
35	Antony Brown	antony.brown@mybinxhealth.com	Antony	Brown	t	f	f	user	1
4	Paul Buxton	paul.buxton@mybinxhealth.com	Paul	Buxton	t	f	f	user	\N
5	Luke Chess	luke.chess@mybinxhealth.com	Luke	Chess	t	f	f	user	\N
6	Sarah Forster	sarah.forster@mybinxhealth.com	Sarah	Forster	t	f	f	user	\N
7	Jesna Kattil	jesna.kattil@mybinxhealth.com	Jesna	Kattil	t	f	f	user	\N
8	Matt Crowley	matt.crowley@mybinxhealth.com	Matt	Crowley	t	f	f	user	\N
10	Patti Titus	patti.titus@mybinxhealth.com	Patti	Titus	t	f	f	user	\N
11	Gaby Wirth	gaby.wirth@mybinxhealth.com	Gaby	Wirth	t	f	f	user	\N
15	Maggie Lefaivre	maggie.lefaivre@mybinxhealth.com	Maggie	Lefaivre	t	f	f	user	\N
16	Ed Leftin	ed.leftin@mybinxhealth.com	Ed	Leftin	t	f	f	user	\N
26	Victoria Catarau	victoria.catarau@mybinxhealth.com	Victoria	Catarau	t	f	f	user	\N
28	Ian Kelly	ian.kelly@mybinxhealth.com	Ian	Kelly	t	f	f	user	\N
30	Liam Liu	liam.liu@mybinxhealth.com	Liam	Liu	t	f	f	user	\N
37	Alyssa Amidei	alyssa.amidei@mybinxhealth.com	Alyssa	Amidei	t	f	f	user	\N
38	Juliet Coulson	juliet.coulson@mybinxhealth.com	Juliet	Coulson	t	f	f	user	\N
39	Anna Domanska	anna.domanska@mybinxhealth.com	Anna	Domanska	t	f	f	user	\N
40	Evaldas Mel	evaldas.mel@mybinxhealth.com	Evaldas	Mel	t	f	f	user	\N
42	Stephanie Rideout	stephanie.rideout@mybinxhealth.com	Stephanie	Rideout	t	f	f	user	\N
43	Katherine Danaher	katherine.danaher@mybinxhealth.com	Katherine	Danaher	t	f	f	user	\N
44	Matthieu Fabrega	matthieu.fabrega@mybinxhealth.com	Matthieu	Fabrega	t	f	f	user	\N
46	Grace Newman	grace.newman@mybinxhealth.com	Grace	Newman	t	f	f	user	\N
47	Brygida Kulesza-Orlowska	brygida.kulesza-orlowska@mybinxhealth.com	Brygida	Kulesza-Orlowska	t	f	f	user	\N
48	Olivia Steward	olivia.steward@mybinxhealth.com	Olivia	Steward	t	f	f	user	\N
49	Jennifer Araujo	jennifer.araujo@mybinxhealth.com	Jennifer	Araujo	t	f	f	user	\N
50	Jenna Chicoine	jenna.chicoine@mybinxhealth.com	Jenna	Chicoine	t	f	f	user	\N
51	Shirley Freeman	shirley.freeman@mybinxhealth.com	Shirley	Freeman	t	f	f	user	\N
52	Wendy Kivens	wendy.kivens@mybinxhealth.com	Wendy	Kivens	t	f	f	user	\N
53	Paul Rolls	paul.rolls@mybinxhealth.com	Paul	Rolls	t	f	f	user	\N
54	Buck Brady	buck.brady@mybinxhealth.com	Buck	Brady	t	f	f	user	\N
57	Tomos Morris	tomos.morris@mybinxhealth.com	Tomos	Morris	t	f	f	user	\N
58	Calum Rae	calum.rae@mybinxhealth.com	Calum	Rae	t	f	f	user	\N
59	Emma Bird	emma.bird@mybinxhealth.com	Emma	Bird	t	f	f	user	\N
60	Darren Gerrish	darren.gerrish@mybinxhealth.com	Darren	Gerrish	t	f	f	user	\N
61	Justin Lebrocq	justin.lebrocq@mybinxhealth.com	Justin	Lebrocq	t	f	f	user	\N
62	Alex Tsang	alex.tsang@mybinxhealth.com	Alex	Tsang	t	f	f	user	\N
63	Mallory Caron	mallory.caron@mybinxhealth.com	Mallory	Caron	t	f	f	user	\N
64	Chelsea Murphy	chelsea.murphy@mybinxhealth.com	Chelsea	Murphy	t	f	f	user	\N
65	Sasha Carr	sasha.carr@mybinxhealth.com	Sasha	Carr	t	f	f	user	\N
66	Clerveau Toussaint	clerveau.toussaint@mybinxhealth.com	Clerveau	Toussaint	t	f	f	user	\N
36	Ian Moore	ian.moore@mybinxhealth.com	Ian	Moore	t	f	f	user	4
3	Abby Wright	abby.wright@mybinxhealth.com	Abby	Wright	t	f	t	user	\N
17	Pia Olson	pia.olson@mybinxhealth.com	Pia	Olson	t	f	t	user	\N
29	Scott Kerr	scott.kerr@mybinxhealth.com	Scott	Kerr	t	f	t	user	\N
45	Victoria Hall	victoria.hall@mybinxhealth.com	Victoria	Hall	t	f	t	user	\N
31	Camilo Madriz	camilo.madriz@mybinxhealth.com	Camilo	Madriz	t	f	t	user	\N
14	Alex Kramer	alex.kramer@mybinxhealth.com	Alex	Kramer	f	f	t	user	\N
13	Jenna Hanson	jenna.hanson@mybinxhealth.com	Jenna	Hanson	t	f	t	user	\N
2	Sarah Thomas	sarah.thomas@mybinxhealth.com	Sarah	Thomas	t	f	t	user	\N
41	Mike Storm	mike.storm@mybinxhealth.com	Mike	Storm	t	f	t	user	\N
67	Kay Kelly	kay.kelly@mybinxhealth.com	Kay	Kelly	t	f	f	user	\N
69	Ashley Brown	ashley.brown@mybinxhealth.com	Ashley	Brown	t	f	f	user	\N
70	Amber Ralf	amber.ralf@mybinxhealth.com	Amber	Ralf	t	f	f	user	\N
72	Lloyd Peacock	lloyd.peacock@mybinxhealth.com	Lloyd	Peacock	t	f	f	user	\N
73	Karen Schneider	karen.schneider@mybinxhealth.com	Karen	Schneider	t	f	f	user	\N
74	Jj Watson	jj.watson@mybinxhealth.com	Jj	Watson	t	f	f	user	\N
75	Reid Clanton	reid.clanton@mybinxhealth.com	Reid	Clanton	t	f	f	user	\N
76	Rich Dibiase	rich.dibiase@mybinxhealth.com	Rich	Dibiase	t	f	f	user	\N
77	Juan Gutierrez	juan.gutierrez@mybinxhealth.com	Juan	Gutierrez	t	f	f	user	\N
78	Justin Laxton	justin.laxton@mybinxhealth.com	Justin	Laxton	t	f	f	user	\N
79	Erin Mccormick	erin.mccormick@mybinxhealth.com	Erin	Mccormick	t	f	f	user	\N
80	Susan Ocasio	susan.ocasio@mybinxhealth.com	Susan	Ocasio	t	f	f	user	\N
81	Shawna Osborn	shawna.osborn@mybinxhealth.com	Shawna	Osborn	t	f	f	user	\N
82	Cathy Otto	cathy.otto@mybinxhealth.com	Cathy	Otto	t	f	f	user	\N
83	Dori Repuyan	dori.repuyan@mybinxhealth.com	Dori	Repuyan	t	f	f	user	\N
84	Geoffrey Richman	geoffrey.richman@mybinxhealth.com	Geoffrey	Richman	t	f	f	user	\N
85	Pam Villalba	pam.villalba@mybinxhealth.com	Pam	Villalba	t	f	f	user	\N
86	Emily Wiitala	emily.wiitala@mybinxhealth.com	Emily	Wiitala	t	f	f	user	\N
87	Kennedy Daiger	kennedy.daiger@mybinxhealth.com	Kennedy	Daiger	t	f	f	user	\N
88	Gregg Kelley	gregg.kelley@mybinxhealth.com	Gregg	Kelley	t	f	f	user	\N
89	Ellis Lambert	ellis.lambert@mybinxhealth.com	Ellis	Lambert	t	f	f	user	\N
90	Evan Bartlett	evan.bartlett@mybinxhealth.com	Evan	Bartlett	t	f	f	user	\N
91	Rachel Korwek	rachel.korwek@mybinxhealth.com	Rachel	Korwek	t	f	f	user	\N
92	Tracie Medairos	tracie.medairos@mybinxhealth.com	Tracie	Medairos	t	f	f	user	\N
94	Nicole Freeman	nicole.freeman@mybinxhealth.com	Nicole	Freeman	t	f	f	user	\N
96	Monique Doyle	monique.doyle@mybinxhealth.com	Monique	Doyle	t	f	f	user	\N
97	Dustin Johnson	dustin.johnson@mybinxhealth.com	Dustin	Johnson	t	f	f	user	\N
98	Alexia Osei-Dabankah	alexia.osei-dabankah@mybinxhealth.com	Alexia	Osei-Dabankah	t	f	f	user	\N
99	Reno Torres	reno.torres@mybinxhealth.com	Reno	Torres	t	f	f	user	\N
101	Alyssa Luber	alyssa.luber@mybinxhealth.com	Alyssa	Luber	t	f	f	user	\N
118	Jacob Barnes	Jacob.Barnes@mybinxhealth.com	Jacob	Barnes	t	f	f	user	\N
121	Bugs Bunny	Bugs.Bunny@mybinxhealth.com	Bugs	Bunny	t	f	f	user	\N
71	Rose Burt	rose.burt@mybinxhealth.com	Rose	Burt	t	f	t	user	\N
68	Austin Main	austin.main@mybinxhealth.com	Austin	Main	t	f	t	user	\N
95	Misty Woods-Barnett	misty.woods-barnett@mybinxhealth.com	Misty	Woods-Barnett	t	f	t	user	\N
56	Anna Dixon	anna.dixon@mybinxhealth.com	Anna	Dixon	t	f	t	user	10
93	Nasa Suon	nasa.suon@mybinxhealth.com	Nasa	Suon	t	f	t	user	\N
102	Jeff Luber	jeff.luber@mybinxhealth.com	Jeff	Luber	t	f	t	user	\N
100	Kalli Glanz	kalli.glanz@mybinxhealth.com	Kalli	Glanz	t	f	t	user	\N
12	Stella Chistyakov	stella.chistyakov@mybinxhealth.com	Stella	Chistyakov	t	f	t	user	\N
24	Tony Moran	tony.moran@mybinxhealth.com	Tony	Moran	t	f	t	user	\N
25	Ben Reynolds	ben.reynolds@mybinxhealth.com	Ben	Reynolds	t	f	t	user	\N
20	John Dowell	john.dowell@mybinxhealth.com	John	Dowell	t	f	t	user	\N
1	Dan Milano	dan.milano@mybinxhealth.com	Dan	Milano	t	f	t	user	\N
18	Taylor Santos	taylor.santos@mybinxhealth.com	Taylor	Santos	t	f	t	user	\N
55	Jack Crowley	jack.crowley@mybinxhealth.com	Jack	Crowley	t	f	t	user	\N
23	Tim Stewart	tim.stewart@mybinxhealth.com	Tim	Stewart	t	f	t	user	\N
\.


--
-- Data for Name: userstate; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.userstate (id, employee_name, qt9_document_code, revision, title, trained) FROM stdin;
2	Jeff Luber	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
3	Jeff Luber	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
4	Jeff Luber	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
5	Jeff Luber	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
6	Jeff Luber	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
7	Jeff Luber	CO-H&S-P-001	9	Health & Safety Policy	Y
8	Jeff Luber	CO-DES-SOP-029	10	Design and Development Procedure	Y
9	Jeff Luber	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
10	Jeff Luber	CO-DES-SOP-004	4	Software Development Procedure	Y
11	Jeff Luber	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
12	Jeff Luber	CO-QA-SOP-098	7	Document Matrix	Y
13	Jeff Luber	CO-QA-SOP-139	15	Change Management	Y
14	Jeff Luber	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
15	Jeff Luber	CO-QA-SOP-026	5	Use of Sharepoint	Y
16	Jeff Luber	CO-QA-SOP-028	8	Quality Records	Y
17	Jeff Luber	CO-QA-SOP-003	17	Non Conformance Procedure	Y
18	Jeff Luber	CO-QA-SOP-077	10	Supplier Audit Procedure	Y
19	Jeff Luber	CO-QA-SOP-076	8	Product Complaint Handling	Y
20	Jeff Luber	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
21	Jeff Luber	CO-QA-SOP-345	4	Tools for Root Cause Analysis	Y
22	Jeff Luber	CO-QA-SOP-267	7	Post Market Surveillance	N
23	Jeff Luber	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
24	Jeff Luber	CO-QA-SOP-099	5	Deviation procedure	Y
25	Jeff Luber	CO-QA-SOP-093	7	CAPA Procedure	Y
26	Jeff Luber	CO-QA-SOP-012	8	Annual Quality Objectives 	N
27	Jeff Luber	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	Y
28	Jeff Luber	CO-QA-SOP-014	2	Quality Planning Procedure	Y
29	Jeff Luber	CO-QA-POL-021	9	Quality Manual	Y
30	Jeff Luber	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
31	Jeff Luber	CO-HR-POL-007	2	Training Policy	Y
32	Jeff Luber	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
33	Jeff Luber	CO-CA-POL-009	3	Policy for Verification and Validation	Y
34	Jeff Luber	CO-CS-POL-012	4	Policy for Customer Feedback and Device Vigilance	Y
36	Jeff Luber	CO-QA-POL-019	6	Quality Policy	N
37	Jeff Luber	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
38	Jeff Luber	CO-QA-SOP-284	6	FMEA Procedure	Y
39	Jeff Luber	CO-QA-SOP-283	4	Product Risk Management 	Y
40	Jeff Luber	CO-SUP-SOP-068	14	Purchasing SOP	Y
41	Jeff Luber	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
43	Jeff Luber	CO-QA-SOP-043	7	Training Procedure	Y
44	Jeff Luber	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
45	Jeff Luber	CO-IT-POL-022	0	Access Control Policy	Y
46	Jeff Luber	CO-IT-POL-023	0	Asset Management Policy	Y
47	Jeff Luber	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
48	Jeff Luber	CO-IT-POL-025	0	Code of Conduct	Y
49	Jeff Luber	CO-IT-POL-026	0	Cryptography Policy	Y
50	Jeff Luber	CO-IT-POL-027	0	Human Resource Security Policy	Y
51	Jeff Luber	CO-IT-POL-028	0	Information Security Policy	Y
52	Jeff Luber	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
53	Jeff Luber	CO-IT-POL-030	0	Physical Security Policy	Y
54	Jeff Luber	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
55	Jeff Luber	CO-IT-POL-032	0	Risk Management 	Y
56	Jeff Luber	CO-IT-POL-033	0	Third Party Management	Y
57	Anna Dixon	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
58	Anna Dixon	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
59	Anna Dixon	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
60	Anna Dixon	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
61	Anna Dixon	CO-H&S-P-001	9	Health & Safety Policy	Y
62	Anna Dixon	CO-H&S-P-002	6	PAT Policy	Y
63	Anna Dixon	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
64	Anna Dixon	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
65	Anna Dixon	CO-H&S-PRO-003	5	Health and Safety Manual Handling	Y
66	Anna Dixon	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
67	Anna Dixon	CO-DES-SOP-029	10	Design and Development Procedure	Y
68	Anna Dixon	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
69	Anna Dixon	CO-DES-SOP-041	6	Design Review Work Instruction	Y
70	Anna Dixon	CO-DES-SOP-042	3	Creation and maintenance of a Device Master Record	Y
71	Anna Dixon	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
72	Anna Dixon	CO-QA-SOP-139	15	Change Management	Y
73	Anna Dixon	CO-QA-SOP-026	5	Use of Sharepoint	Y
74	Anna Dixon	CO-QA-SOP-028	8	Quality Records	Y
75	Anna Dixon	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
76	Anna Dixon	CO-LAB-SOP-295	6	Environmental Contamination Monitoring	Y
77	Anna Dixon	CO-LAB-SOP-155	8	Lab book write up	Y
78	Anna Dixon	CO-LAB-SOP-156	9	Lab rough notes	Y
79	Anna Dixon	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
80	Anna Dixon	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	Y
81	Anna Dixon	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	Y
82	Anna Dixon	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	Y
83	Anna Dixon	CO-LAB-SOP-288	4	Assessment of Potentiostat Performance	Y
1	Employee Name	QT9 Document Code	Revision	Title	N
84	Anna Dixon	CO-LAB-SOP-158	5	Use of NanoDrop SP2000 Spectrophotometer for quantifying nucleic acid and protein samples	N
85	Anna Dixon	CO-LAB-SOP-149	5	Introducing New Laboratory Equipment	N
86	Anna Dixon	CO-LAB-SOP-135	3	Use and Completion of MFG documents	Y
87	Anna Dixon	CO-LAB-SOP-170	3	Rapid PCR Rig Work Instructions	Y
88	Anna Dixon	CO-LAB-SOP-178	1	Signal Analyser	Y
89	Anna Dixon	CO-CA-SOP-081	2	Collection of Human samples for QA purposes	Y
90	Anna Dixon	CO-QA-SOP-003	17	Non Conformance Procedure	N
91	Anna Dixon	CO-QA-SOP-004	12	Internal Audit	N
92	Anna Dixon	CO-QA-SOP-077	10	Supplier Audit Procedure	N
93	Anna Dixon	CO-QA-SOP-076	8	Product Complaint Handling	N
94	Anna Dixon	CO-QA-SOP-345	4	Tools for Root Cause Analysis	N
95	Anna Dixon	CO-QA-SOP-267	7	Post Market Surveillance	N
96	Anna Dixon	CO-QA-SOP-099	5	Deviation procedure	Y
97	Anna Dixon	CO-QA-SOP-093	7	CAPA Procedure	Y
98	Anna Dixon	CO-QA-SOP-012	8	Annual Quality Objectives 	N
99	Anna Dixon	CO-QA-POL-021	9	Quality Manual	Y
100	Anna Dixon	CO-HR-POL-007	2	Training Policy	Y
101	Anna Dixon	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
102	Anna Dixon	CO-QA-POL-020	8	Risk Management Policy	Y
103	Anna Dixon	CO-CA-POL-009	3	Policy for Verification and Validation	N
104	Anna Dixon	CO-QA-POL-019	6	Quality Policy	N
105	Anna Dixon	CO-QA-POL-013	1	Policy for Complaints and Vigilance	Y
106	Anna Dixon	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
107	Anna Dixon	CO-QA-SOP-284	6	FMEA Procedure	Y
108	Anna Dixon	CO-QA-SOP-283	4	Product Risk Management 	Y
109	Anna Dixon	CO-SUP-SOP-068	14	Purchasing SOP	N
110	Anna Dixon	CO-SUP-SOP-072	13	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	Y
111	Anna Dixon	CO-SUP-SOP-280	8	Setting Expiry Dates for Incoming Materials	Y
112	Anna Dixon	CO-QA-SOP-043	7	Training Procedure	Y
113	Anna Dixon	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
114	Anna Dixon	CO-OPS-SOP-188	4	Process Validation	Y
115	Anna Dixon	CO-OPS-SOP-002	3	Planning for Process Validation	Y
116	Anna Dixon	CO-OPS-SOP-032	3	Validation of Automated Equipment and Quality System Software	Y
117	Anna Dixon	CO-OPS-SOP-034	3	Test Method Validation	Y
118	Anna Dixon	CO-IT-POL-022	0	Access Control Policy	N
119	Anna Dixon	CO-IT-POL-023	0	Asset Management Policy	N
120	Anna Dixon	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
121	Anna Dixon	CO-IT-POL-025	0	Code of Conduct	N
122	Anna Dixon	CO-IT-POL-026	0	Cryptography Policy	N
123	Anna Dixon	CO-IT-POL-027	0	Human Resource Security Policy	N
124	Anna Dixon	CO-IT-POL-028	0	Information Security Policy	N
125	Anna Dixon	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
126	Anna Dixon	CO-IT-POL-030	0	Physical Security Policy	N
127	Anna Dixon	CO-IT-POL-031	0	Responsible Disclosure Policy	N
128	Anna Dixon	CO-IT-POL-032	0	Risk Management 	N
129	Anna Dixon	CO-IT-POL-033	0	Third Party Management	N
130	Jack Kaminski	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
131	Jack Kaminski	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
132	Jack Kaminski	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
133	Jack Kaminski	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
134	Jack Kaminski	CO-QA-SOP-098	7	Document Matrix	N
135	Jack Kaminski	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
136	Jack Kaminski	CO-QA-SOP-026	5	Use of Sharepoint	Y
137	Jack Kaminski	CO-QA-SOP-028	8	Quality Records	Y
138	Jack Kaminski	CO-QA-SOP-025	10	Management Review	Y
139	Jack Kaminski	CO-QA-SOP-012	8	Annual Quality Objectives 	N
140	Jack Kaminski	CO-QA-POL-021	9	Quality Manual	N
141	Jack Kaminski	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
142	Jack Kaminski	CO-HR-POL-007	2	Training Policy	Y
143	Jack Kaminski	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
144	Jack Kaminski	CO-QA-POL-019	6	Quality Policy	N
145	Jack Kaminski	CO-SUP-SOP-068	14	Purchasing SOP	N
146	Jack Kaminski	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
148	Jack Kaminski	CO-QA-SOP-043	7	Training Procedure	Y
149	Jack Kaminski	CO-IT-POL-022	0	Access Control Policy	N
150	Jack Kaminski	CO-IT-POL-023	0	Asset Management Policy	N
151	Jack Kaminski	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
152	Jack Kaminski	CO-IT-POL-025	0	Code of Conduct	N
153	Jack Kaminski	CO-IT-POL-026	0	Cryptography Policy	N
154	Jack Kaminski	CO-IT-POL-027	0	Human Resource Security Policy	N
155	Jack Kaminski	CO-IT-POL-028	0	Information Security Policy	N
156	Jack Kaminski	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
157	Jack Kaminski	CO-IT-POL-030	0	Physical Security Policy	N
158	Jack Kaminski	CO-IT-POL-031	0	Responsible Disclosure Policy	N
159	Jack Kaminski	CO-IT-POL-032	0	Risk Management 	N
160	Jack Kaminski	CO-IT-POL-033	0	Third Party Management	N
161	Pia Olsen	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
162	Pia Olsen	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
163	Pia Olsen	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	N
164	Pia Olsen	CO-QA-SOP-140	18	Document Control & Control of Quality Records	N
165	Pia Olsen	CO-QA-SOP-098	7	Document Matrix	N
166	Pia Olsen	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
167	Pia Olsen	CO-QA-SOP-026	5	Use of Sharepoint	Y
168	Pia Olsen	CO-QA-SOP-028	8	Quality Records	Y
169	Pia Olsen	CO-QA-SOP-025	10	Management Review	Y
170	Pia Olsen	CO-QA-SOP-012	8	Annual Quality Objectives 	N
171	Pia Olsen	CO-QA-POL-021	9	Quality Manual	N
172	Pia Olsen	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
173	Pia Olsen	CO-HR-POL-007	2	Training Policy	Y
174	Pia Olsen	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
175	Pia Olsen	CO-QA-POL-019	6	Quality Policy	N
176	Pia Olsen	CO-QA-SOP-043	7	Training Procedure	Y
177	Pia Olsen	CO-IT-POL-022	0	Access Control Policy	Y
178	Pia Olsen	CO-IT-POL-023	0	Asset Management Policy	Y
179	Pia Olsen	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
180	Pia Olsen	CO-IT-POL-025	0	Code of Conduct	Y
181	Pia Olsen	CO-IT-POL-026	0	Cryptography Policy	Y
182	Pia Olsen	CO-IT-POL-027	0	Human Resource Security Policy	Y
183	Pia Olsen	CO-IT-POL-028	0	Information Security Policy	Y
184	Pia Olsen	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
185	Pia Olsen	CO-IT-POL-030	0	Physical Security Policy	Y
186	Pia Olsen	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
187	Pia Olsen	CO-IT-POL-032	0	Risk Management 	Y
188	Pia Olsen	CO-IT-POL-033	0	Third Party Management	Y
189	Alyssa Luber	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
190	Alyssa Luber	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
191	Alyssa Luber	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
192	Alyssa Luber	CO-DES-SOP-006	1	Reagent Design Transfer Process 	N
193	Alyssa Luber	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
194	Alyssa Luber	CO-QA-SOP-098	7	Document Matrix	N
195	Alyssa Luber	CO-QA-SOP-139	15	Change Management	N
196	Alyssa Luber	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
197	Alyssa Luber	CO-QA-SOP-026	5	Use of Sharepoint	Y
198	Alyssa Luber	CO-QA-SOP-028	8	Quality Records	Y
199	Alyssa Luber	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
200	Alyssa Luber	CO-QA-SOP-025	10	Management Review	Y
201	Alyssa Luber	CO-QA-SOP-076	8	Product Complaint Handling	N
202	Alyssa Luber	CO-QA-SOP-267	7	Post Market Surveillance	N
203	Alyssa Luber	CO-QA-SOP-093	7	CAPA Procedure	Y
204	Alyssa Luber	CO-QA-SOP-012	8	Annual Quality Objectives 	N
205	Alyssa Luber	CO-QA-POL-021	9	Quality Manual	N
206	Alyssa Luber	CO-HR-POL-007	2	Training Policy	Y
207	Alyssa Luber	CO-QA-POL-019	6	Quality Policy	N
209	Alyssa Luber	CO-QA-SOP-043	7	Training Procedure	Y
210	Alyssa Luber	CO-IT-POL-022	0	Access Control Policy	N
211	Alyssa Luber	CO-IT-POL-023	0	Asset Management Policy	N
212	Alyssa Luber	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
213	Alyssa Luber	CO-IT-POL-025	0	Code of Conduct	N
214	Alyssa Luber	CO-IT-POL-026	0	Cryptography Policy	N
215	Alyssa Luber	CO-IT-POL-027	0	Human Resource Security Policy	N
216	Alyssa Luber	CO-IT-POL-028	0	Information Security Policy	N
217	Alyssa Luber	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
218	Alyssa Luber	CO-IT-POL-030	0	Physical Security Policy	N
219	Alyssa Luber	CO-IT-POL-031	0	Responsible Disclosure Policy	N
220	Alyssa Luber	CO-IT-POL-032	0	Risk Management 	N
221	Alyssa Luber	CO-IT-POL-033	0	Third Party Management	N
222	Alyssa Amidei	CO-IT-POL-022	0	Access Control Policy	N
223	Alyssa Amidei	CO-IT-POL-023	0	Asset Management Policy	N
224	Alyssa Amidei	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
225	Alyssa Amidei	CO-IT-POL-025	0	Code of Conduct	N
226	Alyssa Amidei	CO-IT-POL-026	0	Cryptography Policy	N
227	Alyssa Amidei	CO-IT-POL-027	0	Human Resource Security Policy	N
228	Alyssa Amidei	CO-IT-POL-028	0	Information Security Policy	N
229	Alyssa Amidei	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
230	Alyssa Amidei	CO-IT-POL-030	0	Physical Security Policy	N
231	Alyssa Amidei	CO-IT-POL-031	0	Responsible Disclosure Policy	N
232	Alyssa Amidei	CO-IT-POL-032	0	Risk Management 	N
233	Alyssa Amidei	CO-IT-POL-033	0	Third Party Management	N
234	Sarah Thomas	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	N
235	Sarah Thomas	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	N
236	Sarah Thomas	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	N
237	Sarah Thomas	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	N
238	Sarah Thomas	CO-QA-SOP-274	0	Applicable Standards Management Procedure	N
239	Sarah Thomas	CO-IT-SOP-044	4	IT Management Back Up and Support	N
240	Sarah Thomas	CO-QA-SOP-026	5	Use of Sharepoint	N
241	Sarah Thomas	CO-QA-SOP-028	8	Quality Records	N
242	Sarah Thomas	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
243	Sarah Thomas	CO-QA-SOP-076	8	Product Complaint Handling	N
244	Sarah Thomas	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
245	Sarah Thomas	CO-QA-SOP-007	5	Correction Removal and Recall Procedure	Y
246	Sarah Thomas	CO-QA-SOP-267	7	Post Market Surveillance	N
247	Sarah Thomas	CO-QA-SOP-012	8	Annual Quality Objectives 	N
248	Sarah Thomas	CO-QA-POL-021	9	Quality Manual	N
249	Sarah Thomas	CO-QA-POL-006	5	Policy for Document Control and Change Management	N
250	Sarah Thomas	CO-HR-POL-007	2	Training Policy	N
251	Sarah Thomas	CO-QA-POL-019	6	Quality Policy	N
252	Sarah Thomas	CO-QA-SOP-043	7	Training Procedure	N
253	Sarah Thomas	CO-IT-POL-022	0	Access Control Policy	N
254	Sarah Thomas	CO-IT-POL-023	0	Asset Management Policy	N
255	Sarah Thomas	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
256	Sarah Thomas	CO-IT-POL-025	0	Code of Conduct	N
257	Sarah Thomas	CO-IT-POL-026	0	Cryptography Policy	N
258	Sarah Thomas	CO-IT-POL-027	0	Human Resource Security Policy	N
259	Sarah Thomas	CO-IT-POL-028	0	Information Security Policy	N
260	Sarah Thomas	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
261	Sarah Thomas	CO-IT-POL-030	0	Physical Security Policy	N
262	Sarah Thomas	CO-IT-POL-031	0	Responsible Disclosure Policy	N
263	Sarah Thomas	CO-IT-POL-032	0	Risk Management 	N
264	Sarah Thomas	CO-IT-POL-033	0	Third Party Management	N
265	Tracie Medairos	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
266	Tracie Medairos	HS-P-001	9	Health & Safety Policy	N
267	Tracie Medairos	CO-QA-SOP-026	5	Use of Sharepoint	Y
268	Tracie Medairos	CO-QA-SOP-028	8	Quality Records	Y
269	Tracie Medairos	CO-QA-SOP-076	8	Product Complaint Handling	N
270	Tracie Medairos	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
271	Tracie Medairos	CO-QA-SOP-093	7	CAPA Procedure	N
272	Tracie Medairos	CO-QA-SOP-012	8	Annual Quality Objectives 	N
273	Tracie Medairos	CO-SUP-SOP-002	4	Intrument service and repair	Y
274	Tracie Medairos	CO-QA-POL-021	9	Quality Manual	Y
275	Tracie Medairos	CO-HR-POL-007	2	Training Policy	Y
276	Tracie Medairos	CO-QA-POL-019	6	Quality Policy	N
277	Tracie Medairos	CO-QA-SOP-043	7	Training Procedure	N
278	Tracie Medairos	CO-IT-POL-022	0	Access Control Policy	N
279	Tracie Medairos	CO-IT-POL-023	0	Asset Management Policy	N
280	Tracie Medairos	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
281	Tracie Medairos	CO-IT-POL-025	0	Code of Conduct	N
282	Tracie Medairos	CO-IT-POL-026	0	Cryptography Policy	N
283	Tracie Medairos	CO-IT-POL-027	0	Human Resource Security Policy	N
284	Tracie Medairos	CO-IT-POL-028	0	Information Security Policy	N
285	Tracie Medairos	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
286	Tracie Medairos	CO-IT-POL-030	0	Physical Security Policy	N
287	Tracie Medairos	CO-IT-POL-031	0	Responsible Disclosure Policy	N
288	Tracie Medairos	CO-IT-POL-032	0	Risk Management 	N
289	Tracie Medairos	CO-IT-POL-033	0	Third Party Management	N
290	Nasa Suon	CO-CS-SOP-249	0	io Insepction using Data Collection Cartridge	Y
291	Nasa Suon	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
292	Nasa Suon	CO-H&S-P-001	9	Health & Safety Policy	N
293	Nasa Suon	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
294	Nasa Suon	CO-QA-SOP-139	15	Change Management	N
295	Nasa Suon	CO-QA-SOP-026	5	Use of Sharepoint	Y
296	Nasa Suon	CO-QA-SOP-028	8	Quality Records	Y
297	Nasa Suon	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
298	Nasa Suon	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
299	Nasa Suon	CO-QA-SOP-003	17	Non Conformance Procedure	N
300	Nasa Suon	CO-QA-SOP-076	8	Product Complaint Handling	N
301	Nasa Suon	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
302	Nasa Suon	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
303	Nasa Suon	CO-QA-SOP-093	7	CAPA Procedure	Y
304	Nasa Suon	CO-SUP-SOP-002	4	Intrument service and repair	Y
305	Nasa Suon	CO-QA-POL-021	9	Quality Manual	N
306	Nasa Suon	CO-HR-POL-007	2	Training Policy	Y
307	Nasa Suon	CO-QA-POL-019	6	Quality Policy	N
308	Nasa Suon	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	Y
309	Nasa Suon	CO-SUP-SOP-068	14	Purchasing SOP	N
310	Nasa Suon	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
312	Nasa Suon	CO-QA-SOP-043	7	Training Procedure	Y
313	Nasa Suon	CO-IT-POL-022	0	Access Control Policy	N
314	Nasa Suon	CO-IT-POL-023	0	Asset Management Policy	N
315	Nasa Suon	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
316	Nasa Suon	CO-IT-POL-025	0	Code of Conduct	N
317	Nasa Suon	CO-IT-POL-026	0	Cryptography Policy	N
318	Nasa Suon	CO-IT-POL-027	0	Human Resource Security Policy	N
319	Nasa Suon	CO-IT-POL-028	0	Information Security Policy	N
320	Nasa Suon	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
321	Nasa Suon	CO-IT-POL-030	0	Physical Security Policy	N
322	Nasa Suon	CO-IT-POL-031	0	Responsible Disclosure Policy	N
323	Nasa Suon	CO-IT-POL-032	0	Risk Management 	N
324	Nasa Suon	CO-IT-POL-033	0	Third Party Management	N
325	Alexia Osei-Dabankah	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
326	Alexia Osei-Dabankah	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
327	Alexia Osei-Dabankah	CO-H&S-P-001	9	Health & Safety Policy	N
328	Alexia Osei-Dabankah	CO-H&S-P-003	1	Stress Policy 	Y
329	Alexia Osei-Dabankah	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
330	Alexia Osei-Dabankah	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
331	Alexia Osei-Dabankah	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
332	Alexia Osei-Dabankah	CO-QA-SOP-139	15	Change Management	Y
333	Alexia Osei-Dabankah	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
334	Alexia Osei-Dabankah	CO-QA-SOP-026	5	Use of Sharepoint	Y
335	Alexia Osei-Dabankah	CO-QA-SOP-028	8	Quality Records	Y
336	Alexia Osei-Dabankah	CO-SUP-SOP-048	3	Raise PO Non Stock and Services	Y
337	Alexia Osei-Dabankah	CO-SUP-SOP-049	4	Receive non sock PO 	Y
338	Alexia Osei-Dabankah	CO-QA-SOP-003	17	Non Conformance Procedure	N
339	Alexia Osei-Dabankah	CO-QA-SOP-076	8	Product Complaint Handling	N
340	Alexia Osei-Dabankah	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
341	Alexia Osei-Dabankah	CO-QA-SOP-267	7	Post Market Surveillance	N
342	Alexia Osei-Dabankah	CO-QA-SOP-093	7	CAPA Procedure	Y
343	Alexia Osei-Dabankah	CO-QA-SOP-012	8	Annual Quality Objectives 	N
344	Alexia Osei-Dabankah	CO-QA-POL-021	9	Quality Manual	N
345	Alexia Osei-Dabankah	CO-HR-POL-007	2	Training Policy	Y
346	Alexia Osei-Dabankah	CO-QA-POL-019	6	Quality Policy	N
347	Alexia Osei-Dabankah	CO-SUP-SOP-068	14	Purchasing SOP	N
348	Alexia Osei-Dabankah	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
350	Alexia Osei-Dabankah	CO-QA-SOP-043	7	Training Procedure	Y
351	Alexia Osei-Dabankah	CO-IT-POL-022	0	Access Control Policy	N
352	Alexia Osei-Dabankah	CO-IT-POL-023	0	Asset Management Policy	N
353	Alexia Osei-Dabankah	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
354	Alexia Osei-Dabankah	CO-IT-POL-025	0	Code of Conduct	N
355	Alexia Osei-Dabankah	CO-IT-POL-026	0	Cryptography Policy	N
356	Alexia Osei-Dabankah	CO-IT-POL-027	0	Human Resource Security Policy	N
357	Alexia Osei-Dabankah	CO-IT-POL-028	0	Information Security Policy	N
358	Alexia Osei-Dabankah	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
359	Alexia Osei-Dabankah	CO-IT-POL-030	0	Physical Security Policy	N
360	Alexia Osei-Dabankah	CO-IT-POL-031	0	Responsible Disclosure Policy	N
361	Alexia Osei-Dabankah	CO-IT-POL-032	0	Risk Management 	N
362	Alexia Osei-Dabankah	CO-IT-POL-033	0	Third Party Management	N
363	Evan Bartlett	CO-H&S-P-001	9	Health & Safety Policy	N
364	Evan Bartlett	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
365	Evan Bartlett	CO-QA-SOP-139	15	Change Management	Y
366	Evan Bartlett	CO-QA-SOP-026	5	Use of Sharepoint	Y
367	Evan Bartlett	CO-QA-SOP-028	8	Quality Records	Y
368	Evan Bartlett	CO-SUP-SOP-046	2	Create New Customer Return	Y
369	Evan Bartlett	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
370	Evan Bartlett	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
371	Evan Bartlett	CO-QA-SOP-003	17	Non Conformance Procedure	Y
372	Evan Bartlett	CO-QA-SOP-077	10	Supplier Audit Procedure	N
373	Evan Bartlett	CO-QA-SOP-076	8	Product Complaint Handling	N
374	Evan Bartlett	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
375	Evan Bartlett	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
376	Evan Bartlett	CO-QA-SOP-093	7	CAPA Procedure	Y
377	Evan Bartlett	CO-SUP-SOP-002	4	Intrument service and repair	Y
378	Evan Bartlett	CO-QA-POL-021	9	Quality Manual	Y
379	Evan Bartlett	CO-HR-POL-007	2	Training Policy	Y
380	Evan Bartlett	CO-QA-POL-019	6	Quality Policy	N
381	Evan Bartlett	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	Y
382	Evan Bartlett	CO-SUP-SOP-068	14	Purchasing SOP	N
383	Evan Bartlett	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
385	Evan Bartlett	CO-QA-SOP-043	7	Training Procedure	Y
386	Evan Bartlett	CO-IT-POL-022	0	Access Control Policy	N
387	Evan Bartlett	CO-IT-POL-023	0	Asset Management Policy	N
388	Evan Bartlett	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
389	Evan Bartlett	CO-IT-POL-025	0	Code of Conduct	N
390	Evan Bartlett	CO-IT-POL-026	0	Cryptography Policy	N
391	Evan Bartlett	CO-IT-POL-027	0	Human Resource Security Policy	N
392	Evan Bartlett	CO-IT-POL-028	0	Information Security Policy	N
393	Evan Bartlett	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
394	Evan Bartlett	CO-IT-POL-030	0	Physical Security Policy	N
395	Evan Bartlett	CO-IT-POL-031	0	Responsible Disclosure Policy	N
396	Evan Bartlett	CO-IT-POL-032	0	Risk Management 	N
397	Evan Bartlett	CO-IT-POL-033	0	Third Party Management	N
398	Reno Torres	CO-H&S-P-001	9	Health & Safety Policy	Y
399	Reno Torres	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
400	Reno Torres	CO-QA-SOP-139	15	Change Management	Y
401	Reno Torres	CO-QA-SOP-026	5	Use of Sharepoint	Y
402	Reno Torres	CO-QA-SOP-028	8	Quality Records	Y
403	Reno Torres	CO-QA-SOP-076	8	Product Complaint Handling	N
404	Reno Torres	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
405	Reno Torres	CO-QA-POL-021	9	Quality Manual	Y
406	Reno Torres	CO-HR-POL-007	2	Training Policy	Y
407	Reno Torres	CO-QA-POL-019	6	Quality Policy	N
408	Reno Torres	CO-SUP-SOP-068	14	Purchasing SOP	N
409	Reno Torres	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
411	Reno Torres	CO-QA-SOP-043	7	Training Procedure	Y
412	Reno Torres	CO-IT-POL-022	0	Access Control Policy	N
413	Reno Torres	CO-IT-POL-023	0	Asset Management Policy	N
414	Reno Torres	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
415	Reno Torres	CO-IT-POL-025	0	Code of Conduct	N
416	Reno Torres	CO-IT-POL-026	0	Cryptography Policy	N
417	Reno Torres	CO-IT-POL-027	0	Human Resource Security Policy	N
418	Reno Torres	CO-IT-POL-028	0	Information Security Policy	N
419	Reno Torres	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
420	Reno Torres	CO-IT-POL-030	0	Physical Security Policy	N
421	Reno Torres	CO-IT-POL-031	0	Responsible Disclosure Policy	N
422	Reno Torres	CO-IT-POL-032	0	Risk Management 	N
423	Reno Torres	CO-IT-POL-033	0	Third Party Management	N
424	Nicole Surprise-Freeman	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
425	Nicole Surprise-Freeman	CO-H&S-P-001	9	Health & Safety Policy	Y
426	Nicole Surprise-Freeman	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
427	Nicole Surprise-Freeman	CO-QA-SOP-012	8	Annual Quality Objectives 	N
428	Nicole Surprise-Freeman	CO-QA-POL-021	9	Quality Manual	Y
429	Nicole Surprise-Freeman	CO-HR-POL-007	2	Training Policy	Y
430	Nicole Surprise-Freeman	CO-QA-POL-019	6	Quality Policy	N
431	Nicole Surprise-Freeman	CO-IT-POL-022	0	Access Control Policy	N
432	Nicole Surprise-Freeman	CO-IT-POL-023	0	Asset Management Policy	N
433	Nicole Surprise-Freeman	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
434	Nicole Surprise-Freeman	CO-IT-POL-025	0	Code of Conduct	N
435	Nicole Surprise-Freeman	CO-IT-POL-026	0	Cryptography Policy	N
436	Nicole Surprise-Freeman	CO-IT-POL-027	0	Human Resource Security Policy	N
437	Nicole Surprise-Freeman	CO-IT-POL-028	0	Information Security Policy	N
438	Nicole Surprise-Freeman	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
439	Nicole Surprise-Freeman	CO-IT-POL-030	0	Physical Security Policy	N
440	Nicole Surprise-Freeman	CO-IT-POL-031	0	Responsible Disclosure Policy	N
441	Nicole Surprise-Freeman	CO-IT-POL-032	0	Risk Management 	N
442	Nicole Surprise-Freeman	CO-IT-POL-033	0	Third Party Management	N
443	Rachel Korwek	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	N
444	Rachel Korwek	CO-QA-SOP-139	15	Change Management	N
445	Rachel Korwek	CO-QA-SOP-026	5	Use of Sharepoint	N
446	Rachel Korwek	CO-QA-SOP-028	8	Quality Records	N
447	Rachel Korwek	CO-SUP-SOP-046	2	Create New Customer Return	N
448	Rachel Korwek	CO-QA-SOP-076	8	Product Complaint Handling	N
449	Rachel Korwek	CO-QA-SOP-093	7	CAPA Procedure	N
450	Rachel Korwek	CO-QA-SOP-012	8	Annual Quality Objectives 	N
451	Rachel Korwek	CO-SUP-SOP-002	4	Intrument service and repair	N
452	Rachel Korwek	CO-QA-POL-021	9	Quality Manual	N
453	Rachel Korwek	CO-HR-POL-007	2	Training Policy	N
454	Rachel Korwek	CO-QA-POL-019	6	Quality Policy	N
455	Rachel Korwek	CO-SUP-SOP-068	14	Purchasing SOP	N
456	Rachel Korwek	CO-SUP-SOP-069	7	Supplier Evaluation SOP	N
458	Rachel Korwek	CO-QA-SOP-043	7	Training Procedure	N
459	Rachel Korwek	CO-IT-POL-022	0	Access Control Policy	N
460	Rachel Korwek	CO-IT-POL-023	0	Asset Management Policy	N
461	Rachel Korwek	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
462	Rachel Korwek	CO-IT-POL-025	0	Code of Conduct	N
463	Rachel Korwek	CO-IT-POL-026	0	Cryptography Policy	N
464	Rachel Korwek	CO-IT-POL-027	0	Human Resource Security Policy	N
465	Rachel Korwek	CO-IT-POL-028	0	Information Security Policy	N
466	Rachel Korwek	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
467	Rachel Korwek	CO-IT-POL-030	0	Physical Security Policy	N
468	Rachel Korwek	CO-IT-POL-031	0	Responsible Disclosure Policy	N
469	Rachel Korwek	CO-IT-POL-032	0	Risk Management 	N
470	Rachel Korwek	CO-IT-POL-033	0	Third Party Management	N
471	Antony Brown	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
472	Antony Brown	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
473	Antony Brown	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
474	Antony Brown	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
475	Antony Brown	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
476	Antony Brown	CO-QC-COP-001	3	Quality Control Laboratory Code of Practice	Y
477	Antony Brown	CO-QC-COP-002 	2	CL2 Microbiology Lab Code of Practice	Y
478	Antony Brown	CO-H&S-COSHH-001	5	General Chemicals	Y
479	Antony Brown	CO-H&S-COSHH-002	5	Oxidising Agents	Y
480	Antony Brown	CO-H&S-COSHH-003	5	Flammable Materials	Y
481	Antony Brown	CO-H&S-COSHH-004	5	Chlorinated Solvents	Y
482	Antony Brown	CO-H&S-COSHH-005	5	Corrosive Bases	Y
483	Antony Brown	CO-H&S-COSHH-006	5	Corrosive Acids	Y
484	Antony Brown	CO-H&S-COSHH-007	5	COSHH assessment for general Hazard Group 2 organisms	Y
485	Antony Brown	CO-H&S-COSHH-008	5	COSHH assessment for Hazard Group 2 respiratory pathogens	Y
486	Antony Brown	CO-H&S-COSHH-009	4	COSHH Risk Assessment for Hazard Group 1 Pathogens	Y
487	Antony Brown	CO-H&S-COSHH-010	6	COSHH Risk assessment for clinical samples	Y
488	Antony Brown	CO-H&S-COSHH-012	5	Inactivated Micro-organisms	Y
489	Antony Brown	CO-H&S-P-001	9	Health & Safety Policy	Y
490	Antony Brown	CO-H&S-P-002	6	PAT Policy	Y
491	Antony Brown	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
492	Antony Brown	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
493	Antony Brown	CO-H&S-PRO-003	5	Health and Safety Manual Handling	Y
494	Antony Brown	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
495	Antony Brown	CO-H&S-RA-001	3	Risk Assessment for binx Health office and non-laboratory area	Y
496	Antony Brown	CO-H&S-RA-003	4	Risk Assessment for laboratory areas (excluding Microbiology and Pilot Line)	Y
497	Antony Brown	CO-H&S-RA-004	5	Risk Assessment for� io� reader / assay development tools	Y
498	Antony Brown	CO-H&S-RA-005	3	Dangerous and Explosive Atmosphere Risk Assessment	Y
499	Antony Brown	CO-H&S-RA-006	5	Risk Assessment for use of UV irradiation in the binx health Laboratories	Y
500	Antony Brown	CO-H&S-RA-007	4	RA Pilot Line Lab Area	Y
501	Antony Brown	CO-H&S-RA-008	3	Risk Assessment for binx Health Employees	Y
502	Antony Brown	CO-H&S-RA-009	3	Risk Assessment for use of Chemicals / Microorganisms	Y
503	Antony Brown	CO-H&S-RA-011	6	Covid-19 Risk Assessment binx Health ltd	Y
504	Antony Brown	CO-DES-SOP-029	10	Design and Development Procedure	Y
505	Antony Brown	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
506	Antony Brown	CO-DES-SOP-041	6	Design Review Work Instruction	Y
507	Antony Brown	CO-DES-SOP-004	4	Software Development Procedure	Y
508	Antony Brown	CO-DES-SOP-042	3	Creation and maintenance of a Device Master Record	Y
509	Antony Brown	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
510	Antony Brown	CO-QA-SOP-098	7	Document Matrix	N
511	Antony Brown	CO-QA-SOP-139	15	Change Management	Y
512	Antony Brown	CO-OPS-SOP-035	3	Engineering Drawing Control	Y
513	Antony Brown	CO-QA-SOP-026	5	Use of Sharepoint	Y
514	Antony Brown	CO-OPS-SOP-036	2	Instrument Engineering Change Management	Y
515	Antony Brown	CO-QA-SOP-028	8	Quality Records	Y
516	Antony Brown	CO-SUP-SOP-048	3	Raise PO Non Stock and Services	Y
517	Antony Brown	CO-SUP-SOP-049	4	Receive non sock PO 	Y
518	Antony Brown	CO-SUP-SOP-055	2	Goods Movement 	Y
519	Antony Brown	CO-SUP-SOP-057	2	Consume to cost centre or Project 	Y
520	Antony Brown	CO-SUP-SOP-065	2	Complete a timesheet	Y
521	Antony Brown	CO-LAB-SOP-300	5	Preparation of Sub-circuit cards for voltammetric detection	Y
522	Antony Brown	CO-LAB-SOP-290	3	Running Clinical Samples in io Readers	Y
523	Antony Brown	CO-LAB-SOP-155	8	Lab book write up	Y
524	Antony Brown	CO-LAB-SOP-156	9	Lab rough notes	Y
525	Antony Brown	CO-LAB-SOP-013	6	Balance calibration	Y
526	Antony Brown	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
527	Antony Brown	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	Y
528	Antony Brown	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	Y
529	Antony Brown	CO-LAB-SOP-137	7	Monitoring Variable Temperature Apparatus	Y
530	Antony Brown	CO-LAB-SOP-108	20	Laboratory cleaning SOP	Y
531	Antony Brown	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	Y
532	Antony Brown	CO-LAB-SOP-102	4	Use of the Grant XB2 Ultrasonic Bath	Y
533	Antony Brown	CO-LAB-SOP-149	5	Introducing New Laboratory Equipment	Y
534	Antony Brown	CO-LAB-SOP-003	3	Validation of Temperature Controlled Equipemnt	Y
535	Antony Brown	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
536	Antony Brown	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
537	Antony Brown	CO-LAB-SOP-164	3	Operation and Maintenance of HT24-2P Bambi Compressor and DSIS Sealer	Y
538	Antony Brown	CO-LAB-SOP-005	3	Rhychiger Heat Sealer	Y
539	Antony Brown	CO-OPS-SOP-165	1	Windows Software Up-date	Y
540	Antony Brown	CO-OPS-SOP-007	2	Firmware Up-date	Y
541	Antony Brown	CO-OPS-SOP-166	2	Pneumatics Test Rig Set Up and Calibration	Y
542	Antony Brown	CO-OPS-SOP-187	3	Force Test Rig Set Up and Calibration	Y
543	Antony Brown	CO-OPS-SOP-008	3	Thermal Test Rig Set Up and Calibration	Y
544	Antony Brown	CO-LAB-SOP-167	5	Attaching Electrode/Blister Adhesive and Blister Pack	Y
545	Antony Brown	CO-LAB-SOP-169	3	Fermant Pouch Sealer (Pilot Line)	Y
546	Antony Brown	CO-LAB-SOP-170	3	Rapid PCR Rig Work Instructions	Y
547	Antony Brown	CO-LAB-SOP-130	2	Heat Detection Rig Work Instructions	Y
548	Antony Brown	CO-OPS-SOP-172	3	Tool Changes of the Rhychiger Heat Sealer 	Y
549	Antony Brown	CO-LAB-SOP-020	2	Use of the Hulme Martin Impulse Sealer in DNA free	Y
550	Antony Brown	CO-OPS-SOP-174	2	Engineering Rework Procedure 	Y
551	Antony Brown	CO-LAB-SOP-176	2	SOP to provide guidance for IQCs	Y
552	Antony Brown	CO-LAB-SOP-178	1	Signal Analyser	Y
553	Antony Brown	CO-LAB-SOP-184	2	Pilot Line Blister Filling and Sealing Procedure	Y
554	Antony Brown	CO-QC-SOP-185	1	Use of the SB3 Rotator	Y
555	Antony Brown	CO-CA-SOP-081	2	Collection of Human samples for QA purposes	Y
556	Antony Brown	CO-QA-SOP-003	17	Non Conformance Procedure	Y
557	Antony Brown	CO-QA-SOP-004	12	Internal Audit	Y
558	Antony Brown	CO-QA-SOP-077	10	Supplier Audit Procedure	Y
559	Antony Brown	CO-QA-SOP-076	8	Product Complaint Handling	Y
560	Antony Brown	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
561	Antony Brown	CO-QA-SOP-007	5	Correction Removal and Recall Procedure	Y
562	Antony Brown	CO-QA-SOP-345	4	Tools for Root Cause Analysis	Y
563	Antony Brown	CO-QA-SOP-267	7	Post Market Surveillance	N
564	Antony Brown	CO-QA-SOP-147	3	Managing an External Regulatory Visit	Y
565	Antony Brown	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
566	Antony Brown	CO-QA-SOP-099	5	Deviation procedure	Y
567	Antony Brown	CO-QA-SOP-093	7	CAPA Procedure	Y
568	Antony Brown	CO-QA-SOP-012	8	Annual Quality Objectives 	N
569	Antony Brown	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	Y
570	Antony Brown	CO-QA-SOP-014	2	Quality Planning Procedure	Y
571	Antony Brown	CO-QA-SOP-015	3	Competence of Atlas Auditors	Y
572	Antony Brown	CO-QA-SOP-016	1	Identification and Traceability	Y
573	Antony Brown	CO-SUP-SOP-002	4	Intrument service and repair	Y
574	Antony Brown	CO-SUP-SOP-006	2	Equipment and fulfilment and field visits	Y
575	Antony Brown	CO-QA-POL-021	9	Quality Manual	Y
576	Antony Brown	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
577	Antony Brown	CO-HR-POL-007	2	Training Policy	Y
578	Antony Brown	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
579	Antony Brown	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
580	Antony Brown	CO-QA-POL-020	8	Risk Management Policy	Y
581	Antony Brown	CO-CA-POL-009	3	Policy for Verification and Validation	Y
582	Antony Brown	CO-OPS-POL-011	2	WEEE Policy	Y
583	Antony Brown	CO-CS-POL-012	4	Policy for Customer Feedback and Device Vigilance	Y
584	Antony Brown	CO-QC-POL-018	5	Quality Control Policy	Y
586	Antony Brown	CO-QA-POL-019	6	Quality Policy	N
587	Antony Brown	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	Y
588	Antony Brown	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
589	Antony Brown	CO-QA-SOP-284	6	FMEA Procedure	Y
590	Antony Brown	CO-QA-SOP-283	4	Product Risk Management 	Y
591	Antony Brown	CO-SUP-SOP-068	14	Purchasing SOP	Y
592	Antony Brown	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
593	Antony Brown	CO-SUP-SOP-281	7	Cartridge Component Stock Control Procedure	Y
594	Antony Brown	CO-SUP-SOP-072	13	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	Y
595	Antony Brown	CO-SUP-SOP-280	8	Setting Expiry Dates for Incoming Materials	Y
596	Antony Brown	CO-SUP-SOP-278	8	Pilot Line Electronic Stock Control	Y
599	Antony Brown	CO-QC-SOP-286	3	Procedure for io Release	Y
600	Antony Brown	CO-QA-SOP-043	7	Training Procedure	Y
601	Antony Brown	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
602	Antony Brown	CO-OPS-SOP-188	4	Process Validation	Y
603	Antony Brown	CO-OPS-SOP-002	3	Planning for Process Validation	Y
604	Antony Brown	CO-OPS-SOP-032	3	Validation of Automated Equipment and Quality System Software	Y
605	Antony Brown	CO-OPS-SOP-034	3	Test Method Validation	Y
606	Antony Brown	CO-IT-POL-022	0	Access Control Policy	Y
607	Antony Brown	CO-IT-POL-023	0	Asset Management Policy	Y
608	Antony Brown	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
609	Antony Brown	CO-IT-POL-025	0	Code of Conduct	Y
610	Antony Brown	CO-IT-POL-026	0	Cryptography Policy	Y
611	Antony Brown	CO-IT-POL-027	0	Human Resource Security Policy	Y
612	Antony Brown	CO-IT-POL-028	0	Information Security Policy	Y
613	Antony Brown	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
614	Antony Brown	CO-IT-POL-030	0	Physical Security Policy	Y
615	Antony Brown	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
616	Antony Brown	CO-IT-POL-032	0	Risk Management 	Y
617	Antony Brown	CO-IT-POL-033	0	Third Party Management	Y
618	Henry Fatoyinbo	CO-H&S-COSHH-001	5	General Chemicals	N
619	Henry Fatoyinbo	CO-H&S-COSHH-002	5	Oxidising Agents	N
620	Henry Fatoyinbo	CO-H&S-COSHH-003	5	Flammable Materials	N
621	Henry Fatoyinbo	CO-H&S-COSHH-004	5	Chlorinated Solvents	N
622	Henry Fatoyinbo	CO-H&S-COSHH-005	5	Corrosive Bases	N
623	Henry Fatoyinbo	CO-H&S-COSHH-006	5	Corrosive Acids	N
624	Henry Fatoyinbo	CO-H&S-COSHH-007	5	COSHH assessment for general Hazard Group 2 organisms	N
625	Henry Fatoyinbo	CO-H&S-COSHH-008	5	COSHH assessment for Hazard Group 2 respiratory pathogens	N
626	Henry Fatoyinbo	CO-H&S-COSHH-009	4	COSHH Risk Assessment for Hazard Group 1 Pathogens	N
627	Henry Fatoyinbo	CO-H&S-COSHH-010	6	COSHH Risk assessment for clinical samples	N
628	Henry Fatoyinbo	CO-H&S-COSHH-012	5	Inactivated Micro-organisms	N
629	Henry Fatoyinbo	CO-H&S-P-001	9	Health & Safety Policy	N
630	Henry Fatoyinbo	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	N
631	Henry Fatoyinbo	CO-H&S-PRO-002	8	Chemical COSHH Guidance	N
632	Henry Fatoyinbo	CO-H&S-PRO-003	5	Health and Safety Manual Handling	N
633	Henry Fatoyinbo	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	N
634	Henry Fatoyinbo	CO-H&S-RA-001	3	Risk Assessment for binx Health office and non-laboratory area	N
635	Henry Fatoyinbo	CO-H&S-RA-003	4	Risk Assessment for laboratory areas (excluding Microbiology and Pilot Line)	N
636	Henry Fatoyinbo	CO-H&S-RA-004	5	Risk Assessment for� io� reader / assay development tools	N
637	Henry Fatoyinbo	CO-H&S-RA-005	3	Dangerous and Explosive Atmosphere Risk Assessment	N
638	Henry Fatoyinbo	CO-H&S-RA-006	5	Risk Assessment for use of UV irradiation in the binx health Laboratories	N
639	Henry Fatoyinbo	CO-H&S-RA-007	4	RA Pilot Line Lab Area	N
640	Henry Fatoyinbo	CO-H&S-RA-008	3	Risk Assessment for binx Health Employees	N
641	Henry Fatoyinbo	CO-H&S-RA-009	3	Risk Assessment for use of Chemicals / Microorganisms	N
642	Henry Fatoyinbo	CO-DES-SOP-029	10	Design and Development Procedure	N
643	Henry Fatoyinbo	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	N
644	Henry Fatoyinbo	CO-DES-SOP-041	6	Design Review Work Instruction	N
645	Henry Fatoyinbo	CO-DES-SOP-146	OBSOLETE	Experimental Planning and Review	N
646	Henry Fatoyinbo	CO-DES-SOP-004	4	Software Development Procedure	N
647	Henry Fatoyinbo	CO-DES-SOP-042	3	Creation and maintenance of a Device Master Record	N
648	Henry Fatoyinbo	CO-QA-SOP-140	18	Document Control & Control of Quality Records	N
649	Henry Fatoyinbo	CO-QA-SOP-098	7	Document Matrix	N
650	Henry Fatoyinbo	CO-QA-SOP-139	15	Change Management	N
651	Henry Fatoyinbo	CO-OPS-SOP-035	3	Engineering Drawing Control	N
652	Henry Fatoyinbo	CO-QA-SOP-026	5	Use of Sharepoint	N
653	Henry Fatoyinbo	CO-OPS-SOP-036	2	Instrument Engineering Change Management	N
654	Henry Fatoyinbo	CO-QA-SOP-028	8	Quality Records	N
655	Henry Fatoyinbo	CO-LAB-SOP-155	8	Lab book write up	N
656	Henry Fatoyinbo	CO-LAB-SOP-156	9	Lab rough notes	N
657	Henry Fatoyinbo	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	N
658	Henry Fatoyinbo	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	N
659	Henry Fatoyinbo	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	N
660	Henry Fatoyinbo	CO-LAB-SOP-108	20	Laboratory cleaning SOP	N
661	Henry Fatoyinbo	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	N
662	Henry Fatoyinbo	CO-OPS-SOP-166	2	Pneumatics Test Rig Set Up and Calibration	N
663	Henry Fatoyinbo	CO-OPS-SOP-187	3	Force Test Rig Set Up and Calibration	N
664	Henry Fatoyinbo	CO-OPS-SOP-008	3	Thermal Test Rig Set Up and Calibration	N
665	Henry Fatoyinbo	CO-OPS-SOP-174	2	Engineering Rework Procedure 	N
666	Henry Fatoyinbo	CO-QA-SOP-003	17	Non Conformance Procedure	N
667	Henry Fatoyinbo	CO-QA-SOP-004	12	Internal Audit	N
668	Henry Fatoyinbo	CO-QA-SOP-076	8	Product Complaint Handling	N
669	Henry Fatoyinbo	CO-QA-SOP-007	5	Correction Removal and Recall Procedure	Y
670	Henry Fatoyinbo	CO-QA-SOP-267	7	Post Market Surveillance	N
671	Henry Fatoyinbo	CO-QA-SOP-099	5	Deviation procedure	N
672	Henry Fatoyinbo	CO-QA-SOP-093	7	CAPA Procedure	N
673	Henry Fatoyinbo	CO-QA-SOP-012	8	Annual Quality Objectives 	N
674	Henry Fatoyinbo	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	N
675	Henry Fatoyinbo	CO-QA-SOP-014	2	Quality Planning Procedure	N
676	Henry Fatoyinbo	CO-QA-SOP-016	1	Identification and Traceability	N
677	Henry Fatoyinbo	CO-SUP-SOP-002	4	Intrument service and repair	N
678	Henry Fatoyinbo	CO-QA-POL-021	9	Quality Manual	N
679	Henry Fatoyinbo	CO-QA-POL-006	5	Policy for Document Control and Change Management	N
680	Henry Fatoyinbo	CO-HR-POL-007	2	Training Policy	N
681	Henry Fatoyinbo	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	N
682	Henry Fatoyinbo	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	N
683	Henry Fatoyinbo	CO-QA-POL-020	8	Risk Management Policy	N
684	Henry Fatoyinbo	CO-CA-POL-009	3	Policy for Verification and Validation	N
685	Henry Fatoyinbo	CO-QA-POL-010	4	Policy for Control of Infrastructure Environment and Equipment	N
686	Henry Fatoyinbo	CO-QA-POL-019	6	Quality Policy	N
687	Henry Fatoyinbo	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	N
688	Henry Fatoyinbo	CO-QA-SOP-285	6	Hazard Analysis Procedure	N
689	Henry Fatoyinbo	CO-QA-SOP-284	6	FMEA Procedure	N
690	Henry Fatoyinbo	CO-QA-SOP-283	4	Product Risk Management 	N
691	Henry Fatoyinbo	CO-SUP-SOP-068	14	Purchasing SOP	N
692	Henry Fatoyinbo	CO-SUP-SOP-069	7	Supplier Evaluation SOP	N
693	Henry Fatoyinbo	CO-QC-SOP-286	3	Procedure for io Release	N
694	Henry Fatoyinbo	CO-QA-SOP-043	7	Training Procedure	N
695	Henry Fatoyinbo	CO-IT-POL-022	0	Access Control Policy	N
696	Henry Fatoyinbo	CO-IT-POL-023	0	Asset Management Policy	N
697	Henry Fatoyinbo	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
698	Henry Fatoyinbo	CO-IT-POL-025	0	Code of Conduct	N
699	Henry Fatoyinbo	CO-IT-POL-026	0	Cryptography Policy	N
700	Henry Fatoyinbo	CO-IT-POL-027	0	Human Resource Security Policy	N
701	Henry Fatoyinbo	CO-IT-POL-028	0	Information Security Policy	N
702	Henry Fatoyinbo	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
703	Henry Fatoyinbo	CO-IT-POL-030	0	Physical Security Policy	N
704	Henry Fatoyinbo	CO-IT-POL-031	0	Responsible Disclosure Policy	N
705	Henry Fatoyinbo	CO-IT-POL-032	0	Risk Management 	N
706	Henry Fatoyinbo	CO-IT-POL-033	0	Third Party Management	N
707	Ian Moore	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
708	Ian Moore	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
709	Ian Moore	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
710	Ian Moore	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
711	Ian Moore	CO-H&S-P-001	9	Health & Safety Policy	Y
712	Ian Moore	CO-H&S-P-002	6	PAT Policy	Y
713	Ian Moore	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
714	Ian Moore	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
715	Ian Moore	CO-H&S-PRO-003	5	Health and Safety Manual Handling	Y
716	Ian Moore	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
717	Ian Moore	CO-H&S-RA-001	3	Risk Assessment for binx Health office and non-laboratory area	Y
718	Ian Moore	CO-H&S-RA-003	4	Risk Assessment for laboratory areas (excluding Microbiology and Pilot Line)	Y
719	Ian Moore	CO-H&S-RA-004	5	Risk Assessment for� io� reader / assay development tools	N
720	Ian Moore	CO-H&S-RA-005	3	Risk Assessment for binx Health Employees	Y
721	Ian Moore	CO-H&S-RA-006	3	Risk Assessment for use of Chemicals / Microorganisms	Y
722	Ian Moore	CO-DES-SOP-004	4	Software Development Procedure	Y
723	Ian Moore	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
724	Ian Moore	CO-QA-SOP-098	7	Document Matrix	N
725	Ian Moore	CO-QA-SOP-139	15	Change Management	Y
726	Ian Moore	CO-QA-SOP-026	5	Use of Sharepoint	Y
727	Ian Moore	CO-OPS-SOP-036	2	Instrument Engineering Change Management	Y
728	Ian Moore	CO-QA-SOP-028	8	Quality Records	Y
729	Ian Moore	CO-LAB-SOP-155	8	Lab book write up	Y
730	Ian Moore	CO-LAB-SOP-156	9	Lab rough notes	Y
731	Ian Moore	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
732	Ian Moore	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	Y
733	Ian Moore	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	Y
734	Ian Moore	CO-LAB-SOP-108	20	Laboratory cleaning SOP	Y
735	Ian Moore	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	Y
736	Ian Moore	CO-LAB-SOP-149	5	Introducing New Laboratory Equipment	N
737	Ian Moore	CO-LAB-SOP-138	4	Use of temperature and humidity loggers	Y
738	Ian Moore	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
739	Ian Moore	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
740	Ian Moore	CO-OPS-SOP-165	1	Windows Software Up-date	Y
741	Ian Moore	CO-OPS-SOP-007	2	Firmware Up-date	Y
742	Ian Moore	CO-OPS-SOP-166	2	Pneumatics Test Rig Set Up and Calibration	Y
743	Ian Moore	CO-OPS-SOP-187	3	Force Test Rig Set Up and Calibration	Y
744	Ian Moore	CO-OPS-SOP-008	3	Thermal Test Rig Set Up and Calibration	Y
745	Ian Moore	CO-LAB-SOP-167	5	Attaching Electrode/Blister Adhesive and Blister Pack	Y
746	Ian Moore	CO-OPS-SOP-009	2	Reader Peltier Refit procedure	Y
747	Ian Moore	CO-LAB-SOP-170	3	Rapid PCR Rig Work Instructions	Y
748	Ian Moore	CO-OPS-SOP-172	3	Tool Changes of the Rhychiger Heat Sealer 	Y
749	Ian Moore	CO-OPS-SOP-174	2	Engineering Rework Procedure 	Y
750	Ian Moore	CO-LAB-SOP-178	1	Signal Analyser	Y
751	Ian Moore	CO-LAB-SOP-184	2	Pilot Line Blister Filling and Sealing Procedure	Y
752	Ian Moore	CO-QC-SOP-185	1	Use of the SB3 Rotator	Y
753	Ian Moore	CO-CA-SOP-081	2	Collection of Human samples for QA purposes	Y
754	Ian Moore	CO-QA-SOP-003	17	Non Conformance Procedure	Y
755	Ian Moore	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
756	Ian Moore	CO-QA-SOP-093	7	CAPA Procedure	Y
757	Ian Moore	CO-QA-SOP-012	8	Annual Quality Objectives 	N
758	Ian Moore	CO-QA-SOP-016	1	Identification and Traceability	Y
759	Ian Moore	CO-SUP-SOP-006	2	Equipment and fulfilment and field visits	Y
760	Ian Moore	CO-QA-POL-021	9	Quality Manual	Y
761	Ian Moore	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
762	Ian Moore	CO-HR-POL-007	2	Training Policy	Y
763	Ian Moore	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
764	Ian Moore	CO-QA-POL-020	8	Risk Management Policy	Y
765	Ian Moore	CO-CA-POL-009	3	Policy for Verification and Validation	Y
766	Ian Moore	CO-QA-POL-010	4	Policy for Control of Infrastructure Environment and Equipment	Y
767	Ian Moore	CO-QA-POL-019	6	Quality Policy	N
768	Ian Moore	CO-SUP-SOP-068	14	Purchasing SOP	N
769	Ian Moore	CO-SUP-SOP-281	7	Cartridge Component Stock Control Procedure	Y
770	Ian Moore	CO-SUP-SOP-072	13	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	Y
771	Ian Moore	CO-QA-SOP-043	7	Training Procedure	Y
772	Ian Moore	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
773	Ian Moore	CO-OPS-SOP-188	4	Process Validation	Y
774	Ian Moore	CO-OPS-SOP-032	3	Validation of Automated Equipment and Quality System Software	Y
775	Ian Moore	CO-IT-POL-022	0	Access Control Policy	N
776	Ian Moore	CO-IT-POL-023	0	Asset Management Policy	N
777	Ian Moore	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
778	Ian Moore	CO-IT-POL-025	0	Code of Conduct	N
779	Ian Moore	CO-IT-POL-026	0	Cryptography Policy	N
780	Ian Moore	CO-IT-POL-027	0	Human Resource Security Policy	N
781	Ian Moore	CO-IT-POL-028	0	Information Security Policy	N
782	Ian Moore	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
783	Ian Moore	CO-IT-POL-030	0	Physical Security Policy	N
784	Ian Moore	CO-IT-POL-031	0	Responsible Disclosure Policy	N
785	Ian Moore	CO-IT-POL-032	0	Risk Management 	N
786	Ian Moore	CO-IT-POL-033	0	Third Party Management	N
787	Jawaad Bhatti	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
788	Jawaad Bhatti	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	N
789	Jawaad Bhatti	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	N
790	Jawaad Bhatti	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
791	Jawaad Bhatti	CO-H&S-P-001	9	Health & Safety Policy	N
792	Jawaad Bhatti	CO-H&S-P-003	1	Stress Policy 	Y
793	Jawaad Bhatti	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
794	Jawaad Bhatti	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
795	Jawaad Bhatti	CO-H&S-PRO-003	5	Health and Safety Manual Handling	N
796	Jawaad Bhatti	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
797	Jawaad Bhatti	CO-DES-SOP-029	10	Design and Development Procedure	Y
798	Jawaad Bhatti	CO-DES-SOP-041	6	Design Review Work Instruction	Y
799	Jawaad Bhatti	CO-QA-SOP-140	18	Document Control & Control of Quality Records	N
800	Jawaad Bhatti	CO-QA-SOP-098	7	Document Matrix	N
801	Jawaad Bhatti	CO-QA-SOP-139	15	Change Management	N
802	Jawaad Bhatti	CO-QA-SOP-026	5	Use of Sharepoint	Y
803	Jawaad Bhatti	CO-QA-SOP-028	8	Quality Records	Y
804	Jawaad Bhatti	CO-QA-SOP-005	5	Document and Records Archiving	Y
805	Jawaad Bhatti	CO-SUP-SOP-048	3	Raise PO Non Stock and Services	Y
806	Jawaad Bhatti	CO-SUP-SOP-049	4	Receive non sock PO 	Y
807	Jawaad Bhatti	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
808	Jawaad Bhatti	CO-QA-SOP-003	17	Non Conformance Procedure	N
809	Jawaad Bhatti	CO-QA-SOP-076	8	Product Complaint Handling	N
810	Jawaad Bhatti	CO-QA-SOP-099	5	Deviation procedure	N
811	Jawaad Bhatti	CO-QA-SOP-093	7	CAPA Procedure	N
812	Jawaad Bhatti	CO-QA-SOP-012	8	Annual Quality Objectives 	N
813	Jawaad Bhatti	CO-QA-SOP-016	1	Identification and Traceability	Y
814	Jawaad Bhatti	CO-QA-POL-021	9	Quality Manual	N
815	Jawaad Bhatti	CO-HR-POL-007	2	Training Policy	Y
816	Jawaad Bhatti	CO-SUP-SOP-068	14	Purchasing SOP	N
817	Jawaad Bhatti	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
818	Jawaad Bhatti	CO-QA-SOP-043	7	Training Procedure	Y
819	Jawaad Bhatti	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
820	Jawaad Bhatti	CO-IT-POL-022	0	Access Control Policy	N
821	Jawaad Bhatti	CO-IT-POL-023	0	Asset Management Policy	N
822	Jawaad Bhatti	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
823	Jawaad Bhatti	CO-IT-POL-025	0	Code of Conduct	N
824	Jawaad Bhatti	CO-IT-POL-026	0	Cryptography Policy	N
825	Jawaad Bhatti	CO-IT-POL-027	0	Human Resource Security Policy	N
826	Jawaad Bhatti	CO-IT-POL-028	0	Information Security Policy	N
827	Jawaad Bhatti	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
828	Jawaad Bhatti	CO-IT-POL-030	0	Physical Security Policy	N
829	Jawaad Bhatti	CO-IT-POL-031	0	Responsible Disclosure Policy	N
830	Jawaad Bhatti	CO-IT-POL-032	0	Risk Management 	N
831	Jawaad Bhatti	CO-IT-POL-033	0	Third Party Management	N
832	Sean Barnes	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
833	Sean Barnes	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
834	Sean Barnes	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
835	Sean Barnes	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
836	Sean Barnes	CO-H&S-P-001	9	Health & Safety Policy	Y
837	Sean Barnes	CO-DES-SOP-029	10	Design and Development Procedure	Y
838	Sean Barnes	CO-DES-SOP-004	4	Software Development Procedure	Y
839	Sean Barnes	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
840	Sean Barnes	CO-QA-SOP-098	7	Document Matrix	Y
841	Sean Barnes	CO-QA-SOP-139	15	Change Management	N
842	Sean Barnes	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
843	Sean Barnes	CO-QA-SOP-026	5	Use of Sharepoint	Y
844	Sean Barnes	CO-QA-SOP-028	8	Quality Records	Y
845	Sean Barnes	CO-QA-SOP-003	17	Non Conformance Procedure	Y
846	Sean Barnes	CO-QA-SOP-076	8	Product Complaint Handling	N
847	Sean Barnes	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
848	Sean Barnes	CO-QA-SOP-093	7	CAPA Procedure	N
849	Sean Barnes	CO-QA-SOP-012	8	Annual Quality Objectives 	Y
850	Sean Barnes	CO-QA-POL-021	9	Quality Manual	N
851	Sean Barnes	CO-HR-POL-007	2	Training Policy	Y
852	Sean Barnes	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
853	Sean Barnes	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
854	Sean Barnes	CO-QA-SOP-284	6	FMEA Procedure	Y
855	Sean Barnes	CO-QA-SOP-283	4	Product Risk Management 	Y
856	Sean Barnes	CO-SUP-SOP-068	14	Purchasing SOP	Y
857	Sean Barnes	CO-SUP-SOP-069	7	Supplier Evaluation SOP	N
858	Sean Barnes	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
859	Sean Barnes	CO-QA-SOP-043	7	Training Procedure	Y
860	Sean Barnes	CO-IT-POL-022	0	Access Control Policy	Y
861	Sean Barnes	CO-IT-POL-023	0	Asset Management Policy	N
862	Sean Barnes	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
863	Sean Barnes	CO-IT-POL-025	0	Code of Conduct	N
864	Sean Barnes	CO-IT-POL-026	0	Cryptography Policy	N
865	Sean Barnes	CO-IT-POL-027	0	Human Resource Security Policy	N
866	Sean Barnes	CO-IT-POL-028	0	Information Security Policy	N
867	Sean Barnes	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
868	Sean Barnes	CO-IT-POL-030	0	Physical Security Policy	N
869	Sean Barnes	CO-IT-POL-031	0	Responsible Disclosure Policy	N
870	Sean Barnes	CO-IT-POL-032	0	Risk Management 	N
871	Sean Barnes	CO-IT-POL-033	0	Third Party Management	N
872	Alan Alpert	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
873	Alan Alpert	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
874	Alan Alpert	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
875	Alan Alpert	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
876	Alan Alpert	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
877	Alan Alpert	CO-H&S-P-001	9	Health & Safety Policy	Y
878	Alan Alpert	CO-DES-SOP-029	10	Design and Development Procedure	Y
879	Alan Alpert	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
880	Alan Alpert	CO-DES-SOP-004	4	Software Development Procedure	Y
881	Alan Alpert	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
882	Alan Alpert	CO-QA-SOP-098	7	Document Matrix	Y
883	Alan Alpert	CO-QA-SOP-139	15	Change Management	Y
884	Alan Alpert	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
885	Alan Alpert	CO-QA-SOP-026	5	Use of Sharepoint	Y
886	Alan Alpert	CO-QA-SOP-028	8	Quality Records	Y
887	Alan Alpert	CO-QA-SOP-003	17	Non Conformance Procedure	Y
888	Alan Alpert	CO-QA-SOP-077	10	Supplier Audit Procedure	Y
889	Alan Alpert	CO-QA-SOP-076	8	Product Complaint Handling	Y
890	Alan Alpert	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
891	Alan Alpert	CO-QA-SOP-345	4	Tools for Root Cause Analysis	Y
892	Alan Alpert	CO-QA-SOP-267	7	Post Market Surveillance	N
893	Alan Alpert	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
894	Alan Alpert	CO-QA-SOP-099	5	Deviation procedure	Y
895	Alan Alpert	CO-QA-SOP-093	7	CAPA Procedure	Y
896	Alan Alpert	CO-QA-SOP-012	8	Annual Quality Objectives 	N
897	Alan Alpert	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	Y
898	Alan Alpert	CO-QA-SOP-014	2	Quality Planning Procedure	Y
899	Alan Alpert	CO-QA-POL-021	9	Quality Manual	Y
900	Alan Alpert	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
901	Alan Alpert	CO-HR-POL-007	2	Training Policy	Y
902	Alan Alpert	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
903	Alan Alpert	CO-CA-POL-009	3	Policy for Verification and Validation	Y
904	Alan Alpert	CO-CS-POL-012	4	Policy for Customer Feedback and Device Vigilance	Y
906	Alan Alpert	CO-QA-POL-019	6	Quality Policy	N
907	Alan Alpert	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
908	Alan Alpert	CO-QA-SOP-284	6	FMEA Procedure	Y
909	Alan Alpert	CO-QA-SOP-283	4	Product Risk Management 	Y
910	Alan Alpert	CO-SUP-SOP-068	14	Purchasing SOP	Y
911	Alan Alpert	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
912	Alan Alpert	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
913	Alan Alpert	CO-QA-SOP-043	7	Training Procedure	Y
914	Alan Alpert	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
915	Alan Alpert	CO-IT-POL-022	0	Access Control Policy	Y
916	Alan Alpert	CO-IT-POL-023	0	Asset Management Policy	Y
917	Alan Alpert	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
918	Alan Alpert	CO-IT-POL-025	0	Code of Conduct	Y
919	Alan Alpert	CO-IT-POL-026	0	Cryptography Policy	Y
920	Alan Alpert	CO-IT-POL-027	0	Human Resource Security Policy	Y
921	Alan Alpert	CO-IT-POL-028	0	Information Security Policy	Y
922	Alan Alpert	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
923	Alan Alpert	CO-IT-POL-030	0	Physical Security Policy	Y
924	Alan Alpert	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
925	Alan Alpert	CO-IT-POL-032	0	Risk Management 	Y
926	Alan Alpert	CO-IT-POL-033	0	Third Party Management	Y
35	Jeff Luber	CO-SUP-POL-017	3	Policy for Customer Interface	N
42	Jeff Luber	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
147	Jack Kaminski	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
208	Alyssa Luber	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
311	Nasa Suon	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
349	Alexia Osei-Dabankah	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
384	Evan Bartlett	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
410	Reno Torres	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
457	Rachel Korwek	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
585	Antony Brown	CO-SUP-POL-017	3	Policy for Customer Interface	N
597	Antony Brown	CO-SUP-SOP-070	5	Supplier Risk Assessment	N
598	Antony Brown	CO-SUP-SOP-277	3	Instructions for receipt of incoming Non-Stock goods	N
905	Alan Alpert	CO-SUP-POL-017	3	Policy for Customer Interface	N
\.


--
-- Data for Name: userstate_raw; Type: TABLE DATA; Schema: public; Owner: binxenlightenmentdb
--

COPY public.userstate_raw (employeename, qt9_document_code, revision, title, trained) FROM stdin;
Jeff Luber	CO-DES-SOP-029	10	Design and Development Procedure	Y
Jeff Luber	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Jeff Luber	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Jeff Luber	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Jeff Luber	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Jeff Luber	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Jeff Luber	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Jeff Luber	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Jeff Luber	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Jeff Luber	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
Jeff Luber	CO-H&S-P-001	9	Health & Safety Policy	Y
Jeff Luber	CO-DES-SOP-029	10	Design and Development Procedure	Y
Jeff Luber	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
Jeff Luber	CO-DES-SOP-004	4	Software Development Procedure	Y
Jeff Luber	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Jeff Luber	CO-QA-SOP-098	7	Document Matrix	Y
Jeff Luber	CO-QA-SOP-139	15	Change Management	Y
Jeff Luber	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Jeff Luber	CO-QA-SOP-026	5	Use of Sharepoint	Y
Jeff Luber	CO-QA-SOP-028	8	Quality Records	Y
Jeff Luber	CO-QA-SOP-003	17	Non Conformance Procedure	Y
Jeff Luber	CO-QA-SOP-077	10	Supplier Audit Procedure	Y
Jeff Luber	CO-QA-SOP-076	8	Product Complaint Handling	Y
Jeff Luber	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
Jeff Luber	CO-QA-SOP-345	4	Tools for Root Cause Analysis	Y
Jeff Luber	CO-QA-SOP-267	7	Post Market Surveillance	N
Jeff Luber	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
Jeff Luber	CO-QA-SOP-099	5	Deviation procedure	Y
Jeff Luber	CO-QA-SOP-093	7	CAPA Procedure	Y
Jeff Luber	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Jeff Luber	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	Y
Jeff Luber	CO-QA-SOP-014	2	Quality Planning Procedure	Y
Jeff Luber	CO-QA-POL-021	9	Quality Manual	Y
Jeff Luber	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
Jeff Luber	CO-HR-POL-007	2	Training Policy	Y
Jeff Luber	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
Jeff Luber	CO-CA-POL-009	3	Policy for Verification and Validation	Y
Jeff Luber	CO-CS-POL-012	4	Policy for Customer Feedback and Device Vigilance	Y
Jeff Luber	CO-SUP-POL-017	3	Policy for Customer Interface Order Handling Product Storage & Distribution	Y
Jeff Luber	CO-QA-POL-019	6	Quality Policy	N
Jeff Luber	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
Jeff Luber	CO-QA-SOP-284	6	FMEA Procedure	Y
Jeff Luber	CO-QA-SOP-283	4	Product Risk Management 	Y
Jeff Luber	CO-SUP-SOP-068	14	Purchasing SOP	Y
Jeff Luber	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Jeff Luber	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Jeff Luber	CO-QA-SOP-043	7	Training Procedure	Y
Jeff Luber	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
Jeff Luber	CO-IT-POL-022	0	Access Control Policy	Y
Jeff Luber	CO-IT-POL-023	0	Asset Management Policy	Y
Jeff Luber	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
Jeff Luber	CO-IT-POL-025	0	Code of Conduct	Y
Jeff Luber	CO-IT-POL-026	0	Cryptography Policy	Y
Jeff Luber	CO-IT-POL-027	0	Human Resource Security Policy	Y
Jeff Luber	CO-IT-POL-028	0	Information Security Policy	Y
Jeff Luber	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
Jeff Luber	CO-IT-POL-030	0	Physical Security Policy	Y
Jeff Luber	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
Jeff Luber	CO-IT-POL-032	0	Risk Management 	Y
Jeff Luber	CO-IT-POL-033	0	Third Party Management	Y
Anna Dixon	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Anna Dixon	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Anna Dixon	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Anna Dixon	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
Anna Dixon	CO-H&S-P-001	9	Health & Safety Policy	Y
Anna Dixon	CO-H&S-P-002	6	PAT Policy	Y
Anna Dixon	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
Anna Dixon	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
Anna Dixon	CO-H&S-PRO-003	5	Health and Safety Manual Handling	Y
Anna Dixon	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
Anna Dixon	CO-DES-SOP-029	10	Design and Development Procedure	Y
Anna Dixon	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
Anna Dixon	CO-DES-SOP-041	6	Design Review Work Instruction	Y
Anna Dixon	CO-DES-SOP-042	3	Creation and maintenance of a Device Master Record	Y
Anna Dixon	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Anna Dixon	CO-QA-SOP-139	15	Change Management	Y
Anna Dixon	CO-QA-SOP-026	5	Use of Sharepoint	Y
Anna Dixon	CO-QA-SOP-028	8	Quality Records	Y
Anna Dixon	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
Anna Dixon	CO-LAB-SOP-295	6	Environmental Contamination Monitoring	Y
Anna Dixon	CO-LAB-SOP-155	8	Lab book write up	Y
Anna Dixon	CO-LAB-SOP-156	9	Lab rough notes	Y
Anna Dixon	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
Anna Dixon	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	Y
Anna Dixon	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	Y
Anna Dixon	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	Y
Anna Dixon	CO-LAB-SOP-288	4	Assessment of Potentiostat Performance	Y
Anna Dixon	CO-LAB-SOP-158	5	Use of NanoDrop SP2000 Spectrophotometer for quantifying nucleic acid and protein samples	N
Anna Dixon	CO-LAB-SOP-149	5	Introducing New Laboratory Equipment	N
Anna Dixon	CO-LAB-SOP-135	3	Use and Completion of MFG documents	Y
Anna Dixon	CO-LAB-SOP-170	3	Rapid PCR Rig Work Instructions	Y
Anna Dixon	CO-LAB-SOP-178	1	Signal Analyser	Y
Anna Dixon	CO-CA-SOP-081	2	Collection of Human samples for QA purposes	Y
Anna Dixon	CO-QA-SOP-003	17	Non Conformance Procedure	N
Anna Dixon	CO-QA-SOP-004	12	Internal Audit	N
Anna Dixon	CO-QA-SOP-077	10	Supplier Audit Procedure	N
Anna Dixon	CO-QA-SOP-076	8	Product Complaint Handling	N
Anna Dixon	CO-QA-SOP-345	4	Tools for Root Cause Analysis	N
Anna Dixon	CO-QA-SOP-267	7	Post Market Surveillance	N
Anna Dixon	CO-QA-SOP-099	5	Deviation procedure	Y
Anna Dixon	CO-QA-SOP-093	7	CAPA Procedure	Y
Anna Dixon	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Anna Dixon	CO-QA-POL-021	9	Quality Manual	Y
Anna Dixon	CO-HR-POL-007	2	Training Policy	Y
Anna Dixon	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
Anna Dixon	CO-QA-POL-020	8	Risk Management Policy	Y
Anna Dixon	CO-CA-POL-009	3	Policy for Verification and Validation	N
Anna Dixon	CO-QA-POL-019	6	Quality Policy	N
Anna Dixon	CO-QA-POL-013	1	Policy for Complaints and Vigilance	Y
Anna Dixon	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
Anna Dixon	CO-QA-SOP-284	6	FMEA Procedure	Y
Anna Dixon	CO-QA-SOP-283	4	Product Risk Management 	Y
Anna Dixon	CO-SUP-SOP-068	14	Purchasing SOP	N
Anna Dixon	CO-SUP-SOP-072	13	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	N
Anna Dixon	CO-SUP-SOP-280	8	Setting Expiry Dates for Incoming Materials	Y
Anna Dixon	CO-QA-SOP-043	7	Training Procedure	Y
Anna Dixon	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
Anna Dixon	CO-OPS-SOP-188	4	Process Validation	Y
Anna Dixon	CO-OPS-SOP-002	3	Planning for Process Validation	Y
Anna Dixon	CO-OPS-SOP-032	3	Validation of Automated Equipment and Quality System Software	Y
Anna Dixon	CO-OPS-SOP-034	3	Test Method Validation	Y
Anna Dixon	CO-IT-POL-022	0	Access Control Policy	N
Anna Dixon	CO-IT-POL-023	0	Asset Management Policy	N
Anna Dixon	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Anna Dixon	CO-IT-POL-025	0	Code of Conduct	N
Anna Dixon	CO-IT-POL-026	0	Cryptography Policy	N
Anna Dixon	CO-IT-POL-027	0	Human Resource Security Policy	N
Anna Dixon	CO-IT-POL-028	0	Information Security Policy	N
Anna Dixon	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Anna Dixon	CO-IT-POL-030	0	Physical Security Policy	N
Anna Dixon	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Anna Dixon	CO-IT-POL-032	0	Risk Management 	N
Anna Dixon	CO-IT-POL-033	0	Third Party Management	N
Jack Kaminski	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Jack Kaminski	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Jack Kaminski	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Jack Kaminski	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Jack Kaminski	CO-QA-SOP-098	7	Document Matrix	N
Jack Kaminski	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Jack Kaminski	CO-QA-SOP-026	5	Use of Sharepoint	Y
Jack Kaminski	CO-QA-SOP-028	8	Quality Records	Y
Jack Kaminski	CO-QA-SOP-025	10	Management Review	Y
Jack Kaminski	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Jack Kaminski	CO-QA-POL-021	9	Quality Manual	N
Jack Kaminski	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
Jack Kaminski	CO-HR-POL-007	2	Training Policy	Y
Jack Kaminski	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
Jack Kaminski	CO-QA-POL-019	6	Quality Policy	N
Jack Kaminski	CO-SUP-SOP-068	14	Purchasing SOP	N
Jack Kaminski	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Jack Kaminski	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Jack Kaminski	CO-QA-SOP-043	7	Training Procedure	Y
Jack Kaminski	CO-IT-POL-022	0	Access Control Policy	N
Jack Kaminski	CO-IT-POL-023	0	Asset Management Policy	N
Jack Kaminski	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Jack Kaminski	CO-IT-POL-025	0	Code of Conduct	N
Jack Kaminski	CO-IT-POL-026	0	Cryptography Policy	N
Jack Kaminski	CO-IT-POL-027	0	Human Resource Security Policy	N
Jack Kaminski	CO-IT-POL-028	0	Information Security Policy	N
Jack Kaminski	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Jack Kaminski	CO-IT-POL-030	0	Physical Security Policy	N
Jack Kaminski	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Jack Kaminski	CO-IT-POL-032	0	Risk Management 	N
Jack Kaminski	CO-IT-POL-033	0	Third Party Management	N
Pia Olsen	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Pia Olsen	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Pia Olsen	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	N
Pia Olsen	CO-QA-SOP-140	18	Document Control & Control of Quality Records	N
Pia Olsen	CO-QA-SOP-098	7	Document Matrix	N
Pia Olsen	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Pia Olsen	CO-QA-SOP-026	5	Use of Sharepoint	Y
Pia Olsen	CO-QA-SOP-028	8	Quality Records	Y
Pia Olsen	CO-QA-SOP-025	10	Management Review	Y
Pia Olsen	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Pia Olsen	CO-QA-POL-021	9	Quality Manual	N
Pia Olsen	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
Pia Olsen	CO-HR-POL-007	2	Training Policy	Y
Pia Olsen	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
Pia Olsen	CO-QA-POL-019	6	Quality Policy	N
Pia Olsen	CO-QA-SOP-043	7	Training Procedure	Y
Pia Olsen	CO-IT-POL-022	0	Access Control Policy	Y
Pia Olsen	CO-IT-POL-023	0	Asset Management Policy	Y
Pia Olsen	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
Pia Olsen	CO-IT-POL-025	0	Code of Conduct	Y
Pia Olsen	CO-IT-POL-026	0	Cryptography Policy	Y
Pia Olsen	CO-IT-POL-027	0	Human Resource Security Policy	Y
Pia Olsen	CO-IT-POL-028	0	Information Security Policy	Y
Pia Olsen	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
Pia Olsen	CO-IT-POL-030	0	Physical Security Policy	Y
Pia Olsen	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
Pia Olsen	CO-IT-POL-032	0	Risk Management 	Y
Pia Olsen	CO-IT-POL-033	0	Third Party Management	Y
Alyssa Luber	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Alyssa Luber	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Alyssa Luber	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Alyssa Luber	CO-DES-SOP-006	1	Reagent Design Transfer Process 	N
Alyssa Luber	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Alyssa Luber	CO-QA-SOP-098	7	Document Matrix	N
Alyssa Luber	CO-QA-SOP-139	15	Change Management	N
Alyssa Luber	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Alyssa Luber	CO-QA-SOP-026	5	Use of Sharepoint	Y
Alyssa Luber	CO-QA-SOP-028	8	Quality Records	Y
Alyssa Luber	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
Alyssa Luber	CO-QA-SOP-025	10	Management Review	Y
Alyssa Luber	CO-QA-SOP-076	8	Product Complaint Handling	N
Alyssa Luber	CO-QA-SOP-267	7	Post Market Surveillance	N
Alyssa Luber	CO-QA-SOP-093	7	CAPA Procedure	Y
Alyssa Luber	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Alyssa Luber	CO-QA-POL-021	9	Quality Manual	N
Alyssa Luber	CO-HR-POL-007	2	Training Policy	Y
Alyssa Luber	CO-QA-POL-019	6	Quality Policy	N
Alyssa Luber	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Alyssa Luber	CO-QA-SOP-043	7	Training Procedure	Y
Alyssa Luber	CO-IT-POL-022	0	Access Control Policy	N
Alyssa Luber	CO-IT-POL-023	0	Asset Management Policy	N
Alyssa Luber	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Alyssa Luber	CO-IT-POL-025	0	Code of Conduct	N
Alyssa Luber	CO-IT-POL-026	0	Cryptography Policy	N
Alyssa Luber	CO-IT-POL-027	0	Human Resource Security Policy	N
Alyssa Luber	CO-IT-POL-028	0	Information Security Policy	N
Alyssa Luber	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Alyssa Luber	CO-IT-POL-030	0	Physical Security Policy	N
Alyssa Luber	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Alyssa Luber	CO-IT-POL-032	0	Risk Management 	N
Alyssa Luber	CO-IT-POL-033	0	Third Party Management	N
Alyssa Amidei	CO-IT-POL-022	0	Access Control Policy	N
Alyssa Amidei	CO-IT-POL-023	0	Asset Management Policy	N
Alyssa Amidei	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Alyssa Amidei	CO-IT-POL-025	0	Code of Conduct	N
Alyssa Amidei	CO-IT-POL-026	0	Cryptography Policy	N
Alyssa Amidei	CO-IT-POL-027	0	Human Resource Security Policy	N
Alyssa Amidei	CO-IT-POL-028	0	Information Security Policy	N
Alyssa Amidei	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Alyssa Amidei	CO-IT-POL-030	0	Physical Security Policy	N
Alyssa Amidei	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Alyssa Amidei	CO-IT-POL-032	0	Risk Management 	N
Alyssa Amidei	CO-IT-POL-033	0	Third Party Management	N
Sarah Thomas	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	N
Sarah Thomas	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	N
Sarah Thomas	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	N
Sarah Thomas	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	N
Sarah Thomas	CO-QA-SOP-274	0	Applicable Standards Management Procedure	N
Sarah Thomas	CO-IT-SOP-044	4	IT Management Back Up and Support	N
Sarah Thomas	CO-QA-SOP-026	5	Use of Sharepoint	N
Sarah Thomas	CO-QA-SOP-028	8	Quality Records	N
Sarah Thomas	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
Sarah Thomas	CO-QA-SOP-076	8	Product Complaint Handling	N
Sarah Thomas	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
Sarah Thomas	CO-QA-SOP-007	5	Correction Removal and Recall Procedure	N
Sarah Thomas	CO-QA-SOP-267	7	Post Market Surveillance	N
Sarah Thomas	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Sarah Thomas	CO-QA-POL-021	9	Quality Manual	N
Sarah Thomas	CO-QA-POL-006	5	Policy for Document Control and Change Management	N
Sarah Thomas	CO-HR-POL-007	2	Training Policy	N
Sarah Thomas	CO-QA-POL-019	6	Quality Policy	N
Sarah Thomas	CO-QA-SOP-043	7	Training Procedure	N
Sarah Thomas	CO-IT-POL-022	0	Access Control Policy	N
Sarah Thomas	CO-IT-POL-023	0	Asset Management Policy	N
Sarah Thomas	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Sarah Thomas	CO-IT-POL-025	0	Code of Conduct	N
Sarah Thomas	CO-IT-POL-026	0	Cryptography Policy	N
Sarah Thomas	CO-IT-POL-027	0	Human Resource Security Policy	N
Sarah Thomas	CO-IT-POL-028	0	Information Security Policy	N
Sarah Thomas	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Sarah Thomas	CO-IT-POL-030	0	Physical Security Policy	N
Sarah Thomas	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Sarah Thomas	CO-IT-POL-032	0	Risk Management 	N
Sarah Thomas	CO-IT-POL-033	0	Third Party Management	N
Tracie Medairos	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Tracie Medairos	HS-P-001	9	Health & Safety Policy	N
Tracie Medairos	CO-QA-SOP-026	5	Use of Sharepoint	Y
Tracie Medairos	CO-QA-SOP-028	8	Quality Records	Y
Tracie Medairos	CO-QA-SOP-076	8	Product Complaint Handling	N
Tracie Medairos	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
Tracie Medairos	CO-QA-SOP-093	7	CAPA Procedure	N
Tracie Medairos	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Tracie Medairos	CO-SUP-SOP-002	4	Intrument service and repair	Y
Tracie Medairos	CO-QA-POL-021	9	Quality Manual	Y
Tracie Medairos	CO-HR-POL-007	2	Training Policy	Y
Tracie Medairos	CO-QA-POL-019	6	Quality Policy	N
Tracie Medairos	CO-QA-SOP-043	7	Training Procedure	N
Tracie Medairos	CO-IT-POL-022	0	Access Control Policy	N
Tracie Medairos	CO-IT-POL-023	0	Asset Management Policy	N
Tracie Medairos	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Tracie Medairos	CO-IT-POL-025	0	Code of Conduct	N
Tracie Medairos	CO-IT-POL-026	0	Cryptography Policy	N
Tracie Medairos	CO-IT-POL-027	0	Human Resource Security Policy	N
Tracie Medairos	CO-IT-POL-028	0	Information Security Policy	N
Tracie Medairos	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Tracie Medairos	CO-IT-POL-030	0	Physical Security Policy	N
Tracie Medairos	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Tracie Medairos	CO-IT-POL-032	0	Risk Management 	N
Tracie Medairos	CO-IT-POL-033	0	Third Party Management	N
Nasa Suon	CO-CS-SOP-249	0	io Insepction using Data Collection Cartridge	Y
Nasa Suon	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Nasa Suon	CO-H&S-P-001	9	Health & Safety Policy	N
Nasa Suon	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Nasa Suon	CO-QA-SOP-139	15	Change Management	N
Nasa Suon	CO-QA-SOP-026	5	Use of Sharepoint	Y
Nasa Suon	CO-QA-SOP-028	8	Quality Records	Y
Nasa Suon	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
Nasa Suon	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
Nasa Suon	CO-QA-SOP-003	17	Non Conformance Procedure	N
Nasa Suon	CO-QA-SOP-076	8	Product Complaint Handling	N
Nasa Suon	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
Nasa Suon	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
Nasa Suon	CO-QA-SOP-093	7	CAPA Procedure	Y
Nasa Suon	CO-SUP-SOP-002	4	Intrument service and repair	Y
Nasa Suon	CO-QA-POL-021	9	Quality Manual	N
Nasa Suon	CO-HR-POL-007	2	Training Policy	Y
Nasa Suon	CO-QA-POL-019	6	Quality Policy	N
Nasa Suon	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	Y
Nasa Suon	CO-SUP-SOP-068	14	Purchasing SOP	N
Nasa Suon	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Nasa Suon	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Nasa Suon	CO-QA-SOP-043	7	Training Procedure	Y
Nasa Suon	CO-IT-POL-022	0	Access Control Policy	N
Nasa Suon	CO-IT-POL-023	0	Asset Management Policy	N
Nasa Suon	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Nasa Suon	CO-IT-POL-025	0	Code of Conduct	N
Nasa Suon	CO-IT-POL-026	0	Cryptography Policy	N
Nasa Suon	CO-IT-POL-027	0	Human Resource Security Policy	N
Nasa Suon	CO-IT-POL-028	0	Information Security Policy	N
Nasa Suon	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Nasa Suon	CO-IT-POL-030	0	Physical Security Policy	N
Nasa Suon	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Nasa Suon	CO-IT-POL-032	0	Risk Management 	N
Nasa Suon	CO-IT-POL-033	0	Third Party Management	N
Alexia Osei-Dabankah	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Alexia Osei-Dabankah	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Alexia Osei-Dabankah	CO-H&S-P-001	9	Health & Safety Policy	N
Alexia Osei-Dabankah	CO-H&S-P-003	1	Stress Policy 	Y
Alexia Osei-Dabankah	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
Alexia Osei-Dabankah	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
Alexia Osei-Dabankah	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Alexia Osei-Dabankah	CO-QA-SOP-139	15	Change Management	Y
Alexia Osei-Dabankah	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Alexia Osei-Dabankah	CO-QA-SOP-026	5	Use of Sharepoint	Y
Alexia Osei-Dabankah	CO-QA-SOP-028	8	Quality Records	Y
Alexia Osei-Dabankah	CO-SUP-SOP-048	3	Raise PO Non Stock and Services	Y
Alexia Osei-Dabankah	CO-SUP-SOP-049	4	Receive non sock PO 	Y
Alexia Osei-Dabankah	CO-QA-SOP-003	17	Non Conformance Procedure	N
Alexia Osei-Dabankah	CO-QA-SOP-076	8	Product Complaint Handling	N
Alexia Osei-Dabankah	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
Alexia Osei-Dabankah	CO-QA-SOP-267	7	Post Market Surveillance	N
Alexia Osei-Dabankah	CO-QA-SOP-093	7	CAPA Procedure	Y
Alexia Osei-Dabankah	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Alexia Osei-Dabankah	CO-QA-POL-021	9	Quality Manual	N
Alexia Osei-Dabankah	CO-HR-POL-007	2	Training Policy	Y
Alexia Osei-Dabankah	CO-QA-POL-019	6	Quality Policy	N
Alexia Osei-Dabankah	CO-SUP-SOP-068	14	Purchasing SOP	N
Alexia Osei-Dabankah	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Alexia Osei-Dabankah	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Alexia Osei-Dabankah	CO-QA-SOP-043	7	Training Procedure	Y
Alexia Osei-Dabankah	CO-IT-POL-022	0	Access Control Policy	N
Alexia Osei-Dabankah	CO-IT-POL-023	0	Asset Management Policy	N
Alexia Osei-Dabankah	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Alexia Osei-Dabankah	CO-IT-POL-025	0	Code of Conduct	N
Alexia Osei-Dabankah	CO-IT-POL-026	0	Cryptography Policy	N
Alexia Osei-Dabankah	CO-IT-POL-027	0	Human Resource Security Policy	N
Alexia Osei-Dabankah	CO-IT-POL-028	0	Information Security Policy	N
Alexia Osei-Dabankah	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Alexia Osei-Dabankah	CO-IT-POL-030	0	Physical Security Policy	N
Alexia Osei-Dabankah	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Alexia Osei-Dabankah	CO-IT-POL-032	0	Risk Management 	N
Alexia Osei-Dabankah	CO-IT-POL-033	0	Third Party Management	N
Evan Bartlett	CO-H&S-P-001	9	Health & Safety Policy	N
Evan Bartlett	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Evan Bartlett	CO-QA-SOP-139	15	Change Management	Y
Evan Bartlett	CO-QA-SOP-026	5	Use of Sharepoint	Y
Evan Bartlett	CO-QA-SOP-028	8	Quality Records	Y
Evan Bartlett	CO-SUP-SOP-046	2	Create New Customer Return	Y
Evan Bartlett	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
Evan Bartlett	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
Evan Bartlett	CO-QA-SOP-003	17	Non Conformance Procedure	Y
Evan Bartlett	CO-QA-SOP-077	10	Supplier Audit Procedure	N
Evan Bartlett	CO-QA-SOP-076	8	Product Complaint Handling	N
Evan Bartlett	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
Evan Bartlett	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
Evan Bartlett	CO-QA-SOP-093	7	CAPA Procedure	Y
Evan Bartlett	CO-SUP-SOP-002	4	Intrument service and repair	Y
Evan Bartlett	CO-QA-POL-021	9	Quality Manual	Y
Evan Bartlett	CO-HR-POL-007	2	Training Policy	Y
Evan Bartlett	CO-QA-POL-019	6	Quality Policy	N
Evan Bartlett	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	Y
Evan Bartlett	CO-SUP-SOP-068	14	Purchasing SOP	N
Evan Bartlett	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Evan Bartlett	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Evan Bartlett	CO-QA-SOP-043	7	Training Procedure	Y
Evan Bartlett	CO-IT-POL-022	0	Access Control Policy	N
Evan Bartlett	CO-IT-POL-023	0	Asset Management Policy	N
Evan Bartlett	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Evan Bartlett	CO-IT-POL-025	0	Code of Conduct	N
Evan Bartlett	CO-IT-POL-026	0	Cryptography Policy	N
Evan Bartlett	CO-IT-POL-027	0	Human Resource Security Policy	N
Evan Bartlett	CO-IT-POL-028	0	Information Security Policy	N
Evan Bartlett	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Evan Bartlett	CO-IT-POL-030	0	Physical Security Policy	N
Evan Bartlett	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Evan Bartlett	CO-IT-POL-032	0	Risk Management 	N
Evan Bartlett	CO-IT-POL-033	0	Third Party Management	N
Reno Torres	CO-H&S-P-001	9	Health & Safety Policy	Y
Reno Torres	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Reno Torres	CO-QA-SOP-139	15	Change Management	Y
Reno Torres	CO-QA-SOP-026	5	Use of Sharepoint	Y
Reno Torres	CO-QA-SOP-028	8	Quality Records	Y
Reno Torres	CO-QA-SOP-076	8	Product Complaint Handling	N
Reno Torres	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
Reno Torres	CO-QA-POL-021	9	Quality Manual	Y
Reno Torres	CO-HR-POL-007	2	Training Policy	Y
Reno Torres	CO-QA-POL-019	6	Quality Policy	N
Reno Torres	CO-SUP-SOP-068	14	Purchasing SOP	N
Reno Torres	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Reno Torres	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Reno Torres	CO-QA-SOP-043	7	Training Procedure	Y
Reno Torres	CO-IT-POL-022	0	Access Control Policy	N
Reno Torres	CO-IT-POL-023	0	Asset Management Policy	N
Reno Torres	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Reno Torres	CO-IT-POL-025	0	Code of Conduct	N
Reno Torres	CO-IT-POL-026	0	Cryptography Policy	N
Reno Torres	CO-IT-POL-027	0	Human Resource Security Policy	N
Reno Torres	CO-IT-POL-028	0	Information Security Policy	N
Reno Torres	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Reno Torres	CO-IT-POL-030	0	Physical Security Policy	N
Reno Torres	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Reno Torres	CO-IT-POL-032	0	Risk Management 	N
Reno Torres	CO-IT-POL-033	0	Third Party Management	N
Nicole Surprise-Freeman	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Nicole Surprise-Freeman	CO-H&S-P-001	9	Health & Safety Policy	Y
Nicole Surprise-Freeman	CO-SAM-SOP-009	5	Control of Marketing and Promotion	N
Nicole Surprise-Freeman	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Nicole Surprise-Freeman	CO-QA-POL-021	9	Quality Manual	Y
Nicole Surprise-Freeman	CO-HR-POL-007	2	Training Policy	Y
Nicole Surprise-Freeman	CO-QA-POL-019	6	Quality Policy	N
Nicole Surprise-Freeman	CO-IT-POL-022	0	Access Control Policy	N
Nicole Surprise-Freeman	CO-IT-POL-023	0	Asset Management Policy	N
Nicole Surprise-Freeman	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Nicole Surprise-Freeman	CO-IT-POL-025	0	Code of Conduct	N
Nicole Surprise-Freeman	CO-IT-POL-026	0	Cryptography Policy	N
Nicole Surprise-Freeman	CO-IT-POL-027	0	Human Resource Security Policy	N
Nicole Surprise-Freeman	CO-IT-POL-028	0	Information Security Policy	N
Nicole Surprise-Freeman	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Nicole Surprise-Freeman	CO-IT-POL-030	0	Physical Security Policy	N
Nicole Surprise-Freeman	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Nicole Surprise-Freeman	CO-IT-POL-032	0	Risk Management 	N
Nicole Surprise-Freeman	CO-IT-POL-033	0	Third Party Management	N
Rachel Korwek	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	N
Rachel Korwek	CO-QA-SOP-139	15	Change Management	N
Rachel Korwek	CO-QA-SOP-026	5	Use of Sharepoint	N
Rachel Korwek	CO-QA-SOP-028	8	Quality Records	N
Rachel Korwek	CO-SUP-SOP-046	2	Create New Customer Return	N
Rachel Korwek	CO-QA-SOP-076	8	Product Complaint Handling	N
Rachel Korwek	CO-QA-SOP-093	7	CAPA Procedure	N
Rachel Korwek	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Rachel Korwek	CO-SUP-SOP-002	4	Intrument service and repair	N
Rachel Korwek	CO-QA-POL-021	9	Quality Manual	N
Rachel Korwek	CO-HR-POL-007	2	Training Policy	N
Rachel Korwek	CO-QA-POL-019	6	Quality Policy	N
Rachel Korwek	CO-SUP-SOP-068	14	Purchasing SOP	N
Rachel Korwek	CO-SUP-SOP-069	7	Supplier Evaluation SOP	N
Rachel Korwek	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	N
Rachel Korwek	CO-QA-SOP-043	7	Training Procedure	N
Rachel Korwek	CO-IT-POL-022	0	Access Control Policy	N
Rachel Korwek	CO-IT-POL-023	0	Asset Management Policy	N
Rachel Korwek	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Rachel Korwek	CO-IT-POL-025	0	Code of Conduct	N
Rachel Korwek	CO-IT-POL-026	0	Cryptography Policy	N
Rachel Korwek	CO-IT-POL-027	0	Human Resource Security Policy	N
Rachel Korwek	CO-IT-POL-028	0	Information Security Policy	N
Rachel Korwek	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Rachel Korwek	CO-IT-POL-030	0	Physical Security Policy	N
Rachel Korwek	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Rachel Korwek	CO-IT-POL-032	0	Risk Management 	N
Rachel Korwek	CO-IT-POL-033	0	Third Party Management	N
Antony Brown	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Antony Brown	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Antony Brown	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Antony Brown	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Antony Brown	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
Antony Brown	CO-QC-COP-001	3	Quality Control Laboratory Code of Practice	Y
Antony Brown	CO-QC-COP-002 	2	CL2 Microbiology Lab Code of Practice	Y
Antony Brown	CO-H&S-COSHH-001	5	General Chemicals	Y
Antony Brown	CO-H&S-COSHH-002	5	Oxidising Agents	Y
Antony Brown	CO-H&S-COSHH-003	5	Flammable Materials	Y
Antony Brown	CO-H&S-COSHH-004	5	Chlorinated Solvents	Y
Antony Brown	CO-H&S-COSHH-005	5	Corrosive Bases	Y
Antony Brown	CO-H&S-COSHH-006	5	Corrosive Acids	Y
Antony Brown	CO-H&S-COSHH-007	5	COSHH assessment for general Hazard Group 2 organisms	Y
Antony Brown	CO-H&S-COSHH-008	5	COSHH assessment for Hazard Group 2 respiratory pathogens	Y
Antony Brown	CO-H&S-COSHH-009	4	COSHH Risk Assessment for Hazard Group 1 Pathogens	Y
Antony Brown	CO-H&S-COSHH-010	6	COSHH Risk assessment for clinical samples	Y
Antony Brown	CO-H&S-COSHH-012	5	Inactivated Micro-organisms	Y
Antony Brown	CO-H&S-P-001	9	Health & Safety Policy	Y
Antony Brown	CO-H&S-P-002	6	PAT Policy	Y
Antony Brown	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
Antony Brown	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
Antony Brown	CO-H&S-PRO-003	5	Health and Safety Manual Handling	Y
Antony Brown	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
Antony Brown	CO-H&S-RA-001	3	Risk Assessment for binx Health office and non-laboratory area	Y
Antony Brown	CO-H&S-RA-003	4	Risk Assessment for laboratory areas (excluding Microbiology and Pilot Line)	Y
Antony Brown	CO-H&S-RA-004	5	Risk Assessment for io reader / assay development tools	Y
Antony Brown	CO-H&S-RA-005	3	Dangerous and Explosive Atmosphere Risk Assessment	Y
Antony Brown	CO-H&S-RA-006	5	Risk Assessment for use of UV irradiation in the binx health Laboratories	Y
Antony Brown	CO-H&S-RA-007	4	RA Pilot Line Lab Area	Y
Antony Brown	CO-H&S-RA-008	3	Risk Assessment for binx Health Employees	Y
Antony Brown	CO-H&S-RA-009	3	Risk Assessment for use of Chemicals / Microorganisms	Y
Antony Brown	CO-H&S-RA-011	6	Covid-19 Risk Assessment binx Health ltd	Y
Antony Brown	CO-DES-SOP-029	10	Design and Development Procedure	Y
Antony Brown	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
Antony Brown	CO-DES-SOP-041	6	Design Review Work Instruction	Y
Antony Brown	CO-DES-SOP-004	4	Software Development Procedure	Y
Antony Brown	CO-DES-SOP-042	3	Creation and maintenance of a Device Master Record	Y
Antony Brown	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Antony Brown	CO-QA-SOP-098	7	Document Matrix	N
Antony Brown	CO-QA-SOP-139	15	Change Management	Y
Antony Brown	CO-OPS-SOP-035	3	Engineering Drawing Control	Y
Antony Brown	CO-QA-SOP-026	5	Use of Sharepoint	Y
Antony Brown	CO-OPS-SOP-036	2	Instrument Engineering Change Management	Y
Antony Brown	CO-QA-SOP-028	8	Quality Records	Y
Antony Brown	CO-SUP-SOP-048	3	Raise PO Non Stock and Services	Y
Antony Brown	CO-SUP-SOP-049	4	Receive non sock PO 	Y
Antony Brown	CO-SUP-SOP-055	2	Goods Movement 	Y
Antony Brown	CO-SUP-SOP-057	2	Consume to cost centre or Project 	Y
Antony Brown	CO-SUP-SOP-065	2	Complete a timesheet	Y
Antony Brown	CO-LAB-SOP-300	5	Preparation of Sub-circuit cards for voltammetric detection	Y
Antony Brown	CO-LAB-SOP-290	3	Running Clinical Samples in io Readers	Y
Antony Brown	CO-LAB-SOP-155	8	Lab book write up	Y
Antony Brown	CO-LAB-SOP-156	9	Lab rough notes	Y
Antony Brown	CO-LAB-SOP-013	6	Balance calibration	Y
Antony Brown	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
Antony Brown	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	Y
Antony Brown	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	Y
Antony Brown	CO-LAB-SOP-137	7	Monitoring Variable Temperature Apparatus	Y
Antony Brown	CO-LAB-SOP-108	20	Laboratory cleaning SOP	Y
Antony Brown	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	Y
Antony Brown	CO-LAB-SOP-102	4	Use of the Grant XB2 Ultrasonic Bath	Y
Antony Brown	CO-LAB-SOP-149	5	Introducing New Laboratory Equipment	Y
Antony Brown	CO-LAB-SOP-003	3	Validation of Temperature Controlled Equipemnt	Y
Antony Brown	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
Antony Brown	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
Antony Brown	CO-LAB-SOP-164	3	Operation and Maintenance of HT24-2P Bambi Compressor and DSIS Sealer	Y
Antony Brown	CO-LAB-SOP-005	3	Rhychiger Heat Sealer	Y
Antony Brown	CO-OPS-SOP-165	1	Windows Software Up-date	Y
Antony Brown	CO-OPS-SOP-007	2	Firmware Up-date	Y
Antony Brown	CO-OPS-SOP-166	2	Pneumatics Test Rig Set Up and Calibration	Y
Antony Brown	CO-OPS-SOP-187	3	Force Test Rig Set Up and Calibration	Y
Antony Brown	CO-OPS-SOP-008	3	Thermal Test Rig Set Up and Calibration	Y
Antony Brown	CO-LAB-SOP-167	5	Attaching Electrode/Blister Adhesive and Blister Pack	Y
Antony Brown	CO-LAB-SOP-169	3	Fermant Pouch Sealer (Pilot Line)	Y
Antony Brown	CO-LAB-SOP-170	3	Rapid PCR Rig Work Instructions	Y
Antony Brown	CO-LAB-SOP-130	2	Heat Detection Rig Work Instructions	Y
Antony Brown	CO-OPS-SOP-172	3	Tool Changes of the Rhychiger Heat Sealer 	Y
Antony Brown	CO-LAB-SOP-020	2	Use of the Hulme Martin Impulse Sealer in DNA free	Y
Antony Brown	CO-OPS-SOP-174	2	Engineering Rework Procedure 	Y
Antony Brown	CO-LAB-SOP-176	2	SOP to provide guidance for IQC's	Y
Antony Brown	CO-LAB-SOP-178	1	Signal Analyser	Y
Antony Brown	CO-LAB-SOP-184	2	Pilot Line Blister Filling and Sealing Procedure	Y
Antony Brown	CO-QC-SOP-185	1	Use of the SB3 Rotator	Y
Antony Brown	CO-CA-SOP-081	2	Collection of Human samples for QA purposes	Y
Antony Brown	CO-QA-SOP-003	17	Non Conformance Procedure	Y
Antony Brown	CO-QA-SOP-004	12	Internal Audit	Y
Antony Brown	CO-QA-SOP-077	10	Supplier Audit Procedure	Y
Antony Brown	CO-QA-SOP-076	8	Product Complaint Handling	Y
Antony Brown	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
Antony Brown	CO-QA-SOP-007	5	Correction Removal and Recall Procedure	N
Antony Brown	CO-QA-SOP-345	4	Tools for Root Cause Analysis	Y
Antony Brown	CO-QA-SOP-267	7	Post Market Surveillance	N
Antony Brown	CO-QA-SOP-147	3	Managing an External Regulatory Visit	Y
Antony Brown	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
Antony Brown	CO-QA-SOP-099	5	Deviation procedure	Y
Antony Brown	CO-QA-SOP-093	7	CAPA Procedure	Y
Antony Brown	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Antony Brown	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	Y
Antony Brown	CO-QA-SOP-014	2	Quality Planning Procedure	Y
Antony Brown	CO-QA-SOP-015	3	Competence of Atlas Auditors	Y
Antony Brown	CO-QA-SOP-016	1	Identification and Traceability	Y
Antony Brown	CO-SUP-SOP-002	4	Intrument service and repair	Y
Antony Brown	CO-SUP-SOP-006	2	Equipment and fulfilment and field visits	Y
Antony Brown	CO-QA-POL-021	9	Quality Manual	Y
Antony Brown	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
Antony Brown	CO-HR-POL-007	2	Training Policy	Y
Antony Brown	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
Antony Brown	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
Antony Brown	CO-QA-POL-020	8	Risk Management Policy	Y
Antony Brown	CO-CA-POL-009	3	Policy for Verification and Validation	Y
Antony Brown	CO-OPS-POL-011	2	WEEE Policy	Y
Antony Brown	CO-CS-POL-012	4	Policy for Customer Feedback and Device Vigilance	Y
Antony Brown	CO-QC-POL-018	5	Quality Control Policy	Y
Antony Brown	CO-SUP-POL-017	3	Policy for Customer Interface Order Handling Product Storage & Distribution	Y
Antony Brown	CO-QA-POL-019	6	Quality Policy	N
Antony Brown	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	Y
Antony Brown	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
Antony Brown	CO-QA-SOP-284	6	FMEA Procedure	Y
Antony Brown	CO-QA-SOP-283	4	Product Risk Management 	Y
Antony Brown	CO-SUP-SOP-068	14	Purchasing SOP	Y
Antony Brown	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Antony Brown	CO-SUP-SOP-281	7	Cartridge Component Stock Control Procedure	Y
Antony Brown	CO-SUP-SOP-072	13	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	Y
Antony Brown	CO-SUP-SOP-280	8	Setting Expiry Dates for Incoming Materials	Y
Antony Brown	CO-SUP-SOP-278	8	Pilot Line Electronic Stock Control	Y
Antony Brown	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Antony Brown	CO-SUP-SOP-277	3	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	Y
Antony Brown	CO-QC-SOP-286	3	Procedure for io Release	Y
Antony Brown	CO-QA-SOP-043	7	Training Procedure	Y
Antony Brown	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
Antony Brown	CO-OPS-SOP-188	4	Process Validation	Y
Antony Brown	CO-OPS-SOP-002	3	Planning for Process Validation	Y
Antony Brown	CO-OPS-SOP-032	3	Validation of Automated Equipment and Quality System Software	Y
Antony Brown	CO-OPS-SOP-034	3	Test Method Validation	Y
Antony Brown	CO-IT-POL-022	0	Access Control Policy	Y
Antony Brown	CO-IT-POL-023	0	Asset Management Policy	Y
Antony Brown	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
Antony Brown	CO-IT-POL-025	0	Code of Conduct	Y
Antony Brown	CO-IT-POL-026	0	Cryptography Policy	Y
Antony Brown	CO-IT-POL-027	0	Human Resource Security Policy	Y
Antony Brown	CO-IT-POL-028	0	Information Security Policy	Y
Antony Brown	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
Antony Brown	CO-IT-POL-030	0	Physical Security Policy	Y
Antony Brown	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
Antony Brown	CO-IT-POL-032	0	Risk Management 	Y
Antony Brown	CO-IT-POL-033	0	Third Party Management	Y
Henry Fatoyinbo	CO-H&S-COSHH-001	5	General Chemicals	N
Henry Fatoyinbo	CO-H&S-COSHH-002	5	Oxidising Agents	N
Henry Fatoyinbo	CO-H&S-COSHH-003	5	Flammable Materials	N
Henry Fatoyinbo	CO-H&S-COSHH-004	5	Chlorinated Solvents	N
Henry Fatoyinbo	CO-H&S-COSHH-005	5	Corrosive Bases	N
Henry Fatoyinbo	CO-H&S-COSHH-006	5	Corrosive Acids	N
Henry Fatoyinbo	CO-H&S-COSHH-007	5	COSHH assessment for general Hazard Group 2 organisms	N
Henry Fatoyinbo	CO-H&S-COSHH-008	5	COSHH assessment for Hazard Group 2 respiratory pathogens	N
Henry Fatoyinbo	CO-H&S-COSHH-009	4	COSHH Risk Assessment for Hazard Group 1 Pathogens	N
Henry Fatoyinbo	CO-H&S-COSHH-010	6	COSHH Risk assessment for clinical samples	N
Henry Fatoyinbo	CO-H&S-COSHH-012	5	Inactivated Micro-organisms	N
Henry Fatoyinbo	CO-H&S-P-001	9	Health & Safety Policy	N
Henry Fatoyinbo	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	N
Henry Fatoyinbo	CO-H&S-PRO-002	8	Chemical COSHH Guidance	N
Henry Fatoyinbo	CO-H&S-PRO-003	5	Health and Safety Manual Handling	N
Henry Fatoyinbo	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	N
Henry Fatoyinbo	CO-H&S-RA-001	3	Risk Assessment for binx Health office and non-laboratory area	N
Henry Fatoyinbo	CO-H&S-RA-003	4	Risk Assessment for laboratory areas (excluding Microbiology and Pilot Line)	N
Henry Fatoyinbo	CO-H&S-RA-004	5	Risk Assessment  io reader / assay development tools	N
Henry Fatoyinbo	CO-H&S-RA-005	3	Dangerous and Explosive Atmosphere Risk Assessment	N
Henry Fatoyinbo	CO-H&S-RA-006	5	Risk Assessment for use of UV irradiation in the binx health Laboratories	N
Henry Fatoyinbo	CO-H&S-RA-007	4	RA Pilot Line Lab Area	N
Henry Fatoyinbo	CO-H&S-RA-008	3	Risk Assessment for binx Health Employees	N
Henry Fatoyinbo	CO-H&S-RA-009	3	Risk Assessment for use of Chemicals / Microorganisms	N
Henry Fatoyinbo	CO-DES-SOP-029	10	Design and Development Procedure	N
Henry Fatoyinbo	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	N
Henry Fatoyinbo	CO-DES-SOP-041	6	Design Review Work Instruction	N
Henry Fatoyinbo	CO-DES-SOP-146	OBSOLETE	Experimental Planning and Review	N
Henry Fatoyinbo	CO-DES-SOP-004	4	Software Development Procedure	N
Henry Fatoyinbo	CO-DES-SOP-042	3	Creation and maintenance of a Device Master Record	N
Henry Fatoyinbo	CO-QA-SOP-140	18	Document Control & Control of Quality Records	N
Henry Fatoyinbo	CO-QA-SOP-098	7	Document Matrix	N
Henry Fatoyinbo	CO-QA-SOP-139	15	Change Management	N
Henry Fatoyinbo	CO-OPS-SOP-035	3	Engineering Drawing Control	N
Henry Fatoyinbo	CO-QA-SOP-026	5	Use of Sharepoint	N
Henry Fatoyinbo	CO-OPS-SOP-036	2	Instrument Engineering Change Management	N
Henry Fatoyinbo	CO-QA-SOP-028	8	Quality Records	N
Henry Fatoyinbo	CO-LAB-SOP-155	8	Lab book write up	N
Henry Fatoyinbo	CO-LAB-SOP-156	9	Lab rough notes	N
Henry Fatoyinbo	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	N
Henry Fatoyinbo	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	N
Henry Fatoyinbo	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	N
Henry Fatoyinbo	CO-LAB-SOP-108	20	Laboratory cleaning SOP	N
Henry Fatoyinbo	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	N
Henry Fatoyinbo	CO-OPS-SOP-166	2	Pneumatics Test Rig Set Up and Calibration	N
Henry Fatoyinbo	CO-OPS-SOP-187	3	Force Test Rig Set Up and Calibration	N
Henry Fatoyinbo	CO-OPS-SOP-008	3	Thermal Test Rig Set Up and Calibration	N
Henry Fatoyinbo	CO-OPS-SOP-174	2	Engineering Rework Procedure 	N
Henry Fatoyinbo	CO-QA-SOP-003	17	Non Conformance Procedure	N
Henry Fatoyinbo	CO-QA-SOP-004	12	Internal Audit	N
Henry Fatoyinbo	CO-QA-SOP-076	8	Product Complaint Handling	N
Henry Fatoyinbo	CO-QA-SOP-007	5	Correction Removal and Recall Procedure	N
Henry Fatoyinbo	CO-QA-SOP-267	7	Post Market Surveillance	N
Henry Fatoyinbo	CO-QA-SOP-099	5	Deviation procedure	N
Henry Fatoyinbo	CO-QA-SOP-093	7	CAPA Procedure	N
Henry Fatoyinbo	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Henry Fatoyinbo	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	N
Henry Fatoyinbo	CO-QA-SOP-014	2	Quality Planning Procedure	N
Henry Fatoyinbo	CO-QA-SOP-016	1	Identification and Traceability	N
Henry Fatoyinbo	CO-SUP-SOP-002	4	Intrument service and repair	N
Henry Fatoyinbo	CO-QA-POL-021	9	Quality Manual	N
Henry Fatoyinbo	CO-QA-POL-006	5	Policy for Document Control and Change Management	N
Henry Fatoyinbo	CO-HR-POL-007	2	Training Policy	N
Henry Fatoyinbo	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	N
Henry Fatoyinbo	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	N
Henry Fatoyinbo	CO-QA-POL-020	8	Risk Management Policy	N
Henry Fatoyinbo	CO-CA-POL-009	3	Policy for Verification and Validation	N
Henry Fatoyinbo	CO-QA-POL-010	4	Policy for Control of Infrastructure Environment and Equipment	N
Henry Fatoyinbo	CO-QA-POL-019	6	Quality Policy	N
Henry Fatoyinbo	CO-OPS-PTL-048	3	IO Release Procedure for Refurbished and Reworked Readers	N
Henry Fatoyinbo	CO-QA-SOP-285	6	Hazard Analysis Procedure	N
Henry Fatoyinbo	CO-QA-SOP-284	6	FMEA Procedure	N
Henry Fatoyinbo	CO-QA-SOP-283	4	Product Risk Management 	N
Henry Fatoyinbo	CO-SUP-SOP-068	14	Purchasing SOP	N
Henry Fatoyinbo	CO-SUP-SOP-069	7	Supplier Evaluation SOP	N
Henry Fatoyinbo	CO-QC-SOP-286	3	Procedure for io Release	N
Henry Fatoyinbo	CO-QA-SOP-043	7	Training Procedure	N
Henry Fatoyinbo	CO-IT-POL-022	0	Access Control Policy	N
Henry Fatoyinbo	CO-IT-POL-023	0	Asset Management Policy	N
Henry Fatoyinbo	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Henry Fatoyinbo	CO-IT-POL-025	0	Code of Conduct	N
Henry Fatoyinbo	CO-IT-POL-026	0	Cryptography Policy	N
Henry Fatoyinbo	CO-IT-POL-027	0	Human Resource Security Policy	N
Henry Fatoyinbo	CO-IT-POL-028	0	Information Security Policy	N
Henry Fatoyinbo	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Henry Fatoyinbo	CO-IT-POL-030	0	Physical Security Policy	N
Henry Fatoyinbo	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Henry Fatoyinbo	CO-IT-POL-032	0	Risk Management 	N
Henry Fatoyinbo	CO-IT-POL-033	0	Third Party Management	N
Ian Moore	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Ian Moore	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Ian Moore	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Ian Moore	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Ian Moore	CO-H&S-P-001	9	Health & Safety Policy	Y
Ian Moore	CO-H&S-P-002	6	PAT Policy	Y
Ian Moore	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
Ian Moore	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
Ian Moore	CO-H&S-PRO-003	5	Health and Safety Manual Handling	Y
Ian Moore	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
Ian Moore	CO-H&S-RA-001	3	Risk Assessment for binx Health office and non-laboratory area	Y
Ian Moore	CO-H&S-RA-003	4	Risk Assessment for laboratory areas (excluding Microbiology and Pilot Line)	Y
Ian Moore	CO-H&S-RA-004	5	Risk Assessment for io  reader / assay development tools	N
Ian Moore	CO-H&S-RA-005	3	Risk Assessment for binx Health Employees	Y
Ian Moore	CO-H&S-RA-006	3	Risk Assessment for use of Chemicals / Microorganisms	Y
Ian Moore	CO-DES-SOP-004	4	Software Development Procedure	Y
Ian Moore	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Ian Moore	CO-QA-SOP-098	7	Document Matrix	N
Ian Moore	CO-QA-SOP-139	15	Change Management	Y
Ian Moore	CO-QA-SOP-026	5	Use of Sharepoint	Y
Ian Moore	CO-OPS-SOP-036	2	Instrument Engineering Change Management	Y
Ian Moore	CO-QA-SOP-028	8	Quality Records	Y
Ian Moore	CO-LAB-SOP-155	8	Lab book write up	Y
Ian Moore	CO-LAB-SOP-156	9	Lab rough notes	Y
Ian Moore	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
Ian Moore	CO-LAB-SOP-145	4	Storage and Safe handling of Biohazardous Materials	Y
Ian Moore	CO-LAB-SOP-151	10	Management and Control of Critical and Controlled equipment	Y
Ian Moore	CO-LAB-SOP-108	20	Laboratory cleaning SOP	Y
Ian Moore	CO-QC-SOP-094	5	Procedure to control chemical and biological spillages	Y
Ian Moore	CO-LAB-SOP-149	5	Introducing New Laboratory Equipment	N
Ian Moore	CO-LAB-SOP-138	4	Use of temperature and humidity loggers	Y
Ian Moore	CO-LAB-SOP-095	5	External and repair Cleaning for io readers used at Atlas	Y
Ian Moore	CO-LAB-SOP-163	8	Running End to End CT cartridges on io Readers	Y
Ian Moore	CO-OPS-SOP-165	1	Windows Software Up-date	Y
Ian Moore	CO-OPS-SOP-007	2	Firmware Up-date	Y
Ian Moore	CO-OPS-SOP-166	2	Pneumatics Test Rig Set Up and Calibration	Y
Ian Moore	CO-OPS-SOP-187	3	Force Test Rig Set Up and Calibration	Y
Ian Moore	CO-OPS-SOP-008	3	Thermal Test Rig Set Up and Calibration	Y
Ian Moore	CO-LAB-SOP-167	5	Attaching Electrode/Blister Adhesive and Blister Pack	Y
Ian Moore	CO-OPS-SOP-009	2	Reader Peltier Refit procedure	Y
Ian Moore	CO-LAB-SOP-170	3	Rapid PCR Rig Work Instructions	Y
Ian Moore	CO-OPS-SOP-172	3	Tool Changes of the Rhychiger Heat Sealer 	Y
Ian Moore	CO-OPS-SOP-174	2	Engineering Rework Procedure 	Y
Ian Moore	CO-LAB-SOP-178	1	Signal Analyser	Y
Ian Moore	CO-LAB-SOP-184	2	Pilot Line Blister Filling and Sealing Procedure	Y
Ian Moore	CO-QC-SOP-185	1	Use of the SB3 Rotator	Y
Ian Moore	CO-CA-SOP-081	2	Collection of Human samples for QA purposes	Y
Ian Moore	CO-QA-SOP-003	17	Non Conformance Procedure	Y
Ian Moore	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
Ian Moore	CO-QA-SOP-093	7	CAPA Procedure	Y
Ian Moore	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Ian Moore	CO-QA-SOP-016	1	Identification and Traceability	Y
Ian Moore	CO-SUP-SOP-006	2	Equipment and fulfilment and field visits	Y
Ian Moore	CO-QA-POL-021	9	Quality Manual	Y
Ian Moore	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
Ian Moore	CO-HR-POL-007	2	Training Policy	Y
Ian Moore	CO-OPS-POL-008	4	Policy for Purchasing and Management of Suppliers	Y
Ian Moore	CO-QA-POL-020	8	Risk Management Policy	Y
Ian Moore	CO-CA-POL-009	3	Policy for Verification and Validation	Y
Ian Moore	CO-QA-POL-010	4	Policy for Control of Infrastructure Environment and Equipment	Y
Ian Moore	CO-QA-POL-019	6	Quality Policy	N
Ian Moore	CO-SUP-SOP-068	14	Purchasing SOP	N
Ian Moore	CO-SUP-SOP-281	7	Cartridge Component Stock Control Procedure	Y
Ian Moore	CO-SUP-SOP-072	13	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	N
Ian Moore	CO-QA-SOP-043	7	Training Procedure	Y
Ian Moore	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
Ian Moore	CO-OPS-SOP-188	4	Process Validation	Y
Ian Moore	CO-OPS-SOP-032	3	Validation of Automated Equipment and Quality System Software	Y
Ian Moore	CO-IT-POL-022	0	Access Control Policy	N
Ian Moore	CO-IT-POL-023	0	Asset Management Policy	N
Ian Moore	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Ian Moore	CO-IT-POL-025	0	Code of Conduct	N
Ian Moore	CO-IT-POL-026	0	Cryptography Policy	N
Ian Moore	CO-IT-POL-027	0	Human Resource Security Policy	N
Ian Moore	CO-IT-POL-028	0	Information Security Policy	N
Ian Moore	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Ian Moore	CO-IT-POL-030	0	Physical Security Policy	N
Ian Moore	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Ian Moore	CO-IT-POL-032	0	Risk Management 	N
Ian Moore	CO-IT-POL-033	0	Third Party Management	N
Jawaad Bhatti	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Jawaad Bhatti	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	N
Jawaad Bhatti	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	N
Jawaad Bhatti	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Jawaad Bhatti	CO-H&S-P-001	9	Health & Safety Policy	N
Jawaad Bhatti	CO-H&S-P-003	1	Stress Policy 	Y
Jawaad Bhatti	CO-H&S-PRO-001	9	Health and Safety Fire Related Procedures	Y
Jawaad Bhatti	CO-H&S-PRO-002	8	Chemical COSHH Guidance	Y
Jawaad Bhatti	CO-H&S-PRO-003	5	Health and Safety Manual Handling	N
Jawaad Bhatti	CO-H&S-PRO-004	4	Health & Safety Incident and Near Miss Reporting Procedure	Y
Jawaad Bhatti	CO-DES-SOP-029	10	Design and Development Procedure	Y
Jawaad Bhatti	CO-DES-SOP-041	6	Design Review Work Instruction	Y
Jawaad Bhatti	CO-QA-SOP-140	18	Document Control & Control of Quality Records	N
Jawaad Bhatti	CO-QA-SOP-098	7	Document Matrix	N
Jawaad Bhatti	CO-QA-SOP-139	15	Change Management	N
Jawaad Bhatti	CO-QA-SOP-026	5	Use of Sharepoint	Y
Jawaad Bhatti	CO-QA-SOP-028	8	Quality Records	Y
Jawaad Bhatti	CO-QA-SOP-005	5	Document and Records Archiving	Y
Jawaad Bhatti	CO-SUP-SOP-048	3	Raise PO Non Stock and Services	Y
Jawaad Bhatti	CO-SUP-SOP-049	4	Receive non sock PO 	Y
Jawaad Bhatti	CO-LAB-SOP-103	12	Environmental Control in the Laboratory	Y
Jawaad Bhatti	CO-QA-SOP-003	17	Non Conformance Procedure	N
Jawaad Bhatti	CO-QA-SOP-076	8	Product Complaint Handling	N
Jawaad Bhatti	CO-QA-SOP-099	5	Deviation procedure	N
Jawaad Bhatti	CO-QA-SOP-093	7	CAPA Procedure	N
Jawaad Bhatti	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Jawaad Bhatti	CO-QA-SOP-016	1	Identification and Traceability	Y
Jawaad Bhatti	CO-QA-POL-021	9	Quality Manual	N
Jawaad Bhatti	CO-HR-POL-007	2	Training Policy	Y
Jawaad Bhatti	CO-SUP-SOP-068	14	Purchasing SOP	N
Jawaad Bhatti	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Jawaad Bhatti	CO-QA-SOP-043	7	Training Procedure	Y
Jawaad Bhatti	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
Jawaad Bhatti	CO-IT-POL-022	0	Access Control Policy	N
Jawaad Bhatti	CO-IT-POL-023	0	Asset Management Policy	N
Jawaad Bhatti	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Jawaad Bhatti	CO-IT-POL-025	0	Code of Conduct	N
Jawaad Bhatti	CO-IT-POL-026	0	Cryptography Policy	N
Jawaad Bhatti	CO-IT-POL-027	0	Human Resource Security Policy	N
Jawaad Bhatti	CO-IT-POL-028	0	Information Security Policy	N
Jawaad Bhatti	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Jawaad Bhatti	CO-IT-POL-030	0	Physical Security Policy	N
Jawaad Bhatti	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Jawaad Bhatti	CO-IT-POL-032	0	Risk Management 	N
Jawaad Bhatti	CO-IT-POL-033	0	Third Party Management	N
Sean Barnes	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Sean Barnes	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Sean Barnes	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Sean Barnes	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Sean Barnes	CO-H&S-P-001	9	Health & Safety Policy	Y
Sean Barnes	CO-DES-SOP-029	10	Design and Development Procedure	Y
Sean Barnes	CO-DES-SOP-004	4	Software Development Procedure	Y
Sean Barnes	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Sean Barnes	CO-QA-SOP-098	7	Document Matrix	Y
Sean Barnes	CO-QA-SOP-139	15	Change Management	N
Sean Barnes	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Sean Barnes	CO-QA-SOP-026	5	Use of Sharepoint	Y
Sean Barnes	CO-QA-SOP-028	8	Quality Records	Y
Sean Barnes	CO-QA-SOP-003	17	Non Conformance Procedure	Y
Sean Barnes	CO-QA-SOP-076	8	Product Complaint Handling	N
Sean Barnes	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	N
Sean Barnes	CO-QA-SOP-093	7	CAPA Procedure	N
Sean Barnes	CO-QA-SOP-012	8	Annual Quality Objectives 	Y
Sean Barnes	CO-QA-POL-021	9	Quality Manual	N
Sean Barnes	CO-HR-POL-007	2	Training Policy	Y
Sean Barnes	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
Sean Barnes	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
Sean Barnes	CO-QA-SOP-284	6	FMEA Procedure	Y
Sean Barnes	CO-QA-SOP-283	4	Product Risk Management 	Y
Sean Barnes	CO-SUP-SOP-068	14	Purchasing SOP	Y
Sean Barnes	CO-SUP-SOP-069	7	Supplier Evaluation SOP	N
Sean Barnes	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Sean Barnes	CO-QA-SOP-043	7	Training Procedure	Y
Sean Barnes	CO-IT-POL-022	0	Access Control Policy	Y
Sean Barnes	CO-IT-POL-023	0	Asset Management Policy	N
Sean Barnes	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	N
Sean Barnes	CO-IT-POL-025	0	Code of Conduct	N
Sean Barnes	CO-IT-POL-026	0	Cryptography Policy	N
Sean Barnes	CO-IT-POL-027	0	Human Resource Security Policy	N
Sean Barnes	CO-IT-POL-028	0	Information Security Policy	N
Sean Barnes	CO-IT-POL-029	0	Information Security Roles and Responsibilities	N
Sean Barnes	CO-IT-POL-030	0	Physical Security Policy	N
Sean Barnes	CO-IT-POL-031	0	Responsible Disclosure Policy	N
Sean Barnes	CO-IT-POL-032	0	Risk Management 	N
Sean Barnes	CO-IT-POL-033	0	Third Party Management	N
Alan Alpert	CO-QA-POL-015	0	Policy for the use of Electronic Signatures within binx health	Y
Alan Alpert	CO-QA-SOP-030	2	Accessing and Finding Documents in QT9	Y
Alan Alpert	CO-QA-SOP-031	2	Revising and Introducing Documents in QT9	Y
Alan Alpert	CO-QA-SOP-237	0	QT9 - Periodic Review and Making Documents Obsolete	Y
Alan Alpert	CO-QA-SOP-274	0	Applicable Standards Management Procedure	Y
Alan Alpert	CO-H&S-P-001	9	Health & Safety Policy	Y
Alan Alpert	CO-DES-SOP-029	10	Design and Development Procedure	Y
Alan Alpert	CO-DES-SOP-243	6	CE Mark/Technical File Procedure	Y
Alan Alpert	CO-DES-SOP-004	4	Software Development Procedure	Y
Alan Alpert	CO-QA-SOP-140	18	Document Control & Control of Quality Records	Y
Alan Alpert	CO-QA-SOP-098	7	Document Matrix	Y
Alan Alpert	CO-QA-SOP-139	15	Change Management	Y
Alan Alpert	CO-IT-SOP-044	4	IT Management Back Up and Support	Y
Alan Alpert	CO-QA-SOP-026	5	Use of Sharepoint	Y
Alan Alpert	CO-QA-SOP-028	8	Quality Records	Y
Alan Alpert	CO-QA-SOP-003	17	Non Conformance Procedure	Y
Alan Alpert	CO-QA-SOP-077	10	Supplier Audit Procedure	Y
Alan Alpert	CO-QA-SOP-076	8	Product Complaint Handling	Y
Alan Alpert	CO-QA-SOP-326	7	Vigilance and Medical Reporting Procedure	Y
Alan Alpert	CO-QA-SOP-345	4	Tools for Root Cause Analysis	Y
Alan Alpert	CO-QA-SOP-267	7	Post Market Surveillance	N
Alan Alpert	CO-QA-SOP-011	6	Supplier Corrective Action Response Procedure	Y
Alan Alpert	CO-QA-SOP-099	5	Deviation procedure	Y
Alan Alpert	CO-QA-SOP-093	7	CAPA Procedure	Y
Alan Alpert	CO-QA-SOP-012	8	Annual Quality Objectives 	N
Alan Alpert	CO-QA-SOP-096	5	Monitoring and Reporting of Quality Data	Y
Alan Alpert	CO-QA-SOP-014	2	Quality Planning Procedure	Y
Alan Alpert	CO-QA-POL-021	9	Quality Manual	Y
Alan Alpert	CO-QA-POL-006	5	Policy for Document Control and Change Management	Y
Alan Alpert	CO-HR-POL-007	2	Training Policy	Y
Alan Alpert	CO-QA-POL-014	4	Poilcy for Control of Non Conformance 	Y
Alan Alpert	CO-CA-POL-009	3	Policy for Verification and Validation	Y
Alan Alpert	CO-CS-POL-012	4	Policy for Customer Feedback and Device Vigilance	Y
Alan Alpert	CO-SUP-POL-017	3	Policy for Customer Interface Order Handling Product Storage & Distribution	Y
Alan Alpert	CO-QA-POL-019	6	Quality Policy	N
Alan Alpert	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
Alan Alpert	CO-QA-SOP-284	6	FMEA Procedure	Y
Alan Alpert	CO-QA-SOP-283	4	Product Risk Management 	Y
Alan Alpert	CO-SUP-SOP-068	14	Purchasing SOP	Y
Alan Alpert	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
Alan Alpert	CO-SUP-SOP-070	5	Supplier Risk Assessment Approval and Monitoring Procedure	Y
Alan Alpert	CO-QA-SOP-043	7	Training Procedure	Y
Alan Alpert	CO-OPS-SOP-192	3	Verification Testing Process SOP	Y
Alan Alpert	CO-IT-POL-022	0	Access Control Policy	Y
Alan Alpert	CO-IT-POL-023	0	Asset Management Policy	Y
Alan Alpert	CO-IT-POL-024	0	Business Continuity and Disaster Recovery	Y
Alan Alpert	CO-IT-POL-025	0	Code of Conduct	Y
Alan Alpert	CO-IT-POL-026	0	Cryptography Policy	Y
Alan Alpert	CO-IT-POL-027	0	Human Resource Security Policy	Y
Alan Alpert	CO-IT-POL-028	0	Information Security Policy	Y
Alan Alpert	CO-IT-POL-029	0	Information Security Roles and Responsibilities	Y
Alan Alpert	CO-IT-POL-030	0	Physical Security Policy	Y
Alan Alpert	CO-IT-POL-031	0	Responsible Disclosure Policy	Y
Alan Alpert	CO-IT-POL-032	0	Risk Management 	Y
Alan Alpert	CO-IT-POL-033	0	Third Party Management	Y
\.


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.documents_id_seq', 462, true);


--
-- Name: email_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.email_log_id_seq', 1, false);


--
-- Name: escalation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.escalation_id_seq', 1, false);


--
-- Name: job_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.job_documents_id_seq', 72, true);


--
-- Name: job_titles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.job_titles_id_seq', 28, true);


--
-- Name: orgchart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.orgchart_id_seq', 168, true);


--
-- Name: relationship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.relationship_id_seq', 132, true);


--
-- Name: team_members_id_id; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.team_members_id_id', 3, true);


--
-- Name: training_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.training_record_id_seq', 952, true);


--
-- Name: training_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.training_status_id_seq', 838, true);


--
-- Name: transaction_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.transaction_log_id_seq', 1, false);


--
-- Name: transaction_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.transaction_type_id_seq', 21, true);


--
-- Name: user_jobtitle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.user_jobtitle_id_seq', 35, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.users_id_seq', 124, true);


--
-- Name: userstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: binxenlightenmentdb
--

SELECT pg_catalog.setval('public.userstate_id_seq', 957, true);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: email_log email_log_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.email_log
    ADD CONSTRAINT email_log_pkey PRIMARY KEY (id);


--
-- Name: escalation escalation_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.escalation
    ADD CONSTRAINT escalation_pkey PRIMARY KEY (id);


--
-- Name: job_titles job_titles_team_id_name_key; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.job_titles
    ADD CONSTRAINT job_titles_team_id_name_key UNIQUE (team_id, name);


--
-- Name: orgchart orgchart_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.orgchart
    ADD CONSTRAINT orgchart_pkey PRIMARY KEY (id);


--
-- Name: relationship relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_pkey PRIMARY KEY (id);


--
-- Name: training_record training_record_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.training_record
    ADD CONSTRAINT training_record_pkey PRIMARY KEY (id);


--
-- Name: training_history training_status_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.training_history
    ADD CONSTRAINT training_status_pkey PRIMARY KEY (id);


--
-- Name: transaction_log transaction_log_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.transaction_log
    ADD CONSTRAINT transaction_log_pkey PRIMARY KEY (id);


--
-- Name: transaction_type transaction_type_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_pkey PRIMARY KEY (id);


--
-- Name: user_jobtitle user_jobtitle_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.user_jobtitle
    ADD CONSTRAINT user_jobtitle_pkey PRIMARY KEY (user_id, job_title_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: userstate userstate_pkey; Type: CONSTRAINT; Schema: public; Owner: binxenlightenmentdb
--

ALTER TABLE ONLY public.userstate
    ADD CONSTRAINT userstate_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

