--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

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
-- Name: training; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE training WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE training OWNER TO postgres;

\connect training

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: current_state_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_state_documents (
    id integer NOT NULL,
    documentcode character varying(30) NOT NULL,
    documentname character varying(150),
    rev character varying(30) NOT NULL,
    department character varying(50),
    doctype character varying(50),
    doccategory character varying(50),
    sitename character varying(30),
    docreference character varying(50),
    status character varying(30)
);


ALTER TABLE public.current_state_documents OWNER TO postgres;

--
-- Name: current_state_documents2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_state_documents2 (
    id integer NOT NULL,
    doc_id character varying(10) NOT NULL,
    documentcode character varying(30) NOT NULL,
    rev character varying(30) NOT NULL
);


ALTER TABLE public.current_state_documents2 OWNER TO postgres;

--
-- Name: current_state_documents2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.current_state_documents2 ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.current_state_documents2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: current_state_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.current_state_documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.current_state_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100),
    email_address character varying,
    firstname character varying(100),
    surname character varying(100),
    active boolean DEFAULT true,
    "isAdmin" boolean DEFAULT false NOT NULL,
    "isManager" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: userstate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userstate (
    id integer NOT NULL,
    employee_name character varying(100) NOT NULL,
    qt9_document_code character varying(100) NOT NULL,
    revision character varying(100) NOT NULL,
    title character varying(100) NOT NULL,
    trained character varying(100) NOT NULL
);


ALTER TABLE public.userstate OWNER TO postgres;

--
-- Name: current_state_documents_view; Type: VIEW; Schema: public; Owner: postgres
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


ALTER VIEW public.current_state_documents_view OWNER TO postgres;

--
-- Name: document_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_list (
    id integer NOT NULL,
    documentqtid character varying(30),
    documenttitle character varying(150),
    documenttype integer,
    risklevel integer,
    doc_id character varying
);


ALTER TABLE public.document_list OWNER TO postgres;

--
-- Name: document_list2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_list2 (
    doc_id integer,
    documentqtid character varying(30),
    documenttitle character varying(150),
    documenttype integer,
    risklevel integer
);


ALTER TABLE public.document_list2 OWNER TO postgres;

--
-- Name: document_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.document_list ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.document_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_type (
    id integer NOT NULL,
    documentcode character varying(50),
    documenttype character varying(100)
);


ALTER TABLE public.document_type OWNER TO postgres;

--
-- Name: document_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.document_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.document_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: documents_temp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents_temp (
    doc_id character varying(100),
    documentcode character varying(50) NOT NULL,
    documentname character varying(150) NOT NULL,
    rev character varying(50) NOT NULL,
    department character varying(100) NOT NULL,
    documenttype character varying(50) NOT NULL,
    risklevel integer NOT NULL
);


ALTER TABLE public.documents_temp OWNER TO postgres;

--
-- Name: escalation_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escalation_state (
    id integer NOT NULL,
    delay_in_hours integer,
    state_name character varying(100),
    email_text character varying(250)
);


ALTER TABLE public.escalation_state OWNER TO postgres;

--
-- Name: job_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_documents (
    id integer NOT NULL,
    doc_id integer NOT NULL,
    job_id integer NOT NULL
);


ALTER TABLE public.job_documents OWNER TO postgres;

--
-- Name: job_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: job_titles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_titles (
    id integer NOT NULL,
    team_id integer,
    name character varying(150),
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.job_titles OWNER TO postgres;

--
-- Name: job_titles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: relationship; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relationship (
    id integer NOT NULL,
    manager_email character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL
);


ALTER TABLE public.relationship OWNER TO postgres;

--
-- Name: managers; Type: VIEW; Schema: public; Owner: postgres
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


ALTER VIEW public.managers OWNER TO postgres;

--
-- Name: orgchart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orgchart (
    id integer NOT NULL,
    user_id integer,
    manager_id integer
);


ALTER TABLE public.orgchart OWNER TO postgres;

--
-- Name: orgchart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: relationship_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: team_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_members (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_is_manager boolean NOT NULL,
    team_id integer
);


ALTER TABLE public.team_members OWNER TO postgres;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: training_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.training_record (
    id integer NOT NULL,
    userid integer NOT NULL,
    doc_id integer NOT NULL,
    doc_version integer DEFAULT 0 NOT NULL,
    doc_priority character varying(10) DEFAULT 'low'::character varying,
    date_notified date,
    trained boolean,
    escalation_level integer DEFAULT 1,
    date_validated date,
    validated_by integer
);


ALTER TABLE public.training_record OWNER TO postgres;

--
-- Name: training_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: training_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.training_status (
    id integer NOT NULL,
    userid integer NOT NULL,
    documentid integer NOT NULL,
    usercurrentrevision character varying(10),
    training_complete boolean,
    training_complete_date timestamp without time zone
);


ALTER TABLE public.training_status OWNER TO postgres;

--
-- Name: training_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.training_status ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.training_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_jobtitle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_jobtitle (
    id integer NOT NULL,
    user_id integer,
    job_title_id integer
);


ALTER TABLE public.user_jobtitle OWNER TO postgres;

--
-- Name: user_jobtitle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: user_training_needed; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.user_training_needed AS
 SELECT DISTINCT ts.userid,
    u.username,
    u.email_address,
    dl.doc_id AS documentid,
    dl.documentqtid,
    dl.documenttitle,
    ts.usercurrentrevision,
    csd.rev,
    dl.risklevel
   FROM (((public.training_status ts
     JOIN public.document_list2 dl ON ((dl.doc_id = ts.documentid)))
     JOIN public.current_state_documents_view csd ON (((csd.documentcode)::text = (dl.documentqtid)::text)))
     JOIN public.users u ON ((u.id = ts.userid)))
  WHERE (((ts.usercurrentrevision)::integer < (csd.rev)::integer) OR ((ts.training_complete_date IS NULL) AND ((ts.usercurrentrevision)::text = '0'::text)))
  ORDER BY ts.userid, dl.documentqtid;


ALTER VIEW public.user_training_needed OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: userstate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Data for Name: current_state_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.current_state_documents (id, documentcode, documentname, rev, department, doctype, doccategory, sitename, docreference, status) FROM stdin;
1	CO-OPS-PTL-050	Factory Acceptance Test (FAT)  TQC in-line leak test equipment	0	Operations	Protocol	QMS	Corporate		Active
2	CO-LAB-FRM-086	‘0260 CT Forward Primer from SGS DNA’	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0260	Active
3	CO-LAB-FRM-097	‘0271 gyrA_F_Fwd primer’	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0271	Active
4	CO-LAB-FRM-096	‘25U/µL Taq-B DNA Polymerase (Low Glycerol)’ Part Number 0270	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0270	Active
5	CO-LAB-FRM-059	‘50mM dUTP MIX’ Part no. 0088	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0088	Active
6	CO-LAB-FRM-077	‘Albumin from bovine serum – New Zealand Source’ Part Number: 0219	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0219	Active
7	CO-LAB-FRM-108	‘CT di452 Probe from SGS’ Part No. 0289	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0289	Active
8	CO-LAB-FRM-106	‘CT/NG: CT/IC Detection Reagent	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0281	Active
9	CO-LAB-FRM-100	‘CT/NG: IC DNA Reagent	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0275	Active
10	CO-LAB-FRM-101	‘CT/NG: NG1/NG2/IC Primer Passivation Reagent	9	Laboratory	Forms	QMS	Corporate	QS-IQC-0276	Active
11	CO-LAB-FRM-104	‘CT/NG: NG2/IC Detection Reagent	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0279	Active
12	CO-LAB-FRM-102	‘CT/NG: TaqUNG Reagent	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0277	Active
13	CO-LAB-FRM-080	‘DNase Alert Buffer’ Part Number 0241	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0241	Active
14	CO-LAB-FRM-081	‘DNase Alert Substrate’ Part Number 0242	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0242	Active
15	CO-LAB-FRM-062	‘Guanidine Thiocyanate’ Part Number: 0094	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0094	Active
16	CO-LAB-FRM-137	‘HS anti-Taq mAb (5.7 mg/mL)’ Part no: 0340	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0340	Active
17	CO-LAB-FRM-107	‘IC di275 Probe from SGS’ Part No. 0288	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0288	Active
18	CO-LAB-FRM-063	‘MES’ Part No. 0095	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0095	Active
19	CO-LAB-FRM-152	‘N-5 Loop-B Primer’ Material binx Part Number 0368	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0368	Active
20	CO-LAB-FRM-151	‘N-5 Loop-F-T7 Primer’ Material binx Part Number 0367	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0367	Active
21	CO-LAB-FRM-148	‘N-5B3 Primer’ Material binx Part Number 0364	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0364	Active
22	CO-LAB-FRM-150	‘N-5BIP Primer’ Material binx Part Number 0366	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0366	Active
23	CO-LAB-FRM-147	‘N-5F3 Primer’ Material binx Part Number 0363	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0363	Active
24	CO-LAB-FRM-149	‘N-5FIP Primer’ Material binx Part Number 0365	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0365	Active
25	CO-LAB-FRM-162	‘NATtrol™ SARS-CoV-2 External Run Control’ Material binx Part Number 0403	1	Laboratory	Forms	QMS	Corporate	QS-QC-0403	Active
26	CO-LAB-FRM-163	‘NATtrol™ SARS-CoV-2 Negative Control’ Material binx Part Number 0404	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0404	Active
27	CO-LAB-FRM-160	‘N-crRNA’ Material binx Part Number 0400	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0400	Active
28	CO-LAB-FRM-099	‘Neisseria gonorrhoeae DNA’ Part Number 0273	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0273	Active
29	CO-LAB-FRM-143	‘ORF1ab-B3 Primer’ Material binx Part Number 0359	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0359	Active
30	CO-LAB-FRM-145	‘ORF1ab-BIP Primer’ Material binx Part Number 0361	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0361	Active
31	CO-LAB-FRM-159	‘ORF1ab-crRNA’ Material binx Part Number 0399	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0399	Active
32	CO-LAB-FRM-142	‘ORF1ab-F3 Primer’ Material binx Part Number 0358	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0358	Active
33	CO-LAB-FRM-144	‘ORF1ab-FIP Primer’ Material binx Part Number 0360	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0360	Active
34	CO-LAB-FRM-146	‘ORF1ab-Loop-F-T7 Primer’ Material binx Part Number 0362	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0362	Active
35	CO-LAB-FRM-072	‘Part No. 0148 DL-Dithiothreitol’	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0148	Active
36	CO-LAB-FRM-138	‘Potassium Chloride Solution’ Part Number: 0341	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0341	Active
37	CO-LAB-FRM-158	‘RP Loop-B-T7 Primer’ Material binx Part Number 0374	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0374	Active
38	CO-LAB-FRM-154	‘RP-B3 Primer’ Material binx Part Number 0370	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0370	Active
39	CO-LAB-FRM-156	‘RP-BIP Primer’ Material binx Part Number 0372	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0372	Active
40	CO-LAB-FRM-161	‘RP-crRNA’ Material binx Part Number 0401	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0401	Active
41	CO-LAB-FRM-153	‘RP-F3 Primer’ Material binx Part Number 0369	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0369	Active
42	CO-LAB-FRM-155	‘RP-FIP Primer’ Material binx Part Number 0371	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0371	Active
43	CO-LAB-FRM-157	‘RP-Loop-F Primer’ Material binx Part Number 0373	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0373	Active
44	CO-LAB-FRM-055	‘Safe View DNA Stain’  Part Number 0079	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0079	Active
45	CO-LAB-FRM-119	‘Trichomonas vaginalis Cultured Stock’ P/N:0310	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0310	Active
46	CO-LAB-FRM-139	‘Tris (1M) pH8.0’ Part no: 0342	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0342	
47	CO-LAB-FRM-053	‘TRIS (TRIZMA®) HYDROCHLORIDE’ Part Number: 0011	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0011	Active
48	CO-LAB-FRM-127	‘TV_Alt_6_Fwd’ Part No. 0330 from SGS DNA	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0330	Active
49	CO-LAB-FRM-128	‘TV_Alt_6_Rev’ Part No 0331 from SGS DNA	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0331	Active
50	CO-LAB-FRM-129	‘TV_Alt_A di452 Probe from SGS’ Part Number 0332	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0332	Active
51	CO-LAB-FRM-079	‘Uracil DNA Glycosylase [50000 U/mL]’ Part Number 0240	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0240	
52	CO-LAB-FRM-075	‘γ Aminobutyric acid’ Part Number: 0178	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0178	Active
53	CO-PRD1-FRM-231	0.5M EDTA Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
54	CO-LAB-FRM-007	0.5M EDTA solution	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0110	Active
55	CO-OPS-SOP-109	1 x lysis buffer	9	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-013	Active
56	CO-DPT-IFU-013	1 2 3 At-Home Card (English Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate		
57	CO-LAB-FRM-005	100bp low MW Ladder	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0053	Active
58	CO-LAB-FRM-033	100mM dATP Material binx Part Number 0392	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0392	Active
59	CO-LAB-FRM-034	100mM dCTP Material binx Part Number 0393	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0393	Active
60	CO-LAB-FRM-032	100mM dGTP Material binx Part Number 0391	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0391	Active
61	CO-LAB-FRM-031	100mM dTTP Material binx Part Number 0390	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0390	Active
62	CO-LAB-FRM-030	100mM dUTP Material binx Part Number 0389	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0389	Active
63	CO-LAB-FRM-125	10x TBE electrophoresis buffer Part Number 0326	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0326	Active
64	CO-LAB-FRM-073	1L Nalgene Disposable Filter Unit’ Part No. 0167	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0167	Active
65	CO-LAB-FRM-068	1M Magnesium Chloride solution molecular biology grade Part No. 0115	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0115	
66	CO-DPT-BOM-002	2.600.002 (CG + Blood Male) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
67	CO-DPT-BOM-001	2.600.003 (CG3 Male) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
68	CO-DPT-BOM-003	2.600.004 (CG + Blood + Blood Male) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
69	CO-DPT-BOM-005	2.600.006 (CG3 + Blood Male) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
70	CO-DPT-BOM-006	2.600.006-001 (CG3 + Blood Male	BAO) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
71	CO-DPT-BOM-007	2.600.007 (CG3 + Blood + Blood Male) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
72	CO-DPT-BOM-008	2.600.008 (CG Male) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
73	CO-DPT-BOM-004	2.600.500 (Blood	Unisex) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
74	CO-DPT-BOM-009	2.600.902 (CG + Blood Female) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
75	CO-DPT-BOM-010	2.600.903 (CG3 Female) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
76	CO-DPT-BOM-011	2.600.904 (CG + Blood + Blood Female) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
77	CO-DPT-BOM-012	2.600.905 (Blood + Blood	Unisex) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
78	CO-DPT-BOM-013	2.600.906 (CG3 + Blood Female) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
79	CO-DPT-BOM-014	2.600.907 (CG3 + Blood + Blood Female) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
80	CO-DPT-BOM-015	2.600.908 (CG Female) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
81	CO-DPT-BOM-016	2.600.909 (HIV USPS Blood Card) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
82	CO-DPT-BOM-017	2.601.002 (CG + Blood Male	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
83	CO-DPT-BOM-018	2.601.003 (CG Male	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
84	CO-DPT-BOM-019	2.601.005 (Blood	Unisex	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate
85	CO-DPT-BOM-020	2.601.006 (CG3 + Blood Male	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
86	CO-DPT-BOM-021	2.601.008 (CG Male	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
87	CO-DPT-BOM-022	2.601.902 (CG + Blood Female	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
88	CO-DPT-BOM-023	2.601.903 (CG3 Female	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
89	CO-DPT-BOM-024	2.601.906 (CG3 + Blood Female	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
90	CO-DPT-BOM-025	2.601.908 (CG Female	AG) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
91	CO-DPT-BOM-026	2.800.001 (ADX Blood Card (1) Fasting) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
92	CO-DPT-BOM-027	2.800.002 (ADX Blood Card (2) Fasting) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
93	CO-DPT-BOM-028	2.801.001 (ADX Blood Card (1)	Non-fasting) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
94	CO-DPT-BOM-029	2.801.002 (ADX Blood Card (2)	Non-fasting) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate	
95	CO-OPS-SOP-110	225mM Potassium phosphate buffer	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-124	Active
96	CO-LAB-FRM-010	2mL ENAT Transport media	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0138	Active
97	CO-DPT-BOM-030	5.900.444 (Blood Collection Drop-in Pack) Kit BOM	0	Digital Product Technology	Bill of Materials	QMS	Corporate		Active
98	CO-LAB-FRM-126	50bp DNA Ladder binx Part Number 0329	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0329	Active
99	CO-OPS-SOP-111	50U/uL T7 Exonuclease in CTNG Storage Buffer	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-139	Active
100	CO-OPS-SOP-112	600pM Stocks of Synthetic Uracil containing Amplicon	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-138	Active
101	CO-LAB-FRM-023	6x DNA loading dye Atlas Part Number 0327	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0327	Active
102	CO-OPS-SOP-113	9.26pc (w.v) BSA in 208.3 mM Potassium Phosphate buffer	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-126	Active
103	CO-OPS-SOP-114	9.26pc (w.v) NZ Source BSA in 208.3mM Potassium Phosphate buffer	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-125	Active
104	CO-QA-JA-001	A Basic Guide to Finding Documents in SharePoint	1	Quality Assurance	Job Aid	QMS	Corporate	QS-JA-001	Active
105	CO-QC-JA-019	A Guide for QC Document Filing	0	Quality Control	Job Aid	QMS	Corporate		Active
106	CO-IT-POL-022	Access Control Policy	0	Information Technology	Policy	QMS	Corporate		Active
107	CO-QA-SOP-030	Accessing and Finding Documents in QT9	3	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Active
108	CO-H&S-PRO-004	Accident Incident and near miss reporting procedure	4	Health and Safety	H&S Procedures		Corporate	HS-PRO-007	
109	CO-SUP-SOP-062	Add Team Member to a Task	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-031	Active
110	CO-QA-T-045	Additional Training Form	4	Quality Assurance	Templates	QMS	Corporate	QS-T-029	Active
111	CO-DPT-ART-004	ADX Blood Card Barcode QR Labels	0	Digital Product Technology	Artwork	QMS	Corporate		Active
112	CO-LAB-SOP-002	Agilent Bioanalyzer SOP for RNA 6000 Pico and Nano Kits	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-028	Active
113	CO-PRD1-JA-008	Air conditioning	1	Production line 1 - Oak House	Job Aid	QMS	Corporate		Active
114	CO-SUP-JA-062	AirSea 2-8°c Shipper Packing Instructions	0	Supply Chain	Job Aid	QMS	Corporate		Active
115	CO-SUP-JA-061	AirSea Dry Ice Shipper Packing Instructions	0	Supply Chain	Job Aid	QMS	Corporate		Active
116	CO-PRD1-FRM-244	Albumin from bovine serum (BSA) Oak House Production IQC	2	Production line 1 - Oak House	Forms	QMS	Corporate		Active
117	CO-LAB-FRM-028	Ammonium Acetate binx Part Number 0387	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0387	Active
118	CO-DPT-ART-010	Anal STI Sample Collection Sticker	0	Digital Product Technology	Artwork	QMS	Corporate		Active
119	CO-DPT-VID-007	Anal Swab Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	QMS	Corporate		Active
120	CO-QA-SOP-096	Analysis of Quality Data	5	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-020	Active
121	CO-QA-SOP-012	Annual Quality Objectives	8	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-019	Active
122	CO-QA-SOP-274	Applicable Standards Management Procedure	0	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Active
123	CO-LAB-LBL-003	Approved material label	2	Laboratory	Label	QMS	Corporate	QS-L-001	Active
124	CO-QA-REG-024	Archived Document Retrieval Log	1	Quality Assurance	Registers	QMS	Corporate	QS-REG-048	Active
125	CO-QA-T-109	Archiving Box Contents List	3	Quality Assurance	Templates	QMS	Corporate	QS-T-127	Active
126	CO-LAB-SOP-288	Assessment of Potentiostat Performance	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-021 UK-LAB-SOP-001	Active
127	CO-LAB-LBL-019	Asset Calibration Label	2	Laboratory	Label	QMS	Corporate	QS-L-020	Active
128	CO-IT-POL-023	Asset Management Policy	0	Information Technology	Policy	QMS	Corporate		Active
129	CO-LAB-FRM-278	Asset Not Temperature Controlled Sign	0	Laboratory	Forms	QMS	Corporate		Active
130	CO-LAB-REG-011	Asset Register	3	Laboratory	Registers	QMS	Corporate	QS-REG-002	Active
131	CO-DPT-IFU-003	At-Home Blood Spot Collection Kit IFU (English Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0020A	Active
132	CO-DPT-IFU-001	At-Home Blood Spot Collection Kit IFU (English Print Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0020	Active
133	CO-DPT-IFU-004	At-Home Blood Spot Collection Kit IFU (Spanish Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0020A-ES	Active
134	CO-DPT-IFU-002	At-Home Blood Spot Collection Kit IFU (Spanish Print Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0020-ES	Active
135	CO-DPT-IFU-042	At-Home Blood Spot Collection Kit USPS IFU (English Digital Version)	0	Digital Product Technology	Instructions For Use	QMS	Corporate		Active
136	CO-DPT-IFU-040	At-Home Blood Spot Collection Kit USPS IFU (English Print Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate		Active
137	CO-DPT-IFU-043	At-Home Blood Spot Collection Kit USPS IFU (Spanish Digital Version)	0	Digital Product Technology	Instructions For Use	QMS	Corporate		Active
138	CO-DPT-IFU-041	At-Home Blood Spot Collection Kit USPS IFU (Spanish Print Version)	0	Digital Product Technology	Instructions For Use	QMS	Corporate		Active
139	CO-DPT-IFU-011	At-Home Female Triple Site Collection Kit IFU (English Digital Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0029A-EN	Active
140	CO-DPT-IFU-009	At-Home Female Triple Site Collection Kit IFU (English Print Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0029-EN	Active
141	CO-DPT-IFU-012	At-Home Female Triple Site Collection Kit IFU (Spanish Digital Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0029A-ES	Active
142	CO-DPT-IFU-010	At-Home Female Triple Site Collection Kit IFU (Spanish Print Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0029-ES	Active
143	CO-DPT-IFU-016	At-Home Male Triple Site Collection Kit IFU (English Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0032A	Active
144	CO-DPT-IFU-014	At-Home Male Triple Site Collection Kit IFU (English Print Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0032	Active
145	CO-DPT-IFU-017	At-Home Male Triple Site Collection Kit IFU (Spanish Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0032A-ES	Active
146	CO-DPT-IFU-015	At-Home Male Triple Site Collection Kit IFU (Spanish Print Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0032-ES	Active
147	CO-DPT-IFU-020	At-Home Urine Collection Kit IFU (English Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0033A	Active
148	CO-DPT-IFU-018	At-Home Urine Collection Kit IFU (English Print Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0033	Active
149	CO-DPT-IFU-021	At-Home Urine Collection Kit IFU (Spanish Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0033A-ES	Active
150	CO-DPT-IFU-019	At-Home Urine Collection Kit IFU (Spanish Print Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-033-ES	Active
151	CO-DPT-IFU-007	At-Home Vaginal Swab Collection Kit IFU (English Digital Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0028A	Active
152	CO-DPT-IFU-005	At-Home Vaginal Swab Collection Kit IFU (English Print Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0028	Active
153	CO-DPT-IFU-008	At-Home Vaginal Swab Collection Kit IFU (Spanish Digital Print)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0028A-ES	Active
154	CO-DPT-IFU-006	At-Home Vaginal Swab Collection Kit IFU (Spanish Print Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0028-ES	Active
155	CO-LAB-SOP-167	Attaching Electrode Blister Adhesive and Blister Pack and Cover (M600)	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-053	
156	CO-QA-FRM-194	Auditor Competency Assessment	0	Quality Assurance	Forms	QMS	Corporate		Active
157	CO-QA-FRM-193	Auditor Qualification	0	Quality Assurance	Forms	QMS	Corporate		Active
158	CO-QA-REG-033	Auditor register	0	Quality Assurance	Registers	QMS	Corporate		Active
159	CO-LAB-T-159	Autoclave Biological Indicator Check Form	0	Laboratory	Templates	QMS	Corporate		Active
160	CO-QC-T-033	Autoclave Record	5	Quality Control	Templates	QMS	Corporate	QS-T-092	Active
161	CO-SUP-JA-031	Automatic MRP run	set up and edit	0	Supply Chain	Job Aid	QMS	Corporate	
162	CO-QA-REG-007	Bacterial Stock Register	2	Quality Assurance	Registers	QMS	Corporate	QS-REG-056	Active
163	CO-LAB-SOP-013	Balance calibration	6	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-004	Active
164	CO-QC-T-028	Balance Calibration form	3	Quality Control	Templates	QMS	Corporate	QS-T-083	Active
165	CO-DES-PTL-006	Balance IQ/OQ	3	Design	Protocol	QMS	Corporate	QS-VAL-020	Active
166	CO-LAB-SOP-164	Bambi compressor: Use and Maintenance	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-043	Active
167	CO-DPT-ART-012	BAO Sassy Little Box	0	Digital Product Technology	Artwork	QMS	Corporate		Active
168	CO-LAB-REG-020	Batch Retention Register	1	Laboratory	Registers	QMS	Corporate	QS-REG-057	Active
169	CO-LAB-URS-001	Binder incubator and humidity chamber User Requirement Specification	0	Laboratory	User Requirements	QMS	Corporate		Active
170	CO-LAB-SOP-012	Binder KBF-115 Oven	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-063	Active
171	CO-DPT-IFU-032	binx At-Home Collection Kit IFU Group_Broad (English Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0009	Active
172	CO-DPT-IFU-031	binx At-Home Collection Kit Individual_Broad (English Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0008	Active
173	CO-DPT-IFU-033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping (English Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0010	Active
174	CO-DPT-IFU-036	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad (English Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0018	Active
175	CO-DPT-IFU-035	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location (English Version)	5	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0011	Active
176	CO-DPT-IFU-037	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad (English Version)	4	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0019	Active
177	CO-SUP-T-184	binx Commercial Invoice (Misc. shipments)	1	Supply Chain	Templates	QMS	Corporate		Active
178	CO-DPT-IFU-039	binx health (powered by P23) At-home Saliva COVID-19 Test Collection Kit for Group Settings (English Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0013	Active
179	CO-DPT-IFU-038	binx health (powered by P23) At-home Saliva COVID-19 Test Collection Kit IFU (English Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0012	Active
180	CO-DPT-IFU-044	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU for return at a drop-off location (English Print Version)	0	Digital Product Technology	Instructions For Use	QMS	Corporate		
181	CO-OPS-REG-029	binx health ltd Master Assay Code Register	7	Operations	Registers	QMS	Corporate	QS-REG-200	Active
182	CO-SUP-FRM-177	binx health Vendor Information Form	0	Supply Chain	Forms	QMS	Corporate		Active
183	CO-CS-FRM-275	binx io RMA Number Request Form	0	Customer Support	Forms	QMS	Corporate		Active
184	CO-QA-T-042	binx Meeting Minutes Template	5	Quality Assurance	Templates	QMS	Corporate	QS-T-007	Active
185	CO-QA-T-038	binx Memorandum Template	7	Quality Assurance	Templates	QMS	Corporate	QS-T-003	Active
186	CO-DPT-IFU-029	binx Nasal Swab For Group Setting (English Print Version)	7	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0007	Active
187	CO-DPT-IFU-028	binx Nasal Swab For Individual Setting (English Print Version)	10	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0002	Active
188	CO-SUP-T-185	binx Packing List (Misc shipments)	1	Supply Chain	Templates	QMS	Corporate		Active
189	CO-SUP-T-003	binx Purchase Order Form	8	Supply Chain	Templates	QMS	Corporate	QS-T-013	Active
190	CO-DES-T-040	binx Report Template	7	Design	Templates	QMS	Corporate	QS-T-005	Active
191	CO-DES-T-041	binx Technical Report Template	7	Design	Templates	QMS	Corporate	QS-T-006	Active
192	CO-QC-T-107	Bioanalyzer Cleaning Record	3	Quality Control	Templates	QMS	Corporate	QS-T-117	Active
193	CO-H&S-T-203	Blank Form for H&S COSHH assessments	5	Health and Safety	Templates	Business	Corporate	HS-T-003	Active
194	CO-OPS-PTL-037	Blister Cropping Press IQ and OQ Validation Protocol	1	Operations	Protocol	QMS	Corporate	QS-VAL-064	Active
195	CO-OPS-PTL-038	Blister Filling Rig and Cropping Press PQ Validation Protocol	3	Operations	Protocol	QMS	Corporate	QS-VAL-060	Active
196	CO-DPT-IFU-022	Blood Card Collection Kit IFU (Using ADx Card) Fasting (English Print Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0037	
197	CO-DPT-IFU-023	Blood Card Collection Kit IFU (Using the ADx Card) Fasting (English Digital Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0037A	
198	CO-DPT-IFU-025	Blood Card Collection Kit IFU (Using the ADx Card) Non-Fasting  (English Digital Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0038A	
199	CO-DPT-IFU-024	Blood Card Collection Kit IFU (Using the ADx Card) Non-Fasting (English Print Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0038	
200	CO-SUP-SOP-063	Book Time Against A Project	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-032	Active
201	CO-PRD1-FRM-232	Brij- 58 Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
202	CO-OPS-SOP-115	BSA Solution	6	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-023	Active
203	CO-LAB-FRM-038	Bst 3.0 DNA Polymerase (Glycerol-Free)’ Materials binx Part Number 0407	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0407	Active
204	CO-IT-POL-024	Business Continuity and Disaster Recovery	0	Information Technology	Policy	QMS	Corporate		Active
205	CO-LAB-FRM-066	C. trachomatis serotype F Elementary Bodies Part No. 0106	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0106	Active
206	CO-PRD1-FRM-204	Calibrated Clock/Timer verification form	0	Production line 1 - Oak House	Forms	QMS	Corporate		Active
207	CO-DES-PTL-008	Calibration of V&V Laboratory Timers	3	Design	Protocol	QMS	Corporate	QS-VAL-027	Active
208	CO-QA-T-123	CAPA date extension form	3	Quality Assurance	Templates	QMS	Corporate	QS-T-160	Active
209	CO-OPS-T-139	Cartridge and Packing Bill of Materials Template	1	Operations	Templates	QMS	Corporate	QS-T-195	Active
210	CO-SUP-SOP-281	Cartridge Component Stock Control Procedure	7	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-006 UK-SUP-SOP-002	Active
211	CO-OPS-JA-020	Cartridge Defects Library	0	Operations	Job Aid	QMS	Corporate		Active
212	CO-LAB-LBL-021	Cartridge Materials Label	1	Laboratory	Label	QMS	Corporate	QS-L-022	Active
213	CO-SUP-T-113	Cartridge Stock Take Form	3	Supply Chain	Templates	QMS	Corporate	QS-T-131	Out For Revision
214	CO-DES-SOP-243	CE Mark/Technical File Procedure	6	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-004	Active
215	CO-QA-T-145	Certificate of Conformance	1	Quality Assurance	Templates	QMS	Corporate	QS-T-201	Active
216	CO-PRD1-FRM-183	Certificate of conformance – CT IC detection reagent	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
217	CO-PRD1-FRM-184	Certificate of conformance - CT IC primer passivation reagent	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
218	CO-PRD1-FRM-185	Certificate of Conformance - IC DNA reagent	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
219	CO-PRD1-FRM-186	Certificate of Conformance - NG1 IC detection reagent	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
220	CO-PRD1-FRM-188	Certificate of Conformance - NG1 NG2 IC primer passivation reagent	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
221	CO-PRD1-FRM-187	Certificate of Conformance - NG2 IC detection reagent	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
222	CO-PRD1-FRM-189	Certificate of Conformance - Taq UNG	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
223	CO-PRD1-T-163	Certificate of Conformance template	1	Production line 1 - Oak House	Templates	QMS	Corporate		Active
224	CO-QA-T-008	Change Management Form	12	Quality Assurance	Templates	QMS	Corporate	QS-T-021	Active
225	CO-QA-SOP-139	Change Management Procedure for Product/Project Documents	15	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-004	Active
226	CO-QA-REG-001	Change Management Register	9	Quality Assurance	Registers	QMS	Corporate	QS-REG-023	Active
227	CO-SUP-SOP-038	Change of Stock (QC Release)	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-017	Active
228	CO-SUP-SOP-056	Check Sales Order due Date	1	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-037	Active
229	CO-H&S-PRO-002	Chemical and Biological COSHH Guidance	8	Health and Safety	H&S Procedures	Business	Corporate	HS-PRO-002	Active
230	CO-LAB-JA-043	CIR Job Aid	0	Laboratory	Job Aid	QMS	Corporate		Out For Revision
231	CO-LAB-LBL-026	CIR Label	2	Laboratory	Label	QMS	Corporate	QS-L-027	Active
232	CO-QC-COP-002	CL2 Microbiology Laboratory Code of Practice	2	Quality Control	Code of Practice	QMS	Corporate		Active
233	CO-LAB-FRM-180	Class II MSC Monthly Airflow Check Form	1	Laboratory	Forms	QMS	Corporate	QS-T-210	Active
234	CO-LAB-SOP-179	Cleaning Procedure for Microbiology Lab	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-082	Active
235	CO-PRD1-SOP-261	Cleaning Procedure for Oak House Production Facility	3	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Out For Revision
236	CO-CA-T-147	Clinical Trial Agreement	2	Clinical Affairs	Templates	QMS	Corporate	QS-T-205	Active
237	CO-IT-POL-025	Code of Conduct	0	Information Technology	Policy	QMS	Corporate		Active
238	CO-SD-FRM-171	Code Review	0	Software Development	Forms	QMS	Corporate		Active
239	CO-SUP-POL-035	Cold Chain Shipping Policy	0	Supply Chain	Policy	QMS	Corporate		Active
240	CO-CA-SOP-081	Collection of In-house Collected Samples	2	Clinical Affairs	Standard Operating Procedure	QMS	Corporate	QS-LAB-094	Active
241	CO-SUP-SOP-065	Complete a Time Sheet	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-034	Active
242	CO-SUP-SOP-054	Complete Production Order	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-011	Active
243	CO-SUP-SOP-037	Complete QC Inspections	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-016	Active
244	CO-OPS-SOP-202	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility (for FDA 510(k))	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-147	Active
245	CO-CA-FRM-041	Consent for Voluntary Donation of In-house Collected Samples	2	Clinical Affairs	Forms	QMS	Corporate	QS-T-208	Active
246	CO-LAB-LBL-015	Consumables Label	2	Laboratory	Label	QMS	Corporate	QS-L-015	Active
247	CO-LAB-REG-016	Consumables Register	2	Laboratory	Registers	QMS	Corporate	QS-REG-025	Active
248	CO-SUP-SOP-057	Consume to Cost Centre or Project	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-013	Active
249	CO-SUP-JA-024	Consumption on Cost Center	0	Supply Chain	Job Aid	QMS	Corporate		Active
250	CO-OPS-SOP-208	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility (for FDA 510(k))	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-163	Active
251	CO-OPS-SOP-116	Contrived Vaginal Matrix in eNAT	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-146	Active
252	CO-LAB-SOP-156	Control of Controlled Laboratory Notes	9	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-003	Out For Revision
253	CO-SAM-SOP-009	Control of Marketing and Promotion	5	Sales and Marketing	Standard Operating Procedure	QMS	Corporate	QS-DOC-011	Active
254	CO-QC-T-051	Controlled Lab Notes Template	6	Quality Control	Templates	QMS	Corporate	QS-T-037	Active
255	CO-IT-REG-028	Controlled Laboratory Equipment Software List	3	Information Technology	Registers	QMS	Corporate	QS-REG-031	Active
256	CO-SAM-T-069	Copy Approval Form	3	Sales and Marketing	Templates	QMS	Corporate	QS-T-096	Active
471	CO-QC-T-121	Impulse Sealer Use Log	2	Quality Control	Templates	QMS	Corporate	QS-T-157	Active
257	CO-H&S-P-004	Coronavirus (COVID-19) Policy on employees being vaccinated	1	Health and Safety	H&S Policy	Business	Corporate	HS-P-008	Active
258	CO-QA-SOP-007	Correction	Removal	and Recall Procedure	5	Quality Assurance	Standard Operating Procedure	QMS	Corporate
259	CO-QA-SOP-093	Corrective and Preventive Action Procedure	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-018	Active
260	CO-H&S-COSHH-006	COSH-Assessment - Corrosive Acids	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-006	Active
261	CO-H&S-COSHH-013	COSHH Assessment  - Dry Ice	4	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-012	Active
262	CO-H&S-COSHH-007	COSHH assessment  - General Hazard Group 2 organisms	5	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-007	Active
263	CO-H&S-COSHH-008	COSHH assessment  - Hazard Group 2 respiratory pathogens	5	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-008	Active
264	CO-H&S-COSHH-004	COSHH Assessment - Chlorinated Solvents	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-004	Active
265	CO-H&S-COSHH-010	COSHH assessment - clinical samples	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-010	Active
266	CO-H&S-COSHH-014	COSHH Assessment - Compressed Gases	1	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-013	Active
267	CO-H&S-COSHH-005	COSHH Assessment - Corrosive Bases	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-005	Active
268	CO-H&S-COSHH-003	COSHH Assessment - Flammable Materials	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-003	Active
269	CO-H&S-COSHH-001	COSHH Assessment - General Chemicals	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-001	Active
270	CO-H&S-COSHH-009	COSHH Assessment - Hazard Group 1 Pathogens	4	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-009	Active
271	CO-H&S-COSHH-012	COSHH Assessment - Inactivated Micro-organisms	5	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-011	Active
272	CO-H&S-COSHH-002	COSHH Assessment - Oxidising Agents	6	Health and Safety	COSHH Assessment	Business	Corporate	HS-COSHH-002	Active
273	CO-DPT-ART-007	COVID Broad Kit QRX Barcode 2 Part Label	0	Digital Product Technology	Artwork	QMS	Corporate		Active
274	CO-DPT-WEB-001	COVID Consent	0	Digital Product Technology	Website Content	QMS	Corporate		Active
275	CO-DPT-WEB-006	COVID Consent (Spanish)	0	Digital Product Technology	Website Content	QMS	Corporate		Active
276	CO-DPT-ART-005	COVID Pre-Printed PCR Label	1	Digital Product Technology	Artwork	QMS	Corporate		Active
277	CO-DPT-ART-006	COVID Pre-Printed PCR Label - 1D Barcode	0	Digital Product Technology	Artwork	QMS	Corporate		Active
278	CO-H&S-RA-011	Covid-19 Risk Assessment binx Health ltd	6	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-043	Active
279	CO-SUP-SOP-064	Create a PO Within a Project	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-033	Active
280	CO-SUP-SOP-046	Create New Customer Return	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-027	Active
281	CO-SUP-JA-025	Creating stock and non-stock purchase orders from purchase request	0	Supply Chain	Job Aid	QMS	Corporate		Active
282	CO-DES-SOP-042	Creation and Maintenance of a Device Master Record (DMR)	4	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-011	Active
283	CO-SUP-SOP-059	Credit Customer Returns	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-028	Active
284	CO-DES-SOP-371	Critical to Quality and Reagent Design Control	2	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-012	CO-DES-SOP-005
285	CO-IT-POL-026	Cryptography Policy	0	Information Technology	Policy	QMS	Corporate		Active
286	CO-PRD1-FRM-246	CT di452 probe Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
287	CO-PRD1-FRM-249	CT forward primer Oak House production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
288	CO-PRD1-LBL-041	CT IC Detection Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
289	CO-SUP-FRM-214	CT IC Detection Reagent Component pick list form	4	Supply Chain	Forms	QMS	Corporate		Active
290	CO-PRD1-LBL-034	CT IC Detection Reagent Vial Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
291	CO-PRD1-LBL-042	CT IC Primer Passivation Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
292	CO-SUP-FRM-215	CT IC Primer Passivation Reagent Component Pick List Form	2	Supply Chain	Forms	QMS	Corporate		Active
293	CO-PRD1-LBL-035	CT IC Primer Passivation Reagent Vial Label	1	Production line 1 - Oak House	Label	QMS	Corporate		Active
294	CO-PRD1-LBL-046	CT NG Taq UNG Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
295	CO-SUP-FRM-219	CT NG Taq UNG Reagent Component Pick List Form	2	Supply Chain	Forms	QMS	Corporate		Active
296	CO-PRD1-LBL-039	CT NG Taq UNG Reagent Vial Label	1	Production line 1 - Oak House	Label	QMS	Corporate		Active
297	CO-QC-QCP-055	CT Plasmid Quantification - qPCR Test (Part No. 0348)	1	Quality Control	Quality Control Protocol	QMS	Corporate	UK-QC-QCP-040	Active
298	CO-PRD1-FRM-250	CT reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
299	CO-LAB-FRM-074	CT synthetic target containing Uracil Part no: 0168	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0168	Active
300	CO-LAB-FRM-016	CT Taqman Probe (FAM)	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0216	Active
301	CO-OPS-SOP-189	CT/NG ATCC Input Generation	14	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-159	Active
302	CO-QC-PTL-074	CT/NG Cartridge QC Test Analysis Template Validation Protocol	1	Quality Control	Protocol	QMS	Corporate	MOB-VAL-024	Active
303	CO-QC-QCP-059	CT/NG Collection Kit Batch Release	2	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-059 UK-QC-QCP-034	Active
304	CO-SUP-JA-068	CT/NG ioTM Cartridge Packing Instructions for QC samples (Softbox MAX Shipper)	0	Supply Chain	Job Aid	QMS	Corporate		Active
305	CO-SUP-JA-067	CT/NG ioTM Cartridge Packing Instructions for QC samples (Softbox PRO Shipper)	0	Supply Chain	Job Aid	QMS	Corporate		Active
306	CO-QC-QCP-060	CT/NG Relabelled Cartridge Batch Release Procedure	2	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-058 UK-QC-QCP-033	Active
307	CO-QC-QCP-068	CT/NG Taq-UNG reagent qPCR test (MOB-D-0277)	11	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-045 UK-QC-QCP-025	Active
308	CO-QC-QCP-065	CT/NG: CT/IC Detection Reagent Heated io detection rig	11	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-048 UK-QC-QCP-028	Active
309	CO-LAB-FRM-105	CT/NG: CT/IC Primer Passivation Reagent	9	Laboratory	Forms	QMS	Corporate	QS-IQC-0280	Active
310	CO-QC-QCP-067	CT/NG: CT/IC Primer-Passivation Reagent	9	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-046 UK-QC-QCP-026	Active
311	CO-QC-QCP-052	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test (Part 0248)	7	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-039 UK-LAB-QCP-021	Active
312	CO-QC-QCP-069	CT/NG: IC DNA Reagent qPCR Test	10	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-044 UK-QC-QCP-024	Active
313	CO-QC-QCP-064	CT/NG: NG1/IC Detection Reagent	11	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-049 UK-QC-QCP-029	Active
314	CO-LAB-FRM-103	CT/NG: NG1/IC Detection Reagent	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0278	Active
315	CO-QC-QCP-066	CT/NG: NG1/NG2/IC Primer-Passivation Reagent qPCR test	7	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-047 UK-QC-QCP-027	Active
316	CO-QC-QCP-063	CT/NG: NG2/IC detection reagent Heated io detection rig	11	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-050 UK-QC-QCP-030	Active
317	CO-OPS-SOP-104	CT_IC Detection Reagent	7	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-130	Active
318	CO-LAB-FRM-018	CTdi452 Probe from atdbio	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0234	Active
319	CO-QC-T-102	CTNG Cartridge Cof A	11	Quality Control	Templates	QMS	Corporate	QS-T-180	Active
320	CO-QC-PTL-066	CTNG CT/IC Primer passivation	2	Quality Control	Protocol	QMS	Corporate	MOB-VAL-009	Active
321	CO-QC-QCP-057	CTNG CTIC NG1IC and NG2IC Detection Reagents QC test	6	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-061 UK-QC-QCP-036	
322	CO-QC-PTL-068	CTNG Detection Reagent Validation	3	Quality Control	Protocol	QMS	Corporate	MOB-VAL-011	Active
323	CO-QC-PTL-067	CTNG NG/IC Primer passivation Validation	2	Quality Control	Protocol	QMS	Corporate	MOB-VAL-010	Active
324	CO-QC-T-155	CTNG QC Cartridge Analysis Module	0	Quality Control	Templates	QMS	Corporate		Active
325	CO-OPS-SOP-120	CTNG Storage Buffer (224.3mM Potassium Phosphate	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-127	Active
326	CO-OPS-SOP-142	CTNG T7 Diluent	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-128	Active
327	CO-OPS-SOP-121	CTNG T7 Diluent Rev 3.0 (NZ source BSA)	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-129	Active
328	CO-CS-JA-069	Customer Installation and Training Job Aid binx io	0	Customer Support	Job Aid	QMS	Corporate		Active
329	CO-DES-T-129	Customer Requirements Specification	1	Design	Templates	QMS	Corporate	QS-T-185	Active
330	CO-SUP-SOP-013	Customer Returns	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-026	Active
331	CO-SUP-SOP-060	Customer Returns	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-029	Active
332	CO-SUP-SOP-041	Customer Sales Contracts	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-021	Active
333	CO-CS-T-131	Customer Service Script	1	Customer Support	Templates	QMS	Corporate	QS-T-187	Active
334	CO-SUP-SOP-045	Cutomer Price Lists	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-025	Active
335	CO-LAB-FRM-009	D-(+)-Trehalose Dihydrate	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0119	Active
336	CO-QA-T-194	Declaration of Conformity Template	0	Quality Assurance	Templates	QMS	Corporate		Active
337	CO-SUP-JA-047	Demand Plan - Plan and Release	0	Supply Chain	Job Aid	QMS	Corporate		Active
338	CO-SUP-SOP-323	Demand Planning	0	Supply Chain	Standard Operating Procedure	QMS	Corporate		Active
339	CO-DES-SOP-029	Design and Development Procedure	10	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-001	Active
340	CO-DES-T-004	Design Review Record	2	Design	Templates	QMS	Corporate	QS-T-018a	Active
341	CO-DES-SOP-041	Design Review Work Instruction	6	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-006	Active
342	CO-DES-T-124	Design Transfer Form	2	Design	Templates	QMS	Corporate	QS-T-161	Active
343	CO-QC-T-071	Detection Reagent Analysis Template	5	Quality Control	Templates	QMS	Corporate	QS-T-098	Active
344	CO-OPS-SOP-122	Detection Surfactants Solution	9	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-059	Active
345	CO-OPS-T-020	Development Partner Ranking	2	Operations	Templates	QMS	Corporate	QS-T-056	Active
346	CO-QA-SOP-099	Deviation Procedure	5	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-017	Out For Revision
347	CO-DES-T-099	Device Master Record	2	Design	Templates	QMS	Corporate	QS-T-174	Active
348	CO-QA-T-166	Device Specific List of Applicable Standards Form Template	0	Quality Assurance	Templates	QMS	Corporate		Active
349	CO-DPT-T-187	Digital BOM Template	0	Digital Product Technology	Templates	QMS	Corporate		Active
350	CO-DPT-T-168	Digital Feature Template	0	Digital Product Technology	Templates	QMS	Corporate	US-DPT-T-154	Active
351	CO-LAB-FRM-027	Dimethylsulfoxide Part Number 0227	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0227	Active
352	CO-QC-T-031	Dishwasher User Form	3	Quality Control	Templates	QMS	Corporate	QS-T-087	Active
353	CO-PRD1-FRM-245	DL-dithiothreitol (DTT) Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
354	CO-QA-T-049	Document Acceptance Form	5	Quality Assurance	Templates	QMS	Corporate	QS-T-034	Active
355	CO-QA-T-142	Document and Record Disposition Form	1	Quality Assurance	Templates	QMS	Corporate	QS-T-198	Active
356	CO-QA-SOP-005	Document and Records Archiving	5	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-013	Active
357	CO-QA-SOP-140	Document Control Procedure (Projects)	19	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-002	Active
358	CO-QA-SOP-098	Document Matrix	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-002a	Active
359	CO-QA-T-110	Document Retrieval Request	3	Quality Assurance	Templates	QMS	Corporate	QS-T-128	Active
360	CO-QA-T-141	Document Signoff Front Sheet	2	Quality Assurance	Templates	QMS	Corporate	QS-T-197	Active
361	CO-CA-REG-031	Donor Number Consent Register	1	Clinical Affairs	Registers	QMS	Corporate	QS-REG-205	Active
362	CO-QC-PTL-072	dPCR Performance Qualification	2	Quality Control	Protocol	QMS	Corporate	MOB-VAL-021	Active
363	CO-QC-SOP-293	dPCR Quantification of CT and NG Vircell Inputs	2	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-EXP-044 UK-QC-SOP-020	Active
364	CO-DPT-VID-004	Dry Blood Spot Card Video Transcript	0	Digital Product Technology	Instructional Videos	QMS	Corporate		Active
365	CO-SUP-JA-023	Dry Ice Job aid (Oak House)	0	Supply Chain	Job Aid	QMS	Corporate		Active
366	CO-OPS-SOP-123	DTT Solution	8	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-032	Active
367	CO-PRD1-FRM-242	dUTP mix Oak House Production IQC	2	Production line 1 - Oak House	Forms	QMS	Corporate		Active
368	CO-QC-QCP-061	Electrode Electrochemical Functionality QC Assessment	7	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-025 UK-QC-QCP-032	Active
369	CO-LAB-SOP-161	Elix Deionised Water System	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-035	Active
370	CO-LAB-FRM-020	Elution Reagent	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0284	Active
371	CO-LAB-LBL-024	Elution Reagent Label	4	Laboratory	Label	QMS	Corporate	QS-L-025	Active
372	CO-QA-REG-041	Employee Unique Initial Register	0	Quality Assurance	Registers	QMS	Corporate		Active
373	CO-OPS-SOP-035	Engineering Drawing Control	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-DOC-005	Active
374	CO-OPS-SOP-174	Engineering Rework Procedure	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-076	Active
375	CO-SUP-SOP-042	Enter & Release Sales Orders	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-022	Active
376	CO-PRD1-SOP-263	Entry and Exit to the Oak House Production Facility and Production Suite	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
377	CO-LAB-REG-018	Enviromental Monitoring Results Register	2	Laboratory	Registers	QMS	Corporate	QS-REG-049	Active
378	CO-QC-T-076	Environmental Chamber Monitoring Form	3	Quality Control	Templates	QMS	Corporate	QS-T-103	Active
379	CO-LAB-SOP-295	Environmental Contamination testing	6	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-041 UK-QC-SOP-018	Active
380	CO-LAB-SOP-103	Environmental Controls in the Laboratory	12	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-009	Out For Revision
381	CO-QC-QCP-071	Enzymatics Taq-B 25U/ul (Part 0270)	8	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-042 UK-QC-QCP-022	Active
382	CO-OPS-PTL-031	EOL thermal test 21011-MET-012 Thermal-PCR Cycle Template for TTDL-No.2.xlsx v4.0	3	Operations	Protocol	QMS	Corporate	QS-VAL-038	Active
383	CO-LAB-SOP-011	Eppendorf 5424 Centrifuge	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-062	Active
384	CO-SUP-SOP-006	Equipment Fulfilment and Field Visit SOP for non-stock instruments	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-OPS-011	Active
385	CO-OPS-T-130	Equipment Fulfilment Order	2	Operations	Templates	QMS	Corporate	QS-T-186	Active
386	CO-QC-T-032	Equipment Log	3	Quality Control	Templates	QMS	Corporate	QS-T-088	Active
387	CO-PRD1-FRM-205	Equipment Maintenance and Calibration Form	0	Production line 1 - Oak House	Forms	QMS	Corporate		Active
388	CO-LAB-LBL-025	Equipment Not Maintained Do Not Use Label	2	Laboratory	Label	QMS	Corporate	QS-L-026	Active
389	CO-CS-T-135	Equipment Return Order	3	Customer Support	Templates	QMS	Corporate	QS-T-191	Active
390	CO-LAB-REG-017	Equipment Service and Calibration Register	6	Laboratory	Registers	QMS	Corporate	QS-REG-032	Active
391	CO-LAB-LBL-017	Equipment Under Qualification Label	2	Laboratory	Label	QMS	Corporate	QS-L-018	Active
392	CO-PRD1-LBL-048	ERP GRN for Oak House Label-Rev_0	0	Production line 1 - Oak House	Label	QMS	Corporate		Active
393	CO-LAB-SOP-006	Esco Laminar Flow Cabinet	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-046	Active
394	CO-LAB-FRM-003	Ethanol (Absolute)	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0006	Active
395	CO-PRD1-FRM-240	Ethanol Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
396	CO-QA-SOP-357	EU Performance Evaluation	0	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Out For Revision
397	CO-QA-SOP-356	EU Regulatory Strategy and Process	0	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Active
398	CO-LAB-T-198	Eupry Calibration Cover Sheet	0	Laboratory	Templates	QMS	Corporate		Active
399	CO-PRD1-SOP-264	Eupry temperature monitoring system	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
400	CO-PRD1-PTL-086	Eupry Temperature Monitoring System Validation	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
401	CO-QC-LBL-032	Excess Raw Material Label	0	Quality Control	Label	QMS	Corporate	UK-QC-LBL-002	Active
402	CO-DES-T-036	Experimental template: Planning	5	Design	Templates	QMS	Corporate	QS-T-095a	Active
403	CO-DES-T-068	Experimental Template: Write Up	5	Design	Templates	QMS	Corporate	QS-T-095b	Out For Revision
404	CO-LAB-SOP-155	Experimental Write Up	8	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-002	Out For Revision
405	CO-SUP-JA-037	Expiry Date Amendment	0	Supply Chain	Job Aid	QMS	Corporate		Active
406	CO-LAB-LBL-007	Expiry Dates Label	3	Laboratory	Label	QMS	Corporate	QS-L-006	Active
407	CO-QA-T-007	External Change Notification Form	6	Quality Assurance	Templates	QMS	Corporate	QS-T-020	Active
408	CO-OPS-PTL-051	Factory Acceptance Test (FAT) Sprint B+ In-line Leak Tester	0	Operations	Protocol	QMS	Corporate		Active
409	CO-LAB-LBL-010	Failed Testing - Not in use Label	2	Laboratory	Label	QMS	Corporate	QS-L-009	Active
410	CO-LAB-REG-037	Female Urine Database	0	Laboratory	Registers	QMS	Corporate		Active
411	CO-QA-T-078	Field Action Implementation Checklist	4	Quality Assurance	Templates	QMS	Corporate	QS-T-108	Active
412	CO-QA-T-079	Field Corrective Action File Review Form	3	Quality Assurance	Templates	QMS	Corporate	QS-T-109	Active
413	CO-CS-FRM-267	Field Service Report Form	0	Customer Support	Forms	QMS	Corporate		Active
414	CO-H&S-PRO-007	Fire evacuation procedure for Oak House	1	Health and Safety	H&S Procedures	Business	Corporate	HS-PRO-011	Active
415	CO-OPS-SOP-007	Firmware Up-date	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-048	Active
416	CO-FIN-T-122	Fixed Asset Transfer Form	2	Finance	Templates	QMS	Corporate	QS-T-159	Active
470	CO-QA-SOP-016	Identification and Traceabillity	2	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-026	Active
417	CO-H&S-RA-005	Flammable & Explosive Substances Risk Assessment for  binx health Ltd (Derby Court and Unit 6)	3	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-029	Active
418	CO-QA-SOP-284	FMEA Procedure	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-RSK-002 UK-QA-SOP-002	Active
419	CO-DES-T-059	FMEA template	3	Design	Templates	QMS	Corporate	QS-T-065	Active
420	CO-LAB-LBL-004	For Indication Only Label	1	Laboratory	Label	QMS	Corporate	QS-L-003	Active
421	CO-OPS-SOP-187	Force Test Rig Set up and Calibration	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-051	Active
422	CO-QA-T-011	Form Template	5	Quality Assurance	Templates	QMS	Corporate	QS-T-025	Active
423	CO-LAB-FRM-024	GelRed Nucleic Acid Stain Atlas Part Number 0328	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0328	Active
424	CO-LAB-LBL-012	General Calibration Label	2	Laboratory	Label	QMS	Corporate	QS-L-011	Active
425	CO-OPS-T-111	Generic Cartridge Subassembly Build	3	Operations	Templates	QMS	Corporate	QS-T-129	Active
426	CO-OPS-T-021	Generic PSP Ranking Criteria (template)	2	Operations	Templates	QMS	Corporate	QS-T-057	Active
427	CO-LAB-FRM-002	Glycerol (For molecular biology)	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0004	Active
428	CO-PRD1-FRM-233	Glycerol Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
429	CO-OPS-SOP-124	Glycerol Solution	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-089	Active
430	CO-SUP-SOP-055	Goods Movement	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-012	Active
431	CO-SUP-JA-032	Goods Movements	0	Supply Chain	Job Aid	QMS	Corporate		Active
432	CO-LAB-LBL-005	GRN for R&D and Samples Label	3	Laboratory	Label	QMS	Corporate	QS-L-004	Active
433	CO-SUP-FRM-178	GRN Form for incoming goods	1	Supply Chain	Forms	QMS	Corporate	CO-SUP-FRM-176	Active
434	CO-LAB-REG-014	GRN Register	22	Laboratory	Registers	QMS	Corporate	QS-REG-007	Active
435	CO-QA-T-196	GSPR Template	0	Quality Assurance	Templates	QMS	Corporate		Active
436	CO-PRD1-SOP-312	Guidance for the completion of Reagent Production Manufacturing Batch Records (MBRs)	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
437	CO-LAB-SOP-176	Guidance for the use and completion of IQC documents	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-079	Active
438	CO-LAB-SOP-135	Guidance for Use and Completion of MFG Documents	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-055	Active
439	CO-LAB-SOP-145	Handling Biological Materials	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-010	Active
440	CO-QA-SOP-285	Hazard Analysis Procedure	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-RSK-001 UK-QA-SOP-001	Active
441	CO-DES-T-067	Hazard Analysis template	8	Design	Templates	QMS	Corporate	QS-T-075	Active
442	CO-H&S-PRO-001	Health & Safety Fire Related Procedures	9	Health and Safety	H&S Procedures	Business	Corporate	HS-PRO-001	Active
443	CO-H&S-PRO-006	Health and Safety Legislation Review Procedure	1	Health and Safety	H&S Procedures	Business	Corporate	HS-PRO-010	Active
444	CO-H&S-RA-017	Health and Safety Oak House Fire Risk Assessment	1	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-050	Active
445	CO-H&S-P-001	Health and Safety Policy	9	Health and Safety	H&S Policy	Business	Corporate	HS-P-001	Active
446	CO-H&S-RA-012	Health and Safety Risk Assessment for Use of a Butane Torch	1	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-046	Active
447	CO-H&S-RA-016	Health and Safety Risk Assessment Incoming	Outgoing goods and Packaging	2	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-049
448	CO-H&S-RA-018	Health and Safety Risk Assessment Oak House Covid-19	2	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-051	Active
449	CO-H&S-RA-014	Health and Safety Risk Assessment Oak House Facility	2	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-047	Active
450	CO-H&S-RA-015	Health and Safety Risk Assessment Oak House Production Activities	2	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-048	Active
451	CO-H&S-PRO-005	Health and Safety Risk Assessment Procedure	1	Health and Safety	H&S Procedures	Business	Corporate	HS-PRO-009	Active
452	CO-H&S-T-202	Health and Safety Risk Assessment Template	1	Health and Safety	Templates	Business	Corporate	HS-T-002	Active
453	CO-H&S-P-003	Health and Safety Stress Management Policy	1	Health and Safety	H&S Policy	Business	Corporate	HS-P-003	Active
454	CO-LAB-FRM-164	Heat Inactivated 2019 Novel Coronavirus Part Number 0409	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0409	Active
455	CO-OPS-PTL-029	Heated Detection Rig IQ Procedure	2	Operations	Protocol	QMS	Corporate	QS-VAL-034	Active
456	CO-OPS-PTL-009	Heated Detection Rig OQ Procedure	4	Operations	Protocol	QMS	Corporate	QS-VAL-035	Active
457	CO-LAB-SOP-130	Heated Detection Rig Work Instructions	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-061	Active
458	CO-LAB-FRM-276	High Risk Temperature Controlled Asset Sign	0	Laboratory	Forms	QMS	Corporate		Active
459	CO-LAB-FRM-140	Hot Start Taq (PCR Biosystems LTD) P/N:0344	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0344	Active
460	CO-IT-POL-027	Human Resource Security Policy	0	Information Technology	Policy	QMS	Corporate		Active
461	CO-PRD1-FRM-230	Hybridization Oven Verification and Calibration Form	0	Production line 1 - Oak House	Forms	QMS	Corporate		Active
462	CO-PRD1-FRM-251	IC  forward primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
463	CO-PRD1-FRM-247	IC di275 probe Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
464	CO-OPS-SOP-125	IC DNA in TE Buffer 100pg/ul Working Stock Aliquots	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-098	Active
465	CO-PRD1-LBL-047	IC DNA Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
466	CO-SUP-FRM-220	IC DNA Reagent Component Pick List Form	2	Supply Chain	Forms	QMS	Corporate		Active
467	CO-PRD1-LBL-040	IC DNA Reagent Vial Label	1	Production line 1 - Oak House	Label	QMS	Corporate		Active
468	CO-PRD1-FRM-252	IC reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
469	CO-LAB-FRM-017	IC Taqman Probe (FAM)	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0217	Active
472	CO-LAB-LBL-013	In process MFG material label	3	Laboratory	Label	QMS	Corporate	QS-L-012	Active
473	CO-H&S-T-204	Incident and Near Miss Reporting Form	4	Health and Safety	Templates	Business	Corporate	HS-T-001	Active
474	CO-SUP-SOP-321	Incoming Goods Procedure for deliveries into Oak House Manufacturing Site	2	Supply Chain	Standard Operating Procedure	QMS	Corporate		Active
475	CO-QC-T-115	Incoming Oligo QC Form	3	Quality Control	Templates	QMS	Corporate	QS-T-133	Active
476	CO-LAB-FRM-050	Incoming Quality Control and Specification for ‘CMO Manufactured io® Cartridges’	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0283	Active
477	CO-LAB-FRM-043	Incoming Quality Control and Specification for ‘CT Plasmid in TE buffer’ Materials binx Part Number: 0348	0	Laboratory	Forms	QMS	Corporate	QS-IQC-0348	Active
478	CO-LAB-FRM-041	Incoming Quality Control and Specification for ‘NG1 Plasmid in TE buffer’ Materials binx Part Number: 0346	0	Laboratory	Forms	QMS	Corporate	QS-IQC-0346	Active
479	CO-LAB-FRM-042	Incoming Quality Control and Specification for ‘NG2 Plasmid in TE buffer’ Materials binx Part Number: 0347	0	Laboratory	Forms	QMS	Corporate	QS-IQC-0347	Active
480	CO-PRD1-FRM-262	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQC	0	Production line 1 - Oak House	Forms	QMS	Corporate		Active
481	CO-QC-T-029	Incubator Monitoring Form	4	Quality Control	Templates	QMS	Corporate	QS-T-085	Active
482	CO-QA-T-047	Individual Training Plan Template	9	Quality Assurance	Templates	QMS	Corporate	QS-T-031	Active
483	CO-IT-POL-028	Information Security Policy	0	Information Technology	Policy	QMS	Corporate		Active
484	CO-IT-POL-029	Information Security Roles and Responsibilities	0	Information Technology	Policy	QMS	Corporate		Active
485	CO-SUP-FRM-043	Initial Risk Assessment and Supplier Approval	3	Supply Chain	Forms	QMS	Corporate	QS-T-143	Active
486	CO-DPT-ART-002	Inner lid activation label (STI/ODX)	0	Digital Product Technology	Artwork	QMS	Corporate		Active
487	CO-SUP-SOP-058	Inspection Plans	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-015	Active
488	CO-QA-T-164	Instructional Video Template	0	Quality Assurance	Templates	QMS	Corporate		Active
489	CO-SUP-SOP-072	Instructions for receipt of incoming Non-Stock goods assigning GRN numbers and labelling	13	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-007	
490	CO-SUP-SOP-277	Instructions for Receipt of incoming Stock goods assigning GRN No.s & Labelling	3	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-012 UK-SUP-SOP-007	
491	CO-LAB-SOP-095	Instrument Cleaning Procedure	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-040	Active
492	CO-OPS-SOP-036	Instrument Engineering Change Management	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-DOC-008	Active
493	CO-LAB-SOP-152	Instrument Failure Reporting SOP	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-083	Active
494	CO-CS-T-133	Instrument Field Visit	1	Customer Support	Templates	QMS	Corporate	QS-T-189	Active
495	CO-OPS-REG-026	Instrument Register	6	Operations	Registers	QMS	Corporate	QS-REG-028	Active
496	CO-CS-SOP-368	Instrument Service & Repair Procedure	4	Customer Support	Standard Operating Procedure	QMS	Corporate	QS-OPS-007	Active
497	CO-CS-T-149	Instrument Trouble Shooting Script	1	Customer Support	Templates	QMS	Corporate	QS-T-188	Active
498	CO-OPS-LBL-027	Interim CTNG CLIA Waiver Outer Shipper Label	1	Operations	Label	QMS	Corporate	QS-L-028	Active
499	CO-PRD1-LBL-033	Intermediate reagent labels	0	Production line 1 - Oak House	Label	QMS	Corporate		Active
500	CO-QA-SOP-004	Internal Audit	12	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-002	Active
501	CO-LAB-FRM-109	Internal Control di275 Probe from ATDBio Part Number 0294	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0294	Active
502	CO-QA-T-012	Internal Training Form	4	Quality Assurance	Templates	QMS	Corporate	QS-T-027	Active
503	CO-LAB-SOP-149	Introducing New Laboratory Equipment	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-030	Active
504	CO-LAB-SOP-287	Introduction of New microorganisms SOP	1	Laboratory	Standard Operating Procedure	QMS	Corporate	UK-LAB-SOP-236	Active
505	CO-PRD1-JA-009	Intruder Alarm	0	Production line 1 - Oak House	Job Aid	QMS	Corporate		Active
506	CO-SUP-SOP-044	Invoice Customers Manually	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-024	Active
507	CO-CS-SOP-249	io Insepction using Data Collection Cartridge	0	Customer Support	Standard Operating Procedure	QMS	Corporate		Out For Revision
508	CO-CS-FRM-175	io Inspection using Data Collection Cartridge Form	0	Customer Support	Forms	QMS	Corporate		Out For Revision
509	CO-QC-LBL-052	io Instrument Failure - For Engineering Inspection Label	0	Quality Control	Label	QMS	Corporate		Active
510	CO-OPS-PTL-023	io Reader - Digital Pressure Regulator Calibration Protocol	2	Operations	Protocol	QMS	Corporate	QS-VAL-022	Active
511	CO-OPS-PTL-025	io Reader – Force End Test Protocol	2	Operations	Protocol	QMS	Corporate	QS-VAL-024	Active
512	CO-OPS-PTL-024	io Reader - Pneumatics End Test Protocol	1	Operations	Protocol	QMS	Corporate	QS-VAL-023	Out For Revision
513	CO-QC-SOP-299	io Reader interface - barcode scan rate	3	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-EXP-045 UK-QC-SOP-014	Active
514	CO-OPS-PTL-048	io Release Record (following repair or refurbishment)	3	Operations	Protocol	QMS	Corporate	QS-QCP-067	Active
515	CO-OPS-PTL-026	io® Reader – Thermal End Test Protocol	2	Operations	Protocol	QMS	Corporate	QS-VAL-025	Out For Revision
516	CO-LAB-PTL-045	IQ Protocol for Binder incubator and humidity chamber	0	Laboratory	Protocol	QMS	Corporate		Active
517	CO-OPS-PTL-040	IQ Validation Protocol Blister Filling Rig	1	Operations	Protocol	QMS	Corporate	QS-VAL-058	Active
518	CO-DES-PTL-005	IQ/OQ for Agilent Bioanalyzer	2	Design	Protocol	QMS	Corporate	QS-VAL-019	Active
519	CO-FIN-T-026	IT GAMP Evaluation Form	4	Finance	Templates	QMS	Corporate	QS-T-081	Active
520	CO-IT-SOP-044	IT Management	Back-UP and Support	5	Information Technology	Standard Operating Procedure	QMS	Corporate	QS-DOC-006
521	CO-FIN-T-027	IT Request for Information	3	Finance	Templates	QMS	Corporate	QS-T-082	Active
522	CO-DPT-IFU-026	It s as Easy as 1 2 3 (Ft. the ADx Card Collection Method) (English Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate		
523	CO-DES-T-022	IVD Directive - Essential Requirements Check List Template	4	Design	Templates	QMS	Corporate	QS-T-058	Active
524	CO-LAB-SOP-168	Jenway 3510 model pH Meter	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-056	Active
525	CO-PRD1-SOP-319	Jenway 3510 model pH Meter with ATC probe and 924 30 6.0mm model Tris electrode SOP in Oak House	2	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
526	CO-CS-JA-050	Job Aid _Field Service-Instrument cleaning	0	Customer Support	Job Aid	QMS	Corporate		Active
527	CO-QA-T-153	Job Aid Template	2	Quality Assurance	Templates	QMS	Corporate	QS-T-204	Active
528	CO-QC-JA-012	Job Aid: A Guide to QC Cartridge Inspections	0	Quality Control	Job Aid	QMS	Corporate	UK-QC-JA-003	Active
529	CO-OPS-URS-028	Keyence LM Series - User Requirements Specification	0	Operations	User Requirements Specification	QMS	Corporate		Active
530	CO-QC-T-016	Lab Cleaning Form	8	Quality Control	Templates	QMS	Corporate	QS-T-044	Active
531	CO-QC-T-103	Lab investigation initiation Template	1	Quality Control	Templates	QMS	Corporate	QS-T-184a	Active
532	CO-QC-T-128	LAB investigation summary report	1	Quality Control	Templates	QMS	Corporate	QS-T-184b	Active
533	CO-PRD1-SOP-276	Label printing	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
534	CO-LAB-SOP-108	Laboratory Cleaning	21	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-019	Active
535	CO-QC-SOP-173	Laboratory Investigation (LI) Procedure for Invalid Assays and Out of Specification (OOS) Results	3	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-LAB-069	Active
536	CO-LAB-REG-019	Laboratory Investigation Register	1	Laboratory	Registers	QMS	Corporate	QS-REG-052	Active
537	CO-LAB-REG-021	Laboratory Responsibilities by Area	9	Laboratory	Registers	QMS	Corporate	QS-REG-202	Active
538	CO-QA-JA-002	Legacy Document Number Crosswalk	6	Quality Assurance	Job Aid	QMS	Corporate		Active
539	CO-LAB-SOP-182	Limited Laboratory Access Procedure	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-086	Out For Revision
540	CO-QC-T-137	Limited Laboratory Access Work Note	1	Quality Control	Templates	QMS	Corporate	QS-T-193	Active
541	CO-LAB-FRM-277	Low Risk Temperature Controlled Asset Sign	0	Laboratory	Forms	QMS	Corporate		Active
542	CO-PRD1-FRM-239	Magnesium chloride Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
543	CO-SUP-SOP-039	Manage Quality Codes	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-018	Active
544	CO-LAB-SOP-151	Management and Control of Critical and Controlled Equipment	10	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-012	Active
545	CO-PRD1-SOP-304	Management of Critical and Controlled Equipment at Oak House Production Facility	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
546	CO-QA-SOP-025	Management Review	11	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-004	Active
547	CO-QA-SOP-147	Managing an External Regulatory Visit from the FDA	4	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-014	Active
548	CO-SUP-SOP-067	Managing Expired Identified Stock	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-036	Active
549	CO-LAB-FRM-207	Manipulated Material Aliquot form	0	Laboratory	Forms	QMS	Corporate		Active
550	CO-H&S-PRO-003	Manual Lifting Procedure	5	Health and Safety	H&S Procedures	Business	Corporate	HS-PRO-003	Active
551	CO-SUP-JA-030	Manual MRP Process (binx ERP system) and Releasing Purchase / Production Proposals	0	Supply Chain	Job Aid	QMS	Corporate		Active
552	CO-OPS-SOP-206	Manufacture of 1.5 M Trehalose	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-161	Active
553	CO-OPS-SOP-205	Manufacture of 200mM Tris pH8.0	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-160	Active
554	CO-OPS-SOP-213	Manufacture of 20X N/O LAMP Primer Mix	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-173	Active
555	CO-OPS-SOP-214	Manufacture of 20X RP LAMP Primer Mix	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-174	Active
556	CO-OPS-SOP-227	Manufacture of 50x PSF Buffer No Ammonium Acetate	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-187	Active
557	CO-OPS-SOP-216	Manufacture of 9.52mM Ammonium Acetate elution reagent	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-176	Active
558	CO-OPS-SOP-228	Manufacture of Ab-HS Taq/UNG Reagent	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-188	Active
559	CO-OPS-SOP-133	Manufacture of Brij 58 Solution	8	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-056	Active
560	CO-QC-PTL-071	Manufacture of Cartridge Reagents	1	Quality Control	Protocol	QMS	Corporate	MOB-VAL-005	Active
561	CO-OPS-SOP-200	Manufacture of Chlamydia trachomatis and Neisseria gonorrhoeae positive control samples	8	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-140	Active
562	CO-PRD1-FRM-199	Manufacture of CT/IC Detection Reagent	5	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
563	CO-PRD1-FRM-200	Manufacture of CT/IC Primer Passivation Reagent	2	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
564	CO-OPS-SOP-118	Manufacture of CT/IC Primer Passivation Reagent	5	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-101	Active
565	CO-LAB-SOP-199	Manufacture of CT/NG Negative Control Samples	7	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-MFG-135	Active
566	CO-PRD1-FRM-202	Manufacture of CT/NG Taq/UNG Reagent	3	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
567	CO-OPS-SOP-229	Manufacture of CT/TV/IC Primer Buffer Reagent	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-189	Active
568	CO-QC-PTL-070	Manufacture of CTNG Cartridge Reagents	1	Quality Control	Protocol	QMS	Corporate	MOB-VAL-003	Active
569	CO-OPS-SOP-132	Manufacture of Elution Buffer Revision 2	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-054	Active
570	CO-PRD1-FRM-203	Manufacture of IC DNA Reagent	3	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
571	CO-OPS-SOP-117	Manufacture of IC DNA Reagent’	5	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-099	Active
572	CO-OPS-SOP-207	Manufacture of Lactobacillus delbrueckii subsp. lactis glycerol stocks	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-162	Active
573	CO-OPS-SOP-215	Manufacture of Lysis buffer with 55.5% ethanol	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-175	Active
574	CO-OPS-SOP-198	Manufacture of microorganism glycerol stocks	6	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-117	Active
575	CO-PRD1-FRM-197	Manufacture of NG1/IC Detection Reagent	4	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
576	CO-OPS-SOP-119	Manufacture of NG1/NG2/IC Primer Passivation Reagent	8	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-102	Active
577	CO-PRD1-FRM-201	Manufacture of NG1/NG2/IC Primer Passivation Reagent	2	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
578	CO-OPS-SOP-107	Manufacture of NG2/IC Detection Reagent	7	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-132	Active
579	CO-PRD1-FRM-198	Manufacture of NG2/IC Detection Reagent	4	Production line 1 - Oak House	Forms	QMS	Corporate		Out For Revision
580	CO-OPS-SOP-204	Manufacture of Qnostic Input Generation for QS-QCP-052	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-158	Active
581	CO-OPS-SOP-219	Manufacture of SARS-CoV-2 ‘N’ detection reagent	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-179	Active
582	CO-OPS-SOP-220	Manufacture of SARS-CoV-2 ‘O’ detection reagent	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-180	Active
583	CO-OPS-SOP-221	Manufacture of SARS-CoV-2 ‘RP’ detection reagent	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-181	Active
584	CO-OPS-SOP-230	Manufacture of SARS-CoV-2 3.13% Triton Solution	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-194	Active
585	CO-OPS-SOP-217	Manufacture of SARS-CoV-2 Assay Blisters	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-177	Active
586	CO-OPS-SOP-226	Manufacture of SARS-CoV-2 cartridges	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-186	Active
587	CO-OPS-SOP-224	Manufacture of SARS-CoV-2 Enzyme reagent	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-184	Active
588	CO-LAB-SOP-225	Manufacture of SARS-CoV-2 Magnesium-Triton reagent	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-MFG-185	Active
589	CO-OPS-SOP-222	Manufacture of SARS-CoV-2 N/O primer reagent	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-182	Active
590	CO-OPS-SOP-223	Manufacture of SARS-CoV-2 RP primer reagent	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-183	Active
591	CO-OPS-SOP-197	Manufacture of Taq/UNG Reagent	9	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-100	Active
592	CO-OPS-SOP-134	Manufacture of Trehalose in PCR Buffer	7	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-095	Active
593	CO-OPS-SOP-091	Manufacture of TV/IC Detection Reagent	5	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-190	Active
594	CO-OPS-SOP-203	Manufacture of Wash Buffer II	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-157	Active
595	CO-PRD1-T-165	Manufacturing Batch Record (MBR) Template	1	Production line 1 - Oak House	Templates	QMS	Corporate		Active
596	CO-PRD1-T-200	Manufacturing Batch Record (MBR) Template - DEV#28	0	Production line 1 - Oak House	Templates	QMS	Corporate		Active
597	CO-LAB-REG-008	Manufacturing Lot Number Register	5	Laboratory	Registers	QMS	Corporate	QS-REG-003	Active
598	CO-PRD1-SOP-370	Manufacturing Overview for CT/NG Taq/UNG Reagent	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
599	CO-PRD1-SOP-355	Manufacturing Overview for Detection Reagents	2	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
600	CO-PRD1-SOP-369	Manufacturing Overview for IC DNA Reagent	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
601	CO-PRD1-SOP-365	Manufacturing Overview for Primer/Passivation Reagents	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
602	CO-PRD1-SOP-306	Manufacturing Overview for the binx Cartridge Reagent Manufacturing Facility	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
603	CO-OPS-T-019	Manufacturing Partner Ranking Criteria	2	Operations	Templates	QMS	Corporate	QS-T-055	Active
604	CO-OPS-T-152	Manufacturing Procedure (MFG) Template	1	Operations	Templates	QMS	Corporate		Active
605	CO-SUP-SOP-043	Mark Sales Orders as Despatched	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-023	Active
606	CO-SAM-T-101	Marketing template	2	Sales and Marketing	Templates	QMS	Corporate	QS-T-179	Active
607	CO-QA-REG-023	Master Archive Register	2	Quality Assurance	Registers	QMS	Corporate	QS-REG-047	Active
608	CO-QA-REG-032	Master List of Applicable Standards Form Template	0	Quality Assurance	Registers	QMS	Corporate		Active
609	CO-QC-QCP-058	Material Electrochemical Signal Interference - Electrochemical detection assessment	1	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-060 UK-QC-QCP-035	Active
610	CO-OPS-T-001	Material Transfer Agreement	4	Operations	Templates	QMS	Corporate	QS-T-012	Active
611	CO-OPS-T-002	Material Transfer Agreement (binx recipient)	2	Operations	Templates	QMS	Corporate	QS-T-012a	Active
612	CO-LAB-LBL-016	MBG water label	3	Laboratory	Label	QMS	Corporate	QS-L-017	Active
613	CO-PRD1-FRM-229	MBG Water Oak House Production IQC	2	Production line 1 - Oak House	Forms	QMS	Corporate		Active
614	CO-OPS-SOP-193	MBR to record the details of the manufacture of “T7 storage buffer”	5	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-079	Active
615	CO-PRD1-FRM-212	ME2002T/00 and ML104T/00 Balance Weight Verification Form	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
616	CO-DES-PTL-001	Measuring pH values IQ/OQ Protocol	2	Design	Protocol	QMS	Corporate	QS-VAL-031	Active
617	CO-LAB-FRM-120	Metronidazole resistant Trichomonas Vaginalis Cultured Stocks Part no. 0312	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0312	Active
618	CO-OPS-SOP-218	MFG for Pooled Negative Nasal Matrix	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-178	Active
619	CO-OPS-SOP-090	MFG for preparing male and female urine with 10% eNAT	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-137	Active
620	CO-OPS-SOP-195	MFG for the preparation of Pectobacterium atrosepticum chromosomal DNA in TE buffer	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-092	Active
675	CO-SUP-T-171	Oak House Commercial Invoice - Cartridge Reagent (-20°c)	1	Supply Chain	Templates	QMS	Corporate		Active
621	CO-LAB-SOP-194	MFG for the preparation of Pectobacterium atrosepticum glycerol starter cultures	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-MFG-091	Active
622	CO-QC-FRM-046	Micro Monthly Laboratory Checklist-Rev_0	0	Quality Control	Forms	QMS	Corporate		Active
623	CO-LAB-FRM-012	Microbank Cryovials	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0159	Active
624	CO-QC-T-073	Microbiology Laboratory Cleaning record	8	Quality Control	Templates	QMS	Corporate	QS-T-100	Active
625	CO-LAB-SOP-239	Microorganism Ampoules Handling SOP	0	Laboratory	Standard Operating Procedure	QMS	Corporate		Active
626	CO-PRD1-SOP-255	Mini Fuge Plus centrifuge SOP	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
627	CO-QC-T-118	Moby Detection Reagent Analysis Spreadsheet	12	Quality Control	Templates	QMS	Corporate	QS-T-153	Active
628	CO-QC-PTL-060	MOBY Detection Reagent Spreadsheet Validation Protocol	0	Quality Control	Protocol	QMS	Corporate	MOB-VAL-014	Active
629	CO-DES-PTL-004	Monmouth 1200	2	Design	Protocol	QMS	Corporate	QS-VAL-015	Active
630	CO-OPS-SOP-092	mSTI Cartridge Manufacture	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-191	Active
631	CO-OPS-T-043	Mutual Agreement of Confidentiality	5	Operations	Templates	QMS	Corporate	QS-T-011	Active
632	CO-SUP-SOP-005	New Customer Procedure	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-OPS-010	Active
633	CO-SUP-SOP-040	New Customer Set-Up	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-020	Active
634	CO-SUP-SOP-231	New Items	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-001	Active
635	CO-LAB-FRM-165	New Microorganism Introduction Checklist Form	0	Laboratory	Forms	QMS	Corporate		Active
636	CO-SUP-SOP-061	New Project Set-Up	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-030	Active
637	CO-SUP-JA-036	New Stock Adjustment	0	Supply Chain	Job Aid	QMS	Corporate		Active
638	CO-SUP-SOP-052	New Supplier Set-Up	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-009	Active
639	CO-LAB-FRM-021	NG1  di452 Probe from SGS	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0290	Active
640	CO-PRD1-FRM-248	NG1 di452 probe Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
641	CO-PRD1-FRM-253	NG1 forward primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
642	CO-PRD1-LBL-043	NG1 IC Detection Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
643	CO-SUP-FRM-216	NG1 IC Detection Reagent Component Pick List Form	2	Supply Chain	Forms	QMS	Corporate		Active
644	CO-PRD1-LBL-036	NG1 IC Detection Reagent Vial Label	1	Production line 1 - Oak House	Label	QMS	Corporate		Active
645	CO-PRD1-LBL-045	NG1 NG2 IC Primer Passivation Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
646	CO-SUP-FRM-218	NG1 NG2 IC Primer Passivation Reagent Component Pick List Form	2	Supply Chain	Forms	QMS	Corporate		Active
647	CO-PRD1-LBL-038	NG1 NG2 IC Primer Passivation Reagent Vial Label	1	Production line 1 - Oak House	Label	QMS	Corporate		Active
648	CO-QC-QCP-054	NG1 Plasmid Quantification - qPCR Test (Part No. 0346)	1	Quality Control	Quality Control Protocol	QMS	Corporate	UK-QC-QCP-044	Active
649	CO-PRD1-FRM-254	NG1 Reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
650	CO-LAB-FRM-084	NG1 Synthetic Target Part No 0258	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0258	Active
651	CO-LAB-FRM-094	NG1 Taqman Probe HPLC GRADE Part no 0268	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0268	Active
652	CO-OPS-SOP-105	NG1_IC Detection Reagent	8	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-131	Active
653	CO-LAB-FRM-022	NG2  di452 Probe from SGS	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0291	Active
654	CO-PRD1-FRM-227	NG2 di452 probe Oak House production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
655	CO-PRD1-FRM-255	NG2 forward primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
656	CO-PRD1-LBL-044	NG2 IC Detection Reagent Box Label	2	Production line 1 - Oak House	Label	QMS	Corporate		Active
657	CO-SUP-FRM-217	NG2 IC Detection Reagent Component Pick List Form	2	Supply Chain	Forms	QMS	Corporate		Active
658	CO-PRD1-LBL-037	NG2 IC Detection Reagent Vial Label	1	Production line 1 - Oak House	Label	QMS	Corporate		Active
659	CO-QC-QCP-053	NG2 Plasmid Quantification - qPCR Test (Part No. 0347)	1	Quality Control	Quality Control Protocol	QMS	Corporate	UK-QC-QCP-045	Active
660	CO-PRD1-FRM-256	NG2 reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
661	CO-LAB-FRM-085	NG2 Synthetic Target Part no 0259	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0259	Active
662	CO-LAB-FRM-095	NG2 Taqman probe HPLC GRADE Part No 0269	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0269	Active
663	CO-SUP-T-098	Non Approved Supplier SAP by D supplier information	4	Supply Chain	Templates	QMS	Corporate	QS-T-173	Active
664	CO-CA-FRM-044	Non-binx-initiated study proposal	1	Clinical Affairs	Forms	QMS	Corporate	QS-T-209	Active
665	CO-QA-SOP-003	Nonconforming Product Procedure	18	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-001	Active
666	CO-DPT-WEB-005	Non-COVID Consent	0	Digital Product Technology	Website Content	QMS	Corporate		Active
667	CO-DPT-WEB-008	Non-COVID Consent (Spanish)	0	Digital Product Technology	Website Content	QMS	Corporate		Active
668	CO-OPS-SOP-126	NZ Source BSA Solution	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-065	Active
669	CO-PRD1-PTL-102	Oak House APC Schneider UPS Asset  1116 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
670	CO-PRD1-PTL-103	Oak House APC Schneider UPS Asset  1117 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
671	CO-PRD1-PTL-104	Oak House APC Schneider UPS Asset  1118 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
672	CO-PRD1-PTL-105	Oak House APC Schneider UPS Asset  1176 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
673	CO-PRD1-PTL-106	Oak House APC Schneider UPS Asset  1177 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
674	CO-SUP-JA-041	Oak House Check Task Confirmation	0	Supply Chain	Job Aid	QMS	Corporate		Active
676	CO-SUP-T-182	Oak House Commercial Invoice - Cartridge Reagent (2-8°c)	1	Supply Chain	Templates	QMS	Corporate		Active
677	CO-SUP-FRM-209	Oak House Cycle Counting stock sheet	0	Supply Chain	Forms	QMS	Corporate		Active
678	CO-PRD1-SOP-265	Oak House Emergency Procedures	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
679	CO-PRD1-PTL-075	Oak House Environmental Control System Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
680	CO-PRD1-REG-035	Oak House Equipment Service and Calibration Register	1	Production line 1 - Oak House	Registers	QMS	Corporate	OAK-REG-002	Active
681	CO-PRD1-PTL-090	Oak House Haier DW-86L338J Freezer 1155 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
682	CO-PRD1-PTL-078	Oak House Jenway 3510 pH Meter Asset 1143 Validation Protocol	1	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
683	CO-SUP-FRM-213	Oak House Lab Replenishment Form	0	Supply Chain	Forms	QMS	Corporate		Active
684	CO-PRD1-PTL-093	Oak House Labcold RLDF0519 Fridge 1161 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
685	CO-PRD1-PTL-091	Oak House Labcold RLDF1519 Fridge 1157 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
686	CO-PRD1-PTL-092	Oak House Labcold RLDF1519 Fridge 1159 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
687	CO-PRD1-PTL-097	Oak House Labcold RLDF1519 Fridge 1207 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
688	CO-PRD1-PTL-095	Oak House Labcold RLVF0417 Freezer 1162 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
689	CO-PRD1-PTL-094	Oak House Labcold RLVF1517 Freezer 1158 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
690	CO-PRD1-PTL-096	Oak House Labcold RLVF1517 Freezer 1183 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
691	CO-PRD1-PTL-098	Oak House Labcold RLVF1517 Freezer 1208 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
692	CO-SUP-JA-040	Oak House Make Task Confirmation	0	Supply Chain	Job Aid	QMS	Corporate		Active
693	CO-PRD1-T-199	Oak House Manufacturing Overview SOP Template	0	Production line 1 - Oak House	Templates	QMS	Corporate		Active
694	CO-PRD1-PTL-087	Oak House Mettler Toledo ME2002T_00 Precision Balance Asset 1170 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
695	CO-PRD1-PTL-088	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1171 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
696	CO-PRD1-PTL-089	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1172 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
697	CO-PRD1-FRM-181	Oak House Monthly Production Facility Checklist	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
698	CO-PRD1-PTL-099	Oak House MSC1800 Production Enclosure Asset 1168 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
699	CO-PRD1-SOP-303	Oak House Out of Hours Procedures	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
700	CO-SUP-T-183	Oak House Packing List - Cartridge Reagent (-20°c)	1	Supply Chain	Templates	QMS	Corporate		Active
701	CO-SUP-T-172	Oak House Packing List - Cartridge Reagent (2-8°c)	1	Supply Chain	Templates	QMS	Corporate		Active
702	CO-PRD1-REG-036	Oak House Pipette Register	0	Production line 1 - Oak House	Registers	QMS	Corporate	OAK-REG-003	Active
703	CO-PRD1-SOP-269	Oak House Pipette Use and Calibration SOP	2	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
704	CO-PRD1-T-160	Oak House Production Facility Cleaning Record	1	Production line 1 - Oak House	Templates	QMS	Corporate		Active
705	CO-PRD1-COP-003	Oak House Production Facility Code of Practice	0	Production line 1 - Oak House	Code of Practice	QMS	Corporate		Active
706	CO-SUP-FRM-210	Oak House Re-Order form for Supply Chain	0	Supply Chain	Forms	QMS	Corporate		Active
707	CO-PRD1-PTL-100	Oak House Roto-Therm H2024-E Hybridisation Oven Asset 1113 Validation Protocol	0	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
708	CO-SUP-SOP-320	Oak House Supply Chain Reagent Production Process Flow	4	Supply Chain	Standard Operating Procedure	QMS	Corporate		Active
709	CO-SUP-JA-039	Oak House Supply Task Confirmation	0	Supply Chain	Job Aid	QMS	Corporate		Active
710	CO-LAB-SOP-177	Operating instruction for the QuantStudio 3D digital PCR system	1	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-080	Active
711	CO-LAB-SOP-178	Operating Instructions for Signal Analyser	1	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-081	Active
712	CO-LAB-SOP-022	Operation & Maintenance of Grant SUB Aqua Pro 5 (SAP5) unstirred Water Bath with Labarmor Beads	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-078	Active
713	CO-LAB-PTL-046	OQ protocol for binder incubator and humidity chamber	0	Laboratory	Protocol	QMS	Corporate		Active
714	CO-OPS-PTL-039	OQ Validation Protocol Blister Filling Rig	1	Operations	Protocol	QMS	Corporate	QS-VAL-059	Active
715	CO-DPT-ART-009	Oral STI Sample Collection Sticker	0	Digital Product Technology	Artwork	QMS	Corporate		Active
716	CO-DPT-VID-003	Oral Swab Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	QMS	Corporate		Active
717	CO-SUP-SOP-075	Order to Cash	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-019	Active
718	CO-LAB-SOP-241	Ordering of New Reagents and Chemicals	0	Laboratory	Standard Operating Procedure	QMS	Corporate		Active
719	CO-LAB-SOP-175	Out of Hours Power Loss and Temperature Monitoring	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-077	Active
720	CO-DPT-ART-001	Outer bag label Nasal PCR Bag Bulk Kit	0	Digital Product Technology	Artwork	QMS	Corporate		Active
721	CO-SUP-SOP-324	Packaging and Shipping Procedure for binx Cartridge Reagent	2	Supply Chain	Standard Operating Procedure	QMS	Corporate		Active
722	CO-OPS-PTL-043	PAN-D-267 Signal Analyzer Validation of functions for outputting V&V tables	1	Operations	Protocol	QMS	Corporate	QS-VAL-056	Active
723	CO-LAB-FRM-001	Part No 0001 Agarose	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0001	Active
724	CO-LAB-FRM-014	Part No 0180 Brij 58	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0180	Active
725	CO-LAB-FRM-015	Part No 0181 ROSS fill solution pH Electrode	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0181	Active
726	CO-LAB-FRM-087	Part No 0261 ‘CT Reverse Mod Primer’ from SGS DNA	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0261	Active
727	CO-LAB-FRM-088	Part No 0262 ‘IC Forward Primer’ from SGS DNA	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0262	Out For Revision
728	CO-LAB-FRM-089	Part No 0263 ‘IC Reverse Primer’ from SGS DNA	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0263	Active
729	CO-LAB-FRM-090	Part No 0264 ‘NG Target 1 Forward Primer’ from SGS DNA	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0264	Active
730	CO-LAB-FRM-091	Part No 0265 ‘NG Target 1 RA Reverse Primer’ from SGS DNA	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0265	Active
731	CO-LAB-FRM-092	Part No 0266 ‘NG Target 2 Forward Primer’ from SGS DNA	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0266	Active
732	CO-LAB-FRM-093	Part No 0267 ‘NG Target 2 Reverse Primer’ from SGS DNA	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0267	Active
733	CO-LAB-LBL-006	Part No GRN Label	3	Laboratory	Label	QMS	Corporate	QS-L-005	Active
734	CO-LAB-REG-012	Part No Register	1	Laboratory	Registers	QMS	Corporate	QS-REG-004	Active
735	CO-LAB-FRM-054	Part No. 0014 ‘Potassium Chloride’	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0014	Active
736	CO-LAB-FRM-057	Part No. 0085 Buffer solution pH 4	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0085	Active
737	CO-LAB-FRM-056	Part No. 0086 Buffer solution pH 7	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0086	Active
738	CO-LAB-FRM-058	Part No. 0087 Buffer solution pH 10	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0087	Active
739	CO-LAB-FRM-060	Part no. 0089	70% ethanol	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0089
740	CO-LAB-FRM-061	Part No. 0093 CT ME17 Synthetic target HPLC GRADE	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0093	Active
741	CO-LAB-FRM-064	Part No. 0104 – Tryptone Soya Broth	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0104	Active
742	CO-LAB-FRM-008	Part No. 0117 Sterile Syringe filter with 0.2 µm cellulose acetate membrane	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0117	Active
743	CO-LAB-FRM-069	Part No. 0118 IC Synthetic target HPLC GRADE	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0118	Active
744	CO-LAB-FRM-070	Part No. 0125 Potassium Phospate Monobasic	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0125	Active
745	CO-LAB-FRM-011	Part no. 0141 Albumin from Bovine serum	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0141	Active
746	CO-LAB-FRM-078	Part no. 0222 CO2 Gen sachets	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0222	Active
747	CO-LAB-FRM-082	Part No. 0248 Pectobacterium atrosepticum chromosomal DNA in TE buffer	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0248	Active
748	CO-LAB-FRM-110	Part No. 0295 ‘Sterile Syringe Filter with 0.45µm Cellulose Acetate Membrane’	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0295	Active
749	CO-LAB-FRM-111	Part No. 0296 Chlamydia trachomatis serovar F ATCC VR-346	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0296	Active
750	CO-LAB-FRM-121	Part No. 0316 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.45 µm surfactant-free Cellulose Acetate Membrane’	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0316	Active
751	CO-LAB-FRM-122	Part No. 0317 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane’	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0317	Active
752	CO-LAB-FRM-123	Part No. 0318  NATtrol Chlamydia trachomatis Positive Control	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0318	Active
753	CO-LAB-FRM-124	Part No. 0319 NATrol Neisseria gonorrhoeae Positive Control	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0319	Active
754	CO-LAB-FRM-136	Part No. 0339 ‘NG2_di275_probe’ from SGS DNA	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0339	Active
755	CO-LAB-FRM-141	Part No. 0345 CampyGen  sachets	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0345	Active
756	CO-LAB-FRM-076	Part Number 0188 Vircell CT DNA Control	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0188	Active
757	CO-LAB-FRM-112	Part Number 0298 Vircell NG DNA Control	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0298	Active
758	CO-LAB-FRM-113	Part Number 0299 Vircell TV DNA control	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0299	Active
759	CO-LAB-FRM-114	Part Number 0300 Vircell MG DNA Control	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0300	Active
760	CO-H&S-P-002	PAT Policy	6	Health and Safety	H&S Policy	Business	Corporate	HS-P-002	Active
761	CO-PRD1-FRM-257	Pectobacterium atrosepticum (IC) DNA buffer Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
762	CO-PRD1-FRM-258	pH Buffer Bottle 10.01 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
763	CO-PRD1-FRM-260	pH Buffer Bottle 4.01 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
764	CO-PRD1-FRM-259	pH Buffer Bottle 7.00 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
765	CO-QC-T-030	pH Meter Calibration Form	3	Quality Control	Templates	QMS	Corporate	QS-T-086	Active
766	CO-PRD1-FRM-211	pH Meter Calibration form - 3 point	2	Production line 1 - Oak House	Forms	QMS	Corporate		Active
767	CO-DES-T-005	Phase Review Record	2	Design	Templates	QMS	Corporate	QS-T-018b	Active
768	CO-IT-POL-030	Physical Security Policy	0	Information Technology	Policy	QMS	Corporate		Active
769	CO-LAB-SOP-184	Pilot Line Blister Filling and Sealing Standard Operating Procedure	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-088	Out For Revision
770	CO-SUP-SOP-278	Pilot Line Electronic Stock Control	8	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-010 UK-SUP-SOP-005	Active
771	CO-DES-T-084	Pilot Line Electronic Stock Register	5	Design	Templates	QMS	Corporate	QS-T-141	Active
772	CO-LAB-LBL-023	Pilot Line Materials Label	1	Laboratory	Label	QMS	Corporate	QS-L-024	Active
773	CO-DES-PTL-007	Pilot Line Process & Equipment Validation	3	Design	Protocol	QMS	Corporate	QS-VAL-026	Active
774	CO-DES-T-112	Pilot Line Use Log	6	Design	Templates	QMS	Corporate	QS-T-130	Active
775	CO-LAB-LBL-008	Pipette Calibration Label	1	Laboratory	Label	QMS	Corporate	QS-L-007	Active
776	CO-PRD1-FRM-182	Pipette Internal Verification Form	2	Production line 1 - Oak House	Forms	QMS	Corporate		Active
777	CO-LAB-REG-013	Pipette Register	3	Laboratory	Registers	QMS	Corporate	QS-REG-005	Active
778	CO-LAB-SOP-131	Pipette Use and Calibration SOP	12	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-001	Active
779	CO-OPS-SOP-002	Planning for Process Validation	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-V-003	Active
780	CO-OPS-SOP-166	Pneumatics Test Rig Set up and Calibration	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-050	Active
781	CO-SUP-POL-017	Policy for Commercial Operations	3	Supply Chain	Policy	QMS	Corporate	QS-POL-014 UK-SUP-POL-004	Active
782	CO-QA-POL-013	Policy for Complaints and Vigilance	2	Quality Assurance	Policy	QMS	Corporate	QS-POL-017	Active
783	CO-QA-POL-010	Policy for Control of Infrastructure	Environment and Equipment	5	Quality Assurance	Policy	QMS	Corporate	QS-POL-008
784	CO-CS-POL-012	Policy for Customer Feedback	5	Customer Support	Policy	QMS	Corporate	QS-POL-012	Active
785	CO-QA-POL-006	Policy for Document Control and Change Management	5	Quality Assurance	Policy	QMS	Corporate	QS-POL-002	Active
786	CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	4	Operations	Policy	QMS	Corporate	QS-POL-004	Out For Revision
787	CO-QA-POL-014	Policy for the Control of Non-Conforming Product and Corrective/Preventive Action	4	Quality Assurance	Policy	QMS	Corporate	QS-POL-005	Active
788	CO-QA-POL-015	Policy for the Use of Electronic Signatures within binx health	0	Quality Assurance	Policy	QMS	Corporate		Active
789	CO-QA-T-010	Policy Template	5	Quality Assurance	Templates	QMS	Corporate	QS-T-024	Active
790	CO-OPS-SOP-212	Pooled male urine samples and male collection kits for CT/NG CLIA waiver field study	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-172	Active
791	CO-OPS-SOP-211	Pooled vaginal swab samples for CT/NG CLIA waiver field study	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-171	Active
792	CO-QA-SOP-267	Post Market Surveillance	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-013	Out For Revision
793	CO-QA-T-192	Post Market Surveillance Plan Template	0	Quality Assurance	Templates	QMS	Corporate		Active
794	CO-QA-T-193	Post Market Surveillance Report Template	0	Quality Assurance	Templates	QMS	Corporate		Active
795	CO-PRD1-FRM-223	Potassium Chloride Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
796	CO-OPS-SOP-127	Potassium Phosphate Buffer	7	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-017	Active
797	CO-PRD1-FRM-225	Potassium phosphate dibasic Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
798	CO-LAB-FRM-071	Potassium Phosphate Dibasic’ Part No.0147	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0147	Active
799	CO-PRD1-FRM-234	Potassium phosphate monobasic Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
800	CO-LAB-PTL-047	PQ Protocol for binder incubator and humidity chamber	0	Laboratory	Protocol	QMS	Corporate		Active
801	CO-LAB-SOP-302	Preparation and use of agarose gels	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-010 UK-QC-SOP-011	Active
802	CO-LAB-SOP-301	Preparation Microbiological Broth & Agar	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-011 UK-QC-SOP-012	Active
803	CO-LAB-SOP-291	Preparation of 10X and 1X TAE Buffer	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-022 UK-QC-SOP-233	Active
804	CO-LAB-SOP-078	Preparation of Bacterial Stocks (Master & Working)	6	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-016	Active
805	CO-OPS-SOP-209	Preparation of bulk male urine plus 10% eNAT (v/v)	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-164	Active
806	CO-OPS-SOP-085	Preparation of Chlamydia trachomatis 1	000	000 Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	QMS	Corporate
807	CO-OPS-SOP-086	Preparation of Chlamydia trachomatis 100000 Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-199	
808	CO-OPS-SOP-191	Preparation of Chlamydia trachomatis master stock aliquots	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-093	Active
809	CO-OPS-SOP-190	Preparation of IC DNA in TE buffer 10ng/μl master stock aliquots	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-097	Active
810	CO-OPS-SOP-087	Preparation of Neisseria gonorrhoeae 1000000 Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	QMS	Corporate		
811	CO-OPS-SOP-088	Preparation of Neisseria gonorrhoeae 100000 Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-201	
812	CO-LAB-SOP-300	Preparation of Sub-circuit cards for voltammetric detection	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-021 UK-QC-SOP-013	Active
813	CO-OPS-SOP-083	Preparation of Trichomonas vaginalis 1000000 Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	QMS	Corporate		
814	CO-OPS-SOP-084	Preparation of Trichomonas vaginalis 100000 Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-197	
815	CO-OPS-SOP-201	Preparation of Trichomonas vaginalis 1000 cells/µL working stocks.	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-143	Active
816	CO-LAB-SOP-292	Preparation of Tryptone Soya Broth (TSB) and Tryptone Soya Agar (TSA)	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-006 UK-QC-SOP-232	Active
817	CO-OPS-SOP-128	Preparation of TV 10	000 cells/uL Master Stocks	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-142
818	CO-OPS-SOP-089	Preparation of vaginal swab samples	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-136	Active
819	CO-DPT-WEB-003	Privacy Policy	0	Digital Product Technology	Website Content	QMS	Corporate		Active
820	CO-DPT-WEB-007	Privacy Policy (UTI	Spanish)	0	Digital Product Technology	Website Content	QMS	Corporate	
821	CO-SUP-SOP-001	Procedure for Commercial Storage and Distribution	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-OPS-005	Active
822	CO-CS-SOP-248	Procedure For Customer Service	2	Customer Support	Standard Operating Procedure	QMS	Corporate	QS-OPS-006	Active
823	CO-SUP-SOP-003	Procedure for Inventry Control and BIP	1	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-OPS-008	Active
824	CO-SUP-SOP-007	Procedure for Sales Administration	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-OPS-001	Active
825	CO-QC-SOP-286	Procedure for the Release of io Instruments	3	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-STK-013 UK-LAB-SOP-245	Active
826	CO-QC-SOP-094	Procedure to Control Chemical and Biological Spillages	5	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-LAB-020	Active
827	CO-OPS-URS-020	Process Requirement Specification for CO-OPS-PTL-010	0	Operations	User Requirements Specification	QMS	Corporate		Active
828	CO-OPS-SOP-188	Process Validation	4	Operations	Standard Operating Procedure	QMS	Corporate	QS-V-002	Active
829	CO-QC-PTL-062	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test (Part no. 0225)	0	Quality Control	Protocol	QMS	Corporate		Active
830	CO-QC-PTL-077	Process Validation of CO-QC-QCP-069 and CO-QC-QCP-052. IC DNA Reagent and Raw Material Testing	0	Quality Control	Protocol	QMS	Corporate	MOB-VAL-013	Active
831	CO-DES-T-083	product requirements Specification Template	3	Design	Templates	QMS	Corporate	QS-T-139	Active
832	CO-QA-SOP-283	Product Risk Management Procedure	4	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-RSK-003 UK-QA-SOP-238	Active
833	CO-SUP-JA-026	Production Requests to Production Orders	0	Supply Chain	Job Aid	QMS	Corporate		Active
834	CO-PRD1-JA-044	Production suite air conditioning job aid	0	Production line 1 - Oak House	Job Aid	QMS	Corporate		Active
835	CO-DES-T-058	Project Planning Template	4	Design	Templates	QMS	Corporate	QS-T-062	Active
836	CO-SAM-JA-048	Promotional Materials Checklist	0	Sales and Marketing	Job Aid	QMS	Corporate		Active
837	CO-PRD1-JA-070	Protecting Light Sensitive Reagents with Tin Foil at the Oak House Manufacturing Facility	0	Production line 1 - Oak House	Job Aid	QMS	Corporate		Active
838	CO-SUP-JA-029	Purchase Order Acknowledgements	0	Supply Chain	Job Aid	QMS	Corporate		Active
839	CO-SUP-FRM-195	Purchase Order Request	0	Supply Chain	Forms	QMS	Corporate		Active
840	CO-SUP-T-100	Purchase order terms & conditions	3	Supply Chain	Templates	QMS	Corporate	QS-T-177	Active
841	CO-SUP-SOP-068	Purchasing SOP	14	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-004	Active
842	CO-QC-PTL-109	QC CT/NG 2:2 Input Manufactured Under CO-OPS-SOP-189 Validation Protocol	0	Quality Control	Protocol	QMS	Corporate		Active
843	CO-QC-T-144	QC io Mainternance Log	2	Quality Control	Templates	QMS	Corporate	QS-T-200	Active
844	CO-QC-SOP-154	QC Laboratory Cleaning Procedure	5	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-LAB-073	Active
845	CO-QC-T-120	QC Laboratory Cleaning Record	4	Quality Control	Templates	QMS	Corporate	QS-T-156	Active
846	CO-QC-FRM-049	QC Monthly Laboratory Checklist	0	Quality Control	Forms	QMS	Corporate		Active
847	CO-QC-PTL-073	QC Release of CT/NG Cartridge	1	Quality Control	Protocol	QMS	Corporate	MOB-VAL-022	Active
848	CO-QC-QCP-062	QC release procedure for the Io Reader	8	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-026 UK-QC-QCP-031	Active
849	CO-QC-LBL-031	QC Retention Box Label	0	Quality Control	Label	QMS	Corporate	UK-QC-LBL-001	Active
850	CO-QC-SOP-282	QC Sample Handling and Retention Procedure	1	Quality Control	Standard Operating Procedure	QMS	Corporate	UK-QC-SOP-240	Active
851	CO-QC-REG-034	QC Sample Retention Register	2	Quality Control	Registers	QMS	Corporate	UK-QC-REG-027	Active
852	CO-QC-PTL-064	QC testing and release of UNG raw material	2	Quality Control	Protocol	QMS	Corporate	MOB-VAL-002	Active
853	CO-QC-T-082	qPCR QC Testing Data Analysis	14	Quality Control	Templates	QMS	Corporate	QS-T-137	Active
854	CO-QA-SOP-237	QT9 - Periodic Review and Making Documents Obsolete	0	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Active
855	CO-QA-SOP-244	QT9 Administration	2	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Active
856	CO-QA-JA-014	QT9 Corrective Action Module Job Aid	0	Quality Assurance	Job Aid	QMS	Corporate		Active
857	CO-QA-JA-013	QT9 Feedback Module Job Aid	1	Quality Assurance	Job Aid	QMS	Corporate		Out For Revision
858	CO-QA-JA-018	QT9 Internal Audit Module Job Aid	1	Quality Assurance	Job Aid	QMS	Corporate		Out For Revision
859	CO-QA-JA-015	QT9 Nonconforming Product Job Aid	2	Quality Assurance	Job Aid	QMS	Corporate		Active
860	CO-QA-JA-016	QT9 Preventive Action Module Job Aid	0	Quality Assurance	Job Aid	QMS	Corporate		Active
861	CO-QA-JA-021	QT9 SCAR Module Job Aid	0	Quality Assurance	Job Aid	QMS	Corporate		Active
862	CO-QA-T-146	QT9 SOP Template	1	Quality Assurance	Templates	QMS	Corporate		Active
863	CO-QA-SOP-015	Qualification and Competence of Auditors	3	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-025	Active
864	CO-SUP-SOP-025	Quality Control	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-014	Active
865	CO-QC-COP-001	Quality Control Laboratory Code of Practice	3	Quality Control	Code of Practice	QMS	Corporate		Active
866	CO-QC-FRM-065	Quality Control Out of Specification Result Investigation Record Form	1	Quality Control	Forms	QMS	Corporate		Active
867	CO-QC-SOP-012	Quality Control Out of Specification Results Procedure	1	Quality Control	Standard Operating Procedure	QMS	Corporate		Active
868	CO-QC-POL-018	Quality Control Policy	5	Quality Control	Policy	QMS	Corporate	QS-POL-013 UK-QC-POL-003	Active
869	CO-QC-SOP-171	Quality Control Rounding Procedure	3	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-LAB-065	Active
870	CO-QA-POL-021	Quality Manual	10	Quality Assurance	Policy	QMS	Corporate	QS-POL-001 UK-QA-POL-001	Active
871	CO-QA-POL-019	Quality Policy	6	Quality Assurance	Policy	QMS	Corporate	QS-POL-016 UK-QA-POL-005	Active
872	CO-QA-SOP-028	Quality Records	9	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-010	Active
873	CO-LAB-LBL-009	Quarantine - Failed calibration Label	2	Laboratory	Label	QMS	Corporate	Qs-L-008	Active
874	CO-LAB-LBL-022	Quarantine Stock Item Label	1	Laboratory	Label	QMS	Corporate	QS-L-023	Active
875	CO-PRD1-LBL-049	Quarantined ERP GRN material label-Rev_0	0	Production line 1 - Oak House	Label	QMS	Corporate		Active
876	CO-LAB-LBL-014	Quarantined material label	2	Laboratory	Label	QMS	Corporate	QS-L-013	Out For Revision
877	CO-QC-T-096	Quarterly Reagent Check Record	4	Quality Control	Templates	QMS	Corporate	QS-T-169	Active
878	CO-SUP-SOP-053	Raise & Release Production Order	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-010	Active
879	CO-SUP-SOP-048	Raise PO - non-Stock & Services	3	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-005	Active
880	CO-SUP-SOP-050	Raise PO - Stock Items	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-007	Active
881	CO-SUP-JA-034	Raise Purchase Order – Non-stock & Services	0	Supply Chain	Job Aid	QMS	Corporate		Active
882	CO-SUP-JA-027	Raising Inspection flag on stock material (SAP ByD)	0	Supply Chain	Job Aid	QMS	Corporate		Active
883	CO-OPS-PTL-027	Rapid PCR Rig IQ Protocol	2	Operations	Protocol	QMS	Corporate	QS-VAL-028	Active
884	CO-OPS-PTL-011	Rapid PCR Rig OQ Procedure	2	Operations	Protocol	QMS	Corporate	QS-VAL-029	Active
885	CO-OPS-PTL-028	Rapid PCR Rig PQ Procedure	4	Operations	Protocol	QMS	Corporate	QS-VAL-030	Active
886	CO-LAB-SOP-170	Rapid PCR Rig Work Instructions	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-059	Active
887	CO-OPS-PTL-010	Reader Installation Qualification Protocol	14	Operations	Protocol	QMS	Corporate	QS-VAL-003	Out For Revision
888	CO-OPS-SOP-009	Reader Peltier Refit procedure	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-054	Active
889	CO-QC-T-095	Reagent Aliquot From	6	Quality Control	Templates	QMS	Corporate	QS-T-168	Active
890	CO-LAB-SOP-148	Reagent Aliquotting	11	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-011	Out For Revision
891	CO-SUP-T-178	Reagent component pick list form	4	Supply Chain	Templates	QMS	Corporate		Active
892	CO-LAB-SOP-010	Reagent Deposition and Immobilisation (Pilot Line)	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-058	Active
893	CO-QC-T-136	Reagent Design template	1	Quality Control	Templates	QMS	Corporate	QS-T-192	Active
894	CO-DES-T-140	Reagent Design Transfer Checklist	1	Design	Templates	QMS	Corporate	QS-T-196	Active
895	CO-DES-SOP-372	Reagent Design Transfer process	2	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-013	Active
896	CO-OPS-URS-018	Reagent Handling Processor for Scienion Dispense Equipment	0	Operations	User Requirements Specification	QMS	Corporate		Active
897	CO-PRD1-POL-016	Reagent Production Policy	0	Production line 1 - Oak House	Policy	QMS	Corporate		Active
898	CO-PRD1-FRM-191	Reagent Shipping Worksheet	2	Production line 1 - Oak House	Forms	QMS	Corporate		Active
899	CO-SUP-SOP-049	Receive Non-Stock PO	4	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-006	Active
900	CO-SUP-SOP-051	Receive Stock Purchase Orders	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-008	Active
901	CO-LAB-SOP-180	Reconstitution of Lyophilised Materials	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-084	Active
902	CO-REG-T-157	Regulatory Change Assessment	0	Regulatory	Templates	QMS	Corporate		Active
903	CO-QC-QCP-056	Release procedure for CT/NG cartridge	27	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-052 UK-QC-QCP-038	Active
904	CO-IT-POL-031	Responsible Disclosure Policy	0	Information Technology	Policy	QMS	Corporate		Active
905	CO-DPT-VID-001	Return STI Kit Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	QMS	Corporate		Active
906	CO-QA-SOP-031	Revising and Introducing Documents in QT9	3	Quality Assurance	Standard Operating Procedure	QMS	Corporate		Active
907	CO-QC-T-035	Rework Protocol Template	4	Quality Control	Templates	QMS	Corporate	QS-T-094	Active
908	CO-LAB-SOP-005	Rhychiger Heat Sealer	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-045	Active
909	CO-LAB-FRM-036	Ribonucleotide Solution Mix’ Material binx Part Number 0405	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0405	Active
910	CO-H&S-RA-001	Risk Assessment - binx Health Office and non-laboratory areas	5	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-020	Active
911	CO-H&S-RA-013	Risk Assessment - Fire - Derby Court and Unit 6	6	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-025	Active
912	CO-H&S-RA-004	Risk Assessment - io® reader / assay development tools	5	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-027	Active
913	CO-H&S-RA-003	Risk Assessment - Laboratory Areas (excluding Microbiology and Pilot line)	5	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-023	Active
914	CO-H&S-RA-007	Risk Assessment - Pilot line Laboratory area	5	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-033	Active
915	CO-H&S-RA-006	Risk Assessment - use of UV irradiation in the binx health Laboratories	5	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-030	Active
916	CO-H&S-RA-008	Risk Assessment for binx Health Employees	3	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-040	Active
917	CO-H&S-RA-009	Risk Assessment for use of Chemicals	3	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-041	Active
918	CO-H&S-RA-002	Risk Assessment for use of Microorganisms	6	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-22	Active
919	CO-H&S-RA-010	Risk Assessment for work-related stress	2	Health and Safety	H&S Risk Assessments	Business	Corporate	HS-RA-042	Active
920	CO-IT-POL-032	Risk Management	0	Information Technology	Policy	QMS	Corporate		Active
921	CO-DES-T-062	Risk Management Plan template	3	Design	Templates	QMS	Corporate	QS-T-069	Active
922	CO-QA-POL-020	Risk Management Policy	9	Quality Assurance	Policy	QMS	Corporate	QS-POL-006 UK-QA-POL-002	Active
923	CO-DES-T-064	Risk Management Report template	3	Design	Templates	QMS	Corporate	QS-T-071	Active
924	CO-DES-T-063	Risk/benefit template	3	Design	Templates	QMS	Corporate	QS-T-070	Active
925	CO-QA-SOP-345	Root Cause Analysis	4	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-011 CO-QA-SOP-008	Active
926	CO-LAB-SOP-163	Running Cartridges on io Readers	8	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-042	Active
927	CO-SUP-JA-028	Running Purchasing and Production Exception Reports	0	Supply Chain	Job Aid	QMS	Corporate		Active
928	CO-PRD1-LBL-050	SAP Code ERP GRN Label-Rev_0	0	Production line 1 - Oak House	Label	QMS	Corporate		Active
929	CO-SUP-SOP-066	SAP Manager Approvals App	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-035	Active
930	CO-LAB-LBL-020	SAP Stock Item Label	2	Laboratory	Label	QMS	Corporate	QS-L-021	Active
931	CO-LAB-FRM-067	Sarcosine’ Part no: 0108	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0108	Active
932	CO-LAB-FRM-029	SARS-Related Coronavirus 2 (SARS-CoV-2) Stock Material binx Part Number 0388	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0388	Active
933	CO-PRD1-FRM-263	Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Slip Oak House IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
934	CO-PRD1-FRM-261	Sartorius Minisart™ NML Syringe Filters Sterile (0.45 µm) Male Luer Lock Oak House IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		
935	CO-DPT-JA-010	Self-Collection Validation Summary	0	Digital Product Technology	Job Aid	QMS	Corporate		Active
936	CO-SUP-SOP-280	Setting Expiry Dates for Incoming Materials	8	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-008 UK-SUP-SOP-003	Active
937	CO-LAB-FRM-039	SGS NO Primer Mix’ Material binx Part Number 0410	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0410	Active
938	CO-LAB-FRM-040	SGS RP Primer Mix’ Material binx Part Number 0411	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0411	Active
939	CO-QA-SOP-024	Sharepoint Administration	2	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-014	Active
940	CO-LAB-FRM-035	Sherlock Probe 7’ Material binx Part Number 0397	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0397	Active
941	CO-PRD1-FRM-190	Shipment note	0	Production line 1 - Oak House	Forms	QMS	Corporate		Active
942	CO-SUP-LBL-051	Shipping Contents Label	0	Supply Chain	Label	QMS	Corporate		Active
943	CO-SUP-T-201	Shipping Specification Template	0	Supply Chain	Templates	QMS	Corporate		Active
944	CO-SUP-FRM-269	Shipping Specification: CT/NG io Cartridge	0	Supply Chain	Forms	QMS	Corporate		Active
945	CO-SUP-SOP-363	Shipping Specifications Procedure	0	Supply Chain	Standard Operating Procedure	QMS	Corporate		Active
946	CO-LAB-FRM-052	SODIUM CHLORIDE Part Number 0008	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0008	Active
947	CO-SUP-JA-063	Softbox TempCell F39 (13-48) Dry ice shipper packing instructions	0	Supply Chain	Job Aid	QMS	Corporate		Active
948	CO-SUP-JA-065	Softbox TempCell MAX shipper packing instructions	0	Supply Chain	Job Aid	QMS	Corporate		Active
949	CO-SUP-JA-064	Softbox TempCell PRO shipper packing instructions	0	Supply Chain	Job Aid	QMS	Corporate		Active
950	CO-DES-SOP-004	Software Development Procedure	4	Design	Standard Operating Procedure	QMS	Corporate	QS-DES-010	Active
951	CO-DES-T-125	Software Development Tool Approval	2	Design	Templates	QMS	Corporate	QS-T-162	Active
952	CO-QC-T-023	Solution Preparation Form	3	Quality Control	Templates	QMS	Corporate	QS-T-060	Active
953	CO-LAB-SOP-136	Solution Preparation SOP	6	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-005	Out For Revision
954	CO-LAB-LBL-011	Solutions labels	3	Laboratory	Label	QMS	Corporate	QS-L-010	Active
955	CO-LAB-SOP-290	SOP for running clinical samples in io® instruments	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-034 UK-QC-SOP-234	Active
956	CO-OPS-SOP-196	SOP to record the details of the manufacture of 75x PCR buffer	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-094	Active
957	CO-DES-T-126	Soup Approval	2	Design	Templates	QMS	Corporate	QS-T-163	Active
958	CO-DPT-WEB-009	South Dakota Waiver	Consent	and Release of Information (Spanish)	0	Digital Product Technology	Website Content	QMS	Corporate
959	CO-QA-T-048	Specimen Signature Log	4	Quality Assurance	Templates	QMS	Corporate	QS-T-032	Active
960	CO-OPS-URS-008	Sprint B+ leak tester- User Requirement Specification	0	Operations	User Requirements Specification	QMS	Corporate		Active
961	CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	8	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-006	Out For Revision
962	CO-QA-T-087	Standard / Guidance Review	4	Quality Assurance	Templates	QMS	Corporate	QS-T-147	Active
963	CO-SUP-SOP-073	Standard Cost Roll Up	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-002	Active
964	CO-LAB-SOP-289	Standard Procedures for use in the Development of the CT/NG Assay	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-042 UK-QC-SOP-235	Active
965	CO-LAB-SOP-150	Standard Use of Freezers	9	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-015	Active
966	CO-PRD1-SOP-257	Standard Use of Oak House Freezers	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
967	CO-PRD1-SOP-259	Standard Use of Oak House Fridges	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
968	CO-LAB-SOP-294	Standard Way of Making CT Dilutions	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-043 UK-QC-SOP-019	Active
969	CO-PRD1-FRM-279	Sterivex-GP Pressure Filter Unit IQC Form	0	Production line 1 - Oak House	Forms	QMS	Corporate		Active
970	CO-DPT-ART-003	STI Barcodes - 8 count label	0	Digital Product Technology	Artwork	QMS	Corporate		Active
971	CO-DPT-IFU-027	STI Sample Tube/Swab Preparation Card (English Version)	2	Digital Product Technology	Instructions For Use	QMS	Corporate	RES-ART-0040	Active
972	CO-OPS-SOP-210	Stock Input Generation for Flex Studies	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-168	Active
973	CO-LAB-REG-015	Stock Item Register	10	Laboratory	Registers	QMS	Corporate	QS-REG-011	Active
974	CO-SUP-SOP-279	Stock take procedure	4	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-009 UK-SUP-SOP-004	Active
975	CO-PRD1-LBL-029	Storage temperature labels	0	Production line 1 - Oak House	Label	QMS	Corporate		Active
976	CO-QC-T-138	Summary technical Documentation (for assay)	2	Quality Control	Templates	QMS	Corporate	QS-T-194	Active
977	CO-QA-T-197	Summary Technical Documentation (STED) Template	0	Quality Assurance	Templates	QMS	Corporate		Active
978	CO-QA-SOP-077	Supplier Audit Procedure	10	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-003	Active
979	CO-QA-REG-005	Supplier Concession Register	1	Quality Assurance	Registers	QMS	Corporate	QS-REG-042	Active
980	CO-QA-SOP-011	Supplier Corrective Action Response Procedure	6	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-016	Active
981	CO-SUP-SOP-069	Supplier Evaluation	7	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-005	Out For Revision
982	CO-SUP-FRM-046	Supplier Questionnaire - Calibration/Equipment maintenance	4	Supply Chain	Forms	QMS	Corporate	QS-T-038a	Active
983	CO-SUP-FRM-042	Supplier Questionnaire - Chemical/Reagent/Microbiological	4	Supply Chain	Forms	QMS	Corporate	QS-T-038b	Active
984	CO-SUP-FRM-048	Supplier Questionnaire - Consultant/Services	4	Supply Chain	Forms	QMS	Corporate	QS-T-038d	Active
985	CO-SUP-FRM-047	Supplier Questionnaire - Hardware	4	Supply Chain	Forms	QMS	Corporate	QS-T-038c	Active
986	CO-QA-T-086	Supplier Re-assessment Approval form	4	Quality Assurance	Templates	QMS	Corporate	QS-T-144	Active
987	CO-QA-REG-025	Supplier Risk Assessment Monitoring List	4	Quality Assurance	Registers	QMS	Corporate	QS-REG-055	Active
988	CO-SUP-SOP-070	Supplier Risk Assessment Approval and Monitoring Procedure	5	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-STK-011	
989	CO-SUP-SOP-322	Supply Team Oak House Operations	1	Supply Chain	Standard Operating Procedure	QMS	Corporate		Active
990	CO-SUP-POL-034	Supply Team Policy for Oak House Production Suite Operations	0	Supply Chain	Policy	QMS	Corporate		Out For Revision
991	CO-LAB-FRM-019	Synthetic Uracil containing Amplicon	3	Laboratory	Forms	QMS	Corporate	QS-IQC-0282	Active
992	CO-OPS-SOP-033	T7 Diluent (NZ Source BSA) Solution	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-MFG-066	Active
993	CO-PRD1-FRM-241	T7 exonuclease Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
994	CO-LAB-FRM-026	T7 Gene 6 Exonuclease 1000U/µL	8	Laboratory	Forms	QMS	Corporate	QS-IQC-0225	Active
995	CO-QC-T-105	T7 QC Testing Data Analysis	7	Quality Control	Templates	QMS	Corporate	QS-T-115	Active
996	CO-QC-PTL-061	T7 Raw Material Spreadsheet Validation	0	Quality Control	Protocol	QMS	Corporate	MOB-VAL-015	Active
997	CO-QC-QCP-039	T7 Raw Material Test	12	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-027	Active
998	CO-LAB-FRM-037	T7 RNA Polymerase (HC)’ Materials binx Part Number 0406	1	Laboratory	Forms	QMS	Corporate	QS-IQC-0406	Active
999	CO-PRD1-FRM-226	Taq-B Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
1000	CO-QC-PTL-065	Taq-B raw material and CT/NG Taq UNG Reagent Validation	2	Quality Control	Protocol	QMS	Corporate	MOB-VAL-004	Active
1001	CO-DES-PTL-003	Temperature controlled equipment	3	Design	Protocol	QMS	Corporate	QS-VAL-009	Active
1002	CO-PRD1-LBL-030	Temperature only label	0	Production line 1 - Oak House	Label	QMS	Corporate		Active
1003	CO-QC-T-009	Template for IQC	6	Quality Control	Templates	QMS	Corporate	QS-T-022	Active
1004	CO-PRD1-T-179	Template for IQC for Oak House	1	Production line 1 - Oak House	Templates	QMS	Corporate		Active
1005	CO-LAB-T-148	Template for Laboratory Code of Practice	1	Laboratory	Templates	QMS	Corporate		Active
1006	CO-DPT-WEB-004	Terms of Service	0	Digital Product Technology	Website Content	QMS	Corporate		Active
1007	CO-DPT-WEB-010	Terms of Service (Spanish)	0	Digital Product Technology	Website Content	QMS	Corporate		Active
1008	CO-OPS-SOP-034	Test Method Validation	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-V-005	Active
1009	CO-QC-PTL-069	Testing and Release of Raw Materials & Formulated Reagents	8	Quality Control	Protocol	QMS	Corporate	MOB-VAL-001	Active
1010	CO-PRD1-SOP-310	The use of Calibrated Clocks/Timers	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1011	CO-PRD1-SOP-318	The use of the calibrated temperature probe	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1012	CO-OPS-SOP-008	Thermal Test Rig Set Up and Calibration	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-052	Active
1013	CO-LAB-SOP-014	Thermo Orion Star pH meter	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-013	Active
1014	CO-IT-POL-033	Third Party Management	0	Information Technology	Policy	QMS	Corporate		Active
1015	CO-SUP-JA-057	Third Party Sale and Purchase Orders Process	0	Supply Chain	Job Aid	QMS	Corporate		Active
1016	CO-OPS-SOP-172	Tool Changes of the Rhychiger Heat Sealer	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-066	Active
1017	CO-OPS-URS-007	TQC leak tester- User Requirement Specification	0	Operations	User Requirements Specification	QMS	Corporate		Active
1018	CO-QA-T-044	Training Competence Assessment Form	4	Quality Assurance	Templates	QMS	Corporate	QS-T-028	Active
1019	CO-QA-T-143	Training Plan Quarterly Sign Off Form	1	Quality Assurance	Templates	QMS	Corporate	QS-T-199	Active
1020	CO-HR-POL-007	Training Policy	3	Human Resources	Policy	QMS	Corporate	QS-POL-003	Active
1021	CO-QA-SOP-043	Training Procedure	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-TRA-001	Out For Revision
1022	CO-HR-REG-030	Training Register	6	Human Resources	Registers	QMS	Corporate	QS-REG-201	Active
1023	CO-PRD1-SOP-268	Transfer of reagent QC samples	2	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1024	CO-SUP-JA-038	Transfer Order	0	Supply Chain	Job Aid	QMS	Corporate		Active
1025	CO-SUP-SOP-047	Transfer Orders	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-004	Active
1026	CO-PRD1-FRM-235	Trehalose dihydrate Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
1027	CO-LAB-FRM-004	TRIS (TRIZMA) Base	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0012	Active
1028	CO-LAB-FRM-006	Triton X-100	4	Laboratory	Forms	QMS	Corporate	QS-IQC-0109	Active
1029	CO-LAB-FRM-013	Triton x305	6	Laboratory	Forms	QMS	Corporate	QS-IQC-0177	Active
1030	CO-PRD1-FRM-236	Triton X305 Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
1031	CO-PRD1-FRM-237	Trizma base Oak House production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
1032	CO-PRD1-FRM-238	Trizma hydrochloride Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
1033	CO-LAB-FRM-192	TV Synthetic Target (P/N 0418)	0	Laboratory	Forms	QMS	Corporate	QS-IQC-0418	Active
1034	CO-LAB-FRM-025	Tween-20 binx Part Number 0002	2	Laboratory	Forms	QMS	Corporate	QS-IQC-0002	Active
1035	CO-SUP-SOP-074	UK Stock Procurement & Movements (Supply Chain)	2	Supply Chain	Standard Operating Procedure	QMS	Corporate	QS-ERP-003	Active
1036	CO-FIN-T-134	UK Trade Credit Application	2	Finance	Templates	QMS	Corporate	QS-T-190	Active
1037	CO-OPS-LBL-028	UN3316 cartridge label - use Avery J8173 labels to print	1	Operations	Label	QMS	Corporate	QS-L-029	Active
1038	CO-QC-QCP-070	UNG 50 U/uL(Part no. 0240)	7	Quality Control	Quality Control Protocol	QMS	Corporate	QS-QCP-043 UK-QC-QCP-023	Active
1039	CO-PRD1-FRM-228	UNG Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
1040	CO-DPT-VID-005	Urine Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	QMS	Corporate		Active
1041	CO-DPT-ART-011	Urine STI Sample Collection Sticker	0	Digital Product Technology	Artwork	QMS	Corporate		Active
1042	CO-PRD1-URS-022	URS for a Hydridisation Oven (Benchmark Roto-Therm Plus H2024-E)	0	Production line 1 - Oak House	User Requirements Specification	QMS	Corporate		Active
1043	CO-LAB-URS-029	URS for Female Urine Clinical Study Database	0	Laboratory	User Requirements Specification	QMS	Corporate		Active
1044	CO-PRD1-URS-025	URS for temp-controlled equipment for Oak House	0	Production line 1 - Oak House	User Requirements Specification	QMS	Corporate		Active
1045	CO-OPS-URS-002	URS for Temperature Monitoring System	1	Operations	User Requirements Specification	QMS	Corporate		Active
1046	CO-FIN-T-167	US Trade Credit Application	0	Finance	Templates	Business	Corporate		Active
1047	CO-PRD1-SOP-254	Use & Cleaning of the Monmouth Scientific Model Guardian 1800 Production Enclosure in Oak House	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1048	CO-LAB-SOP-079	Use and Cleaning of Class II Microbiology Safety Cabinet	7	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-017	Active
1049	CO-SAM-JA-049	Use of Acronyms in Marketing Materials	0	Sales and Marketing	Job Aid	QMS	Corporate		Active
1050	CO-LAB-SOP-080	Use of Agilent Bioanalyzer DNA 1000 kits	6	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-025	Active
1051	CO-PRD1-SOP-252	Use of Benchmark Roto-Therm Plus Hybridisation oven	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1052	CO-QC-JA-011	Use of CO-QC-T-118: Detection Reagent Analysis Spreadsheet	1	Quality Control	Job Aid	QMS	Corporate	UK-QC-JA-007	Active
1053	CO-QC-JA-004	Use of CO-QC-T-155: CTNG QC Cartridge Analysis Module	0	Quality Control	Job Aid	QMS	Corporate		Active
1054	CO-SUP-JA-055	Use of Elpro data loggers	0	Supply Chain	Job Aid	QMS	Corporate		Active
1055	CO-LAB-SOP-169	Use of Fermant Pouch Sealer	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-057	Active
1056	CO-PRD1-SOP-308	Use of IKA Digital Roller Mixer	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1057	CO-PRD1-SOP-260	Use of Logmore dataloggers	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1058	CO-PRD1-SOP-305	Use of ME2002T/00 and ML104T/00 balances in the Oak House Production Facility	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1059	CO-PRD1-SOP-313	Use of Membrane Filters in the binx Reagent Manufacturing Facility	1	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1060	CO-PRD1-SOP-258	Use of Oak House N2400-3010 Magnetic Stirrer	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1061	CO-LAB-SOP-159	Use of Rotor-Gene Q	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-033	Active
1062	CO-SUP-JA-056	Use of Sensitech data loggers	0	Supply Chain	Job Aid	QMS	Corporate		Active
1063	CO-QA-SOP-026	Use of Sharepoint	6	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-DOC-007	Active
1064	CO-QC-SOP-021	Use of Stuart SRT6D Roller Mixer	4	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-LAB-075	Active
1065	CO-LAB-SOP-138	Use of Temperature and Humidity Loggers	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-032	Active
1066	CO-LAB-SOP-015	Use of the ALC PK121 centrifuges (refrigerated and non-refrigerated)	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-022	Active
1067	CO-LAB-SOP-004	Use of the Bolt Mini Gel Tank for protein Electrophoresis	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-039	Active
1068	CO-LAB-SOP-102	Use of the Grant XB2 Ultrasonic Bath	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-023	Active
1069	CO-LAB-SOP-020	Use of the Hulme Martin Pmpulse heat Sealer	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-074	Out For Revision
1070	CO-LAB-SOP-017	Use of the Jenway Spectrophotometer	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-064	Active
1071	CO-LAB-SOP-019	Use of the LMS Programmable Incubator	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-070	Out For Revision
1072	CO-QA-JA-006	Use of the Management Review Module in QT9	1	Quality Assurance	Job Aid	QMS	Corporate		Active
1073	CO-LAB-SOP-183	Use of the Microcentrifuge 24	1	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-087	Active
1074	CO-LAB-SOP-160	Use of the Miele Laboratory Glassware Washer G7804	2	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-034	Active
1075	CO-LAB-SOP-158	Use of the NanoDrop ND2000 Spectrophotometer	5	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-026	Active
1076	CO-PRD1-SOP-271	Use of the Pacplus Impulse Heat Sealer	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1077	CO-LAB-SOP-016	Use of the Peqlab thermal cyclers	4	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-027	Active
1078	CO-LAB-SOP-129	Use of the Priorclave Autoclave	8	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-024	Active
1079	CO-LAB-SOP-082	Use of the Rotary Vane Anemometer	1	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-095	Out For Revision
1080	CO-PRD1-SOP-311	Use of the Rotary Vane Anemometer in Oak House	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1081	CO-QC-SOP-185	Use of the SB3 Rotator	2	Quality Control	Standard Operating Procedure	QMS	Corporate	QS-LAB-090	Active
1082	CO-LAB-SOP-181	Use of the Thermomixer HC block	1	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-085	Active
1083	CO-PRD1-SOP-309	Use of the Uninterruptible Power Supply	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1084	CO-OPS-SOP-186	Use of the VPUMP Vacuum pump	2	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-091	Active
1085	CO-LAB-SOP-153	Use of UV Cabinets	7	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-007	Active
1086	CO-LAB-SOP-296	Use of ZeptoMetrix Controls in  SARS-CoV-2 Studies	1	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-EXP-050 UK-QC-SOP-017	Active
1087	CO-QA-T-158	User Requirement Specification (URS) template	0	Quality Assurance	Templates	QMS	Corporate		Active
1088	CO-OPS-URS-019	User Requirement Specification for a Balance	1	Operations	User Requirements Specification	QMS	Corporate		Active
1089	CO-OPS-URS-015	User requirement specification for a cooled incubator	0	Operations	User Requirements Specification	QMS	Corporate		Active
1090	CO-OPS-URS-014	User requirement specification for a filter integrity tester	0	Operations	User Requirements Specification	QMS	Corporate		Active
1091	CO-OPS-URS-012	User Requirement Specification for a Production Enclosure	0	Operations	User Requirements Specification	QMS	Corporate		Active
1092	CO-PRD1-URS-026	User Requirement Specification for a Wireless Temperature and Humidity Monitoring System for Oak House Production and Storage Facility	0	Production line 1 - Oak House	User Requirements Specification	QMS	Corporate		Active
1093	CO-OPS-URS-011	User Requirement Specification for back up power supply	0	Operations	User Requirements Specification	QMS	Corporate		Active
1094	CO-SUP-URS-017	User Requirement Specification for ByD for binx Reagent Manufacturing Facility	0	Supply Chain	User Requirements Specification	QMS	Corporate		Active
1095	CO-OPS-URS-013	User requirement specification for class 2 microbiological safety cabinet	0	Operations	User Requirements Specification	QMS	Corporate		Active
1096	CO-OPS-URS-009	User Requirement Specification for pH/mV/°C Meter	1	Operations	User Requirements Specification	QMS	Corporate		Active
1097	CO-OPS-URS-010	User Requirement Specification for temperature-controlled equipment	0	Operations	User Requirements Specification	QMS	Corporate		Active
1098	CO-PRD1-URS-021	User Requirement Specification for the binx Cartridge Reagent Manufacturing Lab UK	1	Production line 1 - Oak House	User Requirements Specification	QMS	Corporate	QS-URS-037	Active
1099	CO-OPS-URS-006	User Requirement Specification for the vT off-line flow and leak test equipment	0	Operations	User Requirements Specification	QMS	Corporate		Active
1100	CO-PRD1-URS-027	User Requirements Specification for a Monmouth Scientific Model Guardian 1800 production enclosure	0	Production line 1 - Oak House	User Requirements Specification	QMS	Corporate		Active
1101	CO-DPT-FEA-002	UTI Screening Box	0	Digital Product Technology	Digital Feature	QMS	Corporate	US-DPT-FEA-001	Active
1102	CO-DPT-ART-008	Vaginal STI Sample Collection Sticker	0	Digital Product Technology	Artwork	QMS	Corporate		Active
1103	CO-DPT-VID-006	Vaginal Swab Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	QMS	Corporate		Active
1104	CO-OPS-PTL-108	VAL2023-06 NetSuite Test Specification_QT9	1	Operations	Protocol	QMS	Corporate		Active
1105	CO-OPS-PTL-015	Validation 2-8 Refrigerator QC Lab	1	Operations	Protocol	QMS	Corporate	QS-VAL-005	Active
1106	CO-OPS-PTL-014	Validation -80 Chest Freezer Micro lab	2	Operations	Protocol	QMS	Corporate	QS-VAL-004	Active
1107	CO-OPS-PTL-013	Validation -80 Freezer QC Lab	1	Operations	Protocol	QMS	Corporate	QS-VAL-002	Active
1108	CO-DES-T-065	Validation Master Plan (or Plan) template	5	Design	Templates	QMS	Corporate	QS-T-073	Active
1109	CO-DES-T-066	Validation Matrix template	2	Design	Templates	QMS	Corporate	QS-T-074	Active
1110	CO-DES-PTL-002	Validation of Abacus Guardian	2	Design	Protocol	QMS	Corporate	QS-VAL-047	Active
1111	CO-OPS-PTL-019	Validation of Autolab Type III	2	Operations	Protocol	QMS	Corporate	QS-VAL-013	Active
1112	CO-OPS-SOP-032	Validation of Automated Equipment and Quality System Software	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-V-004	Active
1113	CO-PRD1-PTL-101	Validation of Oak House CT/NG reagent process	1	Production line 1 - Oak House	Protocol	QMS	Corporate		Active
1114	CO-LAB-SOP-003	Validation of Temperature Controlled Equipment	3	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-038	Active
1115	CO-OPS-PTL-030	Validation Protocol – Heated Detection Rig PQ	7	Operations	Protocol	QMS	Corporate	QS-VAL-036	Active
1116	CO-OPS-PTL-018	Validation Protocol – UV/Vis Nanodrop Spectrophotometer	2	Operations	Protocol	QMS	Corporate	QS-VAL-011	Active
1117	CO-OPS-PTL-022	Validation Protocol - V&V Laboratory Facilities	1	Operations	Protocol	QMS	Corporate	QS-VAL-021	Active
1118	CO-OPS-PTL-021	Validation Protocol for Rotorgene	4	Operations	Protocol	QMS	Corporate	QS-VAL-017	Active
1119	CO-OPS-PTL-020	Validation Protocol Temperature controlled storage/incubation	3	Operations	Protocol	QMS	Corporate	QS-VAL-014	Out For Revision
1120	CO-DES-T-025	Validation Protocol template	8	Design	Templates	QMS	Corporate	QS-T-076	Active
1121	CO-QC-PTL-016	Validation Protocol	-20 freezer/QC lab asset 0330	1	Quality Control	Protocol	QMS	Corporate	QS-VAL-006
1122	CO-OPS-PTL-036	Validation Protocol: 21011-MET012 Thermal - PCR Cycle Results Template Master	2	Operations	Protocol	QMS	Corporate	QS-VAL-050	Active
1123	CO-OPS-PTL-017	Validation Protocol: Thermal cycler IQ/OQ/PQ	4	Operations	Protocol	QMS	Corporate	QS-VAL-010	Active
1124	CO-DES-T-114	Validation Summary Report	2	Design	Templates	QMS	Corporate	QS-T-132	Active
1125	CO-LAB-SOP-137	Variable Temperature Apparatus Monitoring	7	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-018	Out For Revision
1126	CO-PRD1-SOP-256	Velp Scientific WIZARD IR Infrared Vortex Mixer SOP	0	Production line 1 - Oak House	Standard Operating Procedure	QMS	Corporate		Active
1127	CO-CA-POL-009	Verification and Validation Policy	3	Clinical Affairs	Policy	QMS	Corporate	QS-POL-007	Active
1128	CO-OPS-SOP-192	Verification Testing Process SOP	3	Operations	Standard Operating Procedure	QMS	Corporate	QS-V-001	Active
1129	CO-LAB-PTL-186	Verification Testing Protocol for Female Urine Database	0	Laboratory	Protocol	QMS	Corporate		Active
1130	CO-DES-T-060	Verification Testing Protocol template	8	Design	Templates	QMS	Corporate	QS-T-066	Active
1131	CO-DES-T-061	Verification Testing Report template	7	Design	Templates	QMS	Corporate	QS-T-067	Active
1132	CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	7	Quality Assurance	Standard Operating Procedure	QMS	Corporate	QS-MGT-007; CO-QA-SOP-006	Out For Revision
1133	CO-QA-T-106	Vigilance Form	3	Quality Assurance	Templates	QMS	Corporate	QS-T-116	Active
1134	CO-QA-REG-022	Vigilance Register	2	Quality Assurance	Registers	QMS	Corporate	QS-REG-045	Active
1135	CO-OPS-PTL-049	vT flow and leak tester- FAT protocol	0	Operations	Protocol	QMS	Corporate		Active
1136	CO-LAB-FRM-051	WATER FOR MOLECULAR BIOLOGY Part Number 0005	5	Laboratory	Forms	QMS	Corporate	QS-IQC-0005	Active
1137	CO-LAB-FRM-206	Water/Eultion Buffer  aliquot form	0	Laboratory	Forms	QMS	Corporate		Active
1138	CO-OPS-POL-011	WEEE Policy	2	Operations	Policy	QMS	Corporate	QS-POL-009	Out For Revision
1139	CO-OPS-SOP-165	Windows Software Update	1	Operations	Standard Operating Procedure	QMS	Corporate	QS-LAB-047	Active
1140	CO-LAB-SOP-097	Wireless Temperature and Humidity Monitoring	15	Laboratory	Standard Operating Procedure	QMS	Corporate	QS-LAB-006	Active
1141	CO-PRD1-FRM-243	y-Aminobutyric acid (GABA) Oak House Production IQC	1	Production line 1 - Oak House	Forms	QMS	Corporate		Active
\.


--
-- Data for Name: current_state_documents2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.current_state_documents2 (id, doc_id, documentcode, rev) FROM stdin;
1	926	CO-OPS-PTL-050	0
2	676	CO-LAB-FRM-086	6
3	687	CO-LAB-FRM-097	3
4	686	CO-LAB-FRM-096	3
5	648	CO-LAB-FRM-059	5
6	667	CO-LAB-FRM-077	5
7	698	CO-LAB-FRM-108	4
8	696	CO-LAB-FRM-106	8
9	690	CO-LAB-FRM-100	8
10	691	CO-LAB-FRM-101	9
11	694	CO-LAB-FRM-104	8
12	692	CO-LAB-FRM-102	8
13	670	CO-LAB-FRM-080	3
14	671	CO-LAB-FRM-081	3
15	651	CO-LAB-FRM-062	5
16	727	CO-LAB-FRM-137	2
17	697	CO-LAB-FRM-107	4
18	652	CO-LAB-FRM-063	5
19	689	CO-LAB-FRM-099	2
20	662	CO-LAB-FRM-072	4
21	728	CO-LAB-FRM-138	1
22	644	CO-LAB-FRM-055	5
23	709	CO-LAB-FRM-119	2
24	729	CO-LAB-FRM-139	1
25	642	CO-LAB-FRM-053	5
26	717	CO-LAB-FRM-127	2
27	718	CO-LAB-FRM-128	2
28	719	CO-LAB-FRM-129	2
29	669	CO-LAB-FRM-079	4
30	665	CO-LAB-FRM-075	3
31	1347	CO-PRD1-FRM-231	1
32	253	CO-LAB-FRM-007	4
33	339	CO-OPS-SOP-109	9
34	1012	CO-DPT-IFU-013	2
35	251	CO-LAB-FRM-005	4
36	715	CO-LAB-FRM-125	1
37	663	CO-LAB-FRM-073	4
38	658	CO-LAB-FRM-068	4
39	1431	CO-DPT-BOM-002	0
40	1430	CO-DPT-BOM-001	0
41	1432	CO-DPT-BOM-003	0
42	1434	CO-DPT-BOM-005	0
43	1435	CO-DPT-BOM-006	BAO) Kit BOM
44	1436	CO-DPT-BOM-007	0
45	1437	CO-DPT-BOM-008	0
46	1433	CO-DPT-BOM-004	Unisex) Kit BOM
47	1438	CO-DPT-BOM-009	0
48	1439	CO-DPT-BOM-010	0
49	1440	CO-DPT-BOM-011	0
50	1441	CO-DPT-BOM-012	Unisex) Kit BOM
51	1442	CO-DPT-BOM-013	0
52	1443	CO-DPT-BOM-014	0
53	1444	CO-DPT-BOM-015	0
54	1445	CO-DPT-BOM-016	0
55	1446	CO-DPT-BOM-017	AG) Kit BOM
56	1447	CO-DPT-BOM-018	AG) Kit BOM
57	1448	CO-DPT-BOM-019	Unisex
58	1449	CO-DPT-BOM-020	AG) Kit BOM
59	1450	CO-DPT-BOM-021	AG) Kit BOM
60	1451	CO-DPT-BOM-022	AG) Kit BOM
61	1452	CO-DPT-BOM-023	AG) Kit BOM
62	1453	CO-DPT-BOM-024	AG) Kit BOM
63	1454	CO-DPT-BOM-025	AG) Kit BOM
64	1455	CO-DPT-BOM-026	0
65	1456	CO-DPT-BOM-027	0
66	1457	CO-DPT-BOM-028	Non-fasting) Kit BOM
67	1458	CO-DPT-BOM-029	Non-fasting) Kit BOM
68	282	CO-OPS-SOP-110	3
69	256	CO-LAB-FRM-010	4
70	1459	CO-DPT-BOM-030	0
71	716	CO-LAB-FRM-126	2
72	346	CO-OPS-SOP-111	4
73	345	CO-OPS-SOP-112	3
74	327	CO-LAB-FRM-023	2
75	284	CO-OPS-SOP-113	3
76	283	CO-OPS-SOP-114	3
77	535	CO-QA-JA-001	1
78	1178	CO-QC-JA-019	0
79	1180	CO-IT-POL-022	0
80	472	CO-QA-SOP-030	3
81	1528	CO-H&S-PRO-004	4
82	213	CO-SUP-SOP-062	2
83	357	CO-QA-T-045	4
84	1229	CO-DPT-ART-004	0
85	264	CO-LAB-SOP-002	4
86	978	CO-PRD1-JA-008	1
87	1554	CO-SUP-JA-062	0
88	1553	CO-SUP-JA-061	0
89	1360	CO-PRD1-FRM-244	2
90	1240	CO-DPT-ART-010	0
91	1046	CO-DPT-VID-007	0
92	539	CO-QA-SOP-096	5
93	148	CO-QA-SOP-012	8
94	1070	CO-QA-SOP-274	0
95	882	CO-LAB-LBL-003	2
96	844	CO-QA-REG-024	1
97	421	CO-QA-T-109	3
98	1121	CO-LAB-SOP-288	4
99	899	CO-LAB-LBL-019	2
100	1181	CO-IT-POL-023	0
101	1546	CO-LAB-FRM-278	0
102	828	CO-LAB-REG-011	3
103	1002	CO-DPT-IFU-003	4
104	1000	CO-DPT-IFU-001	4
105	1003	CO-DPT-IFU-004	4
106	1001	CO-DPT-IFU-002	5
107	1049	CO-DPT-IFU-042	0
108	1047	CO-DPT-IFU-040	2
109	1050	CO-DPT-IFU-043	0
110	1048	CO-DPT-IFU-041	0
111	1010	CO-DPT-IFU-011	5
112	1008	CO-DPT-IFU-009	5
113	1011	CO-DPT-IFU-012	5
114	1009	CO-DPT-IFU-010	5
115	1015	CO-DPT-IFU-016	4
116	1013	CO-DPT-IFU-014	4
117	1016	CO-DPT-IFU-017	4
118	1014	CO-DPT-IFU-015	5
119	1019	CO-DPT-IFU-020	4
120	1017	CO-DPT-IFU-018	4
121	1020	CO-DPT-IFU-021	4
122	1018	CO-DPT-IFU-019	4
123	1006	CO-DPT-IFU-007	4
124	1004	CO-DPT-IFU-005	4
125	1007	CO-DPT-IFU-008	4
126	1005	CO-DPT-IFU-006	5
127	602	CO-LAB-SOP-167	5
128	1065	CO-QA-FRM-194	0
129	1064	CO-QA-FRM-193	0
130	1075	CO-QA-REG-033	0
131	957	CO-LAB-T-159	0
132	318	CO-QC-T-033	5
133	1319	CO-SUP-JA-031	set up and edit
134	501	CO-QA-REG-007	2
135	329	CO-LAB-SOP-013	6
136	313	CO-QC-T-028	3
137	463	CO-DES-PTL-006	3
138	599	CO-LAB-SOP-164	3
139	1331	CO-DPT-ART-012	0
140	839	CO-LAB-REG-020	1
141	850	CO-LAB-URS-001	0
142	274	CO-LAB-SOP-012	2
143	1030	CO-DPT-IFU-032	4
144	1029	CO-DPT-IFU-031	4
145	1031	CO-DPT-IFU-033	5
146	1033	CO-DPT-IFU-036	4
147	1032	CO-DPT-IFU-035	5
148	1034	CO-DPT-IFU-037	4
149	1417	CO-SUP-T-184	1
150	1044	CO-DPT-IFU-039	2
151	1043	CO-DPT-IFU-038	2
152	1063	CO-DPT-IFU-044	0
153	867	CO-OPS-REG-029	7
154	951	CO-SUP-FRM-177	0
155	1537	CO-CS-FRM-275	0
156	354	CO-QA-T-042	5
157	350	CO-QA-T-038	7
158	1028	CO-DPT-IFU-029	7
159	1027	CO-DPT-IFU-028	10
160	1418	CO-SUP-T-185	1
161	288	CO-SUP-T-003	8
162	352	CO-DES-T-040	7
163	353	CO-DES-T-041	7
164	419	CO-QC-T-107	3
165	1499	CO-H&S-T-203	5
166	816	CO-OPS-PTL-037	1
167	817	CO-OPS-PTL-038	3
168	1021	CO-DPT-IFU-022	2
169	1022	CO-DPT-IFU-023	2
170	1024	CO-DPT-IFU-025	2
171	1023	CO-DPT-IFU-024	2
172	214	CO-SUP-SOP-063	2
173	1348	CO-PRD1-FRM-232	1
174	1182	CO-IT-POL-024	0
175	656	CO-LAB-FRM-066	5
176	1209	CO-PRD1-FRM-204	0
177	465	CO-DES-PTL-008	3
178	435	CO-QA-T-123	3
179	451	CO-OPS-T-139	1
180	1104	CO-SUP-SOP-281	7
181	1195	CO-OPS-JA-020	0
182	901	CO-LAB-LBL-021	1
183	425	CO-SUP-T-113	3
184	15	CO-DES-SOP-243	6
185	459	CO-QA-T-145	1
186	987	CO-PRD1-FRM-183	1
187	988	CO-PRD1-FRM-184	1
188	989	CO-PRD1-FRM-185	1
189	990	CO-PRD1-FRM-186	1
190	992	CO-PRD1-FRM-188	1
191	991	CO-PRD1-FRM-187	1
192	993	CO-PRD1-FRM-189	1
193	1052	CO-PRD1-T-163	1
194	293	CO-QA-T-008	12
195	562	CO-QA-SOP-139	15
196	493	CO-QA-REG-001	9
197	156	CO-SUP-SOP-038	2
198	186	CO-SUP-SOP-056	1
199	1526	CO-H&S-PRO-002	8
200	1337	CO-LAB-JA-043	0
201	906	CO-LAB-LBL-026	2
202	852	CO-QC-COP-002	2
203	968	CO-LAB-FRM-180	1
204	614	CO-LAB-SOP-179	3
205	974	CO-PRD1-SOP-261	3
206	549	CO-CA-T-147	2
207	1183	CO-IT-POL-025	0
208	891	CO-SD-FRM-171	0
209	1496	CO-SUP-POL-035	0
210	505	CO-CA-SOP-081	2
211	216	CO-SUP-SOP-065	2
212	184	CO-SUP-SOP-054	2
213	155	CO-SUP-SOP-037	2
214	767	CO-OPS-SOP-202	2
215	534	CO-CA-FRM-041	2
216	895	CO-LAB-LBL-015	2
217	834	CO-LAB-REG-016	2
218	208	CO-SUP-SOP-057	2
219	1312	CO-SUP-JA-024	0
220	773	CO-OPS-SOP-208	1
221	348	CO-OPS-SOP-116	2
222	591	CO-LAB-SOP-156	9
223	245	CO-SAM-SOP-009	5
224	363	CO-QC-T-051	6
225	866	CO-IT-REG-028	3
226	381	CO-SAM-T-069	3
227	433	CO-QC-T-121	2
228	1535	CO-H&S-P-004	1
229	74	CO-QA-SOP-007	Removal
230	517	CO-QA-SOP-093	7
231	1505	CO-H&S-COSHH-006	6
232	1511	CO-H&S-COSHH-013	4
233	1506	CO-H&S-COSHH-007	5
234	1507	CO-H&S-COSHH-008	5
235	1503	CO-H&S-COSHH-004	6
236	1509	CO-H&S-COSHH-010	6
237	1512	CO-H&S-COSHH-014	1
238	1504	CO-H&S-COSHH-005	6
239	1502	CO-H&S-COSHH-003	6
240	1500	CO-H&S-COSHH-001	6
241	1508	CO-H&S-COSHH-009	4
242	1510	CO-H&S-COSHH-012	5
243	1501	CO-H&S-COSHH-002	6
244	1232	CO-DPT-ART-007	0
245	1056	CO-DPT-WEB-001	0
246	1088	CO-DPT-WEB-006	0
247	1230	CO-DPT-ART-005	1
248	1231	CO-DPT-ART-006	0
249	1523	CO-H&S-RA-011	6
250	215	CO-SUP-SOP-064	2
251	164	CO-SUP-SOP-046	2
252	1313	CO-SUP-JA-025	0
253	484	CO-DES-SOP-042	4
254	210	CO-SUP-SOP-059	2
255	40	CO-DES-SOP-371	2
256	1184	CO-IT-POL-026	0
257	1362	CO-PRD1-FRM-246	1
258	1365	CO-PRD1-FRM-249	1
259	1256	CO-PRD1-LBL-041	2
260	1305	CO-SUP-FRM-214	4
261	1249	CO-PRD1-LBL-034	2
262	1257	CO-PRD1-LBL-042	2
263	1306	CO-SUP-FRM-215	2
264	1250	CO-PRD1-LBL-035	1
265	1261	CO-PRD1-LBL-046	2
266	1310	CO-SUP-FRM-219	2
267	1254	CO-PRD1-LBL-039	1
268	1139	CO-QC-QCP-055	1
269	1366	CO-PRD1-FRM-250	1
270	664	CO-LAB-FRM-074	6
271	262	CO-LAB-FRM-016	5
272	628	CO-OPS-SOP-189	14
273	1087	CO-QC-PTL-074	1
274	1143	CO-QC-QCP-059	2
275	1560	CO-SUP-JA-068	0
276	1559	CO-SUP-JA-067	0
277	1144	CO-QC-QCP-060	2
278	1152	CO-QC-QCP-068	11
279	1149	CO-QC-QCP-065	11
280	695	CO-LAB-FRM-105	9
281	1151	CO-QC-QCP-067	9
282	1122	CO-QC-QCP-052	7
283	1153	CO-QC-QCP-069	10
284	1148	CO-QC-QCP-064	11
285	693	CO-LAB-FRM-103	8
286	1150	CO-QC-QCP-066	7
287	1147	CO-QC-QCP-063	11
288	545	CO-OPS-SOP-104	7
289	322	CO-LAB-FRM-018	6
290	414	CO-QC-T-102	11
291	1078	CO-QC-PTL-066	2
292	1141	CO-QC-QCP-057	6
293	1080	CO-QC-PTL-068	3
294	1079	CO-QC-PTL-067	2
295	915	CO-QC-T-155	0
296	285	CO-OPS-SOP-120	3
297	566	CO-OPS-SOP-142	4
298	344	CO-OPS-SOP-121	2
299	1561	CO-CS-JA-069	0
300	441	CO-DES-T-129	1
301	38	CO-SUP-SOP-013	2
302	211	CO-SUP-SOP-060	2
303	159	CO-SUP-SOP-041	2
304	443	CO-CS-T-131	1
305	163	CO-SUP-SOP-045	2
306	255	CO-LAB-FRM-009	4
307	1471	CO-QA-T-194	0
308	1398	CO-SUP-JA-047	0
309	1245	CO-SUP-SOP-323	0
310	14	CO-DES-SOP-029	10
311	289	CO-DES-T-004	2
312	483	CO-DES-SOP-041	6
313	436	CO-DES-T-124	2
314	383	CO-QC-T-071	5
315	343	CO-OPS-SOP-122	9
316	305	CO-OPS-T-020	2
317	541	CO-QA-SOP-099	5
318	411	CO-DES-T-099	2
319	1069	CO-QA-T-166	0
320	1428	CO-DPT-T-187	0
321	1099	CO-DPT-T-168	0
322	520	CO-LAB-FRM-027	3
323	316	CO-QC-T-031	3
324	1361	CO-PRD1-FRM-245	1
325	361	CO-QA-T-049	5
326	456	CO-QA-T-142	1
327	69	CO-QA-SOP-005	5
328	65	CO-QA-SOP-140	19
329	66	CO-QA-SOP-098	7
330	422	CO-QA-T-110	3
331	455	CO-QA-T-141	2
332	869	CO-CA-REG-031	1
333	1085	CO-QC-PTL-072	2
334	1127	CO-QC-SOP-293	2
335	1040	CO-DPT-VID-004	0
336	1263	CO-SUP-JA-023	0
337	342	CO-OPS-SOP-123	8
338	1358	CO-PRD1-FRM-242	2
339	1145	CO-QC-QCP-061	7
340	596	CO-LAB-SOP-161	2
341	324	CO-LAB-FRM-020	4
342	904	CO-LAB-LBL-024	4
343	1565	CO-QA-REG-041	0
344	477	CO-OPS-SOP-035	3
345	609	CO-OPS-SOP-174	2
346	160	CO-SUP-SOP-042	2
347	977	CO-PRD1-SOP-263	0
348	837	CO-LAB-REG-018	2
349	388	CO-QC-T-076	3
350	1129	CO-LAB-SOP-295	6
351	544	CO-LAB-SOP-103	12
352	1155	CO-QC-QCP-071	8
353	811	CO-OPS-PTL-031	3
354	273	CO-LAB-SOP-011	2
355	22	CO-SUP-SOP-006	2
356	442	CO-OPS-T-130	2
357	317	CO-QC-T-032	3
358	1221	CO-PRD1-FRM-205	0
359	905	CO-LAB-LBL-025	2
360	447	CO-CS-T-135	3
361	835	CO-LAB-REG-017	6
362	897	CO-LAB-LBL-017	2
363	1383	CO-PRD1-LBL-048	0
364	268	CO-LAB-SOP-006	2
365	249	CO-LAB-FRM-003	6
366	1356	CO-PRD1-FRM-240	1
367	1464	CO-QA-SOP-357	0
368	1463	CO-QA-SOP-356	0
369	1484	CO-LAB-T-198	0
370	980	CO-PRD1-SOP-264	1
371	1212	CO-PRD1-PTL-086	0
372	1116	CO-QC-LBL-032	0
373	321	CO-DES-T-036	5
374	380	CO-DES-T-068	5
375	590	CO-LAB-SOP-155	8
376	1325	CO-SUP-JA-037	0
377	886	CO-LAB-LBL-007	3
378	292	CO-QA-T-007	6
379	927	CO-OPS-PTL-051	0
380	889	CO-LAB-LBL-010	2
381	1424	CO-LAB-REG-037	0
382	390	CO-QA-T-078	4
383	391	CO-QA-T-079	3
384	1473	CO-CS-FRM-267	0
385	1531	CO-H&S-PRO-007	1
386	269	CO-OPS-SOP-007	2
387	152	CO-QA-SOP-016	2
388	1517	CO-H&S-RA-005	3
389	1109	CO-QA-SOP-284	7
390	371	CO-DES-T-059	3
391	883	CO-LAB-LBL-004	1
392	622	CO-OPS-SOP-187	3
393	296	CO-QA-T-011	5
394	328	CO-LAB-FRM-024	2
395	892	CO-LAB-LBL-012	2
396	423	CO-OPS-T-111	3
397	306	CO-OPS-T-021	2
398	248	CO-LAB-FRM-002	4
399	1349	CO-PRD1-FRM-233	1
400	277	CO-OPS-SOP-124	3
401	185	CO-SUP-SOP-055	2
402	1320	CO-SUP-JA-032	0
403	884	CO-LAB-LBL-005	3
404	965	CO-SUP-FRM-178	1
405	831	CO-LAB-REG-014	22
406	1474	CO-QA-T-196	0
407	1213	CO-PRD1-SOP-312	0
408	611	CO-LAB-SOP-176	2
409	557	CO-LAB-SOP-135	3
410	570	CO-LAB-SOP-145	5
411	1110	CO-QA-SOP-285	7
412	379	CO-DES-T-067	8
413	1525	CO-H&S-PRO-001	9
414	1530	CO-H&S-PRO-006	1
415	1541	CO-H&S-RA-017	1
416	1532	CO-H&S-P-001	9
417	1524	CO-H&S-RA-012	1
418	1540	CO-H&S-RA-016	Outgoing goods and Packaging
419	1542	CO-H&S-RA-018	2
420	1538	CO-H&S-RA-014	2
421	1539	CO-H&S-RA-015	2
422	1529	CO-H&S-PRO-005	1
423	1498	CO-H&S-T-202	1
424	1534	CO-H&S-P-003	1
425	809	CO-OPS-PTL-029	2
426	536	CO-OPS-PTL-009	4
427	552	CO-LAB-SOP-130	2
428	1544	CO-LAB-FRM-276	0
429	730	CO-LAB-FRM-140	2
430	1185	CO-IT-POL-027	0
431	1346	CO-PRD1-FRM-230	0
432	1367	CO-PRD1-FRM-251	1
433	1363	CO-PRD1-FRM-247	1
434	278	CO-OPS-SOP-125	3
435	1262	CO-PRD1-LBL-047	2
436	1311	CO-SUP-FRM-220	2
437	1255	CO-PRD1-LBL-040	1
438	1368	CO-PRD1-FRM-252	1
439	263	CO-LAB-FRM-017	5
440	893	CO-LAB-LBL-013	3
441	1497	CO-H&S-T-204	4
442	1233	CO-SUP-SOP-321	2
443	427	CO-QC-T-115	3
444	627	CO-LAB-FRM-050	8
445	633	CO-LAB-FRM-043	0
446	631	CO-LAB-FRM-041	0
447	632	CO-LAB-FRM-042	0
448	1381	CO-PRD1-FRM-262	0
449	314	CO-QC-T-029	4
450	359	CO-QA-T-047	9
451	1186	CO-IT-POL-028	0
452	1187	CO-IT-POL-029	0
453	397	CO-SUP-FRM-043	3
454	1093	CO-DPT-ART-002	0
455	209	CO-SUP-SOP-058	2
456	1053	CO-QA-T-164	0
457	489	CO-SUP-SOP-072	13
458	1100	CO-SUP-SOP-277	3
459	538	CO-LAB-SOP-095	5
460	478	CO-OPS-SOP-036	2
461	584	CO-LAB-SOP-152	2
462	851	CO-OPS-REG-026	6
463	18	CO-CS-SOP-368	4
464	444	CO-CS-T-149	1
465	907	CO-OPS-LBL-027	1
466	1199	CO-PRD1-LBL-033	0
467	71	CO-QA-SOP-004	12
468	699	CO-LAB-FRM-109	2
469	297	CO-QA-T-012	4
470	581	CO-LAB-SOP-149	5
471	1120	CO-LAB-SOP-287	1
472	1067	CO-PRD1-JA-009	0
473	162	CO-SUP-SOP-044	2
474	938	CO-CS-SOP-249	0
475	939	CO-CS-FRM-175	0
476	1549	CO-QC-LBL-052	0
477	803	CO-OPS-PTL-023	2
478	805	CO-OPS-PTL-025	2
479	804	CO-OPS-PTL-024	1
480	1133	CO-QC-SOP-299	3
481	912	CO-OPS-PTL-048	3
482	806	CO-OPS-PTL-026	2
483	846	CO-LAB-PTL-045	0
484	819	CO-OPS-PTL-040	1
485	462	CO-DES-PTL-005	2
486	311	CO-FIN-T-026	4
487	486	CO-IT-SOP-044	Back-UP and Support
488	312	CO-FIN-T-027	3
489	1025	CO-DPT-IFU-026	2
490	307	CO-DES-T-022	4
491	603	CO-LAB-SOP-168	4
492	1223	CO-PRD1-SOP-319	2
493	1405	CO-CS-JA-050	0
494	853	CO-QA-T-153	2
495	1118	CO-QC-JA-012	0
496	1375	CO-OPS-URS-028	0
497	301	CO-QC-T-016	8
498	415	CO-QC-T-103	1
499	440	CO-QC-T-128	1
500	1096	CO-PRD1-SOP-276	0
501	548	CO-LAB-SOP-108	21
502	608	CO-QC-SOP-173	3
503	838	CO-LAB-REG-019	1
504	840	CO-LAB-REG-021	9
505	854	CO-QA-JA-002	6
506	617	CO-LAB-SOP-182	2
507	449	CO-QC-T-137	1
508	1545	CO-LAB-FRM-277	0
509	1355	CO-PRD1-FRM-239	1
510	157	CO-SUP-SOP-039	2
511	583	CO-LAB-SOP-151	10
512	1162	CO-PRD1-SOP-304	0
513	468	CO-QA-SOP-025	11
514	572	CO-QA-SOP-147	4
515	218	CO-SUP-SOP-067	2
516	1226	CO-LAB-FRM-207	0
517	1527	CO-H&S-PRO-003	5
518	1318	CO-SUP-JA-030	0
519	771	CO-OPS-SOP-206	2
520	770	CO-OPS-SOP-205	4
521	793	CO-OPS-SOP-228	2
522	555	CO-OPS-SOP-133	8
523	1084	CO-QC-PTL-071	1
524	765	CO-OPS-SOP-200	8
525	1169	CO-PRD1-FRM-199	5
526	1170	CO-PRD1-FRM-200	2
527	280	CO-OPS-SOP-118	5
528	764	CO-LAB-SOP-199	7
529	1172	CO-PRD1-FRM-202	3
530	794	CO-OPS-SOP-229	2
531	1083	CO-QC-PTL-070	1
532	554	CO-OPS-SOP-132	4
533	1173	CO-PRD1-FRM-203	3
534	279	CO-OPS-SOP-117	5
535	763	CO-OPS-SOP-198	6
536	1167	CO-PRD1-FRM-197	4
537	281	CO-OPS-SOP-119	8
538	1171	CO-PRD1-FRM-201	2
539	547	CO-OPS-SOP-107	7
540	1168	CO-PRD1-FRM-198	4
541	762	CO-OPS-SOP-197	9
542	556	CO-OPS-SOP-134	7
543	515	CO-OPS-SOP-091	5
544	768	CO-OPS-SOP-203	3
545	1062	CO-PRD1-T-165	1
546	1487	CO-PRD1-T-200	0
547	558	CO-LAB-REG-008	5
548	1563	CO-PRD1-SOP-370	0
549	1462	CO-PRD1-SOP-355	2
550	1562	CO-PRD1-SOP-369	0
551	1550	CO-PRD1-SOP-365	0
552	1176	CO-PRD1-SOP-306	1
553	304	CO-OPS-T-019	2
554	849	CO-OPS-T-152	1
555	161	CO-SUP-SOP-043	2
556	413	CO-SAM-T-101	2
557	843	CO-QA-REG-023	2
558	1071	CO-QA-REG-032	0
559	1142	CO-QC-QCP-058	1
560	286	CO-OPS-T-001	4
561	287	CO-OPS-T-002	2
562	896	CO-LAB-LBL-016	3
563	1345	CO-PRD1-FRM-229	2
564	1174	CO-PRD1-FRM-212	1
565	452	CO-DES-PTL-001	2
566	710	CO-LAB-FRM-120	1
567	514	CO-OPS-SOP-090	3
568	1274	CO-SUP-T-171	1
569	836	CO-QC-FRM-046	0
570	258	CO-LAB-FRM-012	4
571	385	CO-QC-T-073	8
572	857	CO-LAB-SOP-239	0
573	961	CO-PRD1-SOP-255	0
574	430	CO-QC-T-118	12
575	1066	CO-QC-PTL-060	0
576	461	CO-DES-PTL-004	2
577	516	CO-OPS-SOP-092	3
578	355	CO-OPS-T-043	5
579	21	CO-SUP-SOP-005	2
580	158	CO-SUP-SOP-040	2
581	823	CO-SUP-SOP-231	2
582	860	CO-LAB-FRM-165	0
583	212	CO-SUP-SOP-061	2
584	1324	CO-SUP-JA-036	0
585	182	CO-SUP-SOP-052	2
586	325	CO-LAB-FRM-021	5
587	1364	CO-PRD1-FRM-248	1
588	1369	CO-PRD1-FRM-253	1
589	1258	CO-PRD1-LBL-043	2
590	1307	CO-SUP-FRM-216	2
591	1251	CO-PRD1-LBL-036	1
592	1260	CO-PRD1-LBL-045	2
593	1309	CO-SUP-FRM-218	2
594	1253	CO-PRD1-LBL-038	1
595	1138	CO-QC-QCP-054	1
596	1370	CO-PRD1-FRM-254	1
597	674	CO-LAB-FRM-084	3
598	684	CO-LAB-FRM-094	3
599	546	CO-OPS-SOP-105	8
600	326	CO-LAB-FRM-022	5
601	1343	CO-PRD1-FRM-227	1
602	1371	CO-PRD1-FRM-255	1
603	1259	CO-PRD1-LBL-044	2
604	1308	CO-SUP-FRM-217	2
605	1252	CO-PRD1-LBL-037	1
606	1137	CO-QC-QCP-053	1
607	1372	CO-PRD1-FRM-256	1
608	675	CO-LAB-FRM-085	3
609	685	CO-LAB-FRM-095	3
610	410	CO-SUP-T-098	4
611	550	CO-CA-FRM-044	1
612	70	CO-QA-SOP-003	18
613	1061	CO-DPT-WEB-005	0
614	1090	CO-DPT-WEB-008	0
615	1390	CO-PRD1-PTL-102	0
616	1391	CO-PRD1-PTL-103	0
617	1392	CO-PRD1-PTL-104	0
618	1393	CO-PRD1-PTL-105	0
619	1394	CO-PRD1-PTL-106	0
620	1329	CO-SUP-JA-041	0
621	1415	CO-SUP-T-182	1
622	1243	CO-SUP-FRM-209	0
623	981	CO-PRD1-SOP-265	0
624	1097	CO-PRD1-PTL-075	0
625	1196	CO-PRD1-REG-035	1
626	1278	CO-PRD1-PTL-090	0
627	1198	CO-PRD1-PTL-078	1
628	1276	CO-SUP-FRM-213	0
629	1281	CO-PRD1-PTL-093	0
630	1279	CO-PRD1-PTL-091	0
631	1280	CO-PRD1-PTL-092	0
632	1292	CO-PRD1-PTL-097	0
633	1290	CO-PRD1-PTL-095	0
634	1289	CO-PRD1-PTL-094	0
635	1291	CO-PRD1-PTL-096	0
636	1293	CO-PRD1-PTL-098	0
637	1328	CO-SUP-JA-040	0
638	1486	CO-PRD1-T-199	0
639	1235	CO-PRD1-PTL-087	0
640	1236	CO-PRD1-PTL-088	0
641	1237	CO-PRD1-PTL-089	0
642	975	CO-PRD1-FRM-181	1
643	1330	CO-PRD1-PTL-099	0
644	1156	CO-PRD1-SOP-303	0
645	1416	CO-SUP-T-183	1
646	1275	CO-SUP-T-172	1
647	1197	CO-PRD1-REG-036	0
648	986	CO-PRD1-SOP-269	2
649	973	CO-PRD1-T-160	1
650	971	CO-PRD1-COP-003	0
651	1248	CO-SUP-FRM-210	0
652	1332	CO-PRD1-PTL-100	0
653	1227	CO-SUP-SOP-320	4
654	1327	CO-SUP-JA-039	0
655	612	CO-LAB-SOP-177	1
656	613	CO-LAB-SOP-178	1
657	338	CO-LAB-SOP-022	2
658	847	CO-LAB-PTL-046	0
659	818	CO-OPS-PTL-039	1
660	1239	CO-DPT-ART-009	0
661	1039	CO-DPT-VID-003	0
662	492	CO-SUP-SOP-075	2
663	870	CO-LAB-SOP-241	0
664	610	CO-LAB-SOP-175	3
665	1035	CO-DPT-ART-001	0
666	1246	CO-SUP-SOP-324	2
667	821	CO-OPS-PTL-043	1
668	247	CO-LAB-FRM-001	4
669	260	CO-LAB-FRM-014	6
670	261	CO-LAB-FRM-015	3
671	677	CO-LAB-FRM-087	6
672	678	CO-LAB-FRM-088	5
673	679	CO-LAB-FRM-089	5
674	680	CO-LAB-FRM-090	5
675	681	CO-LAB-FRM-091	5
676	682	CO-LAB-FRM-092	5
677	683	CO-LAB-FRM-093	5
678	885	CO-LAB-LBL-006	3
679	829	CO-LAB-REG-012	1
680	643	CO-LAB-FRM-054	5
681	646	CO-LAB-FRM-057	4
682	645	CO-LAB-FRM-056	5
683	647	CO-LAB-FRM-058	5
684	649	CO-LAB-FRM-060	70% ethanol
685	650	CO-LAB-FRM-061	6
686	653	CO-LAB-FRM-064	2
687	254	CO-LAB-FRM-008	6
688	659	CO-LAB-FRM-069	6
689	660	CO-LAB-FRM-070	5
690	257	CO-LAB-FRM-011	5
691	668	CO-LAB-FRM-078	3
692	672	CO-LAB-FRM-082	4
693	700	CO-LAB-FRM-110	2
694	701	CO-LAB-FRM-111	3
695	711	CO-LAB-FRM-121	1
696	712	CO-LAB-FRM-122	1
697	713	CO-LAB-FRM-123	1
698	714	CO-LAB-FRM-124	2
699	726	CO-LAB-FRM-136	1
700	731	CO-LAB-FRM-141	1
701	666	CO-LAB-FRM-076	2
702	702	CO-LAB-FRM-112	2
703	703	CO-LAB-FRM-113	2
704	704	CO-LAB-FRM-114	2
705	1533	CO-H&S-P-002	6
706	1373	CO-PRD1-FRM-257	1
707	1377	CO-PRD1-FRM-258	1
708	1379	CO-PRD1-FRM-260	1
709	1378	CO-PRD1-FRM-259	1
710	315	CO-QC-T-030	3
711	1210	CO-PRD1-FRM-211	2
712	290	CO-DES-T-005	2
713	1188	CO-IT-POL-030	0
714	619	CO-LAB-SOP-184	2
715	1101	CO-SUP-SOP-278	8
716	396	CO-DES-T-084	5
717	903	CO-LAB-LBL-023	1
718	464	CO-DES-PTL-007	3
719	424	CO-DES-T-112	6
720	887	CO-LAB-LBL-008	1
721	985	CO-PRD1-FRM-182	2
722	830	CO-LAB-REG-013	3
723	553	CO-LAB-SOP-131	12
724	24	CO-OPS-SOP-002	3
725	601	CO-OPS-SOP-166	2
726	1105	CO-SUP-POL-017	3
727	579	CO-QA-POL-013	2
728	576	CO-QA-POL-010	Environment and Equipment
729	578	CO-CS-POL-012	5
730	563	CO-QA-POL-006	5
731	574	CO-OPS-POL-008	4
732	859	CO-QA-POL-014	4
733	914	CO-QA-POL-015	0
734	295	CO-QA-T-010	5
735	146	CO-QA-SOP-267	7
736	1469	CO-QA-T-192	0
737	1470	CO-QA-T-193	0
738	1339	CO-PRD1-FRM-223	1
739	340	CO-OPS-SOP-127	7
740	1341	CO-PRD1-FRM-225	1
741	661	CO-LAB-FRM-071	4
742	1350	CO-PRD1-FRM-234	1
743	848	CO-LAB-PTL-047	0
744	1136	CO-LAB-SOP-302	5
745	1135	CO-LAB-SOP-301	4
746	1125	CO-LAB-SOP-291	4
747	502	CO-LAB-SOP-078	6
748	774	CO-OPS-SOP-209	1
749	509	CO-OPS-SOP-085	000
750	510	CO-OPS-SOP-086	2
751	636	CO-OPS-SOP-190	3
752	511	CO-OPS-SOP-087	2
753	512	CO-OPS-SOP-088	2
754	1134	CO-LAB-SOP-300	5
755	507	CO-OPS-SOP-083	2
756	508	CO-OPS-SOP-084	2
757	1126	CO-LAB-SOP-292	4
758	347	CO-OPS-SOP-128	000 cells/uL Master Stocks
759	513	CO-OPS-SOP-089	4
760	1059	CO-DPT-WEB-003	0
761	1089	CO-DPT-WEB-007	Spanish)
762	17	CO-SUP-SOP-001	2
763	920	CO-CS-SOP-248	2
764	19	CO-SUP-SOP-003	1
765	1119	CO-QC-SOP-286	3
766	537	CO-QC-SOP-094	5
767	969	CO-OPS-URS-020	0
768	623	CO-OPS-SOP-188	4
769	1073	CO-QC-PTL-062	0
770	1193	CO-QC-PTL-077	0
771	395	CO-DES-T-083	3
772	1108	CO-QA-SOP-283	4
773	1314	CO-SUP-JA-026	0
774	1376	CO-PRD1-JA-044	0
775	370	CO-DES-T-058	4
776	1402	CO-SAM-JA-048	0
777	1564	CO-PRD1-JA-070	0
778	1317	CO-SUP-JA-029	0
779	1068	CO-SUP-FRM-195	0
780	412	CO-SUP-T-100	3
781	481	CO-SUP-SOP-068	14
782	1571	CO-QC-PTL-109	0
783	458	CO-QC-T-144	2
784	586	CO-QC-SOP-154	5
785	432	CO-QC-T-120	4
786	624	CO-QC-FRM-049	0
787	1086	CO-QC-PTL-073	1
788	1146	CO-QC-QCP-062	8
789	1115	CO-QC-LBL-031	0
790	1106	CO-QC-SOP-282	1
791	1114	CO-QC-REG-034	2
792	1076	CO-QC-PTL-064	2
793	394	CO-QC-T-082	14
794	855	CO-QA-SOP-237	0
795	909	CO-QA-SOP-244	2
796	1158	CO-QA-JA-014	0
797	1157	CO-QA-JA-013	1
798	1175	CO-QA-JA-018	1
799	1159	CO-QA-JA-015	2
800	1160	CO-QA-JA-016	0
801	1224	CO-QA-JA-021	0
802	471	CO-QA-T-146	1
803	151	CO-QA-SOP-015	3
804	85	CO-SUP-SOP-025	2
805	625	CO-QC-COP-001	3
806	654	CO-QC-FRM-065	1
807	655	CO-QC-SOP-012	1
808	1107	CO-QC-POL-018	5
809	606	CO-QC-SOP-171	3
810	1113	CO-QA-POL-021	10
811	1111	CO-QA-POL-019	6
812	470	CO-QA-SOP-028	9
813	888	CO-LAB-LBL-009	2
814	902	CO-LAB-LBL-022	1
815	1384	CO-PRD1-LBL-049	0
816	894	CO-LAB-LBL-014	2
817	408	CO-QC-T-096	4
818	183	CO-SUP-SOP-053	2
819	178	CO-SUP-SOP-048	3
820	180	CO-SUP-SOP-050	2
821	1322	CO-SUP-JA-034	0
822	1315	CO-SUP-JA-027	0
823	807	CO-OPS-PTL-027	2
824	626	CO-OPS-PTL-011	2
825	808	CO-OPS-PTL-028	4
826	605	CO-LAB-SOP-170	3
827	588	CO-OPS-PTL-010	14
828	271	CO-OPS-SOP-009	3
829	407	CO-QC-T-095	6
830	580	CO-LAB-SOP-148	11
831	1304	CO-SUP-T-178	4
832	272	CO-LAB-SOP-010	4
833	448	CO-QC-T-136	1
834	454	CO-DES-T-140	1
835	41	CO-DES-SOP-372	2
836	948	CO-OPS-URS-018	0
837	970	CO-PRD1-POL-016	0
838	999	CO-PRD1-FRM-191	2
839	179	CO-SUP-SOP-049	4
840	181	CO-SUP-SOP-051	2
841	615	CO-LAB-SOP-180	3
842	947	CO-REG-T-157	0
843	1140	CO-QC-QCP-056	27
844	1189	CO-IT-POL-031	0
845	1037	CO-DPT-VID-001	0
846	473	CO-QA-SOP-031	3
847	320	CO-QC-T-035	4
848	267	CO-LAB-SOP-005	3
849	1513	CO-H&S-RA-001	5
850	1536	CO-H&S-RA-013	6
851	1516	CO-H&S-RA-004	5
852	1515	CO-H&S-RA-003	5
853	1519	CO-H&S-RA-007	5
854	1518	CO-H&S-RA-006	5
855	1520	CO-H&S-RA-008	3
856	1521	CO-H&S-RA-009	3
857	1514	CO-H&S-RA-002	6
858	1522	CO-H&S-RA-010	2
859	1190	CO-IT-POL-032	0
860	374	CO-DES-T-062	3
861	1112	CO-QA-POL-020	9
862	376	CO-DES-T-064	3
863	375	CO-DES-T-063	3
864	144	CO-QA-SOP-345	4
865	598	CO-LAB-SOP-163	8
866	1316	CO-SUP-JA-028	0
867	1385	CO-PRD1-LBL-050	0
868	217	CO-SUP-SOP-066	2
869	900	CO-LAB-LBL-020	2
870	657	CO-LAB-FRM-067	5
871	1382	CO-PRD1-FRM-263	1
872	1380	CO-PRD1-FRM-261	1
873	1094	CO-DPT-JA-010	0
874	1103	CO-SUP-SOP-280	8
875	467	CO-QA-SOP-024	2
876	995	CO-PRD1-FRM-190	0
877	1421	CO-SUP-LBL-051	0
878	1488	CO-SUP-T-201	0
879	1490	CO-SUP-FRM-269	0
880	1489	CO-SUP-SOP-363	0
881	641	CO-LAB-FRM-052	4
882	1555	CO-SUP-JA-063	0
883	1557	CO-SUP-JA-065	0
884	1556	CO-SUP-JA-064	0
885	16	CO-DES-SOP-004	4
886	437	CO-DES-T-125	2
887	308	CO-QC-T-023	3
888	559	CO-LAB-SOP-136	6
889	890	CO-LAB-LBL-011	3
890	1124	CO-LAB-SOP-290	4
891	758	CO-OPS-SOP-196	3
892	438	CO-DES-T-126	2
893	1091	CO-DPT-WEB-009	Consent
894	360	CO-QA-T-048	4
895	930	CO-OPS-URS-008	0
896	498	CO-QA-SOP-076	8
897	399	CO-QA-T-087	4
898	490	CO-SUP-SOP-073	2
899	1123	CO-LAB-SOP-289	2
900	582	CO-LAB-SOP-150	9
901	964	CO-PRD1-SOP-257	1
902	967	CO-PRD1-SOP-259	1
903	1128	CO-LAB-SOP-294	4
904	1568	CO-PRD1-FRM-279	0
905	1228	CO-DPT-ART-003	0
906	1026	CO-DPT-IFU-027	2
907	832	CO-LAB-REG-015	10
908	1102	CO-SUP-SOP-279	4
909	984	CO-PRD1-LBL-029	0
910	450	CO-QC-T-138	2
911	1475	CO-QA-T-197	0
912	500	CO-QA-SOP-077	10
913	497	CO-QA-REG-005	1
914	147	CO-QA-SOP-011	6
915	487	CO-SUP-SOP-069	7
916	364	CO-SUP-FRM-046	4
917	365	CO-SUP-FRM-042	4
918	367	CO-SUP-FRM-048	4
919	366	CO-SUP-FRM-047	4
920	398	CO-QA-T-086	4
921	845	CO-QA-REG-025	4
922	488	CO-SUP-SOP-070	5
923	1244	CO-SUP-SOP-322	1
924	1335	CO-SUP-POL-034	0
925	323	CO-LAB-FRM-019	3
926	475	CO-OPS-SOP-033	3
927	1357	CO-PRD1-FRM-241	1
928	519	CO-LAB-FRM-026	8
929	417	CO-QC-T-105	7
930	1072	CO-QC-PTL-061	0
931	587	CO-QC-QCP-039	12
932	1342	CO-PRD1-FRM-226	1
933	1077	CO-QC-PTL-065	2
934	460	CO-DES-PTL-003	3
935	1055	CO-PRD1-LBL-030	0
936	294	CO-QC-T-009	6
937	1333	CO-PRD1-T-179	1
938	569	CO-LAB-T-148	1
939	1060	CO-DPT-WEB-004	0
940	1092	CO-DPT-WEB-010	0
941	476	CO-OPS-SOP-034	3
942	1082	CO-QC-PTL-069	8
943	1208	CO-PRD1-SOP-310	0
944	1222	CO-PRD1-SOP-318	0
945	270	CO-OPS-SOP-008	3
946	330	CO-LAB-SOP-014	4
947	1191	CO-IT-POL-033	0
948	1426	CO-SUP-JA-057	0
949	607	CO-OPS-SOP-172	3
950	929	CO-OPS-URS-007	0
951	356	CO-QA-T-044	4
952	457	CO-QA-T-143	1
953	573	CO-HR-POL-007	3
954	485	CO-QA-SOP-043	7
955	868	CO-HR-REG-030	6
956	983	CO-PRD1-SOP-268	2
957	1326	CO-SUP-JA-038	0
958	177	CO-SUP-SOP-047	2
959	1351	CO-PRD1-FRM-235	1
960	250	CO-LAB-FRM-004	5
961	252	CO-LAB-FRM-006	4
962	259	CO-LAB-FRM-013	6
963	1352	CO-PRD1-FRM-236	1
964	1353	CO-PRD1-FRM-237	1
965	1354	CO-PRD1-FRM-238	1
966	1045	CO-LAB-FRM-192	0
967	518	CO-LAB-FRM-025	2
968	491	CO-SUP-SOP-074	2
969	446	CO-FIN-T-134	2
970	908	CO-OPS-LBL-028	1
971	1154	CO-QC-QCP-070	7
972	1344	CO-PRD1-FRM-228	1
973	1041	CO-DPT-VID-005	0
974	1241	CO-DPT-ART-011	0
975	1215	CO-PRD1-URS-022	0
976	1422	CO-LAB-URS-029	0
977	1266	CO-PRD1-URS-025	0
978	917	CO-OPS-URS-002	1
979	1095	CO-FIN-T-167	0
980	959	CO-PRD1-SOP-254	1
981	503	CO-LAB-SOP-079	7
982	1403	CO-SAM-JA-049	0
983	504	CO-LAB-SOP-080	6
984	952	CO-PRD1-SOP-252	1
985	1117	CO-QC-JA-011	1
986	916	CO-QC-JA-004	0
987	1419	CO-SUP-JA-055	0
988	604	CO-LAB-SOP-169	3
989	1179	CO-PRD1-SOP-308	0
990	972	CO-PRD1-SOP-260	0
991	1164	CO-PRD1-SOP-305	1
992	1214	CO-PRD1-SOP-313	1
993	966	CO-PRD1-SOP-258	0
994	594	CO-LAB-SOP-159	4
995	1420	CO-SUP-JA-056	0
996	469	CO-QA-SOP-026	6
997	337	CO-QC-SOP-021	4
998	561	CO-LAB-SOP-138	4
999	331	CO-LAB-SOP-015	3
1000	266	CO-LAB-SOP-004	3
1001	543	CO-LAB-SOP-102	4
1002	336	CO-LAB-SOP-020	2
1003	333	CO-LAB-SOP-017	3
1004	335	CO-LAB-SOP-019	2
1005	932	CO-QA-JA-006	1
1006	618	CO-LAB-SOP-183	1
1007	595	CO-LAB-SOP-160	2
1008	593	CO-LAB-SOP-158	5
1009	996	CO-PRD1-SOP-271	0
1010	332	CO-LAB-SOP-016	4
1011	551	CO-LAB-SOP-129	8
1012	506	CO-LAB-SOP-082	1
1013	1211	CO-PRD1-SOP-311	0
1014	620	CO-QC-SOP-185	2
1015	616	CO-LAB-SOP-181	1
1016	1194	CO-PRD1-SOP-309	0
1017	621	CO-OPS-SOP-186	2
1018	585	CO-LAB-SOP-153	7
1019	949	CO-QA-T-158	0
1020	956	CO-OPS-URS-019	1
1021	942	CO-OPS-URS-015	0
1022	941	CO-OPS-URS-014	0
1023	936	CO-OPS-URS-012	0
1024	1267	CO-PRD1-URS-026	0
1025	935	CO-OPS-URS-011	0
1026	946	CO-SUP-URS-017	0
1027	937	CO-OPS-URS-013	0
1028	933	CO-OPS-URS-009	1
1029	934	CO-OPS-URS-010	0
1030	1161	CO-PRD1-URS-021	1
1031	928	CO-OPS-URS-006	0
1032	1302	CO-PRD1-URS-027	0
1033	1098	CO-DPT-FEA-002	0
1034	1238	CO-DPT-ART-008	0
1035	1042	CO-DPT-VID-006	0
1036	1567	CO-OPS-PTL-108	1
1037	761	CO-OPS-PTL-015	1
1038	760	CO-OPS-PTL-014	2
1039	759	CO-OPS-PTL-013	1
1040	377	CO-DES-T-065	5
1041	378	CO-DES-T-066	2
1042	453	CO-DES-PTL-002	2
1043	799	CO-OPS-PTL-019	2
1044	474	CO-OPS-SOP-032	3
1045	1374	CO-PRD1-PTL-101	1
1046	265	CO-LAB-SOP-003	3
1047	810	CO-OPS-PTL-030	7
1048	798	CO-OPS-PTL-018	2
1049	802	CO-OPS-PTL-022	1
1050	801	CO-OPS-PTL-021	4
1051	800	CO-OPS-PTL-020	3
1052	310	CO-DES-T-025	8
1053	796	CO-QC-PTL-016	-20 freezer/QC lab asset 0330
1054	815	CO-OPS-PTL-036	2
1055	797	CO-OPS-PTL-017	4
1056	426	CO-DES-T-114	2
1057	560	CO-LAB-SOP-137	7
1058	963	CO-PRD1-SOP-256	0
1059	575	CO-CA-POL-009	3
1060	638	CO-OPS-SOP-192	3
1061	1423	CO-LAB-PTL-186	0
1062	372	CO-DES-T-060	8
1063	373	CO-DES-T-061	7
1064	73	CO-QA-SOP-326	7
1065	418	CO-QA-T-106	3
1066	841	CO-QA-REG-022	2
1067	925	CO-OPS-PTL-049	0
1068	639	CO-LAB-FRM-051	5
1069	1225	CO-LAB-FRM-206	0
1070	577	CO-OPS-POL-011	2
1071	600	CO-OPS-SOP-165	1
1072	540	CO-LAB-SOP-097	15
1073	1359	CO-PRD1-FRM-243	1
\.


--
-- Data for Name: document_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_list (id, documentqtid, documenttitle, documenttype, risklevel, doc_id) FROM stdin;
275	CO-SUP-SOP-231	New Items	867	0	823
457	CO-LAB-FRM-006	Triton X-100	549	0	252
641	CO-OPS-SOP-007	Firmware Up-date	765	0	269
642	CO-OPS-PTL-051	Factory Acceptance Test (FAT) Sprint B+ In-line Leak Tester	729	0	927
643	CO-PRD1-SOP-263	Entry and Exit to the Oak House Production Facility and Production Suite	1055	0	977
807	CO-QA-REG-041	Employee Unique Initial Register	962	0	1565
644	CO-SUP-JA-028	Running Purchasing and Production Exception Reports	40	0	1316
645	CO-QC-LBL-052	io Instrument Failure - For Engineering Inspection Label	918	0	1549
646	CO-OPS-SOP-190	Preparation of IC DNA in TE buffer 10ng/μl master stock aliquots	942	0	636
647	CO-H&S-RA-002	Risk Assessment for use of Microorganisms	1047	0	1514
648	CO-IT-POL-026	Cryptography Policy	457	0	1184
649	CO-SUP-SOP-044	Invoice Customers Manually	358	0	162
650	CO-H&S-RA-010	Risk Assessment for work-related stress	162	0	1522
651	CO-PRD1-PTL-095	Oak House Labcold RLVF0417 Freezer 1162 Validation Protocol	489	0	1290
652	CO-DES-T-114	Validation Summary Report	215	0	426
653	CO-QA-T-109	Archiving Box Contents List	567	0	421
654	CO-DPT-IFU-044	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU	581	0	1063
655	CO-DES-T-025	Validation Protocol template	49	0	310
656	CO-OPS-SOP-105	NG1_IC Detection Reagent	142	0	546
657	CO-QC-T-035	Rework Protocol Template	68	0	320
658	CO-OPS-SOP-002	Planning for Process Validation	572	0	24
659	CO-LAB-SOP-129	Use of the Priorclave Autoclave	997	0	551
660	CO-LAB-FRM-057	Part No. 0085 Buffer solution pH 4	547	0	646
661	CO-LAB-SOP-158	Use of the NanoDrop ND2000 Spectrophotometer	1004	0	593
662	CO-OPS-SOP-189	CT/NG ATCC Input Generation	553	0	628
663	CO-LAB-FRM-050	Incoming Quality Control and Specification for ‘CMO Manufactured io® Cartridges’	816	0	627
664	CO-IT-SOP-044	IT Management Back-UP and Support	443	0	486
665	CO-DPT-FEA-002	UTI Screening Box	868	0	1098
666	CO-LAB-SOP-164	Bambi compressor: Use and Maintenance	116	0	599
667	CO-LAB-FRM-099	‘Neisseria gonorrhoeae DNA’ Part Number 0273	895	0	689
668	CO-OPS-T-043	Mutual Agreement of Confidentiality	174	0	355
669	CO-LAB-FRM-112	Part Number 0298 Vircell NG DNA Control	837	0	702
670	CO-PRD1-URS-027	User Requirements Specification for a Monmouth Scientific Model Guardian 1800 production enclosure	596	0	1302
671	CO-DPT-VID-006	Vaginal Swab Sample Collection Video Transcript	393	0	1042
672	CO-OPS-PTL-028	Rapid PCR Rig PQ Procedure	923	0	808
673	CO-LAB-SOP-108	Laboratory Cleaning	856	0	548
674	CO-QC-T-032	Equipment Log	960	0	317
675	CO-QA-FRM-194	Auditor Competency Assessment	298	0	1065
676	CO-LAB-FRM-020	Elution Reagent	55	0	324
677	CO-LAB-SOP-002	Agilent Bioanalyzer SOP for RNA 6000 Pico and Nano Kits	1019	0	264
678	CO-QA-JA-013	QT9 Feedback Module Job Aid	646	0	1157
679	CO-LAB-FRM-073	1L Nalgene Disposable Filter Unit’ Part No. 0167	546	0	663
680	CO-DPT-BOM-028	2.801.001 (ADX Blood Card (1)	2	0	1457
681	CO-PRD1-LBL-036	NG1 IC Detection Reagent Vial Label	447	0	1251
682	CO-DPT-WEB-004	Terms of Service	108	0	1060
683	CO-LAB-FRM-026	T7 Gene 6 Exonuclease 1000U/µL	536	0	519
684	CO-DPT-ART-009	Oral STI Sample Collection Sticker	322	0	1239
685	CO-QC-SOP-286	Procedure for the Release of io Instruments	873	0	1119
686	CO-PRD1-FRM-261	Sartorius Minisart™ NML Syringe Filters Sterile (0.45 µm) Male Luer Lock Oak House IQC	718	0	1380
687	CO-SUP-SOP-068	Purchasing SOP	607	0	481
688	CO-LAB-FRM-016	CT Taqman Probe (FAM)	84	0	262
689	CO-QC-QCP-039	T7 Raw Material Test	704	0	587
690	CO-QC-QCP-068	CT/NG Taq-UNG reagent qPCR test (MOB-D-0277)	336	0	1152
691	CO-PRD1-FRM-223	Potassium Chloride Oak House Production IQC	764	0	1339
692	CO-QA-JA-018	QT9 Internal Audit Module Job Aid	711	0	1175
693	CO-OPS-URS-013	User requirement specification for class 2 microbiological safety cabinet	479	0	937
694	CO-OPS-URS-014	User requirement specification for a filter integrity tester	557	0	941
695	CO-OPS-SOP-228	Manufacture of Ab-HS Taq/UNG Reagent	980	0	793
696	CO-LAB-FRM-104	‘CT/NG: NG2/IC Detection Reagent	1084	0	694
697	CO-QC-T-155	CTNG QC Cartridge Analysis Module	153	0	915
698	CO-QC-T-138	Summary technical Documentation (for assay)	280	0	450
699	CO-CA-FRM-044	Non-binx-initiated study proposal	356	0	550
700	CO-SUP-FRM-215	CT IC Primer Passivation Reagent Component Pick List Form	76	0	1306
701	CO-OPS-PTL-048	io Release Record (following repair or refurbishment)	251	0	912
702	CO-QC-PTL-068	CTNG Detection Reagent Validation	601	0	1080
703	CO-DPT-BOM-013	2.600.906 (CG3 + Blood Female) Kit BOM	350	0	1442
704	CO-DPT-ART-006	COVID Pre-Printed PCR Label - 1D Barcode	999	0	1231
705	CO-PRD1-SOP-256	Velp Scientific WIZARD IR Infrared Vortex Mixer SOP	205	0	963
706	CO-LAB-FRM-100	‘CT/NG: IC DNA Reagent	641	0	690
707	CO-SUP-SOP-281	Cartridge Component Stock Control Procedure	282	0	1104
708	CO-OPS-PTL-037	Blister Cropping Press IQ and OQ Validation Protocol	509	0	816
709	CO-LAB-LBL-012	General Calibration Label	978	0	892
710	CO-LAB-FRM-137	‘HS anti-Taq mAb (5.7 mg/mL)’ Part no: 0340	827	0	727
711	CO-FIN-FRM-282	Fixed Asset Transfer Form	214	0	434
712	CO-LAB-LBL-019	Asset Calibration Label	1049	0	899
713	CO-LAB-FRM-128	‘TV_Alt_6_Rev’ Part No 0331 from SGS DNA	183	0	718
870	CO-IT-POL-022	Access Control Policy	610	0	1180
853	CO-LAB-FRM-005	100bp low MW Ladder	200	0	251
1384	CO-OPS-SOP-123	DTT Solution	633	0	342
1431	CO-SUP-JA-032	Goods Movements	220	0	1320
23	CO-QA-T-189	Post Market Performance Follow-up Plan Template	608	0	1466
1	CO-QA-REG-001	Change Management Register	357	0	493
2	CO-DPT-ART-002	Inner lid activation label (STI/ODX)	408	0	1093
3	CO-OPS-REG-029	binx health ltd Master Assay Code Register	15	0	867
4	CO-PRD1-FRM-230	Hybridization Oven Verification and Calibration Form	85	0	1346
5	CO-LAB-JA-043	CIR Job Aid	375	0	1337
83	CO-LAB-REG-013	Pipette Register	790	0	830
412	CO-SUP-SOP-007	Procedure for Sales Administration	762	0	\N
611	CO-CS-T-133	Instrument Field Visit	302	0	\N
728	CO-SUP-SOP-055	Goods Movement	328	0	185
1228	CO-QA-T-007	External Change Notification Form	462	0	292
1792	CO-SUP-SOP-069	Supplier Evaluation	828	0	487
2114	CO-SUP-FRM-216	NG1 IC Detection Reagent Component Pick List Form	480	0	1307
2115	CO-QC-QCP-054	NG1 Plasmid Quantification - qPCR Test  Part No. 0346	787	0	1138
2116	CO-QA-T-158	User Requirement Specification  URS  template	864	0	949
2117	CO-LAB-FRM-009	D- + -Trehalose Dihydrate	458	0	255
2118	CO-PRD1-FRM-230	Hybridization Oven Verification and Calibration Form	85	0	1346
2119	CO-SUP-SOP-006	Equipment Fulfilment and Field Visit SOP for non-stock instruments	429	0	22
2120	CO-DPT-BOM-017	2.601.002  CG + Blood Male AG  Kit BOM	388	0	1446
2121	CO-H&S-T-203	Blank Form for H&S COSHH assessments	268	0	1499
2122	CO-LAB-FRM-015	Part No 0181 ROSS fill solution pH Electrode	794	0	261
2123	CO-PRD1-FRM-238	Trizma hydrochloride Oak House Production IQC	1002	0	1354
2124	CO-QA-T-106	Vigilance Form	482	0	418
2125	CO-PRD1-PTL-095	Oak House Labcold RLVF0417 Freezer 1162 Validation Protocol	489	0	1290
2126	CO-LAB-FRM-016	CT Taqman Probe  FAM	84	0	262
2127	CO-PRD1-PTL-101	Validation of Oak House CT/NG reagent process	736	0	1374
2128	CO-QC-QCP-061	Electrode Electrochemical Functionality QC Assessment	938	0	1145
2129	CO-PRD1-PTL-105	Oak House APC Schneider UPS Asset  1176 Validation Protocol	226	0	1393
2130	CO-SUP-JA-024	Consumption on Cost Center	690	0	1312
2131	CO-OPS-PTL-028	Rapid PCR Rig PQ Procedure	923	0	808
2132	CO-PRD1-FRM-205	Equipment Maintenance and Calibration Form	528	0	1221
2133	CO-LAB-PTL-047	PQ Protocol for binder incubator and humidity chamber	229	0	848
2134	CO-SUP-SOP-064	Create a PO Within a Project	435	0	215
2135	CO-QA-REG-032	Master List of Applicable Standards Form Template	832	0	1071
2136	CO-PRD1-SOP-258	Use of Oak House N2400-3010 Magnetic Stirrer	917	0	966
2137	CO-LAB-FRM-277	Low Risk Temperature Controlled Asset Sign	939	0	1545
2138	CO-PRD1-PTL-092	Oak House Labcold RLDF1519 Fridge 1159 Validation Protocol	793	0	1280
2139	CO-PRD1-FRM-235	Trehalose dihydrate Oak House Production IQC	254	0	1351
24	CO-SUP-JA-026	Production Requests to Production Orders	892	0	1314
6	CO-QC-T-118	Moby Detection Reagent Analysis Spreadsheet	799	0	430
7	CO-OPS-SOP-036	Instrument Engineering Change Management	1058	0	478
8	CO-LAB-SOP-168	Jenway 3510 model pH Meter	470	0	603
9	CO-PRD1-T-199	Oak House Manufacturing Overview SOP Template	709	0	1486
10	CO-SUP-JA-057	Third Party Sale and Purchase Orders Process	888	0	1426
11	CO-DPT-IFU-032	binx At-Home Collection Kit IFU Group_Broad (English Version)	552	0	1030
12	CO-LAB-FRM-085	NG2 Synthetic Target Part no 0259	894	0	675
13	CO-LAB-FRM-092	Part No 0266 ‘NG Target 2 Forward Primer’ from SGS DNA	936	0	682
14	CO-SUP-JA-036	New Stock Adjustment	150	0	1324
15	CO-LAB-FRM-101	‘CT/NG: NG1/NG2/IC Primer Passivation Reagent	434	0	691
16	CO-PRD1-FRM-244	Albumin from bovine serum (BSA) Oak House Production IQC	924	0	1360
17	CO-OPS-PTL-025	io Reader – Force End Test Protocol	360	0	805
18	CO-PRD1-SOP-308	Use of IKA Digital Roller Mixer	339	0	1179
19	CO-LAB-FRM-124	Part No. 0319 NATrol Neisseria gonorrhoeae Positive Control	313	0	714
20	CO-LAB-FRM-277	Low Risk Temperature Controlled Asset Sign	939	0	1545
21	CO-PRD1-FRM-227	NG2 di452 probe Oak House production IQC	293	0	1343
22	CO-SUP-FRM-217	NG2 IC Detection Reagent Component Pick List Form	568	0	1308
25	CO-LAB-FRM-043	Incoming Quality Control and Specification for ‘CT Plasmid in TE buffer’ Materials binx Part Number: 0348	535	0	633
26	CO-QC-T-023	Solution Preparation Form	645	0	308
27	CO-LAB-SOP-006	Esco Laminar Flow Cabinet	735	0	268
28	CO-LAB-FRM-138	‘Potassium Chloride Solution’ Part Number: 0341	713	0	728
29	CO-QA-T-143	Training Plan Quarterly Sign Off Form	211	0	457
30	CO-LAB-LBL-016	MBG water label	760	0	896
31	CO-LAB-SOP-161	Elix Deionised Water System	486	0	596
32	CO-H&S-P-001	Health and Safety Policy	570	0	1532
33	CO-DPT-ART-004	ADX Blood Card Barcode QR Labels	126	0	1229
34	CO-QC-PTL-060	MOBY Detection Reagent Spreadsheet Validation Protocol	257	0	1066
35	CO-LAB-FRM-192	TV Synthetic Target (P/N 0418)	246	0	1045
36	CO-IT-POL-029	Information Security Roles and Responsibilities	722	0	1187
37	CO-H&S-RA-005	Flammable & Explosive Substances Risk Assessment for  binx health Ltd (Derby Court and Unit 6)	175	0	1517
38	CO-PRD1-SOP-309	Use of the Uninterruptible Power Supply	831	0	1194
39	CO-SUP-JA-027	Raising Inspection flag on stock material (SAP ByD)	526	0	1315
40	CO-DES-T-068	Experimental Template: Write Up	369	0	380
41	CO-CA-REG-031	Donor Number Consent Register	531	0	869
42	CO-PRD1-SOP-271	Use of the Pacplus Impulse Heat Sealer	603	0	996
43	CO-QC-PTL-072	dPCR Performance Qualification	771	0	1085
44	CO-DPT-BOM-007	2.600.007 (CG3 + Blood + Blood Male) Kit BOM	841	0	1436
45	CO-H&S-P-002	PAT Policy	1027	0	1533
46	CO-LAB-LBL-017	Equipment Under Qualification Label	252	0	897
47	CO-QC-T-076	Environmental Chamber Monitoring Form	490	0	388
48	CO-LAB-FRM-018	CTdi452 Probe from atdbio	779	0	322
49	CO-SUP-FRM-047	Supplier Questionnaire - Hardware	644	0	366
50	CO-QC-QCP-063	CT/NG: NG2/IC detection reagent Heated io detection rig	349	0	1147
51	CO-LAB-SOP-239	Microorganism Ampoules Handling SOP	244	0	857
52	CO-LAB-FRM-108	‘CT di452 Probe from SGS’ Part No. 0289	1024	0	698
53	CO-SUP-SOP-323	Demand Planning	548	0	1245
54	CO-LAB-FRM-111	Part No. 0296 Chlamydia trachomatis serovar F ATCC VR-346	391	0	701
55	CO-SUP-JA-067	CT/NG ioTM Cartridge Packing Instructions for QC samples (Softbox PRO Shipper)	297	0	1559
56	CO-QC-PTL-071	Manufacture of Cartridge Reagents	325	0	1084
57	CO-DPT-IFU-041	At-Home Blood Spot Collection Kit USPS IFU (Spanish Print Version)	929	0	1048
58	CO-DPT-BOM-002	2.600.002 (CG + Blood Male) Kit BOM	829	0	1431
59	CO-OPS-URS-009	User Requirement Specification for pH/mV/°C Meter	893	0	933
60	CO-OPS-SOP-123	DTT Solution	633	0	342
61	CO-SUP-SOP-048	Raise PO - non-Stock & Services	196	0	178
62	CO-H&S-PRO-007	Fire evacuation procedure for Oak House	649	0	1531
63	CO-SUP-T-184	binx Commercial Invoice (Misc. shipments)	321	0	1417
64	CO-IT-POL-030	Physical Security Policy	716	0	1188
65	CO-OPS-SOP-134	Manufacture of Trehalose in PCR Buffer	800	0	556
66	CO-SUP-JA-037	Expiry Date Amendment	217	0	1325
67	CO-LAB-FRM-077	‘Albumin from bovine serum – New Zealand Source’ Part Number: 0219	630	0	667
68	CO-SUP-T-182	Oak House Commercial Invoice - Cartridge Reagent (2-8°c)	1079	0	1415
69	CO-H&S-RA-014	Health and Safety Risk Assessment Oak House Facility	188	0	1538
70	CO-DES-T-062	Risk Management Plan template	1044	0	374
71	CO-PRD1-PTL-097	Oak House Labcold RLDF1519 Fridge 1207 Validation Protocol	218	0	1292
72	CO-QC-PTL-109	QC CT/NG 2:2 Input Manufactured Under CO-OPS-SOP-189 Validation Protocol	1026	0	1571
73	CO-LAB-LBL-023	Pilot Line Materials Label	865	0	903
74	CO-DPT-IFU-013	123 At-Home Card (English Version)	1010	0	1012
75	CO-SUP-JA-063	Softbox TempCell F39 (13-48) Dry ice shipper packing instructions	173	0	1555
76	CO-SUP-FRM-216	NG1 IC Detection Reagent Component Pick List Form	480	0	1307
77	CO-LAB-SOP-022	Operation & Maintenance of Grant SUB Aqua Pro 5 (SAP5) unstirred Water Bath with Labarmor Beads	1016	0	338
78	CO-SUP-SOP-057	Consume to Cost Centre or Project	453	0	208
79	CO-LAB-SOP-292	Preparation of Tryptone Soya Broth (TSB) and Tryptone Soya Agar (TSA)	157	0	1126
80	CO-PRD1-FRM-182	Pipette Internal Verification Form	189	0	985
81	CO-LAB-FRM-079	‘Uracil DNA Glycosylase [50 thousand U/mL]’ Part Number 0240	768	0	669
82	CO-OPS-PTL-014	Validation -80 Chest Freezer Micro lab	382	0	760
84	CO-DPT-BOM-014	2.600.907 (CG3 + Blood + Blood Female) Kit BOM	914	0	1443
85	CO-H&S-COSHH-014	COSHH Assessment - Compressed Gases	461	0	1512
86	CO-H&S-T-203	Blank Form for H&S COSHH assessments	268	0	1499
87	CO-PRD1-PTL-099	Oak House MSC1800 Production Enclosure Asset 1168 Validation Protocol	300	0	1330
88	CO-SUP-JA-038	Transfer Order	785	0	1326
89	CO-SUP-SOP-062	Add Team Member to a Task	192	0	213
90	CO-SUP-SOP-324	Packaging and Shipping Procedure for binx Cartridge Reagent	240	0	1246
91	CO-DPT-IFU-015	At-Home Male Triple Site Collection Kit IFU (Spanish Print Version)	493	0	1014
92	CO-QA-SOP-283	Product Risk Management Procedure	742	0	1108
93	CO-CS-POL-012	Policy for Customer Feedback	593	0	578
94	CO-LAB-FRM-103	CT/NG: NG1/IC Detection Reagent	663	0	693
95	CO-DPT-IFU-020	At-Home Urine Collection Kit IFU (English Digital Version)	129	0	1019
96	CO-IT-POL-023	Asset Management Policy	887	0	1181
97	CO-QA-T-045	Additional Training Form	274	0	357
98	CO-QC-PTL-067	CTNG NG/IC Primer passivation Validation	22	0	1079
99	CO-LAB-SOP-241	Ordering of New Reagents and Chemicals	371	0	870
100	CO-PRD1-SOP-276	Label printing	404	0	1096
560	CO-LAB-REG-018	Enviromental Monitoring Results Register	299	0	837
101	CO-QC-JA-011	Use of CO-QC-T-118: Detection Reagent Analysis Spreadsheet	323	0	1117
102	CO-PRD1-FRM-256	NG2 reverse primer Oak House Production IQC	385	0	1372
103	CO-CS-SOP-275	Installation and Training - binx io	707	0	1081
104	CO-LAB-FRM-074	CT synthetic target containing Uracil Part no: 0168	48	0	664
105	CO-LAB-FRM-053	‘TRIS (TRIZMA®) HYDROCHLORIDE’ Part Number: 0011	460	0	642
106	CO-SUP-SOP-322	Supply Team Oak House Operations	264	0	1244
107	CO-PRD1-FRM-201	Manufacture of NG1/NG2/IC Primer Passivation Reagent	223	0	1171
108	CO-PRD1-FRM-190	Shipment note	191	0	995
109	CO-SUP-SOP-046	Create New Customer Return	484	0	164
110	CO-FIN-T-134	UK Trade Credit Application	652	0	446
111	CO-DPT-IFU-017	At-Home Male Triple Site Collection Kit IFU (Spanish Digital Version)	566	0	1016
112	CO-OPS-PTL-027	Rapid PCR Rig IQ Protocol	592	0	807
113	CO-PRD1-FRM-238	Trizma hydrochloride Oak House Production IQC	1002	0	1354
114	CO-PRD1-FRM-245	DL-dithiothreitol (DTT) Oak House Production IQC	171	0	1361
115	CO-DES-SOP-029	Design and Development Procedure	25	0	14
116	CO-SAM-JA-049	Use of Acronyms in Marketing Materials	1057	0	1403
117	CO-QC-T-144	QC io Mainternance Log	520	0	458
118	CO-PRD1-FRM-239	Magnesium chloride Oak House Production IQC	934	0	1355
119	CO-QA-T-142	Document and Record Disposition Form	180	0	456
120	CO-OPS-SOP-120	CTNG Storage Buffer (224.3mM Potassium Phosphate	335	0	285
121	CO-SD-FRM-171	Code Review	860	0	891
122	CO-QA-T-010	Policy Template	420	0	295
123	CO-SUP-T-185	binx Packing List (Misc shipments)	259	0	1418
124	CO-QC-T-029	Incubator Monitoring Form	854	0	314
125	CO-QA-JA-002	Legacy Document Number Crosswalk	819	0	854
126	CO-LAB-FRM-019	Synthetic Uracil containing Amplicon	688	0	323
127	CO-IT-POL-032	Risk Management	775	0	1190
128	CO-QC-PTL-074	CT/NG Cartridge QC Test Analysis Template Validation Protocol	113	0	1087
129	CO-DES-T-058	Project Planning Template	63	0	370
130	CO-QC-PTL-073	QC Release of CT/NG Cartridge	354	0	1086
131	CO-PRD1-PTL-078	Oak House Jenway 3510 pH Meter Asset 1143 Validation Protocol	662	0	1198
132	CO-DPT-IFU-016	At-Home Male Triple Site Collection Kit IFU (English Digital Version)	954	0	1015
133	CO-DPT-BOM-025	2.601.908 (CG Female AG) Kit BOM	367	0	1454
134	CO-QA-T-011	Form Template	437	0	296
135	CO-SUP-SOP-050	Raise PO - Stock Items	933	0	180
136	CO-PRD1-FRM-205	Equipment Maintenance and Calibration Form	528	0	1221
137	CO-LAB-SOP-095	Instrument Cleaning Procedure	262	0	538
138	CO-QC-QCP-061	Electrode Electrochemical Functionality QC Assessment	938	0	1145
139	CO-OPS-URS-002	URS for Temperature Monitoring System	266	0	917
140	CO-QC-T-028	Balance Calibration form	1025	0	313
141	CO-PRD1-FRM-251	IC  forward primer Oak House Production IQC	782	0	1367
142	CO-QA-JA-015	QT9 Nonconforming Product Job Aid	904	0	1159
143	CO-OPS-T-152	Manufacturing Procedure (MFG) Template	1015	0	849
144	CO-SUP-SOP-054	Complete Production Order	39	0	184
145	CO-LAB-FRM-010	2mL ENAT Transport media	651	0	256
146	CO-DES-T-140	Reagent Design Transfer Checklist	134	0	454
147	CO-OPS-T-021	Generic PSP Ranking Criteria (template)	277	0	306
148	CO-PRD1-URS-026	User Requirement Specification for a Wireless Temperature and Humidity Monitoring System for Oak House Production and Storage Facility	745	0	1267
149	CO-PRD1-LBL-033	Intermediate reagent labels	629	0	1199
150	CO-QA-REG-032	Master List of Applicable Standards Form Template	832	0	1071
151	CO-LAB-SOP-169	Use of Fermant Pouch Sealer	179	0	604
152	CO-PRD1-FRM-212	ME2002T/00 and ML104T/00 Balance Weight Verification Form	514	0	1174
153	CO-OPS-SOP-192	Verification Testing Process SOP	776	0	638
154	CO-H&S-RA-017	Health and Safety Oak House Fire Risk Assessment	239	0	1541
155	CO-PRD1-FRM-243	y-Aminobutyric acid (GABA) Oak House Production IQC	8	0	1359
156	CO-SUP-JA-064	Softbox TempCell PRO shipper packing instructions	389	0	1556
157	CO-DPT-BOM-029	2.801.002 (ADX Blood Card (2)	74	0	1458
158	CO-QA-SOP-028	Quality Records	872	0	470
159	CO-PRD1-FRM-252	IC reverse primer Oak House Production IQC	396	0	1368
160	CO-SUP-SOP-058	Inspection Plans	907	0	209
161	CO-LAB-SOP-287	Introduction of New microorganisms SOP	1007	0	1120
162	CO-QC-JA-019	A Guide for QC Document Filing	671	0	1178
163	CO-QC-PTL-066	CTNG CT/IC Primer passivation	977	0	1078
164	CO-LAB-FRM-012	Microbank Cryovials	260	0	258
165	CO-QA-POL-006	Policy for Document Control and Change Management	719	0	563
166	CO-SUP-SOP-025	Quality Control	1034	0	85
167	CO-LAB-FRM-015	Part No 0181 ROSS fill solution pH Electrode	794	0	261
168	CO-QA-POL-021	Quality Manual	550	0	1113
169	CO-CS-T-135	Equipment Return Order	54	0	447
170	CO-LAB-SOP-078	Preparation of Bacterial Stocks (Master & Working)	89	0	502
171	CO-LAB-FRM-024	GelRed Nucleic Acid Stain Atlas Part Number 0328	117	0	328
172	CO-LAB-FRM-088	Incoming Quality Control and Specification for ‘IC Forward Primer’ from SGS DNA: Part number 0262 and 0419	930	0	678
173	CO-QC-QCP-057	CTNG CTIC NG1IC and NG2IC Detection Reagents QC test	345	0	1141
174	CO-QA-JA-021	QT9 SCAR Module Job Aid	811	0	1224
175	CO-LAB-SOP-148	Reagent Aliquotting	483	0	580
176	CO-QA-T-049	Document Acceptance Form	981	0	361
177	CO-OPS-SOP-111	50U/uL T7 Exonuclease in CTNG Storage Buffer	579	0	346
178	CO-DPT-VID-007	Anal Swab Sample Collection Video Transcript	163	0	1046
179	CO-OPS-SOP-125	IC DNA in TE Buffer 100pg/ul Working Stock Aliquots	250	0	278
180	CO-PRD1-SOP-304	Management of Critical and Controlled Equipment at Oak House Production Facility	587	0	1162
181	CO-IT-POL-027	Human Resource Security Policy	100	0	1185
182	CO-LAB-SOP-184	Pilot Line Blister Filling and Sealing Standard Operating Procedure	523	0	619
183	CO-LAB-REG-015	Stock Item Register	637	0	832
184	CO-H&S-PRO-002	Chemical and Biological COSHH Guidance	372	0	1526
185	CO-LAB-PTL-046	OQ protocol for binder incubator and humidity chamber	741	0	847
186	CO-DES-T-041	binx Technical Report Template	182	0	353
187	CO-OPS-SOP-166	Pneumatics Test Rig Set up and Calibration	348	0	601
188	CO-DPT-IFU-008	At-Home Vaginal Swab Collection Kit IFU (Spanish Digital Print)	730	0	1007
189	CO-QA-SOP-015	Qualification and Competence of Auditors	242	0	151
190	CO-LAB-SOP-178	Operating Instructions for Signal Analyser	576	0	613
191	CO-LAB-SOP-177	Operating instruction for the QuantStudio 3D digital PCR system	500	0	612
192	CO-QA-T-087	Standard / Guidance Review	731	0	399
193	CO-LAB-SOP-103	Environmental Controls in the Laboratory	395	0	544
194	CO-QA-JA-001	A Basic Guide to Finding Documents in SharePoint	387	0	535
195	CO-DES-PTL-004	Monmouth 1200	332	0	461
196	CO-QC-QCP-069	CT/NG: IC DNA Reagent qPCR Test	301	0	1153
197	CO-LAB-FRM-004	TRIS (TRIZMA) Base	691	0	250
198	CO-DPT-IFU-042	At-Home Blood Spot Collection Kit USPS IFU (English Digital Version)	133	0	1049
199	CO-DES-SOP-004	Software Development Procedure	778	0	16
200	CO-SUP-SOP-061	New Project Set-Up	172	0	212
201	CO-QA-SOP-007	Correction Removal and Recall Procedure	135	0	74
202	CO-OPS-SOP-032	Validation of Automated Equipment and Quality System Software	1040	0	474
203	CO-PRD1-PTL-102	Oak House APC Schneider UPS Asset  1116 Validation Protocol	318	0	1390
204	CO-QA-SOP-140	Document Control Procedure (Projects)	57	0	65
205	CO-PRD1-FRM-211	pH Meter Calibration form - 3 point	451	0	1210
206	CO-SUP-SOP-038	Change of Stock (QC Release)	249	0	156
207	CO-LAB-FRM-120	Metronidazole resistant Trichomonas Vaginalis Cultured Stocks Part no. 0312	406	0	710
208	CO-LAB-REG-008	Manufacturing Lot Number Register	617	0	558
209	CO-CS-SOP-249	io Insepction using Data Collection Cartridge	594	0	938
210	CO-PRD1-JA-070	Protecting Light Sensitive Reagents with Tin Foil at the Oak House Manufacturing Facility	886	0	1564
211	CO-PRD1-SOP-369	Manufacturing Overview for IC DNA Reagent	181	0	1562
212	CO-DPT-WEB-005	Non-COVID Consent	64	0	1061
213	CO-LAB-FRM-068	1M Magnesium Chloride solution molecular biology grade Part No. 0115	273	0	658
214	CO-SUP-SOP-075	Order to Cash	666	0	492
215	CO-OPS-SOP-206	Manufacture of 1.5 M Trehalose	340	0	771
216	CO-QC-T-016	Lab Cleaning Form	804	0	301
217	CO-SUP-SOP-060	Customer Returns	238	0	211
218	CO-SUP-SOP-053	Raise & Release Production Order	772	0	183
219	CO-LAB-FRM-141	Part No. 0345 CampyGen  sachets	194	0	731
220	CO-SUP-SOP-041	Customer Sales Contracts	753	0	159
221	CO-H&S-PRO-003	Manual Lifting Procedure	141	0	1527
222	CO-QC-FRM-046	Micro Monthly Laboratory Checklist-Rev_0	430	0	836
223	CO-OPS-URS-008	Sprint B+ leak tester- User Requirement Specification	1060	0	930
224	CO-LAB-LBL-011	Solutions labels	839	0	890
225	CO-LAB-FRM-139	‘Tris (1M) pH8.0’ Part no: 0342	843	0	729
226	CO-OPS-PTL-010	Reader Installation Qualification Protocol	20	0	588
227	CO-QC-T-128	LAB investigation summary report	397	0	440
228	CO-QC-T-102	CTNG Cartridge Cof A	863	0	414
229	CO-PRD1-SOP-319	Jenway 3510 model pH Meter with ATC probe and 924 30 6.0mm model Tris electrode SOP in Oak House	1030	0	1223
230	CO-SUP-FRM-195	Purchase Order Request	193	0	1068
231	CO-LAB-FRM-091	Part No 0265 ‘NG Target 1 RA Reverse Primer’ from SGS DNA	485	0	681
232	CO-PRD1-FRM-247	IC di275 probe Oak House Production IQC	727	0	1363
233	CO-PRD1-LBL-042	CT IC Primer Passivation Reagent Box Label	44	0	1257
234	CO-DPT-IFU-033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping (English Version)	442	0	1031
235	CO-DPT-BOM-020	2.601.006 (CG3 + Blood Male AG) Kit BOM	1021	0	1449
236	CO-SUP-SOP-070	Supplier Risk Assessment Approval and Monitoring Procedure	814	0	488
237	CO-QC-SOP-154	QC Laboratory Cleaning Procedure	580	0	586
238	CO-SUP-SOP-037	Complete QC Inspections	370	0	155
239	CO-LAB-SOP-180	Reconstitution of Lyophilised Materials	338	0	615
240	CO-LAB-LBL-009	Quarantine - Failed calibration Label	1033	0	888
241	CO-OPS-SOP-083	Preparation of Trichomonas vaginalis 1 million Genome Equivalents/µL stocks	402	0	507
242	CO-PRD1-PTL-100	Oak House Roto-Therm H2024-E Hybridisation Oven Asset 1113 Validation Protocol	72	0	1332
243	CO-LAB-LBL-004	For Indication Only Label	619	0	883
244	CO-QA-T-206	EU Performance Evaluation Plan Template	984	0	1569
245	CO-CS-FRM-275	binx io RMA Number Request Form	417	0	1537
246	CO-SUP-FRM-046	Supplier Questionnaire - Calibration/Equipment maintenance	494	0	364
247	CO-DPT-VID-005	Urine Sample Collection Video Transcript	983	0	1041
248	CO-DES-PTL-002	Validation of Abacus Guardian	945	0	453
249	CO-LAB-FRM-063	‘MES’ Part No. 0095	1051	0	652
250	CO-LAB-PTL-186	Verification Testing Protocol for Female Urine Database	642	0	1423
251	CO-QA-SOP-077	Supplier Audit Procedure	694	0	500
252	CO-SUP-JA-041	Oak House Check Task Confirmation	86	0	1329
253	CO-DPT-BOM-016	2.600.909 (HIV USPS Blood Card) Kit BOM	626	0	1445
254	CO-LAB-SOP-170	Rapid PCR Rig Work Instructions	253	0	605
255	CO-OPS-SOP-118	Manufacture of CT/IC Primer Passivation Reagent	976	0	280
256	CO-LAB-FRM-002	Glycerol (For molecular biology)	177	0	248
257	CO-DPT-BOM-022	2.601.902 (CG + Blood Female AG) Kit BOM	501	0	1451
258	CO-QC-SOP-185	Use of the SB3 Rotator	351	0	620
259	CO-PRD1-FRM-242	dUTP mix Oak House Production IQC	808	0	1358
260	CO-LAB-LBL-054	GRN for R&D and Samples Label (Silver)	190	0	1584
261	CO-QC-JA-004	Use of CO-QC-T-155: CTNG QC Cartridge Analysis Module	432	0	916
262	CO-PRD1-PTL-088	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1171 Validation Protocol	845	0	1236
263	CO-OPS-SOP-186	Use of the VPUMP Vacuum pump	554	0	621
264	CO-OPS-PTL-009	Heated Detection Rig OQ Procedure	669	0	536
265	CO-QC-T-115	Incoming Oligo QC Form	881	0	427
266	CO-QC-QCP-064	CT/NG: NG1/IC Detection Reagent	826	0	1148
267	CO-OPS-URS-018	Reagent Handling Processor for Scienion Dispense Equipment	797	0	948
268	CO-OPS-PTL-023	io Reader - Digital Pressure Regulator Calibration Protocol	80	0	803
269	CO-QC-COP-002	CL2 Microbiology Laboratory Code of Practice	426	0	852
270	CO-H&S-COSHH-010	COSHH assessment - clinical samples	344	0	1509
271	CO-QC-SOP-171	Quality Control Rounding Procedure	312	0	606
272	CO-PRD1-JA-009	Intruder Alarm	521	0	1067
273	CO-LAB-FRM-123	Part No. 0318  NATtrol Chlamydia trachomatis Positive Control	99	0	713
274	CO-LAB-FRM-060	Part no. 0089 70% ethanol	1069	0	649
276	CO-OPS-SOP-165	Windows Software Update	701	0	600
277	CO-SUP-JA-055	Use of Elpro data loggers	763	0	1419
278	CO-PRD1-FRM-263	Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Slip Oak House IQC	517	0	1382
279	CO-SAM-T-101	Marketing template	488	0	413
280	CO-SUP-SOP-042	Enter & Release Sales Orders	341	0	160
281	CO-LAB-SOP-010	Reagent Deposition and Immobilisation (Pilot Line)	987	0	272
282	CO-LAB-LBL-010	Failed Testing - Not in use Label	91	0	889
283	CO-H&S-RA-013	Risk Assessment - Fire - Derby Court and Unit 6	97	0	1536
284	CO-QA-POL-014	Policy for the Control of Non-Conforming Product and Corrective/Preventive Action	61	0	859
285	CO-PRD1-LBL-038	NG1 NG2 IC Primer Passivation Reagent Vial Label	441	0	1253
286	CO-DES-PTL-007	Pilot Line Process & Equipment Validation	248	0	464
287	CO-LAB-LBL-053	SAP Stock Item Label (Green)	774	0	1583
288	CO-LAB-SOP-153	Use of UV Cabinets	578	0	585
289	CO-PRD1-FRM-260	pH Buffer Bottle 4.01 Twin-neck Oak House Production IQC	19	0	1379
290	CO-PRD1-SOP-254	Use & Cleaning of the Monmouth Scientific Model Guardian 1800 Production Enclosure in Oak House	204	0	959
291	CO-LAB-SOP-020	Use of the Hulme Martin Pmpulse heat Sealer	1011	0	336
292	CO-OPS-URS-012	User Requirement Specification for a Production Enclosure	973	0	936
293	CO-SUP-FRM-043	Initial Risk Assessment and Supplier Approval	849	0	397
294	CO-H&S-COSHH-002	COSHH Assessment - Oxidising Agents	859	0	1501
295	CO-OPS-SOP-121	CTNG T7 Diluent Rev 3.0 (NZ source BSA)	705	0	344
296	CO-PRD1-SOP-255	Mini Fuge Plus centrifuge SOP	284	0	961
297	CO-LAB-SOP-136	Solution Preparation SOP	510	0	559
298	CO-DES-T-124	Design Transfer Form	602	0	436
299	CO-QA-SOP-012	Annual Quality Objectives	966	0	148
300	CO-DPT-BOM-030	5.900.444 (Blood Collection Drop-in Pack) Kit BOM	481	0	1459
301	CO-CS-FRM-175	io Inspection using Data Collection Cartridge Form	1076	0	939
302	CO-PRD1-FRM-257	Pectobacterium atrosepticum (IC) DNA buffer Oak House Production IQC	70	0	1373
303	CO-QC-LBL-032	Excess Raw Material Label	558	0	1116
304	CO-DPT-BOM-009	2.600.902 (CG + Blood Female) Kit BOM	307	0	1438
305	CO-LAB-FRM-021	NG1  di452 Probe from SGS	11	0	325
306	CO-SUP-FRM-214	CT IC Detection Reagent Component pick list form	758	0	1305
307	CO-LAB-SOP-145	Handling Biological Materials	989	0	570
308	CO-QC-PTL-077	Process Validation of CO-QC-QCP-069 and CO-QC-QCP-052. IC DNA Reagent and Raw Material Testing	221	0	1193
309	CO-OPS-URS-028	Keyence LM Series - User Requirements Specification	621	0	1375
310	CO-DES-T-005	Phase Review Record	207	0	290
311	CO-OPS-PTL-021	Validation Protocol for Rotorgene	202	0	801
312	CO-LAB-FRM-078	Part no. 0222 CO2 Gen sachets	511	0	668
313	CO-DPT-BOM-019	2.601.005 (Blood Unisex AG) Kit BOM	167	0	1448
314	CO-LAB-SOP-179	Cleaning Procedure for Microbiology Lab	208	0	614
315	CO-PRD1-FRM-235	Trehalose dihydrate Oak House Production IQC	254	0	1351
316	CO-LAB-FRM-126	50bp DNA Ladder binx Part Number 0329	769	0	716
317	CO-DPT-VID-003	Oral Swab Sample Collection Video Transcript	668	0	1039
318	CO-PRD1-LBL-049	Quarantined ERP GRN material label-Rev_0	940	0	1384
319	CO-LAB-FRM-052	SODIUM CHLORIDE Part Number 0008	292	0	641
320	CO-DES-T-061	Verification Testing Report template	759	0	373
321	CO-DPT-IFU-012	At-Home Female Triple Site Collection Kit IFU (Spanish Digital Version)	823	0	1011
322	CO-LAB-FRM-096	‘25U/µL Taq-B DNA Polymerase (Low Glycerol)’ Part Number 0270	436	0	686
323	CO-PRD1-PTL-075	Oak House Environmental Control System Validation Protocol	951	0	1097
324	CO-LAB-URS-001	Binder incubator and humidity chamber User Requirement Specification	655	0	850
325	CO-PRD1-FRM-187	Certificate of Conformance - NG2 IC detection reagent	743	0	991
326	CO-QA-SOP-099	Deviation Procedure	379	0	541
327	CO-SUP-SOP-063	Book Time Against A Project	18	0	214
328	CO-PRD1-T-200	Manufacturing Batch Record (MBR) Template - DEV#28	471	0	1487
329	CO-DPT-IFU-006	At-Home Vaginal Swab Collection Kit IFU (Spanish Print Version)	415	0	1005
330	CO-LAB-SOP-155	Experimental Write Up	573	0	590
331	CO-PRD1-REG-036	Oak House Pipette Register	551	0	1197
332	CO-LAB-FRM-071	Potassium Phosphate Dibasic’ Part No.0147	469	0	661
333	CO-PRD1-PTL-091	Oak House Labcold RLDF1519 Fridge 1157 Validation Protocol	770	0	1279
334	CO-SUP-URS-017	User Requirement Specification for ByD for binx Reagent Manufacturing Facility	473	0	946
335	CO-FIN-T-167	US Trade Credit Application	71	0	1095
336	CO-QA-REG-007	Bacterial Stock Register	37	0	501
337	CO-LAB-FRM-041	Incoming Quality Control and Specification for ‘NG1 Plasmid in TE buffer’ Materials binx Part Number: 0346	374	0	631
338	CO-LAB-SOP-150	Standard Use of Freezers	225	0	582
339	CO-LAB-SOP-080	Use of Agilent Bioanalyzer DNA 1000 kits	456	0	504
340	CO-H&S-RA-003	Risk Assessment - Laboratory Areas (excluding Microbiology and Pilot line)	384	0	1515
341	CO-DPT-IFU-007	At-Home Vaginal Swab Collection Kit IFU (English Digital Version)	504	0	1006
342	CO-H&S-COSHH-007	COSHH assessment  - General Hazard Group 2 organisms	78	0	1506
343	CO-DPT-T-168	Digital Feature Template	445	0	1099
344	CO-OPS-URS-011	User Requirement Specification for back up power supply	6	0	935
345	CO-H&S-RA-004	Risk Assessment - io® reader / assay development tools	791	0	1516
346	CO-PRD1-LBL-039	CT NG Taq UNG Reagent Vial Label	390	0	1254
347	CO-OPS-URS-007	TQC leak tester- User Requirement Specification	361	0	929
348	CO-QA-T-153	Job Aid Template	93	0	853
349	CO-DPT-BOM-008	2.600.008 (CG Male) Kit BOM	927	0	1437
350	CO-PRD1-SOP-264	Eupry temperature monitoring system	1039	0	980
351	CO-DES-PTL-008	Calibration of V&V Laboratory Timers	931	0	465
352	CO-LAB-LBL-006	Part No GRN Label	137	0	885
353	CO-SUP-FRM-178	GRN Form for incoming goods	1081	0	965
354	CO-LAB-SOP-156	Control of Controlled Laboratory Notes	228	0	591
355	CO-QA-SOP-356	EU Regulatory Strategy and Process	359	0	1463
356	CO-OPS-T-111	Generic Cartridge Subassembly Build	234	0	423
357	CO-QC-PTL-070	Manufacture of CTNG Cartridge Reagents	786	0	1083
358	CO-SUP-SOP-006	Equipment Fulfilment and Field Visit SOP for non-stock instruments	429	0	22
359	CO-PRD1-LBL-044	NG2 IC Detection Reagent Box Label	538	0	1259
360	CO-DPT-BOM-027	2.800.002 (ADX Blood Card (2) Fasting) Kit BOM	562	0	1456
361	CO-DPT-WEB-006	COVID Consent (Spanish)	611	0	1088
362	CO-LAB-SOP-160	Use of the Miele Laboratory Glassware Washer G7804	993	0	595
363	CO-DPT-WEB-007	Privacy Policy (UTI	545	0	1089
364	CO-DPT-IFU-021	At-Home Urine Collection Kit IFU (Spanish Digital Version)	571	0	1020
365	CO-LAB-SOP-003	Validation of Temperature Controlled Equipment	118	0	265
366	CO-PRD1-SOP-259	Standard Use of Oak House Fridges	618	0	967
367	CO-SUP-SOP-363	Shipping Specifications Procedure	241	0	1489
368	CO-LAB-FRM-011	Part no. 0141 Albumin from Bovine serum	1075	0	257
369	CO-QA-REG-024	Archived Document Retrieval Log	81	0	844
370	CO-OPS-SOP-124	Glycerol Solution	1023	0	277
371	CO-PRD1-FRM-199	Manufacture of CT/IC Detection Reagent	737	0	1169
372	CO-QC-T-009	Template for IQC	963	0	294
373	CO-QA-POL-019	Quality Policy	563	0	1111
374	CO-LAB-SOP-014	Thermo Orion Star pH meter	139	0	330
375	CO-PRD1-FRM-262	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQC	586	0	1381
376	CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	331	0	498
377	CO-IT-POL-031	Responsible Disclosure Policy	748	0	1189
378	CO-LAB-SOP-015	Use of the ALC PK121 centrifuges (refrigerated and non-refrigerated)	423	0	331
379	CO-PRD1-FRM-231	0.5M EDTA Oak House Production IQC	703	0	1347
380	CO-PRD1-FRM-234	Potassium phosphate monobasic Oak House Production IQC	899	0	1350
381	CO-PRD1-FRM-241	T7 exonuclease Oak House Production IQC	830	0	1357
382	CO-DPT-IFU-028	binx Nasal Swab For Individual Setting (English Print Version)	1082	0	1027
383	CO-DPT-IFU-026	It s as Easy as 123 (Ft. the ADx Card Collection Method)	912	0	1025
384	CO-LAB-SOP-013	Balance calibration	890	0	329
385	CO-PRD1-FRM-254	NG1 Reverse primer Oak House Production IQC	876	0	1370
386	CO-QC-PTL-065	Taq-B raw material and CT/NG Taq UNG Reagent Validation	446	0	1077
387	CO-QC-T-073	Microbiology Laboratory Cleaning record	527	0	385
388	CO-DPT-IFU-025	Blood Card Collection Kit IFU (Using the ADx Card)	124	0	1024
389	CO-DES-T-126	Soup Approval	145	0	438
390	CO-SUP-T-171	Oak House Commercial Invoice - Cartridge Reagent (-20°c)	448	0	1274
391	CO-QA-SOP-026	Use of Sharepoint	723	0	469
392	CO-PRD1-SOP-252	Use of Benchmark Roto-Therm Plus Hybridisation oven	783	0	952
393	CO-LAB-FRM-090	Part No 0264 ‘NG Target 1 Forward Primer’ from SGS DNA	861	0	680
394	CO-QA-POL-013	Policy for Complaints and Vigilance	665	0	579
395	CO-SUP-SOP-072	Instructions for receipt of incoming Non-Stock goods  assigning GRN numbers and labelling	425	0	489
396	CO-LAB-LBL-008	Pipette Calibration Label	1056	0	887
397	CO-DPT-IFU-019	At-Home Urine Collection Kit IFU (Spanish Print Version)	127	0	1018
398	CO-PRD1-LBL-034	CT IC Detection Reagent Vial Label	45	0	1249
399	CO-OPS-SOP-142	CTNG T7 Diluent	693	0	566
400	CO-QC-QCP-058	Material Electrochemical Signal Interference - Electrochemical detection assessment	623	0	1142
401	CO-QA-REG-033	Auditor register	245	0	1075
402	CO-QC-JA-012	Job Aid: A Guide to QC Cartridge Inspections	232	0	1118
403	CO-DPT-VID-004	Dry Blood Spot Card Video Transcript	847	0	1040
404	CO-OPS-SOP-117	Manufacture of IC DNA Reagent’	477	0	279
405	CO-PRD1-FRM-259	pH Buffer Bottle 7.00 Twin-neck Oak House Production IQC	271	0	1378
406	CO-PRD1-FRM-184	Certificate of conformance - CT IC primer passivation reagent	112	0	988
407	CO-H&S-RA-007	Risk Assessment - Pilot line Laboratory area	505	0	1519
408	CO-QC-QCP-055	CT Plasmid Quantification - qPCR Test (Part No. 0348)	222	0	1139
409	CO-PRD1-FRM-204	Calibrated Clock/Timer verification form	555	0	1209
410	CO-SUP-SOP-277	Instructions for Receipt of incoming Stock goods assigning GRN No.s & Labelling	680	0	1100
411	CO-LAB-LBL-025	Equipment Not Maintained Do Not Use Label	376	0	905
413	CO-OPS-PTL-038	Blister Filling Rig and Cropping Press PQ Validation Protocol	27	0	817
414	CO-DES-T-036	Experimental template: Planning	653	0	321
415	CO-SUP-SOP-320	Oak House Supply Chain Reagent Production Process Flow	216	0	1227
416	CO-LAB-SOP-138	Use of Temperature and Humidity Loggers	1022	0	561
417	CO-CS-JA-050	Job Aid _Field Service-Instrument cleaning	506	0	1405
418	CO-QA-T-192	Post Market Surveillance Plan Template	686	0	1469
419	CO-PRD1-PTL-105	Oak House APC Schneider UPS Asset  1176 Validation Protocol	226	0	1393
420	CO-OPS-SOP-113	9.26pc (w.v) BSA in 208.3 mM Potassium Phosphate buffer	664	0	284
421	CO-SUP-SOP-074	UK Stock Procurement & Movements (Supply Chain)	403	0	491
422	CO-PRD1-LBL-043	NG1 IC Detection Reagent Box Label	994	0	1258
423	CO-DPT-IFU-039	binx health (powered by P23) At-home Saliva COVID-19 Test Collection Kit for Group Settings (English Version)	658	0	1044
424	CO-LAB-FRM-278	Asset Not Temperature Controlled Sign	916	0	1546
425	CO-PRD1-FRM-188	Certificate of Conformance - NG1 NG2 IC primer passivation reagent	421	0	992
426	CO-OPS-PTL-020	Validation Protocol Temperature controlled storage/incubation	687	0	800
427	CO-QA-T-008	Change Management Form	964	0	293
428	CO-QC-QCP-054	NG1 Plasmid Quantification - qPCR Test (Part No. 0346)	787	0	1138
429	CO-OPS-URS-015	User requirement specification for a cooled incubator	347	0	942
430	CO-H&S-RA-018	Health and Safety Risk Assessment Oak House Covid-19	882	0	1542
431	CO-OPS-SOP-104	CT_IC Detection Reagent	90	0	545
432	CO-SUP-JA-062	AirSea 2-8°c Shipper Packing Instructions	337	0	1554
433	CO-H&S-COSHH-006	COSH-Assessment - Corrosive Acids	315	0	1505
434	CO-LAB-LBL-022	Quarantine Stock Item Label	777	0	902
435	CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	168	0	574
436	CO-LAB-SOP-135	Guidance for Use and Completion of MFG Documents	986	0	557
437	CO-LAB-SOP-079	Use and Cleaning of Class II Microbiology Safety Cabinet	309	0	503
438	CO-LAB-SOP-149	Introducing New Laboratory Equipment	628	0	581
439	CO-LAB-SOP-082	Use of the Rotary Vane Anemometer	103	0	506
440	CO-PRD1-SOP-310	The use of Calibrated Clocks/Timers	676	0	1208
441	CO-QA-JA-014	QT9 Corrective Action Module Job Aid	1074	0	1158
442	CO-LAB-SOP-159	Use of Rotor-Gene Q	798	0	594
443	CO-H&S-COSHH-012	COSHH Assessment - Inactivated Micro-organisms	310	0	1510
444	CO-LAB-REG-012	Part No Register	491	0	829
445	CO-SUP-T-100	Purchase order terms & conditions	106	0	412
446	CO-H&S-P-003	Health and Safety Stress Management Policy	258	0	1534
447	CO-OPS-REG-026	Instrument Register	766	0	851
448	CO-DPT-IFU-035	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location (English Version)	401	0	1032
449	CO-OPS-SOP-202	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility (for FDA 510(k))	925	0	767
450	CO-PRD1-REG-035	Oak House Equipment Service and Calibration Register	818	0	1196
451	CO-OPS-LBL-028	UN3316 cartridge label - use Avery J8173 labels to print	42	0	908
452	CO-QA-SOP-147	Managing an External Regulatory Visit from the FDA	862	0	572
453	CO-H&S-PRO-006	Health and Safety Legislation Review Procedure	714	0	1530
454	CO-PRD1-SOP-305	Use of ME2002T/00 and ML104T/00 balances in the Oak House Production Facility	75	0	1164
455	CO-LAB-LBL-015	Consumables Label	324	0	895
456	CO-OPS-SOP-090	MFG for preparing male and female urine with 10% eNAT	160	0	514
458	CO-SUP-FRM-218	NG1 NG2 IC Primer Passivation Reagent Component Pick List Form	853	0	1309
459	CO-QA-SOP-043	Training Procedure	306	0	485
460	CO-OPS-PTL-022	Validation Protocol - V&V Laboratory Facilities	889	0	802
461	CO-QA-REG-022	Vigilance Register	158	0	841
462	CO-DPT-WEB-009	South Dakota Waiver Consent and Release of Information (Spanish)	614	0	1091
463	CO-PRD1-FRM-248	NG1 di452 probe Oak House Production IQC	957	0	1364
464	CO-SUP-JA-040	Oak House Make Task Confirmation	681	0	1328
465	CO-OPS-PTL-026	io® Reader – Thermal End Test Protocol	247	0	806
466	CO-DES-T-040	binx Report Template	752	0	352
467	CO-PRD1-PTL-092	Oak House Labcold RLDF1519 Fridge 1159 Validation Protocol	793	0	1280
468	CO-LAB-T-159	Autoclave Biological Indicator Check Form	105	0	957
469	CO-LAB-FRM-069	Part No. 0118 IC Synthetic target HPLC GRADE	102	0	659
470	CO-QC-T-105	T7 QC Testing Data Analysis	452	0	417
471	CO-PRD1-PTL-103	Oak House APC Schneider UPS Asset  1117 Validation Protocol	635	0	1391
472	CO-LAB-SOP-199	Manufacture of CT/NG Negative Control Samples	708	0	764
473	CO-QC-LBL-031	QC Retention Box Label	285	0	1115
474	CO-OPS-PTL-036	Validation Protocol: 21011-MET012 Thermal - PCR Cycle Results Template Master	418	0	815
475	CO-DPT-IFU-009	At-Home Female Triple Site Collection Kit IFU (English Print Version)	928	0	1008
476	CO-CS-JA-069	Customer Installation and Training Job Aid binx io	524	0	1561
477	CO-QA-SOP-011	Supplier Corrective Action Response Procedure	407	0	147
478	CO-SUP-T-183	Oak House Packing List - Cartridge Reagent (-20°c)	472	0	1416
479	CO-PRD1-T-165	Manufacturing Batch Record (MBR) Template	944	0	1062
480	CO-QC-QCP-065	CT/NG: CT/IC Detection Reagent Heated io detection rig	4	0	1149
481	CO-PRD1-SOP-265	Oak House Emergency Procedures	236	0	981
482	CO-OPS-PTL-017	Validation Protocol: Thermal cycler IQ/OQ/PQ	660	0	797
483	CO-OPS-SOP-086	Preparation of Chlamydia trachomatis 100 thousand Genome Equivalents/µL stocks	692	0	510
484	CO-OPS-PTL-018	Validation Protocol – UV/Vis Nanodrop Spectrophotometer	674	0	798
485	CO-SUP-FRM-220	IC DNA Reagent Component Pick List Form	795	0	1311
486	CO-LAB-SOP-163	Running Cartridges on io Readers	747	0	598
487	CO-LAB-SOP-017	Use of the Jenway Spectrophotometer	169	0	333
488	CO-SUP-T-201	Shipping Specification Template	883	0	1488
489	CO-LAB-FRM-125	10x TBE electrophoresis buffer Part Number 0326	231	0	715
490	CO-QA-SOP-096	Analysis of Quality Data	609	0	539
491	CO-LAB-FRM-067	Sarcosine’ Part no: 0108	66	0	657
492	CO-SUP-JA-024	Consumption on Cost Center	690	0	1312
493	CO-LAB-FRM-086	‘0260 CT Forward Primer from SGS DNA’	53	0	676
494	CO-QC-T-121	Impulse Sealer Use Log	31	0	433
495	CO-PRD1-SOP-318	The use of the calibrated temperature probe	654	0	1222
496	CO-DPT-IFU-010	At-Home Female Triple Site Collection Kit IFU (Spanish Print Version)	317	0	1009
497	CO-SUP-SOP-073	Standard Cost Roll Up	717	0	490
498	CO-QA-T-048	Specimen Signature Log	352	0	360
499	CO-SUP-SOP-001	Procedure for Commercial Storage and Distribution	1045	0	17
500	CO-H&S-COSHH-001	COSHH Assessment - General Chemicals	1065	0	1500
501	CO-LAB-PTL-045	IQ Protocol for Binder incubator and humidity chamber	792	0	846
502	CO-LAB-FRM-070	Part No. 0125 Potassium Phospate Monobasic	123	0	660
503	CO-FIN-T-027	IT Request for Information	155	0	312
504	CO-SUP-SOP-064	Create a PO Within a Project	435	0	215
505	CO-LAB-SOP-295	Environmental Contamination testing	909	0	1129
506	CO-QC-QCP-052	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test (Part 0248)	838	0	1122
507	CO-QA-T-158	User Requirement Specification (URS) template	864	0	949
508	CO-DPT-IFU-024	Blood Card Collection Kit IFU (Using the ADx Card)	857	0	1023
509	CO-QC-T-082	qPCR QC Testing Data Analysis	32	0	394
510	CO-PRD1-LBL-035	CT IC Primer Passivation Reagent Vial Label	950	0	1250
511	CO-SAM-SOP-009	Control of Marketing and Promotion	1048	0	245
512	CO-H&S-P-004	Coronavirus (COVID-19) Policy on employees being vaccinated	542	0	1535
513	CO-OPS-JA-020	Cartridge Defects Library	746	0	1195
514	CO-DES-PTL-003	Temperature controlled equipment	13	0	460
515	CO-LAB-FRM-207	Manipulated Material Aliquot form	1042	0	1226
516	CO-OPS-SOP-035	Engineering Drawing Control	781	0	477
517	CO-SUP-SOP-005	New Customer Procedure	620	0	21
518	CO-LAB-SOP-151	Management and Control of Critical and Controlled Equipment	82	0	583
519	CO-DPT-IFU-029	binx Nasal Swab For Group Setting (English Print Version)	675	0	1028
520	CO-LAB-FRM-206	Water/Eultion Buffer  aliquot form	227	0	1225
521	CO-PRD1-FRM-250	CT reverse primer Oak House Production IQC	219	0	1366
522	CO-LAB-FRM-102	‘CT/NG: TaqUNG Reagent	855	0	692
523	CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	833	0	73
524	CO-OPS-SOP-107	Manufacture of NG2/IC Detection Reagent	559	0	547
525	CO-QA-T-145	Certificate of Conformance	695	0	459
526	CO-PRD1-LBL-040	IC DNA Reagent Vial Label	656	0	1255
527	CO-PRD1-LBL-037	NG2 IC Detection Reagent Vial Label	342	0	1252
528	CO-QA-SOP-004	Internal Audit	303	0	71
529	CO-QA-T-038	binx Memorandum Template	497	0	350
530	CO-LAB-LBL-013	In process MFG material label	958	0	893
531	CO-PRD1-URS-021	User Requirement Specification for the binx Cartridge Reagent Manufacturing Lab UK	598	0	1161
532	CO-LAB-FRM-107	‘IC di275 Probe from SGS’ Part No. 0288	806	0	697
533	CO-H&S-T-202	Health and Safety Risk Assessment Template	165	0	1498
534	CO-LAB-SOP-019	Use of the LMS Programmable Incubator	891	0	335
535	CO-DPT-IFU-043	At-Home Blood Spot Collection Kit USPS IFU (Spanish Digital Version)	529	0	1050
536	CO-SUP-SOP-051	Receive Stock Purchase Orders	383	0	181
537	CO-LAB-SOP-004	Use of the Bolt Mini Gel Tank for protein Electrophoresis	985	0	266
538	CO-PRD1-FRM-228	UNG Oak House Production IQC	877	0	1344
539	CO-PRD1-FRM-246	CT di452 probe Oak House Production IQC	885	0	1362
540	CO-PRD1-SOP-268	Transfer of reagent QC samples	968	0	983
541	CO-PRD1-PTL-090	Oak House Haier DW-86L338J Freezer 1155 Validation Protocol	622	0	1278
542	CO-DPT-ART-008	Vaginal STI Sample Collection Sticker	911	0	1238
543	CO-QA-FRM-193	Auditor Qualification	561	0	1064
544	CO-PRD1-FRM-191	Reagent Shipping Worksheet	136	0	999
545	CO-H&S-RA-016	Health and Safety Risk Assessment Incoming-Outgoing goods and Packaging	678	0	1540
546	CO-LAB-FRM-009	D-(+)-Trehalose Dihydrate	458	0	255
547	CO-SUP-JA-061	AirSea Dry Ice Shipper Packing Instructions	263	0	1553
548	CO-PRD1-T-160	Oak House Production Facility Cleaning Record	35	0	973
549	CO-QA-T-079	Field Corrective Action File Review Form	198	0	391
550	CO-SUP-SOP-321	Incoming Goods Procedure for deliveries into Oak House Manufacturing Site	788	0	1233
551	CO-OPS-SOP-109	1 x lysis buffer	1052	0	339
552	CO-IT-POL-025	Code of Conduct	50	0	1183
553	CO-DPT-IFU-036	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad (English Version)	634	0	1033
554	CO-LAB-SOP-016	Use of the Peqlab thermal cyclers	41	0	332
555	CO-PRD1-LBL-030	Temperature only label	585	0	1055
556	CO-LAB-SOP-294	Standard Way of Making CT Dilutions	290	0	1128
557	CO-DPT-IFU-040	At-Home Blood Spot Collection Kit USPS IFU (English Print Version)	465	0	1047
558	CO-QA-SOP-139	Change Management Procedure for Product/Project Documents	512	0	562
559	CO-DPT-IFU-014	At-Home Male Triple Site Collection Kit IFU (English Print Version)	754	0	1013
561	CO-LAB-FRM-087	Part No 0261 ‘CT Reverse Mod Primer’ from SGS DNA	224	0	677
562	CO-LAB-SOP-181	Use of the Thermomixer HC block	821	0	616
563	CO-SUP-FRM-042	Supplier Questionnaire - Chemical/Reagent/Microbiological	647	0	365
564	CO-PRD1-FRM-200	Manufacture of CT/IC Primer Passivation Reagent	255	0	1170
565	CO-SUP-SOP-280	Setting Expiry Dates for Incoming Materials	440	0	1103
566	CO-PRD1-LBL-045	NG1 NG2 IC Primer Passivation Reagent Box Label	294	0	1260
567	CO-PRD1-POL-016	Reagent Production Policy	846	0	970
568	CO-CS-T-149	Instrument Trouble Shooting Script	672	0	444
569	CO-PRD1-FRM-225	Potassium phosphate dibasic Oak House Production IQC	381	0	1341
570	CO-SUP-SOP-065	Complete a Time Sheet	146	0	216
571	CO-QA-SOP-237	QT9 - Periodic Review and Making Documents Obsolete	738	0	855
572	CO-DPT-BOM-015	2.600.908 (CG Female) Kit BOM	320	0	1444
573	CO-PRD1-SOP-261	Cleaning Procedure for Oak House Production Facility	394	0	974
574	CO-DES-SOP-042	Creation and Maintenance of a Device Master Record (DMR)	143	0	484
575	CO-LAB-SOP-291	Preparation of 10X and 1X TAE Buffer	363	0	1125
576	CO-QA-T-042	binx Meeting Minutes Template	83	0	354
577	CO-DES-T-129	Customer Requirements Specification	905	0	441
578	CO-QA-T-110	Document Retrieval Request	413	0	422
579	CO-QA-T-193	Post Market Surveillance Report Template	815	0	1470
580	CO-PRD1-PTL-104	Oak House APC Schneider UPS Asset  1118 Validation Protocol	757	0	1392
581	CO-OPS-SOP-008	Thermal Test Rig Set Up and Calibration	380	0	270
582	CO-SUP-JA-032	Goods Movements	220	0	1320
583	CO-SUP-LBL-051	Shipping Contents Label	1043	0	1421
584	CO-OPS-PTL-011	Rapid PCR Rig OQ Procedure	5	0	626
585	CO-SUP-SOP-049	Receive Non-Stock PO	56	0	179
586	CO-QA-T-146	QT9 SOP Template	584	0	471
587	CO-LAB-SOP-288	Assessment of Potentiostat Performance	272	0	1121
588	CO-LAB-REG-021	Laboratory Responsibilities by Area	840	0	840
589	CO-PRD1-FRM-255	NG2 forward primer Oak House Production IQC	919	0	1371
590	CO-QA-REG-005	Supplier Concession Register	1080	0	497
591	CO-PRD1-SOP-370	Manufacturing Overview for CT/NG Taq/UNG Reagent	932	0	1563
592	CO-PRD1-SOP-269	Oak House Pipette Use and Calibration SOP	439	0	986
593	CO-PRD1-PTL-096	Oak House Labcold RLVF1517 Freezer 1183 Validation Protocol	197	0	1291
594	CO-LAB-FRM-093	Part No 0267 ‘NG Target 2 Reverse Primer’ from SGS DNA	858	0	683
595	CO-QA-JA-016	QT9 Preventive Action Module Job Aid	636	0	1160
596	CO-PRD1-JA-044	Production suite air conditioning job aid	368	0	1376
597	CO-SUP-FRM-269	Shipping Specification: CT/NG io Cartridge	98	0	1490
598	CO-DPT-ART-011	Urine STI Sample Collection Sticker	1038	0	1241
599	CO-SUP-POL-034	Supply Team Policy for Oak House Production Suite Operations	156	0	1335
600	CO-DES-T-004	Design Review Record	1064	0	289
601	CO-PRD1-LBL-047	IC DNA Reagent Box Label	825	0	1262
602	CO-SUP-SOP-067	Managing Expired Identified Stock	684	0	218
603	CO-LAB-REG-011	Asset Register	979	0	828
604	CO-LAB-FRM-054	Part No. 0014 ‘Potassium Chloride’	697	0	643
605	CO-PRD1-PTL-094	Oak House Labcold RLVF1517 Freezer 1158 Validation Protocol	975	0	1289
606	CO-LAB-FRM-027	Dimethylsulfoxide Part Number 0227	812	0	520
607	CO-DPT-WEB-001	COVID Consent	110	0	1056
608	CO-SUP-FRM-209	Oak House Cycle Counting stock sheet	459	0	1243
609	CO-PRD1-PTL-101	Validation of Oak House CT/NG reagent process	736	0	1374
610	CO-OPS-SOP-198	Manufacture of microorganism glycerol stocks	604	0	763
612	CO-LAB-FRM-094	NG1 Taqman Probe HPLC GRADE Part no 0268	474	0	684
613	CO-CS-SOP-248	Procedure For Customer Service	522	0	920
614	CO-SUP-JA-023	Dry Ice Job aid (Oak House)	201	0	1263
615	CO-QC-QCP-062	QC release procedure for the Io Reader	920	0	1146
616	CO-LAB-SOP-005	Rhychiger Heat Sealer	230	0	267
617	CO-QA-POL-020	Risk Management Policy	16	0	1112
618	CO-DPT-WEB-008	Non-COVID Consent (Spanish)	392	0	1090
619	CO-OPS-PTL-049	vT flow and leak tester- FAT protocol	278	0	925
620	CO-CA-SOP-081	Collection of In-house Collected Samples	813	0	505
621	CO-DPT-BOM-024	2.601.906 (CG3 + Blood Female AG) Kit BOM	422	0	1453
622	CO-QC-SOP-299	io Reader interface - barcode scan rate	128	0	1133
623	CO-DPT-ART-001	Outer bag label Nasal PCR Bag Bulk Kit	67	0	1035
624	CO-LAB-FRM-061	Part No. 0093 CT ME17 Synthetic target HPLC GRADE	414	0	650
625	CO-QA-T-012	Internal Training Form	913	0	297
626	CO-QC-T-137	Limited Laboratory Access Work Note	492	0	449
627	CO-QC-SOP-021	Use of Stuart SRT6D Roller Mixer	1072	0	337
628	CO-SUP-FRM-048	Supplier Questionnaire - Consultant/Services	784	0	367
629	CO-PRD1-FRM-185	Certificate of Conformance - IC DNA reagent	750	0	989
630	CO-PRD1-JA-008	Air conditioning	237	0	978
631	CO-CS-T-131	Customer Service Script	767	0	443
632	CO-DES-T-066	Validation Matrix template	411	0	378
633	CO-LAB-FRM-165	New Microorganism Introduction Checklist Form	565	0	860
634	CO-OPS-SOP-127	Potassium Phosphate Buffer	541	0	340
635	CO-H&S-PRO-001	Health & Safety Fire Related Procedures	186	0	1525
636	CO-LAB-FRM-121	Part No. 0316 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.45 µm surfactant-free Cellulose Acetate Membrane’	600	0	711
637	CO-DPT-IFU-004	At-Home Blood Spot Collection Kit IFU (Spanish Digital Version)	77	0	1003
638	CO-OPS-SOP-205	Manufacture of 200mM Tris pH8.0	199	0	770
639	CO-QC-SOP-094	Procedure to Control Chemical and Biological Spillages	269	0	537
640	CO-LAB-FRM-056	Part No. 0086 Buffer solution pH 7	724	0	645
714	CO-PRD1-SOP-312	Guidance for the completion of Reagent Production Manufacturing Batch Records (MBRs)	3	0	1213
715	CO-LAB-FRM-080	‘DNase Alert Buffer’ Part Number 0241	525	0	670
716	CO-OPS-PTL-108	VAL2023-06 NetSuite Test Specification_QT9	154	0	1567
717	CO-OPS-PTL-024	io Reader - Pneumatics End Test Protocol	991	0	804
718	CO-LAB-FRM-136	Part No. 0339 ‘NG2_di275_probe’ from SGS DNA	428	0	726
719	CO-DES-SOP-243	CE Mark/Technical File Procedure	51	0	15
720	CO-OPS-SOP-122	Detection Surfactants Solution	632	0	343
721	CO-LAB-SOP-302	Preparation and use of agarose gels	355	0	1136
722	CO-LAB-FRM-014	Part No 0180 Brij 58	149	0	260
723	CO-OPS-SOP-087	Preparation of Neisseria gonorrhoeae 1 million Genome Equivalents/µL stocks	267	0	511
724	CO-PRD1-PTL-093	Oak House Labcold RLDF0519 Fridge 1161 Validation Protocol	706	0	1281
725	CO-OPS-SOP-034	Test Method Validation	1036	0	476
726	CO-OPS-LBL-027	Interim CTNG CLIA Waiver Outer Shipper Label	101	0	907
727	CO-QC-PTL-016	Validation Protocol -20 freezer/QC lab asset 0330	1061	0	796
729	CO-DPT-IFU-018	At-Home Urine Collection Kit IFU (English Print Version)	599	0	1017
730	CO-QC-QCP-053	NG2 Plasmid Quantification - qPCR Test (Part No. 0347)	852	0	1137
731	CO-DPT-BOM-010	2.600.903 (CG3 Female) Kit BOM	773	0	1439
732	CO-DPT-IFU-005	At-Home Vaginal Swab Collection Kit IFU (English Print Version)	935	0	1004
733	CO-OPS-SOP-187	Force Test Rig Set up and Calibration	970	0	622
734	CO-REG-T-157	Regulatory Change Assessment	132	0	947
735	CO-DES-T-099	Device Master Record	305	0	411
736	CO-LAB-FRM-042	Incoming Quality Control and Specification for ‘NG2 Plasmid in TE buffer’ Materials binx Part Number: 0347	131	0	632
737	CO-OPS-SOP-200	Manufacture of Chlamydia trachomatis and Neisseria gonorrhoeae positive control samples	111	0	765
738	CO-LAB-FRM-023	6x DNA loading dye Atlas Part Number 0327	744	0	327
739	CO-IT-REG-028	Controlled Laboratory Equipment Software List	733	0	866
740	CO-QA-REG-023	Master Archive Register	10	0	843
741	CO-DES-T-083	product requirements Specification Template	702	0	395
742	CO-QA-T-196	GSPR Template	941	0	1474
743	CO-OPS-T-020	Development Partner Ranking	533	0	305
744	CO-PRD1-T-179	Template for IQC for Oak House	820	0	1333
745	CO-SUP-SOP-047	Transfer Orders	94	0	177
746	CO-SUP-JA-025	Creating stock and non-stock purchase orders from purchase request	468	0	1313
747	CO-SUP-JA-031	Automatic MRP run set up and edit	29	0	1319
748	CO-QC-T-051	Controlled Lab Notes Template	275	0	363
749	CO-SUP-SOP-052	New Supplier Set-Up	96	0	182
750	CO-DPT-IFU-038	binx health (powered by P23) At-home Saliva COVID-19 Test Collection Kit IFU (English Version)	789	0	1043
751	CO-SUP-T-178	Reagent component pick list form	639	0	1304
752	CO-DES-T-059	FMEA template	1012	0	371
753	CO-SAM-T-069	Copy Approval Form	14	0	381
754	CO-DPT-VID-001	Return STI Kit Sample Collection Video Transcript	176	0	1037
755	CO-DPT-ART-003	STI Barcodes - 8 count label	625	0	1228
756	CO-FIN-T-026	IT GAMP Evaluation Form	965	0	311
757	CO-H&S-COSHH-009	COSHH Assessment - Hazard Group 1 Pathogens	969	0	1508
758	CO-PRD1-FRM-240	Ethanol Oak House Production IQC	1003	0	1356
759	CO-OPS-SOP-085	Preparation of Chlamydia trachomatis 1 million Genome Equivalents/µL stocks	209	0	509
760	CO-LAB-FRM-114	Part Number 0300 Vircell MG DNA Control	974	0	704
761	CO-LAB-FRM-025	Tween-20 binx Part Number 0002	107	0	518
762	CO-QC-PTL-069	Testing and Release of Raw Materials & Formulated Reagents	1070	0	1082
763	CO-QA-SOP-016	Identification and Traceabillity	582	0	152
764	CO-DPT-IFU-027	STI Sample Tube/Swab Preparation Card (English Version)	696	0	1026
765	CO-QA-SOP-274	Applicable Standards Management Procedure	130	0	1070
766	CO-DPT-ART-010	Anal STI Sample Collection Sticker	879	0	1240
767	CO-OPS-PTL-039	OQ Validation Protocol Blister Filling Rig	1050	0	818
768	CO-QA-T-190	Post Market Performance Follow-up Report Template	726	0	1467
769	CO-SUP-SOP-003	Procedure for Inventry Control and BIP	922	0	19
770	CO-SUP-SOP-043	Mark Sales Orders as Despatched	807	0	161
771	CO-H&S-RA-012	Health and Safety Risk Assessment for Use of a Butane Torch	612	0	1524
772	CO-H&S-RA-006	Risk Assessment - use of UV irradiation in the binx health Laboratories	364	0	1518
773	CO-LAB-FRM-022	NG2  di452 Probe from SGS	998	0	326
774	CO-LAB-FRM-001	Part No 0001 Agarose	125	0	247
775	CO-DPT-BOM-005	2.600.006 (CG3 + Blood Male) Kit BOM	1063	0	1434
776	CO-DPT-BOM-023	2.601.903 (CG3 Female AG) Kit BOM	910	0	1452
777	CO-PRD1-FRM-198	Manufacture of NG2/IC Detection Reagent	316	0	1168
778	CO-QA-T-044	Training Competence Assessment Form	144	0	356
779	CO-SUP-JA-030	Manual MRP Process (binx ERP system) and Releasing Purchase / Production Proposals	454	0	1318
780	CO-LAB-FRM-062	‘Guanidine Thiocyanate’ Part Number: 0094	333	0	651
781	CO-H&S-RA-015	Health and Safety Risk Assessment Oak House Production Activities	1073	0	1539
782	CO-QA-SOP-285	Hazard Analysis Procedure	291	0	1110
783	CO-SUP-FRM-213	Oak House Lab Replenishment Form	710	0	1276
784	CO-SUP-T-172	Oak House Packing List - Cartridge Reagent (2-8°c)	438	0	1275
785	CO-OPS-T-130	Equipment Fulfilment Order	643	0	442
786	CO-PRD1-URS-025	URS for temp-controlled equipment for Oak House	659	0	1266
787	CO-OPS-SOP-089	Preparation of vaginal swab samples	148	0	513
788	CO-OPS-SOP-209	Preparation of bulk male urine plus 10% eNAT (v/v)	410	0	774
789	CO-LAB-FRM-081	‘DNase Alert Substrate’ Part Number 0242	749	0	671
790	CO-QA-SOP-024	Sharepoint Administration	140	0	467
791	CO-QA-T-166	Device Specific List of Applicable Standards Form Template	869	0	1069
792	CO-OPS-URS-020	Process Requirement Specification for CO-OPS-PTL-010	534	0	969
793	CO-DES-SOP-372	Reagent Design Transfer process	896	0	41
794	CO-SUP-SOP-059	Credit Customer Returns	1046	0	210
795	CO-CS-SOP-368	Instrument Service & Repair Procedure	1041	0	18
796	CO-PRD1-FRM-203	Manufacture of IC DNA Reagent	496	0	1173
797	CO-PRD1-FRM-232	Brij- 58 Oak House Production IQC	1031	0	1348
798	CO-LAB-FRM-076	Part Number 0188 Vircell CT DNA Control	270	0	666
799	CO-PRD1-PTL-110	Installation and Operational  Qualification Protocols for Jenway 924 030	906	0	1585
800	CO-H&S-RA-009	Risk Assessment for use of Chemicals	631	0	1521
801	CO-SUP-FRM-210	Oak House Re-Order form for Supply Chain	26	0	1248
802	CO-QC-PTL-064	QC testing and release of UNG raw material	33	0	1076
803	CO-DES-PTL-005	IQ/OQ for Agilent Bioanalyzer	7	0	462
804	CO-SUP-T-098	Non Approved Supplier SAP by D supplier information	1014	0	410
805	CO-DES-T-022	IVD Directive - Essential Requirements Check List Template	122	0	307
806	CO-PRD1-PTL-087	Oak House Mettler Toledo ME2002T_00 Precision Balance Asset 1170 Validation Protocol	518	0	1235
808	CO-LAB-FRM-059	‘50mM dUTP MIX’ Part no. 0088	721	0	648
809	CO-LAB-T-198	Eupry Calibration Cover Sheet	543	0	1484
810	CO-QA-T-207	EU Performance Evaluation Report Template	88	0	1570
811	CO-LAB-FRM-140	Hot Start Taq (PCR Biosystems LTD) P/N:0344	947	0	730
812	CO-SAM-JA-048	Promotional Materials Checklist	884	0	1402
813	CO-LAB-SOP-130	Heated Detection Rig Work Instructions	870	0	552
814	CO-LAB-FRM-109	Internal Control di275 Probe from ATDBio Part Number 0294	751	0	699
815	CO-DES-T-112	Pilot Line Use Log	530	0	424
816	CO-LAB-REG-020	Batch Retention Register	615	0	839
817	CO-PRD1-FRM-279	Sterivex-GP Pressure Filter Unit IQC Form	952	0	1568
818	CO-PRD1-FRM-258	pH Buffer Bottle 10.01 Twin-neck Oak House Production IQC	243	0	1377
819	CO-DES-T-067	Hazard Analysis template	1037	0	379
820	CO-PRD1-FRM-183	Certificate of conformance – CT IC detection reagent	288	0	987
821	CO-SUP-SOP-279	Stock take procedure	276	0	1102
822	CO-SUP-JA-056	Use of Sensitech data loggers	327	0	1420
823	CO-LAB-FRM-119	‘Trichomonas vaginalis Cultured Stock’ P/N:0310	948	0	709
824	CO-IT-POL-024	Business Continuity and Disaster Recovery	679	0	1182
825	CO-SUP-POL-035	Cold Chain Shipping Policy	1062	0	1496
826	CO-OPS-PTL-013	Validation -80 Freezer QC Lab	319	0	759
827	CO-DPT-BOM-017	2.601.002 (CG + Blood Male AG) Kit BOM	388	0	1446
828	CO-LAB-FRM-129	‘TV_Alt_A di452 Probe from SGS’ Part Number 0332	405	0	719
829	CO-LAB-FRM-075	‘γ Aminobutyric acid’ Part Number: 0178	114	0	665
830	CO-PRD1-FRM-253	NG1 forward primer Oak House Production IQC	803	0	1369
831	CO-OPS-SOP-119	Manufacture of NG1/NG2/IC Primer Passivation Reagent	444	0	281
832	CO-LAB-SOP-131	Pipette Use and Calibration SOP	60	0	553
833	CO-QA-T-047	Individual Training Plan Template	955	0	359
834	CO-DPT-ART-007	COVID Broad Kit QRX Barcode 2 Part Label	699	0	1232
835	CO-DPT-BOM-018	2.601.003 (CG Male AG) Kit BOM	386	0	1447
836	CO-QA-T-164	Instructional Video Template	330	0	1053
837	CO-OPS-PTL-029	Heated Detection Rig IQ Procedure	732	0	809
838	CO-OPS-PTL-019	Validation of Autolab Type III	79	0	799
839	CO-QA-T-141	Document Signoff Front Sheet	1013	0	455
840	CO-H&S-PRO-004	Accident Incident and near miss reporting procedure	115	0	1528
841	CO-PRD1-LBL-048	ERP GRN for Oak House Label-Rev_0	304	0	1383
842	CO-DPT-BOM-021	2.601.008 (CG Male AG) Kit BOM	1017	0	1450
843	CO-SUP-JA-047	Demand Plan - Plan and Release	256	0	1398
844	CO-DPT-IFU-011	At-Home Female Triple Site Collection Kit IFU (English Digital Version)	373	0	1010
845	CO-SUP-SOP-013	Customer Returns	449	0	38
846	CO-PRD1-PTL-089	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1172 Validation Protocol	992	0	1237
847	CO-LAB-SOP-152	Instrument Failure Reporting SOP	265	0	584
848	CO-QA-SOP-031	Revising and Introducing Documents in QT9	734	0	473
849	CO-OPS-SOP-203	Manufacture of Wash Buffer II	712	0	768
850	CO-LAB-FRM-084	NG1 Synthetic Target Part No 0258	1006	0	674
851	CO-OPS-SOP-229	Manufacture of CT/TV/IC Primer Buffer Reagent	467	0	794
852	CO-OPS-SOP-196	SOP to record the details of the manufacture of 75x PCR buffer	109	0	758
854	CO-H&S-COSHH-013	COSHH Assessment  - Dry Ice	515	0	1511
855	CO-DES-T-065	Validation Master Plan (or Plan) template	1078	0	377
856	CO-QC-PTL-061	T7 Raw Material Spreadsheet Validation	657	0	1072
857	CO-LAB-FRM-058	Part No. 0087 Buffer solution pH 10	851	0	647
858	CO-DPT-IFU-001	At-Home Blood Spot Collection Kit IFU (English Print Version)	590	0	1000
859	CO-OPS-SOP-188	Process Validation	58	0	623
860	CO-OPS-SOP-197	Manufacture of Taq/UNG Reagent	588	0	762
861	CO-H&S-PRO-005	Health and Safety Risk Assessment Procedure	1035	0	1529
862	CO-OPS-PTL-043	PAN-D-267 Signal Analyzer Validation of functions for outputting V&V tables	809	0	821
863	CO-QA-T-007	External Change Notification Form	462	0	292
864	CO-LAB-SOP-167	Attaching Electrode and Blister Adhesive and Blister Pack and Cover (M600)	700	0	602
865	CO-LAB-FRM-105	CT/NG: CT/IC Primer Passivation Reagent	433	0	695
866	CO-PRD1-PTL-106	Oak House APC Schneider UPS Asset  1177 Validation Protocol	848	0	1394
867	CO-QA-SOP-345	Root Cause Analysis	810	0	144
868	CO-QC-QCP-066	CT/NG: NG1/NG2/IC Primer-Passivation Reagent qPCR test	1071	0	1150
869	CO-LAB-SOP-290	SOP for running clinical samples in io® instruments	21	0	1124
871	CO-QA-SOP-098	Document Matrix	1066	0	66
872	CO-LAB-PTL-047	PQ Protocol for binder incubator and humidity chamber	229	0	848
873	CO-DPT-ART-005	COVID Pre-Printed PCR Label	648	0	1230
874	CO-LAB-FRM-127	‘TV_Alt_6_Fwd’ Part No. 0330 from SGS DNA	880	0	717
875	CO-PRD1-T-163	Certificate of Conformance template	835	0	1052
876	CO-DES-SOP-041	Design Review Work Instruction	956	0	483
877	CO-OPS-SOP-033	T7 Diluent (NZ Source BSA) Solution	544	0	475
878	CO-PRD1-SOP-258	Use of Oak House N2400-3010 Magnetic Stirrer	917	0	966
879	CO-DES-T-064	Risk Management Report template	295	0	376
880	CO-OPS-PTL-040	IQ Validation Protocol Blister Filling Rig	59	0	819
881	CO-QC-SOP-282	QC Sample Handling and Retention Procedure	289	0	1106
882	CO-OPS-URS-006	User Requirement Specification for the vT off-line flow and leak test equipment	476	0	928
883	CO-OPS-URS-010	User Requirement Specification for temperature-controlled equipment	398	0	934
884	CO-SUP-JA-065	Softbox TempCell MAX shipper packing instructions	866	0	1557
885	CO-LAB-SOP-301	Preparation Microbiological Broth & Agar	152	0	1135
886	CO-LAB-REG-019	Laboratory Investigation Register	409	0	838
887	CO-PRD1-URS-022	URS for a Hydridisation Oven (Benchmark Roto-Therm Plus H2024-E)	908	0	1215
888	CO-LAB-LBL-007	Expiry Dates Label	206	0	886
889	CO-H&S-RA-011	Covid-19 Risk Assessment binx Health ltd	366	0	1523
890	CO-IT-POL-028	Information Security Policy	455	0	1186
891	CO-DPT-BOM-006	2.600.006-001 (CG3 + Blood Male	311	0	1435
892	CO-LAB-LBL-020	SAP Stock Item Label	507	0	900
893	CO-QC-QCP-056	Release procedure for CT/NG cartridge	967	0	1140
894	CO-QC-T-033	Autoclave Record	279	0	318
895	CO-CS-FRM-267	Field Service Report Form	513	0	1473
896	CO-QC-REG-034	QC Sample Retention Register	329	0	1114
897	CO-DES-T-084	Pilot Line Electronic Stock Register	673	0	396
898	CO-QC-COP-001	Quality Control Laboratory Code of Practice	740	0	625
899	CO-QC-QCP-060	CT/NG Relabelled Cartridge Batch Release Procedure	900	0	1144
900	CO-DPT-BOM-001	2.600.003 (CG3 Male) Kit BOM	362	0	1430
901	CO-LAB-FRM-180	Class II MSC Monthly Airflow Check Form	897	0	968
902	CO-LAB-SOP-176	Guidance for the use and completion of IQC documents	378	0	611
903	CO-DPT-ART-012	BAO Sassy Little Box	346	0	1331
904	CO-OPS-T-019	Manufacturing Partner Ranking Criteria	166	0	304
905	CO-OPS-SOP-128	Preparation of TV 10 thousand cells/uL Master Stocks	878	0	347
906	CO-SUP-JA-039	Oak House Work Order Preparation	95	0	1327
907	CO-PRD1-PTL-086	Eupry Temperature Monitoring System Validation	756	0	1212
908	CO-SUP-T-003	binx Purchase Order Form	314	0	288
909	CO-H&S-COSHH-003	COSHH Assessment - Flammable Materials	161	0	1502
910	CO-PRD1-SOP-306	Manufacturing Overview for the binx Cartridge Reagent Manufacturing Facility	953	0	1176
911	CO-OPS-SOP-084	Preparation of Trichomonas vaginalis 100 thousand Genome Equivalents/µL stocks	996	0	508
912	CO-SUP-SOP-056	Check Sales Order due Date	597	0	186
913	CO-LAB-FRM-007	0.5M EDTA solution	824	0	253
914	CO-DPT-IFU-023	Blood Card Collection Kit IFU (Using the ADx Card)	715	0	1022
915	CO-QA-SOP-003	Nonconforming Product Procedure	805	0	70
916	CO-QA-T-194	Declaration of Conformity Template	836	0	1471
917	CO-LAB-FRM-110	Part No. 0295 ‘Sterile Syringe Filter with 0.45µm Cellulose Acetate Membrane’	871	0	700
918	CO-LAB-REG-037	Female Urine Database	591	0	1424
919	CO-LAB-FRM-064	Part No. 0104 – Tryptone Soya Broth	308	0	653
920	CO-DPT-BOM-012	2.600.905 (Blood + Blood	698	0	1441
921	CO-QC-QCP-059	CT/NG Collection Kit Batch Release	556	0	1143
922	CO-OPS-PTL-050	Factory Acceptance Test (FAT)  TQC in-line leak test equipment	539	0	926
923	CO-OPS-SOP-132	Manufacture of Elution Buffer Revision 2	817	0	554
924	CO-LAB-FRM-082	Part No. 0248 Pectobacterium atrosepticum chromosomal DNA in TE buffer	62	0	672
925	CO-DPT-IFU-003	At-Home Blood Spot Collection Kit IFU (English Digital Version)	802	0	1002
926	CO-LAB-FRM-008	Part No. 0117 Sterile Syringe filter with 0.2 µm cellulose acetate membrane	540	0	254
927	CO-DPT-IFU-031	binx At-Home Collection Kit Individual_Broad (English Version)	281	0	1029
928	CO-QC-QCP-070	UNG 50 U/uL(Part no. 0240)	728	0	1154
929	CO-PRD1-FRM-186	Certificate of Conformance - NG1 IC detection reagent	990	0	990
930	CO-DPT-IFU-022	Blood Card Collection Kit IFU (Using ADx Card)	1032	0	1021
931	CO-CA-FRM-041	Consent for Voluntary Donation of In-house Collected Samples	1054	0	534
932	CO-DES-T-125	Software Development Tool Approval	988	0	437
933	CO-H&S-T-204	Incident and Near Miss Reporting Form	961	0	1497
934	CO-LAB-FRM-276	High Risk Temperature Controlled Asset Sign	185	0	1544
935	CO-QC-T-096	Quarterly Reagent Check Record	755	0	408
936	CO-PRD1-FRM-229	MBG Water Oak House Production IQC	1029	0	1345
937	CO-PRD1-FRM-202	Manufacture of CT/NG Taq/UNG Reagent	682	0	1172
938	CO-LAB-SOP-097	Wireless Temperature and Humidity Monitoring	498	0	540
939	CO-OPS-SOP-112	600pM Stocks of Synthetic Uracil containing Amplicon	606	0	345
940	CO-LAB-FRM-106	‘CT/NG: CT/IC Detection Reagent	261	0	696
941	CO-QC-SOP-293	dPCR Quantification of CT and NG Vircell Inputs	842	0	1127
942	CO-DES-PTL-001	Measuring pH values IQ/OQ Protocol	416	0	452
943	CO-LAB-FRM-097	‘0271 gyrA_F_Fwd primer’	1	0	687
944	CO-DPT-BOM-004	2.600.500 (Blood	203	0	1433
945	CO-SUP-SOP-040	New Customer Set-Up	739	0	158
946	CO-LAB-FRM-055	‘Safe View DNA Stain’  Part Number 0079	119	0	644
947	CO-CA-POL-009	Verification and Validation Policy	377	0	575
948	CO-SUP-SOP-066	SAP Manager Approvals App	516	0	217
949	CO-PRD1-FRM-181	Oak House Monthly Production Facility Checklist	464	0	975
950	CO-PRD1-FRM-236	Triton X305 Oak House Production IQC	575	0	1352
951	CO-DPT-BOM-011	2.600.904 (CG + Blood + Blood Female) Kit BOM	946	0	1440
952	CO-OPS-PTL-030	Validation Protocol – Heated Detection Rig PQ	187	0	810
953	CO-OPS-SOP-116	Contrived Vaginal Matrix in eNAT	353	0	348
954	CO-OPS-T-001	Material Transfer Agreement	667	0	286
955	CO-QA-SOP-357	EU Performance Evaluation	720	0	1464
956	CO-DPT-BOM-003	2.600.004 (CG + Blood + Blood Male) Kit BOM	138	0	1432
957	CO-DPT-IFU-002	At-Home Blood Spot Collection Kit IFU (Spanish Print Version)	943	0	1001
958	CO-QA-T-086	Supplier Re-assessment Approval form	564	0	398
959	CO-PRD1-SOP-311	Use of the Rotary Vane Anemometer in Oak House	689	0	1211
960	CO-LAB-SOP-137	Variable Temperature Apparatus Monitoring	532	0	560
961	CO-H&S-RA-001	Risk Assessment - binx Health Office and non-laboratory areas	1020	0	1513
962	CO-SUP-JA-068	CT/NG ioTM Cartridge Packing Instructions for QC samples (Softbox MAX Shipper)	915	0	1560
963	CO-LAB-FRM-122	Part No. 0317 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane’	685	0	712
964	CO-QC-POL-018	Quality Control Policy	503	0	1107
965	CO-DPT-WEB-010	Terms of Service (Spanish)	1053	0	1092
966	CO-LAB-FRM-013	Triton x305	283	0	259
967	CO-QA-T-078	Field Action Implementation Checklist	589	0	390
968	CO-H&S-COSHH-005	COSHH Assessment - Corrosive Bases	850	0	1504
969	CO-LAB-LBL-003	Approved material label	995	0	882
970	CO-LAB-FRM-089	Part No 0263 ‘IC Reverse Primer’ from SGS DNA	605	0	679
971	CO-QA-SOP-005	Document and Records Archiving	560	0	69
972	CO-PRD1-LBL-041	CT IC Detection Reagent Box Label	151	0	1256
973	CO-OPS-SOP-088	Preparation of Neisseria gonorrhoeae 100 thousand Genome Equivalents/µL stocks	937	0	512
974	CO-LAB-FRM-017	IC Taqman Probe (FAM)	87	0	263
975	CO-QA-SOP-030	Accessing and Finding Documents in QT9	780	0	472
976	CO-QC-T-120	QC Laboratory Cleaning Record	43	0	432
977	CO-SUP-T-113	Cartridge Stock Take Form	419	0	425
978	CO-LAB-REG-017	Equipment Service and Calibration Register	898	0	835
979	CO-HR-REG-030	Training Register	624	0	868
980	CO-LAB-REG-016	Consumables Register	466	0	834
981	CO-QA-SOP-284	FMEA Procedure	502	0	1109
982	CO-QA-SOP-025	Management Review	650	0	468
983	CO-QA-T-197	Summary Technical Documentation (STED) Template	159	0	1475
984	CO-LAB-FRM-066	C. trachomatis serotype F Elementary Bodies Part No. 0106	1077	0	656
985	CO-SUP-JA-034	Raise Purchase Order – Non-stock & Services	343	0	1322
986	CO-OPS-URS-019	User Requirement Specification for a Balance	233	0	956
987	CO-QA-POL-010	Policy for Control of Infrastructure Environment and Equipment	801	0	576
988	CO-PRD1-FRM-237	Trizma base Oak House production IQC	178	0	1353
989	CO-SUP-SOP-278	Pilot Line Electronic Stock Control	412	0	1101
990	CO-QA-POL-015	Policy for the Use of Electronic Signatures within binx health	670	0	914
991	CO-LAB-FRM-051	WATER FOR MOLECULAR BIOLOGY Part Number 0005	487	0	639
992	CO-QC-T-136	Reagent Design template	9	0	448
993	CO-LAB-SOP-289	Standard Procedures for use in the Development of the CT/NG Assay	286	0	1123
994	CO-DPT-WEB-003	Privacy Policy	638	0	1059
995	CO-QA-T-123	CAPA date extension form	677	0	435
996	CO-LAB-SOP-102	Use of the Grant XB2 Ultrasonic Bath	844	0	543
997	CO-OPS-SOP-009	Reader Peltier Refit procedure	574	0	271
998	CO-SUP-SOP-039	Manage Quality Codes	1083	0	157
999	CO-DES-PTL-006	Balance IQ/OQ	52	0	463
1000	CO-OPS-SOP-174	Engineering Rework Procedure	399	0	609
1001	CO-CA-T-147	Clinical Trial Agreement	450	0	549
1002	CO-DPT-IFU-037	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad (English Version)	431	0	1034
1003	CO-QC-T-030	pH Meter Calibration Form	971	0	315
1004	CO-QC-T-107	Bioanalyzer Cleaning Record	583	0	419
1005	CO-OPS-POL-011	WEEE Policy	822	0	577
1006	CO-IT-POL-033	Third Party Management	463	0	1191
1007	CO-PRD1-LBL-029	Storage temperature labels	796	0	984
1008	CO-QC-PTL-062	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test (Part no. 0225)	92	0	1073
1009	CO-QC-T-071	Detection Reagent Analysis Template	959	0	383
1010	CO-PRD1-SOP-313	Use of Membrane Filters in the binx Reagent Manufacturing Facility	834	0	1214
1011	CO-SUP-JA-029	Purchase Order Acknowledgements	972	0	1317
1012	CO-SUP-POL-017	Policy for Commercial Operations	613	0	1105
1013	CO-LAB-LBL-014	Quarantined material label	23	0	894
1014	CO-PRD1-SOP-257	Standard Use of Oak House Freezers	495	0	964
1015	CO-SUP-SOP-045	Cutomer Price Lists	874	0	163
1016	CO-QA-JA-006	Use of the Management Review Module in QT9	903	0	932
1017	CO-OPS-SOP-133	Manufacture of Brij 58 Solution	1067	0	555
1018	CO-DES-SOP-371	Critical to Quality and Reagent Design Control	121	0	40
1019	CO-LAB-LBL-005	GRN for R&D and Samples Label	73	0	884
1020	CO-QA-SOP-267	Post Market Surveillance	1009	0	146
1021	CO-QA-SOP-244	QT9 Administration	982	0	909
1022	CO-LAB-REG-014	GRN Register	34	0	831
1023	CO-LAB-SOP-182	Limited Laboratory Access Procedure	334	0	617
1024	CO-LAB-SOP-175	Out of Hours Power Loss and Temperature Monitoring	12	0	610
1025	CO-PRD1-SOP-303	Oak House Out of Hours Procedures	627	0	1156
1026	CO-LAB-FRM-072	‘Part No. 0148 DL-Dithiothreitol’	761	0	662
1027	CO-PRD1-FRM-249	CT forward primer Oak House production IQC	1028	0	1365
1028	CO-LAB-URS-029	URS for Female Urine Clinical Study Database	1018	0	1422
1029	CO-LAB-SOP-183	Use of the Microcentrifuge 24	616	0	618
1030	CO-QA-SOP-093	Corrective and Preventive Action Procedure	537	0	517
1031	CO-QC-QCP-071	Enzymatics Taq-B 25U/ul (Part 0270)	640	0	1155
1032	CO-LAB-SOP-011	Eppendorf 5424 Centrifuge	36	0	273
1033	CO-PRD1-SOP-355	Manufacturing Overview for Detection Reagents	902	0	1462
1034	CO-OPS-SOP-092	mSTI Cartridge Manufacture	213	0	516
1035	CO-OPS-T-002	Material Transfer Agreement (binx recipient)	926	0	287
1036	CO-QA-T-106	Vigilance Form	482	0	418
1037	CO-LAB-LBL-026	CIR Label	424	0	906
1038	CO-PRD1-FRM-233	Glycerol Oak House Production IQC	365	0	1349
1039	CO-LAB-FRM-095	NG2 Taqman probe HPLC GRADE Part No 0269	24	0	685
1040	CO-SUP-FRM-219	CT NG Taq UNG Reagent Component Pick List Form	120	0	1310
1041	CO-PRD1-LBL-046	CT NG Taq UNG Reagent Box Label	147	0	1261
1042	CO-DPT-T-187	Digital BOM Template	475	0	1428
1043	CO-H&S-RA-008	Risk Assessment for binx Health Employees	38	0	1520
1044	CO-QC-T-095	Reagent Aliquot From	212	0	407
1045	CO-PRD1-FRM-226	Taq-B Oak House Production IQC	235	0	1342
1046	CO-LAB-SOP-012	Binder KBF-115 Oven	901	0	274
1047	CO-DES-T-063	Risk/benefit template	28	0	375
1048	CO-LAB-SOP-300	Preparation of Sub-circuit cards for voltammetric detection	30	0	1134
1049	CO-LAB-FRM-113	Part Number 0299 Vircell TV DNA control	661	0	703
1050	CO-PRD1-LBL-050	SAP Code ERP GRN Label-Rev_0	569	0	1385
1051	CO-QC-QCP-067	CT/NG: CT/IC Primer-Passivation Reagent	164	0	1151
1052	CO-QC-SOP-173	Laboratory Investigation (LI) Procedure for Invalid Assays and Out of Specification (OOS) Results	683	0	608
1053	CO-SUP-SOP-069	Supplier Evaluation	828	0	487
1054	CO-OPS-SOP-172	Tool Changes of the Rhychiger Heat Sealer	1008	0	607
1055	CO-DES-T-060	Verification Testing Protocol template	400	0	372
1056	CO-PRD1-FRM-189	Certificate of Conformance - Taq UNG	287	0	993
1057	CO-OPS-SOP-208	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility (for FDA 510(k))	46	0	773
1058	CO-OPS-SOP-114	9.26pc (w.v) NZ Source BSA in 208.3mM Potassium Phosphate buffer	508	0	283
1059	CO-PRD1-SOP-365	Manufacturing Overview for Primer/Passivation Reagents	1001	0	1550
1060	CO-H&S-COSHH-004	COSHH Assessment - Chlorinated Solvents	1005	0	1503
1061	CO-SUP-FRM-177	binx health Vendor Information Form	949	0	951
1062	CO-QC-SOP-012	Quality Control Out of Specification Results Procedure	1068	0	655
1063	CO-OPS-PTL-015	Validation 2-8 Refrigerator QC Lab	104	0	761
1064	CO-DPT-BOM-026	2.800.001 (ADX Blood Card (1) Fasting) Kit BOM	595	0	1455
1065	CO-HR-POL-007	Training Policy	184	0	573
1066	CO-LAB-FRM-003	Ethanol (Absolute)	296	0	249
1067	CO-PRD1-SOP-260	Use of Logmore dataloggers	1000	0	972
1068	CO-PRD1-FRM-197	Manufacture of NG1/IC Detection Reagent	478	0	1167
1069	CO-LAB-T-148	Template for Laboratory Code of Practice	1059	0	569
1070	CO-OPS-T-139	Cartridge and Packing Bill of Materials Template	210	0	451
1071	CO-PRD1-PTL-098	Oak House Labcold RLVF1517 Freezer 1208 Validation Protocol	65	0	1293
1072	CO-OPS-PTL-031	EOL thermal test 21011-MET-012 Thermal-PCR Cycle Template for TTDL-No.2.xlsx v4.0	170	0	811
1073	CO-QC-FRM-065	Quality Control Out of Specification Result Investigation Record Form	577	0	654
1074	CO-H&S-COSHH-008	COSHH assessment  - Hazard Group 2 respiratory pathogens	725	0	1507
1075	CO-LAB-LBL-024	Elution Reagent Label	519	0	904
1076	CO-PRD1-COP-003	Oak House Production Facility Code of Practice	326	0	971
1077	CO-DPT-JA-010	Self-Collection Validation Summary	69	0	1094
1078	CO-LAB-LBL-021	Cartridge Materials Label	875	0	901
1079	CO-QC-FRM-049	QC Monthly Laboratory Checklist	195	0	624
1080	CO-QC-T-031	Dishwasher User Form	921	0	316
1081	CO-OPS-SOP-110	225mM Potassium phosphate buffer	499	0	282
1082	CO-QC-T-103	Lab investigation initiation Template	17	0	415
1083	CO-QA-REG-025	Supplier Risk Assessment Monitoring List	427	0	845
1084	CO-OPS-SOP-091	Manufacture of TV/IC Detection Reagent	47	0	515
1085	CO-LAB-FRM-001	Part No 0001 Agarose	125	0	247
1086	CO-H&S-COSHH-005	COSHH Assessment - Corrosive Bases	850	0	1504
1087	CO-SUP-SOP-005	New Customer Procedure	620	0	21
1088	CO-REG-T-157	Regulatory Change Assessment	132	0	947
1089	CO-H&S-COSHH-002	COSHH Assessment - Oxidising Agents	859	0	1501
1090	CO-QC-QCP-058	Material Electrochemical Signal Interference - Electrochemical detection assessment	623	0	1142
1091	CO-QC-FRM-065	Quality Control Out of Specification Result Investigation Record Form	577	0	654
1092	CO-OPS-T-021	Generic PSP Ranking Criteria  template	277	0	306
1093	CO-H&S-RA-007	Risk Assessment - Pilot line Laboratory area	505	0	1519
1094	CO-SUP-T-003	binx Purchase Order Form	314	0	288
1095	CO-LAB-REG-011	Asset Register	979	0	828
1096	CO-HR-REG-030	Training Register	624	0	868
1097	CO-H&S-P-002	PAT Policy	1027	0	1533
1098	CO-QA-SOP-356	EU Regulatory Strategy and Process	359	0	1463
1099	CO-PRD1-FRM-257	Pectobacterium atrosepticum  IC  DNA buffer Oak House Production IQC	70	0	1373
1100	CO-LAB-SOP-082	Use of the Rotary Vane Anemometer	103	0	506
1101	CO-LAB-SOP-288	Assessment of Potentiostat Performance	272	0	1121
1102	CO-QA-T-196	GSPR Template	941	0	1474
1103	CO-PRD1-LBL-049	Quarantined ERP GRN material label-Rev_0	940	0	1384
1104	CO-SUP-T-171	Oak House Commercial Invoice - Cartridge Reagent  -20°c	448	0	1274
1105	CO-LAB-SOP-241	Ordering of New Reagents and Chemicals	371	0	870
1106	CO-SUP-T-100	Purchase order terms & conditions	106	0	412
1107	CO-SUP-JA-057	Third Party Sale and Purchase Orders Process	888	0	1426
1108	CO-SAM-SOP-009	Control of Marketing and Promotion	1048	0	245
1109	CO-SUP-SOP-063	Book Time Against A Project	18	0	214
1110	CO-LAB-FRM-088	Incoming Quality Control and Specification for ‘IC Forward Primer’ from SGS DNA: Part number 0262 and 0419	930	0	678
1111	CO-OPS-SOP-034	Test Method Validation	1036	0	476
1112	CO-LAB-FRM-105	CT/NG: CT/IC Primer Passivation Reagent	433	0	695
1113	CO-OPS-SOP-104	CT_IC Detection Reagent	90	0	545
1114	CO-LAB-FRM-095	NG2 Taqman probe HPLC GRADE Part No 0269	24	0	685
1115	CO-OPS-PTL-029	Heated Detection Rig IQ Procedure	732	0	809
1116	CO-LAB-SOP-159	Use of Rotor-Gene Q	798	0	594
1117	CO-SUP-SOP-059	Credit Customer Returns	1046	0	210
1118	CO-DES-PTL-003	Temperature controlled equipment	13	0	460
1119	CO-QC-T-033	Autoclave Record	279	0	318
1120	CO-QA-SOP-093	Corrective and Preventive Action Procedure	537	0	517
1121	CO-LAB-FRM-111	Part No. 0296 Chlamydia trachomatis serovar F ATCC VR-346	391	0	701
1122	CO-LAB-FRM-068	1M Magnesium Chloride solution molecular biology grade Part No. 0115	273	0	658
1123	CO-OPS-T-002	Material Transfer Agreement  binx recipient	926	0	287
1124	CO-PRD1-LBL-038	NG1 NG2 IC Primer Passivation Reagent Vial Label	441	0	1253
1125	CO-OPS-REG-026	Instrument Register	766	0	851
1126	CO-SAM-T-069	Copy Approval Form	14	0	381
1127	CO-DES-SOP-372	Reagent Design Transfer process	896	0	41
1128	CO-OPS-SOP-121	CTNG T7 Diluent Rev 3.0  NZ source BSA	705	0	344
1129	CO-PRD1-SOP-252	Use of Benchmark Roto-Therm Plus Hybridisation oven	783	0	952
1130	CO-SUP-SOP-363	Shipping Specifications Procedure	241	0	1489
1131	CO-QC-QCP-065	CT/NG: CT/IC Detection Reagent Heated io detection rig	4	0	1149
1132	CO-H&S-COSHH-014	COSHH Assessment - Compressed Gases	461	0	1512
1133	CO-SUP-JA-037	Expiry Date Amendment	217	0	1325
1134	CO-DPT-IFU-020	At-Home Urine Collection Kit IFU  English Digital Version	129	0	1019
1135	CO-LAB-LBL-023	Pilot Line Materials Label	865	0	903
1136	CO-QA-POL-019	Quality Policy	563	0	1111
1137	CO-QA-T-141	Document Signoff Front Sheet	1013	0	455
1138	CO-DPT-IFU-014	At-Home Male Triple Site Collection Kit IFU  English Print Version	754	0	1013
1139	CO-QA-T-079	Field Corrective Action File Review Form	198	0	391
1140	CO-H&S-PRO-002	Chemical and Biological COSHH Guidance	372	0	1526
1141	CO-DPT-ART-007	COVID Broad Kit QRX Barcode 2 Part Label	699	0	1232
1142	CO-QA-JA-006	Use of the Management Review Module in QT9	903	0	932
1143	CO-LAB-SOP-102	Use of the Grant XB2 Ultrasonic Bath	844	0	543
1144	CO-DPT-BOM-001	2.600.003  CG3 Male  Kit BOM	362	0	1430
1145	CO-PRD1-FRM-190	Shipment note	191	0	995
1146	CO-PRD1-LBL-040	IC DNA Reagent Vial Label	656	0	1255
1147	CO-PRD1-FRM-187	Certificate of Conformance - NG2 IC detection reagent	743	0	991
1148	CO-OPS-PTL-013	Validation -80 Freezer QC Lab	319	0	759
1149	CO-QC-PTL-071	Manufacture of Cartridge Reagents	325	0	1084
1150	CO-QC-QCP-053	NG2 Plasmid Quantification - qPCR Test  Part No. 0347	852	0	1137
1151	CO-LAB-LBL-011	Solutions labels	839	0	890
1152	CO-LAB-FRM-060	Part no. 0089 70% ethanol	1069	0	649
1153	CO-CS-JA-050	Job Aid _Field Service-Instrument cleaning	506	0	1405
1154	CO-OPS-SOP-107	Manufacture of NG2/IC Detection Reagent	559	0	547
1155	CO-LAB-FRM-112	Part Number 0298 Vircell NG DNA Control	837	0	702
1156	CO-PRD1-FRM-248	NG1 di452 probe Oak House Production IQC	957	0	1364
1157	CO-H&S-RA-001	Risk Assessment - binx Health Office and non-laboratory areas	1020	0	1513
1158	CO-PRD1-FRM-246	CT di452 probe Oak House Production IQC	885	0	1362
1159	CO-LAB-FRM-014	Part No 0180 Brij 58	149	0	260
1160	CO-DPT-IFU-040	At-Home Blood Spot Collection Kit USPS IFU  English Print Version	465	0	1047
1161	CO-DPT-IFU-041	At-Home Blood Spot Collection Kit USPS IFU  Spanish Print Version	929	0	1048
1162	CO-OPS-URS-019	User Requirement Specification for a Balance	233	0	956
1163	CO-LAB-LBL-016	MBG water label	760	0	896
1164	CO-CS-POL-012	Policy for Customer Feedback	593	0	578
1165	CO-SUP-SOP-039	Manage Quality Codes	1083	0	157
1166	CO-PRD1-FRM-227	NG2 di452 probe Oak House production IQC	293	0	1343
1167	CO-LAB-LBL-005	GRN for R&D and Samples Label	73	0	884
1168	CO-LAB-LBL-019	Asset Calibration Label	1049	0	899
1169	CO-LAB-FRM-180	Class II MSC Monthly Airflow Check Form	897	0	968
1170	CO-DES-T-062	Risk Management Plan template	1044	0	374
1171	CO-LAB-FRM-124	Part No. 0319 NATrol Neisseria gonorrhoeae Positive Control	313	0	714
1172	CO-PRD1-FRM-239	Magnesium chloride Oak House Production IQC	934	0	1355
1173	CO-OPS-URS-002	URS for Temperature Monitoring System	266	0	917
1174	CO-OPS-PTL-048	io Release Record  following repair or refurbishment	251	0	912
1175	CO-QC-SOP-021	Use of Stuart SRT6D Roller Mixer	1072	0	337
1176	CO-DPT-IFU-027	STI Sample Tube/Swab Preparation Card  English Version	696	0	1026
1177	CO-SUP-FRM-047	Supplier Questionnaire - Hardware	644	0	366
1178	CO-LAB-FRM-104	‘CT/NG: NG2/IC Detection Reagent	1084	0	694
1179	CO-DPT-BOM-021	2.601.008  CG Male AG  Kit BOM	1017	0	1450
1180	CO-QC-PTL-077	Process Validation of CO-QC-QCP-069 and CO-QC-QCP-052. IC DNA Reagent and Raw Material Testing	221	0	1193
1181	CO-QC-T-071	Detection Reagent Analysis Template	959	0	383
1182	CO-LAB-LBL-021	Cartridge Materials Label	875	0	901
1183	CO-LAB-FRM-055	‘Safe View DNA Stain’  Part Number 0079	119	0	644
1184	CO-DES-T-005	Phase Review Record	207	0	290
1338	CO-SUP-SOP-038	Change of Stock  QC Release	249	0	156
1185	CO-H&S-COSHH-007	COSHH assessment  - General Hazard Group 2 organisms	78	0	1506
1186	CO-SUP-FRM-220	IC DNA Reagent Component Pick List Form	795	0	1311
1187	CO-LAB-FRM-012	Microbank Cryovials	260	0	258
1188	CO-LAB-FRM-138	‘Potassium Chloride Solution’ Part Number: 0341	713	0	728
1189	CO-LAB-FRM-010	2mL ENAT Transport media	651	0	256
1190	CO-H&S-P-004	Coronavirus  COVID-19  Policy on employees being vaccinated	542	0	1535
1191	CO-DPT-IFU-044	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU for return at a drop-off location  English Print Version	581	0	1063
1192	CO-DPT-WEB-006	COVID Consent  Spanish	611	0	1088
1193	CO-LAB-FRM-018	CTdi452 Probe from atdbio	779	0	322
1194	CO-LAB-SOP-012	Binder KBF-115 Oven	901	0	274
1195	CO-LAB-FRM-113	Part Number 0299 Vircell TV DNA control	661	0	703
1196	CO-LAB-FRM-064	Part No. 0104 – Tryptone Soya Broth	308	0	653
1197	CO-LAB-FRM-119	‘Trichomonas vaginalis Cultured Stock’ P/N:0310	948	0	709
1198	CO-DES-T-060	Verification Testing Protocol template	400	0	372
1199	CO-QA-SOP-357	EU Performance Evaluation	720	0	1464
1200	CO-SUP-SOP-046	Create New Customer Return	484	0	164
1201	CO-QC-PTL-072	dPCR Performance Qualification	771	0	1085
1202	CO-SUP-FRM-195	Purchase Order Request	193	0	1068
1203	CO-QA-SOP-077	Supplier Audit Procedure	694	0	500
1204	CO-LAB-SOP-011	Eppendorf 5424 Centrifuge	36	0	273
1205	CO-OPS-URS-020	Process Requirement Specification for CO-OPS-PTL-010	534	0	969
1206	CO-OPS-SOP-209	Preparation of bulk male urine plus 10% eNAT  v/v	410	0	774
1207	CO-OPS-PTL-014	Validation -80 Chest Freezer Micro lab	382	0	760
1208	CO-SUP-SOP-075	Order to Cash	666	0	492
1209	CO-SUP-FRM-046	Supplier Questionnaire - Calibration/Equipment maintenance	494	0	364
1210	CO-QA-T-192	Post Market Surveillance Plan Template	686	0	1469
1211	CO-LAB-JA-043	CIR Job Aid	375	0	1337
1212	CO-OPS-PTL-030	Validation Protocol – Heated Detection Rig PQ	187	0	810
1213	CO-OPS-T-019	Manufacturing Partner Ranking Criteria	166	0	304
1214	CO-OPS-PTL-018	Validation Protocol – UV/Vis Nanodrop Spectrophotometer	674	0	798
1215	CO-CS-FRM-275	binx io RMA Number Request Form	417	0	1537
1216	CO-OPS-SOP-133	Manufacture of Brij 58 Solution	1067	0	555
1217	CO-PRD1-FRM-188	Certificate of Conformance - NG1 NG2 IC primer passivation reagent	421	0	992
1218	CO-PRD1-SOP-260	Use of Logmore dataloggers	1000	0	972
1219	CO-LAB-FRM-017	IC Taqman Probe  FAM	87	0	263
1220	CO-LAB-FRM-092	Part No 0266 ‘NG Target 2 Forward Primer’ from SGS DNA	936	0	682
1221	CO-DPT-WEB-008	Non-COVID Consent  Spanish	392	0	1090
1222	CO-QA-REG-033	Auditor register	245	0	1075
1223	CO-SUP-FRM-043	Initial Risk Assessment and Supplier Approval	849	0	397
1224	CO-DPT-JA-010	Self-Collection Validation Summary	69	0	1094
1225	CO-OPS-SOP-085	Preparation of Chlamydia trachomatis 1 million Genome Equivalents/µL stocks	209	0	509
1226	CO-LAB-FRM-019	Synthetic Uracil containing Amplicon	688	0	323
1227	CO-H&S-RA-016	Health and Safety Risk Assessment Incoming-Outgoing goods and Packaging	678	0	1540
1229	CO-PRD1-PTL-078	Oak House Jenway 3510 pH Meter Asset 1143 Validation Protocol	662	0	1198
1230	CO-PRD1-FRM-185	Certificate of Conformance - IC DNA reagent	750	0	989
1231	CO-LAB-FRM-107	‘IC di275 Probe from SGS’ Part No. 0288	806	0	697
1232	CO-OPS-SOP-109	1 x lysis buffer	1052	0	339
1233	CO-LAB-FRM-128	‘TV_Alt_6_Rev’ Part No 0331 from SGS DNA	183	0	718
1234	CO-QA-T-109	Archiving Box Contents List	567	0	421
1235	CO-H&S-COSHH-008	COSHH assessment  - Hazard Group 2 respiratory pathogens	725	0	1507
1236	CO-PRD1-FRM-202	Manufacture of CT/NG Taq/UNG Reagent	682	0	1172
1237	CO-H&S-T-204	Incident and Near Miss Reporting Form	961	0	1497
1238	CO-LAB-FRM-061	Part No. 0093 CT ME17 Synthetic target HPLC GRADE	414	0	650
1239	CO-SAM-JA-049	Use of Acronyms in Marketing Materials	1057	0	1403
1240	CO-DPT-WEB-009	South Dakota Waiver Consent and Release of Information  Spanish	614	0	1091
1241	CO-DES-SOP-004	Software Development Procedure	778	0	16
1242	CO-QA-SOP-030	Accessing and Finding Documents in QT9	780	0	472
1243	CO-SUP-T-184	binx Commercial Invoice  Misc. shipments	321	0	1417
1244	CO-LAB-SOP-182	Limited Laboratory Access Procedure	334	0	617
1245	CO-SUP-SOP-057	Consume to Cost Centre or Project	453	0	208
1246	CO-SUP-JA-041	Oak House Work Order Completion	86	0	1329
1247	CO-QC-QCP-039	T7 Raw Material Test	704	0	587
1248	CO-LAB-SOP-015	Use of the ALC PK121 centrifuges  refrigerated and non-refrigerated	423	0	331
1249	CO-H&S-PRO-005	Health and Safety Risk Assessment Procedure	1035	0	1529
1250	CO-OPS-URS-013	User requirement specification for class 2 microbiological safety cabinet	479	0	937
1251	CO-DES-T-126	Soup Approval	145	0	438
1252	CO-OPS-SOP-105	NG1_IC Detection Reagent	142	0	546
1253	CO-DPT-BOM-003	2.600.004  CG + Blood + Blood Male  Kit BOM	138	0	1432
1254	CO-QA-REG-005	Supplier Concession Register	1080	0	497
1255	CO-PRD1-SOP-264	Eupry temperature monitoring system	1039	0	980
1256	CO-PRD1-REG-035	Oak House Equipment Service and Calibration Register	818	0	1196
1257	CO-OPS-SOP-086	Preparation of Chlamydia trachomatis 100 thousand Genome Equivalents/µL stocks	692	0	510
1258	CO-LAB-REG-017	Equipment Service and Calibration Register	898	0	835
1259	CO-OPS-SOP-197	Manufacture of Taq/UNG Reagent	588	0	762
1260	CO-OPS-SOP-117	Manufacture of IC DNA Reagent’	477	0	279
1261	CO-DPT-ART-002	Inner lid activation label  STI/ODX	408	0	1093
1262	CO-SUP-JA-061	AirSea Dry Ice Shipper Packing Instructions	263	0	1553
1263	CO-LAB-FRM-108	‘CT di452 Probe from SGS’ Part No. 0289	1024	0	698
1264	CO-QC-PTL-064	QC testing and release of UNG raw material	33	0	1076
1265	CO-QA-T-008	Change Management Form	964	0	293
1266	CO-OPS-SOP-190	Preparation of IC DNA in TE buffer 10ng/μl master stock aliquots	942	0	636
1267	CO-OPS-PTL-009	Heated Detection Rig OQ Procedure	669	0	536
1268	CO-CS-T-135	Equipment Return Order	54	0	447
1269	CO-LAB-SOP-199	Manufacture of CT/NG Negative Control Samples	708	0	764
1270	CO-LAB-SOP-080	Use of Agilent Bioanalyzer DNA 1000 kits	456	0	504
1271	CO-QC-LBL-031	QC Retention Box Label	285	0	1115
1272	CO-DES-PTL-004	Monmouth 1200	332	0	461
1273	CO-LAB-FRM-073	1L Nalgene Disposable Filter Unit’ Part No. 0167	546	0	663
1274	CO-DPT-BOM-019	2.601.005  Blood Unisex AG  Kit BOM	167	0	1448
1275	CO-PRD1-REG-036	Oak House Pipette Register	551	0	1197
1276	CO-DPT-VID-001	Return STI Kit Sample Collection Video Transcript	176	0	1037
1277	CO-LAB-SOP-148	Reagent Aliquotting	483	0	580
1278	CO-LAB-FRM-078	Part no. 0222 CO2 Gen sachets	511	0	668
1279	CO-DPT-IFU-002	At-Home Blood Spot Collection Kit IFU  Spanish Print Version	943	0	1001
1280	CO-OPS-PTL-015	Validation 2-8 Refrigerator QC Lab	104	0	761
1281	CO-SUP-SOP-050	Raise PO - Stock Items	933	0	180
1282	CO-PRD1-SOP-254	Use & Cleaning of the Monmouth Scientific Model Guardian 1800 Production Enclosure in Oak House	204	0	959
1283	CO-SUP-JA-030	Manual MRP Process  binx ERP system  and Releasing Purchase / Production Proposals	454	0	1318
1284	CO-PRD1-FRM-199	Manufacture of CT/IC Detection Reagent	737	0	1169
1285	CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	331	0	498
1286	CO-LAB-FRM-082	Part No. 0248 Pectobacterium atrosepticum chromosomal DNA in TE buffer	62	0	672
1287	CO-PRD1-JA-009	Intruder Alarm	521	0	1067
1288	CO-H&S-RA-002	Risk Assessment for use of Microorganisms	1047	0	1514
1289	CO-H&S-PRO-004	Accident Incident and near miss reporting procedure	115	0	1528
1290	CO-IT-POL-030	Physical Security Policy	716	0	1188
1291	CO-PRD1-FRM-189	Certificate of Conformance - Taq UNG	287	0	993
1292	CO-SUP-JA-065	Softbox TempCell MAX shipper packing instructions	866	0	1557
1293	CO-DPT-BOM-009	2.600.902  CG + Blood Female  Kit BOM	307	0	1438
1294	CO-QA-SOP-025	Management Review	650	0	468
1295	CO-OPS-URS-010	User Requirement Specification for temperature-controlled equipment	398	0	934
1296	CO-LAB-LBL-017	Equipment Under Qualification Label	252	0	897
1297	CO-LAB-FRM-075	‘γ Aminobutyric acid’ Part Number: 0178	114	0	665
1298	CO-OPS-SOP-083	Preparation of Trichomonas vaginalis 1 million Genome Equivalents/µL stocks	402	0	507
1299	CO-PRD1-SOP-256	Velp Scientific WIZARD IR Infrared Vortex Mixer SOP	205	0	963
1300	CO-LAB-LBL-004	For Indication Only Label	619	0	883
1301	CO-DPT-IFU-016	At-Home Male Triple Site Collection Kit IFU  English Digital Version	954	0	1015
1302	CO-LAB-REG-019	Laboratory Investigation Register	409	0	838
1303	CO-DPT-FEA-002	UTI Screening Box	868	0	1098
1304	CO-PRD1-PTL-097	Oak House Labcold RLDF1519 Fridge 1207 Validation Protocol	218	0	1292
1305	CO-LAB-SOP-167	Attaching Electrode and Blister Adhesive and Blister Pack and Cover  M600	700	0	602
1306	CO-OPS-SOP-205	Manufacture of 200mM Tris pH8.0	199	0	770
1307	CO-IT-POL-025	Code of Conduct	50	0	1183
1308	CO-DPT-IFU-003	At-Home Blood Spot Collection Kit IFU  English Digital Version	802	0	1002
1309	CO-DES-T-129	Customer Requirements Specification	905	0	441
1310	CO-LAB-FRM-062	‘Guanidine Thiocyanate’ Part Number: 0094	333	0	651
1311	CO-QA-SOP-043	Training Procedure	306	0	485
1312	CO-PRD1-FRM-244	Albumin from bovine serum  BSA  Oak House Production IQC	924	0	1360
1313	CO-H&S-RA-008	Risk Assessment for binx Health Employees	38	0	1520
1314	CO-LAB-SOP-151	Management and Control of Critical and Controlled Equipment	82	0	583
1315	CO-DPT-IFU-033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping  English Version	442	0	1031
1316	CO-DPT-IFU-010	At-Home Female Triple Site Collection Kit IFU  Spanish Print Version	317	0	1009
1317	CO-LAB-FRM-081	‘DNase Alert Substrate’ Part Number 0242	749	0	671
1318	CO-PRD1-SOP-305	Use of ME2002T/00 and ML104T/00 balances in the Oak House Production Facility	75	0	1164
1319	CO-PRD1-URS-027	User Requirements Specification for a Monmouth Scientific Model Guardian 1800 production enclosure	596	0	1302
1320	CO-SUP-JA-025	Creating stock and non-stock purchase orders from purchase request	468	0	1313
1321	CO-CA-T-147	Clinical Trial Agreement	450	0	549
1322	CO-LAB-REG-018	Enviromental Monitoring Results Register	299	0	837
1323	CO-LAB-FRM-025	Tween-20 binx Part Number 0002	107	0	518
1324	CO-LAB-URS-029	URS for Female Urine Clinical Study Database	1018	0	1422
1325	CO-CA-SOP-081	Collection of In-house Collected Samples	813	0	505
1326	CO-OPS-PTL-011	Rapid PCR Rig OQ Procedure	5	0	626
1327	CO-OPS-SOP-033	T7 Diluent  NZ Source BSA  Solution	544	0	475
1328	CO-LAB-LBL-053	SAP Stock Item Label  Green	774	0	1583
1329	CO-DPT-T-187	Digital BOM Template	475	0	1428
1330	CO-PRD1-FRM-241	T7 exonuclease Oak House Production IQC	830	0	1357
1331	CO-QA-SOP-007	Correction Removal and Recall Procedure	135	0	74
1332	CO-SUP-JA-055	Use of Elpro data loggers	763	0	1419
1333	CO-CS-JA-069	Customer Installation and Training Job Aid binx io	524	0	1561
1334	CO-QC-SOP-154	QC Laboratory Cleaning Procedure	580	0	586
1335	CO-QC-QCP-060	CT/NG Relabelled Cartridge Batch Release Procedure	900	0	1144
1336	CO-LAB-FRM-004	TRIS  TRIZMA  Base	691	0	250
1337	CO-OPS-JA-020	Cartridge Defects Library	746	0	1195
1339	CO-QA-REG-041	Employee Unique Initial Register	962	0	1565
1340	CO-LAB-SOP-150	Standard Use of Freezers	225	0	582
1341	CO-DPT-IFU-032	binx At-Home Collection Kit IFU Group_Broad  English Version	552	0	1030
1342	CO-LAB-FRM-102	‘CT/NG: TaqUNG Reagent	855	0	692
1343	CO-LAB-FRM-021	NG1  di452 Probe from SGS	11	0	325
1344	CO-SUP-T-098	Non Approved Supplier SAP by D supplier information	1014	0	410
1345	CO-DPT-BOM-029	2.801.002  ADX Blood Card  2 Non-fasting  Kit BOM	74	0	1458
1346	CO-PRD1-T-165	Manufacturing Batch Record  MBR  Template	944	0	1062
1347	CO-LAB-FRM-042	Incoming Quality Control and Specification for ‘NG2 Plasmid in TE buffer’ Materials binx Part Number: 0347	131	0	632
1348	CO-LAB-FRM-043	Incoming Quality Control and Specification for ‘CT Plasmid in TE buffer’ Materials binx Part Number: 0348	535	0	633
1349	CO-OPS-SOP-116	Contrived Vaginal Matrix in eNAT	353	0	348
1350	CO-SUP-T-113	Cartridge Stock Take Form	419	0	425
1351	CO-QC-T-096	Quarterly Reagent Check Record	755	0	408
1352	CO-SUP-SOP-073	Standard Cost Roll Up	717	0	490
1353	CO-SUP-SOP-072	Instructions for receipt of incoming Non-Stock goods  assigning GRN numbers and labelling	425	0	489
1354	CO-SUP-T-185	binx Packing List  Misc shipments	259	0	1418
1355	CO-QC-T-023	Solution Preparation Form	645	0	308
1356	CO-QA-SOP-015	Qualification and Competence of Auditors	242	0	151
1357	CO-QC-JA-019	A Guide for QC Document Filing	671	0	1178
1358	CO-QC-QCP-067	CT/NG: CT/IC Primer-Passivation Reagent	164	0	1151
1359	CO-OPS-URS-018	Reagent Handling Processor for Scienion Dispense Equipment	797	0	948
1360	CO-QC-T-136	Reagent Design template	9	0	448
1361	CO-SUP-JA-064	Softbox TempCell PRO shipper packing instructions	389	0	1556
1362	CO-OPS-PTL-027	Rapid PCR Rig IQ Protocol	592	0	807
1363	CO-SUP-SOP-060	Customer Returns	238	0	211
1364	CO-PRD1-SOP-263	Entry and Exit to the Oak House Production Facility and Production Suite	1055	0	977
1365	CO-PRD1-FRM-201	Manufacture of NG1/NG2/IC Primer Passivation Reagent	223	0	1171
1366	CO-QA-SOP-244	QT9 Administration	982	0	909
1367	CO-LAB-FRM-096	‘25U/µL Taq-B DNA Polymerase  Low Glycerol ’ Part Number 0270	436	0	686
1368	CO-SUP-FRM-178	GRN Form for incoming goods	1081	0	965
1369	CO-QA-SOP-026	Use of Sharepoint	723	0	469
1370	CO-QC-QCP-068	CT/NG Taq-UNG reagent qPCR test  MOB-D-0277	336	0	1152
1371	CO-SUP-FRM-218	NG1 NG2 IC Primer Passivation Reagent Component Pick List Form	853	0	1309
1372	CO-PRD1-LBL-030	Temperature only label	585	0	1055
1373	CO-LAB-REG-013	Pipette Register	790	0	830
1374	CO-OPS-SOP-084	Preparation of Trichomonas vaginalis 100 thousand Genome Equivalents/µL stocks	996	0	508
1375	CO-QA-SOP-016	Identification and Traceabillity	582	0	152
1376	CO-LAB-FRM-129	‘TV_Alt_A di452 Probe from SGS’ Part Number 0332	405	0	719
1377	CO-PRD1-FRM-183	Certificate of conformance – CT IC detection reagent	288	0	987
1378	CO-OPS-SOP-200	Manufacture of Chlamydia trachomatis and Neisseria gonorrhoeae positive control samples	111	0	765
1379	CO-LAB-FRM-137	‘HS anti-Taq mAb  5.7 mg/mL ’ Part no: 0340	827	0	727
1380	CO-LAB-FRM-022	NG2  di452 Probe from SGS	998	0	326
1381	CO-LAB-FRM-011	Part no. 0141 Albumin from Bovine serum	1075	0	257
1382	CO-SAM-JA-048	Promotional Materials Checklist	884	0	1402
1383	CO-DPT-BOM-030	5.900.444  Blood Collection Drop-in Pack  Kit BOM	481	0	1459
1385	CO-LAB-SOP-158	Use of the NanoDrop ND2000 Spectrophotometer	1004	0	593
1386	CO-QA-SOP-003	Nonconforming Product Procedure	805	0	70
1387	CO-H&S-COSHH-010	COSHH assessment - clinical samples	344	0	1509
1388	CO-DES-T-099	Device Master Record	305	0	411
1389	CO-PRD1-PTL-110	Installation and Operational  Qualification Protocols for Jenway 924 030 6.0 mm Tris Buffer pH Electrode  Asset  to be used with	906	0	1585
1390	CO-PRD1-PTL-094	Oak House Labcold RLVF1517 Freezer 1158 Validation Protocol	975	0	1289
1391	CO-OPS-SOP-188	Process Validation	58	0	623
1392	CO-PRD1-FRM-261	Sartorius Minisart™ NML Syringe Filters Sterile  0.45 µm  Male Luer Lock Oak House IQC	718	0	1380
1393	CO-PRD1-T-163	Certificate of Conformance template	835	0	1052
1394	CO-QC-COP-002	CL2 Microbiology Laboratory Code of Practice	426	0	852
1395	CO-LAB-SOP-019	Use of the LMS Programmable Incubator	891	0	335
1396	CO-QC-QCP-069	CT/NG: IC DNA Reagent qPCR Test	301	0	1153
1397	CO-LAB-FRM-006	Triton X-100	549	0	252
1398	CO-LAB-SOP-005	Rhychiger Heat Sealer	230	0	267
1399	CO-QA-SOP-140	Document Control Procedure  Projects	57	0	65
1400	CO-LAB-SOP-290	SOP for running clinical samples in io® instruments	21	0	1124
1401	CO-IT-POL-033	Third Party Management	463	0	1191
1402	CO-PRD1-JA-008	Air conditioning	237	0	978
1403	CO-QC-QCP-070	UNG 50 U/uL Part no. 0240	728	0	1154
1404	CO-LAB-SOP-022	Operation & Maintenance of Grant SUB Aqua Pro 5  SAP5  unstirred Water Bath with Labarmor Beads	1016	0	338
1405	CO-LAB-T-159	Autoclave Biological Indicator Check Form	105	0	957
1406	CO-QA-FRM-193	Auditor Qualification	561	0	1064
1407	CO-PRD1-PTL-098	Oak House Labcold RLVF1517 Freezer 1208 Validation Protocol	65	0	1293
1408	CO-PRD1-SOP-309	Use of the Uninterruptible Power Supply	831	0	1194
1409	CO-PRD1-FRM-279	Sterivex-GP Pressure Filter Unit IQC Form	952	0	1568
1410	CO-QA-T-142	Document and Record Disposition Form	180	0	456
1411	CO-QA-SOP-283	Product Risk Management Procedure	742	0	1108
1412	CO-DPT-IFU-024	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting  English Print Version	857	0	1023
1413	CO-DES-T-058	Project Planning Template	63	0	370
1414	CO-DPT-IFU-009	At-Home Female Triple Site Collection Kit IFU  English Print Version	928	0	1008
1415	CO-QA-SOP-005	Document and Records Archiving	560	0	69
1416	CO-LAB-SOP-292	Preparation of Tryptone Soya Broth  TSB  and Tryptone Soya Agar  TSA	157	0	1126
1417	CO-QC-PTL-070	Manufacture of CTNG Cartridge Reagents	786	0	1083
1418	CO-OPS-SOP-032	Validation of Automated Equipment and Quality System Software	1040	0	474
1419	CO-PRD1-PTL-106	Oak House APC Schneider UPS Asset  1177 Validation Protocol	848	0	1394
1420	CO-FIN-T-027	IT Request for Information	155	0	312
1421	CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	833	0	73
1422	CO-OPS-URS-015	User requirement specification for a cooled incubator	347	0	942
1423	CO-PRD1-SOP-311	Use of the Rotary Vane Anemometer in Oak House	689	0	1211
1424	CO-LAB-FRM-077	‘Albumin from bovine serum – New Zealand Source’ Part Number: 0219	630	0	667
1425	CO-QC-JA-012	Job Aid: A Guide to QC Cartridge Inspections	232	0	1118
1426	CO-QC-T-144	QC io Mainternance Log	520	0	458
1427	CO-QA-T-193	Post Market Surveillance Report Template	815	0	1470
1428	CO-LAB-SOP-179	Cleaning Procedure for Microbiology Lab	208	0	614
1429	CO-QC-T-035	Rework Protocol Template	68	0	320
1430	CO-SUP-FRM-213	Oak House Lab Replenishment Form	710	0	1276
1432	CO-SUP-SOP-065	Complete a Time Sheet	146	0	216
1433	CO-LAB-T-148	Template for Laboratory Code of Practice	1059	0	569
1434	CO-H&S-COSHH-001	COSHH Assessment - General Chemicals	1065	0	1500
1435	CO-LAB-FRM-071	Potassium Phosphate Dibasic’ Part No.0147	469	0	661
1436	CO-QC-PTL-073	QC Release of CT/NG Cartridge	354	0	1086
1437	CO-LAB-SOP-239	Microorganism Ampoules Handling SOP	244	0	857
1438	CO-LAB-REG-016	Consumables Register	466	0	834
1439	CO-LAB-LBL-008	Pipette Calibration Label	1056	0	887
1440	CO-DPT-BOM-011	2.600.904  CG + Blood + Blood Female  Kit BOM	946	0	1440
1441	CO-LAB-LBL-012	General Calibration Label	978	0	892
1442	CO-DPT-IFU-037	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad  English Version	431	0	1034
1443	CO-H&S-PRO-003	Manual Lifting Procedure	141	0	1527
1444	CO-QA-SOP-031	Revising and Introducing Documents in QT9	734	0	473
1445	CO-OPS-SOP-172	Tool Changes of the Rhychiger Heat Sealer	1008	0	607
1446	CO-LAB-SOP-003	Validation of Temperature Controlled Equipment	118	0	265
1447	CO-PRD1-PTL-093	Oak House Labcold RLDF0519 Fridge 1161 Validation Protocol	706	0	1281
1448	CO-LAB-LBL-014	Quarantined material label	23	0	894
1449	CO-OPS-URS-006	User Requirement Specification for the vT off-line flow and leak test equipment	476	0	928
1450	CO-PRD1-SOP-369	Manufacturing Overview for IC DNA Reagent	181	0	1562
1451	CO-LAB-FRM-136	Part No. 0339 ‘NG2_di275_probe’ from SGS DNA	428	0	726
1452	CO-SUP-SOP-025	Quality Control	1034	0	85
1453	CO-OPS-SOP-089	Preparation of vaginal swab samples	148	0	513
1454	CO-OPS-URS-028	Keyence LM Series - User Requirements Specification	621	0	1375
1455	CO-PRD1-FRM-186	Certificate of Conformance - NG1 IC detection reagent	990	0	990
1456	CO-QA-SOP-028	Quality Records	872	0	470
1457	CO-LAB-REG-037	Female Urine Database	591	0	1424
1458	CO-LAB-FRM-109	Internal Control di275 Probe from ATDBio Part Number 0294	751	0	699
1459	CO-LAB-SOP-168	Jenway 3510 model pH Meter	470	0	603
1460	CO-PRD1-SOP-365	Manufacturing Overview for Primer/Passivation Reagents	1001	0	1550
1461	CO-OPS-URS-007	TQC leak tester- User Requirement Specification	361	0	929
1462	CO-LAB-SOP-079	Use and Cleaning of Class II Microbiology Safety Cabinet	309	0	503
1463	CO-LAB-FRM-101	‘CT/NG: NG1/NG2/IC Primer Passivation Reagent	434	0	691
1464	CO-LAB-FRM-087	Part No 0261 ‘CT Reverse Mod Primer’ from SGS DNA	224	0	677
1465	CO-QA-T-206	EU Performance Evaluation Plan Template	984	0	1569
1466	CO-QA-T-190	Post Market Performance Follow-up Report Template	726	0	1467
1467	CO-PRD1-FRM-263	Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Slip Oak House IQC	517	0	1382
1468	CO-OPS-PTL-019	Validation of Autolab Type III	79	0	799
1469	CO-LAB-PTL-186	Verification Testing Protocol for Female Urine Database	642	0	1423
1470	CO-SUP-POL-034	Supply Team Policy for Oak House Production Suite Operations	156	0	1335
1471	CO-SUP-SOP-045	Cutomer Price Lists	874	0	163
1472	CO-LAB-FRM-278	Asset Not Temperature Controlled Sign	916	0	1546
1473	CO-DPT-VID-006	Vaginal Swab Sample Collection Video Transcript	393	0	1042
1474	CO-PRD1-LBL-033	Intermediate reagent labels	629	0	1199
1475	CO-DPT-BOM-002	2.600.002  CG + Blood Male  Kit BOM	829	0	1431
1476	CO-QC-REG-034	QC Sample Retention Register	329	0	1114
1477	CO-PRD1-LBL-041	CT IC Detection Reagent Box Label	151	0	1256
1478	CO-LAB-LBL-020	SAP Stock Item Label	507	0	900
1479	CO-QA-T-164	Instructional Video Template	330	0	1053
1480	CO-QC-SOP-012	Quality Control Out of Specification Results Procedure	1068	0	655
1481	CO-QC-T-095	Reagent Aliquot From	212	0	407
1482	CO-LAB-SOP-130	Heated Detection Rig Work Instructions	870	0	552
1483	CO-LAB-FRM-003	Ethanol  Absolute	296	0	249
1484	CO-PRD1-FRM-240	Ethanol Oak House Production IQC	1003	0	1356
1485	CO-IT-SOP-044	IT Management Back-UP and Support	443	0	486
1486	CO-SUP-JA-039	Oak House Work Order Preparation	95	0	1327
1487	CO-IT-POL-029	Information Security Roles and Responsibilities	722	0	1187
1488	CO-LAB-SOP-138	Use of Temperature and Humidity Loggers	1022	0	561
1489	CO-DPT-BOM-024	2.601.906  CG3 + Blood Female AG  Kit BOM	422	0	1453
1490	CO-LAB-FRM-053	‘TRIS  TRIZMA®  HYDROCHLORIDE’ Part Number: 0011	460	0	642
1491	CO-LAB-REG-008	Manufacturing Lot Number Register	617	0	558
1492	CO-QA-T-011	Form Template	437	0	296
1493	CO-QA-JA-018	QT9 Internal Audit Module Job Aid	711	0	1175
1494	CO-OPS-SOP-208	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	46	0	773
1495	CO-DPT-BOM-025	2.601.908  CG Female AG  Kit BOM	367	0	1454
1496	CO-PRD1-FRM-259	pH Buffer Bottle 7.00 Twin-neck Oak House Production IQC	271	0	1378
1497	CO-CA-FRM-044	Non-binx-initiated study proposal	356	0	550
1498	CO-QC-T-016	Lab Cleaning Form	804	0	301
1499	CO-LAB-SOP-184	Pilot Line Blister Filling and Sealing Standard Operating Procedure	523	0	619
1500	CO-DES-T-022	IVD Directive - Essential Requirements Check List Template	122	0	307
1501	CO-DPT-IFU-004	At-Home Blood Spot Collection Kit IFU  Spanish Digital Version	77	0	1003
1502	CO-FIN-T-026	IT GAMP Evaluation Form	965	0	311
1503	CO-QC-POL-018	Quality Control Policy	503	0	1107
1504	CO-QC-QCP-063	CT/NG: NG2/IC detection reagent Heated io detection rig	349	0	1147
1505	CO-QC-JA-004	Use of CO-QC-T-155: CTNG QC Cartridge Analysis Module	432	0	916
1506	CO-OPS-URS-014	User requirement specification for a filter integrity tester	557	0	941
1507	CO-H&S-RA-015	Health and Safety Risk Assessment Oak House Production Activities	1073	0	1539
1508	CO-QA-JA-001	A Basic Guide to Finding Documents in SharePoint	387	0	535
1509	CO-SUP-SOP-062	Add Team Member to a Task	192	0	213
1510	CO-LAB-SOP-095	Instrument Cleaning Procedure	262	0	538
1511	CO-SUP-JA-040	Oak House Work Order Completion	681	0	1328
1512	CO-PRD1-LBL-034	CT IC Detection Reagent Vial Label	45	0	1249
1513	CO-CS-SOP-275	Installation and Training - binx io	707	0	1081
1514	CO-LAB-FRM-084	NG1 Synthetic Target Part No 0258	1006	0	674
1515	CO-DES-T-040	binx Report Template	752	0	352
1516	CO-QC-SOP-286	Procedure for the Release of io Instruments	873	0	1119
1517	CO-PRD1-SOP-271	Use of the Pacplus Impulse Heat Sealer	603	0	996
1518	CO-DES-T-004	Design Review Record	1064	0	289
1519	CO-H&S-PRO-007	Fire evacuation procedure for Oak House	649	0	1531
1520	CO-H&S-COSHH-013	COSHH Assessment  - Dry Ice	515	0	1511
1521	CO-PRD1-POL-016	Reagent Production Policy	846	0	970
1522	CO-OPS-PTL-043	PAN-D-267 Signal Analyzer Validation of functions for outputting V&V tables	809	0	821
1523	CO-PRD1-URS-022	URS for a Hydridisation Oven  Benchmark Roto-Therm Plus H2024-E	908	0	1215
1524	CO-QA-POL-021	Quality Manual	550	0	1113
1525	CO-QA-JA-016	QT9 Preventive Action Module Job Aid	636	0	1160
1526	CO-QC-COP-001	Quality Control Laboratory Code of Practice	740	0	625
1527	CO-PRD1-URS-026	User Requirement Specification for a Wireless Temperature and Humidity Monitoring System for Oak House Production and Storage Facility	745	0	1267
1528	CO-CS-FRM-175	io Inspection using Data Collection Cartridge Form	1076	0	939
1529	CO-PRD1-LBL-045	NG1 NG2 IC Primer Passivation Reagent Box Label	294	0	1260
1530	CO-DPT-BOM-010	2.600.903  CG3 Female  Kit BOM	773	0	1439
1531	CO-OPS-PTL-038	Blister Filling Rig and Cropping Press PQ Validation Protocol	27	0	817
1532	CO-LAB-FRM-079	‘Uracil DNA Glycosylase [50 thousand U/mL]’ Part Number 0240	768	0	669
1533	CO-QA-T-110	Document Retrieval Request	413	0	422
1534	CO-PRD1-FRM-182	Pipette Internal Verification Form	189	0	985
1535	CO-LAB-FRM-086	‘0260 CT Forward Primer from SGS DNA’	53	0	676
1536	CO-SUP-JA-068	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox MAX Shipper	915	0	1560
1537	CO-LAB-SOP-178	Operating Instructions for Signal Analyser	576	0	613
1538	CO-DPT-BOM-014	2.600.907  CG3 + Blood + Blood Female  Kit BOM	914	0	1443
1539	CO-OPS-SOP-229	Manufacture of CT/TV/IC Primer Buffer Reagent	467	0	794
1540	CO-LAB-FRM-127	‘TV_Alt_6_Fwd’ Part No. 0330 from SGS DNA	880	0	717
1541	CO-PRD1-SOP-312	Guidance for the completion of Reagent Production Manufacturing Batch Records  MBRs	3	0	1213
1542	CO-LAB-FRM-165	New Microorganism Introduction Checklist Form	565	0	860
1543	CO-OPS-SOP-088	Preparation of Neisseria gonorrhoeae 100 thousand Genome Equivalents/µL stocks	937	0	512
1544	CO-LAB-LBL-015	Consumables Label	324	0	895
1545	CO-LAB-FRM-093	Part No 0267 ‘NG Target 2 Reverse Primer’ from SGS DNA	858	0	683
1546	CO-LAB-REG-012	Part No Register	491	0	829
1547	CO-OPS-SOP-009	Reader Peltier Refit procedure	574	0	271
1548	CO-QA-SOP-274	Applicable Standards Management Procedure	130	0	1070
1549	CO-LAB-SOP-294	Standard Way of Making CT Dilutions	290	0	1128
1550	CO-LAB-SOP-169	Use of Fermant Pouch Sealer	179	0	604
1551	CO-DES-T-124	Design Transfer Form	602	0	436
1552	CO-PRD1-T-200	Manufacturing Batch Record  MBR  Template - DEV#28	471	0	1487
1553	CO-DPT-IFU-011	At-Home Female Triple Site Collection Kit IFU  English Digital Version	373	0	1010
1554	CO-SUP-FRM-209	Oak House Cycle Counting stock sheet	459	0	1243
1555	CO-PRD1-LBL-029	Storage temperature labels	796	0	984
1556	CO-PRD1-FRM-181	Oak House Monthly Production Facility Checklist	464	0	975
1557	CO-OPS-URS-009	User Requirement Specification for pH/mV/°C Meter	893	0	933
1558	CO-DES-SOP-042	Creation and Maintenance of a Device Master Record  DMR	143	0	484
1559	CO-DES-T-025	Validation Protocol template	49	0	310
1560	CO-PRD1-PTL-096	Oak House Labcold RLVF1517 Freezer 1183 Validation Protocol	197	0	1291
1561	CO-H&S-RA-014	Health and Safety Risk Assessment Oak House Facility	188	0	1538
1562	CO-LAB-PTL-045	IQ Protocol for Binder incubator and humidity chamber	792	0	846
1563	CO-H&S-RA-018	Health and Safety Risk Assessment Oak House Covid-19	882	0	1542
1564	CO-LAB-FRM-123	Part No. 0318  NATtrol Chlamydia trachomatis Positive Control	99	0	713
1565	CO-LAB-SOP-302	Preparation and use of agarose gels	355	0	1136
1566	CO-DPT-ART-003	STI Barcodes - 8 count label	625	0	1228
1567	CO-LAB-SOP-149	Introducing New Laboratory Equipment	628	0	581
1568	CO-DPT-ART-008	Vaginal STI Sample Collection Sticker	911	0	1238
1569	CO-PRD1-SOP-255	Mini Fuge Plus centrifuge SOP	284	0	961
1570	CO-OPS-T-020	Development Partner Ranking	533	0	305
1571	CO-QC-PTL-061	T7 Raw Material Spreadsheet Validation	657	0	1072
1572	CO-LAB-SOP-160	Use of the Miele Laboratory Glassware Washer G7804	993	0	595
1573	CO-LAB-FRM-141	Part No. 0345 CampyGen  sachets	194	0	731
1574	CO-QC-PTL-016	Validation Protocol -20 freezer/QC lab asset 0330	1061	0	796
1575	CO-LAB-FRM-099	‘Neisseria gonorrhoeae DNA’ Part Number 0273	895	0	689
1576	CO-PRD1-FRM-262	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQ	586	0	1381
1577	CO-LAB-SOP-155	Experimental Write Up	573	0	590
1578	CO-PRD1-SOP-269	Oak House Pipette Use and Calibration SOP	439	0	986
1579	CO-LAB-SOP-175	Out of Hours Power Loss and Temperature Monitoring	12	0	610
1580	CO-QC-PTL-067	CTNG NG/IC Primer passivation Validation	22	0	1079
1581	CO-LAB-FRM-125	10x TBE electrophoresis buffer Part Number 0326	231	0	715
1582	CO-QA-T-194	Declaration of Conformity Template	836	0	1471
1583	CO-DPT-IFU-026	It s as Easy as 123 Ft. the ADx Card Collection Method   English Version	912	0	1025
1584	CO-LAB-LBL-007	Expiry Dates Label	206	0	886
1585	CO-OPS-REG-029	binx health ltd Master Assay Code Register	15	0	867
1586	CO-PRD1-FRM-231	0.5M EDTA Oak House Production IQC	703	0	1347
1587	CO-QA-T-087	Standard / Guidance Review	731	0	399
1588	CO-SUP-SOP-055	Goods Movement	328	0	185
1589	CO-PRD1-FRM-243	y-Aminobutyric acid  GABA  Oak House Production IQC	8	0	1359
1590	CO-PRD1-FRM-247	IC di275 probe Oak House Production IQC	727	0	1363
1591	CO-LAB-FRM-069	Part No. 0118 IC Synthetic target HPLC GRADE	102	0	659
1592	CO-DPT-BOM-005	2.600.006  CG3 + Blood Male  Kit BOM	1063	0	1434
1593	CO-QA-SOP-284	FMEA Procedure	502	0	1109
1594	CO-SUP-SOP-074	UK Stock Procurement & Movements  Supply Chain	403	0	491
1595	CO-DES-PTL-005	IQ/OQ for Agilent Bioanalyzer	7	0	462
1596	CO-SUP-FRM-042	Supplier Questionnaire - Chemical/Reagent/Microbiological	647	0	365
1597	CO-LAB-SOP-004	Use of the Bolt Mini Gel Tank for protein Electrophoresis	985	0	266
1598	CO-PRD1-FRM-260	pH Buffer Bottle 4.01 Twin-neck Oak House Production IQC	19	0	1379
1599	CO-SUP-JA-026	Production Requests to Production Orders	892	0	1314
1600	CO-LAB-FRM-085	NG2 Synthetic Target Part no 0259	894	0	675
1601	CO-LAB-FRM-013	Triton x305	283	0	259
1602	CO-QC-QCP-052	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test  Part 0248	838	0	1122
1603	CO-PRD1-FRM-242	dUTP mix Oak House Production IQC	808	0	1358
1604	CO-DPT-ART-011	Urine STI Sample Collection Sticker	1038	0	1241
1605	CO-SUP-T-183	Oak House Packing List - Cartridge Reagent  -20°c	472	0	1416
1606	CO-DPT-BOM-015	2.600.908  CG Female  Kit BOM	320	0	1444
1607	CO-LAB-REG-021	Laboratory Responsibilities by Area	840	0	840
1608	CO-OPS-SOP-203	Manufacture of Wash Buffer II	712	0	768
1609	CO-DES-T-061	Verification Testing Report template	759	0	373
1610	CO-OPS-SOP-092	mSTI Cartridge Manufacture	213	0	516
1611	CO-LAB-FRM-122	Part No. 0317 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane’	685	0	712
1612	CO-OPS-SOP-110	225mM Potassium phosphate buffer	499	0	282
1613	CO-FIN-T-167	US Trade Credit Application	71	0	1095
1614	CO-DES-PTL-002	Validation of Abacus Guardian	945	0	453
1615	CO-IT-POL-031	Responsible Disclosure Policy	748	0	1189
1616	CO-OPS-SOP-174	Engineering Rework Procedure	399	0	609
1617	CO-CA-REG-031	Donor Number Consent Register	531	0	869
1618	CO-SUP-T-178	Reagent component pick list form	639	0	1304
1619	CO-QC-QCP-057	CTNG CTIC NG1IC and NG2IC Detection Reagents QC test	345	0	1141
1620	CO-LAB-FRM-023	6x DNA loading dye Atlas Part Number 0327	744	0	327
1621	CO-PRD1-LBL-036	NG1 IC Detection Reagent Vial Label	447	0	1251
1622	CO-SD-FRM-171	Code Review	860	0	891
1623	CO-LAB-FRM-140	Hot Start Taq  PCR Biosystems LTD  P/N:0344	947	0	730
1624	CO-LAB-FRM-207	Manipulated Material Aliquot form	1042	0	1226
1625	CO-IT-POL-024	Business Continuity and Disaster Recovery	679	0	1182
1626	CO-SUP-SOP-049	Receive Non-Stock PO	56	0	179
1627	CO-DES-SOP-041	Design Review Work Instruction	956	0	483
1628	CO-DES-T-065	Validation Master Plan  or Plan  template	1078	0	377
1629	CO-DES-PTL-007	Pilot Line Process & Equipment Validation	248	0	464
1630	CO-LAB-SOP-135	Guidance for Use and Completion of MFG Documents	986	0	557
1631	CO-SUP-SOP-041	Customer Sales Contracts	753	0	159
1632	CO-LAB-FRM-027	Dimethylsulfoxide Part Number 0227	812	0	520
1633	CO-PRD1-SOP-318	The use of the calibrated temperature probe	654	0	1222
1634	CO-DPT-IFU-029	binx Nasal Swab For Group Setting  English Print Version	675	0	1028
1635	CO-CA-FRM-041	Consent for Voluntary Donation of In-house Collected Samples	1054	0	534
1636	CO-PRD1-FRM-204	Calibrated Clock/Timer verification form	555	0	1209
1637	CO-LAB-LBL-024	Elution Reagent Label	519	0	904
1638	CO-LAB-SOP-180	Reconstitution of Lyophilised Materials	338	0	615
1639	CO-H&S-RA-010	Risk Assessment for work-related stress	162	0	1522
1640	CO-LAB-SOP-300	Preparation of Sub-circuit cards for voltammetric detection	30	0	1134
1641	CO-LAB-FRM-106	‘CT/NG: CT/IC Detection Reagent	261	0	696
1642	CO-SUP-SOP-048	Raise PO - non-Stock & Services	196	0	178
1643	CO-OPS-URS-011	User Requirement Specification for back up power supply	6	0	935
1644	CO-QA-POL-013	Policy for Complaints and Vigilance	665	0	579
1645	CO-SUP-SOP-054	Complete Production Order	39	0	184
1646	CO-LAB-SOP-156	Control of Controlled Laboratory Notes	228	0	591
1647	CO-DPT-BOM-012	2.600.905  Blood + Blood Unisex  Kit BOM	698	0	1441
1648	CO-OPS-PTL-021	Validation Protocol for Rotorgene	202	0	801
1649	CO-QA-POL-010	Policy for Control of Infrastructure Environment and Equipment	801	0	576
1650	CO-SUP-JA-023	Dry Ice Job aid  Oak House	201	0	1263
1651	CO-QA-JA-002	Legacy Document Number Crosswalk	819	0	854
1652	CO-OPS-PTL-039	OQ Validation Protocol Blister Filling Rig	1050	0	818
1653	CO-DPT-IFU-039	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit for Group Settings  English Version	658	0	1044
1654	CO-LAB-FRM-074	CT synthetic target containing Uracil Part no: 0168	48	0	664
1655	CO-SUP-T-172	Oak House Packing List - Cartridge Reagent  2-8°c	438	0	1275
1656	CO-LAB-SOP-183	Use of the Microcentrifuge 24	616	0	618
1657	CO-QC-PTL-066	CTNG CT/IC Primer passivation	977	0	1078
1658	CO-OPS-PTL-023	io Reader - Digital Pressure Regulator Calibration Protocol	80	0	803
1659	CO-LAB-FRM-008	Part No. 0117 Sterile Syringe filter with 0.2 µm cellulose acetate membrane	540	0	254
1660	CO-PRD1-FRM-233	Glycerol Oak House Production IQC	365	0	1349
1661	CO-QA-SOP-012	Annual Quality Objectives	966	0	148
1662	CO-LAB-REG-015	Stock Item Register	637	0	832
1663	CO-IT-POL-022	Access Control Policy	610	0	1180
1664	CO-QA-T-197	Summary Technical Documentation  STED  Template	159	0	1475
1665	CO-DPT-IFU-005	At-Home Vaginal Swab Collection Kit IFU  English Print Version	935	0	1004
1666	CO-PRD1-FRM-225	Potassium phosphate dibasic Oak House Production IQC	381	0	1341
1667	CO-LAB-FRM-126	50bp DNA Ladder binx Part Number 0329	769	0	716
1668	CO-LAB-FRM-002	Glycerol  For molecular biology	177	0	248
1669	CO-QA-FRM-194	Auditor Competency Assessment	298	0	1065
1670	CO-QC-QCP-071	Enzymatics Taq-B 25U/ul  Part 0270	640	0	1155
1671	CO-OPS-SOP-196	SOP to record the details of the manufacture of 75x PCR buffer	109	0	758
1672	CO-DPT-IFU-036	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad  English Version	634	0	1033
1673	CO-QC-T-107	Bioanalyzer Cleaning Record	583	0	419
1674	CO-IT-POL-028	Information Security Policy	455	0	1186
1675	CO-H&S-COSHH-012	COSHH Assessment - Inactivated Micro-organisms	310	0	1510
1676	CO-LAB-FRM-020	Elution Reagent	55	0	324
1677	CO-IT-POL-032	Risk Management	775	0	1190
1678	CO-PRD1-FRM-236	Triton X305 Oak House Production IQC	575	0	1352
1679	CO-DPT-BOM-004	2.600.500  Blood Unisex  Kit BOM	203	0	1433
1680	CO-SUP-JA-034	Raise Purchase Order – Non-stock & Services	343	0	1322
1681	CO-OPS-SOP-124	Glycerol Solution	1023	0	277
1682	CO-SUP-SOP-003	Procedure for Inventry Control and BIP	922	0	19
1683	CO-H&S-COSHH-004	COSHH Assessment - Chlorinated Solvents	1005	0	1503
1684	CO-SAM-T-101	Marketing template	488	0	413
1685	CO-SUP-SOP-051	Receive Stock Purchase Orders	383	0	181
1686	CO-LAB-LBL-026	CIR Label	424	0	906
1687	CO-LAB-SOP-016	Use of the Peqlab thermal cyclers	41	0	332
1688	CO-OPS-SOP-113	9.26pc  w.v  BSA in 208.3 mM Potassium Phosphate buffer	664	0	284
1689	CO-PRD1-FRM-234	Potassium phosphate monobasic Oak House Production IQC	899	0	1350
1690	CO-SUP-FRM-217	NG2 IC Detection Reagent Component Pick List Form	568	0	1308
1691	CO-SUP-SOP-281	Cartridge Component Stock Control Procedure	282	0	1104
1692	CO-QC-SOP-171	Quality Control Rounding Procedure	312	0	606
1693	CO-QC-T-030	pH Meter Calibration Form	971	0	315
1694	CO-QC-LBL-052	io Instrument Failure - For Engineering Inspection Label	918	0	1549
1695	CO-PRD1-PTL-099	Oak House MSC1800 Production Enclosure Asset 1168 Validation Protocol	300	0	1330
1696	CO-OPS-T-111	Generic Cartridge Subassembly Build	234	0	423
1697	CO-SUP-POL-017	Policy for Commercial Operations	613	0	1105
1698	CO-LAB-REG-020	Batch Retention Register	615	0	839
1699	CO-LAB-PTL-046	OQ protocol for binder incubator and humidity chamber	741	0	847
1700	CO-DPT-IFU-007	At-Home Vaginal Swab Collection Kit IFU  English Digital Version	504	0	1006
1701	CO-LAB-FRM-091	Part No 0265 ‘NG Target 1 RA Reverse Primer’ from SGS DNA	485	0	681
1702	CO-PRD1-SOP-259	Standard Use of Oak House Fridges	618	0	967
1703	CO-QA-SOP-345	Root Cause Analysis	810	0	144
1704	CO-PRD1-SOP-306	Manufacturing Overview for the binx Cartridge Reagent Manufacturing Facility	953	0	1176
1705	CO-SUP-T-201	Shipping Specification Template	883	0	1488
1706	CO-DPT-BOM-008	2.600.008  CG Male  Kit BOM	927	0	1437
1707	CO-QA-T-047	Individual Training Plan Template	955	0	359
1708	CO-DPT-IFU-031	binx At-Home Collection Kit Individual_Broad  English Version	281	0	1029
1709	CO-DPT-BOM-013	2.600.906  CG3 + Blood Female  Kit BOM	350	0	1442
1710	CO-QA-JA-015	QT9 Nonconforming Product Job Aid	904	0	1159
1711	CO-SUP-SOP-066	SAP Manager Approvals App	516	0	217
1712	CO-PRD1-PTL-089	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1172 Validation Protocol	992	0	1237
1713	CO-QA-SOP-237	QT9 - Periodic Review and Making Documents Obsolete	738	0	855
1714	CO-DPT-WEB-007	Privacy Policy  UTI Spanish	545	0	1089
1715	CO-OPS-PTL-020	Validation Protocol Temperature controlled storage/incubation	687	0	800
1716	CO-OPS-SOP-134	Manufacture of Trehalose in PCR Buffer	800	0	556
1717	CO-SUP-JA-062	AirSea 2-8°c Shipper Packing Instructions	337	0	1554
1718	CO-LAB-LBL-025	Equipment Not Maintained Do Not Use Label	376	0	905
1719	CO-QA-SOP-096	Analysis of Quality Data	609	0	539
1720	CO-QC-QCP-055	CT Plasmid Quantification - qPCR Test  Part No. 0348	222	0	1139
1721	CO-SUP-FRM-177	binx health Vendor Information Form	949	0	951
1722	CO-DES-T-066	Validation Matrix template	411	0	378
1723	CO-LAB-SOP-137	Variable Temperature Apparatus Monitoring	532	0	560
1724	CO-QC-T-121	Impulse Sealer Use Log	31	0	433
1725	CO-QC-T-105	T7 QC Testing Data Analysis	452	0	417
1726	CO-DPT-ART-012	BAO Sassy Little Box	346	0	1331
1727	CO-QA-REG-001	Change Management Register	357	0	493
1728	CO-QC-PTL-062	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test  Part no. 0225	92	0	1073
1729	CO-OPS-URS-012	User Requirement Specification for a Production Enclosure	973	0	936
1730	CO-LAB-SOP-078	Preparation of Bacterial Stocks  Master & Working	89	0	502
1731	CO-DPT-ART-006	COVID Pre-Printed PCR Label - 1D Barcode	999	0	1231
1732	CO-SUP-SOP-279	Stock take procedure	276	0	1102
1733	CO-OPS-SOP-008	Thermal Test Rig Set Up and Calibration	380	0	270
1734	CO-LAB-FRM-110	Part No. 0295 ‘Sterile Syringe Filter with 0.45µm Cellulose Acetate Membrane’	871	0	700
1735	CO-OPS-T-139	Cartridge and Packing Bill of Materials Template	210	0	451
1736	CO-SUP-SOP-044	Invoice Customers Manually	358	0	162
1737	CO-LAB-FRM-005	100bp low MW Ladder	200	0	251
1738	CO-DPT-VID-007	Anal Swab Sample Collection Video Transcript	163	0	1046
1739	CO-SUP-SOP-280	Setting Expiry Dates for Incoming Materials	440	0	1103
1740	CO-DES-PTL-001	Measuring pH values IQ/OQ Protocol	416	0	452
1741	CO-PRD1-SOP-310	The use of Calibrated Clocks/Timers	676	0	1208
1742	CO-OPS-SOP-122	Detection Surfactants Solution	632	0	343
1743	CO-H&S-PRO-006	Health and Safety Legislation Review Procedure	714	0	1530
1744	CO-OPS-SOP-166	Pneumatics Test Rig Set up and Calibration	348	0	601
1745	CO-LAB-FRM-089	Part No 0263 ‘IC Reverse Primer’ from SGS DNA	605	0	679
1746	CO-QA-T-143	Training Plan Quarterly Sign Off Form	211	0	457
1747	CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	168	0	574
1748	CO-DPT-IFU-013	123 At-Home Card  English Version	1010	0	1012
1749	CO-OPS-LBL-028	UN3316 cartridge label - use Avery J8173 labels to print	42	0	908
1750	CO-QA-T-086	Supplier Re-assessment Approval form	564	0	398
1751	CO-QC-SOP-173	Laboratory Investigation  LI  Procedure for Invalid Assays and Out of Specification  OOS  Results	683	0	608
1752	CO-LAB-SOP-103	Environmental Controls in the Laboratory	395	0	544
1753	CO-DES-T-036	Experimental template: Planning	653	0	321
1754	CO-SUP-SOP-323	Demand Planning	548	0	1245
1755	CO-PRD1-SOP-276	Label printing	404	0	1096
1756	CO-LAB-SOP-013	Balance calibration	890	0	329
1757	CO-SUP-SOP-040	New Customer Set-Up	739	0	158
1758	CO-H&S-RA-012	Health and Safety Risk Assessment for Use of a Butane Torch	612	0	1524
1759	CO-SUP-LBL-051	Shipping Contents Label	1043	0	1421
1760	CO-DPT-VID-004	Dry Blood Spot Card Video Transcript	847	0	1040
1761	CO-DPT-IFU-012	At-Home Female Triple Site Collection Kit IFU  Spanish Digital Version	823	0	1011
1762	CO-DPT-WEB-004	Terms of Service	108	0	1060
1763	CO-SUP-JA-028	Running Purchasing and Production Exception Reports	40	0	1316
1764	CO-QA-JA-021	QT9 SCAR Module Job Aid	811	0	1224
1765	CO-DPT-BOM-027	2.800.002  ADX Blood Card  2  Fasting  Kit BOM	562	0	1456
1766	CO-SUP-FRM-219	CT NG Taq UNG Reagent Component Pick List Form	120	0	1310
1767	CO-LAB-FRM-058	Part No. 0087 Buffer solution pH 10	851	0	647
1768	CO-DPT-WEB-003	Privacy Policy	638	0	1059
1769	CO-LAB-LBL-009	Quarantine - Failed calibration Label	1033	0	888
1770	CO-LAB-FRM-121	Part No. 0316 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.45 µm surfactant-free Cellulose Acetate Membrane’	600	0	711
1771	CO-PRD1-T-160	Oak House Production Facility Cleaning Record	35	0	973
1772	CO-LAB-LBL-006	Part No GRN Label	137	0	885
1773	CO-QA-SOP-004	Internal Audit	303	0	71
1774	CO-DES-PTL-008	Calibration of V&V Laboratory Timers	931	0	465
1775	CO-SUP-JA-027	Raising Inspection flag on stock material  SAP ByD	526	0	1315
1776	CO-DPT-IFU-017	At-Home Male Triple Site Collection Kit IFU  Spanish Digital Version	566	0	1016
1777	CO-LAB-SOP-161	Elix Deionised Water System	486	0	596
1778	CO-LAB-SOP-301	Preparation Microbiological Broth & Agar	152	0	1135
1779	CO-H&S-RA-011	Covid-19 Risk Assessment binx Health ltd	366	0	1523
1780	CO-PRD1-SOP-370	Manufacturing Overview for CT/NG Taq/UNG Reagent	932	0	1563
1781	CO-LAB-FRM-024	GelRed Nucleic Acid Stain Atlas Part Number 0328	117	0	328
1782	CO-SUP-SOP-061	New Project Set-Up	172	0	212
1783	CO-QA-POL-020	Risk Management Policy	16	0	1112
1784	CO-PRD1-SOP-303	Oak House Out of Hours Procedures	627	0	1156
1785	CO-QA-JA-013	QT9 Feedback Module Job Aid	646	0	1157
1786	CO-H&S-RA-009	Risk Assessment for use of Chemicals	631	0	1521
1787	CO-LAB-FRM-059	‘50mM dUTP MIX’ Part no. 0088	721	0	648
1788	CO-PRD1-FRM-229	MBG Water Oak House Production IQC	1029	0	1345
1789	CO-QA-REG-025	Supplier Risk Assessment Monitoring List	427	0	845
1790	CO-PRD1-FRM-245	DL-dithiothreitol  DTT  Oak House Production IQC	171	0	1361
1791	CO-PRD1-PTL-103	Oak House APC Schneider UPS Asset  1117 Validation Protocol	635	0	1391
1793	CO-QA-T-010	Policy Template	420	0	295
1794	CO-PRD1-FRM-258	pH Buffer Bottle 10.01 Twin-neck Oak House Production IQC	243	0	1377
1795	CO-QA-POL-015	Policy for the Use of Electronic Signatures within binx health	670	0	914
1796	CO-LAB-SOP-136	Solution Preparation SOP	510	0	559
1797	CO-LAB-FRM-192	TV Synthetic Target  P/N 0418	246	0	1045
1798	CO-QA-T-189	Post Market Performance Follow-up Plan Template	608	0	1466
1799	CO-LAB-SOP-006	Esco Laminar Flow Cabinet	735	0	268
1800	CO-PRD1-PTL-091	Oak House Labcold RLDF1519 Fridge 1157 Validation Protocol	770	0	1279
1801	CO-QC-LBL-032	Excess Raw Material Label	558	0	1116
1802	CO-OPS-T-043	Mutual Agreement of Confidentiality	174	0	355
1803	CO-SUP-FRM-214	CT IC Detection Reagent Component pick list form	758	0	1305
1804	CO-QC-T-073	Microbiology Laboratory Cleaning record	527	0	385
1805	CO-LAB-REG-014	GRN Register	34	0	831
1806	CO-IT-POL-026	Cryptography Policy	457	0	1184
1807	CO-DPT-IFU-018	At-Home Urine Collection Kit IFU  English Print Version	599	0	1017
1808	CO-CS-SOP-249	io Insepction using Data Collection Cartridge	594	0	938
1809	CO-PRD1-FRM-212	ME2002T/00 and ML104T/00 Balance Weight Verification Form	514	0	1174
1810	CO-PRD1-FRM-211	pH Meter Calibration form - 3 point	451	0	1210
1811	CO-PRD1-FRM-232	Brij- 58 Oak House Production IQC	1031	0	1348
1812	CO-DES-T-041	binx Technical Report Template	182	0	353
1813	CO-OPS-URS-008	Sprint B+ leak tester- User Requirement Specification	1060	0	930
1814	CO-QA-T-049	Document Acceptance Form	981	0	361
1815	CO-LAB-FRM-139	‘Tris  1M  pH8.0’ Part no: 0342	843	0	729
1816	CO-PRD1-FRM-191	Reagent Shipping Worksheet	136	0	999
1817	CO-PRD1-LBL-048	ERP GRN for Oak House Label-Rev_0	304	0	1383
1818	CO-OPS-PTL-010	Reader Installation Qualification Protocol	20	0	588
1819	CO-SUP-SOP-322	Supply Team Oak House Operations	264	0	1244
1820	CO-QC-SOP-293	dPCR Quantification of CT and NG Vircell Inputs	842	0	1127
1821	CO-QC-T-103	Lab investigation initiation Template	17	0	415
1822	CO-DPT-ART-005	COVID Pre-Printed PCR Label	648	0	1230
1823	CO-OPS-SOP-007	Firmware Up-date	765	0	269
1824	CO-DPT-BOM-018	2.601.003  CG Male AG  Kit BOM	386	0	1447
1825	CO-DPT-IFU-042	At-Home Blood Spot Collection Kit USPS IFU  English Digital Version	133	0	1049
1826	CO-QA-SOP-285	Hazard Analysis Procedure	291	0	1110
1827	CO-QC-T-102	CTNG Cartridge Cof A	863	0	414
1828	CO-H&S-T-202	Health and Safety Risk Assessment Template	165	0	1498
1829	CO-SUP-JA-031	Automatic MRP run set up and edit	29	0	1319
1830	CO-PRD1-JA-070	Protecting Light Sensitive Reagents with Tin Foil at the Oak House Manufacturing Facility	886	0	1564
1831	CO-PRD1-FRM-228	UNG Oak House Production IQC	877	0	1344
1832	CO-OPS-PTL-025	io Reader – Force End Test Protocol	360	0	805
1833	CO-PRD1-LBL-037	NG2 IC Detection Reagent Vial Label	342	0	1252
1834	CO-QA-T-012	Internal Training Form	913	0	297
1835	CO-SUP-SOP-070	Supplier Risk Assessment Approval and Monitoring Procedure	814	0	488
1836	CO-OPS-SOP-035	Engineering Drawing Control	781	0	477
1837	CO-QC-T-120	QC Laboratory Cleaning Record	43	0	432
1838	CO-PRD1-FRM-184	Certificate of conformance - CT IC primer passivation reagent	112	0	988
1839	CO-LAB-FRM-080	‘DNase Alert Buffer’ Part Number 0241	525	0	670
1840	CO-DES-T-083	product requirements Specification Template	702	0	395
1841	CO-DES-T-059	FMEA template	1012	0	371
1842	CO-SUP-JA-029	Purchase Order Acknowledgements	972	0	1317
1843	CO-IT-POL-027	Human Resource Security Policy	100	0	1185
1844	CO-DPT-IFU-028	binx Nasal Swab For Individual Setting  English Print Version	1082	0	1027
1845	CO-SUP-SOP-067	Managing Expired Identified Stock	684	0	218
1846	CO-LAB-SOP-181	Use of the Thermomixer HC block	821	0	616
1847	CO-QC-T-082	qPCR QC Testing Data Analysis	32	0	394
1848	CO-PRD1-FRM-250	CT reverse primer Oak House Production IQC	219	0	1366
1849	CO-SUP-JA-036	New Stock Adjustment	150	0	1324
1850	CO-DES-SOP-243	CE Mark/Technical File Procedure	51	0	15
1851	CO-DES-T-084	Pilot Line Electronic Stock Register	673	0	396
1852	CO-DES-T-064	Risk Management Report template	295	0	376
1853	CO-OPS-LBL-027	Interim CTNG CLIA Waiver Outer Shipper Label	101	0	907
1854	CO-DES-SOP-029	Design and Development Procedure	25	0	14
1855	CO-OPS-PTL-026	io® Reader – Thermal End Test Protocol	247	0	806
1856	CO-DES-T-114	Validation Summary Report	215	0	426
1857	CO-DPT-IFU-035	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location  English Version	401	0	1032
1858	CO-QA-T-123	CAPA date extension form	677	0	435
1859	CO-DPT-BOM-007	2.600.007  CG3 + Blood + Blood Male  Kit BOM	841	0	1436
1860	CO-H&S-COSHH-009	COSHH Assessment - Hazard Group 1 Pathogens	969	0	1508
1861	CO-QA-T-166	Device Specific List of Applicable Standards Form Template	869	0	1069
1862	CO-DES-SOP-371	Critical to Quality and Reagent Design Control	121	0	40
1863	CO-OPS-SOP-091	Manufacture of TV/IC Detection Reagent	47	0	515
1864	CO-QC-PTL-060	MOBY Detection Reagent Spreadsheet Validation Protocol	257	0	1066
1865	CO-OPS-SOP-119	Manufacture of NG1/NG2/IC Primer Passivation Reagent	444	0	281
1866	CO-LAB-T-198	Eupry Calibration Cover Sheet	543	0	1484
1867	CO-QA-T-048	Specimen Signature Log	352	0	360
1868	CO-OPS-PTL-037	Blister Cropping Press IQ and OQ Validation Protocol	509	0	816
1869	CO-SUP-T-182	Oak House Commercial Invoice - Cartridge Reagent  2-8°c	1079	0	1415
1870	CO-SUP-SOP-324	Packaging and Shipping Procedure for binx Cartridge Reagent	240	0	1246
1871	CO-LAB-SOP-164	Bambi compressor: Use and Maintenance	116	0	599
1872	CO-DES-T-068	Experimental Template: Write Up	369	0	380
1873	CO-OPS-PTL-051	Factory Acceptance Test  FAT  Sprint B+ In-line Leak Tester	729	0	927
1874	CO-LAB-FRM-051	WATER FOR MOLECULAR BIOLOGY Part Number 0005	487	0	639
1875	CO-OPS-SOP-125	IC DNA in TE Buffer 100pg/ul Working Stock Aliquots	250	0	278
1876	CO-QC-SOP-282	QC Sample Handling and Retention Procedure	289	0	1106
1877	CO-PRD1-PTL-104	Oak House APC Schneider UPS Asset  1118 Validation Protocol	757	0	1392
1878	CO-OPS-PTL-050	Factory Acceptance Test  FAT   TQC in-line leak test equipment	539	0	926
1879	CO-OPS-SOP-036	Instrument Engineering Change Management	1058	0	478
1880	CO-OPS-SOP-202	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	925	0	767
1881	CO-PRD1-PTL-086	Eupry Temperature Monitoring System Validation	756	0	1212
1882	CO-CS-FRM-267	Field Service Report Form	513	0	1473
1883	CO-QC-QCP-064	CT/NG: NG1/IC Detection Reagent	826	0	1148
1884	CO-DPT-BOM-006	2.600.006-001  CG3 + Blood Male BAO  Kit BOM	311	0	1435
1885	CO-DPT-ART-001	Outer bag label Nasal PCR Bag Bulk Kit	67	0	1035
1886	CO-OPS-SOP-120	CTNG Storage Buffer  224.3mM Potassium Phosphate	335	0	285
1887	CO-SUP-FRM-048	Supplier Questionnaire - Consultant/Services	784	0	367
1888	CO-QC-QCP-066	CT/NG: NG1/NG2/IC Primer-Passivation Reagent qPCR test	1071	0	1150
1889	CO-QC-T-137	Limited Laboratory Access Work Note	492	0	449
1890	CO-LAB-FRM-063	‘MES’ Part No. 0095	1051	0	652
1891	CO-PRD1-URS-021	User Requirement Specification for the binx Cartridge Reagent Manufacturing Lab UK	598	0	1161
1892	CO-PRD1-SOP-261	Cleaning Procedure for Oak House Production Facility	394	0	974
1893	CO-OPS-SOP-128	Preparation of TV 10 thousand cells/uL Master Stocks	878	0	347
1894	CO-DES-T-063	Risk/benefit template	28	0	375
1895	CO-SUP-SOP-001	Procedure for Commercial Storage and Distribution	1045	0	17
1896	CO-CS-SOP-248	Procedure For Customer Service	522	0	920
1897	CO-LAB-SOP-097	Wireless Temperature and Humidity Monitoring	498	0	540
1898	CO-SUP-SOP-052	New Supplier Set-Up	96	0	182
1899	CO-SUP-FRM-215	CT IC Primer Passivation Reagent Component Pick List Form	76	0	1306
1900	CO-PRD1-JA-044	Production suite air conditioning job aid	368	0	1376
1901	CO-LAB-FRM-114	Part Number 0300 Vircell MG DNA Control	974	0	704
1902	CO-PRD1-FRM-200	Manufacture of CT/IC Primer Passivation Reagent	255	0	1170
1903	CO-QC-T-028	Balance Calibration form	1025	0	313
1904	CO-QA-T-207	EU Performance Evaluation Report Template	88	0	1570
1905	CO-DPT-IFU-022	Blood Card Collection Kit IFU  Using ADx Card Fasting  English Print Version	1032	0	1021
1906	CO-LAB-SOP-129	Use of the Priorclave Autoclave	997	0	551
1907	CO-DPT-WEB-010	Terms of Service  Spanish	1053	0	1092
1908	CO-CS-T-149	Instrument Trouble Shooting Script	672	0	444
1909	CO-QC-PTL-109	QC CT/NG 2:2 Input Manufactured Under CO-OPS-SOP-189 Validation Protocol	1026	0	1571
1910	CO-QC-FRM-046	Micro Monthly Laboratory Checklist-Rev_0	430	0	836
1911	CO-SUP-SOP-053	Raise & Release Production Order	772	0	183
1912	CO-DES-T-140	Reagent Design Transfer Checklist	134	0	454
1913	CO-SUP-SOP-278	Pilot Line Electronic Stock Control	412	0	1101
1914	CO-OPS-SOP-087	Preparation of Neisseria gonorrhoeae 1 million Genome Equivalents/µL stocks	267	0	511
1915	CO-QC-PTL-074	CT/NG Cartridge QC Test Analysis Template Validation Protocol	113	0	1087
1916	CO-LAB-FRM-057	Part No. 0085 Buffer solution pH 4	547	0	646
1917	CO-LAB-SOP-170	Rapid PCR Rig Work Instructions	253	0	605
1918	CO-LAB-FRM-090	Part No 0264 ‘NG Target 1 Forward Primer’ from SGS DNA	861	0	680
1919	CO-SUP-POL-035	Cold Chain Shipping Policy	1062	0	1496
1920	CO-LAB-LBL-013	In process MFG material label	958	0	893
1921	CO-OPS-SOP-186	Use of the VPUMP Vacuum pump	554	0	621
1922	CO-QA-POL-006	Policy for Document Control and Change Management	719	0	563
1923	CO-DPT-BOM-023	2.601.903  CG3 Female AG  Kit BOM	910	0	1452
1924	CO-PRD1-LBL-047	IC DNA Reagent Box Label	825	0	1262
1925	CO-PRD1-SOP-308	Use of IKA Digital Roller Mixer	339	0	1179
1926	CO-LAB-FRM-072	‘Part No. 0148 DL-Dithiothreitol’	761	0	662
1927	CO-PRD1-FRM-197	Manufacture of NG1/IC Detection Reagent	478	0	1167
1928	CO-OPS-PTL-017	Validation Protocol: Thermal cycler IQ/OQ/PQ	660	0	797
1929	CO-SUP-SOP-042	Enter & Release Sales Orders	341	0	160
1930	CO-DPT-VID-005	Urine Sample Collection Video Transcript	983	0	1041
1931	CO-LAB-LBL-022	Quarantine Stock Item Label	777	0	902
1932	CO-LAB-FRM-120	Metronidazole resistant Trichomonas Vaginalis Cultured Stocks Part no. 0312	406	0	710
1933	CO-H&S-PRO-001	Health & Safety Fire Related Procedures	186	0	1525
1934	CO-DPT-IFU-019	At-Home Urine Collection Kit IFU  Spanish Print Version	127	0	1018
1935	CO-DPT-IFU-015	At-Home Male Triple Site Collection Kit IFU  Spanish Print Version	493	0	1014
1936	CO-OPS-SOP-165	Windows Software Update	701	0	600
1937	CO-QC-T-031	Dishwasher User Form	921	0	316
1938	CO-QC-QCP-062	QC release procedure for the Io Reader	920	0	1146
1939	CO-PRD1-LBL-039	CT NG Taq UNG Reagent Vial Label	390	0	1254
1940	CO-PRD1-FRM-203	Manufacture of IC DNA Reagent	496	0	1173
1941	CO-LAB-FRM-056	Part No. 0086 Buffer solution pH 7	724	0	645
1942	CO-PRD1-LBL-042	CT IC Primer Passivation Reagent Box Label	44	0	1257
1943	CO-OPS-SOP-187	Force Test Rig Set up and Calibration	970	0	622
1944	CO-H&S-P-001	Health and Safety Policy	570	0	1532
1945	CO-PRD1-URS-025	URS for temp-controlled equipment for Oak House: Refrigerator Models: RLDF0519 and RLDF1519  freestanding and under bench   -20°C Freezer Models: RLV	659	0	1266
1946	CO-DPT-IFU-043	At-Home Blood Spot Collection Kit USPS IFU  Spanish Digital Version	529	0	1050
1947	CO-QA-SOP-267	Post Market Surveillance	1009	0	146
1948	CO-SUP-SOP-320	Oak House Supply Chain Reagent Production Process Flow	216	0	1227
1949	CO-QA-SOP-139	Change Management Procedure for Product/Project Documents	512	0	562
1950	CO-LAB-LBL-010	Failed Testing - Not in use Label	91	0	889
1951	CO-OPS-PTL-108	VAL2023-06 NetSuite Test Specification_QT9	154	0	1567
1952	CO-QA-T-045	Additional Training Form	274	0	357
1953	CO-DPT-WEB-001	COVID Consent	110	0	1056
1954	CO-QC-T-051	Controlled Lab Notes Template	275	0	363
1955	CO-QA-REG-023	Master Archive Register	10	0	843
1956	CO-OPS-PTL-031	EOL thermal test 21011-MET-012 Thermal-PCR Cycle Template for TTDL-No.2.xlsx v4.0	170	0	811
1957	CO-OPS-SOP-114	9.26pc  w.v  NZ Source BSA in 208.3mM Potassium Phosphate buffer	508	0	283
1958	CO-LAB-FRM-054	Part No. 0014 ‘Potassium Chloride’	697	0	643
1959	CO-PRD1-SOP-313	Use of Membrane Filters in the binx Reagent Manufacturing Facility	834	0	1214
1960	CO-CS-SOP-368	Instrument Service & Repair Procedure	1041	0	18
1961	CO-QC-QCP-056	Release procedure for CT/NG cartridge	967	0	1140
1962	CO-QA-T-153	Job Aid Template	93	0	853
1963	CO-PRD1-COP-003	Oak House Production Facility Code of Practice	326	0	971
1964	CO-OPS-SOP-228	Manufacture of Ab-HS Taq/UNG Reagent	980	0	793
1965	CO-QC-T-155	CTNG QC Cartridge Analysis Module	153	0	915
1966	CO-H&S-COSHH-006	COSH-Assessment - Corrosive Acids	315	0	1505
1967	CO-DPT-VID-003	Oral Swab Sample Collection Video Transcript	668	0	1039
1968	CO-PRD1-FRM-249	CT forward primer Oak House production IQC	1028	0	1365
1969	CO-OPS-T-152	Manufacturing Procedure  MFG  Template	1015	0	849
1970	CO-DES-T-125	Software Development Tool Approval	988	0	437
1971	CO-QC-JA-011	Use of CO-QC-T-118: Detection Reagent Analysis Spreadsheet	323	0	1117
1972	CO-SUP-SOP-321	Incoming Goods Procedure for deliveries into Oak House Manufacturing Site	788	0	1233
1973	CO-OPS-SOP-127	Potassium Phosphate Buffer	541	0	340
1974	CO-OPS-T-001	Material Transfer Agreement	667	0	286
1975	CO-QC-T-029	Incubator Monitoring Form	854	0	314
1976	CO-SUP-URS-017	User Requirement Specification for ByD for binx Reagent Manufacturing Facility	473	0	946
1977	CO-FIN-FRM-282	Fixed Asset Transfer Form	214	0	434
1978	CO-OPS-PTL-024	io Reader - Pneumatics End Test Protocol	991	0	804
1979	CO-OPS-POL-011	WEEE Policy	822	0	577
1980	CO-PRD1-T-199	Oak House Manufacturing Overview SOP Template	709	0	1486
1981	CO-LAB-SOP-145	Handling Biological Materials	989	0	570
1982	CO-DPT-IFU-023	Blood Card Collection Kit IFU  Using the ADx Card Fasting  English Digital Version	715	0	1022
1983	CO-QA-REG-007	Bacterial Stock Register	37	0	501
1984	CO-H&S-RA-013	Risk Assessment - Fire - Derby Court and Unit 6	97	0	1536
1985	CO-DPT-IFU-001	At-Home Blood Spot Collection Kit IFU  English Print Version	590	0	1000
1986	CO-OPS-T-130	Equipment Fulfilment Order	643	0	442
1987	CO-PRD1-LBL-035	CT IC Primer Passivation Reagent Vial Label	950	0	1250
1988	CO-QA-REG-022	Vigilance Register	158	0	841
1989	CO-PRD1-LBL-043	NG1 IC Detection Reagent Box Label	994	0	1258
1990	CO-OPS-SOP-002	Planning for Process Validation	572	0	24
1991	CO-PRD1-SOP-304	Management of Critical and Controlled Equipment at Oak House Production Facility	587	0	1162
1992	CO-PRD1-PTL-087	Oak House Mettler Toledo ME2002T_00 Precision Balance Asset 1170 Validation Protocol	518	0	1235
1993	CO-SUP-SOP-277	Instructions for Receipt of incoming Stock goods assigning GRN No.s & Labelling	680	0	1100
1994	CO-PRD1-FRM-198	Manufacture of NG2/IC Detection Reagent	316	0	1168
1995	CO-PRD1-SOP-268	Transfer of reagent QC samples	968	0	983
1996	CO-PRD1-PTL-090	Oak House Haier DW-86L338J Freezer 1155 Validation Protocol	622	0	1278
1997	CO-LAB-FRM-066	C. trachomatis serotype F Elementary Bodies Part No. 0106	1077	0	656
1998	CO-PRD1-T-179	Template for IQC for Oak House	820	0	1333
1999	CO-OPS-PTL-022	Validation Protocol - V&V Laboratory Facilities	889	0	802
2000	CO-SUP-JA-063	Softbox TempCell F39  13-48  Dry ice shipper packing instructions	173	0	1555
2001	CO-QC-T-115	Incoming Oligo QC Form	881	0	427
2002	CO-PRD1-PTL-075	Oak House Environmental Control System Validation Protocol	951	0	1097
2003	CO-QA-T-038	binx Memorandum Template	497	0	350
2004	CO-OPS-SOP-112	600pM Stocks of Synthetic Uracil containing Amplicon	606	0	345
2005	CO-SUP-SOP-037	Complete QC Inspections	370	0	155
2006	CO-DPT-BOM-028	2.801.001  ADX Blood Card  1 Non-fasting  Kit BOM	2	0	1457
2007	CO-PRD1-FRM-255	NG2 forward primer Oak House Production IQC	919	0	1371
2008	CO-LAB-FRM-097	‘0271 gyrA_F_Fwd primer’	1	0	687
2009	CO-H&S-RA-006	Risk Assessment - use of UV irradiation in the binx health Laboratories	364	0	1518
2010	CO-SUP-SOP-043	Mark Sales Orders as Despatched	807	0	161
2011	CO-OPS-PTL-040	IQ Validation Protocol Blister Filling Rig	59	0	819
2012	CO-LAB-SOP-291	Preparation of 10X and 1X TAE Buffer	363	0	1125
2013	CO-QC-SOP-299	io Reader interface - barcode scan rate	128	0	1133
2014	CO-OPS-SOP-111	50U/uL T7 Exonuclease in CTNG Storage Buffer	579	0	346
2015	CO-PRD1-LBL-044	NG2 IC Detection Reagent Box Label	538	0	1259
2016	CO-OPS-SOP-198	Manufacture of microorganism glycerol stocks	604	0	763
2017	CO-PRD1-FRM-251	IC  forward primer Oak House Production IQC	782	0	1367
2018	CO-OPS-SOP-118	Manufacture of CT/IC Primer Passivation Reagent	976	0	280
2019	CO-PRD1-PTL-088	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1171 Validation Protocol	845	0	1236
2020	CO-H&S-RA-005	Flammable & Explosive Substances Risk Assessment for  binx health Ltd  Derby Court and Unit 6	175	0	1517
2021	CO-LAB-FRM-052	SODIUM CHLORIDE Part Number 0008	292	0	641
2022	CO-LAB-FRM-076	Part Number 0188 Vircell CT DNA Control	270	0	666
2023	CO-DPT-WEB-005	Non-COVID Consent	64	0	1061
2024	CO-SUP-FRM-210	Oak House Re-Order form for Supply Chain	26	0	1248
2025	CO-QA-T-042	binx Meeting Minutes Template	83	0	354
2026	CO-SUP-SOP-047	Transfer Orders	94	0	177
2027	CO-QC-PTL-069	Testing and Release of Raw Materials & Formulated Reagents	1070	0	1082
2028	CO-LAB-FRM-050	Incoming Quality Control and Specification for ‘CMO Manufactured io® Cartridges’	816	0	627
2029	CO-QC-SOP-094	Procedure to Control Chemical and Biological Spillages	269	0	537
2030	CO-DES-T-067	Hazard Analysis template	1037	0	379
2031	CO-LAB-FRM-026	T7 Gene 6 Exonuclease 1000U/µL	536	0	519
2032	CO-QA-SOP-098	Document Matrix	1066	0	66
2033	CO-LAB-FRM-103	CT/NG: NG1/IC Detection Reagent	663	0	693
2034	CO-DES-PTL-006	Balance IQ/OQ	52	0	463
2035	CO-LAB-SOP-289	Standard Procedures for use in the Development of the CT/NG Assay	286	0	1123
2036	CO-QC-T-009	Template for IQC	963	0	294
2037	CO-PRD1-SOP-319	Jenway 3510 model pH Meter with ATC probe and 924 30 6.0mm model Tris electrode SOP in Oak House	1030	0	1223
2038	CO-QA-SOP-099	Deviation Procedure	379	0	541
2039	CO-H&S-RA-004	Risk Assessment - io® reader / assay development tools	791	0	1516
2040	CO-QC-T-076	Environmental Chamber Monitoring Form	490	0	388
2041	CO-SUP-SOP-013	Customer Returns	449	0	38
2042	CO-OPS-SOP-090	MFG for preparing male and female urine with 10% eNAT	160	0	514
2043	CO-SUP-JA-056	Use of Sensitech data loggers	327	0	1420
2044	CO-PRD1-SOP-265	Oak House Emergency Procedures	236	0	981
2045	CO-LAB-SOP-014	Thermo Orion Star pH meter	139	0	330
2046	CO-LAB-LBL-054	GRN for R&D and Samples Label  Silver	190	0	1584
2047	CO-OPS-PTL-049	vT flow and leak tester- FAT protocol	278	0	925
2048	CO-LAB-SOP-177	Operating instruction for the QuantStudio 3D digital PCR system	500	0	612
2049	CO-H&S-RA-017	Health and Safety Oak House Fire Risk Assessment	239	0	1541
2050	CO-DPT-IFU-038	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit IFU  English Version	789	0	1043
2051	CO-DPT-ART-010	Anal STI Sample Collection Sticker	879	0	1240
2052	CO-LAB-SOP-176	Guidance for the use and completion of IQC documents	378	0	611
2053	CO-LAB-FRM-276	High Risk Temperature Controlled Asset Sign	185	0	1544
2054	CO-IT-POL-023	Asset Management Policy	887	0	1181
2055	CO-QA-SOP-024	Sharepoint Administration	140	0	467
2056	CO-LAB-FRM-206	Water/Eultion Buffer  aliquot form	227	0	1225
2057	CO-LAB-SOP-163	Running Cartridges on io Readers	747	0	598
2058	CO-PRD1-PTL-102	Oak House APC Schneider UPS Asset  1116 Validation Protocol	318	0	1390
2059	CO-FIN-T-134	UK Trade Credit Application	652	0	446
2060	CO-PRD1-LBL-046	CT NG Taq UNG Reagent Box Label	147	0	1261
2061	CO-H&S-RA-003	Risk Assessment - Laboratory Areas  excluding Microbiology and Pilot line	384	0	1515
2062	CO-LAB-SOP-108	Laboratory Cleaning	856	0	548
2063	CO-OPS-PTL-036	Validation Protocol: 21011-MET012 Thermal - PCR Cycle Results Template Master	418	0	815
2064	CO-OPS-SOP-142	CTNG T7 Diluent	693	0	566
2065	CO-QA-T-145	Certificate of Conformance	695	0	459
2066	CO-QC-T-128	LAB investigation summary report	397	0	440
2067	CO-LAB-SOP-002	Agilent Bioanalyzer SOP for RNA 6000 Pico and Nano Kits	1019	0	264
2068	CO-DPT-T-168	Digital Feature Template	445	0	1099
2069	CO-SUP-JA-047	Demand Plan - Plan and Release	256	0	1398
2070	CO-DPT-BOM-022	2.601.902  CG + Blood Female AG  Kit BOM	501	0	1451
2071	CO-QC-QCP-059	CT/NG Collection Kit Batch Release	556	0	1143
2072	CO-DPT-IFU-008	At-Home Vaginal Swab Collection Kit IFU  Spanish Digital Print	730	0	1007
2073	CO-OPS-SOP-206	Manufacture of 1.5 M Trehalose	340	0	771
2074	CO-DPT-IFU-006	At-Home Vaginal Swab Collection Kit IFU  Spanish Print Version	415	0	1005
2075	CO-QA-T-078	Field Action Implementation Checklist	589	0	390
2076	CO-PRD1-FRM-256	NG2 reverse primer Oak House Production IQC	385	0	1372
2077	CO-SUP-SOP-068	Purchasing SOP	607	0	481
2078	CO-PRD1-FRM-254	NG1 Reverse primer Oak House Production IQC	876	0	1370
2079	CO-LAB-URS-001	Binder incubator and humidity chamber User Requirement Specification	655	0	850
2080	CO-LAB-SOP-295	Environmental Contamination testing	909	0	1129
2081	CO-LAB-SOP-153	Use of UV Cabinets	578	0	585
2082	CO-PRD1-FRM-252	IC reverse primer Oak House Production IQC	396	0	1368
2083	CO-OPS-SOP-189	CT/NG ATCC Input Generation	553	0	628
2084	CO-LAB-FRM-007	0.5M EDTA solution	824	0	253
2085	CO-PRD1-SOP-257	Standard Use of Oak House Freezers	495	0	964
2086	CO-LAB-FRM-094	NG1 Taqman Probe HPLC GRADE Part no 0268	474	0	684
2087	CO-QA-POL-014	Policy for the Control of Non-Conforming Product and Corrective/Preventive Action	61	0	859
2088	CO-SUP-SOP-056	Check Sales Order due Date	597	0	186
2089	CO-PRD1-FRM-237	Trizma base Oak House production IQC	178	0	1353
2090	CO-DPT-BOM-020	2.601.006  CG3 + Blood Male AG  Kit BOM	1021	0	1449
2091	CO-LAB-FRM-070	Part No. 0125 Potassium Phospate Monobasic	123	0	660
2092	CO-LAB-SOP-131	Pipette Use and Calibration SOP	60	0	553
2093	CO-DPT-ART-004	ADX Blood Card Barcode QR Labels	126	0	1229
2094	CO-LAB-SOP-287	Introduction of New microorganisms SOP	1007	0	1120
2095	CO-QA-T-044	Training Competence Assessment Form	144	0	356
2096	CO-SUP-SOP-058	Inspection Plans	907	0	209
2097	CO-SUP-FRM-269	Shipping Specification: CT/NG io Cartridge	98	0	1490
2098	CO-QA-SOP-147	Managing an External Regulatory Visit from the FDA	862	0	572
2099	CO-QC-T-032	Equipment Log	960	0	317
2100	CO-SUP-SOP-231	New Items	867	0	823
2101	CO-CA-POL-009	Verification and Validation Policy	377	0	575
2102	CO-LAB-SOP-020	Use of the Hulme Martin Pmpulse heat Sealer	1011	0	336
2103	CO-PRD1-FRM-253	NG1 forward primer Oak House Production IQC	803	0	1369
2104	CO-DPT-BOM-026	2.800.001  ADX Blood Card  1  Fasting  Kit BOM	595	0	1455
2105	CO-DPT-IFU-021	At-Home Urine Collection Kit IFU  Spanish Digital Version	571	0	1020
2106	CO-DPT-BOM-016	2.600.909  HIV USPS Blood Card  Kit BOM	626	0	1445
2107	CO-QA-JA-014	QT9 Corrective Action Module Job Aid	1074	0	1158
2108	CO-LAB-FRM-041	Incoming Quality Control and Specification for ‘NG1 Plasmid in TE buffer’ Materials binx Part Number: 0346	374	0	631
2109	CO-PRD1-PTL-100	Oak House Roto-Therm H2024-E Hybridisation Oven Asset 1113 Validation Protocol	72	0	1332
2110	CO-H&S-COSHH-003	COSHH Assessment - Flammable Materials	161	0	1502
2111	CO-DPT-ART-009	Oral STI Sample Collection Sticker	322	0	1239
2112	CO-QC-T-138	Summary technical Documentation  for assay	280	0	450
2113	CO-LAB-LBL-003	Approved material label	995	0	882
2140	CO-LAB-FRM-100	‘CT/NG: IC DNA Reagent	641	0	690
2141	CO-OPS-SOP-192	Verification Testing Process SOP	776	0	638
2142	CO-QA-SOP-011	Supplier Corrective Action Response Procedure	407	0	147
2143	CO-PRD1-FRM-223	Potassium Chloride Oak House Production IQC	764	0	1339
2144	CO-LAB-SOP-152	Instrument Failure Reporting SOP	265	0	584
2145	CO-DPT-IFU-025	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting   English Digital Version	124	0	1024
2146	CO-QA-REG-024	Archived Document Retrieval Log	81	0	844
2147	CO-PRD1-FRM-226	Taq-B Oak House Production IQC	235	0	1342
2148	CO-PRD1-LBL-050	SAP Code ERP GRN Label-Rev_0	569	0	1385
2149	CO-PRD1-SOP-355	Manufacturing Overview for Detection Reagents	902	0	1462
2150	CO-LAB-SOP-010	Reagent Deposition and Immobilisation  Pilot Line	987	0	272
2151	CO-LAB-FRM-067	Sarcosine’ Part no: 0108	66	0	657
2152	CO-H&S-P-003	Health and Safety Stress Management Policy	258	0	1534
2153	CO-HR-POL-007	Training Policy	184	0	573
2154	CO-QC-SOP-185	Use of the SB3 Rotator	351	0	620
2155	CO-QC-T-118	Moby Detection Reagent Analysis Spreadsheet	799	0	430
2156	CO-IT-REG-028	Controlled Laboratory Equipment Software List	733	0	866
2157	CO-QC-PTL-065	Taq-B raw material and CT/NG Taq UNG Reagent Validation	446	0	1077
2158	CO-LAB-SOP-017	Use of the Jenway Spectrophotometer	169	0	333
2159	CO-QC-FRM-049	QC Monthly Laboratory Checklist	195	0	624
2160	CO-DES-T-112	Pilot Line Use Log	530	0	424
2161	CO-OPS-SOP-132	Manufacture of Elution Buffer Revision 2	817	0	554
2162	CO-CS-T-131	Customer Service Script	767	0	443
2163	CO-SUP-JA-067	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox PRO Shipper	297	0	1559
2164	CO-SUP-JA-038	Transfer Order	785	0	1326
2165	CO-QC-PTL-068	CTNG Detection Reagent Validation	601	0	1080
2166	CO-QA-T-146	QT9 SOP Template	584	0	471
\.


--
-- Data for Name: document_list2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_list2 (doc_id, documentqtid, documenttitle, documenttype, risklevel) FROM stdin;
14	CO-DES-SOP-029	Design and Development Procedure	25	0
15	CO-DES-SOP-243	CE Mark/Technical File Procedure	51	0
16	CO-DES-SOP-004	Software Development Procedure	778	0
17	CO-SUP-SOP-001	Procedure for Commercial Storage and Distribution	1045	0
18	CO-CS-SOP-368	Instrument Service & Repair Procedure	1041	0
19	CO-SUP-SOP-003	Procedure for Inventry Control and BIP	922	0
21	CO-SUP-SOP-005	New Customer Procedure	620	0
22	CO-SUP-SOP-006	Equipment Fulfilment and Field Visit SOP for non-stock instruments	429	0
24	CO-OPS-SOP-002	Planning for Process Validation	572	0
38	CO-SUP-SOP-013	Customer Returns	449	0
40	CO-DES-SOP-371	Critical to Quality and Reagent Design Control	121	0
41	CO-DES-SOP-372	Reagent Design Transfer process	896	0
65	CO-QA-SOP-140	Document Control Procedure  Projects	57	0
65	CO-QA-SOP-140	Document Control Procedure (Projects)	57	0
66	CO-QA-SOP-098	Document Matrix	1066	0
69	CO-QA-SOP-005	Document and Records Archiving	560	0
70	CO-QA-SOP-003	Nonconforming Product Procedure	805	0
71	CO-QA-SOP-004	Internal Audit	303	0
73	CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	833	0
74	CO-QA-SOP-007	Correction Removal and Recall Procedure	135	0
85	CO-SUP-SOP-025	Quality Control	1034	0
144	CO-QA-SOP-345	Root Cause Analysis	810	0
146	CO-QA-SOP-267	Post Market Surveillance	1009	0
147	CO-QA-SOP-011	Supplier Corrective Action Response Procedure	407	0
148	CO-QA-SOP-012	Annual Quality Objectives	966	0
151	CO-QA-SOP-015	Qualification and Competence of Auditors	242	0
152	CO-QA-SOP-016	Identification and Traceabillity	582	0
155	CO-SUP-SOP-037	Complete QC Inspections	370	0
156	CO-SUP-SOP-038	Change of Stock (QC Release)	249	0
156	CO-SUP-SOP-038	Change of Stock  QC Release	249	0
157	CO-SUP-SOP-039	Manage Quality Codes	1083	0
158	CO-SUP-SOP-040	New Customer Set-Up	739	0
159	CO-SUP-SOP-041	Customer Sales Contracts	753	0
160	CO-SUP-SOP-042	Enter & Release Sales Orders	341	0
161	CO-SUP-SOP-043	Mark Sales Orders as Despatched	807	0
162	CO-SUP-SOP-044	Invoice Customers Manually	358	0
163	CO-SUP-SOP-045	Cutomer Price Lists	874	0
164	CO-SUP-SOP-046	Create New Customer Return	484	0
177	CO-SUP-SOP-047	Transfer Orders	94	0
178	CO-SUP-SOP-048	Raise PO - non-Stock & Services	196	0
179	CO-SUP-SOP-049	Receive Non-Stock PO	56	0
180	CO-SUP-SOP-050	Raise PO - Stock Items	933	0
181	CO-SUP-SOP-051	Receive Stock Purchase Orders	383	0
182	CO-SUP-SOP-052	New Supplier Set-Up	96	0
183	CO-SUP-SOP-053	Raise & Release Production Order	772	0
184	CO-SUP-SOP-054	Complete Production Order	39	0
185	CO-SUP-SOP-055	Goods Movement	328	0
186	CO-SUP-SOP-056	Check Sales Order due Date	597	0
208	CO-SUP-SOP-057	Consume to Cost Centre or Project	453	0
209	CO-SUP-SOP-058	Inspection Plans	907	0
210	CO-SUP-SOP-059	Credit Customer Returns	1046	0
211	CO-SUP-SOP-060	Customer Returns	238	0
212	CO-SUP-SOP-061	New Project Set-Up	172	0
213	CO-SUP-SOP-062	Add Team Member to a Task	192	0
214	CO-SUP-SOP-063	Book Time Against A Project	18	0
215	CO-SUP-SOP-064	Create a PO Within a Project	435	0
216	CO-SUP-SOP-065	Complete a Time Sheet	146	0
217	CO-SUP-SOP-066	SAP Manager Approvals App	516	0
218	CO-SUP-SOP-067	Managing Expired Identified Stock	684	0
245	CO-SAM-SOP-009	Control of Marketing and Promotion	1048	0
247	CO-LAB-FRM-001	Part No 0001 Agarose	125	0
248	CO-LAB-FRM-002	Glycerol (For molecular biology)	177	0
248	CO-LAB-FRM-002	Glycerol  For molecular biology	177	0
249	CO-LAB-FRM-003	Ethanol (Absolute)	296	0
249	CO-LAB-FRM-003	Ethanol  Absolute	296	0
250	CO-LAB-FRM-004	TRIS  TRIZMA  Base	691	0
250	CO-LAB-FRM-004	TRIS (TRIZMA) Base	691	0
251	CO-LAB-FRM-005	100bp low MW Ladder	200	0
252	CO-LAB-FRM-006	Triton X-100	549	0
253	CO-LAB-FRM-007	0.5M EDTA solution	824	0
254	CO-LAB-FRM-008	Part No. 0117 Sterile Syringe filter with 0.2 µm cellulose acetate membrane	540	0
255	CO-LAB-FRM-009	D- + -Trehalose Dihydrate	458	0
255	CO-LAB-FRM-009	D-(+)-Trehalose Dihydrate	458	0
256	CO-LAB-FRM-010	2mL ENAT Transport media	651	0
257	CO-LAB-FRM-011	Part no. 0141 Albumin from Bovine serum	1075	0
258	CO-LAB-FRM-012	Microbank Cryovials	260	0
259	CO-LAB-FRM-013	Triton x305	283	0
260	CO-LAB-FRM-014	Part No 0180 Brij 58	149	0
261	CO-LAB-FRM-015	Part No 0181 ROSS fill solution pH Electrode	794	0
262	CO-LAB-FRM-016	CT Taqman Probe  FAM	84	0
262	CO-LAB-FRM-016	CT Taqman Probe (FAM)	84	0
263	CO-LAB-FRM-017	IC Taqman Probe (FAM)	87	0
263	CO-LAB-FRM-017	IC Taqman Probe  FAM	87	0
264	CO-LAB-SOP-002	Agilent Bioanalyzer SOP for RNA 6000 Pico and Nano Kits	1019	0
265	CO-LAB-SOP-003	Validation of Temperature Controlled Equipment	118	0
266	CO-LAB-SOP-004	Use of the Bolt Mini Gel Tank for protein Electrophoresis	985	0
267	CO-LAB-SOP-005	Rhychiger Heat Sealer	230	0
268	CO-LAB-SOP-006	Esco Laminar Flow Cabinet	735	0
269	CO-OPS-SOP-007	Firmware Up-date	765	0
270	CO-OPS-SOP-008	Thermal Test Rig Set Up and Calibration	380	0
271	CO-OPS-SOP-009	Reader Peltier Refit procedure	574	0
272	CO-LAB-SOP-010	Reagent Deposition and Immobilisation (Pilot Line)	987	0
272	CO-LAB-SOP-010	Reagent Deposition and Immobilisation  Pilot Line	987	0
273	CO-LAB-SOP-011	Eppendorf 5424 Centrifuge	36	0
274	CO-LAB-SOP-012	Binder KBF-115 Oven	901	0
277	CO-OPS-SOP-124	Glycerol Solution	1023	0
278	CO-OPS-SOP-125	IC DNA in TE Buffer 100pg/ul Working Stock Aliquots	250	0
279	CO-OPS-SOP-117	Manufacture of IC DNA Reagent’	477	0
280	CO-OPS-SOP-118	Manufacture of CT/IC Primer Passivation Reagent	976	0
281	CO-OPS-SOP-119	Manufacture of NG1/NG2/IC Primer Passivation Reagent	444	0
282	CO-OPS-SOP-110	225mM Potassium phosphate buffer	499	0
283	CO-OPS-SOP-114	9.26pc (w.v) NZ Source BSA in 208.3mM Potassium Phosphate buffer	508	0
283	CO-OPS-SOP-114	9.26pc  w.v  NZ Source BSA in 208.3mM Potassium Phosphate buffer	508	0
284	CO-OPS-SOP-113	9.26pc (w.v) BSA in 208.3 mM Potassium Phosphate buffer	664	0
284	CO-OPS-SOP-113	9.26pc  w.v  BSA in 208.3 mM Potassium Phosphate buffer	664	0
285	CO-OPS-SOP-120	CTNG Storage Buffer (224.3mM Potassium Phosphate	335	0
285	CO-OPS-SOP-120	CTNG Storage Buffer  224.3mM Potassium Phosphate	335	0
286	CO-OPS-T-001	Material Transfer Agreement	667	0
287	CO-OPS-T-002	Material Transfer Agreement  binx recipient	926	0
287	CO-OPS-T-002	Material Transfer Agreement (binx recipient)	926	0
288	CO-SUP-T-003	binx Purchase Order Form	314	0
289	CO-DES-T-004	Design Review Record	1064	0
290	CO-DES-T-005	Phase Review Record	207	0
292	CO-QA-T-007	External Change Notification Form	462	0
293	CO-QA-T-008	Change Management Form	964	0
294	CO-QC-T-009	Template for IQC	963	0
295	CO-QA-T-010	Policy Template	420	0
296	CO-QA-T-011	Form Template	437	0
297	CO-QA-T-012	Internal Training Form	913	0
301	CO-QC-T-016	Lab Cleaning Form	804	0
304	CO-OPS-T-019	Manufacturing Partner Ranking Criteria	166	0
305	CO-OPS-T-020	Development Partner Ranking	533	0
306	CO-OPS-T-021	Generic PSP Ranking Criteria  template	277	0
306	CO-OPS-T-021	Generic PSP Ranking Criteria (template)	277	0
307	CO-DES-T-022	IVD Directive - Essential Requirements Check List Template	122	0
308	CO-QC-T-023	Solution Preparation Form	645	0
310	CO-DES-T-025	Validation Protocol template	49	0
311	CO-FIN-T-026	IT GAMP Evaluation Form	965	0
312	CO-FIN-T-027	IT Request for Information	155	0
313	CO-QC-T-028	Balance Calibration form	1025	0
314	CO-QC-T-029	Incubator Monitoring Form	854	0
315	CO-QC-T-030	pH Meter Calibration Form	971	0
316	CO-QC-T-031	Dishwasher User Form	921	0
317	CO-QC-T-032	Equipment Log	960	0
318	CO-QC-T-033	Autoclave Record	279	0
320	CO-QC-T-035	Rework Protocol Template	68	0
321	CO-DES-T-036	Experimental template: Planning	653	0
322	CO-LAB-FRM-018	CTdi452 Probe from atdbio	779	0
323	CO-LAB-FRM-019	Synthetic Uracil containing Amplicon	688	0
324	CO-LAB-FRM-020	Elution Reagent	55	0
325	CO-LAB-FRM-021	NG1  di452 Probe from SGS	11	0
326	CO-LAB-FRM-022	NG2  di452 Probe from SGS	998	0
327	CO-LAB-FRM-023	6x DNA loading dye Atlas Part Number 0327	744	0
328	CO-LAB-FRM-024	GelRed Nucleic Acid Stain Atlas Part Number 0328	117	0
329	CO-LAB-SOP-013	Balance calibration	890	0
330	CO-LAB-SOP-014	Thermo Orion Star pH meter	139	0
331	CO-LAB-SOP-015	Use of the ALC PK121 centrifuges  refrigerated and non-refrigerated	423	0
331	CO-LAB-SOP-015	Use of the ALC PK121 centrifuges (refrigerated and non-refrigerated)	423	0
332	CO-LAB-SOP-016	Use of the Peqlab thermal cyclers	41	0
333	CO-LAB-SOP-017	Use of the Jenway Spectrophotometer	169	0
335	CO-LAB-SOP-019	Use of the LMS Programmable Incubator	891	0
336	CO-LAB-SOP-020	Use of the Hulme Martin Pmpulse heat Sealer	1011	0
337	CO-QC-SOP-021	Use of Stuart SRT6D Roller Mixer	1072	0
338	CO-LAB-SOP-022	Operation & Maintenance of Grant SUB Aqua Pro 5 (SAP5) unstirred Water Bath with Labarmor Beads	1016	0
338	CO-LAB-SOP-022	Operation & Maintenance of Grant SUB Aqua Pro 5  SAP5  unstirred Water Bath with Labarmor Beads	1016	0
339	CO-OPS-SOP-109	1 x lysis buffer	1052	0
340	CO-OPS-SOP-127	Potassium Phosphate Buffer	541	0
342	CO-OPS-SOP-123	DTT Solution	633	0
343	CO-OPS-SOP-122	Detection Surfactants Solution	632	0
344	CO-OPS-SOP-121	CTNG T7 Diluent Rev 3.0 (NZ source BSA)	705	0
344	CO-OPS-SOP-121	CTNG T7 Diluent Rev 3.0  NZ source BSA	705	0
345	CO-OPS-SOP-112	600pM Stocks of Synthetic Uracil containing Amplicon	606	0
346	CO-OPS-SOP-111	50U/uL T7 Exonuclease in CTNG Storage Buffer	579	0
347	CO-OPS-SOP-128	Preparation of TV 10 thousand cells/uL Master Stocks	878	0
348	CO-OPS-SOP-116	Contrived Vaginal Matrix in eNAT	353	0
350	CO-QA-T-038	binx Memorandum Template	497	0
352	CO-DES-T-040	binx Report Template	752	0
353	CO-DES-T-041	binx Technical Report Template	182	0
354	CO-QA-T-042	binx Meeting Minutes Template	83	0
355	CO-OPS-T-043	Mutual Agreement of Confidentiality	174	0
356	CO-QA-T-044	Training Competence Assessment Form	144	0
357	CO-QA-T-045	Additional Training Form	274	0
359	CO-QA-T-047	Individual Training Plan Template	955	0
360	CO-QA-T-048	Specimen Signature Log	352	0
361	CO-QA-T-049	Document Acceptance Form	981	0
363	CO-QC-T-051	Controlled Lab Notes Template	275	0
364	CO-SUP-FRM-046	Supplier Questionnaire - Calibration/Equipment maintenance	494	0
365	CO-SUP-FRM-042	Supplier Questionnaire - Chemical/Reagent/Microbiological	647	0
366	CO-SUP-FRM-047	Supplier Questionnaire - Hardware	644	0
367	CO-SUP-FRM-048	Supplier Questionnaire - Consultant/Services	784	0
370	CO-DES-T-058	Project Planning Template	63	0
371	CO-DES-T-059	FMEA template	1012	0
372	CO-DES-T-060	Verification Testing Protocol template	400	0
373	CO-DES-T-061	Verification Testing Report template	759	0
374	CO-DES-T-062	Risk Management Plan template	1044	0
375	CO-DES-T-063	Risk/benefit template	28	0
376	CO-DES-T-064	Risk Management Report template	295	0
377	CO-DES-T-065	Validation Master Plan (or Plan) template	1078	0
377	CO-DES-T-065	Validation Master Plan  or Plan  template	1078	0
378	CO-DES-T-066	Validation Matrix template	411	0
379	CO-DES-T-067	Hazard Analysis template	1037	0
380	CO-DES-T-068	Experimental Template: Write Up	369	0
381	CO-SAM-T-069	Copy Approval Form	14	0
383	CO-QC-T-071	Detection Reagent Analysis Template	959	0
385	CO-QC-T-073	Microbiology Laboratory Cleaning record	527	0
388	CO-QC-T-076	Environmental Chamber Monitoring Form	490	0
390	CO-QA-T-078	Field Action Implementation Checklist	589	0
391	CO-QA-T-079	Field Corrective Action File Review Form	198	0
394	CO-QC-T-082	qPCR QC Testing Data Analysis	32	0
395	CO-DES-T-083	product requirements Specification Template	702	0
396	CO-DES-T-084	Pilot Line Electronic Stock Register	673	0
397	CO-SUP-FRM-043	Initial Risk Assessment and Supplier Approval	849	0
398	CO-QA-T-086	Supplier Re-assessment Approval form	564	0
399	CO-QA-T-087	Standard / Guidance Review	731	0
407	CO-QC-T-095	Reagent Aliquot From	212	0
408	CO-QC-T-096	Quarterly Reagent Check Record	755	0
410	CO-SUP-T-098	Non Approved Supplier SAP by D supplier information	1014	0
411	CO-DES-T-099	Device Master Record	305	0
412	CO-SUP-T-100	Purchase order terms & conditions	106	0
413	CO-SAM-T-101	Marketing template	488	0
414	CO-QC-T-102	CTNG Cartridge Cof A	863	0
415	CO-QC-T-103	Lab investigation initiation Template	17	0
417	CO-QC-T-105	T7 QC Testing Data Analysis	452	0
418	CO-QA-T-106	Vigilance Form	482	0
419	CO-QC-T-107	Bioanalyzer Cleaning Record	583	0
421	CO-QA-T-109	Archiving Box Contents List	567	0
422	CO-QA-T-110	Document Retrieval Request	413	0
423	CO-OPS-T-111	Generic Cartridge Subassembly Build	234	0
424	CO-DES-T-112	Pilot Line Use Log	530	0
425	CO-SUP-T-113	Cartridge Stock Take Form	419	0
426	CO-DES-T-114	Validation Summary Report	215	0
427	CO-QC-T-115	Incoming Oligo QC Form	881	0
430	CO-QC-T-118	Moby Detection Reagent Analysis Spreadsheet	799	0
432	CO-QC-T-120	QC Laboratory Cleaning Record	43	0
433	CO-QC-T-121	Impulse Sealer Use Log	31	0
434	CO-FIN-FRM-282	Fixed Asset Transfer Form	214	0
435	CO-QA-T-123	CAPA date extension form	677	0
436	CO-DES-T-124	Design Transfer Form	602	0
437	CO-DES-T-125	Software Development Tool Approval	988	0
438	CO-DES-T-126	Soup Approval	145	0
440	CO-QC-T-128	LAB investigation summary report	397	0
441	CO-DES-T-129	Customer Requirements Specification	905	0
442	CO-OPS-T-130	Equipment Fulfilment Order	643	0
443	CO-CS-T-131	Customer Service Script	767	0
444	CO-CS-T-149	Instrument Trouble Shooting Script	672	0
446	CO-FIN-T-134	UK Trade Credit Application	652	0
447	CO-CS-T-135	Equipment Return Order	54	0
448	CO-QC-T-136	Reagent Design template	9	0
449	CO-QC-T-137	Limited Laboratory Access Work Note	492	0
450	CO-QC-T-138	Summary technical Documentation (for assay)	280	0
450	CO-QC-T-138	Summary technical Documentation  for assay	280	0
451	CO-OPS-T-139	Cartridge and Packing Bill of Materials Template	210	0
452	CO-DES-PTL-001	Measuring pH values IQ/OQ Protocol	416	0
453	CO-DES-PTL-002	Validation of Abacus Guardian	945	0
454	CO-DES-T-140	Reagent Design Transfer Checklist	134	0
455	CO-QA-T-141	Document Signoff Front Sheet	1013	0
456	CO-QA-T-142	Document and Record Disposition Form	180	0
457	CO-QA-T-143	Training Plan Quarterly Sign Off Form	211	0
458	CO-QC-T-144	QC io Mainternance Log	520	0
459	CO-QA-T-145	Certificate of Conformance	695	0
460	CO-DES-PTL-003	Temperature controlled equipment	13	0
461	CO-DES-PTL-004	Monmouth 1200	332	0
462	CO-DES-PTL-005	IQ/OQ for Agilent Bioanalyzer	7	0
463	CO-DES-PTL-006	Balance IQ/OQ	52	0
464	CO-DES-PTL-007	Pilot Line Process & Equipment Validation	248	0
465	CO-DES-PTL-008	Calibration of V&V Laboratory Timers	931	0
467	CO-QA-SOP-024	Sharepoint Administration	140	0
468	CO-QA-SOP-025	Management Review	650	0
469	CO-QA-SOP-026	Use of Sharepoint	723	0
470	CO-QA-SOP-028	Quality Records	872	0
471	CO-QA-T-146	QT9 SOP Template	584	0
472	CO-QA-SOP-030	Accessing and Finding Documents in QT9	780	0
473	CO-QA-SOP-031	Revising and Introducing Documents in QT9	734	0
474	CO-OPS-SOP-032	Validation of Automated Equipment and Quality System Software	1040	0
475	CO-OPS-SOP-033	T7 Diluent  NZ Source BSA  Solution	544	0
475	CO-OPS-SOP-033	T7 Diluent (NZ Source BSA) Solution	544	0
476	CO-OPS-SOP-034	Test Method Validation	1036	0
477	CO-OPS-SOP-035	Engineering Drawing Control	781	0
478	CO-OPS-SOP-036	Instrument Engineering Change Management	1058	0
481	CO-SUP-SOP-068	Purchasing SOP	607	0
483	CO-DES-SOP-041	Design Review Work Instruction	956	0
484	CO-DES-SOP-042	Creation and Maintenance of a Device Master Record  DMR	143	0
484	CO-DES-SOP-042	Creation and Maintenance of a Device Master Record (DMR)	143	0
485	CO-QA-SOP-043	Training Procedure	306	0
486	CO-IT-SOP-044	IT Management Back-UP and Support	443	0
487	CO-SUP-SOP-069	Supplier Evaluation	828	0
488	CO-SUP-SOP-070	Supplier Risk Assessment Approval and Monitoring Procedure	814	0
489	CO-SUP-SOP-072	Instructions for receipt of incoming Non-Stock goods  assigning GRN numbers and labelling	425	0
490	CO-SUP-SOP-073	Standard Cost Roll Up	717	0
491	CO-SUP-SOP-074	UK Stock Procurement & Movements (Supply Chain)	403	0
491	CO-SUP-SOP-074	UK Stock Procurement & Movements  Supply Chain	403	0
492	CO-SUP-SOP-075	Order to Cash	666	0
493	CO-QA-REG-001	Change Management Register	357	0
497	CO-QA-REG-005	Supplier Concession Register	1080	0
498	CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	331	0
500	CO-QA-SOP-077	Supplier Audit Procedure	694	0
501	CO-QA-REG-007	Bacterial Stock Register	37	0
502	CO-LAB-SOP-078	Preparation of Bacterial Stocks  Master & Working	89	0
502	CO-LAB-SOP-078	Preparation of Bacterial Stocks (Master & Working)	89	0
503	CO-LAB-SOP-079	Use and Cleaning of Class II Microbiology Safety Cabinet	309	0
504	CO-LAB-SOP-080	Use of Agilent Bioanalyzer DNA 1000 kits	456	0
505	CO-CA-SOP-081	Collection of In-house Collected Samples	813	0
506	CO-LAB-SOP-082	Use of the Rotary Vane Anemometer	103	0
507	CO-OPS-SOP-083	Preparation of Trichomonas vaginalis 1 million Genome Equivalents/µL stocks	402	0
508	CO-OPS-SOP-084	Preparation of Trichomonas vaginalis 100 thousand Genome Equivalents/µL stocks	996	0
509	CO-OPS-SOP-085	Preparation of Chlamydia trachomatis 1 million Genome Equivalents/µL stocks	209	0
510	CO-OPS-SOP-086	Preparation of Chlamydia trachomatis 100 thousand Genome Equivalents/µL stocks	692	0
511	CO-OPS-SOP-087	Preparation of Neisseria gonorrhoeae 1 million Genome Equivalents/µL stocks	267	0
512	CO-OPS-SOP-088	Preparation of Neisseria gonorrhoeae 100 thousand Genome Equivalents/µL stocks	937	0
513	CO-OPS-SOP-089	Preparation of vaginal swab samples	148	0
514	CO-OPS-SOP-090	MFG for preparing male and female urine with 10% eNAT	160	0
515	CO-OPS-SOP-091	Manufacture of TV/IC Detection Reagent	47	0
516	CO-OPS-SOP-092	mSTI Cartridge Manufacture	213	0
517	CO-QA-SOP-093	Corrective and Preventive Action Procedure	537	0
518	CO-LAB-FRM-025	Tween-20 binx Part Number 0002	107	0
519	CO-LAB-FRM-026	T7 Gene 6 Exonuclease 1000U/µL	536	0
520	CO-LAB-FRM-027	Dimethylsulfoxide Part Number 0227	812	0
534	CO-CA-FRM-041	Consent for Voluntary Donation of In-house Collected Samples	1054	0
535	CO-QA-JA-001	A Basic Guide to Finding Documents in SharePoint	387	0
536	CO-OPS-PTL-009	Heated Detection Rig OQ Procedure	669	0
537	CO-QC-SOP-094	Procedure to Control Chemical and Biological Spillages	269	0
538	CO-LAB-SOP-095	Instrument Cleaning Procedure	262	0
539	CO-QA-SOP-096	Analysis of Quality Data	609	0
540	CO-LAB-SOP-097	Wireless Temperature and Humidity Monitoring	498	0
541	CO-QA-SOP-099	Deviation Procedure	379	0
543	CO-LAB-SOP-102	Use of the Grant XB2 Ultrasonic Bath	844	0
544	CO-LAB-SOP-103	Environmental Controls in the Laboratory	395	0
545	CO-OPS-SOP-104	CT_IC Detection Reagent	90	0
546	CO-OPS-SOP-105	NG1_IC Detection Reagent	142	0
547	CO-OPS-SOP-107	Manufacture of NG2/IC Detection Reagent	559	0
548	CO-LAB-SOP-108	Laboratory Cleaning	856	0
549	CO-CA-T-147	Clinical Trial Agreement	450	0
550	CO-CA-FRM-044	Non-binx-initiated study proposal	356	0
551	CO-LAB-SOP-129	Use of the Priorclave Autoclave	997	0
552	CO-LAB-SOP-130	Heated Detection Rig Work Instructions	870	0
553	CO-LAB-SOP-131	Pipette Use and Calibration SOP	60	0
554	CO-OPS-SOP-132	Manufacture of Elution Buffer Revision 2	817	0
555	CO-OPS-SOP-133	Manufacture of Brij 58 Solution	1067	0
556	CO-OPS-SOP-134	Manufacture of Trehalose in PCR Buffer	800	0
557	CO-LAB-SOP-135	Guidance for Use and Completion of MFG Documents	986	0
558	CO-LAB-REG-008	Manufacturing Lot Number Register	617	0
559	CO-LAB-SOP-136	Solution Preparation SOP	510	0
560	CO-LAB-SOP-137	Variable Temperature Apparatus Monitoring	532	0
561	CO-LAB-SOP-138	Use of Temperature and Humidity Loggers	1022	0
562	CO-QA-SOP-139	Change Management Procedure for Product/Project Documents	512	0
563	CO-QA-POL-006	Policy for Document Control and Change Management	719	0
566	CO-OPS-SOP-142	CTNG T7 Diluent	693	0
569	CO-LAB-T-148	Template for Laboratory Code of Practice	1059	0
570	CO-LAB-SOP-145	Handling Biological Materials	989	0
572	CO-QA-SOP-147	Managing an External Regulatory Visit from the FDA	862	0
573	CO-HR-POL-007	Training Policy	184	0
574	CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	168	0
575	CO-CA-POL-009	Verification and Validation Policy	377	0
576	CO-QA-POL-010	Policy for Control of Infrastructure Environment and Equipment	801	0
577	CO-OPS-POL-011	WEEE Policy	822	0
578	CO-CS-POL-012	Policy for Customer Feedback	593	0
579	CO-QA-POL-013	Policy for Complaints and Vigilance	665	0
580	CO-LAB-SOP-148	Reagent Aliquotting	483	0
581	CO-LAB-SOP-149	Introducing New Laboratory Equipment	628	0
582	CO-LAB-SOP-150	Standard Use of Freezers	225	0
583	CO-LAB-SOP-151	Management and Control of Critical and Controlled Equipment	82	0
584	CO-LAB-SOP-152	Instrument Failure Reporting SOP	265	0
585	CO-LAB-SOP-153	Use of UV Cabinets	578	0
586	CO-QC-SOP-154	QC Laboratory Cleaning Procedure	580	0
587	CO-QC-QCP-039	T7 Raw Material Test	704	0
588	CO-OPS-PTL-010	Reader Installation Qualification Protocol	20	0
590	CO-LAB-SOP-155	Experimental Write Up	573	0
591	CO-LAB-SOP-156	Control of Controlled Laboratory Notes	228	0
593	CO-LAB-SOP-158	Use of the NanoDrop ND2000 Spectrophotometer	1004	0
594	CO-LAB-SOP-159	Use of Rotor-Gene Q	798	0
595	CO-LAB-SOP-160	Use of the Miele Laboratory Glassware Washer G7804	993	0
596	CO-LAB-SOP-161	Elix Deionised Water System	486	0
598	CO-LAB-SOP-163	Running Cartridges on io Readers	747	0
599	CO-LAB-SOP-164	Bambi compressor: Use and Maintenance	116	0
600	CO-OPS-SOP-165	Windows Software Update	701	0
601	CO-OPS-SOP-166	Pneumatics Test Rig Set up and Calibration	348	0
602	CO-LAB-SOP-167	Attaching Electrode and Blister Adhesive and Blister Pack and Cover  M600	700	0
602	CO-LAB-SOP-167	Attaching Electrode and Blister Adhesive and Blister Pack and Cover (M600)	700	0
603	CO-LAB-SOP-168	Jenway 3510 model pH Meter	470	0
604	CO-LAB-SOP-169	Use of Fermant Pouch Sealer	179	0
605	CO-LAB-SOP-170	Rapid PCR Rig Work Instructions	253	0
606	CO-QC-SOP-171	Quality Control Rounding Procedure	312	0
607	CO-OPS-SOP-172	Tool Changes of the Rhychiger Heat Sealer	1008	0
608	CO-QC-SOP-173	Laboratory Investigation (LI) Procedure for Invalid Assays and Out of Specification (OOS) Results	683	0
608	CO-QC-SOP-173	Laboratory Investigation  LI  Procedure for Invalid Assays and Out of Specification  OOS  Results	683	0
609	CO-OPS-SOP-174	Engineering Rework Procedure	399	0
610	CO-LAB-SOP-175	Out of Hours Power Loss and Temperature Monitoring	12	0
611	CO-LAB-SOP-176	Guidance for the use and completion of IQC documents	378	0
612	CO-LAB-SOP-177	Operating instruction for the QuantStudio 3D digital PCR system	500	0
613	CO-LAB-SOP-178	Operating Instructions for Signal Analyser	576	0
614	CO-LAB-SOP-179	Cleaning Procedure for Microbiology Lab	208	0
615	CO-LAB-SOP-180	Reconstitution of Lyophilised Materials	338	0
616	CO-LAB-SOP-181	Use of the Thermomixer HC block	821	0
617	CO-LAB-SOP-182	Limited Laboratory Access Procedure	334	0
618	CO-LAB-SOP-183	Use of the Microcentrifuge 24	616	0
619	CO-LAB-SOP-184	Pilot Line Blister Filling and Sealing Standard Operating Procedure	523	0
620	CO-QC-SOP-185	Use of the SB3 Rotator	351	0
621	CO-OPS-SOP-186	Use of the VPUMP Vacuum pump	554	0
622	CO-OPS-SOP-187	Force Test Rig Set up and Calibration	970	0
623	CO-OPS-SOP-188	Process Validation	58	0
624	CO-QC-FRM-049	QC Monthly Laboratory Checklist	195	0
625	CO-QC-COP-001	Quality Control Laboratory Code of Practice	740	0
626	CO-OPS-PTL-011	Rapid PCR Rig OQ Procedure	5	0
627	CO-LAB-FRM-050	Incoming Quality Control and Specification for ‘CMO Manufactured io® Cartridges’	816	0
628	CO-OPS-SOP-189	CT/NG ATCC Input Generation	553	0
631	CO-LAB-FRM-041	Incoming Quality Control and Specification for ‘NG1 Plasmid in TE buffer’ Materials binx Part Number: 0346	374	0
632	CO-LAB-FRM-042	Incoming Quality Control and Specification for ‘NG2 Plasmid in TE buffer’ Materials binx Part Number: 0347	131	0
633	CO-LAB-FRM-043	Incoming Quality Control and Specification for ‘CT Plasmid in TE buffer’ Materials binx Part Number: 0348	535	0
636	CO-OPS-SOP-190	Preparation of IC DNA in TE buffer 10ng/μl master stock aliquots	942	0
638	CO-OPS-SOP-192	Verification Testing Process SOP	776	0
639	CO-LAB-FRM-051	WATER FOR MOLECULAR BIOLOGY Part Number 0005	487	0
641	CO-LAB-FRM-052	SODIUM CHLORIDE Part Number 0008	292	0
642	CO-LAB-FRM-053	‘TRIS (TRIZMA®) HYDROCHLORIDE’ Part Number: 0011	460	0
642	CO-LAB-FRM-053	‘TRIS  TRIZMA®  HYDROCHLORIDE’ Part Number: 0011	460	0
643	CO-LAB-FRM-054	Part No. 0014 ‘Potassium Chloride’	697	0
644	CO-LAB-FRM-055	‘Safe View DNA Stain’  Part Number 0079	119	0
645	CO-LAB-FRM-056	Part No. 0086 Buffer solution pH 7	724	0
646	CO-LAB-FRM-057	Part No. 0085 Buffer solution pH 4	547	0
647	CO-LAB-FRM-058	Part No. 0087 Buffer solution pH 10	851	0
648	CO-LAB-FRM-059	‘50mM dUTP MIX’ Part no. 0088	721	0
649	CO-LAB-FRM-060	Part no. 0089 70% ethanol	1069	0
650	CO-LAB-FRM-061	Part No. 0093 CT ME17 Synthetic target HPLC GRADE	414	0
651	CO-LAB-FRM-062	‘Guanidine Thiocyanate’ Part Number: 0094	333	0
652	CO-LAB-FRM-063	‘MES’ Part No. 0095	1051	0
653	CO-LAB-FRM-064	Part No. 0104 – Tryptone Soya Broth	308	0
654	CO-QC-FRM-065	Quality Control Out of Specification Result Investigation Record Form	577	0
655	CO-QC-SOP-012	Quality Control Out of Specification Results Procedure	1068	0
656	CO-LAB-FRM-066	C. trachomatis serotype F Elementary Bodies Part No. 0106	1077	0
657	CO-LAB-FRM-067	Sarcosine’ Part no: 0108	66	0
658	CO-LAB-FRM-068	1M Magnesium Chloride solution molecular biology grade Part No. 0115	273	0
659	CO-LAB-FRM-069	Part No. 0118 IC Synthetic target HPLC GRADE	102	0
660	CO-LAB-FRM-070	Part No. 0125 Potassium Phospate Monobasic	123	0
661	CO-LAB-FRM-071	Potassium Phosphate Dibasic’ Part No.0147	469	0
662	CO-LAB-FRM-072	‘Part No. 0148 DL-Dithiothreitol’	761	0
663	CO-LAB-FRM-073	1L Nalgene Disposable Filter Unit’ Part No. 0167	546	0
664	CO-LAB-FRM-074	CT synthetic target containing Uracil Part no: 0168	48	0
665	CO-LAB-FRM-075	‘γ Aminobutyric acid’ Part Number: 0178	114	0
666	CO-LAB-FRM-076	Part Number 0188 Vircell CT DNA Control	270	0
667	CO-LAB-FRM-077	‘Albumin from bovine serum – New Zealand Source’ Part Number: 0219	630	0
668	CO-LAB-FRM-078	Part no. 0222 CO2 Gen sachets	511	0
669	CO-LAB-FRM-079	‘Uracil DNA Glycosylase [50 thousand U/mL]’ Part Number 0240	768	0
670	CO-LAB-FRM-080	‘DNase Alert Buffer’ Part Number 0241	525	0
671	CO-LAB-FRM-081	‘DNase Alert Substrate’ Part Number 0242	749	0
672	CO-LAB-FRM-082	Part No. 0248 Pectobacterium atrosepticum chromosomal DNA in TE buffer	62	0
674	CO-LAB-FRM-084	NG1 Synthetic Target Part No 0258	1006	0
675	CO-LAB-FRM-085	NG2 Synthetic Target Part no 0259	894	0
676	CO-LAB-FRM-086	‘0260 CT Forward Primer from SGS DNA’	53	0
677	CO-LAB-FRM-087	Part No 0261 ‘CT Reverse Mod Primer’ from SGS DNA	224	0
678	CO-LAB-FRM-088	Incoming Quality Control and Specification for ‘IC Forward Primer’ from SGS DNA: Part number 0262 and 0419	930	0
679	CO-LAB-FRM-089	Part No 0263 ‘IC Reverse Primer’ from SGS DNA	605	0
680	CO-LAB-FRM-090	Part No 0264 ‘NG Target 1 Forward Primer’ from SGS DNA	861	0
681	CO-LAB-FRM-091	Part No 0265 ‘NG Target 1 RA Reverse Primer’ from SGS DNA	485	0
682	CO-LAB-FRM-092	Part No 0266 ‘NG Target 2 Forward Primer’ from SGS DNA	936	0
683	CO-LAB-FRM-093	Part No 0267 ‘NG Target 2 Reverse Primer’ from SGS DNA	858	0
684	CO-LAB-FRM-094	NG1 Taqman Probe HPLC GRADE Part no 0268	474	0
685	CO-LAB-FRM-095	NG2 Taqman probe HPLC GRADE Part No 0269	24	0
686	CO-LAB-FRM-096	‘25U/µL Taq-B DNA Polymerase  Low Glycerol ’ Part Number 0270	436	0
686	CO-LAB-FRM-096	‘25U/µL Taq-B DNA Polymerase (Low Glycerol)’ Part Number 0270	436	0
687	CO-LAB-FRM-097	‘0271 gyrA_F_Fwd primer’	1	0
689	CO-LAB-FRM-099	‘Neisseria gonorrhoeae DNA’ Part Number 0273	895	0
690	CO-LAB-FRM-100	‘CT/NG: IC DNA Reagent	641	0
691	CO-LAB-FRM-101	‘CT/NG: NG1/NG2/IC Primer Passivation Reagent	434	0
692	CO-LAB-FRM-102	‘CT/NG: TaqUNG Reagent	855	0
693	CO-LAB-FRM-103	CT/NG: NG1/IC Detection Reagent	663	0
694	CO-LAB-FRM-104	‘CT/NG: NG2/IC Detection Reagent	1084	0
695	CO-LAB-FRM-105	CT/NG: CT/IC Primer Passivation Reagent	433	0
696	CO-LAB-FRM-106	‘CT/NG: CT/IC Detection Reagent	261	0
697	CO-LAB-FRM-107	‘IC di275 Probe from SGS’ Part No. 0288	806	0
698	CO-LAB-FRM-108	‘CT di452 Probe from SGS’ Part No. 0289	1024	0
699	CO-LAB-FRM-109	Internal Control di275 Probe from ATDBio Part Number 0294	751	0
700	CO-LAB-FRM-110	Part No. 0295 ‘Sterile Syringe Filter with 0.45µm Cellulose Acetate Membrane’	871	0
701	CO-LAB-FRM-111	Part No. 0296 Chlamydia trachomatis serovar F ATCC VR-346	391	0
702	CO-LAB-FRM-112	Part Number 0298 Vircell NG DNA Control	837	0
703	CO-LAB-FRM-113	Part Number 0299 Vircell TV DNA control	661	0
704	CO-LAB-FRM-114	Part Number 0300 Vircell MG DNA Control	974	0
709	CO-LAB-FRM-119	‘Trichomonas vaginalis Cultured Stock’ P/N:0310	948	0
710	CO-LAB-FRM-120	Metronidazole resistant Trichomonas Vaginalis Cultured Stocks Part no. 0312	406	0
711	CO-LAB-FRM-121	Part No. 0316 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.45 µm surfactant-free Cellulose Acetate Membrane’	600	0
712	CO-LAB-FRM-122	Part No. 0317 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane’	685	0
713	CO-LAB-FRM-123	Part No. 0318  NATtrol Chlamydia trachomatis Positive Control	99	0
714	CO-LAB-FRM-124	Part No. 0319 NATrol Neisseria gonorrhoeae Positive Control	313	0
715	CO-LAB-FRM-125	10x TBE electrophoresis buffer Part Number 0326	231	0
716	CO-LAB-FRM-126	50bp DNA Ladder binx Part Number 0329	769	0
717	CO-LAB-FRM-127	‘TV_Alt_6_Fwd’ Part No. 0330 from SGS DNA	880	0
718	CO-LAB-FRM-128	‘TV_Alt_6_Rev’ Part No 0331 from SGS DNA	183	0
719	CO-LAB-FRM-129	‘TV_Alt_A di452 Probe from SGS’ Part Number 0332	405	0
726	CO-LAB-FRM-136	Part No. 0339 ‘NG2_di275_probe’ from SGS DNA	428	0
727	CO-LAB-FRM-137	‘HS anti-Taq mAb  5.7 mg/mL ’ Part no: 0340	827	0
727	CO-LAB-FRM-137	‘HS anti-Taq mAb (5.7 mg/mL)’ Part no: 0340	827	0
728	CO-LAB-FRM-138	‘Potassium Chloride Solution’ Part Number: 0341	713	0
729	CO-LAB-FRM-139	‘Tris (1M) pH8.0’ Part no: 0342	843	0
729	CO-LAB-FRM-139	‘Tris  1M  pH8.0’ Part no: 0342	843	0
730	CO-LAB-FRM-140	Hot Start Taq  PCR Biosystems LTD  P/N:0344	947	0
730	CO-LAB-FRM-140	Hot Start Taq (PCR Biosystems LTD) P/N:0344	947	0
731	CO-LAB-FRM-141	Part No. 0345 CampyGen  sachets	194	0
758	CO-OPS-SOP-196	SOP to record the details of the manufacture of 75x PCR buffer	109	0
759	CO-OPS-PTL-013	Validation -80 Freezer QC Lab	319	0
760	CO-OPS-PTL-014	Validation -80 Chest Freezer Micro lab	382	0
761	CO-OPS-PTL-015	Validation 2-8 Refrigerator QC Lab	104	0
762	CO-OPS-SOP-197	Manufacture of Taq/UNG Reagent	588	0
763	CO-OPS-SOP-198	Manufacture of microorganism glycerol stocks	604	0
764	CO-LAB-SOP-199	Manufacture of CT/NG Negative Control Samples	708	0
765	CO-OPS-SOP-200	Manufacture of Chlamydia trachomatis and Neisseria gonorrhoeae positive control samples	111	0
767	CO-OPS-SOP-202	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	925	0
767	CO-OPS-SOP-202	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility (for FDA 510(k))	925	0
768	CO-OPS-SOP-203	Manufacture of Wash Buffer II	712	0
770	CO-OPS-SOP-205	Manufacture of 200mM Tris pH8.0	199	0
771	CO-OPS-SOP-206	Manufacture of 1.5 M Trehalose	340	0
773	CO-OPS-SOP-208	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	46	0
773	CO-OPS-SOP-208	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility (for FDA 510(k))	46	0
774	CO-OPS-SOP-209	Preparation of bulk male urine plus 10% eNAT  v/v	410	0
774	CO-OPS-SOP-209	Preparation of bulk male urine plus 10% eNAT (v/v)	410	0
793	CO-OPS-SOP-228	Manufacture of Ab-HS Taq/UNG Reagent	980	0
794	CO-OPS-SOP-229	Manufacture of CT/TV/IC Primer Buffer Reagent	467	0
796	CO-QC-PTL-016	Validation Protocol -20 freezer/QC lab asset 0330	1061	0
797	CO-OPS-PTL-017	Validation Protocol: Thermal cycler IQ/OQ/PQ	660	0
798	CO-OPS-PTL-018	Validation Protocol – UV/Vis Nanodrop Spectrophotometer	674	0
799	CO-OPS-PTL-019	Validation of Autolab Type III	79	0
800	CO-OPS-PTL-020	Validation Protocol Temperature controlled storage/incubation	687	0
801	CO-OPS-PTL-021	Validation Protocol for Rotorgene	202	0
802	CO-OPS-PTL-022	Validation Protocol - V&V Laboratory Facilities	889	0
803	CO-OPS-PTL-023	io Reader - Digital Pressure Regulator Calibration Protocol	80	0
804	CO-OPS-PTL-024	io Reader - Pneumatics End Test Protocol	991	0
805	CO-OPS-PTL-025	io Reader – Force End Test Protocol	360	0
806	CO-OPS-PTL-026	io® Reader – Thermal End Test Protocol	247	0
807	CO-OPS-PTL-027	Rapid PCR Rig IQ Protocol	592	0
808	CO-OPS-PTL-028	Rapid PCR Rig PQ Procedure	923	0
809	CO-OPS-PTL-029	Heated Detection Rig IQ Procedure	732	0
810	CO-OPS-PTL-030	Validation Protocol – Heated Detection Rig PQ	187	0
811	CO-OPS-PTL-031	EOL thermal test 21011-MET-012 Thermal-PCR Cycle Template for TTDL-No.2.xlsx v4.0	170	0
815	CO-OPS-PTL-036	Validation Protocol: 21011-MET012 Thermal - PCR Cycle Results Template Master	418	0
816	CO-OPS-PTL-037	Blister Cropping Press IQ and OQ Validation Protocol	509	0
817	CO-OPS-PTL-038	Blister Filling Rig and Cropping Press PQ Validation Protocol	27	0
818	CO-OPS-PTL-039	OQ Validation Protocol Blister Filling Rig	1050	0
819	CO-OPS-PTL-040	IQ Validation Protocol Blister Filling Rig	59	0
821	CO-OPS-PTL-043	PAN-D-267 Signal Analyzer Validation of functions for outputting V&V tables	809	0
823	CO-SUP-SOP-231	New Items	867	0
828	CO-LAB-REG-011	Asset Register	979	0
829	CO-LAB-REG-012	Part No Register	491	0
830	CO-LAB-REG-013	Pipette Register	790	0
831	CO-LAB-REG-014	GRN Register	34	0
832	CO-LAB-REG-015	Stock Item Register	637	0
834	CO-LAB-REG-016	Consumables Register	466	0
835	CO-LAB-REG-017	Equipment Service and Calibration Register	898	0
836	CO-QC-FRM-046	Micro Monthly Laboratory Checklist-Rev_0	430	0
837	CO-LAB-REG-018	Enviromental Monitoring Results Register	299	0
838	CO-LAB-REG-019	Laboratory Investigation Register	409	0
839	CO-LAB-REG-020	Batch Retention Register	615	0
840	CO-LAB-REG-021	Laboratory Responsibilities by Area	840	0
841	CO-QA-REG-022	Vigilance Register	158	0
843	CO-QA-REG-023	Master Archive Register	10	0
844	CO-QA-REG-024	Archived Document Retrieval Log	81	0
845	CO-QA-REG-025	Supplier Risk Assessment Monitoring List	427	0
846	CO-LAB-PTL-045	IQ Protocol for Binder incubator and humidity chamber	792	0
847	CO-LAB-PTL-046	OQ protocol for binder incubator and humidity chamber	741	0
848	CO-LAB-PTL-047	PQ Protocol for binder incubator and humidity chamber	229	0
849	CO-OPS-T-152	Manufacturing Procedure  MFG  Template	1015	0
849	CO-OPS-T-152	Manufacturing Procedure (MFG) Template	1015	0
850	CO-LAB-URS-001	Binder incubator and humidity chamber User Requirement Specification	655	0
851	CO-OPS-REG-026	Instrument Register	766	0
852	CO-QC-COP-002	CL2 Microbiology Laboratory Code of Practice	426	0
853	CO-QA-T-153	Job Aid Template	93	0
854	CO-QA-JA-002	Legacy Document Number Crosswalk	819	0
855	CO-QA-SOP-237	QT9 - Periodic Review and Making Documents Obsolete	738	0
857	CO-LAB-SOP-239	Microorganism Ampoules Handling SOP	244	0
859	CO-QA-POL-014	Policy for the Control of Non-Conforming Product and Corrective/Preventive Action	61	0
860	CO-LAB-FRM-165	New Microorganism Introduction Checklist Form	565	0
866	CO-IT-REG-028	Controlled Laboratory Equipment Software List	733	0
867	CO-OPS-REG-029	binx health ltd Master Assay Code Register	15	0
868	CO-HR-REG-030	Training Register	624	0
869	CO-CA-REG-031	Donor Number Consent Register	531	0
870	CO-LAB-SOP-241	Ordering of New Reagents and Chemicals	371	0
882	CO-LAB-LBL-003	Approved material label	995	0
883	CO-LAB-LBL-004	For Indication Only Label	619	0
884	CO-LAB-LBL-005	GRN for R&D and Samples Label	73	0
885	CO-LAB-LBL-006	Part No GRN Label	137	0
886	CO-LAB-LBL-007	Expiry Dates Label	206	0
887	CO-LAB-LBL-008	Pipette Calibration Label	1056	0
888	CO-LAB-LBL-009	Quarantine - Failed calibration Label	1033	0
889	CO-LAB-LBL-010	Failed Testing - Not in use Label	91	0
890	CO-LAB-LBL-011	Solutions labels	839	0
891	CO-SD-FRM-171	Code Review	860	0
892	CO-LAB-LBL-012	General Calibration Label	978	0
893	CO-LAB-LBL-013	In process MFG material label	958	0
894	CO-LAB-LBL-014	Quarantined material label	23	0
895	CO-LAB-LBL-015	Consumables Label	324	0
896	CO-LAB-LBL-016	MBG water label	760	0
897	CO-LAB-LBL-017	Equipment Under Qualification Label	252	0
899	CO-LAB-LBL-019	Asset Calibration Label	1049	0
900	CO-LAB-LBL-020	SAP Stock Item Label	507	0
901	CO-LAB-LBL-021	Cartridge Materials Label	875	0
902	CO-LAB-LBL-022	Quarantine Stock Item Label	777	0
903	CO-LAB-LBL-023	Pilot Line Materials Label	865	0
904	CO-LAB-LBL-024	Elution Reagent Label	519	0
905	CO-LAB-LBL-025	Equipment Not Maintained Do Not Use Label	376	0
906	CO-LAB-LBL-026	CIR Label	424	0
907	CO-OPS-LBL-027	Interim CTNG CLIA Waiver Outer Shipper Label	101	0
908	CO-OPS-LBL-028	UN3316 cartridge label - use Avery J8173 labels to print	42	0
909	CO-QA-SOP-244	QT9 Administration	982	0
912	CO-OPS-PTL-048	io Release Record  following repair or refurbishment	251	0
912	CO-OPS-PTL-048	io Release Record (following repair or refurbishment)	251	0
914	CO-QA-POL-015	Policy for the Use of Electronic Signatures within binx health	670	0
915	CO-QC-T-155	CTNG QC Cartridge Analysis Module	153	0
916	CO-QC-JA-004	Use of CO-QC-T-155: CTNG QC Cartridge Analysis Module	432	0
917	CO-OPS-URS-002	URS for Temperature Monitoring System	266	0
920	CO-CS-SOP-248	Procedure For Customer Service	522	0
925	CO-OPS-PTL-049	vT flow and leak tester- FAT protocol	278	0
926	CO-OPS-PTL-050	Factory Acceptance Test  FAT   TQC in-line leak test equipment	539	0
926	CO-OPS-PTL-050	Factory Acceptance Test (FAT)  TQC in-line leak test equipment	539	0
927	CO-OPS-PTL-051	Factory Acceptance Test (FAT) Sprint B+ In-line Leak Tester	729	0
927	CO-OPS-PTL-051	Factory Acceptance Test  FAT  Sprint B+ In-line Leak Tester	729	0
928	CO-OPS-URS-006	User Requirement Specification for the vT off-line flow and leak test equipment	476	0
929	CO-OPS-URS-007	TQC leak tester- User Requirement Specification	361	0
930	CO-OPS-URS-008	Sprint B+ leak tester- User Requirement Specification	1060	0
932	CO-QA-JA-006	Use of the Management Review Module in QT9	903	0
933	CO-OPS-URS-009	User Requirement Specification for pH/mV/°C Meter	893	0
934	CO-OPS-URS-010	User Requirement Specification for temperature-controlled equipment	398	0
935	CO-OPS-URS-011	User Requirement Specification for back up power supply	6	0
936	CO-OPS-URS-012	User Requirement Specification for a Production Enclosure	973	0
937	CO-OPS-URS-013	User requirement specification for class 2 microbiological safety cabinet	479	0
938	CO-CS-SOP-249	io Insepction using Data Collection Cartridge	594	0
939	CO-CS-FRM-175	io Inspection using Data Collection Cartridge Form	1076	0
941	CO-OPS-URS-014	User requirement specification for a filter integrity tester	557	0
942	CO-OPS-URS-015	User requirement specification for a cooled incubator	347	0
946	CO-SUP-URS-017	User Requirement Specification for ByD for binx Reagent Manufacturing Facility	473	0
947	CO-REG-T-157	Regulatory Change Assessment	132	0
948	CO-OPS-URS-018	Reagent Handling Processor for Scienion Dispense Equipment	797	0
949	CO-QA-T-158	User Requirement Specification (URS) template	864	0
949	CO-QA-T-158	User Requirement Specification  URS  template	864	0
951	CO-SUP-FRM-177	binx health Vendor Information Form	949	0
952	CO-PRD1-SOP-252	Use of Benchmark Roto-Therm Plus Hybridisation oven	783	0
956	CO-OPS-URS-019	User Requirement Specification for a Balance	233	0
957	CO-LAB-T-159	Autoclave Biological Indicator Check Form	105	0
959	CO-PRD1-SOP-254	Use & Cleaning of the Monmouth Scientific Model Guardian 1800 Production Enclosure in Oak House	204	0
961	CO-PRD1-SOP-255	Mini Fuge Plus centrifuge SOP	284	0
963	CO-PRD1-SOP-256	Velp Scientific WIZARD IR Infrared Vortex Mixer SOP	205	0
964	CO-PRD1-SOP-257	Standard Use of Oak House Freezers	495	0
965	CO-SUP-FRM-178	GRN Form for incoming goods	1081	0
966	CO-PRD1-SOP-258	Use of Oak House N2400-3010 Magnetic Stirrer	917	0
967	CO-PRD1-SOP-259	Standard Use of Oak House Fridges	618	0
968	CO-LAB-FRM-180	Class II MSC Monthly Airflow Check Form	897	0
969	CO-OPS-URS-020	Process Requirement Specification for CO-OPS-PTL-010	534	0
970	CO-PRD1-POL-016	Reagent Production Policy	846	0
971	CO-PRD1-COP-003	Oak House Production Facility Code of Practice	326	0
972	CO-PRD1-SOP-260	Use of Logmore dataloggers	1000	0
973	CO-PRD1-T-160	Oak House Production Facility Cleaning Record	35	0
974	CO-PRD1-SOP-261	Cleaning Procedure for Oak House Production Facility	394	0
975	CO-PRD1-FRM-181	Oak House Monthly Production Facility Checklist	464	0
977	CO-PRD1-SOP-263	Entry and Exit to the Oak House Production Facility and Production Suite	1055	0
978	CO-PRD1-JA-008	Air conditioning	237	0
980	CO-PRD1-SOP-264	Eupry temperature monitoring system	1039	0
981	CO-PRD1-SOP-265	Oak House Emergency Procedures	236	0
983	CO-PRD1-SOP-268	Transfer of reagent QC samples	968	0
984	CO-PRD1-LBL-029	Storage temperature labels	796	0
985	CO-PRD1-FRM-182	Pipette Internal Verification Form	189	0
986	CO-PRD1-SOP-269	Oak House Pipette Use and Calibration SOP	439	0
987	CO-PRD1-FRM-183	Certificate of conformance – CT IC detection reagent	288	0
988	CO-PRD1-FRM-184	Certificate of conformance - CT IC primer passivation reagent	112	0
989	CO-PRD1-FRM-185	Certificate of Conformance - IC DNA reagent	750	0
990	CO-PRD1-FRM-186	Certificate of Conformance - NG1 IC detection reagent	990	0
991	CO-PRD1-FRM-187	Certificate of Conformance - NG2 IC detection reagent	743	0
992	CO-PRD1-FRM-188	Certificate of Conformance - NG1 NG2 IC primer passivation reagent	421	0
993	CO-PRD1-FRM-189	Certificate of Conformance - Taq UNG	287	0
995	CO-PRD1-FRM-190	Shipment note	191	0
996	CO-PRD1-SOP-271	Use of the Pacplus Impulse Heat Sealer	603	0
999	CO-PRD1-FRM-191	Reagent Shipping Worksheet	136	0
1000	CO-DPT-IFU-001	At-Home Blood Spot Collection Kit IFU (English Print Version)	590	0
1000	CO-DPT-IFU-001	At-Home Blood Spot Collection Kit IFU  English Print Version	590	0
1001	CO-DPT-IFU-002	At-Home Blood Spot Collection Kit IFU  Spanish Print Version	943	0
1001	CO-DPT-IFU-002	At-Home Blood Spot Collection Kit IFU (Spanish Print Version)	943	0
1002	CO-DPT-IFU-003	At-Home Blood Spot Collection Kit IFU  English Digital Version	802	0
1002	CO-DPT-IFU-003	At-Home Blood Spot Collection Kit IFU (English Digital Version)	802	0
1003	CO-DPT-IFU-004	At-Home Blood Spot Collection Kit IFU (Spanish Digital Version)	77	0
1003	CO-DPT-IFU-004	At-Home Blood Spot Collection Kit IFU  Spanish Digital Version	77	0
1004	CO-DPT-IFU-005	At-Home Vaginal Swab Collection Kit IFU  English Print Version	935	0
1004	CO-DPT-IFU-005	At-Home Vaginal Swab Collection Kit IFU (English Print Version)	935	0
1005	CO-DPT-IFU-006	At-Home Vaginal Swab Collection Kit IFU  Spanish Print Version	415	0
1005	CO-DPT-IFU-006	At-Home Vaginal Swab Collection Kit IFU (Spanish Print Version)	415	0
1006	CO-DPT-IFU-007	At-Home Vaginal Swab Collection Kit IFU (English Digital Version)	504	0
1006	CO-DPT-IFU-007	At-Home Vaginal Swab Collection Kit IFU  English Digital Version	504	0
1007	CO-DPT-IFU-008	At-Home Vaginal Swab Collection Kit IFU  Spanish Digital Print	730	0
1007	CO-DPT-IFU-008	At-Home Vaginal Swab Collection Kit IFU (Spanish Digital Print)	730	0
1008	CO-DPT-IFU-009	At-Home Female Triple Site Collection Kit IFU (English Print Version)	928	0
1008	CO-DPT-IFU-009	At-Home Female Triple Site Collection Kit IFU  English Print Version	928	0
1009	CO-DPT-IFU-010	At-Home Female Triple Site Collection Kit IFU (Spanish Print Version)	317	0
1009	CO-DPT-IFU-010	At-Home Female Triple Site Collection Kit IFU  Spanish Print Version	317	0
1010	CO-DPT-IFU-011	At-Home Female Triple Site Collection Kit IFU (English Digital Version)	373	0
1010	CO-DPT-IFU-011	At-Home Female Triple Site Collection Kit IFU  English Digital Version	373	0
1011	CO-DPT-IFU-012	At-Home Female Triple Site Collection Kit IFU (Spanish Digital Version)	823	0
1011	CO-DPT-IFU-012	At-Home Female Triple Site Collection Kit IFU  Spanish Digital Version	823	0
1012	CO-DPT-IFU-013	123 At-Home Card (English Version)	1010	0
1012	CO-DPT-IFU-013	123 At-Home Card  English Version	1010	0
1013	CO-DPT-IFU-014	At-Home Male Triple Site Collection Kit IFU  English Print Version	754	0
1013	CO-DPT-IFU-014	At-Home Male Triple Site Collection Kit IFU (English Print Version)	754	0
1014	CO-DPT-IFU-015	At-Home Male Triple Site Collection Kit IFU  Spanish Print Version	493	0
1014	CO-DPT-IFU-015	At-Home Male Triple Site Collection Kit IFU (Spanish Print Version)	493	0
1015	CO-DPT-IFU-016	At-Home Male Triple Site Collection Kit IFU  English Digital Version	954	0
1015	CO-DPT-IFU-016	At-Home Male Triple Site Collection Kit IFU (English Digital Version)	954	0
1016	CO-DPT-IFU-017	At-Home Male Triple Site Collection Kit IFU  Spanish Digital Version	566	0
1016	CO-DPT-IFU-017	At-Home Male Triple Site Collection Kit IFU (Spanish Digital Version)	566	0
1017	CO-DPT-IFU-018	At-Home Urine Collection Kit IFU (English Print Version)	599	0
1017	CO-DPT-IFU-018	At-Home Urine Collection Kit IFU  English Print Version	599	0
1018	CO-DPT-IFU-019	At-Home Urine Collection Kit IFU  Spanish Print Version	127	0
1018	CO-DPT-IFU-019	At-Home Urine Collection Kit IFU (Spanish Print Version)	127	0
1019	CO-DPT-IFU-020	At-Home Urine Collection Kit IFU  English Digital Version	129	0
1019	CO-DPT-IFU-020	At-Home Urine Collection Kit IFU (English Digital Version)	129	0
1020	CO-DPT-IFU-021	At-Home Urine Collection Kit IFU (Spanish Digital Version)	571	0
1020	CO-DPT-IFU-021	At-Home Urine Collection Kit IFU  Spanish Digital Version	571	0
1021	CO-DPT-IFU-022	Blood Card Collection Kit IFU (Using ADx Card)	1032	0
1021	CO-DPT-IFU-022	Blood Card Collection Kit IFU  Using ADx Card Fasting  English Print Version	1032	0
1022	CO-DPT-IFU-023	Blood Card Collection Kit IFU  Using the ADx Card Fasting  English Digital Version	715	0
1022	CO-DPT-IFU-023	Blood Card Collection Kit IFU (Using the ADx Card)	715	0
1023	CO-DPT-IFU-024	Blood Card Collection Kit IFU (Using the ADx Card)	857	0
1023	CO-DPT-IFU-024	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting  English Print Version	857	0
1024	CO-DPT-IFU-025	Blood Card Collection Kit IFU (Using the ADx Card)	124	0
1024	CO-DPT-IFU-025	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting   English Digital Version	124	0
1025	CO-DPT-IFU-026	It s as Easy as 123 (Ft. the ADx Card Collection Method)	912	0
1025	CO-DPT-IFU-026	It s as Easy as 123 Ft. the ADx Card Collection Method   English Version	912	0
1026	CO-DPT-IFU-027	STI Sample Tube/Swab Preparation Card  English Version	696	0
1026	CO-DPT-IFU-027	STI Sample Tube/Swab Preparation Card (English Version)	696	0
1027	CO-DPT-IFU-028	binx Nasal Swab For Individual Setting  English Print Version	1082	0
1027	CO-DPT-IFU-028	binx Nasal Swab For Individual Setting (English Print Version)	1082	0
1028	CO-DPT-IFU-029	binx Nasal Swab For Group Setting  English Print Version	675	0
1028	CO-DPT-IFU-029	binx Nasal Swab For Group Setting (English Print Version)	675	0
1029	CO-DPT-IFU-031	binx At-Home Collection Kit Individual_Broad  English Version	281	0
1029	CO-DPT-IFU-031	binx At-Home Collection Kit Individual_Broad (English Version)	281	0
1030	CO-DPT-IFU-032	binx At-Home Collection Kit IFU Group_Broad  English Version	552	0
1030	CO-DPT-IFU-032	binx At-Home Collection Kit IFU Group_Broad (English Version)	552	0
1031	CO-DPT-IFU-033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping (English Version)	442	0
1031	CO-DPT-IFU-033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping  English Version	442	0
1032	CO-DPT-IFU-035	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location  English Version	401	0
1032	CO-DPT-IFU-035	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location (English Version)	401	0
1033	CO-DPT-IFU-036	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad  English Version	634	0
1033	CO-DPT-IFU-036	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad (English Version)	634	0
1034	CO-DPT-IFU-037	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad  English Version	431	0
1034	CO-DPT-IFU-037	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad (English Version)	431	0
1035	CO-DPT-ART-001	Outer bag label Nasal PCR Bag Bulk Kit	67	0
1037	CO-DPT-VID-001	Return STI Kit Sample Collection Video Transcript	176	0
1039	CO-DPT-VID-003	Oral Swab Sample Collection Video Transcript	668	0
1040	CO-DPT-VID-004	Dry Blood Spot Card Video Transcript	847	0
1041	CO-DPT-VID-005	Urine Sample Collection Video Transcript	983	0
1042	CO-DPT-VID-006	Vaginal Swab Sample Collection Video Transcript	393	0
1043	CO-DPT-IFU-038	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit IFU  English Version	789	0
1043	CO-DPT-IFU-038	binx health (powered by P23) At-home Saliva COVID-19 Test Collection Kit IFU (English Version)	789	0
1044	CO-DPT-IFU-039	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit for Group Settings  English Version	658	0
1044	CO-DPT-IFU-039	binx health (powered by P23) At-home Saliva COVID-19 Test Collection Kit for Group Settings (English Version)	658	0
1045	CO-LAB-FRM-192	TV Synthetic Target  P/N 0418	246	0
1045	CO-LAB-FRM-192	TV Synthetic Target (P/N 0418)	246	0
1046	CO-DPT-VID-007	Anal Swab Sample Collection Video Transcript	163	0
1047	CO-DPT-IFU-040	At-Home Blood Spot Collection Kit USPS IFU  English Print Version	465	0
1047	CO-DPT-IFU-040	At-Home Blood Spot Collection Kit USPS IFU (English Print Version)	465	0
1048	CO-DPT-IFU-041	At-Home Blood Spot Collection Kit USPS IFU  Spanish Print Version	929	0
1048	CO-DPT-IFU-041	At-Home Blood Spot Collection Kit USPS IFU (Spanish Print Version)	929	0
1049	CO-DPT-IFU-042	At-Home Blood Spot Collection Kit USPS IFU  English Digital Version	133	0
1049	CO-DPT-IFU-042	At-Home Blood Spot Collection Kit USPS IFU (English Digital Version)	133	0
1050	CO-DPT-IFU-043	At-Home Blood Spot Collection Kit USPS IFU (Spanish Digital Version)	529	0
1050	CO-DPT-IFU-043	At-Home Blood Spot Collection Kit USPS IFU  Spanish Digital Version	529	0
1052	CO-PRD1-T-163	Certificate of Conformance template	835	0
1053	CO-QA-T-164	Instructional Video Template	330	0
1055	CO-PRD1-LBL-030	Temperature only label	585	0
1056	CO-DPT-WEB-001	COVID Consent	110	0
1059	CO-DPT-WEB-003	Privacy Policy	638	0
1060	CO-DPT-WEB-004	Terms of Service	108	0
1061	CO-DPT-WEB-005	Non-COVID Consent	64	0
1062	CO-PRD1-T-165	Manufacturing Batch Record (MBR) Template	944	0
1062	CO-PRD1-T-165	Manufacturing Batch Record  MBR  Template	944	0
1063	CO-DPT-IFU-044	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU	581	0
1063	CO-DPT-IFU-044	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU for return at a drop-off location  English Print Version	581	0
1064	CO-QA-FRM-193	Auditor Qualification	561	0
1065	CO-QA-FRM-194	Auditor Competency Assessment	298	0
1066	CO-QC-PTL-060	MOBY Detection Reagent Spreadsheet Validation Protocol	257	0
1067	CO-PRD1-JA-009	Intruder Alarm	521	0
1068	CO-SUP-FRM-195	Purchase Order Request	193	0
1069	CO-QA-T-166	Device Specific List of Applicable Standards Form Template	869	0
1070	CO-QA-SOP-274	Applicable Standards Management Procedure	130	0
1071	CO-QA-REG-032	Master List of Applicable Standards Form Template	832	0
1072	CO-QC-PTL-061	T7 Raw Material Spreadsheet Validation	657	0
1073	CO-QC-PTL-062	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test (Part no. 0225)	92	0
1073	CO-QC-PTL-062	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test  Part no. 0225	92	0
1075	CO-QA-REG-033	Auditor register	245	0
1076	CO-QC-PTL-064	QC testing and release of UNG raw material	33	0
1077	CO-QC-PTL-065	Taq-B raw material and CT/NG Taq UNG Reagent Validation	446	0
1078	CO-QC-PTL-066	CTNG CT/IC Primer passivation	977	0
1079	CO-QC-PTL-067	CTNG NG/IC Primer passivation Validation	22	0
1080	CO-QC-PTL-068	CTNG Detection Reagent Validation	601	0
1081	CO-CS-SOP-275	Installation and Training - binx io	707	0
1082	CO-QC-PTL-069	Testing and Release of Raw Materials & Formulated Reagents	1070	0
1083	CO-QC-PTL-070	Manufacture of CTNG Cartridge Reagents	786	0
1084	CO-QC-PTL-071	Manufacture of Cartridge Reagents	325	0
1085	CO-QC-PTL-072	dPCR Performance Qualification	771	0
1086	CO-QC-PTL-073	QC Release of CT/NG Cartridge	354	0
1087	CO-QC-PTL-074	CT/NG Cartridge QC Test Analysis Template Validation Protocol	113	0
1088	CO-DPT-WEB-006	COVID Consent  Spanish	611	0
1088	CO-DPT-WEB-006	COVID Consent (Spanish)	611	0
1089	CO-DPT-WEB-007	Privacy Policy (UTI	545	0
1089	CO-DPT-WEB-007	Privacy Policy  UTI Spanish	545	0
1090	CO-DPT-WEB-008	Non-COVID Consent (Spanish)	392	0
1090	CO-DPT-WEB-008	Non-COVID Consent  Spanish	392	0
1091	CO-DPT-WEB-009	South Dakota Waiver Consent and Release of Information  Spanish	614	0
1091	CO-DPT-WEB-009	South Dakota Waiver Consent and Release of Information (Spanish)	614	0
1092	CO-DPT-WEB-010	Terms of Service  Spanish	1053	0
1092	CO-DPT-WEB-010	Terms of Service (Spanish)	1053	0
1093	CO-DPT-ART-002	Inner lid activation label (STI/ODX)	408	0
1093	CO-DPT-ART-002	Inner lid activation label  STI/ODX	408	0
1094	CO-DPT-JA-010	Self-Collection Validation Summary	69	0
1095	CO-FIN-T-167	US Trade Credit Application	71	0
1096	CO-PRD1-SOP-276	Label printing	404	0
1097	CO-PRD1-PTL-075	Oak House Environmental Control System Validation Protocol	951	0
1098	CO-DPT-FEA-002	UTI Screening Box	868	0
1099	CO-DPT-T-168	Digital Feature Template	445	0
1100	CO-SUP-SOP-277	Instructions for Receipt of incoming Stock goods assigning GRN No.s & Labelling	680	0
1101	CO-SUP-SOP-278	Pilot Line Electronic Stock Control	412	0
1102	CO-SUP-SOP-279	Stock take procedure	276	0
1103	CO-SUP-SOP-280	Setting Expiry Dates for Incoming Materials	440	0
1104	CO-SUP-SOP-281	Cartridge Component Stock Control Procedure	282	0
1105	CO-SUP-POL-017	Policy for Commercial Operations	613	0
1106	CO-QC-SOP-282	QC Sample Handling and Retention Procedure	289	0
1107	CO-QC-POL-018	Quality Control Policy	503	0
1108	CO-QA-SOP-283	Product Risk Management Procedure	742	0
1109	CO-QA-SOP-284	FMEA Procedure	502	0
1110	CO-QA-SOP-285	Hazard Analysis Procedure	291	0
1111	CO-QA-POL-019	Quality Policy	563	0
1112	CO-QA-POL-020	Risk Management Policy	16	0
1113	CO-QA-POL-021	Quality Manual	550	0
1114	CO-QC-REG-034	QC Sample Retention Register	329	0
1115	CO-QC-LBL-031	QC Retention Box Label	285	0
1116	CO-QC-LBL-032	Excess Raw Material Label	558	0
1117	CO-QC-JA-011	Use of CO-QC-T-118: Detection Reagent Analysis Spreadsheet	323	0
1118	CO-QC-JA-012	Job Aid: A Guide to QC Cartridge Inspections	232	0
1119	CO-QC-SOP-286	Procedure for the Release of io Instruments	873	0
1120	CO-LAB-SOP-287	Introduction of New microorganisms SOP	1007	0
1121	CO-LAB-SOP-288	Assessment of Potentiostat Performance	272	0
1122	CO-QC-QCP-052	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test (Part 0248)	838	0
1122	CO-QC-QCP-052	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test  Part 0248	838	0
1123	CO-LAB-SOP-289	Standard Procedures for use in the Development of the CT/NG Assay	286	0
1124	CO-LAB-SOP-290	SOP for running clinical samples in io® instruments	21	0
1125	CO-LAB-SOP-291	Preparation of 10X and 1X TAE Buffer	363	0
1126	CO-LAB-SOP-292	Preparation of Tryptone Soya Broth  TSB  and Tryptone Soya Agar  TSA	157	0
1126	CO-LAB-SOP-292	Preparation of Tryptone Soya Broth (TSB) and Tryptone Soya Agar (TSA)	157	0
1127	CO-QC-SOP-293	dPCR Quantification of CT and NG Vircell Inputs	842	0
1128	CO-LAB-SOP-294	Standard Way of Making CT Dilutions	290	0
1129	CO-LAB-SOP-295	Environmental Contamination testing	909	0
1133	CO-QC-SOP-299	io Reader interface - barcode scan rate	128	0
1134	CO-LAB-SOP-300	Preparation of Sub-circuit cards for voltammetric detection	30	0
1135	CO-LAB-SOP-301	Preparation Microbiological Broth & Agar	152	0
1136	CO-LAB-SOP-302	Preparation and use of agarose gels	355	0
1137	CO-QC-QCP-053	NG2 Plasmid Quantification - qPCR Test (Part No. 0347)	852	0
1137	CO-QC-QCP-053	NG2 Plasmid Quantification - qPCR Test  Part No. 0347	852	0
1138	CO-QC-QCP-054	NG1 Plasmid Quantification - qPCR Test  Part No. 0346	787	0
1138	CO-QC-QCP-054	NG1 Plasmid Quantification - qPCR Test (Part No. 0346)	787	0
1139	CO-QC-QCP-055	CT Plasmid Quantification - qPCR Test  Part No. 0348	222	0
1139	CO-QC-QCP-055	CT Plasmid Quantification - qPCR Test (Part No. 0348)	222	0
1140	CO-QC-QCP-056	Release procedure for CT/NG cartridge	967	0
1141	CO-QC-QCP-057	CTNG CTIC NG1IC and NG2IC Detection Reagents QC test	345	0
1142	CO-QC-QCP-058	Material Electrochemical Signal Interference - Electrochemical detection assessment	623	0
1143	CO-QC-QCP-059	CT/NG Collection Kit Batch Release	556	0
1144	CO-QC-QCP-060	CT/NG Relabelled Cartridge Batch Release Procedure	900	0
1145	CO-QC-QCP-061	Electrode Electrochemical Functionality QC Assessment	938	0
1146	CO-QC-QCP-062	QC release procedure for the Io Reader	920	0
1147	CO-QC-QCP-063	CT/NG: NG2/IC detection reagent Heated io detection rig	349	0
1148	CO-QC-QCP-064	CT/NG: NG1/IC Detection Reagent	826	0
1149	CO-QC-QCP-065	CT/NG: CT/IC Detection Reagent Heated io detection rig	4	0
1150	CO-QC-QCP-066	CT/NG: NG1/NG2/IC Primer-Passivation Reagent qPCR test	1071	0
1151	CO-QC-QCP-067	CT/NG: CT/IC Primer-Passivation Reagent	164	0
1152	CO-QC-QCP-068	CT/NG Taq-UNG reagent qPCR test (MOB-D-0277)	336	0
1152	CO-QC-QCP-068	CT/NG Taq-UNG reagent qPCR test  MOB-D-0277	336	0
1153	CO-QC-QCP-069	CT/NG: IC DNA Reagent qPCR Test	301	0
1154	CO-QC-QCP-070	UNG 50 U/uL Part no. 0240	728	0
1154	CO-QC-QCP-070	UNG 50 U/uL(Part no. 0240)	728	0
1155	CO-QC-QCP-071	Enzymatics Taq-B 25U/ul (Part 0270)	640	0
1155	CO-QC-QCP-071	Enzymatics Taq-B 25U/ul  Part 0270	640	0
1156	CO-PRD1-SOP-303	Oak House Out of Hours Procedures	627	0
1157	CO-QA-JA-013	QT9 Feedback Module Job Aid	646	0
1158	CO-QA-JA-014	QT9 Corrective Action Module Job Aid	1074	0
1159	CO-QA-JA-015	QT9 Nonconforming Product Job Aid	904	0
1160	CO-QA-JA-016	QT9 Preventive Action Module Job Aid	636	0
1161	CO-PRD1-URS-021	User Requirement Specification for the binx Cartridge Reagent Manufacturing Lab UK	598	0
1162	CO-PRD1-SOP-304	Management of Critical and Controlled Equipment at Oak House Production Facility	587	0
1164	CO-PRD1-SOP-305	Use of ME2002T/00 and ML104T/00 balances in the Oak House Production Facility	75	0
1167	CO-PRD1-FRM-197	Manufacture of NG1/IC Detection Reagent	478	0
1168	CO-PRD1-FRM-198	Manufacture of NG2/IC Detection Reagent	316	0
1169	CO-PRD1-FRM-199	Manufacture of CT/IC Detection Reagent	737	0
1170	CO-PRD1-FRM-200	Manufacture of CT/IC Primer Passivation Reagent	255	0
1171	CO-PRD1-FRM-201	Manufacture of NG1/NG2/IC Primer Passivation Reagent	223	0
1172	CO-PRD1-FRM-202	Manufacture of CT/NG Taq/UNG Reagent	682	0
1173	CO-PRD1-FRM-203	Manufacture of IC DNA Reagent	496	0
1174	CO-PRD1-FRM-212	ME2002T/00 and ML104T/00 Balance Weight Verification Form	514	0
1175	CO-QA-JA-018	QT9 Internal Audit Module Job Aid	711	0
1176	CO-PRD1-SOP-306	Manufacturing Overview for the binx Cartridge Reagent Manufacturing Facility	953	0
1178	CO-QC-JA-019	A Guide for QC Document Filing	671	0
1179	CO-PRD1-SOP-308	Use of IKA Digital Roller Mixer	339	0
1180	CO-IT-POL-022	Access Control Policy	610	0
1181	CO-IT-POL-023	Asset Management Policy	887	0
1182	CO-IT-POL-024	Business Continuity and Disaster Recovery	679	0
1183	CO-IT-POL-025	Code of Conduct	50	0
1184	CO-IT-POL-026	Cryptography Policy	457	0
1185	CO-IT-POL-027	Human Resource Security Policy	100	0
1186	CO-IT-POL-028	Information Security Policy	455	0
1187	CO-IT-POL-029	Information Security Roles and Responsibilities	722	0
1188	CO-IT-POL-030	Physical Security Policy	716	0
1189	CO-IT-POL-031	Responsible Disclosure Policy	748	0
1190	CO-IT-POL-032	Risk Management	775	0
1191	CO-IT-POL-033	Third Party Management	463	0
1193	CO-QC-PTL-077	Process Validation of CO-QC-QCP-069 and CO-QC-QCP-052. IC DNA Reagent and Raw Material Testing	221	0
1194	CO-PRD1-SOP-309	Use of the Uninterruptible Power Supply	831	0
1195	CO-OPS-JA-020	Cartridge Defects Library	746	0
1196	CO-PRD1-REG-035	Oak House Equipment Service and Calibration Register	818	0
1197	CO-PRD1-REG-036	Oak House Pipette Register	551	0
1198	CO-PRD1-PTL-078	Oak House Jenway 3510 pH Meter Asset 1143 Validation Protocol	662	0
1199	CO-PRD1-LBL-033	Intermediate reagent labels	629	0
1208	CO-PRD1-SOP-310	The use of Calibrated Clocks/Timers	676	0
1209	CO-PRD1-FRM-204	Calibrated Clock/Timer verification form	555	0
1210	CO-PRD1-FRM-211	pH Meter Calibration form - 3 point	451	0
1211	CO-PRD1-SOP-311	Use of the Rotary Vane Anemometer in Oak House	689	0
1212	CO-PRD1-PTL-086	Eupry Temperature Monitoring System Validation	756	0
1213	CO-PRD1-SOP-312	Guidance for the completion of Reagent Production Manufacturing Batch Records (MBRs)	3	0
1213	CO-PRD1-SOP-312	Guidance for the completion of Reagent Production Manufacturing Batch Records  MBRs	3	0
1214	CO-PRD1-SOP-313	Use of Membrane Filters in the binx Reagent Manufacturing Facility	834	0
1215	CO-PRD1-URS-022	URS for a Hydridisation Oven (Benchmark Roto-Therm Plus H2024-E)	908	0
1215	CO-PRD1-URS-022	URS for a Hydridisation Oven  Benchmark Roto-Therm Plus H2024-E	908	0
1221	CO-PRD1-FRM-205	Equipment Maintenance and Calibration Form	528	0
1222	CO-PRD1-SOP-318	The use of the calibrated temperature probe	654	0
1223	CO-PRD1-SOP-319	Jenway 3510 model pH Meter with ATC probe and 924 30 6.0mm model Tris electrode SOP in Oak House	1030	0
1224	CO-QA-JA-021	QT9 SCAR Module Job Aid	811	0
1225	CO-LAB-FRM-206	Water/Eultion Buffer  aliquot form	227	0
1226	CO-LAB-FRM-207	Manipulated Material Aliquot form	1042	0
1227	CO-SUP-SOP-320	Oak House Supply Chain Reagent Production Process Flow	216	0
1228	CO-DPT-ART-003	STI Barcodes - 8 count label	625	0
1229	CO-DPT-ART-004	ADX Blood Card Barcode QR Labels	126	0
1230	CO-DPT-ART-005	COVID Pre-Printed PCR Label	648	0
1231	CO-DPT-ART-006	COVID Pre-Printed PCR Label - 1D Barcode	999	0
1232	CO-DPT-ART-007	COVID Broad Kit QRX Barcode 2 Part Label	699	0
1233	CO-SUP-SOP-321	Incoming Goods Procedure for deliveries into Oak House Manufacturing Site	788	0
1235	CO-PRD1-PTL-087	Oak House Mettler Toledo ME2002T_00 Precision Balance Asset 1170 Validation Protocol	518	0
1236	CO-PRD1-PTL-088	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1171 Validation Protocol	845	0
1237	CO-PRD1-PTL-089	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1172 Validation Protocol	992	0
1238	CO-DPT-ART-008	Vaginal STI Sample Collection Sticker	911	0
1239	CO-DPT-ART-009	Oral STI Sample Collection Sticker	322	0
1240	CO-DPT-ART-010	Anal STI Sample Collection Sticker	879	0
1241	CO-DPT-ART-011	Urine STI Sample Collection Sticker	1038	0
1243	CO-SUP-FRM-209	Oak House Cycle Counting stock sheet	459	0
1244	CO-SUP-SOP-322	Supply Team Oak House Operations	264	0
1245	CO-SUP-SOP-323	Demand Planning	548	0
1246	CO-SUP-SOP-324	Packaging and Shipping Procedure for binx Cartridge Reagent	240	0
1248	CO-SUP-FRM-210	Oak House Re-Order form for Supply Chain	26	0
1249	CO-PRD1-LBL-034	CT IC Detection Reagent Vial Label	45	0
1250	CO-PRD1-LBL-035	CT IC Primer Passivation Reagent Vial Label	950	0
1251	CO-PRD1-LBL-036	NG1 IC Detection Reagent Vial Label	447	0
1252	CO-PRD1-LBL-037	NG2 IC Detection Reagent Vial Label	342	0
1253	CO-PRD1-LBL-038	NG1 NG2 IC Primer Passivation Reagent Vial Label	441	0
1254	CO-PRD1-LBL-039	CT NG Taq UNG Reagent Vial Label	390	0
1255	CO-PRD1-LBL-040	IC DNA Reagent Vial Label	656	0
1256	CO-PRD1-LBL-041	CT IC Detection Reagent Box Label	151	0
1257	CO-PRD1-LBL-042	CT IC Primer Passivation Reagent Box Label	44	0
1258	CO-PRD1-LBL-043	NG1 IC Detection Reagent Box Label	994	0
1259	CO-PRD1-LBL-044	NG2 IC Detection Reagent Box Label	538	0
1260	CO-PRD1-LBL-045	NG1 NG2 IC Primer Passivation Reagent Box Label	294	0
1261	CO-PRD1-LBL-046	CT NG Taq UNG Reagent Box Label	147	0
1262	CO-PRD1-LBL-047	IC DNA Reagent Box Label	825	0
1263	CO-SUP-JA-023	Dry Ice Job aid  Oak House	201	0
1263	CO-SUP-JA-023	Dry Ice Job aid (Oak House)	201	0
1266	CO-PRD1-URS-025	URS for temp-controlled equipment for Oak House	659	0
1266	CO-PRD1-URS-025	URS for temp-controlled equipment for Oak House: Refrigerator Models: RLDF0519 and RLDF1519  freestanding and under bench   -20°C Freezer Models: RLV	659	0
1267	CO-PRD1-URS-026	User Requirement Specification for a Wireless Temperature and Humidity Monitoring System for Oak House Production and Storage Facility	745	0
1274	CO-SUP-T-171	Oak House Commercial Invoice - Cartridge Reagent  -20°c	448	0
1274	CO-SUP-T-171	Oak House Commercial Invoice - Cartridge Reagent (-20°c)	448	0
1275	CO-SUP-T-172	Oak House Packing List - Cartridge Reagent (2-8°c)	438	0
1275	CO-SUP-T-172	Oak House Packing List - Cartridge Reagent  2-8°c	438	0
1276	CO-SUP-FRM-213	Oak House Lab Replenishment Form	710	0
1278	CO-PRD1-PTL-090	Oak House Haier DW-86L338J Freezer 1155 Validation Protocol	622	0
1279	CO-PRD1-PTL-091	Oak House Labcold RLDF1519 Fridge 1157 Validation Protocol	770	0
1280	CO-PRD1-PTL-092	Oak House Labcold RLDF1519 Fridge 1159 Validation Protocol	793	0
1281	CO-PRD1-PTL-093	Oak House Labcold RLDF0519 Fridge 1161 Validation Protocol	706	0
1289	CO-PRD1-PTL-094	Oak House Labcold RLVF1517 Freezer 1158 Validation Protocol	975	0
1290	CO-PRD1-PTL-095	Oak House Labcold RLVF0417 Freezer 1162 Validation Protocol	489	0
1291	CO-PRD1-PTL-096	Oak House Labcold RLVF1517 Freezer 1183 Validation Protocol	197	0
1292	CO-PRD1-PTL-097	Oak House Labcold RLDF1519 Fridge 1207 Validation Protocol	218	0
1293	CO-PRD1-PTL-098	Oak House Labcold RLVF1517 Freezer 1208 Validation Protocol	65	0
1302	CO-PRD1-URS-027	User Requirements Specification for a Monmouth Scientific Model Guardian 1800 production enclosure	596	0
1304	CO-SUP-T-178	Reagent component pick list form	639	0
1305	CO-SUP-FRM-214	CT IC Detection Reagent Component pick list form	758	0
1306	CO-SUP-FRM-215	CT IC Primer Passivation Reagent Component Pick List Form	76	0
1307	CO-SUP-FRM-216	NG1 IC Detection Reagent Component Pick List Form	480	0
1308	CO-SUP-FRM-217	NG2 IC Detection Reagent Component Pick List Form	568	0
1309	CO-SUP-FRM-218	NG1 NG2 IC Primer Passivation Reagent Component Pick List Form	853	0
1310	CO-SUP-FRM-219	CT NG Taq UNG Reagent Component Pick List Form	120	0
1311	CO-SUP-FRM-220	IC DNA Reagent Component Pick List Form	795	0
1312	CO-SUP-JA-024	Consumption on Cost Center	690	0
1313	CO-SUP-JA-025	Creating stock and non-stock purchase orders from purchase request	468	0
1314	CO-SUP-JA-026	Production Requests to Production Orders	892	0
1315	CO-SUP-JA-027	Raising Inspection flag on stock material  SAP ByD	526	0
1315	CO-SUP-JA-027	Raising Inspection flag on stock material (SAP ByD)	526	0
1316	CO-SUP-JA-028	Running Purchasing and Production Exception Reports	40	0
1317	CO-SUP-JA-029	Purchase Order Acknowledgements	972	0
1318	CO-SUP-JA-030	Manual MRP Process (binx ERP system) and Releasing Purchase / Production Proposals	454	0
1318	CO-SUP-JA-030	Manual MRP Process  binx ERP system  and Releasing Purchase / Production Proposals	454	0
1319	CO-SUP-JA-031	Automatic MRP run set up and edit	29	0
1320	CO-SUP-JA-032	Goods Movements	220	0
1322	CO-SUP-JA-034	Raise Purchase Order – Non-stock & Services	343	0
1324	CO-SUP-JA-036	New Stock Adjustment	150	0
1325	CO-SUP-JA-037	Expiry Date Amendment	217	0
1326	CO-SUP-JA-038	Transfer Order	785	0
1327	CO-SUP-JA-039	Oak House Work Order Preparation	95	0
1328	CO-SUP-JA-040	Oak House Work Order Completion	681	0
1328	CO-SUP-JA-040	Oak House Make Task Confirmation	681	0
1329	CO-SUP-JA-041	Oak House Work Order Completion	86	0
1329	CO-SUP-JA-041	Oak House Check Task Confirmation	86	0
1330	CO-PRD1-PTL-099	Oak House MSC1800 Production Enclosure Asset 1168 Validation Protocol	300	0
1331	CO-DPT-ART-012	BAO Sassy Little Box	346	0
1332	CO-PRD1-PTL-100	Oak House Roto-Therm H2024-E Hybridisation Oven Asset 1113 Validation Protocol	72	0
1333	CO-PRD1-T-179	Template for IQC for Oak House	820	0
1335	CO-SUP-POL-034	Supply Team Policy for Oak House Production Suite Operations	156	0
1337	CO-LAB-JA-043	CIR Job Aid	375	0
1339	CO-PRD1-FRM-223	Potassium Chloride Oak House Production IQC	764	0
1341	CO-PRD1-FRM-225	Potassium phosphate dibasic Oak House Production IQC	381	0
1342	CO-PRD1-FRM-226	Taq-B Oak House Production IQC	235	0
1343	CO-PRD1-FRM-227	NG2 di452 probe Oak House production IQC	293	0
1344	CO-PRD1-FRM-228	UNG Oak House Production IQC	877	0
1345	CO-PRD1-FRM-229	MBG Water Oak House Production IQC	1029	0
1346	CO-PRD1-FRM-230	Hybridization Oven Verification and Calibration Form	85	0
1347	CO-PRD1-FRM-231	0.5M EDTA Oak House Production IQC	703	0
1348	CO-PRD1-FRM-232	Brij- 58 Oak House Production IQC	1031	0
1349	CO-PRD1-FRM-233	Glycerol Oak House Production IQC	365	0
1350	CO-PRD1-FRM-234	Potassium phosphate monobasic Oak House Production IQC	899	0
1351	CO-PRD1-FRM-235	Trehalose dihydrate Oak House Production IQC	254	0
1352	CO-PRD1-FRM-236	Triton X305 Oak House Production IQC	575	0
1353	CO-PRD1-FRM-237	Trizma base Oak House production IQC	178	0
1354	CO-PRD1-FRM-238	Trizma hydrochloride Oak House Production IQC	1002	0
1355	CO-PRD1-FRM-239	Magnesium chloride Oak House Production IQC	934	0
1356	CO-PRD1-FRM-240	Ethanol Oak House Production IQC	1003	0
1357	CO-PRD1-FRM-241	T7 exonuclease Oak House Production IQC	830	0
1358	CO-PRD1-FRM-242	dUTP mix Oak House Production IQC	808	0
1359	CO-PRD1-FRM-243	y-Aminobutyric acid (GABA) Oak House Production IQC	8	0
1359	CO-PRD1-FRM-243	y-Aminobutyric acid  GABA  Oak House Production IQC	8	0
1360	CO-PRD1-FRM-244	Albumin from bovine serum  BSA  Oak House Production IQC	924	0
1360	CO-PRD1-FRM-244	Albumin from bovine serum (BSA) Oak House Production IQC	924	0
1361	CO-PRD1-FRM-245	DL-dithiothreitol  DTT  Oak House Production IQC	171	0
1361	CO-PRD1-FRM-245	DL-dithiothreitol (DTT) Oak House Production IQC	171	0
1362	CO-PRD1-FRM-246	CT di452 probe Oak House Production IQC	885	0
1363	CO-PRD1-FRM-247	IC di275 probe Oak House Production IQC	727	0
1364	CO-PRD1-FRM-248	NG1 di452 probe Oak House Production IQC	957	0
1365	CO-PRD1-FRM-249	CT forward primer Oak House production IQC	1028	0
1366	CO-PRD1-FRM-250	CT reverse primer Oak House Production IQC	219	0
1367	CO-PRD1-FRM-251	IC  forward primer Oak House Production IQC	782	0
1368	CO-PRD1-FRM-252	IC reverse primer Oak House Production IQC	396	0
1369	CO-PRD1-FRM-253	NG1 forward primer Oak House Production IQC	803	0
1370	CO-PRD1-FRM-254	NG1 Reverse primer Oak House Production IQC	876	0
1371	CO-PRD1-FRM-255	NG2 forward primer Oak House Production IQC	919	0
1372	CO-PRD1-FRM-256	NG2 reverse primer Oak House Production IQC	385	0
1373	CO-PRD1-FRM-257	Pectobacterium atrosepticum (IC) DNA buffer Oak House Production IQC	70	0
1373	CO-PRD1-FRM-257	Pectobacterium atrosepticum  IC  DNA buffer Oak House Production IQC	70	0
1374	CO-PRD1-PTL-101	Validation of Oak House CT/NG reagent process	736	0
1375	CO-OPS-URS-028	Keyence LM Series - User Requirements Specification	621	0
1376	CO-PRD1-JA-044	Production suite air conditioning job aid	368	0
1377	CO-PRD1-FRM-258	pH Buffer Bottle 10.01 Twin-neck Oak House Production IQC	243	0
1378	CO-PRD1-FRM-259	pH Buffer Bottle 7.00 Twin-neck Oak House Production IQC	271	0
1379	CO-PRD1-FRM-260	pH Buffer Bottle 4.01 Twin-neck Oak House Production IQC	19	0
1380	CO-PRD1-FRM-261	Sartorius Minisart™ NML Syringe Filters Sterile (0.45 µm) Male Luer Lock Oak House IQC	718	0
1380	CO-PRD1-FRM-261	Sartorius Minisart™ NML Syringe Filters Sterile  0.45 µm  Male Luer Lock Oak House IQC	718	0
1381	CO-PRD1-FRM-262	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQ	586	0
1381	CO-PRD1-FRM-262	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQC	586	0
1382	CO-PRD1-FRM-263	Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Slip Oak House IQC	517	0
1383	CO-PRD1-LBL-048	ERP GRN for Oak House Label-Rev_0	304	0
1384	CO-PRD1-LBL-049	Quarantined ERP GRN material label-Rev_0	940	0
1385	CO-PRD1-LBL-050	SAP Code ERP GRN Label-Rev_0	569	0
1390	CO-PRD1-PTL-102	Oak House APC Schneider UPS Asset  1116 Validation Protocol	318	0
1391	CO-PRD1-PTL-103	Oak House APC Schneider UPS Asset  1117 Validation Protocol	635	0
1392	CO-PRD1-PTL-104	Oak House APC Schneider UPS Asset  1118 Validation Protocol	757	0
1393	CO-PRD1-PTL-105	Oak House APC Schneider UPS Asset  1176 Validation Protocol	226	0
1394	CO-PRD1-PTL-106	Oak House APC Schneider UPS Asset  1177 Validation Protocol	848	0
1398	CO-SUP-JA-047	Demand Plan - Plan and Release	256	0
1402	CO-SAM-JA-048	Promotional Materials Checklist	884	0
1403	CO-SAM-JA-049	Use of Acronyms in Marketing Materials	1057	0
1405	CO-CS-JA-050	Job Aid _Field Service-Instrument cleaning	506	0
1415	CO-SUP-T-182	Oak House Commercial Invoice - Cartridge Reagent  2-8°c	1079	0
1415	CO-SUP-T-182	Oak House Commercial Invoice - Cartridge Reagent (2-8°c)	1079	0
1416	CO-SUP-T-183	Oak House Packing List - Cartridge Reagent  -20°c	472	0
1416	CO-SUP-T-183	Oak House Packing List - Cartridge Reagent (-20°c)	472	0
1417	CO-SUP-T-184	binx Commercial Invoice  Misc. shipments	321	0
1417	CO-SUP-T-184	binx Commercial Invoice (Misc. shipments)	321	0
1418	CO-SUP-T-185	binx Packing List (Misc shipments)	259	0
1418	CO-SUP-T-185	binx Packing List  Misc shipments	259	0
1419	CO-SUP-JA-055	Use of Elpro data loggers	763	0
1420	CO-SUP-JA-056	Use of Sensitech data loggers	327	0
1421	CO-SUP-LBL-051	Shipping Contents Label	1043	0
1422	CO-LAB-URS-029	URS for Female Urine Clinical Study Database	1018	0
1423	CO-LAB-PTL-186	Verification Testing Protocol for Female Urine Database	642	0
1424	CO-LAB-REG-037	Female Urine Database	591	0
1426	CO-SUP-JA-057	Third Party Sale and Purchase Orders Process	888	0
1428	CO-DPT-T-187	Digital BOM Template	475	0
1430	CO-DPT-BOM-001	2.600.003  CG3 Male  Kit BOM	362	0
1430	CO-DPT-BOM-001	2.600.003 (CG3 Male) Kit BOM	362	0
1431	CO-DPT-BOM-002	2.600.002 (CG + Blood Male) Kit BOM	829	0
1431	CO-DPT-BOM-002	2.600.002  CG + Blood Male  Kit BOM	829	0
1432	CO-DPT-BOM-003	2.600.004  CG + Blood + Blood Male  Kit BOM	138	0
1432	CO-DPT-BOM-003	2.600.004 (CG + Blood + Blood Male) Kit BOM	138	0
1433	CO-DPT-BOM-004	2.600.500  Blood Unisex  Kit BOM	203	0
1433	CO-DPT-BOM-004	2.600.500 (Blood	203	0
1434	CO-DPT-BOM-005	2.600.006  CG3 + Blood Male  Kit BOM	1063	0
1434	CO-DPT-BOM-005	2.600.006 (CG3 + Blood Male) Kit BOM	1063	0
1435	CO-DPT-BOM-006	2.600.006-001 (CG3 + Blood Male	311	0
1435	CO-DPT-BOM-006	2.600.006-001  CG3 + Blood Male BAO  Kit BOM	311	0
1436	CO-DPT-BOM-007	2.600.007  CG3 + Blood + Blood Male  Kit BOM	841	0
1436	CO-DPT-BOM-007	2.600.007 (CG3 + Blood + Blood Male) Kit BOM	841	0
1437	CO-DPT-BOM-008	2.600.008 (CG Male) Kit BOM	927	0
1437	CO-DPT-BOM-008	2.600.008  CG Male  Kit BOM	927	0
1438	CO-DPT-BOM-009	2.600.902  CG + Blood Female  Kit BOM	307	0
1438	CO-DPT-BOM-009	2.600.902 (CG + Blood Female) Kit BOM	307	0
1439	CO-DPT-BOM-010	2.600.903 (CG3 Female) Kit BOM	773	0
1439	CO-DPT-BOM-010	2.600.903  CG3 Female  Kit BOM	773	0
1440	CO-DPT-BOM-011	2.600.904  CG + Blood + Blood Female  Kit BOM	946	0
1440	CO-DPT-BOM-011	2.600.904 (CG + Blood + Blood Female) Kit BOM	946	0
1441	CO-DPT-BOM-012	2.600.905  Blood + Blood Unisex  Kit BOM	698	0
1441	CO-DPT-BOM-012	2.600.905 (Blood + Blood	698	0
1442	CO-DPT-BOM-013	2.600.906 (CG3 + Blood Female) Kit BOM	350	0
1442	CO-DPT-BOM-013	2.600.906  CG3 + Blood Female  Kit BOM	350	0
1443	CO-DPT-BOM-014	2.600.907 (CG3 + Blood + Blood Female) Kit BOM	914	0
1443	CO-DPT-BOM-014	2.600.907  CG3 + Blood + Blood Female  Kit BOM	914	0
1444	CO-DPT-BOM-015	2.600.908  CG Female  Kit BOM	320	0
1444	CO-DPT-BOM-015	2.600.908 (CG Female) Kit BOM	320	0
1445	CO-DPT-BOM-016	2.600.909 (HIV USPS Blood Card) Kit BOM	626	0
1445	CO-DPT-BOM-016	2.600.909  HIV USPS Blood Card  Kit BOM	626	0
1446	CO-DPT-BOM-017	2.601.002 (CG + Blood Male AG) Kit BOM	388	0
1446	CO-DPT-BOM-017	2.601.002  CG + Blood Male AG  Kit BOM	388	0
1447	CO-DPT-BOM-018	2.601.003  CG Male AG  Kit BOM	386	0
1447	CO-DPT-BOM-018	2.601.003 (CG Male AG) Kit BOM	386	0
1448	CO-DPT-BOM-019	2.601.005 (Blood Unisex AG) Kit BOM	167	0
1448	CO-DPT-BOM-019	2.601.005  Blood Unisex AG  Kit BOM	167	0
1449	CO-DPT-BOM-020	2.601.006  CG3 + Blood Male AG  Kit BOM	1021	0
1449	CO-DPT-BOM-020	2.601.006 (CG3 + Blood Male AG) Kit BOM	1021	0
1450	CO-DPT-BOM-021	2.601.008  CG Male AG  Kit BOM	1017	0
1450	CO-DPT-BOM-021	2.601.008 (CG Male AG) Kit BOM	1017	0
1451	CO-DPT-BOM-022	2.601.902  CG + Blood Female AG  Kit BOM	501	0
1451	CO-DPT-BOM-022	2.601.902 (CG + Blood Female AG) Kit BOM	501	0
1452	CO-DPT-BOM-023	2.601.903 (CG3 Female AG) Kit BOM	910	0
1452	CO-DPT-BOM-023	2.601.903  CG3 Female AG  Kit BOM	910	0
1453	CO-DPT-BOM-024	2.601.906 (CG3 + Blood Female AG) Kit BOM	422	0
1453	CO-DPT-BOM-024	2.601.906  CG3 + Blood Female AG  Kit BOM	422	0
1454	CO-DPT-BOM-025	2.601.908 (CG Female AG) Kit BOM	367	0
1454	CO-DPT-BOM-025	2.601.908  CG Female AG  Kit BOM	367	0
1455	CO-DPT-BOM-026	2.800.001 (ADX Blood Card (1) Fasting) Kit BOM	595	0
1455	CO-DPT-BOM-026	2.800.001  ADX Blood Card  1  Fasting  Kit BOM	595	0
1456	CO-DPT-BOM-027	2.800.002  ADX Blood Card  2  Fasting  Kit BOM	562	0
1456	CO-DPT-BOM-027	2.800.002 (ADX Blood Card (2) Fasting) Kit BOM	562	0
1457	CO-DPT-BOM-028	2.801.001 (ADX Blood Card (1)	2	0
1457	CO-DPT-BOM-028	2.801.001  ADX Blood Card  1 Non-fasting  Kit BOM	2	0
1458	CO-DPT-BOM-029	2.801.002  ADX Blood Card  2 Non-fasting  Kit BOM	74	0
1458	CO-DPT-BOM-029	2.801.002 (ADX Blood Card (2)	74	0
1459	CO-DPT-BOM-030	5.900.444  Blood Collection Drop-in Pack  Kit BOM	481	0
1459	CO-DPT-BOM-030	5.900.444 (Blood Collection Drop-in Pack) Kit BOM	481	0
1462	CO-PRD1-SOP-355	Manufacturing Overview for Detection Reagents	902	0
1463	CO-QA-SOP-356	EU Regulatory Strategy and Process	359	0
1464	CO-QA-SOP-357	EU Performance Evaluation	720	0
1466	CO-QA-T-189	Post Market Performance Follow-up Plan Template	608	0
1467	CO-QA-T-190	Post Market Performance Follow-up Report Template	726	0
1469	CO-QA-T-192	Post Market Surveillance Plan Template	686	0
1470	CO-QA-T-193	Post Market Surveillance Report Template	815	0
1471	CO-QA-T-194	Declaration of Conformity Template	836	0
1473	CO-CS-FRM-267	Field Service Report Form	513	0
1474	CO-QA-T-196	GSPR Template	941	0
1475	CO-QA-T-197	Summary Technical Documentation  STED  Template	159	0
1475	CO-QA-T-197	Summary Technical Documentation (STED) Template	159	0
1484	CO-LAB-T-198	Eupry Calibration Cover Sheet	543	0
1486	CO-PRD1-T-199	Oak House Manufacturing Overview SOP Template	709	0
1487	CO-PRD1-T-200	Manufacturing Batch Record (MBR) Template - DEV#28	471	0
1487	CO-PRD1-T-200	Manufacturing Batch Record  MBR  Template - DEV#28	471	0
1488	CO-SUP-T-201	Shipping Specification Template	883	0
1489	CO-SUP-SOP-363	Shipping Specifications Procedure	241	0
1490	CO-SUP-FRM-269	Shipping Specification: CT/NG io Cartridge	98	0
1496	CO-SUP-POL-035	Cold Chain Shipping Policy	1062	0
1497	CO-H&S-T-204	Incident and Near Miss Reporting Form	961	0
1498	CO-H&S-T-202	Health and Safety Risk Assessment Template	165	0
1499	CO-H&S-T-203	Blank Form for H&S COSHH assessments	268	0
1500	CO-H&S-COSHH-001	COSHH Assessment - General Chemicals	1065	0
1501	CO-H&S-COSHH-002	COSHH Assessment - Oxidising Agents	859	0
1502	CO-H&S-COSHH-003	COSHH Assessment - Flammable Materials	161	0
1503	CO-H&S-COSHH-004	COSHH Assessment - Chlorinated Solvents	1005	0
1504	CO-H&S-COSHH-005	COSHH Assessment - Corrosive Bases	850	0
1505	CO-H&S-COSHH-006	COSH-Assessment - Corrosive Acids	315	0
1506	CO-H&S-COSHH-007	COSHH assessment  - General Hazard Group 2 organisms	78	0
1507	CO-H&S-COSHH-008	COSHH assessment  - Hazard Group 2 respiratory pathogens	725	0
1508	CO-H&S-COSHH-009	COSHH Assessment - Hazard Group 1 Pathogens	969	0
1509	CO-H&S-COSHH-010	COSHH assessment - clinical samples	344	0
1510	CO-H&S-COSHH-012	COSHH Assessment - Inactivated Micro-organisms	310	0
1511	CO-H&S-COSHH-013	COSHH Assessment  - Dry Ice	515	0
1512	CO-H&S-COSHH-014	COSHH Assessment - Compressed Gases	461	0
1513	CO-H&S-RA-001	Risk Assessment - binx Health Office and non-laboratory areas	1020	0
1514	CO-H&S-RA-002	Risk Assessment for use of Microorganisms	1047	0
1515	CO-H&S-RA-003	Risk Assessment - Laboratory Areas (excluding Microbiology and Pilot line)	384	0
1515	CO-H&S-RA-003	Risk Assessment - Laboratory Areas  excluding Microbiology and Pilot line	384	0
1516	CO-H&S-RA-004	Risk Assessment - io® reader / assay development tools	791	0
1517	CO-H&S-RA-005	Flammable & Explosive Substances Risk Assessment for  binx health Ltd (Derby Court and Unit 6)	175	0
1517	CO-H&S-RA-005	Flammable & Explosive Substances Risk Assessment for  binx health Ltd  Derby Court and Unit 6	175	0
1518	CO-H&S-RA-006	Risk Assessment - use of UV irradiation in the binx health Laboratories	364	0
1519	CO-H&S-RA-007	Risk Assessment - Pilot line Laboratory area	505	0
1520	CO-H&S-RA-008	Risk Assessment for binx Health Employees	38	0
1521	CO-H&S-RA-009	Risk Assessment for use of Chemicals	631	0
1522	CO-H&S-RA-010	Risk Assessment for work-related stress	162	0
1523	CO-H&S-RA-011	Covid-19 Risk Assessment binx Health ltd	366	0
1524	CO-H&S-RA-012	Health and Safety Risk Assessment for Use of a Butane Torch	612	0
1525	CO-H&S-PRO-001	Health & Safety Fire Related Procedures	186	0
1526	CO-H&S-PRO-002	Chemical and Biological COSHH Guidance	372	0
1527	CO-H&S-PRO-003	Manual Lifting Procedure	141	0
1528	CO-H&S-PRO-004	Accident Incident and near miss reporting procedure	115	0
1529	CO-H&S-PRO-005	Health and Safety Risk Assessment Procedure	1035	0
1530	CO-H&S-PRO-006	Health and Safety Legislation Review Procedure	714	0
1531	CO-H&S-PRO-007	Fire evacuation procedure for Oak House	649	0
1532	CO-H&S-P-001	Health and Safety Policy	570	0
1533	CO-H&S-P-002	PAT Policy	1027	0
1534	CO-H&S-P-003	Health and Safety Stress Management Policy	258	0
1535	CO-H&S-P-004	Coronavirus  COVID-19  Policy on employees being vaccinated	542	0
1535	CO-H&S-P-004	Coronavirus (COVID-19) Policy on employees being vaccinated	542	0
1536	CO-H&S-RA-013	Risk Assessment - Fire - Derby Court and Unit 6	97	0
1537	CO-CS-FRM-275	binx io RMA Number Request Form	417	0
1538	CO-H&S-RA-014	Health and Safety Risk Assessment Oak House Facility	188	0
1539	CO-H&S-RA-015	Health and Safety Risk Assessment Oak House Production Activities	1073	0
1540	CO-H&S-RA-016	Health and Safety Risk Assessment Incoming-Outgoing goods and Packaging	678	0
1541	CO-H&S-RA-017	Health and Safety Oak House Fire Risk Assessment	239	0
1542	CO-H&S-RA-018	Health and Safety Risk Assessment Oak House Covid-19	882	0
1544	CO-LAB-FRM-276	High Risk Temperature Controlled Asset Sign	185	0
1545	CO-LAB-FRM-277	Low Risk Temperature Controlled Asset Sign	939	0
1546	CO-LAB-FRM-278	Asset Not Temperature Controlled Sign	916	0
1549	CO-QC-LBL-052	io Instrument Failure - For Engineering Inspection Label	918	0
1550	CO-PRD1-SOP-365	Manufacturing Overview for Primer/Passivation Reagents	1001	0
1553	CO-SUP-JA-061	AirSea Dry Ice Shipper Packing Instructions	263	0
1554	CO-SUP-JA-062	AirSea 2-8°c Shipper Packing Instructions	337	0
1555	CO-SUP-JA-063	Softbox TempCell F39 (13-48) Dry ice shipper packing instructions	173	0
1555	CO-SUP-JA-063	Softbox TempCell F39  13-48  Dry ice shipper packing instructions	173	0
1556	CO-SUP-JA-064	Softbox TempCell PRO shipper packing instructions	389	0
1557	CO-SUP-JA-065	Softbox TempCell MAX shipper packing instructions	866	0
1559	CO-SUP-JA-067	CT/NG ioTM Cartridge Packing Instructions for QC samples (Softbox PRO Shipper)	297	0
1559	CO-SUP-JA-067	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox PRO Shipper	297	0
1560	CO-SUP-JA-068	CT/NG ioTM Cartridge Packing Instructions for QC samples (Softbox MAX Shipper)	915	0
1560	CO-SUP-JA-068	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox MAX Shipper	915	0
1561	CO-CS-JA-069	Customer Installation and Training Job Aid binx io	524	0
1562	CO-PRD1-SOP-369	Manufacturing Overview for IC DNA Reagent	181	0
1563	CO-PRD1-SOP-370	Manufacturing Overview for CT/NG Taq/UNG Reagent	932	0
1564	CO-PRD1-JA-070	Protecting Light Sensitive Reagents with Tin Foil at the Oak House Manufacturing Facility	886	0
1565	CO-QA-REG-041	Employee Unique Initial Register	962	0
1567	CO-OPS-PTL-108	VAL2023-06 NetSuite Test Specification_QT9	154	0
1568	CO-PRD1-FRM-279	Sterivex-GP Pressure Filter Unit IQC Form	952	0
1569	CO-QA-T-206	EU Performance Evaluation Plan Template	984	0
1570	CO-QA-T-207	EU Performance Evaluation Report Template	88	0
1571	CO-QC-PTL-109	QC CT/NG 2:2 Input Manufactured Under CO-OPS-SOP-189 Validation Protocol	1026	0
1583	CO-LAB-LBL-053	SAP Stock Item Label (Green)	774	0
1583	CO-LAB-LBL-053	SAP Stock Item Label  Green	774	0
1584	CO-LAB-LBL-054	GRN for R&D and Samples Label (Silver)	190	0
1584	CO-LAB-LBL-054	GRN for R&D and Samples Label  Silver	190	0
1585	CO-PRD1-PTL-110	Installation and Operational  Qualification Protocols for Jenway 924 030 6.0 mm Tris Buffer pH Electrode  Asset  to be used with	906	0
1585	CO-PRD1-PTL-110	Installation and Operational  Qualification Protocols for Jenway 924 030	906	0
\N	CO-SUP-SOP-007	Procedure for Sales Administration	762	0
\N	CO-CS-T-133	Instrument Field Visit	302	0
\.


--
-- Data for Name: document_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_type (id, documentcode, documenttype) FROM stdin;
1	CO-LAB-FRM-097	Forms
2	CO-DPT-BOM-028	Digital Product Technology
3	CO-PRD1-SOP-312	Standard Operating Procedure
4	CO-QC-QCP-065	Quality Control Protocol
5	CO-OPS-PTL-011	Protocol
6	CO-OPS-URS-011	User Requirements Specification
7	CO-DES-PTL-005	Protocol
8	CO-PRD1-FRM-243	Forms
9	CO-QC-T-136	Templates
10	CO-QA-REG-023	Registers
11	CO-LAB-FRM-021	Forms
12	CO-LAB-SOP-175	Standard Operating Procedure
13	CO-DES-PTL-003	Protocol
14	CO-SAM-T-069	Templates
15	CO-OPS-REG-029	Registers
16	CO-QA-POL-020	Policy
17	CO-QC-T-103	Templates
18	CO-SUP-SOP-063	Standard Operating Procedure
19	CO-PRD1-FRM-260	Forms
20	CO-OPS-PTL-010	Protocol
21	CO-LAB-SOP-290	Standard Operating Procedure
22	CO-QC-PTL-067	Protocol
23	CO-LAB-LBL-014	Label
24	CO-LAB-FRM-095	Forms
25	CO-DES-SOP-029	Standard Operating Procedure
26	CO-SUP-FRM-210	Forms
27	CO-OPS-PTL-038	Protocol
28	CO-DES-T-063	Templates
29	CO-SUP-JA-031	Job Aid
30	CO-LAB-SOP-300	Standard Operating Procedure
31	CO-QC-T-121	Templates
32	CO-QC-T-082	Templates
33	CO-QC-PTL-064	Protocol
34	CO-LAB-REG-014	Registers
35	CO-PRD1-T-160	Templates
36	CO-LAB-SOP-011	Standard Operating Procedure
37	CO-QA-REG-007	Registers
38	CO-H&S-RA-008	H&S Risk Assessments
39	CO-SUP-SOP-054	Standard Operating Procedure
40	CO-SUP-JA-028	Job Aid
41	CO-LAB-SOP-016	Standard Operating Procedure
42	CO-OPS-LBL-028	Label
43	CO-QC-T-120	Templates
44	CO-PRD1-LBL-042	Label
45	CO-PRD1-LBL-034	Label
46	CO-OPS-SOP-208	Standard Operating Procedure
47	CO-OPS-SOP-091	Standard Operating Procedure
48	CO-LAB-FRM-074	Forms
49	CO-DES-T-025	Templates
50	CO-IT-POL-025	Policy
51	CO-DES-SOP-243	Standard Operating Procedure
52	CO-DES-PTL-006	Protocol
53	CO-LAB-FRM-086	Forms
54	CO-CS-T-135	Templates
55	CO-LAB-FRM-020	Forms
56	CO-SUP-SOP-049	Standard Operating Procedure
57	CO-QA-SOP-140	Standard Operating Procedure
58	CO-OPS-SOP-188	Standard Operating Procedure
59	CO-OPS-PTL-040	Protocol
60	CO-LAB-SOP-131	Standard Operating Procedure
61	CO-QA-POL-014	Policy
62	CO-LAB-FRM-082	Forms
63	CO-DES-T-058	Templates
64	CO-DPT-WEB-005	Website Content
65	CO-PRD1-PTL-098	Protocol
66	CO-LAB-FRM-067	Forms
67	CO-DPT-ART-001	Artwork
68	CO-QC-T-035	Templates
69	CO-DPT-JA-010	Job Aid
70	CO-PRD1-FRM-257	Forms
71	CO-FIN-T-167	Templates
72	CO-PRD1-PTL-100	Protocol
73	CO-LAB-LBL-005	Label
74	CO-DPT-BOM-029	Digital Product Technology
75	CO-PRD1-SOP-305	Standard Operating Procedure
76	CO-SUP-FRM-215	Forms
77	CO-DPT-IFU-004	Instructions For Use
78	CO-H&S-COSHH-007	COSHH Assessment
79	CO-OPS-PTL-019	Protocol
80	CO-OPS-PTL-023	Protocol
81	CO-QA-REG-024	Registers
82	CO-LAB-SOP-151	Standard Operating Procedure
83	CO-QA-T-042	Templates
84	CO-LAB-FRM-016	Forms
85	CO-PRD1-FRM-230	Forms
86	CO-SUP-JA-041	Job Aid
87	CO-LAB-FRM-017	Forms
88	CO-QA-T-207	Templates
89	CO-LAB-SOP-078	Standard Operating Procedure
90	CO-OPS-SOP-104	Standard Operating Procedure
91	CO-LAB-LBL-010	Label
92	CO-QC-PTL-062	Protocol
93	CO-QA-T-153	Templates
94	CO-SUP-SOP-047	Standard Operating Procedure
95	CO-SUP-JA-039	Job Aid
96	CO-SUP-SOP-052	Standard Operating Procedure
97	CO-H&S-RA-013	H&S Risk Assessments
98	CO-SUP-FRM-269	Forms
99	CO-LAB-FRM-123	Forms
100	CO-IT-POL-027	Policy
101	CO-OPS-LBL-027	Label
102	CO-LAB-FRM-069	Forms
103	CO-LAB-SOP-082	Standard Operating Procedure
104	CO-OPS-PTL-015	Protocol
105	CO-LAB-T-159	Templates
106	CO-SUP-T-100	Templates
107	CO-LAB-FRM-025	Forms
108	CO-DPT-WEB-004	Website Content
109	CO-OPS-SOP-196	Standard Operating Procedure
110	CO-DPT-WEB-001	Website Content
111	CO-OPS-SOP-200	Standard Operating Procedure
112	CO-PRD1-FRM-184	Forms
113	CO-QC-PTL-074	Protocol
114	CO-LAB-FRM-075	Forms
115	CO-H&S-PRO-004	H&S Procedures
116	CO-LAB-SOP-164	Standard Operating Procedure
117	CO-LAB-FRM-024	Forms
118	CO-LAB-SOP-003	Standard Operating Procedure
119	CO-LAB-FRM-055	Forms
120	CO-SUP-FRM-219	Forms
121	CO-DES-SOP-371	Standard Operating Procedure
122	CO-DES-T-022	Templates
123	CO-LAB-FRM-070	Forms
124	CO-DPT-IFU-025	Digital Product Technology
125	CO-LAB-FRM-001	Forms
126	CO-DPT-ART-004	Artwork
127	CO-DPT-IFU-019	Instructions For Use
128	CO-QC-SOP-299	Standard Operating Procedure
129	CO-DPT-IFU-020	Instructions For Use
130	CO-QA-SOP-274	Standard Operating Procedure
131	CO-LAB-FRM-042	Forms
132	CO-REG-T-157	Templates
133	CO-DPT-IFU-042	Instructions For Use
134	CO-DES-T-140	Templates
135	CO-QA-SOP-007	Standard Operating Procedure
136	CO-PRD1-FRM-191	Forms
137	CO-LAB-LBL-006	Label
138	CO-DPT-BOM-003	Bill of Materials
139	CO-LAB-SOP-014	Standard Operating Procedure
140	CO-QA-SOP-024	Standard Operating Procedure
141	CO-H&S-PRO-003	H&S Procedures
142	CO-OPS-SOP-105	Standard Operating Procedure
143	CO-DES-SOP-042	Standard Operating Procedure
144	CO-QA-T-044	Templates
145	CO-DES-T-126	Templates
146	CO-SUP-SOP-065	Standard Operating Procedure
147	CO-PRD1-LBL-046	Label
148	CO-OPS-SOP-089	Standard Operating Procedure
149	CO-LAB-FRM-014	Forms
150	CO-SUP-JA-036	Job Aid
151	CO-PRD1-LBL-041	Label
152	CO-LAB-SOP-301	Standard Operating Procedure
153	CO-QC-T-155	Templates
154	CO-OPS-PTL-108	Protocol
155	CO-FIN-T-027	Templates
156	CO-SUP-POL-034	Policy
157	CO-LAB-SOP-292	Standard Operating Procedure
158	CO-QA-REG-022	Registers
159	CO-QA-T-197	Templates
160	CO-OPS-SOP-090	Standard Operating Procedure
161	CO-H&S-COSHH-003	COSHH Assessment
162	CO-H&S-RA-010	H&S Risk Assessments
163	CO-DPT-VID-007	Instructional Videos
164	CO-QC-QCP-067	Quality Control Protocol
165	CO-H&S-T-202	Templates
166	CO-OPS-T-019	Templates
167	CO-DPT-BOM-019	Bill of Materials
168	CO-OPS-POL-008	Policy
169	CO-LAB-SOP-017	Standard Operating Procedure
170	CO-OPS-PTL-031	Protocol
171	CO-PRD1-FRM-245	Forms
172	CO-SUP-SOP-061	Standard Operating Procedure
173	CO-SUP-JA-063	Job Aid
174	CO-OPS-T-043	Templates
175	CO-H&S-RA-005	H&S Risk Assessments
176	CO-DPT-VID-001	Instructional Videos
177	CO-LAB-FRM-002	Forms
178	CO-PRD1-FRM-237	Forms
179	CO-LAB-SOP-169	Standard Operating Procedure
180	CO-QA-T-142	Templates
181	CO-PRD1-SOP-369	Standard Operating Procedure
182	CO-DES-T-041	Templates
183	CO-LAB-FRM-128	Forms
184	CO-HR-POL-007	Policy
185	CO-LAB-FRM-276	Forms
186	CO-H&S-PRO-001	H&S Procedures
187	CO-OPS-PTL-030	Protocol
188	CO-H&S-RA-014	H&S Risk Assessments
189	CO-PRD1-FRM-182	Forms
190	CO-LAB-LBL-054	Label
191	CO-PRD1-FRM-190	Forms
192	CO-SUP-SOP-062	Standard Operating Procedure
193	CO-SUP-FRM-195	Forms
194	CO-LAB-FRM-141	Forms
195	CO-QC-FRM-049	Forms
196	CO-SUP-SOP-048	Standard Operating Procedure
197	CO-PRD1-PTL-096	Protocol
198	CO-QA-T-079	Templates
199	CO-OPS-SOP-205	Standard Operating Procedure
200	CO-LAB-FRM-005	Forms
201	CO-SUP-JA-023	Job Aid
202	CO-OPS-PTL-021	Protocol
203	CO-DPT-BOM-004	Digital Product Technology
204	CO-PRD1-SOP-254	Standard Operating Procedure
205	CO-PRD1-SOP-256	Standard Operating Procedure
206	CO-LAB-LBL-007	Label
207	CO-DES-T-005	Templates
208	CO-LAB-SOP-179	Standard Operating Procedure
209	CO-OPS-SOP-085	Standard Operating Procedure
210	CO-OPS-T-139	Templates
211	CO-QA-T-143	Templates
212	CO-QC-T-095	Templates
213	CO-OPS-SOP-092	Standard Operating Procedure
214	CO-FIN-FRM-282	Forms
215	CO-DES-T-114	Templates
216	CO-SUP-SOP-320	Standard Operating Procedure
217	CO-SUP-JA-037	Job Aid
218	CO-PRD1-PTL-097	Protocol
219	CO-PRD1-FRM-250	Forms
220	CO-SUP-JA-032	Job Aid
221	CO-QC-PTL-077	Protocol
222	CO-QC-QCP-055	Quality Control Protocol
223	CO-PRD1-FRM-201	Forms
224	CO-LAB-FRM-087	Forms
225	CO-LAB-SOP-150	Standard Operating Procedure
226	CO-PRD1-PTL-105	Protocol
227	CO-LAB-FRM-206	Forms
228	CO-LAB-SOP-156	Standard Operating Procedure
229	CO-LAB-PTL-047	Protocol
230	CO-LAB-SOP-005	Standard Operating Procedure
231	CO-LAB-FRM-125	Forms
232	CO-QC-JA-012	Job Aid
233	CO-OPS-URS-019	User Requirements Specification
234	CO-OPS-T-111	Templates
235	CO-PRD1-FRM-226	Forms
236	CO-PRD1-SOP-265	Standard Operating Procedure
237	CO-PRD1-JA-008	Job Aid
238	CO-SUP-SOP-060	Standard Operating Procedure
239	CO-H&S-RA-017	H&S Risk Assessments
240	CO-SUP-SOP-324	Standard Operating Procedure
241	CO-SUP-SOP-363	Standard Operating Procedure
242	CO-QA-SOP-015	Standard Operating Procedure
243	CO-PRD1-FRM-258	Forms
244	CO-LAB-SOP-239	Standard Operating Procedure
245	CO-QA-REG-033	Registers
246	CO-LAB-FRM-192	Forms
247	CO-OPS-PTL-026	Protocol
248	CO-DES-PTL-007	Protocol
249	CO-SUP-SOP-038	Standard Operating Procedure
250	CO-OPS-SOP-125	Standard Operating Procedure
251	CO-OPS-PTL-048	Protocol
252	CO-LAB-LBL-017	Label
253	CO-LAB-SOP-170	Standard Operating Procedure
254	CO-PRD1-FRM-235	Forms
255	CO-PRD1-FRM-200	Forms
256	CO-SUP-JA-047	Job Aid
257	CO-QC-PTL-060	Protocol
258	CO-H&S-P-003	H&S Policy
259	CO-SUP-T-185	Templates
260	CO-LAB-FRM-012	Forms
261	CO-LAB-FRM-106	Forms
262	CO-LAB-SOP-095	Standard Operating Procedure
263	CO-SUP-JA-061	Job Aid
264	CO-SUP-SOP-322	Standard Operating Procedure
265	CO-LAB-SOP-152	Standard Operating Procedure
266	CO-OPS-URS-002	User Requirements Specification
267	CO-OPS-SOP-087	Standard Operating Procedure
268	CO-H&S-T-203	Templates
269	CO-QC-SOP-094	Standard Operating Procedure
270	CO-LAB-FRM-076	Forms
271	CO-PRD1-FRM-259	Forms
272	CO-LAB-SOP-288	Standard Operating Procedure
273	CO-LAB-FRM-068	Forms
274	CO-QA-T-045	Templates
275	CO-QC-T-051	Templates
276	CO-SUP-SOP-279	Standard Operating Procedure
277	CO-OPS-T-021	Templates
278	CO-OPS-PTL-049	Protocol
279	CO-QC-T-033	Templates
280	CO-QC-T-138	Templates
281	CO-DPT-IFU-031	Instructions For Use
282	CO-SUP-SOP-281	Standard Operating Procedure
283	CO-LAB-FRM-013	Forms
284	CO-PRD1-SOP-255	Standard Operating Procedure
285	CO-QC-LBL-031	Label
286	CO-LAB-SOP-289	Standard Operating Procedure
287	CO-PRD1-FRM-189	Forms
288	CO-PRD1-FRM-183	Forms
289	CO-QC-SOP-282	Standard Operating Procedure
290	CO-LAB-SOP-294	Standard Operating Procedure
291	CO-QA-SOP-285	Standard Operating Procedure
292	CO-LAB-FRM-052	Forms
293	CO-PRD1-FRM-227	Forms
294	CO-PRD1-LBL-045	Label
295	CO-DES-T-064	Templates
296	CO-LAB-FRM-003	Forms
297	CO-SUP-JA-067	Job Aid
298	CO-QA-FRM-194	Forms
299	CO-LAB-REG-018	Registers
300	CO-PRD1-PTL-099	Protocol
301	CO-QC-QCP-069	Quality Control Protocol
302	CO-CS-T-133	Templates
303	CO-QA-SOP-004	Standard Operating Procedure
304	CO-PRD1-LBL-048	Label
305	CO-DES-T-099	Templates
306	CO-QA-SOP-043	Standard Operating Procedure
307	CO-DPT-BOM-009	Bill of Materials
308	CO-LAB-FRM-064	Forms
309	CO-LAB-SOP-079	Standard Operating Procedure
310	CO-H&S-COSHH-012	COSHH Assessment
311	CO-DPT-BOM-006	Digital Product Technology
312	CO-QC-SOP-171	Standard Operating Procedure
313	CO-LAB-FRM-124	Forms
314	CO-SUP-T-003	Templates
315	CO-H&S-COSHH-006	COSHH Assessment
316	CO-PRD1-FRM-198	Forms
317	CO-DPT-IFU-010	Instructions For Use
318	CO-PRD1-PTL-102	Protocol
319	CO-OPS-PTL-013	Protocol
320	CO-DPT-BOM-015	Bill of Materials
321	CO-SUP-T-184	Templates
322	CO-DPT-ART-009	Artwork
323	CO-QC-JA-011	Job Aid
324	CO-LAB-LBL-015	Label
325	CO-QC-PTL-071	Protocol
326	CO-PRD1-COP-003	Code of Practice
327	CO-SUP-JA-056	Job Aid
328	CO-SUP-SOP-055	Standard Operating Procedure
329	CO-QC-REG-034	Registers
330	CO-QA-T-164	Templates
331	CO-QA-SOP-076	Standard Operating Procedure
332	CO-DES-PTL-004	Protocol
333	CO-LAB-FRM-062	Forms
334	CO-LAB-SOP-182	Standard Operating Procedure
335	CO-OPS-SOP-120	Standard Operating Procedure
336	CO-QC-QCP-068	Quality Control Protocol
337	CO-SUP-JA-062	Job Aid
338	CO-LAB-SOP-180	Standard Operating Procedure
339	CO-PRD1-SOP-308	Standard Operating Procedure
340	CO-OPS-SOP-206	Standard Operating Procedure
341	CO-SUP-SOP-042	Standard Operating Procedure
342	CO-PRD1-LBL-037	Label
343	CO-SUP-JA-034	Job Aid
344	CO-H&S-COSHH-010	COSHH Assessment
345	CO-QC-QCP-057	Quality Control Protocol
346	CO-DPT-ART-012	Artwork
347	CO-OPS-URS-015	User Requirements Specification
348	CO-OPS-SOP-166	Standard Operating Procedure
349	CO-QC-QCP-063	Quality Control Protocol
350	CO-DPT-BOM-013	Bill of Materials
351	CO-QC-SOP-185	Standard Operating Procedure
352	CO-QA-T-048	Templates
353	CO-OPS-SOP-116	Standard Operating Procedure
354	CO-QC-PTL-073	Protocol
355	CO-LAB-SOP-302	Standard Operating Procedure
356	CO-CA-FRM-044	Forms
357	CO-QA-REG-001	Registers
358	CO-SUP-SOP-044	Standard Operating Procedure
359	CO-QA-SOP-356	Standard Operating Procedure
360	CO-OPS-PTL-025	Protocol
361	CO-OPS-URS-007	User Requirements Specification
362	CO-DPT-BOM-001	Bill of Materials
363	CO-LAB-SOP-291	Standard Operating Procedure
364	CO-H&S-RA-006	H&S Risk Assessments
365	CO-PRD1-FRM-233	Forms
366	CO-H&S-RA-011	H&S Risk Assessments
367	CO-DPT-BOM-025	Bill of Materials
368	CO-PRD1-JA-044	Job Aid
369	CO-DES-T-068	Templates
370	CO-SUP-SOP-037	Standard Operating Procedure
371	CO-LAB-SOP-241	Standard Operating Procedure
372	CO-H&S-PRO-002	H&S Procedures
373	CO-DPT-IFU-011	Instructions For Use
374	CO-LAB-FRM-041	Forms
375	CO-LAB-JA-043	Job Aid
376	CO-LAB-LBL-025	Label
377	CO-CA-POL-009	Policy
378	CO-LAB-SOP-176	Standard Operating Procedure
379	CO-QA-SOP-099	Standard Operating Procedure
380	CO-OPS-SOP-008	Standard Operating Procedure
381	CO-PRD1-FRM-225	Forms
382	CO-OPS-PTL-014	Protocol
383	CO-SUP-SOP-051	Standard Operating Procedure
384	CO-H&S-RA-003	H&S Risk Assessments
385	CO-PRD1-FRM-256	Forms
386	CO-DPT-BOM-018	Bill of Materials
387	CO-QA-JA-001	Job Aid
388	CO-DPT-BOM-017	Bill of Materials
389	CO-SUP-JA-064	Job Aid
390	CO-PRD1-LBL-039	Label
391	CO-LAB-FRM-111	Forms
392	CO-DPT-WEB-008	Website Content
393	CO-DPT-VID-006	Instructional Videos
394	CO-PRD1-SOP-261	Standard Operating Procedure
395	CO-LAB-SOP-103	Standard Operating Procedure
396	CO-PRD1-FRM-252	Forms
397	CO-QC-T-128	Templates
398	CO-OPS-URS-010	User Requirements Specification
399	CO-OPS-SOP-174	Standard Operating Procedure
400	CO-DES-T-060	Templates
401	CO-DPT-IFU-035	Instructions For Use
402	CO-OPS-SOP-083	Standard Operating Procedure
403	CO-SUP-SOP-074	Standard Operating Procedure
404	CO-PRD1-SOP-276	Standard Operating Procedure
405	CO-LAB-FRM-129	Forms
406	CO-LAB-FRM-120	Forms
407	CO-QA-SOP-011	Standard Operating Procedure
408	CO-DPT-ART-002	Artwork
409	CO-LAB-REG-019	Registers
410	CO-OPS-SOP-209	Standard Operating Procedure
411	CO-DES-T-066	Templates
412	CO-SUP-SOP-278	Standard Operating Procedure
413	CO-QA-T-110	Templates
414	CO-LAB-FRM-061	Forms
415	CO-DPT-IFU-006	Instructions For Use
416	CO-DES-PTL-001	Protocol
417	CO-CS-FRM-275	Forms
418	CO-OPS-PTL-036	Protocol
419	CO-SUP-T-113	Templates
420	CO-QA-T-010	Templates
421	CO-PRD1-FRM-188	Forms
422	CO-DPT-BOM-024	Bill of Materials
423	CO-LAB-SOP-015	Standard Operating Procedure
424	CO-LAB-LBL-026	Label
425	CO-SUP-SOP-072	Standard Operating Procedure
426	CO-QC-COP-002	Code of Practice
427	CO-QA-REG-025	Registers
428	CO-LAB-FRM-136	Forms
429	CO-SUP-SOP-006	Standard Operating Procedure
430	CO-QC-FRM-046	Forms
431	CO-DPT-IFU-037	Instructions For Use
432	CO-QC-JA-004	Job Aid
433	CO-LAB-FRM-105	Forms
434	CO-LAB-FRM-101	Forms
435	CO-SUP-SOP-064	Standard Operating Procedure
436	CO-LAB-FRM-096	Forms
437	CO-QA-T-011	Templates
438	CO-SUP-T-172	Templates
439	CO-PRD1-SOP-269	Standard Operating Procedure
440	CO-SUP-SOP-280	Standard Operating Procedure
441	CO-PRD1-LBL-038	Label
442	CO-DPT-IFU-033	Instructions For Use
443	CO-IT-SOP-044	Standard Operating Procedure
444	CO-OPS-SOP-119	Standard Operating Procedure
445	CO-DPT-T-168	Templates
446	CO-QC-PTL-065	Protocol
447	CO-PRD1-LBL-036	Label
448	CO-SUP-T-171	Templates
449	CO-SUP-SOP-013	Standard Operating Procedure
450	CO-CA-T-147	Templates
451	CO-PRD1-FRM-211	Forms
452	CO-QC-T-105	Templates
453	CO-SUP-SOP-057	Standard Operating Procedure
454	CO-SUP-JA-030	Job Aid
455	CO-IT-POL-028	Policy
456	CO-LAB-SOP-080	Standard Operating Procedure
457	CO-IT-POL-026	Policy
458	CO-LAB-FRM-009	Forms
459	CO-SUP-FRM-209	Forms
460	CO-LAB-FRM-053	Forms
461	CO-H&S-COSHH-014	COSHH Assessment
462	CO-QA-T-007	Templates
463	CO-IT-POL-033	Policy
464	CO-PRD1-FRM-181	Forms
465	CO-DPT-IFU-040	Instructions For Use
466	CO-LAB-REG-016	Registers
467	CO-OPS-SOP-229	Standard Operating Procedure
468	CO-SUP-JA-025	Job Aid
469	CO-LAB-FRM-071	Forms
470	CO-LAB-SOP-168	Standard Operating Procedure
471	CO-PRD1-T-200	Templates
472	CO-SUP-T-183	Templates
473	CO-SUP-URS-017	User Requirements Specification
474	CO-LAB-FRM-094	Forms
475	CO-DPT-T-187	Templates
476	CO-OPS-URS-006	User Requirements Specification
477	CO-OPS-SOP-117	Standard Operating Procedure
478	CO-PRD1-FRM-197	Forms
479	CO-OPS-URS-013	User Requirements Specification
480	CO-SUP-FRM-216	Forms
481	CO-DPT-BOM-030	Bill of Materials
482	CO-QA-T-106	Templates
483	CO-LAB-SOP-148	Standard Operating Procedure
484	CO-SUP-SOP-046	Standard Operating Procedure
485	CO-LAB-FRM-091	Forms
486	CO-LAB-SOP-161	Standard Operating Procedure
487	CO-LAB-FRM-051	Forms
488	CO-SAM-T-101	Templates
489	CO-PRD1-PTL-095	Protocol
490	CO-QC-T-076	Templates
491	CO-LAB-REG-012	Registers
492	CO-QC-T-137	Templates
493	CO-DPT-IFU-015	Instructions For Use
494	CO-SUP-FRM-046	Forms
495	CO-PRD1-SOP-257	Standard Operating Procedure
496	CO-PRD1-FRM-203	Forms
497	CO-QA-T-038	Templates
498	CO-LAB-SOP-097	Standard Operating Procedure
499	CO-OPS-SOP-110	Standard Operating Procedure
500	CO-LAB-SOP-177	Standard Operating Procedure
501	CO-DPT-BOM-022	Bill of Materials
502	CO-QA-SOP-284	Standard Operating Procedure
503	CO-QC-POL-018	Policy
504	CO-DPT-IFU-007	Instructions For Use
505	CO-H&S-RA-007	H&S Risk Assessments
506	CO-CS-JA-050	Job Aid
507	CO-LAB-LBL-020	Label
508	CO-OPS-SOP-114	Standard Operating Procedure
509	CO-OPS-PTL-037	Protocol
510	CO-LAB-SOP-136	Standard Operating Procedure
511	CO-LAB-FRM-078	Forms
512	CO-QA-SOP-139	Standard Operating Procedure
513	CO-CS-FRM-267	Forms
514	CO-PRD1-FRM-212	Forms
515	CO-H&S-COSHH-013	COSHH Assessment
516	CO-SUP-SOP-066	Standard Operating Procedure
517	CO-PRD1-FRM-263	Forms
518	CO-PRD1-PTL-087	Protocol
519	CO-LAB-LBL-024	Label
520	CO-QC-T-144	Templates
521	CO-PRD1-JA-009	Job Aid
522	CO-CS-SOP-248	Standard Operating Procedure
523	CO-LAB-SOP-184	Standard Operating Procedure
524	CO-CS-JA-069	Job Aid
525	CO-LAB-FRM-080	Forms
526	CO-SUP-JA-027	Job Aid
527	CO-QC-T-073	Templates
528	CO-PRD1-FRM-205	Forms
529	CO-DPT-IFU-043	Instructions For Use
530	CO-DES-T-112	Templates
531	CO-CA-REG-031	Registers
532	CO-LAB-SOP-137	Standard Operating Procedure
533	CO-OPS-T-020	Templates
534	CO-OPS-URS-020	User Requirements Specification
535	CO-LAB-FRM-043	Forms
536	CO-LAB-FRM-026	Forms
537	CO-QA-SOP-093	Standard Operating Procedure
538	CO-PRD1-LBL-044	Label
539	CO-OPS-PTL-050	Protocol
540	CO-LAB-FRM-008	Forms
541	CO-OPS-SOP-127	Standard Operating Procedure
542	CO-H&S-P-004	H&S Policy
543	CO-LAB-T-198	Templates
544	CO-OPS-SOP-033	Standard Operating Procedure
545	CO-DPT-WEB-007	Digital Product Technology
546	CO-LAB-FRM-073	Forms
547	CO-LAB-FRM-057	Forms
548	CO-SUP-SOP-323	Standard Operating Procedure
549	CO-LAB-FRM-006	Forms
550	CO-QA-POL-021	Policy
551	CO-PRD1-REG-036	Registers
552	CO-DPT-IFU-032	Instructions For Use
553	CO-OPS-SOP-189	Standard Operating Procedure
554	CO-OPS-SOP-186	Standard Operating Procedure
555	CO-PRD1-FRM-204	Forms
556	CO-QC-QCP-059	Quality Control Protocol
557	CO-OPS-URS-014	User Requirements Specification
558	CO-QC-LBL-032	Label
559	CO-OPS-SOP-107	Standard Operating Procedure
560	CO-QA-SOP-005	Standard Operating Procedure
561	CO-QA-FRM-193	Forms
562	CO-DPT-BOM-027	Bill of Materials
563	CO-QA-POL-019	Policy
564	CO-QA-T-086	Templates
565	CO-LAB-FRM-165	Forms
566	CO-DPT-IFU-017	Instructions For Use
567	CO-QA-T-109	Templates
568	CO-SUP-FRM-217	Forms
569	CO-PRD1-LBL-050	Label
570	CO-H&S-P-001	H&S Policy
571	CO-DPT-IFU-021	Instructions For Use
572	CO-OPS-SOP-002	Standard Operating Procedure
573	CO-LAB-SOP-155	Standard Operating Procedure
574	CO-OPS-SOP-009	Standard Operating Procedure
575	CO-PRD1-FRM-236	Forms
576	CO-LAB-SOP-178	Standard Operating Procedure
577	CO-QC-FRM-065	Forms
578	CO-LAB-SOP-153	Standard Operating Procedure
579	CO-OPS-SOP-111	Standard Operating Procedure
580	CO-QC-SOP-154	Standard Operating Procedure
581	CO-DPT-IFU-044	Digital Product Technology
582	CO-QA-SOP-016	Standard Operating Procedure
583	CO-QC-T-107	Templates
584	CO-QA-T-146	Templates
585	CO-PRD1-LBL-030	Label
586	CO-PRD1-FRM-262	Forms
587	CO-PRD1-SOP-304	Standard Operating Procedure
588	CO-OPS-SOP-197	Standard Operating Procedure
589	CO-QA-T-078	Templates
590	CO-DPT-IFU-001	Instructions For Use
591	CO-LAB-REG-037	Registers
592	CO-OPS-PTL-027	Protocol
593	CO-CS-POL-012	Policy
594	CO-CS-SOP-249	Standard Operating Procedure
595	CO-DPT-BOM-026	Bill of Materials
596	CO-PRD1-URS-027	User Requirements Specification
597	CO-SUP-SOP-056	Standard Operating Procedure
598	CO-PRD1-URS-021	User Requirements Specification
599	CO-DPT-IFU-018	Instructions For Use
600	CO-LAB-FRM-121	Forms
601	CO-QC-PTL-068	Protocol
602	CO-DES-T-124	Templates
603	CO-PRD1-SOP-271	Standard Operating Procedure
604	CO-OPS-SOP-198	Standard Operating Procedure
605	CO-LAB-FRM-089	Forms
606	CO-OPS-SOP-112	Standard Operating Procedure
607	CO-SUP-SOP-068	Standard Operating Procedure
608	CO-QA-T-189	Templates
609	CO-QA-SOP-096	Standard Operating Procedure
610	CO-IT-POL-022	Policy
611	CO-DPT-WEB-006	Website Content
612	CO-H&S-RA-012	H&S Risk Assessments
613	CO-SUP-POL-017	Policy
614	CO-DPT-WEB-009	Website Content
615	CO-LAB-REG-020	Registers
616	CO-LAB-SOP-183	Standard Operating Procedure
617	CO-LAB-REG-008	Registers
618	CO-PRD1-SOP-259	Standard Operating Procedure
619	CO-LAB-LBL-004	Label
620	CO-SUP-SOP-005	Standard Operating Procedure
621	CO-OPS-URS-028	User Requirements Specification
622	CO-PRD1-PTL-090	Protocol
623	CO-QC-QCP-058	Quality Control Protocol
624	CO-HR-REG-030	Registers
625	CO-DPT-ART-003	Artwork
626	CO-DPT-BOM-016	Bill of Materials
627	CO-PRD1-SOP-303	Standard Operating Procedure
628	CO-LAB-SOP-149	Standard Operating Procedure
629	CO-PRD1-LBL-033	Label
630	CO-LAB-FRM-077	Forms
631	CO-H&S-RA-009	H&S Risk Assessments
632	CO-OPS-SOP-122	Standard Operating Procedure
633	CO-OPS-SOP-123	Standard Operating Procedure
634	CO-DPT-IFU-036	Instructions For Use
635	CO-PRD1-PTL-103	Protocol
636	CO-QA-JA-016	Job Aid
637	CO-LAB-REG-015	Registers
638	CO-DPT-WEB-003	Website Content
639	CO-SUP-T-178	Templates
640	CO-QC-QCP-071	Quality Control Protocol
641	CO-LAB-FRM-100	Forms
642	CO-LAB-PTL-186	Protocol
643	CO-OPS-T-130	Templates
644	CO-SUP-FRM-047	Forms
645	CO-QC-T-023	Templates
646	CO-QA-JA-013	Job Aid
647	CO-SUP-FRM-042	Forms
648	CO-DPT-ART-005	Artwork
649	CO-H&S-PRO-007	H&S Procedures
650	CO-QA-SOP-025	Standard Operating Procedure
651	CO-LAB-FRM-010	Forms
652	CO-FIN-T-134	Templates
653	CO-DES-T-036	Templates
654	CO-PRD1-SOP-318	Standard Operating Procedure
655	CO-LAB-URS-001	User Requirements Specification
656	CO-PRD1-LBL-040	Label
657	CO-QC-PTL-061	Protocol
658	CO-DPT-IFU-039	Instructions For Use
659	CO-PRD1-URS-025	User Requirements Specification
660	CO-OPS-PTL-017	Protocol
661	CO-LAB-FRM-113	Forms
662	CO-PRD1-PTL-078	Protocol
663	CO-LAB-FRM-103	Forms
664	CO-OPS-SOP-113	Standard Operating Procedure
665	CO-QA-POL-013	Policy
666	CO-SUP-SOP-075	Standard Operating Procedure
667	CO-OPS-T-001	Templates
668	CO-DPT-VID-003	Instructional Videos
669	CO-OPS-PTL-009	Protocol
670	CO-QA-POL-015	Policy
671	CO-QC-JA-019	Job Aid
672	CO-CS-T-149	Templates
673	CO-DES-T-084	Templates
674	CO-OPS-PTL-018	Protocol
675	CO-DPT-IFU-029	Instructions For Use
676	CO-PRD1-SOP-310	Standard Operating Procedure
677	CO-QA-T-123	Templates
678	CO-H&S-RA-016	H&S Risk Assessments
679	CO-IT-POL-024	Policy
680	CO-SUP-SOP-277	Standard Operating Procedure
681	CO-SUP-JA-040	Job Aid
682	CO-PRD1-FRM-202	Forms
683	CO-QC-SOP-173	Standard Operating Procedure
684	CO-SUP-SOP-067	Standard Operating Procedure
685	CO-LAB-FRM-122	Forms
686	CO-QA-T-192	Templates
687	CO-OPS-PTL-020	Protocol
688	CO-LAB-FRM-019	Forms
689	CO-PRD1-SOP-311	Standard Operating Procedure
690	CO-SUP-JA-024	Job Aid
691	CO-LAB-FRM-004	Forms
692	CO-OPS-SOP-086	Standard Operating Procedure
693	CO-OPS-SOP-142	Standard Operating Procedure
694	CO-QA-SOP-077	Standard Operating Procedure
695	CO-QA-T-145	Templates
696	CO-DPT-IFU-027	Instructions For Use
697	CO-LAB-FRM-054	Forms
698	CO-DPT-BOM-012	Digital Product Technology
699	CO-DPT-ART-007	Artwork
700	CO-LAB-SOP-167	Standard Operating Procedure
701	CO-OPS-SOP-165	Standard Operating Procedure
702	CO-DES-T-083	Templates
703	CO-PRD1-FRM-231	Forms
704	CO-QC-QCP-039	Quality Control Protocol
705	CO-OPS-SOP-121	Standard Operating Procedure
706	CO-PRD1-PTL-093	Protocol
707	CO-CS-SOP-275	Standard Operating Procedure
708	CO-LAB-SOP-199	Standard Operating Procedure
709	CO-PRD1-T-199	Templates
710	CO-SUP-FRM-213	Forms
711	CO-QA-JA-018	Job Aid
712	CO-OPS-SOP-203	Standard Operating Procedure
713	CO-LAB-FRM-138	Forms
714	CO-H&S-PRO-006	H&S Procedures
715	CO-DPT-IFU-023	Digital Product Technology
716	CO-IT-POL-030	Policy
717	CO-SUP-SOP-073	Standard Operating Procedure
718	CO-PRD1-FRM-261	Forms
719	CO-QA-POL-006	Policy
720	CO-QA-SOP-357	Standard Operating Procedure
721	CO-LAB-FRM-059	Forms
722	CO-IT-POL-029	Policy
723	CO-QA-SOP-026	Standard Operating Procedure
724	CO-LAB-FRM-056	Forms
725	CO-H&S-COSHH-008	COSHH Assessment
726	CO-QA-T-190	Templates
727	CO-PRD1-FRM-247	Forms
728	CO-QC-QCP-070	Quality Control Protocol
729	CO-OPS-PTL-051	Protocol
730	CO-DPT-IFU-008	Instructions For Use
731	CO-QA-T-087	Templates
732	CO-OPS-PTL-029	Protocol
733	CO-IT-REG-028	Registers
734	CO-QA-SOP-031	Standard Operating Procedure
735	CO-LAB-SOP-006	Standard Operating Procedure
736	CO-PRD1-PTL-101	Protocol
737	CO-PRD1-FRM-199	Forms
738	CO-QA-SOP-237	Standard Operating Procedure
739	CO-SUP-SOP-040	Standard Operating Procedure
740	CO-QC-COP-001	Code of Practice
741	CO-LAB-PTL-046	Protocol
742	CO-QA-SOP-283	Standard Operating Procedure
743	CO-PRD1-FRM-187	Forms
744	CO-LAB-FRM-023	Forms
745	CO-PRD1-URS-026	User Requirements Specification
746	CO-OPS-JA-020	Job Aid
747	CO-LAB-SOP-163	Standard Operating Procedure
748	CO-IT-POL-031	Policy
749	CO-LAB-FRM-081	Forms
750	CO-PRD1-FRM-185	Forms
751	CO-LAB-FRM-109	Forms
752	CO-DES-T-040	Templates
753	CO-SUP-SOP-041	Standard Operating Procedure
754	CO-DPT-IFU-014	Instructions For Use
755	CO-QC-T-096	Templates
756	CO-PRD1-PTL-086	Protocol
757	CO-PRD1-PTL-104	Protocol
758	CO-SUP-FRM-214	Forms
759	CO-DES-T-061	Templates
760	CO-LAB-LBL-016	Label
761	CO-LAB-FRM-072	Forms
762	CO-SUP-SOP-007	Standard Operating Procedure
763	CO-SUP-JA-055	Job Aid
764	CO-PRD1-FRM-223	Forms
765	CO-OPS-SOP-007	Standard Operating Procedure
766	CO-OPS-REG-026	Registers
767	CO-CS-T-131	Templates
768	CO-LAB-FRM-079	Forms
769	CO-LAB-FRM-126	Forms
770	CO-PRD1-PTL-091	Protocol
771	CO-QC-PTL-072	Protocol
772	CO-SUP-SOP-053	Standard Operating Procedure
773	CO-DPT-BOM-010	Bill of Materials
774	CO-LAB-LBL-053	Label
775	CO-IT-POL-032	Policy
776	CO-OPS-SOP-192	Standard Operating Procedure
777	CO-LAB-LBL-022	Label
778	CO-DES-SOP-004	Standard Operating Procedure
779	CO-LAB-FRM-018	Forms
780	CO-QA-SOP-030	Standard Operating Procedure
781	CO-OPS-SOP-035	Standard Operating Procedure
782	CO-PRD1-FRM-251	Forms
783	CO-PRD1-SOP-252	Standard Operating Procedure
784	CO-SUP-FRM-048	Forms
785	CO-SUP-JA-038	Job Aid
786	CO-QC-PTL-070	Protocol
787	CO-QC-QCP-054	Quality Control Protocol
788	CO-SUP-SOP-321	Standard Operating Procedure
789	CO-DPT-IFU-038	Instructions For Use
790	CO-LAB-REG-013	Registers
791	CO-H&S-RA-004	H&S Risk Assessments
792	CO-LAB-PTL-045	Protocol
793	CO-PRD1-PTL-092	Protocol
794	CO-LAB-FRM-015	Forms
795	CO-SUP-FRM-220	Forms
796	CO-PRD1-LBL-029	Label
797	CO-OPS-URS-018	User Requirements Specification
798	CO-LAB-SOP-159	Standard Operating Procedure
799	CO-QC-T-118	Templates
800	CO-OPS-SOP-134	Standard Operating Procedure
801	CO-QA-POL-010	Policy
802	CO-DPT-IFU-003	Instructions For Use
803	CO-PRD1-FRM-253	Forms
804	CO-QC-T-016	Templates
805	CO-QA-SOP-003	Standard Operating Procedure
806	CO-LAB-FRM-107	Forms
807	CO-SUP-SOP-043	Standard Operating Procedure
808	CO-PRD1-FRM-242	Forms
809	CO-OPS-PTL-043	Protocol
810	CO-QA-SOP-345	Standard Operating Procedure
811	CO-QA-JA-021	Job Aid
812	CO-LAB-FRM-027	Forms
813	CO-CA-SOP-081	Standard Operating Procedure
814	CO-SUP-SOP-070	Standard Operating Procedure
815	CO-QA-T-193	Templates
816	CO-LAB-FRM-050	Forms
817	CO-OPS-SOP-132	Standard Operating Procedure
818	CO-PRD1-REG-035	Registers
819	CO-QA-JA-002	Job Aid
820	CO-PRD1-T-179	Templates
821	CO-LAB-SOP-181	Standard Operating Procedure
822	CO-OPS-POL-011	Policy
823	CO-DPT-IFU-012	Instructions For Use
824	CO-LAB-FRM-007	Forms
825	CO-PRD1-LBL-047	Label
826	CO-QC-QCP-064	Quality Control Protocol
827	CO-LAB-FRM-137	Forms
828	CO-SUP-SOP-069	Standard Operating Procedure
829	CO-DPT-BOM-002	Bill of Materials
830	CO-PRD1-FRM-241	Forms
831	CO-PRD1-SOP-309	Standard Operating Procedure
832	CO-QA-REG-032	Registers
833	CO-QA-SOP-326	Standard Operating Procedure
834	CO-PRD1-SOP-313	Standard Operating Procedure
835	CO-PRD1-T-163	Templates
836	CO-QA-T-194	Templates
837	CO-LAB-FRM-112	Forms
838	CO-QC-QCP-052	Quality Control Protocol
839	CO-LAB-LBL-011	Label
840	CO-LAB-REG-021	Registers
841	CO-DPT-BOM-007	Bill of Materials
842	CO-QC-SOP-293	Standard Operating Procedure
843	CO-LAB-FRM-139	Forms
844	CO-LAB-SOP-102	Standard Operating Procedure
845	CO-PRD1-PTL-088	Protocol
846	CO-PRD1-POL-016	Policy
847	CO-DPT-VID-004	Instructional Videos
848	CO-PRD1-PTL-106	Protocol
849	CO-SUP-FRM-043	Forms
850	CO-H&S-COSHH-005	COSHH Assessment
851	CO-LAB-FRM-058	Forms
852	CO-QC-QCP-053	Quality Control Protocol
853	CO-SUP-FRM-218	Forms
854	CO-QC-T-029	Templates
855	CO-LAB-FRM-102	Forms
856	CO-LAB-SOP-108	Standard Operating Procedure
857	CO-DPT-IFU-024	Digital Product Technology
858	CO-LAB-FRM-093	Forms
859	CO-H&S-COSHH-002	COSHH Assessment
860	CO-SD-FRM-171	Forms
861	CO-LAB-FRM-090	Forms
862	CO-QA-SOP-147	Standard Operating Procedure
863	CO-QC-T-102	Templates
864	CO-QA-T-158	Templates
865	CO-LAB-LBL-023	Label
866	CO-SUP-JA-065	Job Aid
867	CO-SUP-SOP-231	Standard Operating Procedure
868	CO-DPT-FEA-002	Digital Feature
869	CO-QA-T-166	Templates
870	CO-LAB-SOP-130	Standard Operating Procedure
871	CO-LAB-FRM-110	Forms
872	CO-QA-SOP-028	Standard Operating Procedure
873	CO-QC-SOP-286	Standard Operating Procedure
874	CO-SUP-SOP-045	Standard Operating Procedure
875	CO-LAB-LBL-021	Label
876	CO-PRD1-FRM-254	Forms
877	CO-PRD1-FRM-228	Forms
878	CO-OPS-SOP-128	Standard Operating Procedure
879	CO-DPT-ART-010	Artwork
880	CO-LAB-FRM-127	Forms
881	CO-QC-T-115	Templates
882	CO-H&S-RA-018	H&S Risk Assessments
883	CO-SUP-T-201	Templates
884	CO-SAM-JA-048	Job Aid
885	CO-PRD1-FRM-246	Forms
886	CO-PRD1-JA-070	Job Aid
887	CO-IT-POL-023	Policy
888	CO-SUP-JA-057	Job Aid
889	CO-OPS-PTL-022	Protocol
890	CO-LAB-SOP-013	Standard Operating Procedure
891	CO-LAB-SOP-019	Standard Operating Procedure
892	CO-SUP-JA-026	Job Aid
893	CO-OPS-URS-009	User Requirements Specification
894	CO-LAB-FRM-085	Forms
895	CO-LAB-FRM-099	Forms
896	CO-DES-SOP-372	Standard Operating Procedure
897	CO-LAB-FRM-180	Forms
898	CO-LAB-REG-017	Registers
899	CO-PRD1-FRM-234	Forms
900	CO-QC-QCP-060	Quality Control Protocol
901	CO-LAB-SOP-012	Standard Operating Procedure
902	CO-PRD1-SOP-355	Standard Operating Procedure
903	CO-QA-JA-006	Job Aid
904	CO-QA-JA-015	Job Aid
905	CO-DES-T-129	Templates
906	CO-PRD1-PTL-110	Protocol
907	CO-SUP-SOP-058	Standard Operating Procedure
908	CO-PRD1-URS-022	User Requirements Specification
909	CO-LAB-SOP-295	Standard Operating Procedure
910	CO-DPT-BOM-023	Bill of Materials
911	CO-DPT-ART-008	Artwork
912	CO-DPT-IFU-026	Digital Product Technology
913	CO-QA-T-012	Templates
914	CO-DPT-BOM-014	Bill of Materials
915	CO-SUP-JA-068	Job Aid
916	CO-LAB-FRM-278	Forms
917	CO-PRD1-SOP-258	Standard Operating Procedure
918	CO-QC-LBL-052	Label
919	CO-PRD1-FRM-255	Forms
920	CO-QC-QCP-062	Quality Control Protocol
921	CO-QC-T-031	Templates
922	CO-SUP-SOP-003	Standard Operating Procedure
923	CO-OPS-PTL-028	Protocol
924	CO-PRD1-FRM-244	Forms
925	CO-OPS-SOP-202	Standard Operating Procedure
926	CO-OPS-T-002	Templates
927	CO-DPT-BOM-008	Bill of Materials
928	CO-DPT-IFU-009	Instructions For Use
929	CO-DPT-IFU-041	Instructions For Use
930	CO-LAB-FRM-088	Forms
931	CO-DES-PTL-008	Protocol
932	CO-PRD1-SOP-370	Standard Operating Procedure
933	CO-SUP-SOP-050	Standard Operating Procedure
934	CO-PRD1-FRM-239	Forms
935	CO-DPT-IFU-005	Instructions For Use
936	CO-LAB-FRM-092	Forms
937	CO-OPS-SOP-088	Standard Operating Procedure
938	CO-QC-QCP-061	Quality Control Protocol
939	CO-LAB-FRM-277	Forms
940	CO-PRD1-LBL-049	Label
941	CO-QA-T-196	Templates
942	CO-OPS-SOP-190	Standard Operating Procedure
943	CO-DPT-IFU-002	Instructions For Use
944	CO-PRD1-T-165	Templates
945	CO-DES-PTL-002	Protocol
946	CO-DPT-BOM-011	Bill of Materials
947	CO-LAB-FRM-140	Forms
948	CO-LAB-FRM-119	Forms
949	CO-SUP-FRM-177	Forms
950	CO-PRD1-LBL-035	Label
951	CO-PRD1-PTL-075	Protocol
952	CO-PRD1-FRM-279	Forms
953	CO-PRD1-SOP-306	Standard Operating Procedure
954	CO-DPT-IFU-016	Instructions For Use
955	CO-QA-T-047	Templates
956	CO-DES-SOP-041	Standard Operating Procedure
957	CO-PRD1-FRM-248	Forms
958	CO-LAB-LBL-013	Label
959	CO-QC-T-071	Templates
960	CO-QC-T-032	Templates
961	CO-H&S-T-204	Templates
962	CO-QA-REG-041	Registers
963	CO-QC-T-009	Templates
964	CO-QA-T-008	Templates
965	CO-FIN-T-026	Templates
966	CO-QA-SOP-012	Standard Operating Procedure
967	CO-QC-QCP-056	Quality Control Protocol
968	CO-PRD1-SOP-268	Standard Operating Procedure
969	CO-H&S-COSHH-009	COSHH Assessment
970	CO-OPS-SOP-187	Standard Operating Procedure
971	CO-QC-T-030	Templates
972	CO-SUP-JA-029	Job Aid
973	CO-OPS-URS-012	User Requirements Specification
974	CO-LAB-FRM-114	Forms
975	CO-PRD1-PTL-094	Protocol
976	CO-OPS-SOP-118	Standard Operating Procedure
977	CO-QC-PTL-066	Protocol
978	CO-LAB-LBL-012	Label
979	CO-LAB-REG-011	Registers
980	CO-OPS-SOP-228	Standard Operating Procedure
981	CO-QA-T-049	Templates
982	CO-QA-SOP-244	Standard Operating Procedure
983	CO-DPT-VID-005	Instructional Videos
984	CO-QA-T-206	Templates
985	CO-LAB-SOP-004	Standard Operating Procedure
986	CO-LAB-SOP-135	Standard Operating Procedure
987	CO-LAB-SOP-010	Standard Operating Procedure
988	CO-DES-T-125	Templates
989	CO-LAB-SOP-145	Standard Operating Procedure
990	CO-PRD1-FRM-186	Forms
991	CO-OPS-PTL-024	Protocol
992	CO-PRD1-PTL-089	Protocol
993	CO-LAB-SOP-160	Standard Operating Procedure
994	CO-PRD1-LBL-043	Label
995	CO-LAB-LBL-003	Label
996	CO-OPS-SOP-084	Standard Operating Procedure
997	CO-LAB-SOP-129	Standard Operating Procedure
998	CO-LAB-FRM-022	Forms
999	CO-DPT-ART-006	Artwork
1000	CO-PRD1-SOP-260	Standard Operating Procedure
1001	CO-PRD1-SOP-365	Standard Operating Procedure
1002	CO-PRD1-FRM-238	Forms
1003	CO-PRD1-FRM-240	Forms
1004	CO-LAB-SOP-158	Standard Operating Procedure
1005	CO-H&S-COSHH-004	COSHH Assessment
1006	CO-LAB-FRM-084	Forms
1007	CO-LAB-SOP-287	Standard Operating Procedure
1008	CO-OPS-SOP-172	Standard Operating Procedure
1009	CO-QA-SOP-267	Standard Operating Procedure
1010	CO-DPT-IFU-013	Instructions For Use
1011	CO-LAB-SOP-020	Standard Operating Procedure
1012	CO-DES-T-059	Templates
1013	CO-QA-T-141	Templates
1014	CO-SUP-T-098	Templates
1015	CO-OPS-T-152	Templates
1016	CO-LAB-SOP-022	Standard Operating Procedure
1017	CO-DPT-BOM-021	Bill of Materials
1018	CO-LAB-URS-029	User Requirements Specification
1019	CO-LAB-SOP-002	Standard Operating Procedure
1020	CO-H&S-RA-001	H&S Risk Assessments
1021	CO-DPT-BOM-020	Bill of Materials
1022	CO-LAB-SOP-138	Standard Operating Procedure
1023	CO-OPS-SOP-124	Standard Operating Procedure
1024	CO-LAB-FRM-108	Forms
1025	CO-QC-T-028	Templates
1026	CO-QC-PTL-109	Protocol
1027	CO-H&S-P-002	H&S Policy
1028	CO-PRD1-FRM-249	Forms
1029	CO-PRD1-FRM-229	Forms
1030	CO-PRD1-SOP-319	Standard Operating Procedure
1031	CO-PRD1-FRM-232	Forms
1032	CO-DPT-IFU-022	Digital Product Technology
1033	CO-LAB-LBL-009	Label
1034	CO-SUP-SOP-025	Standard Operating Procedure
1035	CO-H&S-PRO-005	H&S Procedures
1036	CO-OPS-SOP-034	Standard Operating Procedure
1037	CO-DES-T-067	Templates
1038	CO-DPT-ART-011	Artwork
1039	CO-PRD1-SOP-264	Standard Operating Procedure
1040	CO-OPS-SOP-032	Standard Operating Procedure
1041	CO-CS-SOP-368	Standard Operating Procedure
1042	CO-LAB-FRM-207	Forms
1043	CO-SUP-LBL-051	Label
1044	CO-DES-T-062	Templates
1045	CO-SUP-SOP-001	Standard Operating Procedure
1046	CO-SUP-SOP-059	Standard Operating Procedure
1047	CO-H&S-RA-002	H&S Risk Assessments
1048	CO-SAM-SOP-009	Standard Operating Procedure
1049	CO-LAB-LBL-019	Label
1050	CO-OPS-PTL-039	Protocol
1051	CO-LAB-FRM-063	Forms
1052	CO-OPS-SOP-109	Standard Operating Procedure
1053	CO-DPT-WEB-010	Website Content
1054	CO-CA-FRM-041	Forms
1055	CO-PRD1-SOP-263	Standard Operating Procedure
1056	CO-LAB-LBL-008	Label
1057	CO-SAM-JA-049	Job Aid
1058	CO-OPS-SOP-036	Standard Operating Procedure
1059	CO-LAB-T-148	Templates
1060	CO-OPS-URS-008	User Requirements Specification
1061	CO-QC-PTL-016	Protocol
1062	CO-SUP-POL-035	Policy
1063	CO-DPT-BOM-005	Bill of Materials
1064	CO-DES-T-004	Templates
1065	CO-H&S-COSHH-001	COSHH Assessment
1066	CO-QA-SOP-098	Standard Operating Procedure
1067	CO-OPS-SOP-133	Standard Operating Procedure
1068	CO-QC-SOP-012	Standard Operating Procedure
1069	CO-LAB-FRM-060	Forms
1070	CO-QC-PTL-069	Protocol
1071	CO-QC-QCP-066	Quality Control Protocol
1072	CO-QC-SOP-021	Standard Operating Procedure
1073	CO-H&S-RA-015	H&S Risk Assessments
1074	CO-QA-JA-014	Job Aid
1075	CO-LAB-FRM-011	Forms
1076	CO-CS-FRM-175	Forms
1077	CO-LAB-FRM-066	Forms
1078	CO-DES-T-065	Templates
1079	CO-SUP-T-182	Templates
1080	CO-QA-REG-005	Registers
1081	CO-SUP-FRM-178	Forms
1082	CO-DPT-IFU-028	Instructions For Use
1083	CO-SUP-SOP-039	Standard Operating Procedure
1084	CO-LAB-FRM-104	Forms
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, doc_id, documentname, rev, department, documentcode, documenttype, documentnumber, risklevel) FROM stdin;
1	14	Design and Development Procedure	10	Design	CO-DES-SOP-029	Standard Operating Procedure		0
2	15	CE Mark/Technical File Procedure	6	Design	CO-DES-SOP-243	Standard Operating Procedure		0
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
619	1000	At-Home Blood Spot Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-001	Instructions For Use		0
620	1001	At-Home Blood Spot Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-002	Instructions For Use		0
621	1002	At-Home Blood Spot Collection Kit IFU  English Digital Version	4	Digital Product Technology	CO-DPT-IFU-003	Instructions For Use		0
622	1003	At-Home Blood Spot Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	CO-DPT-IFU-004	Instructions For Use		0
623	1004	At-Home Vaginal Swab Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-005	Instructions For Use		0
624	1005	At-Home Vaginal Swab Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-006	Instructions For Use		0
625	1006	At-Home Vaginal Swab Collection Kit IFU  English Digital Version	4	Digital Product Technology	CO-DPT-IFU-007	Instructions For Use		0
626	1007	At-Home Vaginal Swab Collection Kit IFU  Spanish Digital Print	4	Digital Product Technology	CO-DPT-IFU-008	Instructions For Use		0
627	1008	At-Home Female Triple Site Collection Kit IFU  English Print Version	5	Digital Product Technology	CO-DPT-IFU-009	Instructions For Use		0
628	1009	At-Home Female Triple Site Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	CO-DPT-IFU-010	Instructions For Use		0
629	1010	At-Home Female Triple Site Collection Kit IFU  English Digital Version	5	Digital Product Technology	CO-DPT-IFU-011	Instructions For Use		0
630	1011	At-Home Female Triple Site Collection Kit IFU  Spanish Digital Version	5	Digital Product Technology	CO-DPT-IFU-012	Instructions For Use		0
631	1012	123 At-Home Card  English Version	2	Digital Product Technology	CO-DPT-IFU-013	Instructions For Use		0
632	1013	At-Home Male Triple Site Collection Kit IFU  English Print Version	4	Digital Product Technology	CO-DPT-IFU-014	Instructions For Use		0
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
\.


--
-- Data for Name: documents_temp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents_temp (doc_id, documentcode, documentname, rev, department, documenttype, risklevel) FROM stdin;
14	CO-DES-SOP-029	Design and Development Procedure	10	Design	Standard Operating Procedure	0
15	CO-DES-SOP-243	CE Mark/Technical File Procedure	6	Design	Standard Operating Procedure	0
16	CO-DES-SOP-004	Software Development Procedure	4	Design	Standard Operating Procedure	0
17	CO-SUP-SOP-001	Procedure for Commercial Storage and Distribution	2	Supply Chain	Standard Operating Procedure	0
18	CO-CS-SOP-368	Instrument Service & Repair Procedure	5	Customer Support	Standard Operating Procedure	0
19	CO-SUP-SOP-003	Procedure for Inventry Control and BIP	1	Supply Chain	Standard Operating Procedure	0
21	CO-SUP-SOP-005	New Customer Procedure	2	Supply Chain	Standard Operating Procedure	0
22	CO-SUP-SOP-006	Equipment Fulfilment and Field Visit SOP for non-stock instruments	2	Supply Chain	Standard Operating Procedure	0
24	CO-OPS-SOP-002	Planning for Process Validation	3	Operations	Standard Operating Procedure	0
38	CO-SUP-SOP-013	Customer Returns	2	Supply Chain	Standard Operating Procedure	0
40	CO-DES-SOP-371	Critical to Quality and Reagent Design Control	2	Design	Standard Operating Procedure	0
41	CO-DES-SOP-372	Reagent Design Transfer process	2	Design	Standard Operating Procedure	0
65	CO-QA-SOP-140	Document Control Procedure  Projects	19	Quality Assurance	Standard Operating Procedure	0
66	CO-QA-SOP-098	Document Matrix	7	Quality Assurance	Standard Operating Procedure	0
69	CO-QA-SOP-005	Document and Records Archiving	5	Quality Assurance	Standard Operating Procedure	0
70	CO-QA-SOP-003	Nonconforming Product Procedure	18	Quality Assurance	Standard Operating Procedure	0
71	CO-QA-SOP-004	Internal Audit	12	Quality Assurance	Standard Operating Procedure	0
73	CO-QA-SOP-326	Vigilance and Medical Reporting Procedure	7	Quality Assurance	Standard Operating Procedure	0
74	CO-QA-SOP-007	Correction Removal and Recall Procedure	5	Quality Assurance	Standard Operating Procedure	0
85	CO-SUP-SOP-025	Quality Control	2	Supply Chain	Standard Operating Procedure	0
144	CO-QA-SOP-345	Root Cause Analysis	4	Quality Assurance	Standard Operating Procedure	0
146	CO-QA-SOP-267	Post Market Surveillance	8	Quality Assurance	Standard Operating Procedure	0
147	CO-QA-SOP-011	Supplier Corrective Action Response Procedure	6	Quality Assurance	Standard Operating Procedure	0
148	CO-QA-SOP-012	Annual Quality Objectives	8	Quality Assurance	Standard Operating Procedure	0
151	CO-QA-SOP-015	Qualification and Competence of Auditors	3	Quality Assurance	Standard Operating Procedure	0
152	CO-QA-SOP-016	Identification and Traceabillity	2	Quality Assurance	Standard Operating Procedure	0
155	CO-SUP-SOP-037	Complete QC Inspections	2	Supply Chain	Standard Operating Procedure	0
156	CO-SUP-SOP-038	Change of Stock  QC Release	2	Supply Chain	Standard Operating Procedure	0
157	CO-SUP-SOP-039	Manage Quality Codes	2	Supply Chain	Standard Operating Procedure	0
158	CO-SUP-SOP-040	New Customer Set-Up	2	Supply Chain	Standard Operating Procedure	0
159	CO-SUP-SOP-041	Customer Sales Contracts	2	Supply Chain	Standard Operating Procedure	0
160	CO-SUP-SOP-042	Enter & Release Sales Orders	2	Supply Chain	Standard Operating Procedure	0
161	CO-SUP-SOP-043	Mark Sales Orders as Despatched	2	Supply Chain	Standard Operating Procedure	0
162	CO-SUP-SOP-044	Invoice Customers Manually	2	Supply Chain	Standard Operating Procedure	0
163	CO-SUP-SOP-045	Cutomer Price Lists	2	Supply Chain	Standard Operating Procedure	0
164	CO-SUP-SOP-046	Create New Customer Return	2	Supply Chain	Standard Operating Procedure	0
177	CO-SUP-SOP-047	Transfer Orders	2	Supply Chain	Standard Operating Procedure	0
178	CO-SUP-SOP-048	Raise PO - non-Stock & Services	3	Supply Chain	Standard Operating Procedure	0
179	CO-SUP-SOP-049	Receive Non-Stock PO	4	Supply Chain	Standard Operating Procedure	0
180	CO-SUP-SOP-050	Raise PO - Stock Items	2	Supply Chain	Standard Operating Procedure	0
181	CO-SUP-SOP-051	Receive Stock Purchase Orders	2	Supply Chain	Standard Operating Procedure	0
182	CO-SUP-SOP-052	New Supplier Set-Up	2	Supply Chain	Standard Operating Procedure	0
183	CO-SUP-SOP-053	Raise & Release Production Order	2	Supply Chain	Standard Operating Procedure	0
184	CO-SUP-SOP-054	Complete Production Order	2	Supply Chain	Standard Operating Procedure	0
185	CO-SUP-SOP-055	Goods Movement	2	Supply Chain	Standard Operating Procedure	0
186	CO-SUP-SOP-056	Check Sales Order due Date	1	Supply Chain	Standard Operating Procedure	0
208	CO-SUP-SOP-057	Consume to Cost Centre or Project	2	Supply Chain	Standard Operating Procedure	0
209	CO-SUP-SOP-058	Inspection Plans	2	Supply Chain	Standard Operating Procedure	0
210	CO-SUP-SOP-059	Credit Customer Returns	2	Supply Chain	Standard Operating Procedure	0
211	CO-SUP-SOP-060	Customer Returns	2	Supply Chain	Standard Operating Procedure	0
212	CO-SUP-SOP-061	New Project Set-Up	2	Supply Chain	Standard Operating Procedure	0
213	CO-SUP-SOP-062	Add Team Member to a Task	2	Supply Chain	Standard Operating Procedure	0
214	CO-SUP-SOP-063	Book Time Against A Project	2	Supply Chain	Standard Operating Procedure	0
215	CO-SUP-SOP-064	Create a PO Within a Project	2	Supply Chain	Standard Operating Procedure	0
216	CO-SUP-SOP-065	Complete a Time Sheet	2	Supply Chain	Standard Operating Procedure	0
217	CO-SUP-SOP-066	SAP Manager Approvals App	2	Supply Chain	Standard Operating Procedure	0
218	CO-SUP-SOP-067	Managing Expired Identified Stock	2	Supply Chain	Standard Operating Procedure	0
245	CO-SAM-SOP-009	Control of Marketing and Promotion	5	Sales and Marketing	Standard Operating Procedure	0
247	CO-LAB-FRM-001	Part No 0001 Agarose	4	Laboratory	Forms	0
248	CO-LAB-FRM-002	Glycerol  For molecular biology	4	Laboratory	Forms	0
249	CO-LAB-FRM-003	Ethanol  Absolute	6	Laboratory	Forms	0
250	CO-LAB-FRM-004	TRIS  TRIZMA  Base	5	Laboratory	Forms	0
251	CO-LAB-FRM-005	100bp low MW Ladder	4	Laboratory	Forms	0
252	CO-LAB-FRM-006	Triton X-100	4	Laboratory	Forms	0
253	CO-LAB-FRM-007	0.5M EDTA solution	4	Laboratory	Forms	0
335	CO-LAB-SOP-019	Use of the LMS Programmable Incubator	2	Laboratory	Standard Operating Procedure	0
254	CO-LAB-FRM-008	Part No. 0117 Sterile Syringe filter with 0.2 µm cellulose acetate membrane	6	Laboratory	Forms	0
255	CO-LAB-FRM-009	D- + -Trehalose Dihydrate	4	Laboratory	Forms	0
256	CO-LAB-FRM-010	2mL ENAT Transport media	4	Laboratory	Forms	0
257	CO-LAB-FRM-011	Part no. 0141 Albumin from Bovine serum	5	Laboratory	Forms	0
258	CO-LAB-FRM-012	Microbank Cryovials	4	Laboratory	Forms	0
259	CO-LAB-FRM-013	Triton x305	6	Laboratory	Forms	0
260	CO-LAB-FRM-014	Part No 0180 Brij 58	6	Laboratory	Forms	0
261	CO-LAB-FRM-015	Part No 0181 ROSS fill solution pH Electrode	3	Laboratory	Forms	0
262	CO-LAB-FRM-016	CT Taqman Probe  FAM	5	Laboratory	Forms	0
263	CO-LAB-FRM-017	IC Taqman Probe  FAM	5	Laboratory	Forms	0
264	CO-LAB-SOP-002	Agilent Bioanalyzer SOP for RNA 6000 Pico and Nano Kits	4	Laboratory	Standard Operating Procedure	0
265	CO-LAB-SOP-003	Validation of Temperature Controlled Equipment	3	Laboratory	Standard Operating Procedure	0
266	CO-LAB-SOP-004	Use of the Bolt Mini Gel Tank for protein Electrophoresis	3	Laboratory	Standard Operating Procedure	0
267	CO-LAB-SOP-005	Rhychiger Heat Sealer	3	Laboratory	Standard Operating Procedure	0
268	CO-LAB-SOP-006	Esco Laminar Flow Cabinet	2	Laboratory	Standard Operating Procedure	0
269	CO-OPS-SOP-007	Firmware Up-date	2	Operations	Standard Operating Procedure	0
270	CO-OPS-SOP-008	Thermal Test Rig Set Up and Calibration	3	Operations	Standard Operating Procedure	0
271	CO-OPS-SOP-009	Reader Peltier Refit procedure	3	Operations	Standard Operating Procedure	0
272	CO-LAB-SOP-010	Reagent Deposition and Immobilisation  Pilot Line	4	Laboratory	Standard Operating Procedure	0
273	CO-LAB-SOP-011	Eppendorf 5424 Centrifuge	2	Laboratory	Standard Operating Procedure	0
274	CO-LAB-SOP-012	Binder KBF-115 Oven	2	Laboratory	Standard Operating Procedure	0
277	CO-OPS-SOP-124	Glycerol Solution	3	Operations	Standard Operating Procedure	0
278	CO-OPS-SOP-125	IC DNA in TE Buffer 100pg/ul Working Stock Aliquots	3	Operations	Standard Operating Procedure	0
279	CO-OPS-SOP-117	Manufacture of IC DNA Reagent’	5	Operations	Standard Operating Procedure	0
280	CO-OPS-SOP-118	Manufacture of CT/IC Primer Passivation Reagent	5	Operations	Standard Operating Procedure	0
281	CO-OPS-SOP-119	Manufacture of NG1/NG2/IC Primer Passivation Reagent	8	Operations	Standard Operating Procedure	0
282	CO-OPS-SOP-110	225mM Potassium phosphate buffer	3	Operations	Standard Operating Procedure	0
283	CO-OPS-SOP-114	9.26pc  w.v  NZ Source BSA in 208.3mM Potassium Phosphate buffer	3	Operations	Standard Operating Procedure	0
284	CO-OPS-SOP-113	9.26pc  w.v  BSA in 208.3 mM Potassium Phosphate buffer	3	Operations	Standard Operating Procedure	0
285	CO-OPS-SOP-120	CTNG Storage Buffer  224.3mM Potassium Phosphate	3	Operations	Standard Operating Procedure	0
286	CO-OPS-T-001	Material Transfer Agreement	4	Operations	Templates	0
287	CO-OPS-T-002	Material Transfer Agreement  binx recipient	2	Operations	Templates	0
288	CO-SUP-T-003	binx Purchase Order Form	8	Supply Chain	Templates	0
289	CO-DES-T-004	Design Review Record	2	Design	Templates	0
290	CO-DES-T-005	Phase Review Record	2	Design	Templates	0
292	CO-QA-T-007	External Change Notification Form	6	Quality Assurance	Templates	0
293	CO-QA-T-008	Change Management Form	12	Quality Assurance	Templates	0
294	CO-QC-T-009	Template for IQC	6	Quality Control	Templates	0
295	CO-QA-T-010	Policy Template	5	Quality Assurance	Templates	0
296	CO-QA-T-011	Form Template	5	Quality Assurance	Templates	0
297	CO-QA-T-012	Internal Training Form	4	Quality Assurance	Templates	0
301	CO-QC-T-016	Lab Cleaning Form	8	Quality Control	Templates	0
304	CO-OPS-T-019	Manufacturing Partner Ranking Criteria	2	Operations	Templates	0
305	CO-OPS-T-020	Development Partner Ranking	2	Operations	Templates	0
306	CO-OPS-T-021	Generic PSP Ranking Criteria  template	2	Operations	Templates	0
307	CO-DES-T-022	IVD Directive - Essential Requirements Check List Template	4	Design	Templates	0
308	CO-QC-T-023	Solution Preparation Form	3	Quality Control	Templates	0
310	CO-DES-T-025	Validation Protocol template	8	Design	Templates	0
311	CO-FIN-T-026	IT GAMP Evaluation Form	4	Finance	Templates	0
312	CO-FIN-T-027	IT Request for Information	3	Finance	Templates	0
313	CO-QC-T-028	Balance Calibration form	3	Quality Control	Templates	0
314	CO-QC-T-029	Incubator Monitoring Form	4	Quality Control	Templates	0
315	CO-QC-T-030	pH Meter Calibration Form	3	Quality Control	Templates	0
316	CO-QC-T-031	Dishwasher User Form	3	Quality Control	Templates	0
317	CO-QC-T-032	Equipment Log	3	Quality Control	Templates	0
318	CO-QC-T-033	Autoclave Record	5	Quality Control	Templates	0
320	CO-QC-T-035	Rework Protocol Template	4	Quality Control	Templates	0
321	CO-DES-T-036	Experimental template: Planning	5	Design	Templates	0
322	CO-LAB-FRM-018	CTdi452 Probe from atdbio	6	Laboratory	Forms	0
323	CO-LAB-FRM-019	Synthetic Uracil containing Amplicon	3	Laboratory	Forms	0
324	CO-LAB-FRM-020	Elution Reagent	4	Laboratory	Forms	0
325	CO-LAB-FRM-021	NG1  di452 Probe from SGS	5	Laboratory	Forms	0
326	CO-LAB-FRM-022	NG2  di452 Probe from SGS	5	Laboratory	Forms	0
327	CO-LAB-FRM-023	6x DNA loading dye Atlas Part Number 0327	2	Laboratory	Forms	0
328	CO-LAB-FRM-024	GelRed Nucleic Acid Stain Atlas Part Number 0328	2	Laboratory	Forms	0
329	CO-LAB-SOP-013	Balance calibration	6	Laboratory	Standard Operating Procedure	0
330	CO-LAB-SOP-014	Thermo Orion Star pH meter	4	Laboratory	Standard Operating Procedure	0
331	CO-LAB-SOP-015	Use of the ALC PK121 centrifuges  refrigerated and non-refrigerated	3	Laboratory	Standard Operating Procedure	0
332	CO-LAB-SOP-016	Use of the Peqlab thermal cyclers	4	Laboratory	Standard Operating Procedure	0
333	CO-LAB-SOP-017	Use of the Jenway Spectrophotometer	3	Laboratory	Standard Operating Procedure	0
336	CO-LAB-SOP-020	Use of the Hulme Martin Pmpulse heat Sealer	2	Laboratory	Standard Operating Procedure	0
337	CO-QC-SOP-021	Use of Stuart SRT6D Roller Mixer	4	Quality Control	Standard Operating Procedure	0
338	CO-LAB-SOP-022	Operation & Maintenance of Grant SUB Aqua Pro 5  SAP5  unstirred Water Bath with Labarmor Beads	2	Laboratory	Standard Operating Procedure	0
339	CO-OPS-SOP-109	1 x lysis buffer	9	Operations	Standard Operating Procedure	0
340	CO-OPS-SOP-127	Potassium Phosphate Buffer	7	Operations	Standard Operating Procedure	0
342	CO-OPS-SOP-123	DTT Solution	8	Operations	Standard Operating Procedure	0
343	CO-OPS-SOP-122	Detection Surfactants Solution	9	Operations	Standard Operating Procedure	0
344	CO-OPS-SOP-121	CTNG T7 Diluent Rev 3.0  NZ source BSA	2	Operations	Standard Operating Procedure	0
345	CO-OPS-SOP-112	600pM Stocks of Synthetic Uracil containing Amplicon	3	Operations	Standard Operating Procedure	0
346	CO-OPS-SOP-111	50U/uL T7 Exonuclease in CTNG Storage Buffer	4	Operations	Standard Operating Procedure	0
347	CO-OPS-SOP-128	Preparation of TV 10 thousand cells/uL Master Stocks	2	Operations	Standard Operating Procedure	0
348	CO-OPS-SOP-116	Contrived Vaginal Matrix in eNAT	2	Operations	Standard Operating Procedure	0
350	CO-QA-T-038	binx Memorandum Template	7	Quality Assurance	Templates	0
352	CO-DES-T-040	binx Report Template	7	Design	Templates	0
353	CO-DES-T-041	binx Technical Report Template	7	Design	Templates	0
354	CO-QA-T-042	binx Meeting Minutes Template	5	Quality Assurance	Templates	0
355	CO-OPS-T-043	Mutual Agreement of Confidentiality	5	Operations	Templates	0
356	CO-QA-T-044	Training Competence Assessment Form	4	Quality Assurance	Templates	0
357	CO-QA-T-045	Additional Training Form	4	Quality Assurance	Templates	0
359	CO-QA-T-047	Individual Training Plan Template	9	Quality Assurance	Templates	0
360	CO-QA-T-048	Specimen Signature Log	4	Quality Assurance	Templates	0
361	CO-QA-T-049	Document Acceptance Form	5	Quality Assurance	Templates	0
363	CO-QC-T-051	Controlled Lab Notes Template	6	Quality Control	Templates	0
364	CO-SUP-FRM-046	Supplier Questionnaire - Calibration/Equipment maintenance	4	Supply Chain	Forms	0
365	CO-SUP-FRM-042	Supplier Questionnaire - Chemical/Reagent/Microbiological	4	Supply Chain	Forms	0
366	CO-SUP-FRM-047	Supplier Questionnaire - Hardware	4	Supply Chain	Forms	0
367	CO-SUP-FRM-048	Supplier Questionnaire - Consultant/Services	4	Supply Chain	Forms	0
370	CO-DES-T-058	Project Planning Template	4	Design	Templates	0
371	CO-DES-T-059	FMEA template	3	Design	Templates	0
372	CO-DES-T-060	Verification Testing Protocol template	8	Design	Templates	0
373	CO-DES-T-061	Verification Testing Report template	7	Design	Templates	0
374	CO-DES-T-062	Risk Management Plan template	3	Design	Templates	0
375	CO-DES-T-063	Risk/benefit template	3	Design	Templates	0
376	CO-DES-T-064	Risk Management Report template	3	Design	Templates	0
377	CO-DES-T-065	Validation Master Plan  or Plan  template	5	Design	Templates	0
378	CO-DES-T-066	Validation Matrix template	2	Design	Templates	0
379	CO-DES-T-067	Hazard Analysis template	8	Design	Templates	0
380	CO-DES-T-068	Experimental Template: Write Up	5	Design	Templates	0
381	CO-SAM-T-069	Copy Approval Form	3	Sales and Marketing	Templates	0
383	CO-QC-T-071	Detection Reagent Analysis Template	5	Quality Control	Templates	0
385	CO-QC-T-073	Microbiology Laboratory Cleaning record	8	Quality Control	Templates	0
388	CO-QC-T-076	Environmental Chamber Monitoring Form	3	Quality Control	Templates	0
390	CO-QA-T-078	Field Action Implementation Checklist	4	Quality Assurance	Templates	0
391	CO-QA-T-079	Field Corrective Action File Review Form	3	Quality Assurance	Templates	0
394	CO-QC-T-082	qPCR QC Testing Data Analysis	14	Quality Control	Templates	0
395	CO-DES-T-083	product requirements Specification Template	3	Design	Templates	0
396	CO-DES-T-084	Pilot Line Electronic Stock Register	5	Design	Templates	0
397	CO-SUP-FRM-043	Initial Risk Assessment and Supplier Approval	3	Supply Chain	Forms	0
398	CO-QA-T-086	Supplier Re-assessment Approval form	4	Quality Assurance	Templates	0
399	CO-QA-T-087	Standard / Guidance Review	4	Quality Assurance	Templates	0
407	CO-QC-T-095	Reagent Aliquot From	6	Quality Control	Templates	0
408	CO-QC-T-096	Quarterly Reagent Check Record	4	Quality Control	Templates	0
410	CO-SUP-T-098	Non Approved Supplier SAP by D supplier information	4	Supply Chain	Templates	0
411	CO-DES-T-099	Device Master Record	2	Design	Templates	0
412	CO-SUP-T-100	Purchase order terms & conditions	3	Supply Chain	Templates	0
413	CO-SAM-T-101	Marketing template	2	Sales and Marketing	Templates	0
414	CO-QC-T-102	CTNG Cartridge Cof A	11	Quality Control	Templates	0
415	CO-QC-T-103	Lab investigation initiation Template	1	Quality Control	Templates	0
417	CO-QC-T-105	T7 QC Testing Data Analysis	7	Quality Control	Templates	0
418	CO-QA-T-106	Vigilance Form	3	Quality Assurance	Templates	0
419	CO-QC-T-107	Bioanalyzer Cleaning Record	3	Quality Control	Templates	0
421	CO-QA-T-109	Archiving Box Contents List	3	Quality Assurance	Templates	0
422	CO-QA-T-110	Document Retrieval Request	3	Quality Assurance	Templates	0
423	CO-OPS-T-111	Generic Cartridge Subassembly Build	3	Operations	Templates	0
424	CO-DES-T-112	Pilot Line Use Log	6	Design	Templates	0
425	CO-SUP-T-113	Cartridge Stock Take Form	4	Supply Chain	Templates	0
426	CO-DES-T-114	Validation Summary Report	2	Design	Templates	0
427	CO-QC-T-115	Incoming Oligo QC Form	3	Quality Control	Templates	0
430	CO-QC-T-118	Moby Detection Reagent Analysis Spreadsheet	12	Quality Control	Templates	0
432	CO-QC-T-120	QC Laboratory Cleaning Record	4	Quality Control	Templates	0
433	CO-QC-T-121	Impulse Sealer Use Log	2	Quality Control	Templates	0
434	CO-FIN-FRM-282	Fixed Asset Transfer Form	2	Finance	Forms	0
435	CO-QA-T-123	CAPA date extension form	3	Quality Assurance	Templates	0
436	CO-DES-T-124	Design Transfer Form	2	Design	Templates	0
437	CO-DES-T-125	Software Development Tool Approval	2	Design	Templates	0
438	CO-DES-T-126	Soup Approval	2	Design	Templates	0
440	CO-QC-T-128	LAB investigation summary report	1	Quality Control	Templates	0
441	CO-DES-T-129	Customer Requirements Specification	1	Design	Templates	0
442	CO-OPS-T-130	Equipment Fulfilment Order	2	Operations	Templates	0
443	CO-CS-T-131	Customer Service Script	1	Customer Support	Templates	0
444	CO-CS-T-149	Instrument Trouble Shooting Script	1	Customer Support	Templates	0
446	CO-FIN-T-134	UK Trade Credit Application	2	Finance	Templates	0
447	CO-CS-T-135	Equipment Return Order	3	Customer Support	Templates	0
448	CO-QC-T-136	Reagent Design template	1	Quality Control	Templates	0
449	CO-QC-T-137	Limited Laboratory Access Work Note	1	Quality Control	Templates	0
450	CO-QC-T-138	Summary technical Documentation  for assay	2	Quality Control	Templates	0
451	CO-OPS-T-139	Cartridge and Packing Bill of Materials Template	1	Operations	Templates	0
452	CO-DES-PTL-001	Measuring pH values IQ/OQ Protocol	2	Design	Protocol	0
453	CO-DES-PTL-002	Validation of Abacus Guardian	2	Design	Protocol	0
454	CO-DES-T-140	Reagent Design Transfer Checklist	1	Design	Templates	0
455	CO-QA-T-141	Document Signoff Front Sheet	2	Quality Assurance	Templates	0
456	CO-QA-T-142	Document and Record Disposition Form	1	Quality Assurance	Templates	0
457	CO-QA-T-143	Training Plan Quarterly Sign Off Form	1	Quality Assurance	Templates	0
458	CO-QC-T-144	QC io Mainternance Log	2	Quality Control	Templates	0
459	CO-QA-T-145	Certificate of Conformance	1	Quality Assurance	Templates	0
460	CO-DES-PTL-003	Temperature controlled equipment	3	Design	Protocol	0
461	CO-DES-PTL-004	Monmouth 1200	2	Design	Protocol	0
462	CO-DES-PTL-005	IQ/OQ for Agilent Bioanalyzer	2	Design	Protocol	0
463	CO-DES-PTL-006	Balance IQ/OQ	3	Design	Protocol	0
464	CO-DES-PTL-007	Pilot Line Process & Equipment Validation	3	Design	Protocol	0
465	CO-DES-PTL-008	Calibration of V&V Laboratory Timers	3	Design	Protocol	0
467	CO-QA-SOP-024	Sharepoint Administration	2	Quality Assurance	Standard Operating Procedure	0
468	CO-QA-SOP-025	Management Review	11	Quality Assurance	Standard Operating Procedure	0
469	CO-QA-SOP-026	Use of Sharepoint	6	Quality Assurance	Standard Operating Procedure	0
470	CO-QA-SOP-028	Quality Records	9	Quality Assurance	Standard Operating Procedure	0
471	CO-QA-T-146	QT9 SOP Template	1	Quality Assurance	Templates	0
472	CO-QA-SOP-030	Accessing and Finding Documents in QT9	3	Quality Assurance	Standard Operating Procedure	0
473	CO-QA-SOP-031	Revising and Introducing Documents in QT9	3	Quality Assurance	Standard Operating Procedure	0
474	CO-OPS-SOP-032	Validation of Automated Equipment and Quality System Software	3	Operations	Standard Operating Procedure	0
475	CO-OPS-SOP-033	T7 Diluent  NZ Source BSA  Solution	3	Operations	Standard Operating Procedure	0
476	CO-OPS-SOP-034	Test Method Validation	3	Operations	Standard Operating Procedure	0
477	CO-OPS-SOP-035	Engineering Drawing Control	3	Operations	Standard Operating Procedure	0
478	CO-OPS-SOP-036	Instrument Engineering Change Management	2	Operations	Standard Operating Procedure	0
481	CO-SUP-SOP-068	Purchasing SOP	14	Supply Chain	Standard Operating Procedure	0
483	CO-DES-SOP-041	Design Review Work Instruction	6	Design	Standard Operating Procedure	0
484	CO-DES-SOP-042	Creation and Maintenance of a Device Master Record  DMR	4	Design	Standard Operating Procedure	0
485	CO-QA-SOP-043	Training Procedure	7	Quality Assurance	Standard Operating Procedure	0
486	CO-IT-SOP-044	IT Management Back-UP and Support	5	Information Technology	Standard Operating Procedure	0
487	CO-SUP-SOP-069	Supplier Evaluation	7	Supply Chain	Standard Operating Procedure	0
488	CO-SUP-SOP-070	Supplier Risk Assessment Approval and Monitoring Procedure	5	Supply Chain	Standard Operating Procedure	0
489	CO-SUP-SOP-072	Instructions for receipt of incoming Non-Stock goods  assigning GRN numbers and labelling	13	Supply Chain	Standard Operating Procedure	0
490	CO-SUP-SOP-073	Standard Cost Roll Up	2	Supply Chain	Standard Operating Procedure	0
491	CO-SUP-SOP-074	UK Stock Procurement & Movements  Supply Chain	2	Supply Chain	Standard Operating Procedure	0
492	CO-SUP-SOP-075	Order to Cash	2	Supply Chain	Standard Operating Procedure	0
493	CO-QA-REG-001	Change Management Register	9	Quality Assurance	Registers	0
497	CO-QA-REG-005	Supplier Concession Register	1	Quality Assurance	Registers	0
498	CO-QA-SOP-076	Stakeholder Feedback and Product Complaints Handling Procedure	8	Quality Assurance	Standard Operating Procedure	0
500	CO-QA-SOP-077	Supplier Audit Procedure	10	Quality Assurance	Standard Operating Procedure	0
501	CO-QA-REG-007	Bacterial Stock Register	2	Quality Assurance	Registers	0
502	CO-LAB-SOP-078	Preparation of Bacterial Stocks  Master & Working	6	Laboratory	Standard Operating Procedure	0
503	CO-LAB-SOP-079	Use and Cleaning of Class II Microbiology Safety Cabinet	7	Laboratory	Standard Operating Procedure	0
504	CO-LAB-SOP-080	Use of Agilent Bioanalyzer DNA 1000 kits	6	Laboratory	Standard Operating Procedure	0
505	CO-CA-SOP-081	Collection of In-house Collected Samples	2	Clinical Affairs	Standard Operating Procedure	0
506	CO-LAB-SOP-082	Use of the Rotary Vane Anemometer	1	Laboratory	Standard Operating Procedure	0
507	CO-OPS-SOP-083	Preparation of Trichomonas vaginalis 1 million Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	0
508	CO-OPS-SOP-084	Preparation of Trichomonas vaginalis 100 thousand Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	0
509	CO-OPS-SOP-085	Preparation of Chlamydia trachomatis 1 million Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	0
510	CO-OPS-SOP-086	Preparation of Chlamydia trachomatis 100 thousand Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	0
511	CO-OPS-SOP-087	Preparation of Neisseria gonorrhoeae 1 million Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	0
512	CO-OPS-SOP-088	Preparation of Neisseria gonorrhoeae 100 thousand Genome Equivalents/µL stocks	2	Operations	Standard Operating Procedure	0
513	CO-OPS-SOP-089	Preparation of vaginal swab samples	4	Operations	Standard Operating Procedure	0
514	CO-OPS-SOP-090	MFG for preparing male and female urine with 10% eNAT	3	Operations	Standard Operating Procedure	0
515	CO-OPS-SOP-091	Manufacture of TV/IC Detection Reagent	5	Operations	Standard Operating Procedure	0
516	CO-OPS-SOP-092	mSTI Cartridge Manufacture	3	Operations	Standard Operating Procedure	0
517	CO-QA-SOP-093	Corrective and Preventive Action Procedure	7	Quality Assurance	Standard Operating Procedure	0
518	CO-LAB-FRM-025	Tween-20 binx Part Number 0002	2	Laboratory	Forms	0
519	CO-LAB-FRM-026	T7 Gene 6 Exonuclease 1000U/µL	8	Laboratory	Forms	0
520	CO-LAB-FRM-027	Dimethylsulfoxide Part Number 0227	3	Laboratory	Forms	0
534	CO-CA-FRM-041	Consent for Voluntary Donation of In-house Collected Samples	2	Clinical Affairs	Forms	0
535	CO-QA-JA-001	A Basic Guide to Finding Documents in SharePoint	1	Quality Assurance	Job Aid	0
536	CO-OPS-PTL-009	Heated Detection Rig OQ Procedure	4	Operations	Protocol	0
537	CO-QC-SOP-094	Procedure to Control Chemical and Biological Spillages	5	Quality Control	Standard Operating Procedure	0
538	CO-LAB-SOP-095	Instrument Cleaning Procedure	5	Laboratory	Standard Operating Procedure	0
539	CO-QA-SOP-096	Analysis of Quality Data	5	Quality Assurance	Standard Operating Procedure	0
540	CO-LAB-SOP-097	Wireless Temperature and Humidity Monitoring	15	Laboratory	Standard Operating Procedure	0
541	CO-QA-SOP-099	Deviation Procedure	6	Quality Assurance	Standard Operating Procedure	0
543	CO-LAB-SOP-102	Use of the Grant XB2 Ultrasonic Bath	4	Laboratory	Standard Operating Procedure	0
544	CO-LAB-SOP-103	Environmental Controls in the Laboratory	12	Laboratory	Standard Operating Procedure	0
545	CO-OPS-SOP-104	CT_IC Detection Reagent	7	Operations	Standard Operating Procedure	0
546	CO-OPS-SOP-105	NG1_IC Detection Reagent	8	Operations	Standard Operating Procedure	0
547	CO-OPS-SOP-107	Manufacture of NG2/IC Detection Reagent	7	Operations	Standard Operating Procedure	0
548	CO-LAB-SOP-108	Laboratory Cleaning	21	Laboratory	Standard Operating Procedure	0
549	CO-CA-T-147	Clinical Trial Agreement	2	Clinical Affairs	Templates	0
550	CO-CA-FRM-044	Non-binx-initiated study proposal	1	Clinical Affairs	Forms	0
551	CO-LAB-SOP-129	Use of the Priorclave Autoclave	8	Laboratory	Standard Operating Procedure	0
552	CO-LAB-SOP-130	Heated Detection Rig Work Instructions	2	Laboratory	Standard Operating Procedure	0
553	CO-LAB-SOP-131	Pipette Use and Calibration SOP	12	Laboratory	Standard Operating Procedure	0
554	CO-OPS-SOP-132	Manufacture of Elution Buffer Revision 2	4	Operations	Standard Operating Procedure	0
555	CO-OPS-SOP-133	Manufacture of Brij 58 Solution	8	Operations	Standard Operating Procedure	0
556	CO-OPS-SOP-134	Manufacture of Trehalose in PCR Buffer	7	Operations	Standard Operating Procedure	0
557	CO-LAB-SOP-135	Guidance for Use and Completion of MFG Documents	3	Laboratory	Standard Operating Procedure	0
558	CO-LAB-REG-008	Manufacturing Lot Number Register	5	Laboratory	Registers	0
559	CO-LAB-SOP-136	Solution Preparation SOP	6	Laboratory	Standard Operating Procedure	0
560	CO-LAB-SOP-137	Variable Temperature Apparatus Monitoring	7	Laboratory	Standard Operating Procedure	0
561	CO-LAB-SOP-138	Use of Temperature and Humidity Loggers	4	Laboratory	Standard Operating Procedure	0
562	CO-QA-SOP-139	Change Management Procedure for Product/Project Documents	15	Quality Assurance	Standard Operating Procedure	0
563	CO-QA-POL-006	Policy for Document Control and Change Management	5	Quality Assurance	Policy	0
566	CO-OPS-SOP-142	CTNG T7 Diluent	4	Operations	Standard Operating Procedure	0
569	CO-LAB-T-148	Template for Laboratory Code of Practice	1	Laboratory	Templates	0
570	CO-LAB-SOP-145	Handling Biological Materials	5	Laboratory	Standard Operating Procedure	0
572	CO-QA-SOP-147	Managing an External Regulatory Visit from the FDA	4	Quality Assurance	Standard Operating Procedure	0
573	CO-HR-POL-007	Training Policy	3	Human Resources	Policy	0
574	CO-OPS-POL-008	Policy for Purchasing and Management of Suppliers	5	Operations	Policy	0
575	CO-CA-POL-009	Verification and Validation Policy	4	Clinical Affairs	Policy	0
576	CO-QA-POL-010	Policy for Control of Infrastructure Environment and Equipment	5	Quality Assurance	Policy	0
577	CO-OPS-POL-011	WEEE Policy	2	Operations	Policy	0
578	CO-CS-POL-012	Policy for Customer Feedback	5	Customer Support	Policy	0
579	CO-QA-POL-013	Policy for Complaints and Vigilance	2	Quality Assurance	Policy	0
580	CO-LAB-SOP-148	Reagent Aliquotting	11	Laboratory	Standard Operating Procedure	0
581	CO-LAB-SOP-149	Introducing New Laboratory Equipment	5	Laboratory	Standard Operating Procedure	0
582	CO-LAB-SOP-150	Standard Use of Freezers	9	Laboratory	Standard Operating Procedure	0
583	CO-LAB-SOP-151	Management and Control of Critical and Controlled Equipment	10	Laboratory	Standard Operating Procedure	0
584	CO-LAB-SOP-152	Instrument Failure Reporting SOP	2	Laboratory	Standard Operating Procedure	0
585	CO-LAB-SOP-153	Use of UV Cabinets	7	Laboratory	Standard Operating Procedure	0
586	CO-QC-SOP-154	QC Laboratory Cleaning Procedure	5	Quality Control	Standard Operating Procedure	0
587	CO-QC-QCP-039	T7 Raw Material Test	12	Quality Control	Quality Control Protocol	0
588	CO-OPS-PTL-010	Reader Installation Qualification Protocol	14	Operations	Protocol	0
590	CO-LAB-SOP-155	Experimental Write Up	8	Laboratory	Standard Operating Procedure	0
591	CO-LAB-SOP-156	Control of Controlled Laboratory Notes	9	Laboratory	Standard Operating Procedure	0
593	CO-LAB-SOP-158	Use of the NanoDrop ND2000 Spectrophotometer	5	Laboratory	Standard Operating Procedure	0
594	CO-LAB-SOP-159	Use of Rotor-Gene Q	4	Laboratory	Standard Operating Procedure	0
595	CO-LAB-SOP-160	Use of the Miele Laboratory Glassware Washer G7804	2	Laboratory	Standard Operating Procedure	0
596	CO-LAB-SOP-161	Elix Deionised Water System	2	Laboratory	Standard Operating Procedure	0
598	CO-LAB-SOP-163	Running Cartridges on io Readers	8	Laboratory	Standard Operating Procedure	0
599	CO-LAB-SOP-164	Bambi compressor: Use and Maintenance	3	Laboratory	Standard Operating Procedure	0
600	CO-OPS-SOP-165	Windows Software Update	1	Operations	Standard Operating Procedure	0
601	CO-OPS-SOP-166	Pneumatics Test Rig Set up and Calibration	2	Operations	Standard Operating Procedure	0
602	CO-LAB-SOP-167	Attaching Electrode and Blister Adhesive and Blister Pack and Cover  M600	5	Laboratory	Standard Operating Procedure	0
603	CO-LAB-SOP-168	Jenway 3510 model pH Meter	4	Laboratory	Standard Operating Procedure	0
604	CO-LAB-SOP-169	Use of Fermant Pouch Sealer	3	Laboratory	Standard Operating Procedure	0
605	CO-LAB-SOP-170	Rapid PCR Rig Work Instructions	3	Laboratory	Standard Operating Procedure	0
606	CO-QC-SOP-171	Quality Control Rounding Procedure	3	Quality Control	Standard Operating Procedure	0
607	CO-OPS-SOP-172	Tool Changes of the Rhychiger Heat Sealer	3	Operations	Standard Operating Procedure	0
608	CO-QC-SOP-173	Laboratory Investigation  LI  Procedure for Invalid Assays and Out of Specification  OOS  Results	3	Quality Control	Standard Operating Procedure	0
609	CO-OPS-SOP-174	Engineering Rework Procedure	2	Operations	Standard Operating Procedure	0
610	CO-LAB-SOP-175	Out of Hours Power Loss and Temperature Monitoring	3	Laboratory	Standard Operating Procedure	0
611	CO-LAB-SOP-176	Guidance for the use and completion of IQC documents	2	Laboratory	Standard Operating Procedure	0
612	CO-LAB-SOP-177	Operating instruction for the QuantStudio 3D digital PCR system	1	Laboratory	Standard Operating Procedure	0
613	CO-LAB-SOP-178	Operating Instructions for Signal Analyser	1	Laboratory	Standard Operating Procedure	0
614	CO-LAB-SOP-179	Cleaning Procedure for Microbiology Lab	3	Laboratory	Standard Operating Procedure	0
615	CO-LAB-SOP-180	Reconstitution of Lyophilised Materials	3	Laboratory	Standard Operating Procedure	0
616	CO-LAB-SOP-181	Use of the Thermomixer HC block	1	Laboratory	Standard Operating Procedure	0
617	CO-LAB-SOP-182	Limited Laboratory Access Procedure	2	Laboratory	Standard Operating Procedure	0
618	CO-LAB-SOP-183	Use of the Microcentrifuge 24	1	Laboratory	Standard Operating Procedure	0
619	CO-LAB-SOP-184	Pilot Line Blister Filling and Sealing Standard Operating Procedure	2	Laboratory	Standard Operating Procedure	0
620	CO-QC-SOP-185	Use of the SB3 Rotator	2	Quality Control	Standard Operating Procedure	0
621	CO-OPS-SOP-186	Use of the VPUMP Vacuum pump	2	Operations	Standard Operating Procedure	0
622	CO-OPS-SOP-187	Force Test Rig Set up and Calibration	3	Operations	Standard Operating Procedure	0
623	CO-OPS-SOP-188	Process Validation	4	Operations	Standard Operating Procedure	0
624	CO-QC-FRM-049	QC Monthly Laboratory Checklist	0	Quality Control	Forms	0
625	CO-QC-COP-001	Quality Control Laboratory Code of Practice	3	Quality Control	Code of Practice	0
626	CO-OPS-PTL-011	Rapid PCR Rig OQ Procedure	2	Operations	Protocol	0
627	CO-LAB-FRM-050	Incoming Quality Control and Specification for ‘CMO Manufactured io® Cartridges’	8	Laboratory	Forms	0
628	CO-OPS-SOP-189	CT/NG ATCC Input Generation	14	Operations	Standard Operating Procedure	0
631	CO-LAB-FRM-041	Incoming Quality Control and Specification for ‘NG1 Plasmid in TE buffer’ Materials binx Part Number: 0346	0	Laboratory	Forms	0
632	CO-LAB-FRM-042	Incoming Quality Control and Specification for ‘NG2 Plasmid in TE buffer’ Materials binx Part Number: 0347	0	Laboratory	Forms	0
633	CO-LAB-FRM-043	Incoming Quality Control and Specification for ‘CT Plasmid in TE buffer’ Materials binx Part Number: 0348	0	Laboratory	Forms	0
636	CO-OPS-SOP-190	Preparation of IC DNA in TE buffer 10ng/μl master stock aliquots	3	Operations	Standard Operating Procedure	0
638	CO-OPS-SOP-192	Verification Testing Process SOP	3	Operations	Standard Operating Procedure	0
639	CO-LAB-FRM-051	WATER FOR MOLECULAR BIOLOGY Part Number 0005	5	Laboratory	Forms	0
641	CO-LAB-FRM-052	SODIUM CHLORIDE Part Number 0008	4	Laboratory	Forms	0
642	CO-LAB-FRM-053	‘TRIS  TRIZMA®  HYDROCHLORIDE’ Part Number: 0011	5	Laboratory	Forms	0
643	CO-LAB-FRM-054	Part No. 0014 ‘Potassium Chloride’	5	Laboratory	Forms	0
644	CO-LAB-FRM-055	‘Safe View DNA Stain’  Part Number 0079	5	Laboratory	Forms	0
645	CO-LAB-FRM-056	Part No. 0086 Buffer solution pH 7	5	Laboratory	Forms	0
646	CO-LAB-FRM-057	Part No. 0085 Buffer solution pH 4	4	Laboratory	Forms	0
647	CO-LAB-FRM-058	Part No. 0087 Buffer solution pH 10	5	Laboratory	Forms	0
648	CO-LAB-FRM-059	‘50mM dUTP MIX’ Part no. 0088	5	Laboratory	Forms	0
649	CO-LAB-FRM-060	Part no. 0089 70% ethanol	4	Laboratory	Forms	0
650	CO-LAB-FRM-061	Part No. 0093 CT ME17 Synthetic target HPLC GRADE	6	Laboratory	Forms	0
651	CO-LAB-FRM-062	‘Guanidine Thiocyanate’ Part Number: 0094	5	Laboratory	Forms	0
652	CO-LAB-FRM-063	‘MES’ Part No. 0095	5	Laboratory	Forms	0
653	CO-LAB-FRM-064	Part No. 0104 – Tryptone Soya Broth	2	Laboratory	Forms	0
654	CO-QC-FRM-065	Quality Control Out of Specification Result Investigation Record Form	1	Quality Control	Forms	0
655	CO-QC-SOP-012	Quality Control Out of Specification Results Procedure	1	Quality Control	Standard Operating Procedure	0
656	CO-LAB-FRM-066	C. trachomatis serotype F Elementary Bodies Part No. 0106	5	Laboratory	Forms	0
657	CO-LAB-FRM-067	Sarcosine’ Part no: 0108	5	Laboratory	Forms	0
658	CO-LAB-FRM-068	1M Magnesium Chloride solution molecular biology grade Part No. 0115	4	Laboratory	Forms	0
659	CO-LAB-FRM-069	Part No. 0118 IC Synthetic target HPLC GRADE	6	Laboratory	Forms	0
660	CO-LAB-FRM-070	Part No. 0125 Potassium Phospate Monobasic	5	Laboratory	Forms	0
661	CO-LAB-FRM-071	Potassium Phosphate Dibasic’ Part No.0147	4	Laboratory	Forms	0
662	CO-LAB-FRM-072	‘Part No. 0148 DL-Dithiothreitol’	4	Laboratory	Forms	0
663	CO-LAB-FRM-073	1L Nalgene Disposable Filter Unit’ Part No. 0167	4	Laboratory	Forms	0
664	CO-LAB-FRM-074	CT synthetic target containing Uracil Part no: 0168	6	Laboratory	Forms	0
665	CO-LAB-FRM-075	‘γ Aminobutyric acid’ Part Number: 0178	3	Laboratory	Forms	0
666	CO-LAB-FRM-076	Part Number 0188 Vircell CT DNA Control	2	Laboratory	Forms	0
667	CO-LAB-FRM-077	‘Albumin from bovine serum – New Zealand Source’ Part Number: 0219	5	Laboratory	Forms	0
668	CO-LAB-FRM-078	Part no. 0222 CO2 Gen sachets	3	Laboratory	Forms	0
669	CO-LAB-FRM-079	‘Uracil DNA Glycosylase [50 thousand U/mL]’ Part Number 0240	4	Laboratory	Forms	0
670	CO-LAB-FRM-080	‘DNase Alert Buffer’ Part Number 0241	3	Laboratory	Forms	0
671	CO-LAB-FRM-081	‘DNase Alert Substrate’ Part Number 0242	3	Laboratory	Forms	0
672	CO-LAB-FRM-082	Part No. 0248 Pectobacterium atrosepticum chromosomal DNA in TE buffer	4	Laboratory	Forms	0
674	CO-LAB-FRM-084	NG1 Synthetic Target Part No 0258	3	Laboratory	Forms	0
675	CO-LAB-FRM-085	NG2 Synthetic Target Part no 0259	3	Laboratory	Forms	0
676	CO-LAB-FRM-086	‘0260 CT Forward Primer from SGS DNA’	6	Laboratory	Forms	0
677	CO-LAB-FRM-087	Part No 0261 ‘CT Reverse Mod Primer’ from SGS DNA	6	Laboratory	Forms	0
678	CO-LAB-FRM-088	Incoming Quality Control and Specification for ‘IC Forward Primer’ from SGS DNA: Part number 0262 and 0419	6	Laboratory	Forms	0
679	CO-LAB-FRM-089	Part No 0263 ‘IC Reverse Primer’ from SGS DNA	5	Laboratory	Forms	0
680	CO-LAB-FRM-090	Part No 0264 ‘NG Target 1 Forward Primer’ from SGS DNA	5	Laboratory	Forms	0
681	CO-LAB-FRM-091	Part No 0265 ‘NG Target 1 RA Reverse Primer’ from SGS DNA	5	Laboratory	Forms	0
682	CO-LAB-FRM-092	Part No 0266 ‘NG Target 2 Forward Primer’ from SGS DNA	5	Laboratory	Forms	0
683	CO-LAB-FRM-093	Part No 0267 ‘NG Target 2 Reverse Primer’ from SGS DNA	5	Laboratory	Forms	0
684	CO-LAB-FRM-094	NG1 Taqman Probe HPLC GRADE Part no 0268	3	Laboratory	Forms	0
685	CO-LAB-FRM-095	NG2 Taqman probe HPLC GRADE Part No 0269	3	Laboratory	Forms	0
686	CO-LAB-FRM-096	‘25U/µL Taq-B DNA Polymerase  Low Glycerol ’ Part Number 0270	3	Laboratory	Forms	0
687	CO-LAB-FRM-097	‘0271 gyrA_F_Fwd primer’	3	Laboratory	Forms	0
689	CO-LAB-FRM-099	‘Neisseria gonorrhoeae DNA’ Part Number 0273	2	Laboratory	Forms	0
690	CO-LAB-FRM-100	‘CT/NG: IC DNA Reagent	8	Laboratory	Forms	0
691	CO-LAB-FRM-101	‘CT/NG: NG1/NG2/IC Primer Passivation Reagent	9	Laboratory	Forms	0
692	CO-LAB-FRM-102	‘CT/NG: TaqUNG Reagent	8	Laboratory	Forms	0
693	CO-LAB-FRM-103	CT/NG: NG1/IC Detection Reagent	8	Laboratory	Forms	0
694	CO-LAB-FRM-104	‘CT/NG: NG2/IC Detection Reagent	8	Laboratory	Forms	0
695	CO-LAB-FRM-105	CT/NG: CT/IC Primer Passivation Reagent	9	Laboratory	Forms	0
696	CO-LAB-FRM-106	‘CT/NG: CT/IC Detection Reagent	8	Laboratory	Forms	0
697	CO-LAB-FRM-107	‘IC di275 Probe from SGS’ Part No. 0288	4	Laboratory	Forms	0
698	CO-LAB-FRM-108	‘CT di452 Probe from SGS’ Part No. 0289	4	Laboratory	Forms	0
699	CO-LAB-FRM-109	Internal Control di275 Probe from ATDBio Part Number 0294	2	Laboratory	Forms	0
700	CO-LAB-FRM-110	Part No. 0295 ‘Sterile Syringe Filter with 0.45µm Cellulose Acetate Membrane’	2	Laboratory	Forms	0
701	CO-LAB-FRM-111	Part No. 0296 Chlamydia trachomatis serovar F ATCC VR-346	3	Laboratory	Forms	0
702	CO-LAB-FRM-112	Part Number 0298 Vircell NG DNA Control	2	Laboratory	Forms	0
703	CO-LAB-FRM-113	Part Number 0299 Vircell TV DNA control	2	Laboratory	Forms	0
704	CO-LAB-FRM-114	Part Number 0300 Vircell MG DNA Control	2	Laboratory	Forms	0
709	CO-LAB-FRM-119	‘Trichomonas vaginalis Cultured Stock’ P/N:0310	2	Laboratory	Forms	0
710	CO-LAB-FRM-120	Metronidazole resistant Trichomonas Vaginalis Cultured Stocks Part no. 0312	1	Laboratory	Forms	0
711	CO-LAB-FRM-121	Part No. 0316 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.45 µm surfactant-free Cellulose Acetate Membrane’	1	Laboratory	Forms	0
712	CO-LAB-FRM-122	Part No. 0317 ‘Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane’	1	Laboratory	Forms	0
713	CO-LAB-FRM-123	Part No. 0318  NATtrol Chlamydia trachomatis Positive Control	1	Laboratory	Forms	0
714	CO-LAB-FRM-124	Part No. 0319 NATrol Neisseria gonorrhoeae Positive Control	2	Laboratory	Forms	0
715	CO-LAB-FRM-125	10x TBE electrophoresis buffer Part Number 0326	1	Laboratory	Forms	0
716	CO-LAB-FRM-126	50bp DNA Ladder binx Part Number 0329	2	Laboratory	Forms	0
717	CO-LAB-FRM-127	‘TV_Alt_6_Fwd’ Part No. 0330 from SGS DNA	2	Laboratory	Forms	0
718	CO-LAB-FRM-128	‘TV_Alt_6_Rev’ Part No 0331 from SGS DNA	2	Laboratory	Forms	0
719	CO-LAB-FRM-129	‘TV_Alt_A di452 Probe from SGS’ Part Number 0332	2	Laboratory	Forms	0
726	CO-LAB-FRM-136	Part No. 0339 ‘NG2_di275_probe’ from SGS DNA	1	Laboratory	Forms	0
727	CO-LAB-FRM-137	‘HS anti-Taq mAb  5.7 mg/mL ’ Part no: 0340	2	Laboratory	Forms	0
728	CO-LAB-FRM-138	‘Potassium Chloride Solution’ Part Number: 0341	1	Laboratory	Forms	0
729	CO-LAB-FRM-139	‘Tris  1M  pH8.0’ Part no: 0342	1	Laboratory	Forms	0
730	CO-LAB-FRM-140	Hot Start Taq  PCR Biosystems LTD  P/N:0344	2	Laboratory	Forms	0
731	CO-LAB-FRM-141	Part No. 0345 CampyGen  sachets	1	Laboratory	Forms	0
758	CO-OPS-SOP-196	SOP to record the details of the manufacture of 75x PCR buffer	3	Operations	Standard Operating Procedure	0
759	CO-OPS-PTL-013	Validation -80 Freezer QC Lab	1	Operations	Protocol	0
760	CO-OPS-PTL-014	Validation -80 Chest Freezer Micro lab	2	Operations	Protocol	0
761	CO-OPS-PTL-015	Validation 2-8 Refrigerator QC Lab	1	Operations	Protocol	0
762	CO-OPS-SOP-197	Manufacture of Taq/UNG Reagent	9	Operations	Standard Operating Procedure	0
763	CO-OPS-SOP-198	Manufacture of microorganism glycerol stocks	6	Operations	Standard Operating Procedure	0
764	CO-LAB-SOP-199	Manufacture of CT/NG Negative Control Samples	7	Laboratory	Standard Operating Procedure	0
765	CO-OPS-SOP-200	Manufacture of Chlamydia trachomatis and Neisseria gonorrhoeae positive control samples	8	Operations	Standard Operating Procedure	0
767	CO-OPS-SOP-202	Composite CT/NG Samples for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	2	Operations	Standard Operating Procedure	0
768	CO-OPS-SOP-203	Manufacture of Wash Buffer II	3	Operations	Standard Operating Procedure	0
770	CO-OPS-SOP-205	Manufacture of 200mM Tris pH8.0	4	Operations	Standard Operating Procedure	0
771	CO-OPS-SOP-206	Manufacture of 1.5 M Trehalose	2	Operations	Standard Operating Procedure	0
773	CO-OPS-SOP-208	Contrived male urine specimens for Within and Inter-Laboratory Precision/Reproducibility  for FDA 510 k	1	Operations	Standard Operating Procedure	0
774	CO-OPS-SOP-209	Preparation of bulk male urine plus 10% eNAT  v/v	1	Operations	Standard Operating Procedure	0
793	CO-OPS-SOP-228	Manufacture of Ab-HS Taq/UNG Reagent	2	Operations	Standard Operating Procedure	0
794	CO-OPS-SOP-229	Manufacture of CT/TV/IC Primer Buffer Reagent	2	Operations	Standard Operating Procedure	0
796	CO-QC-PTL-016	Validation Protocol -20 freezer/QC lab asset 0330	1	Quality Control	Protocol	0
797	CO-OPS-PTL-017	Validation Protocol: Thermal cycler IQ/OQ/PQ	4	Operations	Protocol	0
798	CO-OPS-PTL-018	Validation Protocol – UV/Vis Nanodrop Spectrophotometer	2	Operations	Protocol	0
799	CO-OPS-PTL-019	Validation of Autolab Type III	2	Operations	Protocol	0
800	CO-OPS-PTL-020	Validation Protocol Temperature controlled storage/incubation	3	Operations	Protocol	0
801	CO-OPS-PTL-021	Validation Protocol for Rotorgene	4	Operations	Protocol	0
802	CO-OPS-PTL-022	Validation Protocol - V&V Laboratory Facilities	1	Operations	Protocol	0
803	CO-OPS-PTL-023	io Reader - Digital Pressure Regulator Calibration Protocol	2	Operations	Protocol	0
804	CO-OPS-PTL-024	io Reader - Pneumatics End Test Protocol	1	Operations	Protocol	0
805	CO-OPS-PTL-025	io Reader – Force End Test Protocol	2	Operations	Protocol	0
806	CO-OPS-PTL-026	io® Reader – Thermal End Test Protocol	2	Operations	Protocol	0
807	CO-OPS-PTL-027	Rapid PCR Rig IQ Protocol	2	Operations	Protocol	0
808	CO-OPS-PTL-028	Rapid PCR Rig PQ Procedure	4	Operations	Protocol	0
809	CO-OPS-PTL-029	Heated Detection Rig IQ Procedure	2	Operations	Protocol	0
810	CO-OPS-PTL-030	Validation Protocol – Heated Detection Rig PQ	7	Operations	Protocol	0
811	CO-OPS-PTL-031	EOL thermal test 21011-MET-012 Thermal-PCR Cycle Template for TTDL-No.2.xlsx v4.0	3	Operations	Protocol	0
815	CO-OPS-PTL-036	Validation Protocol: 21011-MET012 Thermal - PCR Cycle Results Template Master	2	Operations	Protocol	0
816	CO-OPS-PTL-037	Blister Cropping Press IQ and OQ Validation Protocol	1	Operations	Protocol	0
817	CO-OPS-PTL-038	Blister Filling Rig and Cropping Press PQ Validation Protocol	3	Operations	Protocol	0
818	CO-OPS-PTL-039	OQ Validation Protocol Blister Filling Rig	1	Operations	Protocol	0
819	CO-OPS-PTL-040	IQ Validation Protocol Blister Filling Rig	1	Operations	Protocol	0
821	CO-OPS-PTL-043	PAN-D-267 Signal Analyzer Validation of functions for outputting V&V tables	1	Operations	Protocol	0
823	CO-SUP-SOP-231	New Items	2	Supply Chain	Standard Operating Procedure	0
828	CO-LAB-REG-011	Asset Register	3	Laboratory	Registers	0
829	CO-LAB-REG-012	Part No Register	1	Laboratory	Registers	0
830	CO-LAB-REG-013	Pipette Register	3	Laboratory	Registers	0
831	CO-LAB-REG-014	GRN Register	22	Laboratory	Registers	0
832	CO-LAB-REG-015	Stock Item Register	10	Laboratory	Registers	0
834	CO-LAB-REG-016	Consumables Register	2	Laboratory	Registers	0
835	CO-LAB-REG-017	Equipment Service and Calibration Register	6	Laboratory	Registers	0
836	CO-QC-FRM-046	Micro Monthly Laboratory Checklist-Rev_0	0	Quality Control	Forms	0
837	CO-LAB-REG-018	Enviromental Monitoring Results Register	2	Laboratory	Registers	0
838	CO-LAB-REG-019	Laboratory Investigation Register	1	Laboratory	Registers	0
839	CO-LAB-REG-020	Batch Retention Register	1	Laboratory	Registers	0
840	CO-LAB-REG-021	Laboratory Responsibilities by Area	9	Laboratory	Registers	0
841	CO-QA-REG-022	Vigilance Register	2	Quality Assurance	Registers	0
843	CO-QA-REG-023	Master Archive Register	2	Quality Assurance	Registers	0
844	CO-QA-REG-024	Archived Document Retrieval Log	1	Quality Assurance	Registers	0
845	CO-QA-REG-025	Supplier Risk Assessment Monitoring List	4	Quality Assurance	Registers	0
846	CO-LAB-PTL-045	IQ Protocol for Binder incubator and humidity chamber	0	Laboratory	Protocol	0
847	CO-LAB-PTL-046	OQ protocol for binder incubator and humidity chamber	0	Laboratory	Protocol	0
848	CO-LAB-PTL-047	PQ Protocol for binder incubator and humidity chamber	0	Laboratory	Protocol	0
849	CO-OPS-T-152	Manufacturing Procedure  MFG  Template	1	Operations	Templates	0
850	CO-LAB-URS-001	Binder incubator and humidity chamber User Requirement Specification	0	Laboratory	User Requirements Specification	0
851	CO-OPS-REG-026	Instrument Register	6	Operations	Registers	0
852	CO-QC-COP-002	CL2 Microbiology Laboratory Code of Practice	2	Quality Control	Code of Practice	0
853	CO-QA-T-153	Job Aid Template	2	Quality Assurance	Templates	0
854	CO-QA-JA-002	Legacy Document Number Crosswalk	6	Quality Assurance	Job Aid	0
855	CO-QA-SOP-237	QT9 - Periodic Review and Making Documents Obsolete	0	Quality Assurance	Standard Operating Procedure	0
857	CO-LAB-SOP-239	Microorganism Ampoules Handling SOP	0	Laboratory	Standard Operating Procedure	0
859	CO-QA-POL-014	Policy for the Control of Non-Conforming Product and Corrective/Preventive Action	4	Quality Assurance	Policy	0
860	CO-LAB-FRM-165	New Microorganism Introduction Checklist Form	0	Laboratory	Forms	0
866	CO-IT-REG-028	Controlled Laboratory Equipment Software List	3	Information Technology	Registers	0
867	CO-OPS-REG-029	binx health ltd Master Assay Code Register	7	Operations	Registers	0
868	CO-HR-REG-030	Training Register	6	Human Resources	Registers	0
869	CO-CA-REG-031	Donor Number Consent Register	1	Clinical Affairs	Registers	0
870	CO-LAB-SOP-241	Ordering of New Reagents and Chemicals	0	Laboratory	Standard Operating Procedure	0
882	CO-LAB-LBL-003	Approved material label	2	Laboratory	Label	0
883	CO-LAB-LBL-004	For Indication Only Label	1	Laboratory	Label	0
884	CO-LAB-LBL-005	GRN for R&D and Samples Label	3	Laboratory	Label	0
885	CO-LAB-LBL-006	Part No GRN Label	3	Laboratory	Label	0
886	CO-LAB-LBL-007	Expiry Dates Label	3	Laboratory	Label	0
887	CO-LAB-LBL-008	Pipette Calibration Label	1	Laboratory	Label	0
888	CO-LAB-LBL-009	Quarantine - Failed calibration Label	2	Laboratory	Label	0
889	CO-LAB-LBL-010	Failed Testing - Not in use Label	2	Laboratory	Label	0
890	CO-LAB-LBL-011	Solutions labels	3	Laboratory	Label	0
891	CO-SD-FRM-171	Code Review	0	Software Development	Forms	0
892	CO-LAB-LBL-012	General Calibration Label	2	Laboratory	Label	0
893	CO-LAB-LBL-013	In process MFG material label	3	Laboratory	Label	0
894	CO-LAB-LBL-014	Quarantined material label	3	Laboratory	Label	0
895	CO-LAB-LBL-015	Consumables Label	2	Laboratory	Label	0
896	CO-LAB-LBL-016	MBG water label	3	Laboratory	Label	0
897	CO-LAB-LBL-017	Equipment Under Qualification Label	2	Laboratory	Label	0
899	CO-LAB-LBL-019	Asset Calibration Label	2	Laboratory	Label	0
900	CO-LAB-LBL-020	SAP Stock Item Label	2	Laboratory	Label	0
901	CO-LAB-LBL-021	Cartridge Materials Label	1	Laboratory	Label	0
902	CO-LAB-LBL-022	Quarantine Stock Item Label	1	Laboratory	Label	0
903	CO-LAB-LBL-023	Pilot Line Materials Label	1	Laboratory	Label	0
904	CO-LAB-LBL-024	Elution Reagent Label	4	Laboratory	Label	0
905	CO-LAB-LBL-025	Equipment Not Maintained Do Not Use Label	2	Laboratory	Label	0
906	CO-LAB-LBL-026	CIR Label	2	Laboratory	Label	0
907	CO-OPS-LBL-027	Interim CTNG CLIA Waiver Outer Shipper Label	1	Operations	Label	0
908	CO-OPS-LBL-028	UN3316 cartridge label - use Avery J8173 labels to print	1	Operations	Label	0
909	CO-QA-SOP-244	QT9 Administration	2	Quality Assurance	Standard Operating Procedure	0
912	CO-OPS-PTL-048	io Release Record  following repair or refurbishment	3	Operations	Protocol	0
914	CO-QA-POL-015	Policy for the Use of Electronic Signatures within binx health	0	Quality Assurance	Policy	0
915	CO-QC-T-155	CTNG QC Cartridge Analysis Module	0	Quality Control	Templates	0
916	CO-QC-JA-004	Use of CO-QC-T-155: CTNG QC Cartridge Analysis Module	0	Quality Control	Job Aid	0
917	CO-OPS-URS-002	URS for Temperature Monitoring System	1	Operations	User Requirements Specification	0
920	CO-CS-SOP-248	Procedure For Customer Service	2	Customer Support	Standard Operating Procedure	0
925	CO-OPS-PTL-049	vT flow and leak tester- FAT protocol	0	Operations	Protocol	0
926	CO-OPS-PTL-050	Factory Acceptance Test  FAT   TQC in-line leak test equipment	0	Operations	Protocol	0
927	CO-OPS-PTL-051	Factory Acceptance Test  FAT  Sprint B+ In-line Leak Tester	0	Operations	Protocol	0
928	CO-OPS-URS-006	User Requirement Specification for the vT off-line flow and leak test equipment	0	Operations	User Requirements Specification	0
929	CO-OPS-URS-007	TQC leak tester- User Requirement Specification	0	Operations	User Requirements Specification	0
930	CO-OPS-URS-008	Sprint B+ leak tester- User Requirement Specification	0	Operations	User Requirements Specification	0
932	CO-QA-JA-006	Use of the Management Review Module in QT9	1	Quality Assurance	Job Aid	0
933	CO-OPS-URS-009	User Requirement Specification for pH/mV/°C Meter	1	Operations	User Requirements Specification	0
934	CO-OPS-URS-010	User Requirement Specification for temperature-controlled equipment	0	Operations	User Requirements Specification	0
935	CO-OPS-URS-011	User Requirement Specification for back up power supply	0	Operations	User Requirements Specification	0
936	CO-OPS-URS-012	User Requirement Specification for a Production Enclosure	0	Operations	User Requirements Specification	0
937	CO-OPS-URS-013	User requirement specification for class 2 microbiological safety cabinet	0	Operations	User Requirements Specification	0
938	CO-CS-SOP-249	io Insepction using Data Collection Cartridge	0	Customer Support	Standard Operating Procedure	0
939	CO-CS-FRM-175	io Inspection using Data Collection Cartridge Form	0	Customer Support	Forms	0
941	CO-OPS-URS-014	User requirement specification for a filter integrity tester	0	Operations	User Requirements Specification	0
942	CO-OPS-URS-015	User requirement specification for a cooled incubator	0	Operations	User Requirements Specification	0
946	CO-SUP-URS-017	User Requirement Specification for ByD for binx Reagent Manufacturing Facility	0	Supply Chain	User Requirements Specification	0
947	CO-REG-T-157	Regulatory Change Assessment	0	Regulatory	Templates	0
948	CO-OPS-URS-018	Reagent Handling Processor for Scienion Dispense Equipment	0	Operations	User Requirements Specification	0
949	CO-QA-T-158	User Requirement Specification  URS  template	0	Quality Assurance	Templates	0
951	CO-SUP-FRM-177	binx health Vendor Information Form	0	Supply Chain	Forms	0
952	CO-PRD1-SOP-252	Use of Benchmark Roto-Therm Plus Hybridisation oven	1	Production line 1 - Oak House	Standard Operating Procedure	0
956	CO-OPS-URS-019	User Requirement Specification for a Balance	1	Operations	User Requirements Specification	0
957	CO-LAB-T-159	Autoclave Biological Indicator Check Form	0	Laboratory	Templates	0
959	CO-PRD1-SOP-254	Use & Cleaning of the Monmouth Scientific Model Guardian 1800 Production Enclosure in Oak House	1	Production line 1 - Oak House	Standard Operating Procedure	0
961	CO-PRD1-SOP-255	Mini Fuge Plus centrifuge SOP	0	Production line 1 - Oak House	Standard Operating Procedure	0
963	CO-PRD1-SOP-256	Velp Scientific WIZARD IR Infrared Vortex Mixer SOP	0	Production line 1 - Oak House	Standard Operating Procedure	0
964	CO-PRD1-SOP-257	Standard Use of Oak House Freezers	1	Production line 1 - Oak House	Standard Operating Procedure	0
965	CO-SUP-FRM-178	GRN Form for incoming goods	1	Supply Chain	Forms	0
966	CO-PRD1-SOP-258	Use of Oak House N2400-3010 Magnetic Stirrer	0	Production line 1 - Oak House	Standard Operating Procedure	0
967	CO-PRD1-SOP-259	Standard Use of Oak House Fridges	1	Production line 1 - Oak House	Standard Operating Procedure	0
968	CO-LAB-FRM-180	Class II MSC Monthly Airflow Check Form	1	Laboratory	Forms	0
969	CO-OPS-URS-020	Process Requirement Specification for CO-OPS-PTL-010	0	Operations	User Requirements Specification	0
970	CO-PRD1-POL-016	Reagent Production Policy	0	Production line 1 - Oak House	Policy	0
971	CO-PRD1-COP-003	Oak House Production Facility Code of Practice	0	Production line 1 - Oak House	Code of Practice	0
972	CO-PRD1-SOP-260	Use of Logmore dataloggers	0	Production line 1 - Oak House	Standard Operating Procedure	0
973	CO-PRD1-T-160	Oak House Production Facility Cleaning Record	1	Production line 1 - Oak House	Templates	0
974	CO-PRD1-SOP-261	Cleaning Procedure for Oak House Production Facility	3	Production line 1 - Oak House	Standard Operating Procedure	0
975	CO-PRD1-FRM-181	Oak House Monthly Production Facility Checklist	1	Production line 1 - Oak House	Forms	0
977	CO-PRD1-SOP-263	Entry and Exit to the Oak House Production Facility and Production Suite	0	Production line 1 - Oak House	Standard Operating Procedure	0
978	CO-PRD1-JA-008	Air conditioning	1	Production line 1 - Oak House	Job Aid	0
980	CO-PRD1-SOP-264	Eupry temperature monitoring system	1	Production line 1 - Oak House	Standard Operating Procedure	0
981	CO-PRD1-SOP-265	Oak House Emergency Procedures	0	Production line 1 - Oak House	Standard Operating Procedure	0
983	CO-PRD1-SOP-268	Transfer of reagent QC samples	2	Production line 1 - Oak House	Standard Operating Procedure	0
984	CO-PRD1-LBL-029	Storage temperature labels	0	Production line 1 - Oak House	Label	0
985	CO-PRD1-FRM-182	Pipette Internal Verification Form	2	Production line 1 - Oak House	Forms	0
986	CO-PRD1-SOP-269	Oak House Pipette Use and Calibration SOP	2	Production line 1 - Oak House	Standard Operating Procedure	0
987	CO-PRD1-FRM-183	Certificate of conformance – CT IC detection reagent	1	Production line 1 - Oak House	Forms	0
988	CO-PRD1-FRM-184	Certificate of conformance - CT IC primer passivation reagent	1	Production line 1 - Oak House	Forms	0
989	CO-PRD1-FRM-185	Certificate of Conformance - IC DNA reagent	1	Production line 1 - Oak House	Forms	0
990	CO-PRD1-FRM-186	Certificate of Conformance - NG1 IC detection reagent	1	Production line 1 - Oak House	Forms	0
991	CO-PRD1-FRM-187	Certificate of Conformance - NG2 IC detection reagent	1	Production line 1 - Oak House	Forms	0
992	CO-PRD1-FRM-188	Certificate of Conformance - NG1 NG2 IC primer passivation reagent	1	Production line 1 - Oak House	Forms	0
993	CO-PRD1-FRM-189	Certificate of Conformance - Taq UNG	1	Production line 1 - Oak House	Forms	0
995	CO-PRD1-FRM-190	Shipment note	0	Production line 1 - Oak House	Forms	0
996	CO-PRD1-SOP-271	Use of the Pacplus Impulse Heat Sealer	0	Production line 1 - Oak House	Standard Operating Procedure	0
999	CO-PRD1-FRM-191	Reagent Shipping Worksheet	2	Production line 1 - Oak House	Forms	0
1000	CO-DPT-IFU-001	At-Home Blood Spot Collection Kit IFU  English Print Version	4	Digital Product Technology	Instructions For Use	0
1001	CO-DPT-IFU-002	At-Home Blood Spot Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	Instructions For Use	0
1002	CO-DPT-IFU-003	At-Home Blood Spot Collection Kit IFU  English Digital Version	4	Digital Product Technology	Instructions For Use	0
1003	CO-DPT-IFU-004	At-Home Blood Spot Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	Instructions For Use	0
1004	CO-DPT-IFU-005	At-Home Vaginal Swab Collection Kit IFU  English Print Version	4	Digital Product Technology	Instructions For Use	0
1005	CO-DPT-IFU-006	At-Home Vaginal Swab Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	Instructions For Use	0
1006	CO-DPT-IFU-007	At-Home Vaginal Swab Collection Kit IFU  English Digital Version	4	Digital Product Technology	Instructions For Use	0
1007	CO-DPT-IFU-008	At-Home Vaginal Swab Collection Kit IFU  Spanish Digital Print	4	Digital Product Technology	Instructions For Use	0
1008	CO-DPT-IFU-009	At-Home Female Triple Site Collection Kit IFU  English Print Version	5	Digital Product Technology	Instructions For Use	0
1009	CO-DPT-IFU-010	At-Home Female Triple Site Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	Instructions For Use	0
1010	CO-DPT-IFU-011	At-Home Female Triple Site Collection Kit IFU  English Digital Version	5	Digital Product Technology	Instructions For Use	0
1011	CO-DPT-IFU-012	At-Home Female Triple Site Collection Kit IFU  Spanish Digital Version	5	Digital Product Technology	Instructions For Use	0
1012	CO-DPT-IFU-013	123 At-Home Card  English Version	2	Digital Product Technology	Instructions For Use	0
1013	CO-DPT-IFU-014	At-Home Male Triple Site Collection Kit IFU  English Print Version	4	Digital Product Technology	Instructions For Use	0
1014	CO-DPT-IFU-015	At-Home Male Triple Site Collection Kit IFU  Spanish Print Version	5	Digital Product Technology	Instructions For Use	0
1015	CO-DPT-IFU-016	At-Home Male Triple Site Collection Kit IFU  English Digital Version	4	Digital Product Technology	Instructions For Use	0
1016	CO-DPT-IFU-017	At-Home Male Triple Site Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	Instructions For Use	0
1017	CO-DPT-IFU-018	At-Home Urine Collection Kit IFU  English Print Version	4	Digital Product Technology	Instructions For Use	0
1018	CO-DPT-IFU-019	At-Home Urine Collection Kit IFU  Spanish Print Version	4	Digital Product Technology	Instructions For Use	0
1019	CO-DPT-IFU-020	At-Home Urine Collection Kit IFU  English Digital Version	4	Digital Product Technology	Instructions For Use	0
1020	CO-DPT-IFU-021	At-Home Urine Collection Kit IFU  Spanish Digital Version	4	Digital Product Technology	Instructions For Use	0
1021	CO-DPT-IFU-022	Blood Card Collection Kit IFU  Using ADx Card Fasting  English Print Version	2	Digital Product Technology	Instructions For Use	0
1022	CO-DPT-IFU-023	Blood Card Collection Kit IFU  Using the ADx Card Fasting  English Digital Version	2	Digital Product Technology	Instructions For Use	0
1023	CO-DPT-IFU-024	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting  English Print Version	2	Digital Product Technology	Instructions For Use	0
1024	CO-DPT-IFU-025	Blood Card Collection Kit IFU  Using the ADx Card Non-Fasting   English Digital Version	2	Digital Product Technology	Instructions For Use	0
1025	CO-DPT-IFU-026	It s as Easy as 123 Ft. the ADx Card Collection Method   English Version	2	Digital Product Technology	Instructions For Use	0
1026	CO-DPT-IFU-027	STI Sample Tube/Swab Preparation Card  English Version	2	Digital Product Technology	Instructions For Use	0
1027	CO-DPT-IFU-028	binx Nasal Swab For Individual Setting  English Print Version	10	Digital Product Technology	Instructions For Use	0
1028	CO-DPT-IFU-029	binx Nasal Swab For Group Setting  English Print Version	7	Digital Product Technology	Instructions For Use	0
1029	CO-DPT-IFU-031	binx At-Home Collection Kit Individual_Broad  English Version	4	Digital Product Technology	Instructions For Use	0
1030	CO-DPT-IFU-032	binx At-Home Collection Kit IFU Group_Broad  English Version	4	Digital Product Technology	Instructions For Use	0
1031	CO-DPT-IFU-033	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping  English Version	5	Digital Product Technology	Instructions For Use	0
1032	CO-DPT-IFU-035	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location  English Version	5	Digital Product Technology	Instructions For Use	0
1033	CO-DPT-IFU-036	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Individual Shipping_Broad  English Version	4	Digital Product Technology	Instructions For Use	0
1034	CO-DPT-IFU-037	binx At-Home Nasal Swab COVID-19 Sample Collection Kit IFU - For Return at a Drop-off Location_Broad  English Version	4	Digital Product Technology	Instructions For Use	0
1035	CO-DPT-ART-001	Outer bag label Nasal PCR Bag Bulk Kit	0	Digital Product Technology	Artwork	0
1037	CO-DPT-VID-001	Return STI Kit Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	0
1039	CO-DPT-VID-003	Oral Swab Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	0
1040	CO-DPT-VID-004	Dry Blood Spot Card Video Transcript	0	Digital Product Technology	Instructional Videos	0
1041	CO-DPT-VID-005	Urine Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	0
1042	CO-DPT-VID-006	Vaginal Swab Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	0
1043	CO-DPT-IFU-038	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit IFU  English Version	2	Digital Product Technology	Instructions For Use	0
1044	CO-DPT-IFU-039	binx health  powered by P23  At-home Saliva COVID-19 Test Collection Kit for Group Settings  English Version	2	Digital Product Technology	Instructions For Use	0
1045	CO-LAB-FRM-192	TV Synthetic Target  P/N 0418	0	Laboratory	Forms	0
1046	CO-DPT-VID-007	Anal Swab Sample Collection Video Transcript	0	Digital Product Technology	Instructional Videos	0
1047	CO-DPT-IFU-040	At-Home Blood Spot Collection Kit USPS IFU  English Print Version	2	Digital Product Technology	Instructions For Use	0
1048	CO-DPT-IFU-041	At-Home Blood Spot Collection Kit USPS IFU  Spanish Print Version	0	Digital Product Technology	Instructions For Use	0
1049	CO-DPT-IFU-042	At-Home Blood Spot Collection Kit USPS IFU  English Digital Version	0	Digital Product Technology	Instructions For Use	0
1050	CO-DPT-IFU-043	At-Home Blood Spot Collection Kit USPS IFU  Spanish Digital Version	0	Digital Product Technology	Instructions For Use	0
1052	CO-PRD1-T-163	Certificate of Conformance template	1	Production line 1 - Oak House	Templates	0
1053	CO-QA-T-164	Instructional Video Template	0	Quality Assurance	Templates	0
1055	CO-PRD1-LBL-030	Temperature only label	0	Production line 1 - Oak House	Label	0
1056	CO-DPT-WEB-001	COVID Consent	0	Digital Product Technology	Website Content	0
1059	CO-DPT-WEB-003	Privacy Policy	0	Digital Product Technology	Website Content	0
1060	CO-DPT-WEB-004	Terms of Service	0	Digital Product Technology	Website Content	0
1061	CO-DPT-WEB-005	Non-COVID Consent	0	Digital Product Technology	Website Content	0
1062	CO-PRD1-T-165	Manufacturing Batch Record  MBR  Template	1	Production line 1 - Oak House	Templates	0
1063	CO-DPT-IFU-044	binx health At-home Nasal Swab COVID-19 Sample Collection Kit IFU for return at a drop-off location  English Print Version	0	Digital Product Technology	Instructions For Use	0
1064	CO-QA-FRM-193	Auditor Qualification	0	Quality Assurance	Forms	0
1065	CO-QA-FRM-194	Auditor Competency Assessment	0	Quality Assurance	Forms	0
1066	CO-QC-PTL-060	MOBY Detection Reagent Spreadsheet Validation Protocol	0	Quality Control	Protocol	0
1067	CO-PRD1-JA-009	Intruder Alarm	0	Production line 1 - Oak House	Job Aid	0
1068	CO-SUP-FRM-195	Purchase Order Request	0	Supply Chain	Forms	0
1069	CO-QA-T-166	Device Specific List of Applicable Standards Form Template	0	Quality Assurance	Templates	0
1070	CO-QA-SOP-274	Applicable Standards Management Procedure	0	Quality Assurance	Standard Operating Procedure	0
1071	CO-QA-REG-032	Master List of Applicable Standards Form Template	0	Quality Assurance	Registers	0
1072	CO-QC-PTL-061	T7 Raw Material Spreadsheet Validation	0	Quality Control	Protocol	0
1073	CO-QC-PTL-062	Process Validation of CO-QC-QCP-039: T7 Exonuclease Raw Material Heated io Detection Rig Test  Part no. 0225	0	Quality Control	Protocol	0
1075	CO-QA-REG-033	Auditor register	0	Quality Assurance	Registers	0
1076	CO-QC-PTL-064	QC testing and release of UNG raw material	2	Quality Control	Protocol	0
1077	CO-QC-PTL-065	Taq-B raw material and CT/NG Taq UNG Reagent Validation	2	Quality Control	Protocol	0
1078	CO-QC-PTL-066	CTNG CT/IC Primer passivation	2	Quality Control	Protocol	0
1079	CO-QC-PTL-067	CTNG NG/IC Primer passivation Validation	2	Quality Control	Protocol	0
1080	CO-QC-PTL-068	CTNG Detection Reagent Validation	3	Quality Control	Protocol	0
1081	CO-CS-SOP-275	Installation and Training - binx io	0	Customer Support	Standard Operating Procedure	0
1082	CO-QC-PTL-069	Testing and Release of Raw Materials & Formulated Reagents	8	Quality Control	Protocol	0
1083	CO-QC-PTL-070	Manufacture of CTNG Cartridge Reagents	1	Quality Control	Protocol	0
1084	CO-QC-PTL-071	Manufacture of Cartridge Reagents	1	Quality Control	Protocol	0
1085	CO-QC-PTL-072	dPCR Performance Qualification	2	Quality Control	Protocol	0
1086	CO-QC-PTL-073	QC Release of CT/NG Cartridge	1	Quality Control	Protocol	0
1087	CO-QC-PTL-074	CT/NG Cartridge QC Test Analysis Template Validation Protocol	1	Quality Control	Protocol	0
1088	CO-DPT-WEB-006	COVID Consent  Spanish	0	Digital Product Technology	Website Content	0
1089	CO-DPT-WEB-007	Privacy Policy  UTI Spanish	0	Digital Product Technology	Website Content	0
1090	CO-DPT-WEB-008	Non-COVID Consent  Spanish	0	Digital Product Technology	Website Content	0
1091	CO-DPT-WEB-009	South Dakota Waiver Consent and Release of Information  Spanish	0	Digital Product Technology	Website Content	0
1092	CO-DPT-WEB-010	Terms of Service  Spanish	0	Digital Product Technology	Website Content	0
1093	CO-DPT-ART-002	Inner lid activation label  STI/ODX	0	Digital Product Technology	Artwork	0
1094	CO-DPT-JA-010	Self-Collection Validation Summary	0	Digital Product Technology	Job Aid	0
1095	CO-FIN-T-167	US Trade Credit Application	0	Finance	Templates	0
1096	CO-PRD1-SOP-276	Label printing	0	Production line 1 - Oak House	Standard Operating Procedure	0
1097	CO-PRD1-PTL-075	Oak House Environmental Control System Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1098	CO-DPT-FEA-002	UTI Screening Box	0	Digital Product Technology	Digital Feature	0
1099	CO-DPT-T-168	Digital Feature Template	0	Digital Product Technology	Templates	0
1100	CO-SUP-SOP-277	Instructions for Receipt of incoming Stock goods assigning GRN No.s & Labelling	3	Supply Chain	Standard Operating Procedure	0
1101	CO-SUP-SOP-278	Pilot Line Electronic Stock Control	8	Supply Chain	Standard Operating Procedure	0
1102	CO-SUP-SOP-279	Stock take procedure	4	Supply Chain	Standard Operating Procedure	0
1103	CO-SUP-SOP-280	Setting Expiry Dates for Incoming Materials	8	Supply Chain	Standard Operating Procedure	0
1104	CO-SUP-SOP-281	Cartridge Component Stock Control Procedure	7	Supply Chain	Standard Operating Procedure	0
1105	CO-SUP-POL-017	Policy for Commercial Operations	3	Supply Chain	Policy	0
1106	CO-QC-SOP-282	QC Sample Handling and Retention Procedure	1	Quality Control	Standard Operating Procedure	0
1107	CO-QC-POL-018	Quality Control Policy	5	Quality Control	Policy	0
1108	CO-QA-SOP-283	Product Risk Management Procedure	4	Quality Assurance	Standard Operating Procedure	0
1109	CO-QA-SOP-284	FMEA Procedure	7	Quality Assurance	Standard Operating Procedure	0
1110	CO-QA-SOP-285	Hazard Analysis Procedure	7	Quality Assurance	Standard Operating Procedure	0
1111	CO-QA-POL-019	Quality Policy	6	Quality Assurance	Policy	0
1112	CO-QA-POL-020	Risk Management Policy	9	Quality Assurance	Policy	0
1113	CO-QA-POL-021	Quality Manual	10	Quality Assurance	Policy	0
1114	CO-QC-REG-034	QC Sample Retention Register	2	Quality Control	Registers	0
1115	CO-QC-LBL-031	QC Retention Box Label	0	Quality Control	Label	0
1116	CO-QC-LBL-032	Excess Raw Material Label	0	Quality Control	Label	0
1117	CO-QC-JA-011	Use of CO-QC-T-118: Detection Reagent Analysis Spreadsheet	1	Quality Control	Job Aid	0
1118	CO-QC-JA-012	Job Aid: A Guide to QC Cartridge Inspections	0	Quality Control	Job Aid	0
1119	CO-QC-SOP-286	Procedure for the Release of io Instruments	3	Quality Control	Standard Operating Procedure	0
1120	CO-LAB-SOP-287	Introduction of New microorganisms SOP	1	Laboratory	Standard Operating Procedure	0
1121	CO-LAB-SOP-288	Assessment of Potentiostat Performance	4	Laboratory	Standard Operating Procedure	0
1122	CO-QC-QCP-052	CT/NG: IC DNA in TE Buffer - Raw Material qPCR test  Part 0248	7	Quality Control	Quality Control Protocol	0
1123	CO-LAB-SOP-289	Standard Procedures for use in the Development of the CT/NG Assay	2	Laboratory	Standard Operating Procedure	0
1124	CO-LAB-SOP-290	SOP for running clinical samples in io® instruments	4	Laboratory	Standard Operating Procedure	0
1125	CO-LAB-SOP-291	Preparation of 10X and 1X TAE Buffer	4	Laboratory	Standard Operating Procedure	0
1126	CO-LAB-SOP-292	Preparation of Tryptone Soya Broth  TSB  and Tryptone Soya Agar  TSA	4	Laboratory	Standard Operating Procedure	0
1127	CO-QC-SOP-293	dPCR Quantification of CT and NG Vircell Inputs	2	Quality Control	Standard Operating Procedure	0
1128	CO-LAB-SOP-294	Standard Way of Making CT Dilutions	4	Laboratory	Standard Operating Procedure	0
1129	CO-LAB-SOP-295	Environmental Contamination testing	6	Laboratory	Standard Operating Procedure	0
1133	CO-QC-SOP-299	io Reader interface - barcode scan rate	3	Quality Control	Standard Operating Procedure	0
1134	CO-LAB-SOP-300	Preparation of Sub-circuit cards for voltammetric detection	5	Laboratory	Standard Operating Procedure	0
1135	CO-LAB-SOP-301	Preparation Microbiological Broth & Agar	4	Laboratory	Standard Operating Procedure	0
1136	CO-LAB-SOP-302	Preparation and use of agarose gels	5	Laboratory	Standard Operating Procedure	0
1137	CO-QC-QCP-053	NG2 Plasmid Quantification - qPCR Test  Part No. 0347	1	Quality Control	Quality Control Protocol	0
1138	CO-QC-QCP-054	NG1 Plasmid Quantification - qPCR Test  Part No. 0346	1	Quality Control	Quality Control Protocol	0
1139	CO-QC-QCP-055	CT Plasmid Quantification - qPCR Test  Part No. 0348	1	Quality Control	Quality Control Protocol	0
1140	CO-QC-QCP-056	Release procedure for CT/NG cartridge	27	Quality Control	Quality Control Protocol	0
1141	CO-QC-QCP-057	CTNG CTIC NG1IC and NG2IC Detection Reagents QC test	6	Quality Control	Quality Control Protocol	0
1142	CO-QC-QCP-058	Material Electrochemical Signal Interference - Electrochemical detection assessment	1	Quality Control	Quality Control Protocol	0
1143	CO-QC-QCP-059	CT/NG Collection Kit Batch Release	2	Quality Control	Quality Control Protocol	0
1144	CO-QC-QCP-060	CT/NG Relabelled Cartridge Batch Release Procedure	2	Quality Control	Quality Control Protocol	0
1145	CO-QC-QCP-061	Electrode Electrochemical Functionality QC Assessment	7	Quality Control	Quality Control Protocol	0
1146	CO-QC-QCP-062	QC release procedure for the Io Reader	8	Quality Control	Quality Control Protocol	0
1147	CO-QC-QCP-063	CT/NG: NG2/IC detection reagent Heated io detection rig	11	Quality Control	Quality Control Protocol	0
1148	CO-QC-QCP-064	CT/NG: NG1/IC Detection Reagent	11	Quality Control	Quality Control Protocol	0
1149	CO-QC-QCP-065	CT/NG: CT/IC Detection Reagent Heated io detection rig	11	Quality Control	Quality Control Protocol	0
1150	CO-QC-QCP-066	CT/NG: NG1/NG2/IC Primer-Passivation Reagent qPCR test	7	Quality Control	Quality Control Protocol	0
1151	CO-QC-QCP-067	CT/NG: CT/IC Primer-Passivation Reagent	9	Quality Control	Quality Control Protocol	0
1152	CO-QC-QCP-068	CT/NG Taq-UNG reagent qPCR test  MOB-D-0277	11	Quality Control	Quality Control Protocol	0
1153	CO-QC-QCP-069	CT/NG: IC DNA Reagent qPCR Test	10	Quality Control	Quality Control Protocol	0
1154	CO-QC-QCP-070	UNG 50 U/uL Part no. 0240	7	Quality Control	Quality Control Protocol	0
1155	CO-QC-QCP-071	Enzymatics Taq-B 25U/ul  Part 0270	8	Quality Control	Quality Control Protocol	0
1156	CO-PRD1-SOP-303	Oak House Out of Hours Procedures	0	Production line 1 - Oak House	Standard Operating Procedure	0
1157	CO-QA-JA-013	QT9 Feedback Module Job Aid	2	Quality Assurance	Job Aid	0
1158	CO-QA-JA-014	QT9 Corrective Action Module Job Aid	0	Quality Assurance	Job Aid	0
1159	CO-QA-JA-015	QT9 Nonconforming Product Job Aid	2	Quality Assurance	Job Aid	0
1160	CO-QA-JA-016	QT9 Preventive Action Module Job Aid	0	Quality Assurance	Job Aid	0
1161	CO-PRD1-URS-021	User Requirement Specification for the binx Cartridge Reagent Manufacturing Lab UK	1	Production line 1 - Oak House	User Requirements Specification	0
1162	CO-PRD1-SOP-304	Management of Critical and Controlled Equipment at Oak House Production Facility	0	Production line 1 - Oak House	Standard Operating Procedure	0
1164	CO-PRD1-SOP-305	Use of ME2002T/00 and ML104T/00 balances in the Oak House Production Facility	1	Production line 1 - Oak House	Standard Operating Procedure	0
1167	CO-PRD1-FRM-197	Manufacture of NG1/IC Detection Reagent	5	Production line 1 - Oak House	Forms	0
1168	CO-PRD1-FRM-198	Manufacture of NG2/IC Detection Reagent	5	Production line 1 - Oak House	Forms	0
1169	CO-PRD1-FRM-199	Manufacture of CT/IC Detection Reagent	6	Production line 1 - Oak House	Forms	0
1170	CO-PRD1-FRM-200	Manufacture of CT/IC Primer Passivation Reagent	3	Production line 1 - Oak House	Forms	0
1171	CO-PRD1-FRM-201	Manufacture of NG1/NG2/IC Primer Passivation Reagent	3	Production line 1 - Oak House	Forms	0
1172	CO-PRD1-FRM-202	Manufacture of CT/NG Taq/UNG Reagent	4	Production line 1 - Oak House	Forms	0
1173	CO-PRD1-FRM-203	Manufacture of IC DNA Reagent	4	Production line 1 - Oak House	Forms	0
1174	CO-PRD1-FRM-212	ME2002T/00 and ML104T/00 Balance Weight Verification Form	1	Production line 1 - Oak House	Forms	0
1175	CO-QA-JA-018	QT9 Internal Audit Module Job Aid	1	Quality Assurance	Job Aid	0
1176	CO-PRD1-SOP-306	Manufacturing Overview for the binx Cartridge Reagent Manufacturing Facility	1	Production line 1 - Oak House	Standard Operating Procedure	0
1178	CO-QC-JA-019	A Guide for QC Document Filing	0	Quality Control	Job Aid	0
1179	CO-PRD1-SOP-308	Use of IKA Digital Roller Mixer	0	Production line 1 - Oak House	Standard Operating Procedure	0
1180	CO-IT-POL-022	Access Control Policy	0	Information Technology	Policy	0
1181	CO-IT-POL-023	Asset Management Policy	0	Information Technology	Policy	0
1182	CO-IT-POL-024	Business Continuity and Disaster Recovery	0	Information Technology	Policy	0
1183	CO-IT-POL-025	Code of Conduct	0	Information Technology	Policy	0
1184	CO-IT-POL-026	Cryptography Policy	0	Information Technology	Policy	0
1185	CO-IT-POL-027	Human Resource Security Policy	0	Information Technology	Policy	0
1186	CO-IT-POL-028	Information Security Policy	0	Information Technology	Policy	0
1187	CO-IT-POL-029	Information Security Roles and Responsibilities	0	Information Technology	Policy	0
1188	CO-IT-POL-030	Physical Security Policy	0	Information Technology	Policy	0
1189	CO-IT-POL-031	Responsible Disclosure Policy	0	Information Technology	Policy	0
1190	CO-IT-POL-032	Risk Management	0	Information Technology	Policy	0
1191	CO-IT-POL-033	Third Party Management	0	Information Technology	Policy	0
1193	CO-QC-PTL-077	Process Validation of CO-QC-QCP-069 and CO-QC-QCP-052. IC DNA Reagent and Raw Material Testing	0	Quality Control	Protocol	0
1194	CO-PRD1-SOP-309	Use of the Uninterruptible Power Supply	0	Production line 1 - Oak House	Standard Operating Procedure	0
1195	CO-OPS-JA-020	Cartridge Defects Library	0	Operations	Job Aid	0
1196	CO-PRD1-REG-035	Oak House Equipment Service and Calibration Register	1	Production line 1 - Oak House	Registers	0
1197	CO-PRD1-REG-036	Oak House Pipette Register	0	Production line 1 - Oak House	Registers	0
1198	CO-PRD1-PTL-078	Oak House Jenway 3510 pH Meter Asset 1143 Validation Protocol	1	Production line 1 - Oak House	Protocol	0
1199	CO-PRD1-LBL-033	Intermediate reagent labels	0	Production line 1 - Oak House	Label	0
1208	CO-PRD1-SOP-310	The use of Calibrated Clocks/Timers	0	Production line 1 - Oak House	Standard Operating Procedure	0
1209	CO-PRD1-FRM-204	Calibrated Clock/Timer verification form	0	Production line 1 - Oak House	Forms	0
1210	CO-PRD1-FRM-211	pH Meter Calibration form - 3 point	2	Production line 1 - Oak House	Forms	0
1211	CO-PRD1-SOP-311	Use of the Rotary Vane Anemometer in Oak House	0	Production line 1 - Oak House	Standard Operating Procedure	0
1212	CO-PRD1-PTL-086	Eupry Temperature Monitoring System Validation	0	Production line 1 - Oak House	Protocol	0
1213	CO-PRD1-SOP-312	Guidance for the completion of Reagent Production Manufacturing Batch Records  MBRs	0	Production line 1 - Oak House	Standard Operating Procedure	0
1214	CO-PRD1-SOP-313	Use of Membrane Filters in the binx Reagent Manufacturing Facility	1	Production line 1 - Oak House	Standard Operating Procedure	0
1215	CO-PRD1-URS-022	URS for a Hydridisation Oven  Benchmark Roto-Therm Plus H2024-E	0	Production line 1 - Oak House	User Requirements Specification	0
1221	CO-PRD1-FRM-205	Equipment Maintenance and Calibration Form	0	Production line 1 - Oak House	Forms	0
1222	CO-PRD1-SOP-318	The use of the calibrated temperature probe	0	Production line 1 - Oak House	Standard Operating Procedure	0
1223	CO-PRD1-SOP-319	Jenway 3510 model pH Meter with ATC probe and 924 30 6.0mm model Tris electrode SOP in Oak House	2	Production line 1 - Oak House	Standard Operating Procedure	0
1224	CO-QA-JA-021	QT9 SCAR Module Job Aid	0	Quality Assurance	Job Aid	0
1225	CO-LAB-FRM-206	Water/Eultion Buffer  aliquot form	0	Laboratory	Forms	0
1226	CO-LAB-FRM-207	Manipulated Material Aliquot form	0	Laboratory	Forms	0
1227	CO-SUP-SOP-320	Oak House Supply Chain Reagent Production Process Flow	4	Supply Chain	Standard Operating Procedure	0
1228	CO-DPT-ART-003	STI Barcodes - 8 count label	0	Digital Product Technology	Artwork	0
1229	CO-DPT-ART-004	ADX Blood Card Barcode QR Labels	0	Digital Product Technology	Artwork	0
1230	CO-DPT-ART-005	COVID Pre-Printed PCR Label	1	Digital Product Technology	Artwork	0
1231	CO-DPT-ART-006	COVID Pre-Printed PCR Label - 1D Barcode	0	Digital Product Technology	Artwork	0
1232	CO-DPT-ART-007	COVID Broad Kit QRX Barcode 2 Part Label	0	Digital Product Technology	Artwork	0
1233	CO-SUP-SOP-321	Incoming Goods Procedure for deliveries into Oak House Manufacturing Site	2	Supply Chain	Standard Operating Procedure	0
1235	CO-PRD1-PTL-087	Oak House Mettler Toledo ME2002T_00 Precision Balance Asset 1170 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1236	CO-PRD1-PTL-088	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1171 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1237	CO-PRD1-PTL-089	Oak House Mettler Toledo ML104T_00 Analytical Balance Asset 1172 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1238	CO-DPT-ART-008	Vaginal STI Sample Collection Sticker	0	Digital Product Technology	Artwork	0
1239	CO-DPT-ART-009	Oral STI Sample Collection Sticker	0	Digital Product Technology	Artwork	0
1240	CO-DPT-ART-010	Anal STI Sample Collection Sticker	0	Digital Product Technology	Artwork	0
1241	CO-DPT-ART-011	Urine STI Sample Collection Sticker	0	Digital Product Technology	Artwork	0
1243	CO-SUP-FRM-209	Oak House Cycle Counting stock sheet	0	Supply Chain	Forms	0
1244	CO-SUP-SOP-322	Supply Team Oak House Operations	1	Supply Chain	Standard Operating Procedure	0
1245	CO-SUP-SOP-323	Demand Planning	0	Supply Chain	Standard Operating Procedure	0
1246	CO-SUP-SOP-324	Packaging and Shipping Procedure for binx Cartridge Reagent	2	Supply Chain	Standard Operating Procedure	0
1248	CO-SUP-FRM-210	Oak House Re-Order form for Supply Chain	0	Supply Chain	Forms	0
1249	CO-PRD1-LBL-034	CT IC Detection Reagent Vial Label	2	Production line 1 - Oak House	Label	0
1250	CO-PRD1-LBL-035	CT IC Primer Passivation Reagent Vial Label	1	Production line 1 - Oak House	Label	0
1251	CO-PRD1-LBL-036	NG1 IC Detection Reagent Vial Label	1	Production line 1 - Oak House	Label	0
1252	CO-PRD1-LBL-037	NG2 IC Detection Reagent Vial Label	1	Production line 1 - Oak House	Label	0
1253	CO-PRD1-LBL-038	NG1 NG2 IC Primer Passivation Reagent Vial Label	1	Production line 1 - Oak House	Label	0
1254	CO-PRD1-LBL-039	CT NG Taq UNG Reagent Vial Label	1	Production line 1 - Oak House	Label	0
1255	CO-PRD1-LBL-040	IC DNA Reagent Vial Label	1	Production line 1 - Oak House	Label	0
1256	CO-PRD1-LBL-041	CT IC Detection Reagent Box Label	2	Production line 1 - Oak House	Label	0
1257	CO-PRD1-LBL-042	CT IC Primer Passivation Reagent Box Label	2	Production line 1 - Oak House	Label	0
1258	CO-PRD1-LBL-043	NG1 IC Detection Reagent Box Label	2	Production line 1 - Oak House	Label	0
1259	CO-PRD1-LBL-044	NG2 IC Detection Reagent Box Label	2	Production line 1 - Oak House	Label	0
1260	CO-PRD1-LBL-045	NG1 NG2 IC Primer Passivation Reagent Box Label	2	Production line 1 - Oak House	Label	0
1261	CO-PRD1-LBL-046	CT NG Taq UNG Reagent Box Label	2	Production line 1 - Oak House	Label	0
1262	CO-PRD1-LBL-047	IC DNA Reagent Box Label	2	Production line 1 - Oak House	Label	0
1263	CO-SUP-JA-023	Dry Ice Job aid  Oak House	0	Supply Chain	Job Aid	0
1266	CO-PRD1-URS-025	URS for temp-controlled equipment for Oak House: Refrigerator Models: RLDF0519 and RLDF1519  freestanding and under bench   -20°C Freezer Models: RLV	0	Production line 1 - Oak House	User Requirements Specification	0
1267	CO-PRD1-URS-026	User Requirement Specification for a Wireless Temperature and Humidity Monitoring System for Oak House Production and Storage Facility	0	Production line 1 - Oak House	User Requirements Specification	0
1274	CO-SUP-T-171	Oak House Commercial Invoice - Cartridge Reagent  -20°c	1	Supply Chain	Templates	0
1275	CO-SUP-T-172	Oak House Packing List - Cartridge Reagent  2-8°c	1	Supply Chain	Templates	0
1276	CO-SUP-FRM-213	Oak House Lab Replenishment Form	0	Supply Chain	Forms	0
1278	CO-PRD1-PTL-090	Oak House Haier DW-86L338J Freezer 1155 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1279	CO-PRD1-PTL-091	Oak House Labcold RLDF1519 Fridge 1157 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1280	CO-PRD1-PTL-092	Oak House Labcold RLDF1519 Fridge 1159 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1281	CO-PRD1-PTL-093	Oak House Labcold RLDF0519 Fridge 1161 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1289	CO-PRD1-PTL-094	Oak House Labcold RLVF1517 Freezer 1158 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1290	CO-PRD1-PTL-095	Oak House Labcold RLVF0417 Freezer 1162 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1291	CO-PRD1-PTL-096	Oak House Labcold RLVF1517 Freezer 1183 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1292	CO-PRD1-PTL-097	Oak House Labcold RLDF1519 Fridge 1207 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1293	CO-PRD1-PTL-098	Oak House Labcold RLVF1517 Freezer 1208 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1302	CO-PRD1-URS-027	User Requirements Specification for a Monmouth Scientific Model Guardian 1800 production enclosure	0	Production line 1 - Oak House	User Requirements Specification	0
1304	CO-SUP-T-178	Reagent component pick list form	4	Supply Chain	Templates	0
1305	CO-SUP-FRM-214	CT IC Detection Reagent Component pick list form	4	Supply Chain	Forms	0
1306	CO-SUP-FRM-215	CT IC Primer Passivation Reagent Component Pick List Form	2	Supply Chain	Forms	0
1307	CO-SUP-FRM-216	NG1 IC Detection Reagent Component Pick List Form	2	Supply Chain	Forms	0
1308	CO-SUP-FRM-217	NG2 IC Detection Reagent Component Pick List Form	2	Supply Chain	Forms	0
1309	CO-SUP-FRM-218	NG1 NG2 IC Primer Passivation Reagent Component Pick List Form	2	Supply Chain	Forms	0
1310	CO-SUP-FRM-219	CT NG Taq UNG Reagent Component Pick List Form	2	Supply Chain	Forms	0
1311	CO-SUP-FRM-220	IC DNA Reagent Component Pick List Form	2	Supply Chain	Forms	0
1312	CO-SUP-JA-024	Consumption on Cost Center	0	Supply Chain	Job Aid	0
1313	CO-SUP-JA-025	Creating stock and non-stock purchase orders from purchase request	0	Supply Chain	Job Aid	0
1314	CO-SUP-JA-026	Production Requests to Production Orders	0	Supply Chain	Job Aid	0
1315	CO-SUP-JA-027	Raising Inspection flag on stock material  SAP ByD	0	Supply Chain	Job Aid	0
1316	CO-SUP-JA-028	Running Purchasing and Production Exception Reports	0	Supply Chain	Job Aid	0
1317	CO-SUP-JA-029	Purchase Order Acknowledgements	0	Supply Chain	Job Aid	0
1318	CO-SUP-JA-030	Manual MRP Process  binx ERP system  and Releasing Purchase / Production Proposals	0	Supply Chain	Job Aid	0
1319	CO-SUP-JA-031	Automatic MRP run set up and edit	0	Supply Chain	Job Aid	0
1320	CO-SUP-JA-032	Goods Movements	0	Supply Chain	Job Aid	0
1322	CO-SUP-JA-034	Raise Purchase Order – Non-stock & Services	0	Supply Chain	Job Aid	0
1324	CO-SUP-JA-036	New Stock Adjustment	0	Supply Chain	Job Aid	0
1325	CO-SUP-JA-037	Expiry Date Amendment	0	Supply Chain	Job Aid	0
1326	CO-SUP-JA-038	Transfer Order	0	Supply Chain	Job Aid	0
1327	CO-SUP-JA-039	Oak House Work Order Preparation	0	Supply Chain	Job Aid	0
1328	CO-SUP-JA-040	Oak House Work Order Completion	0	Supply Chain	Job Aid	0
1329	CO-SUP-JA-041	Oak House Work Order Completion	0	Supply Chain	Job Aid	0
1330	CO-PRD1-PTL-099	Oak House MSC1800 Production Enclosure Asset 1168 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1331	CO-DPT-ART-012	BAO Sassy Little Box	0	Digital Product Technology	Artwork	0
1332	CO-PRD1-PTL-100	Oak House Roto-Therm H2024-E Hybridisation Oven Asset 1113 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1333	CO-PRD1-T-179	Template for IQC for Oak House	1	Production line 1 - Oak House	Templates	0
1335	CO-SUP-POL-034	Supply Team Policy for Oak House Production Suite Operations	0	Supply Chain	Policy	0
1337	CO-LAB-JA-043	CIR Job Aid	1	Laboratory	Job Aid	0
1339	CO-PRD1-FRM-223	Potassium Chloride Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1341	CO-PRD1-FRM-225	Potassium phosphate dibasic Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1342	CO-PRD1-FRM-226	Taq-B Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1343	CO-PRD1-FRM-227	NG2 di452 probe Oak House production IQC	1	Production line 1 - Oak House	Forms	0
1344	CO-PRD1-FRM-228	UNG Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1345	CO-PRD1-FRM-229	MBG Water Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1346	CO-PRD1-FRM-230	Hybridization Oven Verification and Calibration Form	0	Production line 1 - Oak House	Forms	0
1347	CO-PRD1-FRM-231	0.5M EDTA Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1348	CO-PRD1-FRM-232	Brij- 58 Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1349	CO-PRD1-FRM-233	Glycerol Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1350	CO-PRD1-FRM-234	Potassium phosphate monobasic Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1351	CO-PRD1-FRM-235	Trehalose dihydrate Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1352	CO-PRD1-FRM-236	Triton X305 Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1353	CO-PRD1-FRM-237	Trizma base Oak House production IQC	1	Production line 1 - Oak House	Forms	0
1354	CO-PRD1-FRM-238	Trizma hydrochloride Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1355	CO-PRD1-FRM-239	Magnesium chloride Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1356	CO-PRD1-FRM-240	Ethanol Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1357	CO-PRD1-FRM-241	T7 exonuclease Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1358	CO-PRD1-FRM-242	dUTP mix Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1359	CO-PRD1-FRM-243	y-Aminobutyric acid  GABA  Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1360	CO-PRD1-FRM-244	Albumin from bovine serum  BSA  Oak House Production IQC	3	Production line 1 - Oak House	Forms	0
1361	CO-PRD1-FRM-245	DL-dithiothreitol  DTT  Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1362	CO-PRD1-FRM-246	CT di452 probe Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1363	CO-PRD1-FRM-247	IC di275 probe Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1364	CO-PRD1-FRM-248	NG1 di452 probe Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1365	CO-PRD1-FRM-249	CT forward primer Oak House production IQC	2	Production line 1 - Oak House	Forms	0
1366	CO-PRD1-FRM-250	CT reverse primer Oak House Production IQC	2	Production line 1 - Oak House	Forms	0
1367	CO-PRD1-FRM-251	IC  forward primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1368	CO-PRD1-FRM-252	IC reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1369	CO-PRD1-FRM-253	NG1 forward primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1370	CO-PRD1-FRM-254	NG1 Reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1371	CO-PRD1-FRM-255	NG2 forward primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1372	CO-PRD1-FRM-256	NG2 reverse primer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1373	CO-PRD1-FRM-257	Pectobacterium atrosepticum  IC  DNA buffer Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1374	CO-PRD1-PTL-101	Validation of Oak House CT/NG reagent process	1	Production line 1 - Oak House	Protocol	0
1375	CO-OPS-URS-028	Keyence LM Series - User Requirements Specification	0	Operations	User Requirements Specification	0
1376	CO-PRD1-JA-044	Production suite air conditioning job aid	0	Production line 1 - Oak House	Job Aid	0
1377	CO-PRD1-FRM-258	pH Buffer Bottle 10.01 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1378	CO-PRD1-FRM-259	pH Buffer Bottle 7.00 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1379	CO-PRD1-FRM-260	pH Buffer Bottle 4.01 Twin-neck Oak House Production IQC	1	Production line 1 - Oak House	Forms	0
1380	CO-PRD1-FRM-261	Sartorius Minisart™ NML Syringe Filters Sterile  0.45 µm  Male Luer Lock Oak House IQC	1	Production line 1 - Oak House	Forms	0
1381	CO-PRD1-FRM-262	Incoming Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Lock Oak House IQ	0	Production line 1 - Oak House	Forms	0
1382	CO-PRD1-FRM-263	Sartorius Minisart NML hydrophilic sterile Syringe Filter with 0.2 µm surfactant-free Cellulose Acetate Membrane Male Luer Slip Oak House IQC	1	Production line 1 - Oak House	Forms	0
1383	CO-PRD1-LBL-048	ERP GRN for Oak House Label-Rev_0	0	Production line 1 - Oak House	Label	0
1384	CO-PRD1-LBL-049	Quarantined ERP GRN material label-Rev_0	0	Production line 1 - Oak House	Label	0
1385	CO-PRD1-LBL-050	SAP Code ERP GRN Label-Rev_0	0	Production line 1 - Oak House	Label	0
1390	CO-PRD1-PTL-102	Oak House APC Schneider UPS Asset  1116 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1391	CO-PRD1-PTL-103	Oak House APC Schneider UPS Asset  1117 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1392	CO-PRD1-PTL-104	Oak House APC Schneider UPS Asset  1118 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1393	CO-PRD1-PTL-105	Oak House APC Schneider UPS Asset  1176 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1394	CO-PRD1-PTL-106	Oak House APC Schneider UPS Asset  1177 Validation Protocol	0	Production line 1 - Oak House	Protocol	0
1398	CO-SUP-JA-047	Demand Plan - Plan and Release	0	Supply Chain	Job Aid	0
1402	CO-SAM-JA-048	Promotional Materials Checklist	0	Sales and Marketing	Job Aid	0
1403	CO-SAM-JA-049	Use of Acronyms in Marketing Materials	0	Sales and Marketing	Job Aid	0
1405	CO-CS-JA-050	Job Aid _Field Service-Instrument cleaning	0	Customer Support	Job Aid	0
1415	CO-SUP-T-182	Oak House Commercial Invoice - Cartridge Reagent  2-8°c	1	Supply Chain	Templates	0
1416	CO-SUP-T-183	Oak House Packing List - Cartridge Reagent  -20°c	1	Supply Chain	Templates	0
1417	CO-SUP-T-184	binx Commercial Invoice  Misc. shipments	1	Supply Chain	Templates	0
1418	CO-SUP-T-185	binx Packing List  Misc shipments	1	Supply Chain	Templates	0
1419	CO-SUP-JA-055	Use of Elpro data loggers	0	Supply Chain	Job Aid	0
1420	CO-SUP-JA-056	Use of Sensitech data loggers	0	Supply Chain	Job Aid	0
1421	CO-SUP-LBL-051	Shipping Contents Label	0	Supply Chain	Label	0
1422	CO-LAB-URS-029	URS for Female Urine Clinical Study Database	0	Laboratory	User Requirements Specification	0
1423	CO-LAB-PTL-186	Verification Testing Protocol for Female Urine Database	0	Laboratory	Protocol	0
1424	CO-LAB-REG-037	Female Urine Database	0	Laboratory	Registers	0
1426	CO-SUP-JA-057	Third Party Sale and Purchase Orders Process	0	Supply Chain	Job Aid	0
1428	CO-DPT-T-187	Digital BOM Template	0	Digital Product Technology	Templates	0
1430	CO-DPT-BOM-001	2.600.003  CG3 Male  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1431	CO-DPT-BOM-002	2.600.002  CG + Blood Male  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1432	CO-DPT-BOM-003	2.600.004  CG + Blood + Blood Male  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1433	CO-DPT-BOM-004	2.600.500  Blood Unisex  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1434	CO-DPT-BOM-005	2.600.006  CG3 + Blood Male  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1435	CO-DPT-BOM-006	2.600.006-001  CG3 + Blood Male BAO  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1436	CO-DPT-BOM-007	2.600.007  CG3 + Blood + Blood Male  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1437	CO-DPT-BOM-008	2.600.008  CG Male  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1438	CO-DPT-BOM-009	2.600.902  CG + Blood Female  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1439	CO-DPT-BOM-010	2.600.903  CG3 Female  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1440	CO-DPT-BOM-011	2.600.904  CG + Blood + Blood Female  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1441	CO-DPT-BOM-012	2.600.905  Blood + Blood Unisex  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1442	CO-DPT-BOM-013	2.600.906  CG3 + Blood Female  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1443	CO-DPT-BOM-014	2.600.907  CG3 + Blood + Blood Female  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1444	CO-DPT-BOM-015	2.600.908  CG Female  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1445	CO-DPT-BOM-016	2.600.909  HIV USPS Blood Card  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1446	CO-DPT-BOM-017	2.601.002  CG + Blood Male AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1447	CO-DPT-BOM-018	2.601.003  CG Male AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1448	CO-DPT-BOM-019	2.601.005  Blood Unisex AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1449	CO-DPT-BOM-020	2.601.006  CG3 + Blood Male AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1450	CO-DPT-BOM-021	2.601.008  CG Male AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1451	CO-DPT-BOM-022	2.601.902  CG + Blood Female AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1452	CO-DPT-BOM-023	2.601.903  CG3 Female AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1453	CO-DPT-BOM-024	2.601.906  CG3 + Blood Female AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1454	CO-DPT-BOM-025	2.601.908  CG Female AG  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1455	CO-DPT-BOM-026	2.800.001  ADX Blood Card  1  Fasting  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1456	CO-DPT-BOM-027	2.800.002  ADX Blood Card  2  Fasting  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1457	CO-DPT-BOM-028	2.801.001  ADX Blood Card  1 Non-fasting  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1458	CO-DPT-BOM-029	2.801.002  ADX Blood Card  2 Non-fasting  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1459	CO-DPT-BOM-030	5.900.444  Blood Collection Drop-in Pack  Kit BOM	0	Digital Product Technology	Bill of Materials	0
1462	CO-PRD1-SOP-355	Manufacturing Overview for Detection Reagents	2	Production line 1 - Oak House	Standard Operating Procedure	0
1463	CO-QA-SOP-356	EU Regulatory Strategy and Process	0	Quality Assurance	Standard Operating Procedure	0
1464	CO-QA-SOP-357	EU Performance Evaluation	1	Quality Assurance	Standard Operating Procedure	0
1466	CO-QA-T-189	Post Market Performance Follow-up Plan Template	0	Quality Assurance	Templates	0
1467	CO-QA-T-190	Post Market Performance Follow-up Report Template	0	Quality Assurance	Templates	0
1469	CO-QA-T-192	Post Market Surveillance Plan Template	0	Quality Assurance	Templates	0
1470	CO-QA-T-193	Post Market Surveillance Report Template	0	Quality Assurance	Templates	0
1471	CO-QA-T-194	Declaration of Conformity Template	0	Quality Assurance	Templates	0
1473	CO-CS-FRM-267	Field Service Report Form	0	Customer Support	Forms	0
1474	CO-QA-T-196	GSPR Template	0	Quality Assurance	Templates	0
1475	CO-QA-T-197	Summary Technical Documentation  STED  Template	0	Quality Assurance	Templates	0
1476	CO-CS-SOP-358	binx io Field Service Procedure	0	Customer Support	Standard Operating Procedure	0
1484	CO-LAB-T-198	Eupry Calibration Cover Sheet	0	Laboratory	Templates	0
1486	CO-PRD1-T-199	Oak House Manufacturing Overview SOP Template	0	Production line 1 - Oak House	Templates	0
1487	CO-PRD1-T-200	Manufacturing Batch Record  MBR  Template - DEV#28	0	Production line 1 - Oak House	Templates	0
1488	CO-SUP-T-201	Shipping Specification Template	0	Supply Chain	Templates	0
1489	CO-SUP-SOP-363	Shipping Specifications Procedure	0	Supply Chain	Standard Operating Procedure	0
1490	CO-SUP-FRM-269	Shipping Specification: CT/NG io Cartridge	0	Supply Chain	Forms	0
1496	CO-SUP-POL-035	Cold Chain Shipping Policy	0	Supply Chain	Policy	0
1497	CO-H&S-T-204	Incident and Near Miss Reporting Form	4	Health and Safety	Templates	0
1498	CO-H&S-T-202	Health and Safety Risk Assessment Template	1	Health and Safety	Templates	0
1499	CO-H&S-T-203	Blank Form for H&S COSHH assessments	5	Health and Safety	Templates	0
1500	CO-H&S-COSHH-001	COSHH Assessment - General Chemicals	6	Health and Safety	COSHH Assessment	0
1501	CO-H&S-COSHH-002	COSHH Assessment - Oxidising Agents	6	Health and Safety	COSHH Assessment	0
1502	CO-H&S-COSHH-003	COSHH Assessment - Flammable Materials	6	Health and Safety	COSHH Assessment	0
1503	CO-H&S-COSHH-004	COSHH Assessment - Chlorinated Solvents	6	Health and Safety	COSHH Assessment	0
1504	CO-H&S-COSHH-005	COSHH Assessment - Corrosive Bases	6	Health and Safety	COSHH Assessment	0
1505	CO-H&S-COSHH-006	COSH-Assessment - Corrosive Acids	6	Health and Safety	COSHH Assessment	0
1506	CO-H&S-COSHH-007	COSHH assessment  - General Hazard Group 2 organisms	5	Health and Safety	COSHH Assessment	0
1507	CO-H&S-COSHH-008	COSHH assessment  - Hazard Group 2 respiratory pathogens	5	Health and Safety	COSHH Assessment	0
1508	CO-H&S-COSHH-009	COSHH Assessment - Hazard Group 1 Pathogens	4	Health and Safety	COSHH Assessment	0
1509	CO-H&S-COSHH-010	COSHH assessment - clinical samples	6	Health and Safety	COSHH Assessment	0
1510	CO-H&S-COSHH-012	COSHH Assessment - Inactivated Micro-organisms	5	Health and Safety	COSHH Assessment	0
1511	CO-H&S-COSHH-013	COSHH Assessment  - Dry Ice	4	Health and Safety	COSHH Assessment	0
1512	CO-H&S-COSHH-014	COSHH Assessment - Compressed Gases	1	Health and Safety	COSHH Assessment	0
1513	CO-H&S-RA-001	Risk Assessment - binx Health Office and non-laboratory areas	5	Health and Safety	H&S Risk Assessments	0
1514	CO-H&S-RA-002	Risk Assessment for use of Microorganisms	7	Health and Safety	H&S Risk Assessments	0
1515	CO-H&S-RA-003	Risk Assessment - Laboratory Areas  excluding Microbiology and Pilot line	5	Health and Safety	H&S Risk Assessments	0
1516	CO-H&S-RA-004	Risk Assessment - io® reader / assay development tools	5	Health and Safety	H&S Risk Assessments	0
1517	CO-H&S-RA-005	Flammable & Explosive Substances Risk Assessment for  binx health Ltd  Derby Court and Unit 6	4	Health and Safety	H&S Risk Assessments	0
1518	CO-H&S-RA-006	Risk Assessment - use of UV irradiation in the binx health Laboratories	5	Health and Safety	H&S Risk Assessments	0
1519	CO-H&S-RA-007	Risk Assessment - Pilot line Laboratory area	5	Health and Safety	H&S Risk Assessments	0
1520	CO-H&S-RA-008	Risk Assessment for binx Health Employees	4	Health and Safety	H&S Risk Assessments	0
1521	CO-H&S-RA-009	Risk Assessment for use of Chemicals	3	Health and Safety	H&S Risk Assessments	0
1522	CO-H&S-RA-010	Risk Assessment for work-related stress	2	Health and Safety	H&S Risk Assessments	0
1523	CO-H&S-RA-011	Covid-19 Risk Assessment binx Health ltd	6	Health and Safety	H&S Risk Assessments	0
1524	CO-H&S-RA-012	Health and Safety Risk Assessment for Use of a Butane Torch	1	Health and Safety	H&S Risk Assessments	0
1525	CO-H&S-PRO-001	Health & Safety Fire Related Procedures	9	Health and Safety	H&S Procedures	0
1526	CO-H&S-PRO-002	Chemical and Biological COSHH Guidance	8	Health and Safety	H&S Procedures	0
1527	CO-H&S-PRO-003	Manual Lifting Procedure	5	Health and Safety	H&S Procedures	0
1528	CO-H&S-PRO-004	Accident Incident and near miss reporting procedure	4	Health and Safety	H&S Procedures	0
1529	CO-H&S-PRO-005	Health and Safety Risk Assessment Procedure	1	Health and Safety	H&S Procedures	0
1530	CO-H&S-PRO-006	Health and Safety Legislation Review Procedure	1	Health and Safety	H&S Procedures	0
1531	CO-H&S-PRO-007	Fire evacuation procedure for Oak House	1	Health and Safety	H&S Procedures	0
1532	CO-H&S-P-001	Health and Safety Policy	9	Health and Safety	H&S Policy	0
1533	CO-H&S-P-002	PAT Policy	6	Health and Safety	H&S Policy	0
1534	CO-H&S-P-003	Health and Safety Stress Management Policy	1	Health and Safety	H&S Policy	0
1535	CO-H&S-P-004	Coronavirus  COVID-19  Policy on employees being vaccinated	1	Health and Safety	H&S Policy	0
1536	CO-H&S-RA-013	Risk Assessment - Fire - Derby Court and Unit 6	6	Health and Safety	H&S Risk Assessments	0
1537	CO-CS-FRM-275	binx io RMA Number Request Form	0	Customer Support	Forms	0
1538	CO-H&S-RA-014	Health and Safety Risk Assessment Oak House Facility	2	Health and Safety	H&S Risk Assessments	0
1539	CO-H&S-RA-015	Health and Safety Risk Assessment Oak House Production Activities	2	Health and Safety	H&S Risk Assessments	0
1540	CO-H&S-RA-016	Health and Safety Risk Assessment Incoming-Outgoing goods and Packaging	2	Health and Safety	H&S Risk Assessments	0
1541	CO-H&S-RA-017	Health and Safety Oak House Fire Risk Assessment	1	Health and Safety	H&S Risk Assessments	0
1542	CO-H&S-RA-018	Health and Safety Risk Assessment Oak House Covid-19	2	Health and Safety	H&S Risk Assessments	0
1543	CO-OPS-SOP-364	Order to Cash Process	0	Operations	Standard Operating Procedure	0
1544	CO-LAB-FRM-276	High Risk Temperature Controlled Asset Sign	0	Laboratory	Forms	0
1545	CO-LAB-FRM-277	Low Risk Temperature Controlled Asset Sign	0	Laboratory	Forms	0
1546	CO-LAB-FRM-278	Asset Not Temperature Controlled Sign	0	Laboratory	Forms	0
1549	CO-QC-LBL-052	io Instrument Failure - For Engineering Inspection Label	0	Quality Control	Label	0
1550	CO-PRD1-SOP-365	Manufacturing Overview for Primer/Passivation Reagents	0	Production line 1 - Oak House	Standard Operating Procedure	0
1553	CO-SUP-JA-061	AirSea Dry Ice Shipper Packing Instructions	0	Supply Chain	Job Aid	0
1554	CO-SUP-JA-062	AirSea 2-8°c Shipper Packing Instructions	0	Supply Chain	Job Aid	0
1555	CO-SUP-JA-063	Softbox TempCell F39  13-48  Dry ice shipper packing instructions	0	Supply Chain	Job Aid	0
1556	CO-SUP-JA-064	Softbox TempCell PRO shipper packing instructions	0	Supply Chain	Job Aid	0
1557	CO-SUP-JA-065	Softbox TempCell MAX shipper packing instructions	0	Supply Chain	Job Aid	0
1559	CO-SUP-JA-067	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox PRO Shipper	0	Supply Chain	Job Aid	0
1560	CO-SUP-JA-068	CT/NG ioTM Cartridge Packing Instructions for QC samples  Softbox MAX Shipper	0	Supply Chain	Job Aid	0
1561	CO-CS-JA-069	Customer Installation and Training Job Aid binx io	0	Customer Support	Job Aid	0
1562	CO-PRD1-SOP-369	Manufacturing Overview for IC DNA Reagent	0	Production line 1 - Oak House	Standard Operating Procedure	0
1563	CO-PRD1-SOP-370	Manufacturing Overview for CT/NG Taq/UNG Reagent	0	Production line 1 - Oak House	Standard Operating Procedure	0
1564	CO-PRD1-JA-070	Protecting Light Sensitive Reagents with Tin Foil at the Oak House Manufacturing Facility	0	Production line 1 - Oak House	Job Aid	0
1565	CO-QA-REG-041	Employee Unique Initial Register	0	Quality Assurance	Registers	0
1566	CO-CS-JA-071	Field Service - Submitting Documents for QA Approval	0	Customer Support	Job Aid	0
1567	CO-OPS-PTL-108	VAL2023-06 NetSuite Test Specification_QT9	1	Operations	Protocol	0
1568	CO-PRD1-FRM-279	Sterivex-GP Pressure Filter Unit IQC Form	0	Production line 1 - Oak House	Forms	0
1569	CO-QA-T-206	EU Performance Evaluation Plan Template	0	Quality Assurance	Templates	0
1570	CO-QA-T-207	EU Performance Evaluation Report Template	0	Quality Assurance	Templates	0
1571	CO-QC-PTL-109	QC CT/NG 2:2 Input Manufactured Under CO-OPS-SOP-189 Validation Protocol	0	Quality Control	Protocol	0
1583	CO-LAB-LBL-053	SAP Stock Item Label  Green	0	Laboratory	Label	0
1584	CO-LAB-LBL-054	GRN for R&D and Samples Label  Silver	0	Laboratory	Label	0
1585	CO-PRD1-PTL-110	Installation and Operational  Qualification Protocols for Jenway 924 030 6.0 mm Tris Buffer pH Electrode  Asset  to be used with	0	Production line 1 - Oak House	Protocol	0
1588	CO-IT-FRM-005	IT System Change Request Form	0	Information Technology	Forms	0
1594	CO-OPS-POL-037	Policy for Production Specification Transfer to Contract Manufacturers	0	Operations	Policy	0
1596	CO-PMO-T-209	Project Plan	1	Project Management Office	Templates	0
1598	CO-PRD1-JA-081	Pipette Handling -Job Aid	0	Production line 1 - Oak House	Job Aid	0
\.


--
-- Data for Name: escalation_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escalation_state (id, delay_in_hours, state_name, email_text) FROM stdin;
1	1	Inform	A new version of the Document [document number] [document title] has been published. Please review and document your training in the next three (3) weeks
2	4	Warn 1	A new version of the Document [document number] [document title] has been published. Please review and document your training.
3	8	Warn 2	A new version of the Document [document number] [document title] has been published. Please review and document your training. In one (1) week, an email notification will be sent to your direct supervisor. 
4	16	Overdue	A new version of the Document [document number] [document title] has been published. This training is considered overdue. This notification has been escalated to your direct supervisor.
\.


--
-- Data for Name: job_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_documents (id, doc_id, job_id) FROM stdin;
1	573	3
2	486	3
3	595	3
4	470	3
5	574	3
6	65	3
7	595	3
8	1078	3
9	573	0
10	486	0
11	595	0
12	470	0
13	574	0
14	65	0
15	595	0
16	1078	0
17	573	2
18	486	2
19	595	2
20	470	2
21	574	2
22	65	2
23	595	2
24	1078	2
25	573	1
26	486	1
27	595	1
28	470	1
29	574	1
30	65	1
31	595	1
32	1078	1
33	573	4
34	486	4
35	595	4
36	470	4
37	574	4
38	65	4
39	595	4
40	1078	4
1	573	3
2	486	3
3	595	3
4	470	3
5	574	3
6	65	3
7	595	3
8	1078	3
9	573	0
10	486	0
11	595	0
12	470	0
13	574	0
14	65	0
15	595	0
16	1078	0
17	573	2
18	486	2
19	595	2
20	470	2
21	574	2
22	65	2
23	595	2
24	1078	2
25	573	1
26	486	1
27	595	1
28	470	1
29	574	1
30	65	1
31	595	1
32	1078	1
33	573	4
34	486	4
35	595	4
36	470	4
37	574	4
38	65	4
39	595	4
40	1078	4
\.


--
-- Data for Name: job_titles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_titles (id, team_id, name, active) FROM stdin;
1	4	Senior Project Engineer	t
2	4	Systems Engineer	t
3	4	Senior Software Engineer	t
4	4	Engineering Technician	t
0	4	Senior Director	t
\.


--
-- Data for Name: orgchart; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: relationship; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_members (id, user_id, user_is_manager, team_id) FROM stdin;
8	1	f	-1
9	2	f	-1
10	3	f	-1
11	4	f	-1
12	5	f	-1
13	6	f	-1
14	7	f	-1
15	8	f	-1
16	9	f	-1
17	10	f	-1
18	11	f	-1
19	12	f	-1
20	13	f	-1
21	14	f	-1
22	15	f	-1
23	16	f	-1
24	17	f	-1
25	18	f	-1
26	19	f	-1
27	20	f	-1
1	21	t	4
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
5	35	f	4
6	36	f	4
38	37	f	-1
39	38	f	-1
40	39	f	-1
41	40	f	-1
42	41	f	-1
43	42	f	-1
44	43	f	-1
45	44	f	-1
46	45	f	-1
47	46	f	-1
48	47	f	-1
49	48	f	-1
50	49	f	-1
51	50	f	-1
52	51	f	-1
53	52	f	-1
54	53	f	-1
55	54	f	-1
56	55	f	-1
7	56	t	0
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
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (id, name) FROM stdin;
0	Executives
1	Commercial
2	POC Sales
3	Global Customer Support
4	Systems Engineering
5	CFO
6	Accounting
7	Human Resources
8	Logistics & Supply Chain
9	Operations
10	Quality Assurance
11	Quality Control & Technical Product
12	Product Development
0	Executives
1	Commercial
2	POC Sales
3	Global Customer Support
4	Systems Engineering
5	CFO
6	Accounting
7	Human Resources
8	Logistics & Supply Chain
9	Operations
10	Quality Assurance
11	Quality Control & Technical Product
12	Product Development
\.


--
-- Data for Name: training_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.training_record (id, userid, doc_id, doc_version, doc_priority, date_notified, trained, escalation_level, date_validated, validated_by) FROM stdin;
\.


--
-- Data for Name: training_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.training_status (id, userid, documentid, usercurrentrevision, training_complete, training_complete_date) FROM stdin;
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
-- Data for Name: user_jobtitle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_jobtitle (id, user_id, job_title_id) FROM stdin;
0	21	0
1	32	3
2	33	3
3	34	2
4	35	1
5	36	4
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email_address, firstname, surname, active, "isAdmin", "isManager") FROM stdin;
21	Henry Fatoyinbo	henry.fatoyinbo@mybinxhealth.com	Henry	Fatoyinbo	t	f	t
1	Dan Milano	dan.milano@mybinxhealth.com	Dan	Milano	t	f	f
2	Sarah Thomas	sarah.thomas@mybinxhealth.com	Sarah	Thomas	t	f	f
3	Abby Wright	abby.wright@mybinxhealth.com	Abby	Wright	t	f	f
4	Paul Buxton	paul.buxton@mybinxhealth.com	Paul	Buxton	t	f	f
5	Luke Chess	luke.chess@mybinxhealth.com	Luke	Chess	t	f	f
6	Sarah Forster	sarah.forster@mybinxhealth.com	Sarah	Forster	t	f	f
7	Jesna Kattil	jesna.kattil@mybinxhealth.com	Jesna	Kattil	t	f	f
8	Matt Crowley	matt.crowley@mybinxhealth.com	Matt	Crowley	t	f	f
9	Sheila Mirasolo	sheila.mirasolo@mybinxhealth.com	Sheila	Mirasolo	t	f	f
10	Patti Titus	patti.titus@mybinxhealth.com	Patti	Titus	t	f	f
11	Gaby Wirth	gaby.wirth@mybinxhealth.com	Gaby	Wirth	t	f	f
12	Stella Chistyakov	stella.chistyakov@mybinxhealth.com	Stella	Chistyakov	t	f	f
13	Jenna Hanson	jenna.hanson@mybinxhealth.com	Jenna	Hanson	t	f	f
14	Alex Kramer	alex.kramer@mybinxhealth.com	Alex	Kramer	t	f	f
15	Maggie Lefaivre	maggie.lefaivre@mybinxhealth.com	Maggie	Lefaivre	t	f	f
16	Ed Leftin	ed.leftin@mybinxhealth.com	Ed	Leftin	t	f	f
17	Pia Olson	pia.olson@mybinxhealth.com	Pia	Olson	t	f	f
18	Taylor Santos	taylor.santos@mybinxhealth.com	Taylor	Santos	t	f	f
19	Tim Stewart	tim.stewart@mybinxhealth.com	Tim	Stewart	t	f	f
20	John Dowell	john.dowell@mybinxhealth.com	John	Dowell	t	f	f
22	Laura Kemp	laura.kemp@mybinxhealth.com	Laura	Kemp	t	f	f
23	Tim Stewart	tim.stewart@mybinxhealth.com	Tim	Stewart	t	f	f
24	Tony Moran	tony.moran@mybinxhealth.com	Tony	Moran	t	f	f
25	Ben Reynolds	ben.reynolds@mybinxhealth.com	Ben	Reynolds	t	f	f
26	Victoria Catarau	victoria.catarau@mybinxhealth.com	Victoria	Catarau	t	f	f
27	Arman Hossainzadeh	arman.hossainzadeh@mybinxhealth.com	Arman	Hossainzadeh	t	f	f
28	Ian Kelly	ian.kelly@mybinxhealth.com	Ian	Kelly	t	f	f
29	Scott Kerr	scott.kerr@mybinxhealth.com	Scott	Kerr	t	f	f
30	Liam Liu	liam.liu@mybinxhealth.com	Liam	Liu	t	f	f
31	Camilo Madriz	camilo.madriz@mybinxhealth.com	Camilo	Madriz	t	f	f
32	Alan Alpert	alan.alpert@mybinxhealth.com	Alan	Alpert	t	f	f
33	Sean Barnes	sean.barnes@mybinxhealth.com	Sean	Barnes	t	f	f
34	Jawaad Bhatti	jawaad.bhatti@mybinxhealth.com	Jawaad	Bhatti	t	f	f
35	Antony Brown	antony.brown@mybinxhealth.com	Antony	Brown	t	f	f
36	Ian Moore	ian.moore@mybinxhealth.com	Ian	Moore	t	f	f
37	Alyssa Amidei	alyssa.amidei@mybinxhealth.com	Alyssa	Amidei	t	f	f
38	Juliet Coulson	juliet.coulson@mybinxhealth.com	Juliet	Coulson	t	f	f
39	Anna Domanska	anna.domanska@mybinxhealth.com	Anna	Domanska	t	f	f
40	Evaldas Mel	evaldas.mel@mybinxhealth.com	Evaldas	Mel	t	f	f
41	Mike Storm	mike.storm@mybinxhealth.com	Mike	Storm	t	f	f
42	Stephanie Rideout	stephanie.rideout@mybinxhealth.com	Stephanie	Rideout	t	f	f
43	Katherine Danaher	katherine.danaher@mybinxhealth.com	Katherine	Danaher	t	f	f
44	Matthieu Fabrega	matthieu.fabrega@mybinxhealth.com	Matthieu	Fabrega	t	f	f
45	Victoria Hall	victoria.hall@mybinxhealth.com	Victoria	Hall	t	f	f
46	Grace Newman	grace.newman@mybinxhealth.com	Grace	Newman	t	f	f
47	Brygida Kulesza-Orlowska	brygida.kulesza-orlowska@mybinxhealth.com	Brygida	Kulesza-Orlowska	t	f	f
48	Olivia Steward	olivia.steward@mybinxhealth.com	Olivia	Steward	t	f	f
49	Jennifer Araujo	jennifer.araujo@mybinxhealth.com	Jennifer	Araujo	t	f	f
50	Jenna Chicoine	jenna.chicoine@mybinxhealth.com	Jenna	Chicoine	t	f	f
51	Shirley Freeman	shirley.freeman@mybinxhealth.com	Shirley	Freeman	t	f	f
52	Wendy Kivens	wendy.kivens@mybinxhealth.com	Wendy	Kivens	t	f	f
53	Paul Rolls	paul.rolls@mybinxhealth.com	Paul	Rolls	t	f	f
54	Buck Brady	buck.brady@mybinxhealth.com	Buck	Brady	t	f	f
55	Jack Crowley	jack.crowley@mybinxhealth.com	Jack	Crowley	t	f	f
57	Tomos Morris	tomos.morris@mybinxhealth.com	Tomos	Morris	t	f	f
58	Calum Rae	calum.rae@mybinxhealth.com	Calum	Rae	t	f	f
59	Emma Bird	emma.bird@mybinxhealth.com	Emma	Bird	t	f	f
60	Darren Gerrish	darren.gerrish@mybinxhealth.com	Darren	Gerrish	t	f	f
61	Justin Lebrocq	justin.lebrocq@mybinxhealth.com	Justin	Lebrocq	t	f	f
62	Alex Tsang	alex.tsang@mybinxhealth.com	Alex	Tsang	t	f	f
63	Mallory Caron	mallory.caron@mybinxhealth.com	Mallory	Caron	t	f	f
64	Chelsea Murphy	chelsea.murphy@mybinxhealth.com	Chelsea	Murphy	t	f	f
65	Sasha Carr	sasha.carr@mybinxhealth.com	Sasha	Carr	t	f	f
66	Clerveau Toussaint	clerveau.toussaint@mybinxhealth.com	Clerveau	Toussaint	t	f	f
67	Kay Kelly	kay.kelly@mybinxhealth.com	Kay	Kelly	t	f	f
68	Austin Main	austin.main@mybinxhealth.com	Austin	Main	t	f	f
69	Ashley Brown	ashley.brown@mybinxhealth.com	Ashley	Brown	t	f	f
70	Amber Ralf	amber.ralf@mybinxhealth.com	Amber	Ralf	t	f	f
71	Rose Burt	rose.burt@mybinxhealth.com	Rose	Burt	t	f	f
72	Lloyd Peacock	lloyd.peacock@mybinxhealth.com	Lloyd	Peacock	t	f	f
73	Karen Schneider	karen.schneider@mybinxhealth.com	Karen	Schneider	t	f	f
74	Jj Watson	jj.watson@mybinxhealth.com	Jj	Watson	t	f	f
75	Reid Clanton	reid.clanton@mybinxhealth.com	Reid	Clanton	t	f	f
76	Rich Dibiase	rich.dibiase@mybinxhealth.com	Rich	Dibiase	t	f	f
77	Juan Gutierrez	juan.gutierrez@mybinxhealth.com	Juan	Gutierrez	t	f	f
78	Justin Laxton	justin.laxton@mybinxhealth.com	Justin	Laxton	t	f	f
79	Erin Mccormick	erin.mccormick@mybinxhealth.com	Erin	Mccormick	t	f	f
80	Susan Ocasio	susan.ocasio@mybinxhealth.com	Susan	Ocasio	t	f	f
81	Shawna Osborn	shawna.osborn@mybinxhealth.com	Shawna	Osborn	t	f	f
82	Cathy Otto	cathy.otto@mybinxhealth.com	Cathy	Otto	t	f	f
83	Dori Repuyan	dori.repuyan@mybinxhealth.com	Dori	Repuyan	t	f	f
84	Geoffrey Richman	geoffrey.richman@mybinxhealth.com	Geoffrey	Richman	t	f	f
85	Pam Villalba	pam.villalba@mybinxhealth.com	Pam	Villalba	t	f	f
86	Emily Wiitala	emily.wiitala@mybinxhealth.com	Emily	Wiitala	t	f	f
87	Kennedy Daiger	kennedy.daiger@mybinxhealth.com	Kennedy	Daiger	t	f	f
56	Anna Dixon	anna.dixon@mybinxhealth.com	Anna	Dixon	t	f	t
88	Gregg Kelley	gregg.kelley@mybinxhealth.com	Gregg	Kelley	t	f	f
89	Ellis Lambert	ellis.lambert@mybinxhealth.com	Ellis	Lambert	t	f	f
90	Evan Bartlett	evan.bartlett@mybinxhealth.com	Evan	Bartlett	t	f	f
91	Rachel Korwek	rachel.korwek@mybinxhealth.com	Rachel	Korwek	t	f	f
92	Tracie Medairos	tracie.medairos@mybinxhealth.com	Tracie	Medairos	t	f	f
93	Nasa Suon	nasa.suon@mybinxhealth.com	Nasa	Suon	t	f	f
94	Nicole Freeman	nicole.freeman@mybinxhealth.com	Nicole	Freeman	t	f	f
95	Misty Woods-Barnett	misty.woods-barnett@mybinxhealth.com	Misty	Woods-Barnett	t	f	f
96	Monique Doyle	monique.doyle@mybinxhealth.com	Monique	Doyle	t	f	f
97	Dustin Johnson	dustin.johnson@mybinxhealth.com	Dustin	Johnson	t	f	f
98	Alexia Osei-Dabankah	alexia.osei-dabankah@mybinxhealth.com	Alexia	Osei-Dabankah	t	f	f
99	Reno Torres	reno.torres@mybinxhealth.com	Reno	Torres	t	f	f
100	Kalli Glanz	kalli.glanz@mybinxhealth.com	Kalli	Glanz	t	f	f
101	Alyssa Luber	alyssa.luber@mybinxhealth.com	Alyssa	Luber	t	f	f
102	Jeff Luber	jeff.luber@mybinxhealth.com	Jeff	Luber	t	f	f
\.


--
-- Data for Name: userstate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userstate (id, employee_name, qt9_document_code, revision, title, trained) FROM stdin;
1	Employee Name	QT9 Document Code	Revision	Title	Trained
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
35	Jeff Luber	CO-SUP-POL-017	3	Policy for Customer Interface	 Order Handling
36	Jeff Luber	CO-QA-POL-019	6	Quality Policy	N
37	Jeff Luber	CO-QA-SOP-285	6	Hazard Analysis Procedure	Y
38	Jeff Luber	CO-QA-SOP-284	6	FMEA Procedure	Y
39	Jeff Luber	CO-QA-SOP-283	4	Product Risk Management 	Y
40	Jeff Luber	CO-SUP-SOP-068	14	Purchasing SOP	Y
41	Jeff Luber	CO-SUP-SOP-069	7	Supplier Evaluation SOP	Y
42	Jeff Luber	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
147	Jack Kaminski	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
208	Alyssa Luber	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
311	Nasa Suon	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
349	Alexia Osei-Dabankah	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
384	Evan Bartlett	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
410	Reno Torres	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
457	Rachel Korwek	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
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
585	Antony Brown	CO-SUP-POL-017	3	Policy for Customer Interface	 Order Handling
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
597	Antony Brown	CO-SUP-SOP-070	5	Supplier Risk Assessment	 Approval and Monitoring Procedure
598	Antony Brown	CO-SUP-SOP-277	3	Instructions for receipt of incoming Non-Stock goods	 assigning GRN numbers and labelling
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
905	Alan Alpert	CO-SUP-POL-017	3	Policy for Customer Interface	 Order Handling
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
\.


--
-- Name: current_state_documents2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.current_state_documents2_id_seq', 1073, true);


--
-- Name: current_state_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.current_state_documents_id_seq', 7481, true);


--
-- Name: document_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_list_id_seq', 450, true);


--
-- Name: document_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_type_id_seq', 5, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 462, true);


--
-- Name: job_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_documents_id_seq', 40, true);


--
-- Name: job_titles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_titles_id_seq', 1, false);


--
-- Name: orgchart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orgchart_id_seq', 168, true);


--
-- Name: relationship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relationship_id_seq', 132, true);


--
-- Name: training_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.training_record_id_seq', 1, false);


--
-- Name: training_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.training_status_id_seq', 838, true);


--
-- Name: user_jobtitle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_jobtitle_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 104, true);


--
-- Name: userstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userstate_id_seq', 957, true);


--
-- Name: current_state_documents2 current_state_documents2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_state_documents2
    ADD CONSTRAINT current_state_documents2_pkey PRIMARY KEY (id);


--
-- Name: current_state_documents current_state_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_state_documents
    ADD CONSTRAINT current_state_documents_pkey PRIMARY KEY (id);


--
-- Name: document_list document_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_list
    ADD CONSTRAINT document_list_pkey PRIMARY KEY (id);


--
-- Name: document_type document_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_type
    ADD CONSTRAINT document_type_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: orgchart orgchart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orgchart
    ADD CONSTRAINT orgchart_pkey PRIMARY KEY (id);


--
-- Name: relationship relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_pkey PRIMARY KEY (id);


--
-- Name: training_record training_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.training_record
    ADD CONSTRAINT training_record_pkey PRIMARY KEY (id);


--
-- Name: training_status training_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.training_status
    ADD CONSTRAINT training_status_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: userstate userstate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userstate
    ADD CONSTRAINT userstate_pkey PRIMARY KEY (id);


ALTER TABLE ADD COLUMN roles VARCHAR(20);


--
-- PostgreSQL database dump complete
--

