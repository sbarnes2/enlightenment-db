--\connect "training"


BEGIN;


--ALTER TABLE "users" ADD COLUMN "created" DATE DEFAULT DATE.now;


CREATE TABLE "public"."transaction_type"(
    "id" INTEGER NOT NULL,
    "type_name" CHARACTER varying(25) not null,
    "type_text" CHARACTER varying(250)
);
ALTER TABLE "public"."transaction_type" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."transaction_type_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."transaction_log"(
    "id" INTEGER NOT NULL,
    "transaction_user_id" INTEGER NOT NULL,
    "target_userid" INTEGER NOT NULL,
    "transaction_type_id" INTEGER NOT NULL,
    "transaction_data"  CHARACTER VARYING(250), -- can be anything that needs to be stored with the transaction document name, paths, users name etc.
    "date" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "public"."transaction_log" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."transaction_log_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--defines escalation policy NOT events.
CREATE TABLE "public"."escalation"(
    "id" INTEGER not null,
    "escalation_level"  INTEGER NOT NULL,
    "delay_days" INTEGER NOT NULL,
    "message" CHARACTER varying(200)
);
ALTER TABLE "public"."escalation" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."escalation_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."email_log"(
  "id" INTEGER not NULL,
  "userid"  INTEGER NOT NULL,
  "escalation_level" INTEGER NOT NULL,
  "email_sent_date" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP 
);
ALTER TABLE "public"."email_log" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."email_log_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE "public"."training_record"(
    "id" INTEGER  NOT NULL,
    "doc_id" INTEGER NOT NULL, -- < going to need converting from VARCHAR
    "risk_level" INTEGER NOT NULL,
    "revision" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL, --< user id of employee
    "run_date" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "needs_verification" BOOLEAN DEFAULT false,
    "trained" BOOLEAN DEFAULT false,
    "verified" BOOLEAN DEFAULT false,
    "date_verified" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "verified_by" INTEGER not null default 0, --< user id of manager / admin
    "current_escalation_level" INTEGER not null default 0
);
ALTER TABLE "public"."training_record" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY(
    SEQUENCE NAME "public"."training_record_id_seq"
        START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY "public"."transaction_type"
ADD CONSTRAINT "transaction_type_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."transaction_log"
ADD CONSTRAINT "transaction_log_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."escalation"
ADD CONSTRAINT "escalation_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."email_log"
ADD CONSTRAINT "email_log_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."training_record"
ADD CONSTRAINT "training_record_pkey" PRIMARY KEY ("id");

INSERT INTO transaction_type (type_name,type_text) 
VALUES
    ('email_sent','sent initial email to user'),
    ('email_escalation_1','escalated to level 1'),
    ('email_escalation_2','escalated to level 2'),
    ('email_escalation_3','escalated to level 3'),
    ('email_escalation_4','escalated to level 4'),
    ('email_verification','verification email sent'), 
    ('user_trained','user ackowledged training'),
    ('manager_verified','manager verified training for user');
ROLLBACK;

