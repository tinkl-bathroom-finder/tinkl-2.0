--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: update_updated_at_restrooms(); Type: FUNCTION; Schema: public; Owner: rileyalexis
--

CREATE FUNCTION public.update_updated_at_restrooms() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF TG_TABLE_NAME = 'comments' THEN
		UPDATE restrooms
    	SET updated_at = now()
    	WHERE id = NEW.restroom_id;
    ELSIF TG_TABLE_NAME = 'restroom_votes' THEN
		UPDATE restrooms
    	SET updated_at = now()
    	WHERE id = NEW.restroom_id;
    END IF;
    
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_updated_at_restrooms() OWNER TO rileyalexis;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comment_votes; Type: TABLE; Schema: public; Owner: rileyalexis
--

CREATE TABLE public.comment_votes (
    id integer NOT NULL,
    user_id integer,
    comment_id integer,
    vote text,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.comment_votes OWNER TO rileyalexis;

--
-- Name: comment_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: rileyalexis
--

CREATE SEQUENCE public.comment_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_votes_id_seq OWNER TO rileyalexis;

--
-- Name: comment_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rileyalexis
--

ALTER SEQUENCE public.comment_votes_id_seq OWNED BY public.comment_votes.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: rileyalexis
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    content text,
    restroom_id integer,
    user_id integer,
    is_removed boolean DEFAULT false,
    is_flagged boolean DEFAULT false,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.comments OWNER TO rileyalexis;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: rileyalexis
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO rileyalexis;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rileyalexis
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: opening_hours; Type: TABLE; Schema: public; Owner: rileyalexis
--

CREATE TABLE public.opening_hours (
    id integer NOT NULL,
    place_id integer,
    weekday_text text,
    day_0_open integer,
    day_0_close integer,
    day_1_open integer,
    day_1_close integer,
    day_2_open integer,
    day_2_close integer,
    day_3_open integer,
    day_3_close integer,
    day_4_open integer,
    day_4_close integer,
    day_5_open integer,
    day_5_close integer,
    day_6_open integer,
    day_6_close integer,
    updated_at timestamp with time zone DEFAULT now(),
    restroom_id integer
);


ALTER TABLE public.opening_hours OWNER TO rileyalexis;

--
-- Name: opening_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: rileyalexis
--

CREATE SEQUENCE public.opening_hours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.opening_hours_id_seq OWNER TO rileyalexis;

--
-- Name: opening_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rileyalexis
--

ALTER SEQUENCE public.opening_hours_id_seq OWNED BY public.opening_hours.id;


--
-- Name: restroom_votes; Type: TABLE; Schema: public; Owner: rileyalexis
--

CREATE TABLE public.restroom_votes (
    id integer NOT NULL,
    user_id integer,
    restroom_id integer,
    upvote integer,
    downvote integer,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.restroom_votes OWNER TO rileyalexis;

--
-- Name: restroom_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: rileyalexis
--

CREATE SEQUENCE public.restroom_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restroom_votes_id_seq OWNER TO rileyalexis;

--
-- Name: restroom_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rileyalexis
--

ALTER SEQUENCE public.restroom_votes_id_seq OWNED BY public.restroom_votes.id;


--
-- Name: restrooms; Type: TABLE; Schema: public; Owner: rileyalexis
--

CREATE TABLE public.restrooms (
    id integer NOT NULL,
    api_id character varying,
    name character varying,
    street character varying,
    city character varying,
    state character varying,
    accessible boolean DEFAULT false,
    unisex boolean DEFAULT false,
    directions text,
    latitude real,
    longitude real,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    country character varying,
    changing_table boolean DEFAULT false,
    is_removed boolean DEFAULT false,
    is_single_stall boolean DEFAULT false,
    is_multi_stall boolean DEFAULT false,
    is_flagged boolean DEFAULT false,
    place_id text
);


ALTER TABLE public.restrooms OWNER TO rileyalexis;

--
-- Name: restrooms_id_seq; Type: SEQUENCE; Schema: public; Owner: rileyalexis
--

CREATE SEQUENCE public.restrooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restrooms_id_seq OWNER TO rileyalexis;

--
-- Name: restrooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rileyalexis
--

ALTER SEQUENCE public.restrooms_id_seq OWNED BY public.restrooms.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: rileyalexis
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(100),
    is_admin boolean DEFAULT false,
    is_removed boolean DEFAULT false,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    reset_password_token text,
    reset_password_expires timestamp without time zone
);


ALTER TABLE public."user" OWNER TO rileyalexis;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: rileyalexis
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO rileyalexis;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rileyalexis
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: comment_votes id; Type: DEFAULT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comment_votes ALTER COLUMN id SET DEFAULT nextval('public.comment_votes_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: opening_hours id; Type: DEFAULT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.opening_hours ALTER COLUMN id SET DEFAULT nextval('public.opening_hours_id_seq'::regclass);


--
-- Name: restroom_votes id; Type: DEFAULT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.restroom_votes ALTER COLUMN id SET DEFAULT nextval('public.restroom_votes_id_seq'::regclass);


--
-- Name: restrooms id; Type: DEFAULT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.restrooms ALTER COLUMN id SET DEFAULT nextval('public.restrooms_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: comment_votes; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public.comment_votes (id, user_id, comment_id, vote, inserted_at, updated_at) FROM stdin;
1	8	1	50	2024-09-17 12:58:30.911437-05	2024-09-17 12:58:30.911437-05
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public.comments (id, content, restroom_id, user_id, is_removed, is_flagged, inserted_at, updated_at) FROM stdin;
1	ICUP	494	8	f	f	2024-09-17 12:56:48.890207-05	2024-09-17 12:56:48.890207-05
\.


--
-- Data for Name: opening_hours; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public.opening_hours (id, place_id, weekday_text, day_0_open, day_0_close, day_1_open, day_1_close, day_2_open, day_2_close, day_3_open, day_3_close, day_4_open, day_4_close, day_5_open, day_5_close, day_6_open, day_6_close, updated_at, restroom_id) FROM stdin;
1	\N	Monday: Closed, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 9:00 PM, Saturday: 11:00 AM – 9:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	\N	\N	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	2024-08-09 15:25:44.151154-05	6
2	\N	Monday: Closed, Tuesday: 1:00 – 8:00 PM, Wednesday: 1:00 – 8:00 PM, Thursday: 1:00 – 8:00 PM, Friday: 1:00 – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 8:00 PM	1000	2000	\N	\N	1300	2000	1300	2000	1300	2000	1300	2000	1000	2000	2024-08-09 15:25:44.935515-05	8
3	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:25:45.17201-05	9
4	\N	Monday: 8:00 AM – 4:30 PM, Tuesday: 8:00 AM – 4:30 PM, Wednesday: 8:00 AM – 4:30 PM, Thursday: 8:00 AM – 4:30 PM, Friday: 8:00 AM – 4:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:25:45.463913-05	11
5	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:25:45.723094-05	12
6	\N	Monday: Closed, Tuesday: 1:00 – 8:00 PM, Wednesday: 1:00 – 8:00 PM, Thursday: 1:00 – 8:00 PM, Friday: 1:00 – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 8:00 PM	1000	2000	\N	\N	1300	2000	1300	2000	1300	2000	1300	2000	1000	2000	2024-08-09 15:25:46.055597-05	13
7	\N	Monday: Closed, Tuesday: 1:00 – 8:00 PM, Wednesday: 1:00 – 8:00 PM, Thursday: 1:00 – 8:00 PM, Friday: 1:00 – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 8:00 PM	1000	2000	\N	\N	1300	2000	1300	2000	1300	2000	1300	2000	1000	2000	2024-08-09 15:25:46.238539-05	14
8	\N	Monday: Closed, Tuesday: 1:00 – 8:00 PM, Wednesday: 1:00 – 8:00 PM, Thursday: 1:00 – 8:00 PM, Friday: 1:00 – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 8:00 PM	1000	2000	\N	\N	1300	2000	1300	2000	1300	2000	1300	2000	1000	2000	2024-08-09 15:25:46.577895-05	15
9	\N	Monday: Closed, Tuesday: 1:00 – 8:00 PM, Wednesday: 1:00 – 8:00 PM, Thursday: 1:00 – 8:00 PM, Friday: 1:00 – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 8:00 PM	1000	2000	\N	\N	1300	2000	1300	2000	1300	2000	1300	2000	1000	2000	2024-08-09 15:25:46.753963-05	16
10	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 9:00 AM – 7:00 PM	900	1900	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:25:47.937573-05	20
11	\N	Monday: Closed, Tuesday: 10:00 AM – 2:00 PM, Wednesday: 10:00 AM – 2:00 PM, Thursday: 10:00 AM – 2:00 PM, Friday: 10:00 AM – 2:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	\N	\N	1000	1400	1000	1400	1000	1400	1000	1400	\N	\N	2024-08-09 15:25:48.144034-05	21
12	\N	Monday: 12:00 PM – 2:00 AM, Tuesday: 12:00 PM – 2:00 AM, Wednesday: 12:00 PM – 2:00 AM, Thursday: 12:00 PM – 2:00 AM, Friday: 12:00 PM – 3:00 AM, Saturday: 12:00 PM – 3:00 AM, Sunday: 12:00 PM – 2:00 AM	1200	200	1200	200	1200	200	1200	200	1200	200	1200	300	1200	300	2024-08-09 15:25:49.229026-05	24
13	\N	Monday: Closed, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 – 11:00 PM, Saturday: 12:00 – 11:00 PM, Sunday: 11:00 AM – 8:00 PM	1100	2000	\N	\N	1600	2200	1600	2200	1600	2200	1600	2300	1200	2300	2024-08-09 15:25:49.748876-05	26
14	\N	Monday: Closed, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 – 11:00 PM, Saturday: 12:00 – 11:00 PM, Sunday: 11:00 AM – 8:00 PM	1100	2000	\N	\N	1600	2200	1600	2200	1600	2200	1600	2300	1200	2300	2024-08-09 15:25:50.08232-05	27
15	\N	Monday: 4:00 – 10:00 PM, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 12:00 AM, Saturday: 4:00 PM – 12:00 AM, Sunday: 4:00 – 10:00 PM	1600	2200	1600	2200	1600	2200	1600	2200	1600	2200	1600	0	1600	0	2024-08-09 15:25:52.440371-05	33
16	\N	Monday: Closed, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 4:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: Closed	\N	\N	\N	\N	1000	1600	1000	1600	1000	1900	1000	1600	1000	1600	2024-08-09 15:25:53.002018-05	37
17	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	0	1100	0	2024-08-09 15:25:53.250547-05	38
18	\N	Monday: 11:00 AM – 2:00 PM, 4:00 – 9:00 PM, Tuesday: 11:00 AM – 2:00 PM, 4:00 – 9:00 PM, Wednesday: 11:00 AM – 2:00 PM, 4:00 – 9:00 PM, Thursday: 11:00 AM – 2:00 PM, 4:00 – 9:00 PM, Friday: 11:00 AM – 9:00 PM, Saturday: 11:00 AM – 9:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	1600	2100	1600	2100	1600	2100	1600	2100	1100	2100	1100	2100	2024-08-09 15:25:54.891874-05	43
19	\N	Monday: 7:00 AM – 4:00 PM, Tuesday: 7:00 AM – 4:00 PM, Wednesday: 7:00 AM – 4:00 PM, Thursday: 7:00 AM – 4:00 PM, Friday: 7:00 AM – 4:00 PM, Saturday: 7:00 AM – 4:00 PM, Sunday: 7:00 AM – 4:00 PM	700	1600	700	1600	700	1600	700	1600	700	1600	700	1600	700	1600	2024-08-09 15:25:55.107761-05	44
20	\N	Monday: 10:00 AM – 5:00 PM, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 5:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 11:00 AM – 4:00 PM, Sunday: Closed	\N	\N	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	1100	1600	2024-08-09 15:25:55.332507-05	45
21	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	2024-08-09 15:25:55.605114-05	46
22	\N	Monday: 6:30 AM – 10:30 PM, Tuesday: 6:30 AM – 10:30 PM, Wednesday: 6:30 AM – 10:30 PM, Thursday: 6:30 AM – 10:30 PM, Friday: 6:30 AM – 10:30 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: Closed	\N	\N	600	2200	600	2200	600	2200	600	2200	600	2200	700	1700	2024-08-09 15:25:55.831116-05	47
23	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: 7:00 AM – 7:00 PM, Sunday: 7:00 AM – 7:00 PM	700	1900	700	1900	700	1900	700	1900	700	1900	700	1900	700	1900	2024-08-09 15:25:56.320776-05	49
24	\N	Monday: 6:30 AM – 10:30 PM, Tuesday: 6:30 AM – 10:30 PM, Wednesday: 6:30 AM – 10:30 PM, Thursday: 6:30 AM – 10:30 PM, Friday: 6:30 AM – 10:30 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: Closed	\N	\N	600	2200	600	2200	600	2200	600	2200	600	2200	700	1700	2024-08-09 15:25:56.503772-05	50
25	\N	Monday: 11:00 AM – 8:00 PM, Tuesday: 11:00 AM – 8:00 PM, Wednesday: 11:00 AM – 8:00 PM, Thursday: 11:00 AM – 8:00 PM, Friday: 11:00 AM – 8:00 PM, Saturday: 11:00 AM – 8:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	2024-08-09 15:25:57.291328-05	52
26	\N	Monday: 8:00 AM – 12:00 AM, Tuesday: 8:00 AM – 12:00 AM, Wednesday: 8:00 AM – 12:00 AM, Thursday: 8:00 AM – 12:00 AM, Friday: 8:00 AM – 12:00 AM, Saturday: 8:00 AM – 12:00 AM, Sunday: 8:00 AM – 12:00 AM	800	0	800	0	800	0	800	0	800	0	800	0	800	0	2024-08-09 15:25:57.675159-05	53
27	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	900	1700	900	1700	900	1700	900	1700	900	1700	\N	\N	2024-08-09 15:25:58.475274-05	58
28	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	700	1700	700	1700	700	1700	700	1700	700	1700	900	1700	2024-08-09 15:25:58.680606-05	59
29	\N	Monday: 11:00 AM – 11:00 PM, Tuesday: 11:00 AM – 11:00 PM, Wednesday: 11:00 AM – 11:00 PM, Thursday: 11:00 AM – 12:00 AM, Friday: 11:00 AM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2300	1100	2300	1100	2300	1100	0	1100	0	1100	0	2024-08-09 15:26:00.174972-05	64
30	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: Closed	\N	\N	900	1900	900	1900	900	1900	900	1900	900	1900	1000	1600	2024-08-09 15:26:00.406791-05	65
31	\N	Monday: 9:00 AM – 4:00 PM, Tuesday: 9:00 AM – 4:00 PM, Wednesday: 9:00 AM – 4:00 PM, Thursday: 9:00 AM – 4:00 PM, Friday: 9:00 AM – 4:00 PM, Saturday: 5:30 – 6:30 PM, Sunday: 8:00 – 9:00 AM, 10:30 AM – 12:00 PM, 5:00 – 6:00 PM	1700	1800	900	1600	900	1600	900	1600	900	1600	900	1600	1700	1800	2024-08-09 15:26:01.875813-05	68
32	\N	Monday: 5:45 AM – 9:00 PM, Tuesday: 5:45 AM – 9:00 PM, Wednesday: 5:45 AM – 9:00 PM, Thursday: 5:45 AM – 9:00 PM, Friday: 5:45 AM – 9:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	500	2100	500	2100	500	2100	500	2100	500	2100	1000	1600	2024-08-09 15:26:02.899368-05	70
33	\N	Monday: Closed, Tuesday: Closed, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	\N	\N	\N	\N	1000	1700	1000	2100	1000	1700	1000	1700	2024-08-09 15:26:03.769146-05	72
34	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 8:00 PM, Friday: 7:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1700	700	1800	700	1900	700	2000	700	1600	\N	\N	2024-08-09 15:26:04.117438-05	73
35	\N	Monday: Closed, Tuesday: Closed, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	\N	\N	\N	\N	1000	1700	1000	2100	1000	1700	1000	1700	2024-08-09 15:26:04.298107-05	74
36	\N	Monday: 8:00 AM – 5:00 PM, Tuesday: 8:00 AM – 5:00 PM, Wednesday: 8:00 AM – 5:00 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 8:00 AM – 5:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1700	800	1700	800	1700	800	1700	800	1700	\N	\N	2024-08-09 15:26:05.92473-05	77
37	\N	Monday: Closed, Tuesday: Closed, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 5:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 11:00 AM – 5:00 PM, Sunday: 11:00 AM – 5:00 PM	1100	1700	\N	\N	\N	\N	1000	1700	1000	1700	1000	1700	1100	1700	2024-08-09 15:26:06.75522-05	79
38	\N	Monday: Closed, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	\N	\N	1000	1700	1000	1700	1000	2100	1000	1700	1000	1700	2024-08-09 15:26:07.718626-05	82
39	\N	Monday: Closed, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	\N	\N	1000	1700	1000	1700	1000	2100	1000	1700	1000	1700	2024-08-09 15:26:08.068096-05	83
40	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: 8:30 AM – 4:30 PM, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	800	1600	2024-08-09 15:26:08.390916-05	85
41	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: 8:30 AM – 4:30 PM, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	800	1600	2024-08-09 15:26:08.582595-05	86
42	\N	Monday: Closed, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 9:00 PM, Saturday: 11:00 AM – 9:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	\N	\N	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	2024-08-09 15:26:11.705787-05	93
43	\N	Monday: Closed, Tuesday: Closed, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	\N	\N	1600	2200	1600	2200	1600	100	1100	100	2024-08-09 15:26:12.614242-05	95
44	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 7:00 AM – 4:00 PM, Sunday: Closed	\N	\N	600	2200	600	2200	600	2200	600	2200	600	2200	700	1600	2024-08-09 15:26:31.337715-05	102
45	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 7:00 AM – 4:00 PM, Sunday: Closed	\N	\N	600	2200	600	2200	600	2200	600	2200	600	2200	700	1600	2024-08-09 15:26:31.517297-05	103
46	\N	Monday: Closed, Tuesday: Closed, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	\N	\N	1600	2200	1600	2200	1600	100	1100	100	2024-08-09 15:26:31.705131-05	104
47	\N	Monday: Closed, Tuesday: Closed, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	\N	\N	1600	2200	1600	2200	1600	100	1100	100	2024-08-09 15:26:31.852281-05	105
48	\N	Monday: Closed, Tuesday: Closed, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	\N	\N	1600	2200	1600	2200	1600	100	1100	100	2024-08-09 15:26:31.998663-05	106
49	\N	Monday: Closed, Tuesday: Closed, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	\N	\N	1600	2200	1600	2200	1600	100	1100	100	2024-08-09 15:26:32.173821-05	107
50	\N	Monday: Closed, Tuesday: Closed, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	\N	\N	1600	2200	1600	2200	1600	100	1100	100	2024-08-09 15:26:32.482774-05	109
51	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: Closed	\N	\N	900	1900	900	1900	900	1900	900	1900	900	1900	1000	1600	2024-08-09 15:26:32.661677-05	110
52	\N	Monday: 7:00 AM – 8:00 PM, Tuesday: 7:00 AM – 8:00 PM, Wednesday: 7:00 AM – 8:00 PM, Thursday: 7:00 AM – 8:00 PM, Friday: 7:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: Closed	\N	\N	700	2000	700	2000	700	2000	700	2000	700	2000	900	2000	2024-08-09 15:26:32.870163-05	111
53	\N	Monday: 7:00 AM – 8:00 PM, Tuesday: 7:00 AM – 8:00 PM, Wednesday: 7:00 AM – 8:00 PM, Thursday: 7:00 AM – 8:00 PM, Friday: 7:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: Closed	\N	\N	700	2000	700	2000	700	2000	700	2000	700	2000	900	2000	2024-08-09 15:26:33.039659-05	112
54	\N	Monday: 8:20 AM – 3:20 PM, Tuesday: 8:20 AM – 3:20 PM, Wednesday: 8:20 AM – 3:20 PM, Thursday: 8:20 AM – 3:20 PM, Friday: 8:20 AM – 3:20 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1500	800	1500	800	1500	800	1500	800	1500	\N	\N	2024-08-09 15:26:33.401549-05	113
55	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: Closed	\N	\N	900	1900	900	1900	900	1900	900	1900	900	1900	1000	1600	2024-08-09 15:26:33.572323-05	114
56	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:33.974194-05	115
57	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: Closed, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 2:00 PM, Sunday: Closed	\N	\N	1000	1800	\N	\N	1000	1800	1000	1800	1000	1700	1000	1400	2024-08-09 15:26:34.176086-05	116
58	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: Closed	\N	\N	900	1900	900	1900	900	1900	900	1900	900	1900	1000	1600	2024-08-09 15:26:34.352527-05	117
59	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:34.531333-05	118
60	\N	Monday: 8:00 AM – 4:00 PM, Tuesday: 8:00 AM – 4:00 PM, Wednesday: 8:00 AM – 4:00 PM, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:26:36.144957-05	122
61	\N	Monday: 8:00 AM – 4:30 PM, Tuesday: 8:00 AM – 4:30 PM, Wednesday: 8:00 AM – 4:30 PM, Thursday: 8:30 AM – 4:30 PM, Friday: 8:00 AM – 4:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:26:36.368553-05	123
62	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:36.96424-05	126
63	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	\N	\N	\N	\N	\N	\N	800	1600	800	1600	800	1600	2024-08-09 15:26:37.196946-05	127
64	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	\N	\N	\N	\N	\N	\N	800	1600	800	1600	800	1600	2024-08-09 15:26:37.371461-05	128
65	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	\N	\N	\N	\N	\N	\N	800	1600	800	1600	800	1600	2024-08-09 15:26:37.584527-05	129
66	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	\N	\N	\N	\N	\N	\N	800	1600	800	1600	800	1600	2024-08-09 15:26:37.884537-05	130
67	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 5:00 – 9:00 PM, Friday: 9:30 AM – 2:30 PM, 5:00 – 9:00 PM, Saturday: 9:00 AM – 3:30 PM, 5:00 – 9:00 PM, Sunday: 9:00 AM – 3:30 PM	900	1500	\N	\N	\N	\N	\N	\N	1700	2100	1700	2100	1700	2100	2024-08-09 15:26:38.091088-05	131
68	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:26:39.223323-05	135
69	\N	Monday: Closed, Tuesday: 4:00 – 9:30 PM, Wednesday: 4:00 – 9:30 PM, Thursday: 4:00 – 9:30 PM, Friday: 4:00 – 10:30 PM, Saturday: 12:00 – 10:30 PM, Sunday: 12:00 – 9:30 PM	1200	2100	\N	\N	1600	2100	1600	2100	1600	2100	1600	2200	1200	2200	2024-08-09 15:26:39.602143-05	136
70	\N	Monday: Closed, Tuesday: 4:00 – 9:30 PM, Wednesday: 4:00 – 9:30 PM, Thursday: 4:00 – 9:30 PM, Friday: 4:00 – 10:30 PM, Saturday: 12:00 – 10:30 PM, Sunday: 12:00 – 9:30 PM	1200	2100	\N	\N	1600	2100	1600	2100	1600	2100	1600	2200	1200	2200	2024-08-09 15:26:39.919563-05	137
71	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 2:00 AM, Saturday: 11:00 AM – 2:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	200	1100	200	2024-08-09 15:26:40.152552-05	138
72	\N	Monday: 7:45 AM – 5:00 PM, Tuesday: 7:45 AM – 5:00 PM, Wednesday: 7:45 AM – 5:00 PM, Thursday: 7:45 AM – 5:00 PM, Friday: 7:45 AM – 5:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1700	700	1700	700	1700	700	1700	700	1700	\N	\N	2024-08-09 15:26:40.359511-05	139
73	\N	Monday: 4:00 – 10:00 PM, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 – 10:00 PM, Saturday: 10:00 AM – 2:00 PM, 4:00 – 10:00 PM, Sunday: 10:00 AM – 2:00 PM, 4:00 – 9:00 PM	1600	2100	1600	2200	1600	2200	1600	2200	1600	2200	1600	2200	1600	2200	2024-08-09 15:26:40.605159-05	140
74	\N	Monday: 6:30 AM – 1:00 AM, Tuesday: 6:30 AM – 1:00 AM, Wednesday: 6:30 AM – 1:00 AM, Thursday: 6:30 AM – 1:00 AM, Friday: 6:30 AM – 1:00 AM, Saturday: 6:30 AM – 1:00 AM, Sunday: 6:30 AM – 1:00 AM	600	100	600	100	600	100	600	100	600	100	600	100	600	100	2024-08-09 15:26:41.421816-05	142
75	\N	Monday: 6:30 AM – 1:00 AM, Tuesday: 6:30 AM – 1:00 AM, Wednesday: 6:30 AM – 1:00 AM, Thursday: 6:30 AM – 1:00 AM, Friday: 6:30 AM – 1:00 AM, Saturday: 6:30 AM – 1:00 AM, Sunday: 6:30 AM – 1:00 AM	600	100	600	100	600	100	600	100	600	100	600	100	600	100	2024-08-09 15:26:41.600418-05	143
76	\N	Monday: Closed, Tuesday: 12:00 – 5:00 PM, Wednesday: 12:00 – 5:00 PM, Thursday: 12:00 – 5:00 PM, Friday: 12:00 – 5:00 PM, Saturday: 12:00 – 5:00 PM, Sunday: Closed	\N	\N	\N	\N	1200	1700	1200	1700	1200	1700	1200	1700	1200	1700	2024-08-09 15:26:41.837417-05	144
77	\N	Monday: 6:30 AM – 1:00 AM, Tuesday: 6:30 AM – 1:00 AM, Wednesday: 6:30 AM – 1:00 AM, Thursday: 6:30 AM – 1:00 AM, Friday: 6:30 AM – 1:00 AM, Saturday: 6:30 AM – 1:00 AM, Sunday: 6:30 AM – 1:00 AM	600	100	600	100	600	100	600	100	600	100	600	100	600	100	2024-08-09 15:26:42.040763-05	145
78	\N	Monday: Closed, Tuesday: Closed, Wednesday: 2:00 – 8:00 PM, Thursday: 2:00 – 7:00 PM, Friday: 11:00 AM – 5:00 PM, Saturday: 11:00 AM – 5:00 PM, Sunday: 11:00 AM – 5:00 PM	1100	1700	\N	\N	\N	\N	1400	2000	1400	1900	1100	1700	1100	1700	2024-08-09 15:26:42.272521-05	146
79	\N	Monday: Closed, Tuesday: Closed, Wednesday: 2:00 – 8:00 PM, Thursday: 2:00 – 7:00 PM, Friday: 11:00 AM – 5:00 PM, Saturday: 11:00 AM – 5:00 PM, Sunday: 11:00 AM – 5:00 PM	1100	1700	\N	\N	\N	\N	1400	2000	1400	1900	1100	1700	1100	1700	2024-08-09 15:26:42.455383-05	147
80	\N	Monday: 9:30 AM – 5:30 PM, Tuesday: 9:30 AM – 5:30 PM, Wednesday: 9:30 AM – 5:30 PM, Thursday: 9:30 AM – 5:30 PM, Friday: 9:30 AM – 5:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	900	1700	900	1700	900	1700	900	1700	900	1700	\N	\N	2024-08-09 15:26:42.804898-05	149
81	\N	Monday: 9:30 AM – 5:30 PM, Tuesday: 9:30 AM – 5:30 PM, Wednesday: 9:30 AM – 5:30 PM, Thursday: 9:30 AM – 5:30 PM, Friday: 9:30 AM – 5:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	900	1700	900	1700	900	1700	900	1700	900	1700	\N	\N	2024-08-09 15:26:43.141415-05	150
82	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	\N	\N	\N	\N	\N	\N	800	1600	800	1600	800	1600	2024-08-09 15:26:44.074725-05	152
83	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	\N	\N	\N	\N	\N	\N	800	1600	800	1600	800	1600	2024-08-09 15:26:44.254977-05	153
84	\N	Monday: 7:00 AM – 3:00 PM, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	700	1500	700	1500	700	1500	700	1500	700	1500	800	1600	2024-08-09 15:26:44.74874-05	155
85	\N	Monday: 7:00 AM – 3:00 PM, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: 8:00 AM – 4:00 PM	800	1600	700	1500	700	1500	700	1500	700	1500	700	1500	800	1600	2024-08-09 15:26:44.943129-05	156
86	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:45.145141-05	157
87	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:45.490596-05	158
88	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:45.651733-05	159
89	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:45.79359-05	160
90	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:45.962233-05	161
91	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:46.139231-05	162
92	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:46.34542-05	163
93	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:46.525031-05	164
94	\N	Monday: 10:00 AM – 5:00 PM, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 5:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	2024-08-09 15:26:47.774817-05	167
95	\N	Monday: 5:45 AM – 9:00 PM, Tuesday: 5:45 AM – 9:00 PM, Wednesday: 5:45 AM – 9:00 PM, Thursday: 5:45 AM – 9:00 PM, Friday: 5:45 AM – 9:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	500	2100	500	2100	500	2100	500	2100	500	2100	1000	1600	2024-08-09 15:26:47.966993-05	168
96	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1800	700	1800	700	1800	700	1800	700	1800	\N	\N	2024-08-09 15:26:53.625695-05	181
97	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:26:55.742552-05	185
98	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: Closed, Friday: 11:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1100	1900	\N	\N	2024-08-09 15:26:56.011723-05	186
99	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: Closed, Friday: 11:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1100	1900	\N	\N	2024-08-09 15:26:56.193701-05	187
100	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: Closed, Friday: 11:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1100	1900	\N	\N	2024-08-09 15:26:56.37703-05	188
101	\N	Monday: 6:00 AM – 7:00 PM, Tuesday: 6:00 AM – 7:00 PM, Wednesday: 6:00 AM – 7:00 PM, Thursday: 6:00 AM – 7:00 PM, Friday: 6:00 AM – 7:00 PM, Saturday: 7:00 AM – 7:00 PM, Sunday: 7:00 AM – 7:00 PM	700	1900	600	1900	600	1900	600	1900	600	1900	600	1900	700	1900	2024-08-09 15:26:56.762714-05	189
102	\N	Monday: 7:00 AM – 11:00 PM, Tuesday: 7:00 AM – 11:00 PM, Wednesday: 7:00 AM – 11:00 PM, Thursday: 7:00 AM – 11:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 11:00 PM	700	2300	700	2300	700	2300	700	2300	700	2300	700	2300	700	2300	2024-08-09 15:26:57.153629-05	190
103	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:26:59.235809-05	194
104	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:26:59.412555-05	195
105	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:26:59.58934-05	196
106	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 6:00 AM – 10:00 PM	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:27:00.574656-05	198
107	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 6:00 AM – 10:00 PM	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:27:00.756871-05	199
108	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:27:00.927212-05	200
109	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:27:01.103143-05	201
110	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:27:01.28316-05	202
111	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:27:01.458332-05	203
112	\N	Monday: 5:30 AM – 7:00 PM, Tuesday: 5:30 AM – 7:00 PM, Wednesday: 5:30 AM – 7:00 PM, Thursday: 5:30 AM – 7:00 PM, Friday: 5:30 AM – 7:00 PM, Saturday: 6:30 AM – 3:00 PM, Sunday: 6:30 AM – 3:00 PM	600	1500	500	1900	500	1900	500	1900	500	1900	500	1900	600	1500	2024-08-09 15:27:03.533094-05	207
113	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:03.947193-05	208
114	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:04.149432-05	209
115	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:04.325621-05	210
116	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:05.35028-05	213
117	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:05.589501-05	214
118	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:05.777575-05	215
119	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:05.933779-05	216
120	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:27:06.162035-05	217
121	\N	Monday: 6:00 AM – 8:00 PM, Tuesday: 6:00 AM – 8:00 PM, Wednesday: 6:00 AM – 8:00 PM, Thursday: 6:00 AM – 8:00 PM, Friday: 6:00 AM – 8:00 PM, Saturday: 7:00 AM – 8:00 PM, Sunday: 7:30 AM – 4:00 PM	700	1600	600	2000	600	2000	600	2000	600	2000	600	2000	700	2000	2024-08-09 15:27:07.798051-05	221
122	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: 8:00 AM – 7:00 PM, Sunday: 8:00 AM – 7:00 PM	800	1900	700	1900	700	1900	700	1900	700	1900	700	1900	800	1900	2024-08-09 15:27:10.036947-05	225
123	\N	Monday: 10:00 AM – 10:00 PM, Tuesday: 10:00 AM – 10:00 PM, Wednesday: 10:00 AM – 10:00 PM, Thursday: 10:00 AM – 10:00 PM, Friday: 10:00 AM – 10:00 PM, Saturday: 10:00 AM – 10:00 PM, Sunday: 10:00 AM – 10:00 PM	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	2024-08-09 15:27:10.291544-05	226
124	\N	Monday: 10:00 AM – 10:00 PM, Tuesday: 10:00 AM – 10:00 PM, Wednesday: 10:00 AM – 10:00 PM, Thursday: 10:00 AM – 10:00 PM, Friday: 10:00 AM – 10:00 PM, Saturday: 10:00 AM – 10:00 PM, Sunday: 10:00 AM – 10:00 PM	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	2024-08-09 15:27:11.03271-05	228
125	\N	Monday: 5:00 – 10:00 PM, Tuesday: 5:00 – 10:00 PM, Wednesday: 5:00 – 10:00 PM, Thursday: 5:00 – 10:00 PM, Friday: 4:00 PM – 12:00 AM, Saturday: 12:00 PM – 12:00 AM, Sunday: 12:00 – 10:00 PM	1200	2200	1700	2200	1700	2200	1700	2200	1700	2200	1600	0	1200	0	2024-08-09 15:27:12.534964-05	231
126	\N	Monday: 12:00 – 6:00 PM, Tuesday: 12:00 – 6:00 PM, Wednesday: 12:00 – 6:00 PM, Thursday: 12:00 – 6:00 PM, Friday: 12:00 – 6:00 PM, Saturday: 12:00 – 6:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	1200	1800	1200	1800	1200	1800	1200	1800	1200	1800	1200	1800	2024-08-09 15:27:12.960425-05	232
127	\N	Monday: 8:30 AM – 3:00 PM, Tuesday: 8:30 AM – 3:00 PM, Wednesday: 8:30 AM – 3:00 PM, Thursday: 8:30 AM – 3:00 PM, Friday: 8:30 AM – 3:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1500	800	1500	800	1500	800	1500	800	1500	\N	\N	2024-08-09 15:27:15.104356-05	236
128	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: 7:00 AM – 6:00 PM, Sunday: 7:00 AM – 6:00 PM	700	1800	700	1800	700	1800	700	1800	700	1800	700	1800	700	1800	2024-08-09 15:27:16.154202-05	240
129	\N	Monday: Closed, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: 9:00 AM – 2:00 PM	900	1400	\N	\N	800	2000	800	2000	800	2000	800	2000	900	2000	2024-08-09 15:27:16.371348-05	241
130	\N	Monday: 9:00 AM – 3:00 PM, Tuesday: 9:00 AM – 3:00 PM, Wednesday: 9:00 AM – 3:00 PM, Thursday: 9:00 AM – 3:00 PM, Friday: 9:00 AM – 3:00 PM, Saturday: 9:00 AM – 3:00 PM, Sunday: 9:00 AM – 3:00 PM	900	1500	900	1500	900	1500	900	1500	900	1500	900	1500	900	1500	2024-08-09 15:27:16.599113-05	242
131	\N	Monday: 9:00 AM – 3:00 PM, Tuesday: 9:00 AM – 3:00 PM, Wednesday: 9:00 AM – 3:00 PM, Thursday: 9:00 AM – 3:00 PM, Friday: 9:00 AM – 3:00 PM, Saturday: 9:00 AM – 3:00 PM, Sunday: 9:00 AM – 3:00 PM	900	1500	900	1500	900	1500	900	1500	900	1500	900	1500	900	1500	2024-08-09 15:27:16.864774-05	243
132	\N	Monday: 9:00 AM – 3:00 PM, Tuesday: 9:00 AM – 3:00 PM, Wednesday: 9:00 AM – 3:00 PM, Thursday: 9:00 AM – 3:00 PM, Friday: 9:00 AM – 3:00 PM, Saturday: 9:00 AM – 3:00 PM, Sunday: 9:00 AM – 3:00 PM	900	1500	900	1500	900	1500	900	1500	900	1500	900	1500	900	1500	2024-08-09 15:27:17.025081-05	244
133	\N	Monday: 5:00 – 10:00 PM, Tuesday: 5:00 – 10:00 PM, Wednesday: 5:00 – 10:00 PM, Thursday: 5:00 – 10:00 PM, Friday: 4:00 PM – 12:00 AM, Saturday: 12:00 PM – 12:00 AM, Sunday: 12:00 – 10:00 PM	1200	2200	1700	2200	1700	2200	1700	2200	1700	2200	1600	0	1200	0	2024-08-09 15:27:17.360528-05	245
134	\N	Monday: 8:00 AM – 3:00 PM, Tuesday: 8:00 AM – 3:00 PM, Wednesday: 8:00 AM – 3:00 PM, Thursday: 8:00 AM – 3:00 PM, Friday: 8:00 AM – 3:00 PM, Saturday: 8:00 AM – 3:00 PM, Sunday: 8:00 AM – 3:00 PM	800	1500	800	1500	800	1500	800	1500	800	1500	800	1500	800	1500	2024-08-09 15:27:18.53008-05	249
135	\N	Monday: 8:00 AM – 3:00 PM, Tuesday: 8:00 AM – 3:00 PM, Wednesday: 8:00 AM – 3:00 PM, Thursday: 8:00 AM – 3:00 PM, Friday: 8:00 AM – 3:00 PM, Saturday: 8:00 AM – 3:00 PM, Sunday: 8:00 AM – 3:00 PM	800	1500	800	1500	800	1500	800	1500	800	1500	800	1500	800	1500	2024-08-09 15:27:18.718016-05	250
136	\N	Monday: 12:00 – 7:00 PM, Tuesday: Closed, Wednesday: 12:00 – 7:00 PM, Thursday: 12:00 – 7:00 PM, Friday: 12:00 – 7:00 PM, Saturday: 12:00 – 8:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	1200	1900	\N	\N	1200	1900	1200	1900	1200	1900	1200	2000	2024-08-09 15:27:19.048778-05	252
137	\N	Monday: 9:00 AM – 11:00 PM, Tuesday: 9:00 AM – 11:00 PM, Wednesday: 9:00 AM – 11:00 PM, Thursday: 9:00 AM – 11:00 PM, Friday: 9:00 AM – 12:00 AM, Saturday: 9:00 AM – 12:00 AM, Sunday: 9:00 AM – 11:00 PM	900	2300	900	2300	900	2300	900	2300	900	2300	900	0	900	0	2024-08-09 15:27:20.135796-05	254
138	\N	Monday: 9:00 AM – 9:00 PM, Tuesday: 9:00 AM – 9:00 PM, Wednesday: 9:00 AM – 9:00 PM, Thursday: 9:00 AM – 9:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	900	2100	900	2100	900	2100	900	2100	800	2200	800	2200	2024-08-09 15:27:20.518813-05	255
139	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 8:00 AM – 5:00 PM, Sunday: Closed	\N	\N	700	1700	700	1700	700	1700	700	1700	700	1700	800	1700	2024-08-09 15:27:21.057498-05	257
140	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1800	700	1800	700	1800	700	1800	700	1800	\N	\N	2024-08-09 15:27:21.279833-05	258
141	\N	Monday: Closed, Tuesday: Closed, Wednesday: 7:00 – 10:30 PM, Thursday: 8:00 – 10:00 PM, Friday: 7:00 – 11:30 PM, Saturday: 6:00 – 11:30 PM, Sunday: Closed	\N	\N	\N	\N	\N	\N	1900	2200	2000	2200	1900	2300	1800	2300	2024-08-09 15:27:22.278378-05	260
142	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:27:22.535052-05	261
143	\N	Monday: 3:00 – 10:00 PM, Tuesday: 3:00 – 10:00 PM, Wednesday: 3:00 – 10:00 PM, Thursday: 3:00 – 10:00 PM, Friday: 2:00 PM – 12:00 AM, Saturday: 12:00 PM – 12:00 AM, Sunday: 12:00 – 10:00 PM	1200	2200	1500	2200	1500	2200	1500	2200	1500	2200	1400	0	1200	0	2024-08-09 15:27:23.344344-05	263
144	\N	Monday: Closed, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 4:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: Closed	\N	\N	\N	\N	1000	1600	1000	1600	1000	1900	1000	1600	1000	1600	2024-08-09 15:27:24.377794-05	267
145	\N	Monday: 12:00 – 8:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	1200	2000	900	1700	1200	2000	900	1700	900	1700	900	1700	2024-08-09 15:27:26.424086-05	271
146	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 4:00 – 8:00 PM, Friday: 4:00 – 8:00 PM, Saturday: 4:00 – 8:00 PM, Sunday: 4:00 – 8:00 PM	1600	2000	\N	\N	\N	\N	\N	\N	1600	2000	1600	2000	1600	2000	2024-08-09 15:27:26.921064-05	272
147	\N	Monday: 12:00 – 8:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1200	2000	1200	2000	1200	2000	900	1700	900	1700	900	1700	2024-08-09 15:27:27.155484-05	273
148	\N	Monday: 2:00 – 10:00 PM, Tuesday: 2:00 – 10:00 PM, Wednesday: 2:00 – 10:00 PM, Thursday: 2:00 – 10:00 PM, Friday: 12:00 – 11:00 PM, Saturday: 12:00 – 11:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	1400	2200	1400	2200	1400	2200	1400	2200	1200	2300	1200	2300	2024-08-09 15:27:27.641421-05	276
149	\N	Monday: 11:00 AM – 6:30 PM, Tuesday: 11:00 AM – 6:30 PM, Wednesday: 11:00 AM – 6:30 PM, Thursday: 11:00 AM – 6:30 PM, Friday: 11:00 AM – 6:30 PM, Saturday: 11:00 AM – 6:30 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1100	1800	1100	1800	1100	1800	1100	1800	1100	1800	1100	1800	2024-08-09 15:27:27.962551-05	277
150	\N	Monday: 11:00 AM – 6:30 PM, Tuesday: 11:00 AM – 6:30 PM, Wednesday: 11:00 AM – 6:30 PM, Thursday: 11:00 AM – 6:30 PM, Friday: 11:00 AM – 6:30 PM, Saturday: 11:00 AM – 6:30 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1100	1800	1100	1800	1100	1800	1100	1800	1100	1800	1100	1800	2024-08-09 15:27:28.144567-05	278
151	\N	Monday: 11:00 AM – 6:30 PM, Tuesday: 11:00 AM – 6:30 PM, Wednesday: 11:00 AM – 6:30 PM, Thursday: 11:00 AM – 6:30 PM, Friday: 11:00 AM – 6:30 PM, Saturday: 11:00 AM – 6:30 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1100	1800	1100	1800	1100	1800	1100	1800	1100	1800	1100	1800	2024-08-09 15:27:28.330054-05	279
152	\N	Monday: 11:00 AM – 4:00 PM, Tuesday: 11:00 AM – 4:00 PM, Wednesday: 11:00 AM – 6:00 PM, Thursday: 11:00 AM – 6:00 PM, Friday: 11:00 AM – 7:00 PM, Saturday: 11:00 AM – 4:00 PM, Sunday: 11:00 AM – 4:00 PM	1100	1600	1100	1600	1100	1600	1100	1800	1100	1800	1100	1900	1100	1600	2024-08-09 15:27:28.537736-05	280
153	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 6:00 AM – 10:00 PM	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:27:28.76348-05	281
154	\N	Monday: 11:00 AM – 7:00 PM, Tuesday: 11:00 AM – 7:00 PM, Wednesday: 11:00 AM – 7:00 PM, Thursday: 12:00 – 7:00 PM, Friday: 11:00 AM – 7:00 PM, Saturday: 11:00 AM – 6:00 PM, Sunday: 11:00 AM – 6:00 PM	1100	1800	1100	1900	1100	1900	1100	1900	1200	1900	1100	1900	1100	1800	2024-08-09 15:27:29.768632-05	283
155	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:27:30.61623-05	285
156	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:27:30.783627-05	286
157	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:27:30.95776-05	287
158	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:27:31.186746-05	288
159	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:27:31.363694-05	289
160	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:27:31.69456-05	290
161	\N	Monday: 7:30 AM – 6:00 PM, Tuesday: 7:30 AM – 6:00 PM, Wednesday: 7:30 AM – 6:00 PM, Thursday: 7:30 AM – 6:00 PM, Friday: 7:30 AM – 6:00 PM, Saturday: 7:30 AM – 6:00 PM, Sunday: 7:30 AM – 6:00 PM	700	1800	700	1800	700	1800	700	1800	700	1800	700	1800	700	1800	2024-08-09 15:27:31.921277-05	291
162	\N	Monday: Closed, Tuesday: 3:00 – 10:00 PM, Wednesday: 3:00 – 10:00 PM, Thursday: 3:00 – 10:00 PM, Friday: 3:00 PM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 10:00 PM	1100	2200	\N	\N	1500	2200	1500	2200	1500	2200	1500	0	1100	0	2024-08-09 15:27:32.099496-05	292
163	\N	Monday: Closed, Tuesday: Closed, Wednesday: 3:00 – 10:00 PM, Thursday: 3:00 – 10:00 PM, Friday: 3:00 – 11:00 PM, Saturday: 10:00 AM – 11:00 PM, Sunday: 10:00 AM – 10:00 PM	1000	2200	\N	\N	\N	\N	1500	2200	1500	2200	1500	2300	1000	2300	2024-08-26 04:38:39.096042-05	293
164	\N	Monday: 11:00 AM – 1:00 AM, Tuesday: 11:00 AM – 1:00 AM, Wednesday: 11:00 AM – 1:00 AM, Thursday: 11:00 AM – 1:00 AM, Friday: 11:00 AM – 1:00 AM, Saturday: 10:00 AM – 1:00 AM, Sunday: 10:00 AM – 1:00 AM	1000	100	1100	100	1100	100	1100	100	1100	100	1100	100	1000	100	2024-08-09 15:27:32.59247-05	294
165	\N	Monday: 12:00 – 8:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1200	2000	1200	2000	1200	2000	900	1700	900	1700	900	1700	2024-08-09 15:27:33.3646-05	296
166	\N	Monday: 12:00 – 8:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1200	2000	1200	2000	1200	2000	900	1700	900	1700	900	1700	2024-08-09 15:27:33.539622-05	297
167	\N	Monday: 12:00 – 8:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1200	2000	1200	2000	900	1700	1200	2000	900	1700	900	1700	2024-08-09 15:27:33.849947-05	299
168	\N	Monday: 8:00 AM – 6:00 PM, Tuesday: 8:00 AM – 6:00 PM, Wednesday: 8:00 AM – 6:00 PM, Thursday: 8:00 AM – 6:00 PM, Friday: 8:00 AM – 6:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1800	800	1800	800	1800	800	1800	800	1800	\N	\N	2024-08-09 15:28:18.072722-05	302
169	\N	Monday: 6:00 AM – 12:00 AM, Tuesday: 6:00 AM – 12:00 AM, Wednesday: 6:00 AM – 12:00 AM, Thursday: 6:00 AM – 12:00 AM, Friday: 6:00 AM – 12:00 AM, Saturday: 6:00 AM – 12:00 AM, Sunday: 6:00 AM – 12:00 AM	600	0	600	0	600	0	600	0	600	0	600	0	600	0	2024-08-09 15:28:19.365285-05	306
170	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: 8:00 AM – 3:00 PM, Sunday: Closed	\N	\N	700	1800	700	1800	700	1800	700	1800	700	1800	800	1500	2024-08-09 15:28:19.637292-05	307
171	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: 8:00 AM – 3:00 PM, Sunday: Closed	\N	\N	700	1800	700	1800	700	1800	700	1800	700	1800	800	1500	2024-08-09 15:28:19.98211-05	308
172	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:28:20.973737-05	310
173	\N	Monday: 6:30 AM – 6:00 PM, Tuesday: 6:30 AM – 6:00 PM, Wednesday: 6:30 AM – 6:00 PM, Thursday: 6:30 AM – 6:00 PM, Friday: 6:30 AM – 6:00 PM, Saturday: 6:30 AM – 6:00 PM, Sunday: 6:30 AM – 6:00 PM	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	2024-08-09 15:28:21.205541-05	311
174	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:28:24.624284-05	318
175	\N	Monday: 7:00 AM – 9:00 PM, Tuesday: 7:00 AM – 9:00 PM, Wednesday: 7:00 AM – 9:00 PM, Thursday: 7:00 AM – 9:00 PM, Friday: 7:00 AM – 9:00 PM, Saturday: 7:00 AM – 9:00 PM, Sunday: 7:00 AM – 9:00 PM	700	2100	700	2100	700	2100	700	2100	700	2100	700	2100	700	2100	2024-08-09 15:28:24.855546-05	319
176	\N	Monday: 6:00 AM – 2:00 PM, Tuesday: 6:00 AM – 2:00 PM, Wednesday: 6:00 AM – 2:00 PM, Thursday: 6:00 AM – 2:00 PM, Friday: 6:00 AM – 2:00 PM, Saturday: 7:30 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	600	1400	600	1400	600	1400	600	1400	600	1400	700	1400	2024-08-09 15:28:25.831979-05	321
177	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:28:26.035017-05	322
178	\N	Monday: Closed, Tuesday: Closed, Wednesday: 9:00 AM – 2:30 PM, Thursday: 9:00 AM – 2:30 PM, Friday: 9:00 AM – 2:30 PM, Saturday: 9:00 AM – 2:30 PM, Sunday: 9:00 AM – 2:30 PM	900	1400	\N	\N	\N	\N	900	1400	900	1400	900	1400	900	1400	2024-08-09 15:28:26.304325-05	323
244	\N	Monday: 8:13 AM – 4:00 PM, Tuesday: 8:13 AM – 4:00 PM, Wednesday: 8:13 AM – 4:00 PM, Thursday: 8:13 AM – 4:00 PM, Friday: 8:13 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:28:57.203837-05	432
179	\N	Monday: 9:00 AM – 9:00 PM, Tuesday: 9:00 AM – 9:00 PM, Wednesday: 9:00 AM – 9:00 PM, Thursday: 9:00 AM – 9:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	900	2100	900	2100	900	2100	900	2100	800	2200	800	2200	2024-08-09 15:28:26.484049-05	324
180	\N	Monday: Closed, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 12:00 – 8:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	\N	\N	1200	2000	1200	2000	1200	2000	1200	2000	1000	1800	2024-08-09 15:28:26.706527-05	325
181	\N	Monday: 6:30 AM – 6:00 PM, Tuesday: 6:30 AM – 6:00 PM, Wednesday: 6:30 AM – 6:00 PM, Thursday: 6:30 AM – 6:00 PM, Friday: 6:30 AM – 6:00 PM, Saturday: 6:30 AM – 6:00 PM, Sunday: 6:30 AM – 6:00 PM	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	2024-08-09 15:28:26.978683-05	326
182	\N	Monday: 6:30 AM – 6:00 PM, Tuesday: 6:30 AM – 6:00 PM, Wednesday: 6:30 AM – 6:00 PM, Thursday: 6:30 AM – 6:00 PM, Friday: 6:30 AM – 6:00 PM, Saturday: 6:30 AM – 6:00 PM, Sunday: 6:30 AM – 6:00 PM	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	2024-08-09 15:28:27.173588-05	327
183	\N	Monday: 11:00 AM – 11:00 PM, Tuesday: 11:00 AM – 11:00 PM, Wednesday: 11:00 AM – 11:00 PM, Thursday: 11:00 AM – 11:00 PM, Friday: 11:00 AM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 11:00 PM	1100	2300	1100	2300	1100	2300	1100	2300	1100	2300	1100	0	1100	0	2024-08-09 15:28:28.167956-05	331
184	\N	Monday: 7:00 AM – 3:00 PM, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	700	1500	700	1500	700	1500	700	1500	700	1500	800	1400	2024-08-09 15:28:28.511705-05	333
185	\N	Monday: 7:00 AM – 3:00 PM, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	700	1500	700	1500	700	1500	700	1500	700	1500	800	1400	2024-08-09 15:28:28.694897-05	334
186	\N	Monday: 7:00 AM – 3:00 PM, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	700	1500	700	1500	700	1500	700	1500	700	1500	800	1400	2024-08-09 15:28:28.874016-05	335
187	\N	Monday: 6:30 AM – 8:30 PM, Tuesday: 6:30 AM – 8:30 PM, Wednesday: 6:30 AM – 8:30 PM, Thursday: 6:30 AM – 8:30 PM, Friday: 6:30 AM – 8:30 PM, Saturday: 6:30 AM – 8:30 PM, Sunday: 6:30 AM – 8:30 PM	600	2000	600	2000	600	2000	600	2000	600	2000	600	2000	600	2000	2024-08-09 15:28:29.189201-05	337
188	\N	Monday: 8:30 AM – 6:00 PM, Tuesday: 8:30 AM – 6:00 PM, Wednesday: 8:30 AM – 6:00 PM, Thursday: 8:30 AM – 6:00 PM, Friday: 8:30 AM – 6:00 PM, Saturday: 9:00 AM – 6:00 PM, Sunday: Closed	\N	\N	800	1800	800	1800	800	1800	800	1800	800	1800	900	1800	2024-08-09 15:28:29.397145-05	338
189	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	2024-08-09 15:28:29.681741-05	339
190	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: Closed	\N	\N	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:28:30.023543-05	341
191	\N	Monday: 12:00 – 9:00 PM, Tuesday: 12:00 – 9:00 PM, Wednesday: 12:00 – 9:00 PM, Thursday: 12:00 – 9:00 PM, Friday: 12:00 – 10:00 PM, Saturday: 12:00 – 10:00 PM, Sunday: 12:00 – 9:00 PM	1200	2100	1200	2100	1200	2100	1200	2100	1200	2100	1200	2200	1200	2200	2024-08-09 15:28:30.500886-05	344
192	\N	Monday: 11:00 AM – 8:00 PM, Tuesday: 11:00 AM – 8:00 PM, Wednesday: 11:00 AM – 8:00 PM, Thursday: 11:00 AM – 8:00 PM, Friday: 11:00 AM – 8:00 PM, Saturday: 11:00 AM – 8:00 PM, Sunday: 11:00 AM – 8:00 PM	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	2024-08-09 15:28:31.226697-05	347
193	\N	Monday: 6:00 AM – 1:00 PM, Tuesday: 6:00 AM – 1:00 PM, Wednesday: 6:00 AM – 1:00 PM, Thursday: 6:00 AM – 1:00 PM, Friday: 6:00 AM – 1:00 PM, Saturday: 6:00 AM – 1:00 PM, Sunday: 6:00 AM – 1:00 PM	600	1300	600	1300	600	1300	600	1300	600	1300	600	1300	600	1300	2024-08-09 15:28:31.643205-05	349
194	\N	Monday: 4:00 – 9:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1600	2100	1100	2200	1100	2200	1100	2200	1100	2200	900	2200	2024-08-09 15:28:32.125268-05	350
195	\N	Monday: 4:00 – 9:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1600	2100	1100	2200	1100	2200	1100	2200	1100	2200	900	2200	2024-08-09 15:28:32.30183-05	351
196	\N	Monday: 4:00 – 9:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1600	2100	1100	2200	1100	2200	1100	2200	1100	2200	900	2200	2024-08-09 15:28:32.483766-05	352
197	\N	Monday: 4:00 – 9:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1600	2100	1100	2200	1100	2200	1100	2200	1100	2200	900	2200	2024-08-09 15:28:32.665427-05	353
198	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	900	1700	900	1700	1200	2000	1200	2000	900	1700	900	1700	2024-08-09 15:28:33.008814-05	355
199	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	2024-08-09 15:28:33.934822-05	357
200	\N	Monday: 4:00 – 9:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1600	2100	1100	2200	1100	2200	1100	2200	1100	2200	900	2200	2024-08-09 15:28:34.220215-05	359
201	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	\N	\N	2024-08-09 15:28:34.603124-05	360
202	\N	Monday: 8:00 AM – 6:00 PM, Tuesday: 8:00 AM – 6:00 PM, Wednesday: 8:00 AM – 6:00 PM, Thursday: 8:00 AM – 6:00 PM, Friday: 8:00 AM – 6:00 PM, Saturday: 12:00 – 6:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	800	1800	800	1800	800	1800	800	1800	800	1800	1200	1800	2024-08-09 15:28:35.224408-05	363
203	\N	Monday: 8:00 AM – 5:00 PM, Tuesday: 8:00 AM – 5:00 PM, Wednesday: 8:00 AM – 5:00 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 8:00 AM – 5:00 PM, Saturday: 8:00 AM – 5:00 PM, Sunday: 8:00 AM – 5:00 PM	800	1700	800	1700	800	1700	800	1700	800	1700	800	1700	800	1700	2024-08-09 15:28:36.475624-05	367
204	\N	Monday: Closed, Tuesday: 3:00 – 10:00 PM, Wednesday: 3:00 – 10:00 PM, Thursday: 3:00 – 10:00 PM, Friday: 3:00 – 11:00 PM, Saturday: 11:00 AM – 11:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	\N	\N	1500	2200	1500	2200	1500	2200	1500	2300	1100	2300	2024-08-09 15:28:37.337408-05	369
205	\N	Monday: Closed, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 7:00 AM – 3:00 PM, Sunday: 7:00 AM – 2:00 PM	700	1400	\N	\N	700	1500	700	1500	700	1500	700	1500	700	1500	2024-08-09 15:28:38.20949-05	371
206	\N	Monday: 6:00 AM – 8:00 PM, Tuesday: 6:00 AM – 8:00 PM, Wednesday: 6:00 AM – 8:00 PM, Thursday: 6:00 AM – 8:00 PM, Friday: 6:00 AM – 8:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	600	2000	600	2000	600	2000	600	2000	600	2000	\N	\N	2024-08-09 15:28:38.565834-05	373
207	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 7:00 – 11:00 AM, Friday: 7:00 – 11:00 AM, Saturday: Closed, Sunday: 8:00 AM – 12:00 PM	800	1200	\N	\N	\N	\N	\N	\N	700	1100	700	1100	\N	\N	2024-08-09 15:28:39.598684-05	377
208	\N	Monday: Closed, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	\N	\N	1000	1900	1000	1900	1000	1900	1000	1900	1000	1700	2024-08-09 15:28:39.844658-05	378
209	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 9:00 AM – 12:00 PM, Friday: 9:00 AM – 12:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	\N	\N	\N	\N	\N	\N	900	1200	900	1200	\N	\N	2024-08-09 15:28:40.065849-05	379
210	\N	Monday: 6:00 AM – 1:00 PM, Tuesday: 6:00 AM – 1:00 PM, Wednesday: 6:00 AM – 1:00 PM, Thursday: 6:00 AM – 1:00 PM, Friday: 6:00 AM – 1:00 PM, Saturday: 6:00 AM – 1:00 PM, Sunday: 6:00 AM – 1:00 PM	600	1300	600	1300	600	1300	600	1300	600	1300	600	1300	600	1300	2024-08-09 15:28:40.88174-05	381
211	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	900	1700	1200	2000	900	1700	1200	2000	900	1700	900	1700	2024-08-09 15:28:41.09083-05	382
212	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:28:41.525098-05	383
213	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2300	700	2300	2024-08-09 15:28:41.728498-05	384
214	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2300	700	2300	2024-08-09 15:28:41.911985-05	385
215	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2300	700	2300	2024-08-09 15:28:42.114728-05	386
216	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2300	700	2300	2024-08-09 15:28:42.290218-05	387
217	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2300	700	2300	2024-08-09 15:28:42.442591-05	388
218	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 3:00 – 8:00 PM, Friday: 9:00 AM – 2:00 PM, 3:00 – 8:00 PM, Saturday: 9:00 AM – 2:00 PM, 3:00 – 8:00 PM, Sunday: 9:00 AM – 2:00 PM	900	1400	\N	\N	\N	\N	\N	\N	1500	2000	1500	2000	1500	2000	2024-08-09 15:28:42.769478-05	390
219	\N	Monday: 4:00 – 10:00 PM, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 – 11:00 PM, Saturday: 4:00 – 11:00 PM, Sunday: 4:00 – 10:00 PM	1600	2200	1600	2200	1600	2200	1600	2200	1600	2200	1600	2300	1600	2300	2024-08-09 15:28:43.078424-05	392
220	\N	Monday: 4:00 – 10:00 PM, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 – 11:00 PM, Saturday: 4:00 – 11:00 PM, Sunday: 4:00 – 10:00 PM	1600	2200	1600	2200	1600	2200	1600	2200	1600	2200	1600	2300	1600	2300	2024-08-09 15:28:43.257148-05	393
221	\N	Monday: 8:00 AM – 5:00 PM, Tuesday: 8:00 AM – 5:00 PM, Wednesday: 8:00 AM – 5:00 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 8:00 AM – 5:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1700	800	1700	800	1700	800	1700	800	1700	\N	\N	2024-08-09 15:28:43.488261-05	394
245	\N	Monday: 4:00 – 9:00 PM, Tuesday: 4:00 – 9:00 PM, Wednesday: 4:00 – 9:00 PM, Thursday: 4:00 – 9:00 PM, Friday: 12:00 – 10:00 PM, Saturday: 12:00 – 10:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	1600	2100	1600	2100	1600	2100	1600	2100	1200	2200	1200	2200	2024-08-09 15:28:57.468455-05	433
222	\N	Monday: 5:00 AM – 9:00 PM, Tuesday: 5:00 AM – 9:00 PM, Wednesday: 5:00 AM – 9:00 PM, Thursday: 5:00 AM – 9:00 PM, Friday: 5:00 AM – 9:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	500	2100	500	2100	500	2100	500	2100	500	2100	700	1700	2024-08-09 15:28:43.709213-05	395
223	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: Closed, Sunday: 9:00 AM – 12:00 PM	900	1200	900	1700	900	1700	900	1700	900	1700	900	1700	\N	\N	2024-08-09 15:28:44.032775-05	397
224	\N	Monday: Closed, Tuesday: 4:30 – 9:00 PM, Wednesday: 4:30 – 9:00 PM, Thursday: 4:30 – 9:00 PM, Friday: 4:30 – 9:00 PM, Saturday: 10:00 AM – 9:00 PM, Sunday: 10:00 AM – 2:00 PM	1000	1400	\N	\N	1600	2100	1600	2100	1600	2100	1600	2100	1000	2100	2024-08-09 15:28:45.155699-05	399
225	\N	Monday: Closed, Tuesday: 4:30 – 9:00 PM, Wednesday: 4:30 – 9:00 PM, Thursday: 4:30 – 9:00 PM, Friday: 4:30 – 9:00 PM, Saturday: 10:00 AM – 9:00 PM, Sunday: 10:00 AM – 2:00 PM	1000	1400	\N	\N	1600	2100	1600	2100	1600	2100	1600	2100	1000	2100	2024-08-09 15:28:45.33968-05	400
226	\N	Monday: Closed, Tuesday: 4:30 – 9:00 PM, Wednesday: 4:30 – 9:00 PM, Thursday: 4:30 – 9:00 PM, Friday: 4:30 – 9:00 PM, Saturday: 10:00 AM – 9:00 PM, Sunday: 10:00 AM – 2:00 PM	1000	1400	\N	\N	1600	2100	1600	2100	1600	2100	1600	2100	1000	2100	2024-08-09 15:28:45.485534-05	401
227	\N	Monday: 11:30 AM – 9:30 PM, Tuesday: 11:30 AM – 9:30 PM, Wednesday: 11:30 AM – 9:30 PM, Thursday: 11:30 AM – 9:30 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 9:30 PM	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2200	1100	2200	2024-08-09 15:28:45.718249-05	402
228	\N	Monday: 8:00 AM – 1:00 PM, Tuesday: Closed, Wednesday: 8:00 AM – 1:00 PM, Thursday: 8:00 AM – 1:00 PM, Friday: 8:00 AM – 1:00 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	800	1300	\N	\N	800	1300	800	1300	800	1300	800	1400	2024-08-09 15:28:46.638335-05	405
229	\N	Monday: 1:00 – 10:00 PM, Tuesday: 1:00 – 10:00 PM, Wednesday: 1:00 – 10:00 PM, Thursday: 1:00 – 10:00 PM, Friday: 1:00 – 10:00 PM, Saturday: 1:00 – 10:00 PM, Sunday: 1:00 – 10:00 PM	1300	2200	1300	2200	1300	2200	1300	2200	1300	2200	1300	2200	1300	2200	2024-08-09 15:28:46.848079-05	406
230	\N	Monday: 6:15 AM – 8:00 PM, Tuesday: 6:15 AM – 8:00 PM, Wednesday: 6:15 AM – 8:00 PM, Thursday: 6:15 AM – 8:00 PM, Friday: 6:15 AM – 8:00 PM, Saturday: 6:45 AM – 8:00 PM, Sunday: 6:45 AM – 8:00 PM	600	2000	600	2000	600	2000	600	2000	600	2000	600	2000	600	2000	2024-08-09 15:28:47.846632-05	408
231	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:28:48.082279-05	409
232	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 3:00 PM, Sunday: Closed	\N	\N	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1500	2024-08-09 15:28:48.306063-05	410
233	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:28:48.542314-05	411
234	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:28:48.873045-05	412
235	\N	Monday: 7:00 AM – 12:00 AM, Tuesday: 7:00 AM – 12:00 AM, Wednesday: 7:00 AM – 12:00 AM, Thursday: 7:00 AM – 12:00 AM, Friday: 7:00 AM – 12:00 AM, Saturday: 7:00 AM – 12:00 AM, Sunday: 7:00 AM – 12:00 AM	700	0	700	0	700	0	700	0	700	0	700	0	700	0	2024-08-09 15:28:49.24498-05	413
236	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:28:50.286449-05	415
237	\N	Monday: 8:00 AM – 4:00 PM, Tuesday: 8:00 AM – 4:00 PM, Wednesday: 8:00 AM – 4:00 PM, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:28:50.504638-05	416
238	\N	Monday: 10:30 AM – 1:00 AM, Tuesday: 10:30 AM – 1:00 AM, Wednesday: 10:30 AM – 1:00 AM, Thursday: 10:30 AM – 1:00 AM, Friday: 10:30 AM – 3:00 AM, Saturday: 10:30 AM – 3:00 AM, Sunday: 10:30 AM – 1:00 AM	1000	100	1000	100	1000	100	1000	100	1000	100	1000	300	1000	300	2024-08-09 15:28:53.541242-05	421
239	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	900	1700	1200	2000	900	1700	1200	2000	900	1700	900	1700	2024-08-09 15:28:53.773228-05	422
240	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:28:54.012308-05	423
241	\N	Monday: 8:00 AM – 7:00 PM, Tuesday: 8:00 AM – 7:00 PM, Wednesday: 8:00 AM – 7:00 PM, Thursday: 8:00 AM – 7:00 PM, Friday: 8:00 AM – 7:00 PM, Saturday: 8:00 AM – 7:00 PM, Sunday: 8:00 AM – 7:00 PM	800	1900	800	1900	800	1900	800	1900	800	1900	800	1900	800	1900	2024-08-09 15:28:54.466668-05	426
242	\N	Monday: 12:00 – 8:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	1200	2000	900	1700	900	1700	1200	2000	900	1700	900	1700	2024-08-09 15:28:55.264461-05	428
243	\N	Monday: 10:00 AM – 9:00 PM, Tuesday: 10:00 AM – 9:00 PM, Wednesday: 10:00 AM – 9:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 9:00 PM, Saturday: 10:00 AM – 9:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	2024-08-09 15:28:56.976264-05	431
246	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:28:57.716671-05	434
247	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 6:00 AM – 10:00 PM	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:28:57.950158-05	435
248	\N	Monday: 5:00 AM – 9:00 PM, Tuesday: 5:00 AM – 9:00 PM, Wednesday: 5:00 AM – 9:00 PM, Thursday: 5:00 AM – 9:00 PM, Friday: 5:00 AM – 9:00 PM, Saturday: 5:00 AM – 9:00 PM, Sunday: 5:00 AM – 9:00 PM	500	2100	500	2100	500	2100	500	2100	500	2100	500	2100	500	2100	2024-08-09 15:28:58.235503-05	436
249	\N	Monday: 5:00 AM – 10:00 PM, Tuesday: 5:00 AM – 10:00 PM, Wednesday: 5:00 AM – 10:00 PM, Thursday: 5:00 AM – 10:00 PM, Friday: 5:00 AM – 10:00 PM, Saturday: 5:00 AM – 10:00 PM, Sunday: 5:00 AM – 10:00 PM	500	2200	500	2200	500	2200	500	2200	500	2200	500	2200	500	2200	2024-08-09 15:28:58.456384-05	437
250	\N	Monday: 8:30 AM – 9:00 PM, Tuesday: 8:30 AM – 9:00 PM, Wednesday: 8:30 AM – 9:00 PM, Thursday: 8:30 AM – 9:00 PM, Friday: 8:30 AM – 9:00 PM, Saturday: 8:30 AM – 4:00 PM, Sunday: 12:00 – 4:00 PM	1200	1600	800	2100	800	2100	800	2100	800	2100	800	2100	800	1600	2024-08-09 15:28:58.862895-05	438
251	\N	Monday: 2:00 – 10:00 PM, Tuesday: 2:00 – 10:00 PM, Wednesday: 2:00 – 10:00 PM, Thursday: 2:00 – 10:00 PM, Friday: 12:00 – 11:00 PM, Saturday: 12:00 – 11:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	1400	2200	1400	2200	1400	2200	1400	2200	1200	2300	1200	2300	2024-08-09 15:29:01.229494-05	443
252	\N	Monday: 9:00 AM – 10:00 PM, Tuesday: 9:00 AM – 10:00 PM, Wednesday: 9:00 AM – 10:00 PM, Thursday: 9:00 AM – 10:00 PM, Friday: 9:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 10:00 PM	900	2200	900	2200	900	2200	900	2200	900	2200	900	2200	900	2200	2024-08-09 15:29:01.629764-05	445
253	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 11:00 AM – 7:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 6:00 PM	1100	1800	1000	2000	1000	2000	1100	1900	1000	2000	1000	2000	1000	2000	2024-08-09 15:29:03.139989-05	448
254	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:29:03.374834-05	449
255	\N	Monday: Closed, Tuesday: 9:00 AM – 4:00 PM, Wednesday: 9:00 AM – 4:00 PM, Thursday: 9:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:00 – 10:30 AM	800	1000	\N	\N	900	1600	900	1600	900	1600	\N	\N	\N	\N	2024-08-09 15:29:03.729519-05	450
256	\N	Monday: Closed, Tuesday: 9:00 AM – 4:00 PM, Wednesday: 9:00 AM – 4:00 PM, Thursday: 9:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:00 – 10:30 AM	800	1000	\N	\N	900	1600	900	1600	900	1600	\N	\N	\N	\N	2024-08-09 15:29:03.890301-05	451
257	\N	Monday: Closed, Tuesday: 9:00 AM – 4:00 PM, Wednesday: 9:00 AM – 4:00 PM, Thursday: 9:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:00 – 10:30 AM	800	1000	\N	\N	900	1600	900	1600	900	1600	\N	\N	\N	\N	2024-08-09 15:29:04.043698-05	452
258	\N	Monday: 11:00 AM – 9:00 PM, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 9:00 PM, Saturday: 11:00 AM – 9:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	2024-08-09 15:29:04.932542-05	454
259	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:29:06.033164-05	457
260	\N	Monday: 8:00 AM – 1:00 AM, Tuesday: 8:00 AM – 1:00 AM, Wednesday: 8:00 AM – 1:00 AM, Thursday: 8:00 AM – 1:00 AM, Friday: 8:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 1:00 AM	1000	100	800	100	800	100	800	100	800	100	800	2000	1000	2000	2024-08-09 15:29:06.542485-05	459
261	\N	Monday: 8:00 AM – 4:00 PM, Tuesday: 8:00 AM – 4:00 PM, Wednesday: 8:00 AM – 4:00 PM, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:29:06.933006-05	462
262	\N	Monday: Closed, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: 7:00 AM – 7:00 PM, Sunday: 7:00 AM – 7:00 PM	700	1900	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	2024-08-09 15:29:07.204698-05	463
263	\N	Monday: Closed, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 7:00 PM, Saturday: 7:00 AM – 7:00 PM, Sunday: 7:00 AM – 7:00 PM	700	1900	\N	\N	700	1900	700	1900	700	1900	700	1900	700	1900	2024-08-09 15:29:07.364983-05	464
264	\N	Monday: 11:00 AM – 5:00 PM, Tuesday: 11:00 AM – 5:00 PM, Wednesday: 11:00 AM – 5:00 PM, Thursday: 11:00 AM – 5:00 PM, Friday: 11:00 AM – 5:00 PM, Saturday: 11:00 AM – 5:00 PM, Sunday: Closed	\N	\N	1100	1700	1100	1700	1100	1700	1100	1700	1100	1700	1100	1700	2024-08-09 15:29:07.617122-05	465
265	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: 7:00 AM – 6:00 PM, Sunday: 7:00 AM – 2:00 PM	700	1400	700	1800	700	1800	700	1800	700	1800	700	1800	700	1800	2024-08-09 15:29:07.920654-05	466
266	\N	Monday: 9:00 AM – 2:00 PM, Tuesday: 9:00 AM – 2:00 PM, Wednesday: 9:00 AM – 2:00 PM, Thursday: 9:00 AM – 2:00 PM, Friday: 9:00 AM – 2:00 PM, Saturday: 9:00 AM – 2:00 PM, Sunday: 9:00 AM – 2:00 PM	900	1400	900	1400	900	1400	900	1400	900	1400	900	1400	900	1400	2024-08-09 15:29:09.341464-05	469
267	\N	Monday: Closed, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	\N	\N	1100	2100	1100	2100	1100	2100	1100	2200	1100	2200	2024-08-09 15:29:09.658579-05	470
268	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	2024-08-09 15:29:12.08456-05	476
269	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	2024-08-09 15:29:12.291962-05	477
270	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 11:00 PM, Saturday: 7:00 AM – 11:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2300	700	2300	2024-08-09 15:29:12.464557-05	478
271	\N	Monday: 7:00 AM – 8:00 PM, Tuesday: 7:00 AM – 8:00 PM, Wednesday: 7:00 AM – 8:00 PM, Thursday: 7:00 AM – 8:00 PM, Friday: 7:00 AM – 9:00 PM, Saturday: 7:00 AM – 9:00 PM, Sunday: 7:00 AM – 8:00 PM	700	2000	700	2000	700	2000	700	2000	700	2000	700	2100	700	2100	2024-08-09 15:29:13.627004-05	480
272	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	2024-08-09 15:29:13.846082-05	481
273	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	2024-08-09 15:29:14.033454-05	482
274	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 5:00 PM, Wednesday: 7:00 AM – 5:00 PM, Thursday: 7:00 AM – 5:00 PM, Friday: 7:00 AM – 5:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	700	1700	2024-08-09 15:29:14.357542-05	483
275	\N	Monday: 4:30 AM – 8:30 PM, Tuesday: 4:30 AM – 8:30 PM, Wednesday: 4:30 AM – 8:30 PM, Thursday: 4:30 AM – 8:30 PM, Friday: 4:30 AM – 8:30 PM, Saturday: 4:30 AM – 8:30 PM, Sunday: 5:30 AM – 8:30 PM	500	2000	400	2000	400	2000	400	2000	400	2000	400	2000	400	2000	2024-08-09 15:29:14.626284-05	484
276	\N	Monday: 4:30 AM – 7:30 PM, Tuesday: 4:30 AM – 7:30 PM, Wednesday: 4:30 AM – 7:30 PM, Thursday: 4:30 AM – 7:30 PM, Friday: 4:30 AM – 7:30 PM, Saturday: 5:00 AM – 7:30 PM, Sunday: 5:00 AM – 7:30 PM	500	1900	400	1900	400	1900	400	1900	400	1900	400	1900	500	1900	2024-08-09 15:29:14.898954-05	485
277	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:29:15.125213-05	486
278	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	900	1700	1200	2000	1200	2000	1200	2000	900	1700	900	1700	2024-08-09 15:29:15.364448-05	487
279	\N	Monday: 10:30 AM – 9:00 PM, Tuesday: 10:30 AM – 9:00 PM, Wednesday: 10:30 AM – 9:00 PM, Thursday: 10:30 AM – 9:00 PM, Friday: 10:30 AM – 9:00 PM, Saturday: 10:30 AM – 9:00 PM, Sunday: 10:30 AM – 9:00 PM	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	2024-08-09 15:29:15.701979-05	489
280	\N	Monday: Closed, Tuesday: 7:00 AM – 2:00 PM, Wednesday: 7:00 AM – 2:00 PM, Thursday: 7:00 AM – 2:00 PM, Friday: 7:00 AM – 2:00 PM, Saturday: 7:00 AM – 2:00 PM, Sunday: 7:00 AM – 2:00 PM	700	1400	\N	\N	700	1400	700	1400	700	1400	700	1400	700	1400	2024-08-09 15:29:17.294302-05	497
281	\N	Monday: 8:00 AM – 4:00 PM, Tuesday: 8:00 AM – 4:00 PM, Wednesday: 8:00 AM – 4:00 PM, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:29:17.518851-05	498
282	\N	Monday: 11:00 AM – 9:00 PM, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2200	1100	2200	2024-08-09 15:29:17.787584-05	499
283	\N	Monday: 7:30 AM – 4:00 PM, Tuesday: 7:30 AM – 4:00 PM, Wednesday: 7:30 AM – 4:00 PM, Thursday: 7:30 AM – 4:00 PM, Friday: 7:30 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1600	700	1600	700	1600	700	1600	700	1600	\N	\N	2024-08-09 15:29:18.002433-05	500
284	\N	Monday: 8:00 AM – 10:00 PM, Tuesday: 8:00 AM – 10:00 PM, Wednesday: 8:00 AM – 10:00 PM, Thursday: 8:00 AM – 10:00 PM, Friday: 8:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	800	2200	2024-08-09 15:30:48.048662-05	501
285	\N	Monday: 3:00 – 9:00 PM, Tuesday: 3:00 – 9:00 PM, Wednesday: 3:00 – 9:00 PM, Thursday: 3:00 – 9:00 PM, Friday: 3:00 – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1500	2100	1500	2100	1500	2100	1500	2100	1500	2200	900	2200	2024-08-09 15:30:48.280316-05	502
286	\N	Monday: 11:00 AM – 1:00 AM, Tuesday: 11:00 AM – 1:00 AM, Wednesday: 11:00 AM – 1:00 AM, Thursday: 11:00 AM – 1:00 AM, Friday: 11:00 AM – 1:00 AM, Saturday: 10:00 AM – 1:00 AM, Sunday: 10:00 AM – 1:00 AM	1000	100	1100	100	1100	100	1100	100	1100	100	1100	100	1000	100	2024-08-09 15:30:48.499286-05	503
287	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 6:00 AM – 10:00 PM	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:30:48.741226-05	504
288	\N	Monday: 6:00 AM – 6:00 PM, Tuesday: 6:00 AM – 6:00 PM, Wednesday: 6:00 AM – 6:00 PM, Thursday: 6:00 AM – 6:00 PM, Friday: 6:00 AM – 6:00 PM, Saturday: 7:00 AM – 6:00 PM, Sunday: 7:00 AM – 6:00 PM	700	1800	600	1800	600	1800	600	1800	600	1800	600	1800	700	1800	2024-08-09 15:30:48.96451-05	505
289	\N	Monday: 5:00 AM – 8:30 PM, Tuesday: 5:00 AM – 8:30 PM, Wednesday: 5:00 AM – 8:30 PM, Thursday: 5:00 AM – 8:30 PM, Friday: 5:00 AM – 8:30 PM, Saturday: 5:30 AM – 8:30 PM, Sunday: 5:30 AM – 8:30 PM	500	2000	500	2000	500	2000	500	2000	500	2000	500	2000	500	2000	2024-08-09 15:30:49.176049-05	506
290	\N	Monday: 5:30 AM – 8:30 PM, Tuesday: 5:30 AM – 8:30 PM, Wednesday: 5:30 AM – 8:30 PM, Thursday: 5:30 AM – 8:30 PM, Friday: 5:30 AM – 8:30 PM, Saturday: 6:00 AM – 8:30 PM, Sunday: 6:00 AM – 8:30 PM	600	2000	500	2000	500	2000	500	2000	500	2000	500	2000	600	2000	2024-08-09 15:30:49.444868-05	507
291	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 10:00 AM – 7:00 PM	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:30:49.831002-05	508
292	\N	Monday: Closed, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 7:00 AM – 3:00 PM, Sunday: 7:00 AM – 3:00 PM	700	1500	\N	\N	700	1500	700	1500	700	1500	700	1500	700	1500	2024-08-09 15:30:50.166375-05	510
293	\N	Monday: 10:30 AM – 1:00 AM, Tuesday: 10:30 AM – 1:00 AM, Wednesday: 10:30 AM – 1:00 AM, Thursday: 10:30 AM – 3:00 AM, Friday: 10:30 AM – 3:00 AM, Saturday: 10:30 AM – 3:00 AM, Sunday: 10:30 AM – 1:00 AM	1000	100	1000	100	1000	100	1000	100	1000	300	1000	300	1000	300	2024-08-09 15:30:50.428824-05	511
294	\N	Monday: 8:00 AM – 4:30 PM, Tuesday: 8:00 AM – 4:30 PM, Wednesday: 8:00 AM – 4:30 PM, Thursday: 8:00 AM – 4:30 PM, Friday: 8:00 AM – 2:00 PM, Saturday: Closed, Sunday: 8:00 AM – 1:00 PM	800	1300	800	1600	800	1600	800	1600	800	1600	800	1400	\N	\N	2024-08-09 15:30:50.811318-05	512
295	\N	Monday: 11:00 AM – 12:00 AM, Tuesday: 11:00 AM – 12:00 AM, Wednesday: 11:00 AM – 12:00 AM, Thursday: 11:00 AM – 12:00 AM, Friday: 11:00 AM – 1:00 AM, Saturday: 11:00 AM – 1:00 AM, Sunday: 11:00 AM – 12:00 AM	1100	0	1100	0	1100	0	1100	0	1100	0	1100	100	1100	100	2024-08-09 15:30:51.071383-05	513
296	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:30:51.945556-05	515
297	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:30:52.191358-05	516
298	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 12:00 PM, Sunday: Closed	\N	\N	900	1700	900	1700	900	1700	900	1700	900	1700	900	1200	2024-08-09 15:30:52.412328-05	517
299	\N	Monday: 5:00 AM – 7:30 PM, Tuesday: 5:00 AM – 7:30 PM, Wednesday: 5:00 AM – 7:30 PM, Thursday: 5:00 AM – 7:30 PM, Friday: 5:00 AM – 7:30 PM, Saturday: 5:30 AM – 7:30 PM, Sunday: 5:30 AM – 7:30 PM	500	1900	500	1900	500	1900	500	1900	500	1900	500	1900	500	1900	2024-08-09 15:30:53.59277-05	520
300	\N	Monday: 6:30 AM – 6:00 PM, Tuesday: 6:30 AM – 6:00 PM, Wednesday: 6:30 AM – 6:00 PM, Thursday: 6:30 AM – 6:00 PM, Friday: 6:30 AM – 6:00 PM, Saturday: 7:00 AM – 6:00 PM, Sunday: 7:00 AM – 6:00 PM	700	1800	600	1800	600	1800	600	1800	600	1800	600	1800	700	1800	2024-08-09 15:30:53.97843-05	521
301	\N	Monday: 11:00 AM – 7:00 PM, Tuesday: 11:00 AM – 7:00 PM, Wednesday: 11:00 AM – 7:00 PM, Thursday: 11:00 AM – 7:00 PM, Friday: 11:00 AM – 7:00 PM, Saturday: 11:00 AM – 7:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1100	1900	1100	1900	1100	1900	1100	1900	1100	1900	1100	1900	2024-08-09 15:30:54.211015-05	522
302	\N	Monday: Closed, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 12:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:00 AM – 12:00 PM	800	1200	\N	\N	1000	1600	1000	1600	0	1600	\N	\N	\N	\N	2024-08-09 15:30:57.219962-05	527
303	\N	Monday: Closed, Tuesday: Closed, Wednesday: 11:00 AM – 8:00 PM, Thursday: 11:00 AM – 8:00 PM, Friday: 11:00 AM – 8:00 PM, Saturday: 11:00 AM – 8:00 PM, Sunday: 10:00 AM – 8:00 PM	1000	2000	\N	\N	\N	\N	1100	2000	1100	2000	1100	2000	1100	2000	2024-08-09 15:30:57.70503-05	528
304	\N	Monday: 7:30 AM – 10:30 PM, Tuesday: 7:30 AM – 10:30 PM, Wednesday: 7:30 AM – 10:30 PM, Thursday: 7:30 AM – 10:30 PM, Friday: 7:30 AM – 10:30 PM, Saturday: 9:00 AM – 4:00 PM, Sunday: 9:00 AM – 4:00 PM	900	1600	700	2200	700	2200	700	2200	700	2200	700	2200	900	1600	2024-08-09 15:30:58.594226-05	530
305	\N	Monday: 9:00 AM – 9:00 PM, Tuesday: 9:00 AM – 9:00 PM, Wednesday: 9:00 AM – 9:00 PM, Thursday: 9:00 AM – 9:00 PM, Friday: 9:00 AM – 9:00 PM, Saturday: 9:00 AM – 9:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	900	2100	900	2100	900	2100	900	2100	900	2100	900	2100	2024-08-09 15:30:58.851814-05	531
306	\N	Monday: Closed, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 12:00 – 8:00 PM, Saturday: 12:00 – 8:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	\N	\N	1200	2000	1200	2000	1200	2000	1200	2000	1200	2000	2024-08-09 15:30:59.170936-05	533
307	\N	Monday: Closed, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 8:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 12:00 – 8:00 PM, Saturday: 12:00 – 8:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	\N	\N	1200	2000	1200	2000	1200	2000	1200	2000	1200	2000	2024-08-09 15:30:59.467562-05	535
308	\N	Monday: 9:00 AM – 9:00 PM, Tuesday: 9:00 AM – 9:00 PM, Wednesday: 9:00 AM – 9:00 PM, Thursday: 9:00 AM – 9:00 PM, Friday: 9:00 AM – 9:00 PM, Saturday: 9:00 AM – 9:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	900	2100	900	2100	900	2100	900	2100	900	2100	900	2100	2024-08-09 15:30:59.685137-05	536
309	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 5:30 PM, Saturday: 10:00 AM – 5:30 PM, Sunday: 1:00 – 5:00 PM	1300	1700	1000	2000	1000	2000	1000	2000	1000	2000	1000	1700	1000	1700	2024-08-09 15:30:59.939664-05	537
439	\N	Monday: 12:00 – 8:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 12:00 – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	1200	2000	900	1700	900	1700	1200	2000	900	1700	900	1700	2024-08-09 15:31:50.197031-05	730
310	\N	Monday: 11:00 AM – 9:30 PM, Tuesday: 11:00 AM – 9:30 PM, Wednesday: 11:00 AM – 9:30 PM, Thursday: 11:00 AM – 9:30 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 9:30 PM	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2200	1100	2200	2024-08-09 15:31:00.930418-05	540
311	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 8:00 AM – 12:00 PM	800	1200	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	2024-08-09 15:31:01.146361-05	541
312	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 8:00 AM – 12:00 PM	800	1200	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	2024-08-09 15:31:01.31798-05	542
313	\N	Monday: 5:30 AM – 8:00 PM, Tuesday: 5:30 AM – 8:00 PM, Wednesday: 5:30 AM – 8:00 PM, Thursday: 5:30 AM – 8:00 PM, Friday: 5:30 AM – 8:00 PM, Saturday: 6:00 AM – 8:00 PM, Sunday: 6:00 AM – 8:00 PM	600	2000	500	2000	500	2000	500	2000	500	2000	500	2000	600	2000	2024-08-09 15:31:01.59954-05	543
314	\N	Monday: 6:00 AM – 11:00 PM, Tuesday: 6:00 AM – 11:00 PM, Wednesday: 6:00 AM – 11:00 PM, Thursday: 6:00 AM – 11:00 PM, Friday: 6:00 AM – 11:00 PM, Saturday: 6:00 AM – 11:00 PM, Sunday: 6:00 AM – 11:00 PM	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	2024-08-09 15:31:01.82549-05	544
315	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 8:00 AM – 10:00 PM, Sunday: 8:00 AM – 6:00 PM	800	1800	600	2200	600	2200	600	2200	600	2200	600	2200	800	2200	2024-08-09 15:31:02.224697-05	546
316	\N	Monday: 7:30 AM – 9:00 PM, Tuesday: 7:30 AM – 9:00 PM, Wednesday: 7:30 AM – 9:00 PM, Thursday: 7:30 AM – 9:00 PM, Friday: 7:30 AM – 9:00 PM, Saturday: 7:30 AM – 9:00 PM, Sunday: 7:30 AM – 9:00 PM	700	2100	700	2100	700	2100	700	2100	700	2100	700	2100	700	2100	2024-08-09 15:31:02.449918-05	547
317	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	2024-08-09 15:31:02.682229-05	548
318	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 12:00 PM, Saturday: 9:00 AM – 12:00 PM, Sunday: Closed	\N	\N	900	1700	900	1700	900	1700	900	1700	900	1200	900	1200	2024-08-09 15:31:03.219624-05	550
319	\N	Monday: 3:00 – 9:00 PM, Tuesday: 3:00 – 9:00 PM, Wednesday: 3:00 – 9:00 PM, Thursday: 3:00 – 9:00 PM, Friday: 3:00 – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 9:00 PM	900	2100	1500	2100	1500	2100	1500	2100	1500	2100	1500	2200	900	2200	2024-08-09 15:31:03.399877-05	551
320	\N	Monday: 10:00 AM – 12:00 AM, Tuesday: 10:00 AM – 12:00 AM, Wednesday: 10:00 AM – 1:00 AM, Thursday: 10:00 AM – 1:00 AM, Friday: 10:00 AM – 1:00 AM, Saturday: 10:00 AM – 1:00 AM, Sunday: 10:00 AM – 12:00 AM	1000	0	1000	0	1000	0	1000	100	1000	100	1000	100	1000	100	2024-08-09 15:31:04.500617-05	555
321	\N	Monday: 8:00 AM – 5:00 PM, Tuesday: 8:00 AM – 5:00 PM, Wednesday: 8:30 AM – 5:30 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 7:00 AM – 12:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1700	800	1700	800	1700	800	1700	700	1200	\N	\N	2024-08-09 15:31:04.727543-05	556
322	\N	Monday: Closed, Tuesday: Closed, Wednesday: 8:00 AM – 1:00 PM, Thursday: 8:00 AM – 1:00 PM, Friday: 8:00 AM – 1:00 PM, Saturday: 8:00 AM – 1:00 PM, Sunday: 8:00 AM – 1:00 PM	800	1300	\N	\N	\N	\N	800	1300	800	1300	800	1300	800	1300	2024-08-09 15:31:05.188692-05	559
323	\N	Monday: 6:00 AM – 5:00 PM, Tuesday: 6:00 AM – 5:00 PM, Wednesday: 6:00 AM – 5:00 PM, Thursday: 6:00 AM – 5:00 PM, Friday: 6:00 AM – 5:00 PM, Saturday: 7:00 AM – 5:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	600	1700	600	1700	600	1700	600	1700	600	1700	700	1700	2024-08-09 15:31:05.768572-05	561
324	\N	Monday: 9:00 AM – 8:00 PM, Tuesday: 9:00 AM – 8:00 PM, Wednesday: 9:00 AM – 8:00 PM, Thursday: 9:00 AM – 8:00 PM, Friday: 9:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	900	2000	900	2000	900	2000	900	2000	900	2000	900	2000	2024-08-09 15:31:05.994627-05	562
325	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 11:00 AM – 6:00 PM	1100	1800	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:31:06.218061-05	563
326	\N	Monday: 9:00 AM – 8:00 PM, Tuesday: 9:00 AM – 8:00 PM, Wednesday: 9:00 AM – 8:00 PM, Thursday: 9:00 AM – 8:00 PM, Friday: 9:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: 9:00 AM – 7:00 PM	900	1900	900	2000	900	2000	900	2000	900	2000	900	2000	900	2000	2024-08-09 15:31:06.620589-05	565
327	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: 9:00 AM – 8:00 PM	900	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	900	2000	2024-08-09 15:31:06.994698-05	568
328	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: 9:00 AM – 8:00 PM	900	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	900	2000	2024-08-09 15:31:07.326526-05	569
329	\N	Monday: 11:00 AM – 11:00 PM, Tuesday: 11:00 AM – 11:00 PM, Wednesday: 11:00 AM – 11:00 PM, Thursday: 11:00 AM – 11:00 PM, Friday: 11:00 AM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 11:00 PM	1100	2300	1100	2300	1100	2300	1100	2300	1100	2300	1100	0	1100	0	2024-08-09 15:31:07.552287-05	570
330	\N	Monday: 11:00 AM – 11:00 PM, Tuesday: 11:00 AM – 11:00 PM, Wednesday: 11:00 AM – 11:00 PM, Thursday: 11:00 AM – 11:00 PM, Friday: 11:00 AM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 11:00 PM	1100	2300	1100	2300	1100	2300	1100	2300	1100	2300	1100	0	1100	0	2024-08-09 15:31:07.892819-05	571
331	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:08.116298-05	572
332	\N	Monday: 7:30 AM – 6:00 PM, Tuesday: 7:30 AM – 6:00 PM, Wednesday: 7:30 AM – 6:00 PM, Thursday: 7:30 AM – 6:00 PM, Friday: 7:30 AM – 5:30 PM, Saturday: 8:00 AM – 4:00 PM, Sunday: Closed	\N	\N	700	1800	700	1800	700	1800	700	1800	700	1700	800	1600	2024-08-09 15:31:08.502404-05	574
333	\N	Monday: 6:30 AM – 8:00 PM, Tuesday: 6:30 AM – 8:00 PM, Wednesday: 6:30 AM – 8:00 PM, Thursday: 6:30 AM – 8:00 PM, Friday: 6:30 AM – 6:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	600	2000	600	2000	600	2000	600	2000	600	1800	\N	\N	2024-08-09 15:31:08.728113-05	575
334	\N	Monday: 11:00 AM – 8:00 PM, Tuesday: 11:00 AM – 8:00 PM, Wednesday: 11:00 AM – 8:00 PM, Thursday: 11:00 AM – 8:00 PM, Friday: 11:00 AM – 8:00 PM, Saturday: 11:00 AM – 8:00 PM, Sunday: 11:00 AM – 8:00 PM	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	1100	2000	2024-08-09 15:31:09.142145-05	576
335	\N	Monday: 12:00 – 10:00 PM, Tuesday: 12:00 – 10:00 PM, Wednesday: 12:00 – 10:00 PM, Thursday: 12:00 – 10:00 PM, Friday: 12:00 – 10:00 PM, Saturday: 12:00 – 10:00 PM, Sunday: 12:00 – 10:00 PM	1200	2200	1200	2200	1200	2200	1200	2200	1200	2200	1200	2200	1200	2200	2024-08-09 15:31:09.539411-05	578
336	\N	Monday: 6:30 AM – 2:00 PM, Tuesday: 6:30 AM – 2:00 PM, Wednesday: 6:30 AM – 2:00 PM, Thursday: 6:30 AM – 2:00 PM, Friday: 6:30 AM – 2:00 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	600	1400	600	1400	600	1400	600	1400	600	1400	800	1400	2024-08-09 15:31:10.61457-05	581
337	\N	Monday: 7:00 AM – 6:00 PM, Tuesday: 7:00 AM – 6:00 PM, Wednesday: 7:00 AM – 6:00 PM, Thursday: 7:00 AM – 6:00 PM, Friday: 7:00 AM – 6:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1800	700	1800	700	1800	700	1800	700	1800	\N	\N	2024-08-09 15:31:10.953604-05	583
338	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:31:11.211971-05	584
339	\N	Monday: 10:00 AM – 7:00 PM, Tuesday: 10:00 AM – 7:00 PM, Wednesday: 10:00 AM – 7:00 PM, Thursday: 10:00 AM – 7:00 PM, Friday: 10:00 AM – 7:00 PM, Saturday: 10:00 AM – 7:00 PM, Sunday: 11:00 AM – 6:00 PM	1100	1800	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	1000	1900	2024-08-09 15:31:11.842004-05	588
340	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:12.075124-05	589
341	\N	Monday: 8:00 AM – 3:00 PM, Tuesday: 8:00 AM – 3:00 PM, Wednesday: 8:00 AM – 3:00 PM, Thursday: 8:00 AM – 3:00 PM, Friday: 8:00 AM – 3:00 PM, Saturday: 8:00 AM – 3:00 PM, Sunday: 8:00 AM – 3:00 PM	800	1500	800	1500	800	1500	800	1500	800	1500	800	1500	800	1500	2024-08-09 15:31:12.515141-05	590
342	\N	Monday: Closed, Tuesday: 7:00 AM – 3:00 PM, Wednesday: 7:00 AM – 3:00 PM, Thursday: 7:00 AM – 3:00 PM, Friday: 7:00 AM – 3:00 PM, Saturday: 7:00 AM – 3:00 PM, Sunday: 7:00 AM – 3:00 PM	700	1500	\N	\N	700	1500	700	1500	700	1500	700	1500	700	1500	2024-08-09 15:31:13.477771-05	592
343	\N	Monday: Closed, Tuesday: Closed, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 4:00 PM, Saturday: 10:00 AM – 4:00 PM, Sunday: 10:00 AM – 4:00 PM	1000	1600	\N	\N	\N	\N	1000	1600	1000	2000	1000	1600	1000	1600	2024-08-09 15:31:13.69288-05	593
344	\N	Monday: 8:00 AM – 5:00 PM, Tuesday: 8:00 AM – 5:00 PM, Wednesday: 8:00 AM – 5:00 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 8:00 AM – 5:00 PM, Saturday: 10:00 AM – 3:00 PM, Sunday: Closed	\N	\N	800	1700	800	1700	800	1700	800	1700	800	1700	1000	1500	2024-08-09 15:31:13.92409-05	594
345	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 3:00 – 10:00 PM, Friday: 3:00 PM – 12:00 AM, Saturday: 11:00 AM – 12:00 AM, Sunday: 11:00 AM – 9:00 PM	1100	2100	\N	\N	\N	\N	\N	\N	1500	2200	1500	0	1100	0	2024-08-09 15:31:14.267556-05	596
346	\N	Monday: 9:30 AM – 9:00 PM, Tuesday: 9:30 AM – 9:00 PM, Wednesday: 9:30 AM – 9:00 PM, Thursday: 9:30 AM – 9:00 PM, Friday: 9:30 AM – 9:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 8:00 PM	900	2000	900	2100	900	2100	900	2100	900	2100	900	2100	900	2200	2024-08-09 15:31:14.775906-05	598
347	\N	Monday: 8:00 AM – 4:30 PM, Tuesday: 8:00 AM – 4:30 PM, Wednesday: 8:00 AM – 4:30 PM, Thursday: 8:00 AM – 4:30 PM, Friday: 8:00 AM – 4:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:31:15.001106-05	599
348	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 6:00 PM	1100	1800	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:31:17.02968-05	603
349	\N	Monday: 10:00 AM – 5:00 PM, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 5:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	1000	2000	1000	2000	2024-08-09 15:31:17.247605-05	604
350	\N	Monday: 10:00 AM – 5:00 PM, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 5:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	1000	2000	1000	2000	2024-08-09 15:31:17.550362-05	606
351	\N	Monday: 10:00 AM – 5:00 PM, Tuesday: 10:00 AM – 5:00 PM, Wednesday: 10:00 AM – 5:00 PM, Thursday: 10:00 AM – 5:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 10:00 AM – 5:00 PM	1000	1700	1000	1700	1000	1700	1000	1700	1000	1700	1000	2000	1000	2000	2024-08-09 15:31:17.725487-05	607
352	\N	Monday: 10:00 AM – 9:00 PM, Tuesday: 10:00 AM – 9:00 PM, Wednesday: 10:00 AM – 9:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 9:00 PM, Saturday: 10:00 AM – 9:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	2024-08-09 15:31:18.112407-05	610
353	\N	Monday: 5:00 AM – 8:00 PM, Tuesday: 5:00 AM – 8:00 PM, Wednesday: 5:00 AM – 8:00 PM, Thursday: 5:00 AM – 8:00 PM, Friday: 5:00 AM – 8:00 PM, Saturday: 6:00 AM – 8:00 PM, Sunday: 6:30 AM – 7:00 PM	600	1900	500	2000	500	2000	500	2000	500	2000	500	2000	600	2000	2024-08-09 15:31:19.749202-05	613
354	\N	Monday: 6:30 AM – 6:00 PM, Tuesday: 6:30 AM – 6:00 PM, Wednesday: 6:30 AM – 6:00 PM, Thursday: 6:30 AM – 6:00 PM, Friday: 6:30 AM – 6:00 PM, Saturday: 6:30 AM – 6:00 PM, Sunday: 6:30 AM – 6:00 PM	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	2024-08-09 15:31:20.243327-05	617
355	\N	Monday: Closed, Tuesday: Closed, Wednesday: 5:00 – 9:00 PM, Thursday: 5:00 – 9:00 PM, Friday: 5:00 – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 9:00 AM – 2:00 PM	900	1400	\N	\N	\N	\N	1700	2100	1700	2100	1700	2200	900	2200	2024-08-09 15:31:21.097435-05	619
356	\N	Monday: Closed, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 9:00 PM, Saturday: 12:00 – 9:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	\N	\N	1100	2100	1100	2100	1100	2100	1100	2100	1200	2100	2024-08-09 15:31:21.309995-05	620
357	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 11:00 PM, Saturday: 11:00 AM – 11:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2300	1100	2300	2024-08-09 15:31:21.767764-05	623
358	\N	Monday: 8:00 AM – 4:30 PM, Tuesday: 8:00 AM – 4:30 PM, Wednesday: 8:00 AM – 4:30 PM, Thursday: 8:00 AM – 4:30 PM, Friday: 8:00 AM – 4:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:31:22.151814-05	624
359	\N	Monday: 11:30 AM – 8:30 PM, Tuesday: 11:30 AM – 8:30 PM, Wednesday: 11:30 AM – 8:30 PM, Thursday: 11:30 AM – 9:00 PM, Friday: 11:30 AM – 9:00 PM, Saturday: 9:00 AM – 9:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	1100	2000	1100	2000	1100	2000	1100	2100	1100	2100	900	2100	2024-08-09 15:31:22.598676-05	625
360	\N	Monday: 3:00 – 9:00 PM, Tuesday: 3:00 – 9:00 PM, Wednesday: 3:00 – 10:00 PM, Thursday: 3:00 – 10:00 PM, Friday: 3:00 – 10:00 PM, Saturday: 12:00 – 10:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	1500	2100	1500	2100	1500	2200	1500	2200	1500	2200	1200	2200	2024-08-09 15:31:23.012934-05	626
361	\N	Monday: 9:00 AM – 9:00 PM, Tuesday: 9:00 AM – 9:00 PM, Wednesday: 9:00 AM – 9:00 PM, Thursday: 9:00 AM – 9:00 PM, Friday: 9:00 AM – 9:00 PM, Saturday: 9:00 AM – 9:00 PM, Sunday: 9:00 AM – 8:00 PM	900	2000	900	2100	900	2100	900	2100	900	2100	900	2100	900	2100	2024-08-09 15:31:23.274386-05	627
362	\N	Monday: 8:00 AM – 3:00 PM, Tuesday: 8:00 AM – 3:00 PM, Wednesday: 8:00 AM – 3:00 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 8:00 AM – 5:00 PM, Saturday: 8:00 AM – 5:00 PM, Sunday: 8:00 AM – 5:00 PM	800	1700	800	1500	800	1500	800	1500	800	1700	800	1700	800	1700	2024-08-09 15:31:23.52061-05	628
363	\N	Monday: 12:00 – 7:00 PM, Tuesday: 12:00 – 7:00 PM, Wednesday: 12:00 – 7:00 PM, Thursday: 12:00 – 7:00 PM, Friday: 12:00 – 7:00 PM, Saturday: 12:00 – 7:00 PM, Sunday: 12:00 – 6:00 PM	1200	1800	1200	1900	1200	1900	1200	1900	1200	1900	1200	1900	1200	1900	2024-08-09 15:31:24.369334-05	630
364	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:31:24.812158-05	631
365	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	1000	2000	1000	2000	1000	2000	1000	2000	1000	1700	1000	1700	2024-08-09 15:31:25.02045-05	632
366	\N	Monday: 5:00 AM – 6:30 PM, Tuesday: 5:00 AM – 6:30 PM, Wednesday: 5:00 AM – 6:30 PM, Thursday: 5:00 AM – 6:30 PM, Friday: 5:00 AM – 6:30 PM, Saturday: 6:00 AM – 6:00 PM, Sunday: 6:00 AM – 6:00 PM	600	1800	500	1800	500	1800	500	1800	500	1800	500	1800	600	1800	2024-08-09 15:31:25.273122-05	633
367	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	1000	1800	1000	1800	1000	1800	1000	1800	1000	1600	\N	\N	2024-08-09 15:31:25.649546-05	634
368	\N	Monday: 10:00 AM – 9:00 PM, Tuesday: 10:00 AM – 9:00 PM, Wednesday: 10:00 AM – 9:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 10:00 PM, Saturday: 9:00 AM – 10:00 PM, Sunday: 10:00 AM – 9:00 PM	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2200	900	2200	2024-08-09 15:31:26.769474-05	637
369	\N	Monday: 9:00 AM – 8:00 PM, Tuesday: 9:00 AM – 8:00 PM, Wednesday: 9:00 AM – 8:00 PM, Thursday: 9:00 AM – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	900	2000	900	2000	900	2000	900	2000	900	1700	900	1700	2024-08-09 15:31:26.997209-05	638
370	\N	Monday: 8:00 AM – 4:30 PM, Tuesday: 8:00 AM – 4:30 PM, Wednesday: 8:00 AM – 4:30 PM, Thursday: 8:00 AM – 4:30 PM, Friday: 8:00 AM – 4:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:31:27.269315-05	640
371	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:31:27.481999-05	641
372	\N	Monday: 10:30 AM – 10:00 PM, Tuesday: 10:30 AM – 10:00 PM, Wednesday: 10:30 AM – 10:00 PM, Thursday: 10:30 AM – 10:00 PM, Friday: 10:30 AM – 10:00 PM, Saturday: 10:30 AM – 10:00 PM, Sunday: 10:30 AM – 10:00 PM	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	2024-08-09 15:31:28.280834-05	643
373	\N	Monday: 11:30 AM – 10:00 PM, Tuesday: 11:30 AM – 10:00 PM, Wednesday: 11:30 AM – 10:00 PM, Thursday: 11:30 AM – 11:00 PM, Friday: 11:30 AM – 12:00 AM, Saturday: 11:30 AM – 12:00 AM, Sunday: 11:30 AM – 9:00 PM	1100	2100	1100	2200	1100	2200	1100	2200	1100	2300	1100	0	1100	0	2024-08-09 15:31:28.518991-05	644
374	\N	Monday: Closed, Tuesday: Closed, Wednesday: Closed, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 10:00 AM – 5:00 PM, Sunday: Closed	\N	\N	\N	\N	\N	\N	\N	\N	900	1700	900	1700	1000	1700	2024-08-09 15:31:29.50559-05	646
375	\N	Monday: 6:30 AM – 10:00 PM, Tuesday: 6:30 AM – 10:00 PM, Wednesday: 6:30 AM – 10:00 PM, Thursday: 6:30 AM – 10:00 PM, Friday: 6:30 AM – 10:00 PM, Saturday: 8:00 AM – 6:00 PM, Sunday: Closed	\N	\N	600	2200	600	2200	600	2200	600	2200	600	2200	800	1800	2024-08-09 15:31:29.729426-05	647
376	\N	Monday: 8:00 AM – 5:00 PM, Tuesday: 8:00 AM – 5:00 PM, Wednesday: 8:00 AM – 5:00 PM, Thursday: 8:00 AM – 5:00 PM, Friday: 8:00 AM – 4:30 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: Closed	\N	\N	800	1700	800	1700	800	1700	800	1700	800	1600	800	1400	2024-08-09 15:31:30.067084-05	649
377	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 6:00 PM	1100	1800	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:31:30.320769-05	650
378	\N	Monday: 6:00 AM – 11:00 PM, Tuesday: 6:00 AM – 11:00 PM, Wednesday: 6:00 AM – 11:00 PM, Thursday: 6:00 AM – 11:00 PM, Friday: 6:00 AM – 11:00 PM, Saturday: 6:00 AM – 11:00 PM, Sunday: 6:00 AM – 11:00 PM	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	2024-08-09 15:31:30.536804-05	651
379	\N	Monday: 9:00 AM – 8:00 PM, Tuesday: 9:00 AM – 8:00 PM, Wednesday: 9:00 AM – 8:00 PM, Thursday: 9:00 AM – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	900	2000	900	2000	900	2000	900	2000	900	1700	900	1700	2024-08-09 15:31:30.849424-05	653
380	\N	Monday: 7:00 AM – 5:00 PM, Tuesday: 7:00 AM – 8:00 PM, Wednesday: 7:00 AM – 8:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 8:00 AM – 6:00 PM	800	1800	700	1700	700	2000	700	2000	700	2200	700	2200	700	2200	2024-08-09 15:31:31.320163-05	654
381	\N	Monday: 8:45 AM – 3:30 PM, Tuesday: 8:45 AM – 3:30 PM, Wednesday: 8:45 AM – 3:30 PM, Thursday: 8:45 AM – 3:30 PM, Friday: 8:45 AM – 3:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1500	800	1500	800	1500	800	1500	800	1500	\N	\N	2024-08-09 15:31:31.528697-05	655
382	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	600	2200	600	2200	600	2200	600	2200	600	2200	700	2200	2024-08-09 15:31:32.197382-05	658
383	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 6:00 AM – 10:00 PM	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:31:32.431745-05	659
384	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:32.849928-05	660
385	\N	Monday: 10:00 AM – 2:00 PM, Tuesday: 10:00 AM – 2:00 PM, Wednesday: 10:00 AM – 2:00 PM, Thursday: 10:00 AM – 2:00 PM, Friday: 10:00 AM – 2:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	1000	1400	1000	1400	1000	1400	1000	1400	1000	1400	\N	\N	2024-08-09 15:31:33.072136-05	661
386	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 9:00 AM – 6:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	900	1900	900	1900	900	1900	900	1900	900	1900	900	1800	2024-08-09 15:31:33.271531-05	662
387	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 9:00 PM, Saturday: 10:00 AM – 9:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2000	1000	2000	1000	2000	1000	2000	1000	2100	1000	2100	2024-08-09 15:31:33.506067-05	663
388	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 9:00 AM – 2:00 PM, Sunday: Closed	\N	\N	900	1900	900	1900	900	1900	900	1900	900	1900	900	1400	2024-08-09 15:31:33.892272-05	664
389	\N	Monday: 9:00 AM – 12:00 PM, Tuesday: 9:00 AM – 12:00 PM, Wednesday: 9:00 AM – 12:00 PM, Thursday: 9:00 AM – 12:00 PM, Friday: 9:00 AM – 12:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	900	1200	900	1200	900	1200	900	1200	900	1200	\N	\N	2024-08-09 15:31:34.123462-05	665
390	\N	Monday: 12:00 – 8:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 12:00 – 10:00 PM, Thursday: 12:00 – 10:00 PM, Friday: 12:00 – 10:00 PM, Saturday: 12:00 – 10:00 PM, Sunday: 12:00 – 8:00 PM	1200	2000	1200	2000	1200	2000	1200	2200	1200	2200	1200	2200	1200	2200	2024-08-09 15:31:34.330081-05	666
391	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:31:34.563768-05	667
392	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 11:00 PM, Saturday: 11:00 AM – 11:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2300	1100	2300	2024-08-09 15:31:34.789715-05	668
393	\N	Monday: 11:00 AM – 10:00 PM, Tuesday: 11:00 AM – 10:00 PM, Wednesday: 11:00 AM – 10:00 PM, Thursday: 11:00 AM – 10:00 PM, Friday: 11:00 AM – 11:00 PM, Saturday: 11:00 AM – 11:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1100	2200	1100	2200	1100	2200	1100	2200	1100	2300	1100	2300	2024-08-09 15:31:34.964454-05	669
394	\N	Monday: 9:00 AM – 8:00 PM, Tuesday: 9:00 AM – 8:00 PM, Wednesday: 9:00 AM – 8:00 PM, Thursday: 9:00 AM – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	900	2000	900	2000	900	2000	900	2000	900	1700	900	1700	2024-08-09 15:31:35.196404-05	670
395	\N	Monday: 9:00 AM – 8:00 PM, Tuesday: 9:00 AM – 8:00 PM, Wednesday: 9:00 AM – 8:00 PM, Thursday: 9:00 AM – 8:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	900	2000	900	2000	900	2000	900	2000	900	1700	900	1700	2024-08-09 15:31:35.374157-05	671
396	\N	Monday: 10:00 AM – 2:00 PM, Tuesday: 10:00 AM – 2:00 PM, 5:00 – 9:00 PM, Wednesday: 10:00 AM – 2:00 PM, 5:00 – 9:00 PM, Thursday: 10:00 AM – 2:00 PM, 5:00 – 9:00 PM, Friday: 10:00 AM – 1:00 PM, Saturday: 8:00 AM – 1:00 PM, Sunday: Closed	\N	\N	1000	1400	1700	2100	1700	2100	1700	2100	1000	1300	800	1300	2024-08-09 15:31:35.856065-05	673
397	\N	Monday: 10:00 AM – 2:00 PM, Tuesday: 10:00 AM – 2:00 PM, 5:00 – 9:00 PM, Wednesday: 10:00 AM – 2:00 PM, 5:00 – 9:00 PM, Thursday: 10:00 AM – 2:00 PM, 5:00 – 9:00 PM, Friday: 10:00 AM – 1:00 PM, Saturday: 8:00 AM – 1:00 PM, Sunday: Closed	\N	\N	1000	1400	1700	2100	1700	2100	1700	2100	1000	1300	800	1300	2024-08-09 15:31:36.028174-05	674
398	\N	Monday: 12:00 – 10:00 PM, Tuesday: 12:00 – 10:00 PM, Wednesday: 12:00 – 10:00 PM, Thursday: 12:00 – 10:00 PM, Friday: 12:00 – 10:00 PM, Saturday: 12:00 – 10:00 PM, Sunday: 12:00 – 10:00 PM	1200	2200	1200	2200	1200	2200	1200	2200	1200	2200	1200	2200	1200	2200	2024-08-09 15:31:36.443893-05	675
399	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:36.667862-05	676
400	\N	Monday: 11:00 AM – 9:00 PM, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 9:30 PM, Saturday: 11:00 AM – 9:30 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	2024-08-09 15:31:36.892126-05	677
401	\N	Monday: 10:30 AM – 10:00 PM, Tuesday: 10:30 AM – 10:00 PM, Wednesday: 10:30 AM – 10:00 PM, Thursday: 10:30 AM – 10:00 PM, Friday: 10:30 AM – 10:00 PM, Saturday: 10:30 AM – 10:00 PM, Sunday: 10:30 AM – 10:00 PM	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	1000	2200	2024-08-09 15:31:37.481839-05	680
402	\N	Monday: 12:00 – 8:00 PM, Tuesday: 12:00 – 8:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: Closed	\N	\N	1200	2000	1200	2000	900	1700	900	1700	900	1700	900	1700	2024-08-09 15:31:37.718283-05	681
403	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:31:37.942633-05	682
404	\N	Monday: Closed, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 10:00 PM, Saturday: 11:00 AM – 10:00 PM, Sunday: 11:00 AM – 8:00 PM	1100	2000	\N	\N	1100	2100	1100	2100	1100	2100	1100	2200	1100	2200	2024-08-09 15:31:38.148585-05	683
405	\N	Monday: 7:30 AM – 4:00 PM, Tuesday: 7:30 AM – 4:00 PM, Wednesday: 7:30 AM – 4:00 PM, Thursday: 7:30 AM – 4:00 PM, Friday: 7:30 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1600	700	1600	700	1600	700	1600	700	1600	\N	\N	2024-08-09 15:31:38.351163-05	684
406	\N	Monday: 7:30 AM – 4:00 PM, Tuesday: 7:30 AM – 4:00 PM, Wednesday: 7:30 AM – 4:00 PM, Thursday: 7:30 AM – 4:00 PM, Friday: 7:30 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1600	700	1600	700	1600	700	1600	700	1600	\N	\N	2024-08-09 15:31:38.523893-05	685
407	\N	Monday: 8:00 AM – 2:40 PM, Tuesday: 8:00 AM – 2:40 PM, Wednesday: 8:00 AM – 2:40 PM, Thursday: 8:00 AM – 2:40 PM, Friday: 8:00 AM – 2:40 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1400	800	1400	800	1400	800	1400	800	1400	\N	\N	2024-08-09 15:31:38.747981-05	686
408	\N	Monday: 8:00 AM – 2:40 PM, Tuesday: 8:00 AM – 2:40 PM, Wednesday: 8:00 AM – 2:40 PM, Thursday: 8:00 AM – 2:40 PM, Friday: 8:00 AM – 2:40 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1400	800	1400	800	1400	800	1400	800	1400	\N	\N	2024-08-09 15:31:38.906602-05	687
409	\N	Monday: 8:00 AM – 2:40 PM, Tuesday: 8:00 AM – 2:40 PM, Wednesday: 8:00 AM – 2:40 PM, Thursday: 8:00 AM – 2:40 PM, Friday: 8:00 AM – 2:40 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1400	800	1400	800	1400	800	1400	800	1400	\N	\N	2024-08-09 15:31:39.080109-05	688
410	\N	Monday: Closed, Tuesday: Closed, Wednesday: 8:00 AM – 2:00 PM, Thursday: 8:00 AM – 2:00 PM, Friday: 8:00 AM – 2:00 PM, Saturday: 8:00 AM – 2:00 PM, Sunday: 8:00 AM – 2:00 PM	800	1400	\N	\N	\N	\N	800	1400	800	1400	800	1400	800	1400	2024-08-09 15:31:39.319218-05	689
411	\N	Monday: 8:00 AM – 4:00 PM, Tuesday: 8:00 AM – 4:00 PM, Wednesday: 8:00 AM – 4:00 PM, Thursday: 8:00 AM – 4:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: 8:00 AM – 12:00 PM, Sunday: 8:00 AM – 1:00 PM	800	1300	800	1600	800	1600	800	1600	800	1600	800	1600	800	1200	2024-08-09 15:31:39.527628-05	690
412	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: Closed	\N	\N	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	2024-08-09 15:31:39.753068-05	691
413	\N	Monday: 9:00 AM – 6:00 PM, Tuesday: 9:00 AM – 6:00 PM, Wednesday: 9:00 AM – 6:00 PM, Thursday: Closed, Friday: 9:00 AM – 6:00 PM, Saturday: 9:00 AM – 6:00 PM, Sunday: 9:00 AM – 5:00 PM	900	1700	900	1800	900	1800	900	1800	\N	\N	900	1800	900	1800	2024-08-09 15:31:40.184702-05	692
414	\N	Monday: 7:30 AM – 10:00 PM, Tuesday: 7:30 AM – 10:00 PM, Wednesday: 7:30 AM – 10:00 PM, Thursday: 7:30 AM – 10:00 PM, Friday: 7:30 AM – 11:00 PM, Saturday: 8:00 AM – 11:00 PM, Sunday: 8:00 AM – 10:00 PM	800	2200	700	2200	700	2200	700	2200	700	2200	700	2300	800	2300	2024-08-09 15:31:40.571966-05	693
415	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:40.793239-05	694
416	\N	Monday: 6:00 AM – 10:00 PM, Tuesday: 6:00 AM – 10:00 PM, Wednesday: 6:00 AM – 10:00 PM, Thursday: 6:00 AM – 10:00 PM, Friday: 6:00 AM – 10:00 PM, Saturday: 6:00 AM – 10:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	600	2200	600	2200	600	2200	600	2200	600	2200	600	2200	2024-08-09 15:31:41.04918-05	695
417	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:41.255657-05	696
418	\N	Monday: 7:00 AM – 7:00 PM, Tuesday: 7:00 AM – 7:00 PM, Wednesday: 7:00 AM – 7:00 PM, Thursday: 7:00 AM – 7:00 PM, Friday: 7:00 AM – 8:00 PM, Saturday: 7:00 AM – 7:00 PM, Sunday: 9:00 AM – 5:00 PM	900	1700	700	1900	700	1900	700	1900	700	1900	700	2000	700	1900	2024-08-09 15:31:41.708301-05	698
419	\N	Monday: 8:00 AM – 8:00 PM, Tuesday: 8:00 AM – 8:00 PM, Wednesday: 8:00 AM – 8:00 PM, Thursday: 8:00 AM – 8:00 PM, Friday: 8:00 AM – 8:00 PM, Saturday: 8:00 AM – 8:00 PM, Sunday: 9:00 AM – 6:00 PM	900	1800	800	2000	800	2000	800	2000	800	2000	800	2000	800	2000	2024-08-09 15:31:42.065914-05	699
420	\N	Monday: 8:00 AM – 6:00 PM, Tuesday: 8:00 AM – 6:00 PM, Wednesday: 8:00 AM – 6:00 PM, Thursday: 8:00 AM – 6:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1800	800	1800	800	1800	800	1800	800	1600	\N	\N	2024-08-09 15:31:42.282284-05	700
421	\N	Monday: 8:00 AM – 6:00 PM, Tuesday: 8:00 AM – 6:00 PM, Wednesday: 8:00 AM – 6:00 PM, Thursday: 8:00 AM – 6:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1800	800	1800	800	1800	800	1800	800	1600	\N	\N	2024-08-09 15:31:42.458583-05	701
422	\N	Monday: 8:00 AM – 6:00 PM, Tuesday: 8:00 AM – 6:00 PM, Wednesday: 8:00 AM – 6:00 PM, Thursday: 8:00 AM – 6:00 PM, Friday: 8:00 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1800	800	1800	800	1800	800	1800	800	1600	\N	\N	2024-08-09 15:31:42.62633-05	702
423	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 9:00 AM – 5:00 PM	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	2024-08-09 15:31:44.074204-05	706
424	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 9:00 AM – 5:00 PM	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	2024-08-09 15:31:44.247107-05	707
425	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	2024-08-09 15:31:45.364484-05	710
426	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 10:00 AM – 6:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	2024-08-09 15:31:46.235597-05	714
427	\N	Monday: 9:00 AM – 7:00 PM, Tuesday: 9:00 AM – 7:00 PM, Wednesday: 9:00 AM – 7:00 PM, Thursday: 9:00 AM – 7:00 PM, Friday: 9:00 AM – 7:00 PM, Saturday: 8:00 AM – 5:00 PM, Sunday: 9:00 AM – 4:00 PM	900	1600	900	1900	900	1900	900	1900	900	1900	900	1900	800	1700	2024-08-09 15:31:46.437025-05	715
428	\N	Monday: 7:00 AM – 8:00 PM, Tuesday: 7:00 AM – 8:00 PM, Wednesday: 7:00 AM – 8:00 PM, Thursday: 7:00 AM – 8:00 PM, Friday: 7:00 AM – 8:00 PM, Saturday: 7:00 AM – 8:00 PM, Sunday: 7:00 AM – 7:00 PM	700	1900	700	2000	700	2000	700	2000	700	2000	700	2000	700	2000	2024-08-09 15:31:46.847101-05	716
429	\N	Monday: 3:30 – 10:00 PM, Tuesday: 3:30 – 10:00 PM, Wednesday: 3:30 – 10:00 PM, Thursday: 3:30 – 10:00 PM, Friday: 11:00 AM – 11:00 PM, Saturday: 11:00 AM – 11:00 PM, Sunday: 11:00 AM – 10:00 PM	1100	2200	1500	2200	1500	2200	1500	2200	1500	2200	1100	2300	1100	2300	2024-08-09 15:31:47.370631-05	719
430	\N	Monday: 9:00 AM – 5:00 PM, Tuesday: 9:00 AM – 5:00 PM, Wednesday: 9:00 AM – 5:00 PM, Thursday: 9:00 AM – 5:00 PM, Friday: 9:00 AM – 5:00 PM, Saturday: 9:00 AM – 5:00 PM, Sunday: 12:00 – 5:00 PM	1200	1700	900	1700	900	1700	900	1700	900	1700	900	1700	900	1700	2024-08-09 15:31:47.626143-05	720
431	\N	Monday: 10:00 AM – 9:00 PM, Tuesday: 10:00 AM – 9:00 PM, Wednesday: 10:00 AM – 9:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 10:00 PM, Saturday: 10:00 AM – 10:00 PM, Sunday: 10:00 AM – 9:00 PM	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2200	1000	2200	2024-08-09 15:31:47.894851-05	721
432	\N	Monday: 10:00 AM – 9:00 PM, Tuesday: 10:00 AM – 9:00 PM, Wednesday: 10:00 AM – 9:00 PM, Thursday: 10:00 AM – 9:00 PM, Friday: 10:00 AM – 10:00 PM, Saturday: 10:00 AM – 10:00 PM, Sunday: 10:00 AM – 9:00 PM	1000	2100	1000	2100	1000	2100	1000	2100	1000	2100	1000	2200	1000	2200	2024-08-09 15:31:48.225161-05	722
433	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:48.478559-05	723
434	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:48.649338-05	724
435	\N	Monday: Closed, Tuesday: 4:00 – 10:00 PM, Wednesday: 4:00 – 10:00 PM, Thursday: 4:00 – 10:00 PM, Friday: 4:00 PM – 12:00 AM, Saturday: 4:00 PM – 12:00 AM, Sunday: Closed	\N	\N	\N	\N	1600	2200	1600	2200	1600	2200	1600	0	1600	0	2024-08-09 15:31:49.093857-05	726
436	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:49.335921-05	727
437	\N	Monday: 6:00 AM – 6:00 PM, Tuesday: 6:00 AM – 6:00 PM, Wednesday: 6:00 AM – 6:00 PM, Thursday: 6:00 AM – 6:00 PM, Friday: 6:00 AM – 6:00 PM, Saturday: 6:00 AM – 6:00 PM, Sunday: 7:00 AM – 5:00 PM	700	1700	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	2024-08-09 15:31:49.717036-05	728
438	\N	Monday: 6:00 AM – 6:00 PM, Tuesday: 6:00 AM – 6:00 PM, Wednesday: 6:00 AM – 6:00 PM, Thursday: 6:00 AM – 6:00 PM, Friday: 6:00 AM – 6:00 PM, Saturday: 6:00 AM – 6:00 PM, Sunday: 6:00 AM – 6:00 PM	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	600	1800	2024-08-09 15:31:49.943214-05	729
440	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:51.101536-05	733
441	\N	Monday: 10:00 AM – 6:00 PM, Tuesday: 10:00 AM – 6:00 PM, Wednesday: 10:00 AM – 6:00 PM, Thursday: 10:00 AM – 6:00 PM, Friday: 10:00 AM – 6:00 PM, Saturday: 9:00 AM – 6:00 PM, Sunday: 11:00 AM – 4:00 PM	1100	1600	1000	1800	1000	1800	1000	1800	1000	1800	1000	1800	900	1800	2024-08-09 15:31:51.328987-05	734
442	\N	Monday: 11:00 AM – 9:00 PM, Tuesday: 11:00 AM – 9:00 PM, Wednesday: 11:00 AM – 9:00 PM, Thursday: 11:00 AM – 9:00 PM, Friday: 11:00 AM – 9:30 PM, Saturday: 11:00 AM – 9:30 PM, Sunday: 11:00 AM – 9:00 PM	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	1100	2100	2024-08-09 15:31:52.447576-05	736
443	\N	Monday: 5:00 AM – 10:00 PM, Tuesday: 5:00 AM – 10:00 PM, Wednesday: 5:00 AM – 10:00 PM, Thursday: 5:00 AM – 10:00 PM, Friday: 5:00 AM – 10:00 PM, Saturday: 5:00 AM – 10:00 PM, Sunday: 5:00 AM – 10:00 PM	500	2200	500	2200	500	2200	500	2200	500	2200	500	2200	500	2200	2024-08-09 15:31:52.6705-05	737
444	\N	Monday: 5:00 AM – 10:00 PM, Tuesday: 5:00 AM – 10:00 PM, Wednesday: 5:00 AM – 10:00 PM, Thursday: 5:00 AM – 10:00 PM, Friday: 5:00 AM – 10:00 PM, Saturday: 5:00 AM – 10:00 PM, Sunday: 5:00 AM – 10:00 PM	500	2200	500	2200	500	2200	500	2200	500	2200	500	2200	500	2200	2024-08-09 15:31:52.829535-05	738
445	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:53.036617-05	739
446	\N	Monday: 7:00 AM – 3:30 PM, Tuesday: 7:00 AM – 3:30 PM, Wednesday: 7:00 AM – 3:30 PM, Thursday: 7:00 AM – 3:30 PM, Friday: 7:00 AM – 3:30 PM, Saturday: Closed, Sunday: Closed	\N	\N	700	1500	700	1500	700	1500	700	1500	700	1500	\N	\N	2024-08-09 15:31:53.257956-05	740
447	\N	Monday: 4:00 – 9:00 PM, Tuesday: 4:00 – 9:00 PM, Wednesday: 3:00 – 10:00 PM, Thursday: 3:00 – 10:00 PM, Friday: 1:00 – 11:00 PM, Saturday: 12:00 – 11:00 PM, Sunday: 12:00 – 9:00 PM	1200	2100	1600	2100	1600	2100	1500	2200	1500	2200	1300	2300	1200	2300	2024-08-09 15:31:53.626558-05	742
448	\N	Monday: 9:00 AM – 4:00 PM, Tuesday: 9:00 AM – 4:00 PM, Wednesday: 9:00 AM – 4:00 PM, Thursday: 9:00 AM – 4:00 PM, Friday: 9:00 AM – 4:00 PM, Saturday: 9:00 AM – 1:00 PM, Sunday: Closed	\N	\N	900	1600	900	1600	900	1600	900	1600	900	1600	900	1300	2024-08-09 15:31:53.847789-05	743
449	\N	Monday: 6:00 AM – 11:00 PM, Tuesday: 6:00 AM – 11:00 PM, Wednesday: 6:00 AM – 11:00 PM, Thursday: 6:00 AM – 11:00 PM, Friday: 6:00 AM – 11:00 PM, Saturday: 6:00 AM – 11:00 PM, Sunday: 6:00 AM – 11:00 PM	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	2024-08-09 15:31:54.072373-05	744
450	\N	Monday: 8:00 AM – 9:00 PM, Tuesday: 8:00 AM – 9:00 PM, Wednesday: 8:00 AM – 9:00 PM, Thursday: 8:00 AM – 9:00 PM, Friday: 8:00 AM – 9:00 PM, Saturday: 8:00 AM – 9:00 PM, Sunday: 8:00 AM – 9:00 PM	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	800	2100	2024-08-09 15:31:54.595391-05	746
451	\N	Monday: 10:00 AM – 4:00 PM, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:30 AM – 12:30 PM	800	1200	1000	1600	1000	1600	1000	1600	1000	1600	\N	\N	\N	\N	2024-08-09 15:31:55.424853-05	750
452	\N	Monday: 10:00 AM – 4:00 PM, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:30 AM – 12:30 PM	800	1200	1000	1600	1000	1600	1000	1600	1000	1600	\N	\N	\N	\N	2024-08-09 15:31:55.581052-05	751
453	\N	Monday: 10:00 AM – 4:00 PM, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:30 AM – 12:30 PM	800	1200	1000	1600	1000	1600	1000	1600	1000	1600	\N	\N	\N	\N	2024-08-09 15:31:55.759138-05	752
454	\N	Monday: 10:00 AM – 4:00 PM, Tuesday: 10:00 AM – 4:00 PM, Wednesday: 10:00 AM – 4:00 PM, Thursday: 10:00 AM – 4:00 PM, Friday: Closed, Saturday: Closed, Sunday: 8:30 AM – 12:30 PM	800	1200	1000	1600	1000	1600	1000	1600	1000	1600	\N	\N	\N	\N	2024-08-09 15:31:55.921521-05	753
455	\N	Monday: 6:00 AM – 11:00 PM, Tuesday: 6:00 AM – 11:00 PM, Wednesday: 6:00 AM – 11:00 PM, Thursday: 6:00 AM – 11:00 PM, Friday: 6:00 AM – 11:00 PM, Saturday: 6:00 AM – 11:00 PM, Sunday: 6:00 AM – 11:00 PM	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	600	2300	2024-08-09 15:31:56.290955-05	754
456	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:56.508489-05	755
457	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 9:00 AM – 8:00 PM, Sunday: 10:00 AM – 6:00 PM	1000	1800	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	900	2000	2024-08-09 15:31:56.718754-05	756
458	\N	Monday: 10:00 AM – 8:00 PM, Tuesday: 10:00 AM – 8:00 PM, Wednesday: 10:00 AM – 8:00 PM, Thursday: 10:00 AM – 8:00 PM, Friday: 10:00 AM – 8:00 PM, Saturday: 10:00 AM – 8:00 PM, Sunday: 11:00 AM – 7:00 PM	1100	1900	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	1000	2000	2024-08-09 15:31:56.944266-05	757
459	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:31:57.60933-05	762
460	\N	Monday: 5:00 AM – 8:30 PM, Tuesday: 5:00 AM – 8:30 PM, Wednesday: 5:00 AM – 8:30 PM, Thursday: 5:00 AM – 8:30 PM, Friday: 5:00 AM – 8:30 PM, Saturday: 5:30 AM – 8:00 PM, Sunday: 5:30 AM – 8:00 PM	500	2000	500	2000	500	2000	500	2000	500	2000	500	2000	500	2000	2024-08-09 15:31:57.888607-05	763
461	\N	Monday: 5:00 AM – 8:30 PM, Tuesday: 5:00 AM – 8:30 PM, Wednesday: 5:00 AM – 8:30 PM, Thursday: 5:00 AM – 8:30 PM, Friday: 5:00 AM – 8:30 PM, Saturday: 5:30 AM – 8:00 PM, Sunday: 5:30 AM – 8:00 PM	500	2000	500	2000	500	2000	500	2000	500	2000	500	2000	500	2000	2024-08-09 15:31:58.080044-05	764
462	\N	Monday: 5:00 AM – 9:00 PM, Tuesday: 5:00 AM – 9:00 PM, Wednesday: 5:00 AM – 9:00 PM, Thursday: 5:00 AM – 9:00 PM, Friday: 5:00 AM – 9:00 PM, Saturday: 6:00 AM – 8:00 PM, Sunday: 8:00 AM – 8:00 PM	800	2000	500	2100	500	2100	500	2100	500	2100	500	2100	600	2000	2024-08-09 15:31:58.458873-05	765
463	\N	Monday: 8:15 AM – 4:00 PM, Tuesday: 8:15 AM – 4:00 PM, Wednesday: 8:15 AM – 4:00 PM, Thursday: 8:15 AM – 4:00 PM, Friday: 8:15 AM – 4:00 PM, Saturday: Closed, Sunday: Closed	\N	\N	800	1600	800	1600	800	1600	800	1600	800	1600	\N	\N	2024-08-09 15:32:00.070429-05	768
464	\N	Monday: 7:00 AM – 10:00 PM, Tuesday: 7:00 AM – 10:00 PM, Wednesday: 7:00 AM – 10:00 PM, Thursday: 7:00 AM – 10:00 PM, Friday: 7:00 AM – 10:00 PM, Saturday: 7:00 AM – 10:00 PM, Sunday: 7:00 AM – 10:00 PM	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	700	2200	2024-08-09 15:32:00.376835-05	770
465	\N	Monday: 9:00 AM – 9:00 PM, Tuesday: 9:00 AM – 9:00 PM, Wednesday: 9:00 AM – 9:00 PM, Thursday: 9:00 AM – 9:00 PM, Friday: 9:00 AM – 9:00 PM, Saturday: 9:00 AM – 9:00 PM, Sunday: 10:00 AM – 7:30 PM	1000	1900	900	2100	900	2100	900	2100	900	2100	900	2100	900	2100	2024-08-09 15:32:00.663821-05	771
466	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: restroom_votes; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public.restroom_votes (id, user_id, restroom_id, upvote, downvote, inserted_at, updated_at) FROM stdin;
1	8	494	5	1	2024-09-17 12:47:55.29727-05	2024-09-17 12:47:55.29727-05
\.


--
-- Data for Name: restrooms; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public.restrooms (id, api_id, name, street, city, state, accessible, unisex, directions, latitude, longitude, created_at, updated_at, country, changing_table, is_removed, is_single_stall, is_multi_stall, is_flagged, place_id) FROM stdin;
1	52278	Mizumi Sushi and Asian Bistro	17629 Cedar Ave	Lakeville	MN	t	t	\N	44.69336	-93.21671	2019-08-30 18:04:17.536-05	2019-08-30 18:04:17.652-05	US	f	f	f	f	f	\N
2	54813	Hirshfield’s	15265 Galaxie Avenue	Apple Valley	MN	f	f	\N	44.72771	-93.208176	2020-01-11 13:37:06.871-06	2020-04-14 16:07:50.234-05	US	f	f	f	f	f	\N
3	53818	Master Kim’s World Class Taekwondo	1815 Radio Dr	Woodbury	MN	t	t	\N	44.92367	-92.93168	2019-11-06 15:34:13.825-06	2019-11-06 15:34:13.939-06	US	f	f	f	f	f	\N
4	56349	Sam’s Club	8201 Old Carriage Ct	Shakopee	MN	f	t	\N	44.781464	-93.4164	2020-07-13 14:37:40.223-05	2020-07-13 14:37:40.369-05	US	t	f	f	f	f	\N
5	62697	Ben and Jerry's ice cream shop 	539 Lake Street East	Wayzata	MN	f	t	\N	44.96987	-93.513695	2022-07-12 10:06:57.662-05	2022-07-12 10:06:57.749-05	US	t	f	t	f	f	\N
6	38242	Lunds and Byerlys	5159 west 98th st	Bloomington	MN	t	t	\N	44.823936	-93.34923	2017-10-19 07:42:12.194-05	2017-10-19 07:42:12.194-05	US	f	f	f	f	f	\N
7	24596	Noodles and Company	1590 S Robert St	West St. Paul	MN	t	f	\N	44.898266	-93.08004	2016-08-07 17:09:24.22-05	2016-08-07 17:09:24.22-05	US	f	f	f	f	f	\N
8	37008	Bruegger’s Bagels	4000 Annapolis Ln N 109, Plymouth, MN 55447	Plymouth	MN	f	f	\N	45.028687	-93.45585	2017-08-16 10:57:06.389-05	2017-08-16 10:57:06.389-05	US	f	f	f	f	f	\N
9	20946	Face to Face Health and Counseling	1165 arcade st	St. Paul 	MN	t	t	\N	44.97629	-93.06637	2016-03-31 11:07:12.922-05	2016-03-31 11:07:12.922-05	US	f	f	f	f	f	\N
10	40244	Amore cafe	Smith	West St. Paul	MN	t	t	\N	44.91611	-93.10178	2018-03-03 19:09:35.35-06	2018-03-03 19:09:35.35-06	US	f	t	f	f	f	\N
11	54419	Total Wine and More	4260 W. 78TH St	Bloomington	MN	t	t	\N	44.859276	-93.33252	2019-12-12 06:42:27.702-06	2020-04-14 16:04:58.761-05	US	t	t	t	f	f	\N
12	55019	Total Wine and More Bloomington	4260 W. 78TH St	Bloomington	MN	t	t	\N	44.859276	-93.33252	2020-01-26 05:32:24.562-06	2020-04-14 16:00:40.929-05	US	t	f	t	f	f	\N
13	2391	Nina's Coffee Café	165 Western Avenue North	St. Paul	MN	t	f	\N	44.946384	-93.11633	2014-02-02 14:52:23.911-06	2014-04-12 20:25:42.828-05	US	f	f	f	f	f	\N
14	35030	Barnes and Noble in Edina Galleria	France Ave S and 69th Street	Edina	MN	f	f	\N	44.87807	-93.329094	2017-05-13 09:40:27.864-05	2017-05-13 09:40:27.864-05	US	f	f	f	f	f	\N
15	35395	Dave and Buster's	500 Southdale Center	Edina	MN	f	t	\N	44.88076	-93.32662	2017-05-29 16:03:55.652-05	2017-05-29 16:03:55.652-05	US	f	f	f	f	f	\N
16	57773	Bruegger’s Bagels	800 Grand Ave	St. Paul	MN	t	t	\N	44.939766	-93.133675	2021-05-19 12:14:34.148-05	2021-05-19 12:14:34.24-05	US	f	f	f	f	f	\N
17	51666	Arc’s Value Village	6528 Penn Ave S	Minneapolis	MN	t	t	\N	44.884453	-93.30939	2019-08-07 14:04:38.975-05	2019-08-07 14:04:38.994-05	US	t	f	f	f	f	\N
18	5791	J S Bean Factory	1518 Randolph Avenue	St. Paul	MN	t	t	\N	44.92671	-93.16428	2014-04-20 21:34:05.858-05	2014-04-20 21:34:05.858-05	US	f	f	t	f	f	\N
19	67154	Noodles and Co	County Road B2	Roseville 	MN	t	t	\N	45.006077	-93.15661	2023-08-26 18:54:37.95-05	2023-08-26 18:54:38.072-05	US	f	f	f	f	f	\N
20	52304	Bull’s Horn	4563 34th Ave S	Minneapolis	MN	t	t	\N	44.919933	-93.222664	2019-08-31 22:10:36.106-05	2019-08-31 22:10:36.129-05	US	f	f	f	f	f	\N
21	36193	Egg and I restaurant	2550 University Ave W	St. Paul	MN	t	f	\N	44.965805	-93.20306	2017-07-04 11:02:47.246-05	2017-07-04 11:02:47.246-05	US	f	f	f	f	f	\N
22	39433	Marla’s Caribbean Cuisine	Marla's Caribbean Cuisine 3761 Bloomington Ave	Minneapolis	MN	t	t	\N	44.934242	-93.25213	2018-01-13 14:32:01.668-06	2018-01-13 14:32:01.668-06	US	f	f	f	f	f	\N
23	41331	Pat’s Tap	3510 Nicollet Ave	Minneapolis	MN	t	f	\N	44.939217	-93.278305	2018-05-13 17:32:17.143-05	2018-05-13 17:32:17.143-05	US	t	f	f	f	f	\N
24	19238	Lunds and Byerlys Lake Street	1450 W Lake Street	Minneapolis	MN	t	f	\N	44.948673	-93.299965	2015-11-10 14:57:25.826-06	2015-11-10 14:57:25.826-06	US	f	f	t	f	f	\N
25	42249	Twin Cities Leather and Latte	2717 Hennepin Ave	Minneapolis	MN	f	t	\N	44.953094	-93.29748	2018-07-05 15:56:31.99-05	2018-07-05 15:56:31.99-05	US	f	t	f	f	f	\N
26	23902	Giordano’s	2700 Hennepin Ave	Minneapolis	MN	t	f	\N	44.953545	-93.29804	2016-07-08 12:15:01.412-05	2016-07-08 12:15:01.412-05	US	f	f	f	f	f	\N
27	4794	French Meadow Bakery and Cafe	2610 Lyndale Avenue South	Minneapolis	MN	t	t	\N	44.955	-93.28843	2014-02-10 11:11:16.879-06	2014-02-10 11:11:16.879-06	US	f	f	f	f	f	\N
28	52702	Fletcher’s	1509 Marshall St NE	Minneapolis	MN	t	t	\N	45.003117	-93.27083	2019-09-13 07:23:02.172-05	2019-09-13 07:23:02.273-05	US	t	f	f	f	f	\N
29	27415	Anchor Fish and Chips	302 13th Ave NE	Minneapolis	MN	t	t	\N	45.000767	-93.26434	2017-01-10 21:02:20.065-06	2017-01-10 21:02:20.065-06	US	f	f	f	f	f	\N
30	4714	University of Minnesota, TC	224 Church Street, Ford Hall 4th Fl.	Minneapolis	MN	t	t	\N	44.983334	-93.26667	2014-02-09 00:07:02.827-06	2024-03-22 15:18:12.991189-05	US	f	f	f	f	f	EkBGb3JkIEhhbGwsIDIyNCBDaHVyY2ggU3QgU0UgSGFsbCA0dGgsIE1pbm5lYXBvbGlzLCBNTiA1NTQ1NSwgVVNBIiQaIgoWChQKEgnH-nIUFi2zUhFaz5scyTaB7xIISGFsbCA0dGg
31	21740	The Source	1601 Snelling Avenue N	Roseville	MN	t	t	\N	45.02285	-93.165886	2016-04-30 12:36:41.948-05	2016-04-30 12:36:41.948-05	US	f	f	t	f	f	EjIxNjAxIFNuZWxsaW5nIEF2ZSBOLCBGYWxjb24gSGVpZ2h0cywgTU4gNTUxMDgsIFVTQSIxEi8KFAoSCU_c5yp0K7NSEXcoZ4c0y0phEMEMKhQKEglzybNOFyr2hxHCqgGV0wfCdw
32	43381	330 2nd Ave S, 4th Floor	330 2nd Ave S.	Minneapolis	MN	t	t	\N	44.979225	-93.266945	2018-09-04 12:00:57.754-05	2018-09-04 12:00:57.754-05	US	f	f	f	f	f	EjczMzAgMm5kIEF2ZSBTIDR0aCBGbG9vciAzMzAsIE1pbm5lYXBvbGlzLCBNTiA1NTQwMSwgVVNBIikaJwoWChQKEglJ2Yt-mzKzUhGpRq4cR5oMshINNHRoIEZsb29yIDMzMA
33	17393	Mississippi National River and Recreation Area, 2462 Childs Road, Saint Paul, MN 55106, USA	2500 Child's Road	St. Paul	MN	t	t	\N	44.922928	-93.049164	2015-05-08 11:28:47.785-05	2015-05-08 11:28:47.785-05	US	f	f	f	f	f	EiYyNDYyIENoaWxkcyBSZCwgU3QgUGF1bCwgTU4gNTUxMDYsIFVTQSIxEi8KFAoSCXO7oQmu1feHEUkhesY3m7JBEJ4TKhQKEgl37PbFpdX3hxEB-VHPzEyOgw
34	36796	Century College	3410 E County Line N	White Bear Lake 	MN	t	t	\N	45.04982	-92.98419	2017-08-03 15:00:00.91-05	2017-08-03 15:00:00.91-05	US	t	f	f	f	f	EiwzNDEwIEUgQ291bnR5IExpbmUgTiwgU3QgUGF1bCwgTU4gNTUxMTAsIFVTQSIxEi8KFAoSCbPmEHme0bJSEZmhsl2f8PFsENIaKhQKEglnczHrqNGyUhF5BGVJQoII6w
35	3584	Holiday	Highway 12/394 and County Road 19	Maple Plain	MN	f	f	\N	45.00755	-93.65461	2014-02-02 14:54:13.381-06	2014-02-02 14:54:13.381-06	US	f	f	f	f	f	EiwxMiBDb3VudHkgUmQgMTksIEluZGVwZW5kZW5jZSwgTU4gNTUzNTksIFVTQSIwEi4KFAoSCX0sWYKdU7NSEcf8_4SU34k9EAwqFAoSCZnp05iOWrNSEVtiHhbgucRg
36	62139	Cycle gear 	10 southdale center ste 1975	Edina	MN	f	t	\N	44.8805	-93.32525	2022-05-21 16:09:59.414-05	2022-05-21 16:09:59.579-05	US	f	f	f	f	f	EiwxMCBTb3V0aGRhbGUgQ3RyICMxOTc1LCBFZGluYSwgTU4gNTU0MzUsIFVTQSIgGh4KFgoUChIJ2XonkKYm9ocRq39uj-sbcjgSBDE5NzU
37	40007	Punch Pizza	8003 City Center Drive	Woodbury	MN	t	t	\N	44.920082	-92.93701	2018-02-18 19:30:54.755-06	2018-02-18 19:30:54.755-06	US	f	f	f	f	f	Eiw4MDAzIENpdHkgQ2VudHJlIERyLCBXb29kYnVyeSwgTU4gNTUxMjUsIFVTQSIxEi8KFAoSCZsOmAXW2feHEeJ_gG5he6YSEMM-KhQKEgnT9Vc01Nn3hxHWCzk9zbCvpQ
38	28579	Carnegie Hall of Sciences (Macalester College)	139 S Macalester Street	St. Paul	MN	f	t	\N	44.938446	-93.169556	2017-02-24 08:35:36.142-06	2017-02-24 08:35:36.142-06	US	f	t	f	f	f	EisxMzkgUyBNYWNhbGVzdGVyIFN0LCBTdCBQYXVsLCBNTiA1NTEwNSwgVVNBIjESLwoUChIJ8UxuaRgq9ocRtmhUn10PvCsQiwEqFAoSCU1vQG8lKvaHEQ1VUYxk2ReS
39	28578	Carnegie Hall of Sciences (Macalester College)	139 S Macalester Street	St. Paul	MN	f	t	\N	44.938446	-93.169556	2017-02-24 08:35:35.994-06	2017-02-24 08:35:35.994-06	US	f	f	f	f	f	EisxMzkgUyBNYWNhbGVzdGVyIFN0LCBTdCBQYXVsLCBNTiA1NTEwNSwgVVNBIjESLwoUChIJ8UxuaRgq9ocRtmhUn10PvCsQiwEqFAoSCU1vQG8lKvaHEQ1VUYxk2ReS
40	46940	The Corner Store (gas station)	5699 division st. N	Oakdale 	MN	f	t	\N	45.030838	-92.9841	2019-01-11 18:18:34.755-06	2019-01-11 18:18:34.896-06	US	f	f	t	f	f	Eio1Njk5IERpdmlzaW9uIFN0IE4sIE9ha2RhbGUsIE1OIDU1MTI4LCBVU0EiMRIvChQKEgmtxaSqLNKyUhFkrJoriqp4aBDDLCoUChIJkYn-FrXTslIRe9wXQdb2QfI
41	51425	Black coffee waffle bar	2108 Marshall Avenue	St. Paul 	MN	f	t	\N	44.948383	-93.18942	2019-07-31 11:47:06.058-05	2019-07-31 11:47:06.112-05	US	t	t	f	f	f	EikyMTA4IE1hcnNoYWxsIEF2ZSwgU3QgUGF1bCwgTU4gNTUxMDQsIFVTQSIxEi8KFAoSCR9-FRzlKfaHEboit5NBwvtuELwQKhQKEgnRNqFgcir2hxFmQGi5zf7K3w
42	26653	Republic 	225 Cedar Ave	Minneapolis	MN	f	t	\N	44.972897	-93.24734	2016-11-21 18:15:36.03-06	2016-11-21 18:15:36.03-06	US	f	f	f	f	f	EikyMjUgQ2VkYXIgQXZlLCBNaW5uZWFwb2xpcywgTU4gNTU0NTQsIFVTQSIxEi8KFAoSCevzrddpLbNSEUVCNbWW-IBUEOEBKhQKEglXxFvWWjD2hxE5vUEwCF-2VQ
43	31883	Eastside Food Co-op	2655 Central Avenue	Minneapolis	MN	f	f	\N	45.016457	-93.247345	2017-02-27 20:39:26.475-06	2017-02-27 20:39:26.475-06	US	f	t	t	f	f	Ei8yNjU1IENlbnRyYWwgQXZlIE5FLCBNaW5uZWFwb2xpcywgTU4gNTU0MTgsIFVTQSIxEi8KFAoSCftvgq_pLbNSEXe6dU_1nJNuEN8UKhQKEgl5LZ2vRi6zUhGNSyP4tI59NQ
44	65646	Caribou Coffee	13250 Grove Dr Suite 2	Maple Grove	MN	t	t	\N	45.10423	-93.448586	2023-05-13 10:01:08.907-05	2023-05-13 10:01:09.014-05	US	f	f	f	f	f	Ei0xMzI1MCBHcm92ZSBEciAjMiwgTWFwbGUgR3JvdmUsIE1OIDU1MzY5LCBVU0EiHRobChYKFAoSCXPHhtPkR7NSEf5e--lXDdMyEgEy
45	42802	Legal Aid	430 1st, Suite 300	Minneapolis	MN	f	f	\N	44.98087	-93.273575	2018-08-06 10:07:42.207-05	2018-08-06 10:07:42.207-05	US	t	f	f	f	f	Ei00MzAgTiAxc3QgU3QgIzMwMCwgTWlubmVhcG9saXMsIE1OIDU1NDAxLCBVU0EiHxodChYKFAoSCYFmzTyGMrNSER7eVIMXUc_uEgMzMDA
46	52459	Starbucks 	420 Minnetonka Blvd	St. Louis Park	MN	t	t	\N	44.903137	-93.5591	2019-09-10 15:27:38.594-05	2019-09-10 15:27:38.711-05	US	f	f	f	f	f	Ei00MjAgTWlubmV0b25rYSBCbHZkLCBFeGNlbHNpb3IsIE1OIDU1MzMxLCBVU0EiMRIvChQKEglHj3rS4Bz2hxGlWAtBCBiblxCkAyoUChIJ5UTgNLkf9ocR3me-hja-rTI
47	40830	Target	W 141st st	Burnsville 	MN	t	t	\N	44.74963	-93.29656	2018-04-08 14:39:01.4-05	2020-04-14 16:20:44.188-05	US	t	f	f	f	f	Eh9XIDE0MXN0IFN0LCBCdXJuc3ZpbGxlLCBNTiwgVVNBIi4qLAoUChIJw2DZYZQ79ocRKQs4-ZMR1icSFAoSCZ17-rhfOvaHEdSKEsn-OFOz
48	33680	Linden Hills Library	2900 W. 43rd Street	Minneapolis	MN	t	t	\N	44.92503	-93.31646	2017-04-06 14:32:33.304-05	2017-04-06 14:32:33.304-05	US	f	f	f	f	f	ChIJZZvfnhcn9ocRsGkOpmr0znA
49	28955	Blick Art Materials	2389 Fairview Ave N	Roseville	MN	t	t	\N	45.012447	-93.177925	2017-02-24 17:02:59.761-06	2017-02-24 17:02:59.761-06	US	f	f	t	f	f	ChIJzWg5IfMrs1IRwSa6XBnOlqw
50	46617	Blick Art Materials	2389 Fairview Ave N	Roseville 	MN	f	f	\N	45.01233	-93.17798	2018-12-24 11:10:11.15-06	2018-12-24 11:10:11.272-06	US	f	t	f	f	f	ChIJzWg5IfMrs1IRwSa6XBnOlqw
51	3839	Dunn Brothers Coffee	228 N Washington Ave	Minneapolis	MN	f	f	\N	44.98433	-93.27222	2014-02-02 14:54:38.603-06	2014-02-02 14:54:38.603-06	US	f	f	f	f	f	ChIJzTO9YY8ys1IRt6JRZFk5YyU
52	32911	St Genevive	5003 Bryant Ave S	Minneapolis	MN	t	t	\N	44.912132	-93.290695	2017-03-02 17:29:29.801-06	2017-03-02 17:29:29.801-06	US	f	f	t	f	f	ChIJzSAXTFIm9ocREO9e2x0wjqc
53	22307	Saint Genevive 	5003 Bryant Ave S	Minneapolis	MN	t	t	\N	44.912155	-93.2908	2016-05-25 23:14:59.188-05	2016-05-25 23:14:59.188-05	US	f	t	f	f	f	ChIJzSAXTFIm9ocREO9e2x0wjqc
54	22306	Saint Genevive 	5003 Bryant Ave S	Minneapolis	MN	t	t	\N	44.912155	-93.2908	2016-05-25 23:14:57.232-05	2016-05-25 23:14:57.232-05	US	f	f	f	f	f	ChIJzSAXTFIm9ocREO9e2x0wjqc
55	22879	Boynton Health Services, University of Minnesota	410 Church St SE	Minneapolis	MN	t	t	\N	44.972103	-93.234474	2016-06-13 13:58:30.338-05	2016-06-13 13:58:30.338-05	US	f	f	f	f	f	ChIJZRvckj0ts1IRm6YWYp9qZr4
56	17709	Hosmer Library	347 E 36th St	Minneapolis	MN	t	f	\N	44.937393	-93.270546	2015-06-11 15:33:08.021-05	2024-03-27 06:17:45.198398-05	US	f	t	t	f	f	ChIJ_zIV--gn9ocR7NLiJGMtHpw
57	3792	Hosmer Library	347 E. 36th St.	Minneapolis	MN	t	f	\N	44.937744	-93.27098	2014-02-02 14:54:35.469-06	2014-02-02 14:54:35.469-06	US	f	f	t	f	f	ChIJ_zIV--gn9ocR7NLiJGMtHpw
58	46471	530 University Ave SE, Minneapolis, MN 55414, USA	530 University Ave SE	Minneapolis	MN	t	t	\N	44.983784	-93.24811	2018-12-15 18:34:00.83-06	2018-12-15 18:34:00.9-06	US	t	f	f	f	f	ChIJZfYEo3Ets1IRiGbz5QqPigg
59	25386	Dunn Brothers Coffee	2180 Hamline Ave N	Roseville	MN	t	t	\N	45.007477	-93.15577	2016-09-07 10:32:35.802-05	2016-09-07 10:32:35.802-05	US	f	f	f	f	f	ChIJzfms2rsrs1IRKx8Zt7psDoc
60	3211	The Loft Literary Center	1011 Washington Avenue S	Minneapolis	MN	t	t	\N	44.9758	-93.25432	2014-02-02 14:53:39.685-06	2014-02-02 14:53:39.685-06	US	f	f	f	f	f	ChIJZfg372Yts1IRw8XhjnHQeP0
61	23337	Cuppa Java	411 Cedar Lake Rd S	Minneapolis	MN	t	f	\N	44.973244	-93.30888	2016-06-18 01:04:30.666-05	2016-06-18 01:04:30.666-05	US	f	f	f	f	f	ChIJzf8SBhkzs1IR42Wbp5z166c
62	40901	Arc's Value Village	6330 Brooklyn Blvd	Brooklyn Center	MN	t	f	\N	45.069954	-93.32604	2018-04-11 20:04:09.474-05	2020-04-14 16:21:01.248-05	US	t	f	f	f	f	ChIJzd5OR-Qws1IRzISV_ieQ_KA
63	17720	Nokomis Library	5100 34th Avenue South	Minneapolis	MN	t	t	\N	44.910534	-93.22336	2015-06-12 11:47:21.855-05	2015-06-12 11:47:21.855-05	US	f	f	f	f	f	ChIJzchaf_wo9ocRtZ_VIBcSKfI
64	34546	Woodbury East Super Target	449 Commerce Dr.	Woodbury	MN	t	f	\N	44.93986	-92.909485	2017-04-24 22:48:01.976-05	2017-04-24 22:48:01.976-05	US	f	f	f	f	f	ChIJzbxpyEPY94cRKgiqRF9V8ho
65	16250	Omnium Bike Shop	520 Selby Ave	St. Paul	MN	f	f	\N	44.946377	-93.122284	2015-03-07 09:18:53.994-06	2015-03-07 09:18:53.994-06	US	f	f	f	f	f	ChIJZb2uMZcq9ocRnYkFVh5UcuI
66	31947	McNally Smith College of Music 	19 E Exchange St	St. Paul	MN	t	t	\N	44.94931	-93.0972	2017-02-27 22:28:45.26-06	2017-02-27 22:28:45.26-06	US	f	f	f	f	f	ChIJzaJDtFLV94cRJGuf6DhhBzk
67	35486	Starbucks	3939 W 50th St	Minneapolis	MN	t	t	\N	44.912243	-93.330414	2017-06-02 18:16:49.358-05	2017-06-02 18:16:49.358-05	US	f	f	f	f	f	ChIJZ9foqdcm9ocRef9J5VfXybM
68	66642	Toppers Pizza	1539 Larpenteur Ave W	Falcon Heights	MN	t	t	\N	44.99208	-93.16492	2023-07-18 00:01:49.3-05	2023-07-18 00:01:49.391-05	US	f	f	f	f	f	ChIJz8CcunUrs1IRYV_d2FBGwCE
69	58597	The Lynhall	3945 Market Street	Edina	MN	t	t	\N	44.913292	-93.33076	2021-07-31 17:15:39.992-05	2021-07-31 17:15:40.35-05	US	f	f	f	f	f	ChIJz8AHx9cm9ocRDldNbSREyRs
70	42633	Sweet Chow	116 North 1st Ave	Minneapolis	MN	t	t	\N	44.984146	-93.26878	2018-07-29 02:18:58.776-05	2018-07-29 02:18:58.776-05	US	f	f	f	f	f	ChIJz_88UIQys1IRkZE0WvdQOQQ
71	60646	School of Environmental studied	12155 Johnny Cake Ridge Rd.	Apple Valley	MN	f	f	\N	44.7721	-93.19091	2021-12-21 21:37:39.27-06	2021-12-21 21:37:39.709-06	US	f	f	f	f	f	ChIJz4n1YZwx9ocRJjZOg7FXByE
72	49427	Twin Spirits Distillery	2931 Central Ave NE	Minneapolis	MN	f	t	\N	45.02129	-93.24682	2019-04-27 18:01:01.593-05	2019-04-27 18:01:01.632-05	US	f	f	t	f	f	ChIJz2Ykmects1IR0TwN_mqk2Lk
73	22992	Eden Prairie Library	565 Prairie Center Dr.	Eden Prairie	MN	t	t	\N	44.850227	-93.42822	2016-06-14 13:43:54.985-05	2020-04-14 16:14:03.309-05	US	f	t	f	f	f	ChIJYzxxI5oY9ocRB2ZrFCje2k0
74	17770	Eden Prairie Library	565 Prairie Center Drive	Eden Prairie 	MN	t	t	\N	44.85034	-93.42808	2015-06-16 15:42:19.563-05	2015-06-16 15:42:19.563-05	US	f	f	f	f	f	ChIJYzxxI5oY9ocRB2ZrFCje2k0
75	55611	Big River Pizza 	280 5th St E	St. Paul	MN	t	t	\N	44.949707	-93.08585	2020-02-22 13:55:09.895-06	2020-04-14 16:08:27.43-05	US	t	f	f	f	f	ChIJyZRPntgm9ocRU1m9gXu7J0U
76	34427	Ridgedale Center	12401 Wayzata Blvd.	Minnetonka 	MN	t	t	\N	44.96833	-93.437614	2017-04-22 16:49:16.538-05	2017-04-22 16:49:16.538-05	US	f	f	f	f	f	ChIJyYOEwJRKs1IRTWC9Ybw2_EQ
77	47276	Super Target	15560 Pilot Knob Road	Apple Valley	MN	t	t	\N	44.723732	-93.175095	2019-02-01 14:33:36.55-06	2019-02-11 23:41:56.514-06	US	t	f	f	f	f	ChIJYYFeGQM09ocRDOn8dlgtzC4
78	33168	Phoenix theater 	2605 Hennepin ave	Minneapolis	MN	f	t	\N	44.955246	-93.29656	2017-03-27 21:30:36.693-05	2017-03-27 21:30:36.693-05	US	f	t	f	f	f	ChIJy_xhrNUys1IRwK7cZ5lEjYU
79	33163	Phoenix Theater	2605 Hennepin ave	Minneapolis	MN	f	t	\N	44.955246	-93.29656	2017-03-27 20:35:09.209-05	2017-03-27 20:35:09.209-05	US	f	f	t	f	f	ChIJy_xhrNUys1IRwK7cZ5lEjYU
80	34681	Phoenix Theater	Hennepin Ave	Minneapolis	MN	f	t	\N	44.965183	-93.28859	2017-04-29 19:30:16.896-05	2017-04-29 19:30:16.896-05	US	f	t	f	f	f	ChIJy_xhrNUys1IRwK7cZ5lEjYU
81	23713	Burgers and bottles 	1278 Lone Oak Road	Eagan	MN	t	t	\N	44.847862	-93.15584	2016-06-30 00:35:49.789-05	2016-06-30 00:35:49.789-05	US	f	f	f	f	f	ChIJyWCsSUos9ocRoQaiLGNs5rY
82	37010	Muddy Waters	2933 Lyndale Avenue	Minneapolis	MN	t	t	\N	44.949215	-93.287735	2017-08-16 11:44:03.603-05	2017-08-16 11:44:03.603-05	US	f	t	f	f	f	ChIJyVGjvYgn9ocRuYIDy8mPU40
83	25818	Muddy Waters	2933 lyndale ave south	Minneapolis	MN	t	t	\N	44.949226	-93.287704	2016-10-11 06:54:08.111-05	2016-10-11 06:54:08.111-05	US	f	f	f	f	f	ChIJyVGjvYgn9ocRuYIDy8mPU40
84	223	urban bean coffeeshop	3255 Bryant Ave South	Minneapolis	MN	f	t	\N	44.943714	-93.290504	2014-02-02 14:49:21.191-06	2014-02-02 14:49:21.191-06	US	f	f	f	f	f	ChIJyQkI0Zon9ocRJEdNAmulZcA
85	35130	Revival St. Paul	525 Selby Ave	St. Paul	MN	t	t	\N	44.946697	-93.12236	2017-05-18 19:07:10.068-05	2017-05-18 19:07:10.068-05	US	t	f	f	f	f	ChIJyQ_GNpcq9ocRb42pWUUZPug
86	62133	Revival	Selby Avenue	St. Paul	MN	f	f	\N	44.946632	-93.15172	2022-05-21 11:30:16.858-05	2022-05-21 11:30:16.978-05	US	f	t	t	f	f	ChIJyQ_GNpcq9ocRb42pWUUZPug
88	27430	Plant growth facilities (west)	1552 Gortner	Falcon Heights 	MN	f	t	\N	44.987896	-93.18118	2017-01-12 14:28:24.543-06	2017-01-12 14:28:24.543-06	US	f	f	f	f	f	ChIJYeljAH4rs1IRkzzy9iD7xOU
89	17721	Roosevelt Library	4026 28th Avenue South	Minneapolis	MN	t	t	\N	44.929585	-93.23249	2015-06-12 11:50:21.813-05	2015-06-12 11:50:21.813-05	US	f	f	f	f	f	ChIJYda3bUQo9ocRomDpIq4LZLg
90	18104	Bloomington Aquatic Center	301 E 90th St, Bloomington, MN 55420	Bloomington	MN	t	t	\N	44.840706	-93.27275	2015-07-27 12:38:23.597-05	2015-07-27 12:38:23.597-05	US	f	f	f	f	f	ChIJYbuXTs0l9ocR2D5tkh3_pd4
91	45100	Walmart	1360 Town Centre Dr	Eagan	MN	f	t	\N	44.828487	-93.16195	2018-10-12 12:33:54.751-05	2020-04-14 16:11:06.815-05	US	f	f	f	f	f	ChIJY2sNbsEt9ocRvL-XVJT00aM
92	22904	Kowalski's Market	1261 Grand Ave	St. Paul	MN	f	f	\N	44.940426	-93.153336	2016-06-13 17:57:33.227-05	2016-06-13 17:57:33.227-05	US	f	f	f	f	f	ChIJy0m7Mmoq9ocRkR4uy02rQGs
93	46366	Lakeville Advanced Dental Care	17600 Cedar Ave	Lakeville	MN	t	t	\N	44.693554	-93.21826	2018-12-09 09:47:31.978-06	2018-12-09 09:47:32.102-06	US	f	f	f	f	f	ChIJXZu7HAA39ocR2EWzfOupDyU
94	37925	Foss Center	625 22nd Ave S	Minneapolis	MN	f	t	\N	44.96656	-93.240265	2017-09-26 20:50:34.779-05	2017-09-26 20:50:34.779-05	US	f	f	f	f	f	ChIJXW4vZEcts1IREQKIMXvKEqg
95	18308	Punch Pizza	769 Grand Avenue	St. Paul	MN	f	t	\N	44.94018	-93.13263	2015-08-09 18:14:07.166-05	2015-08-09 18:14:07.166-05	US	f	f	t	f	f	ChIJxVlTg4wq9ocRVJPjoNfa8bY
96	61311	Rockler woodworking and Hardware 	2020 County Rd 42 W	Burnsville	MN	f	t	\N	44.747986	-93.3049	2022-03-06 21:06:33.014-06	2022-03-06 21:06:33.104-06	US	f	f	f	f	f	ChIJXUDR_Mk79ocRQFGsTu3VxfM
97	53047	Holiday Station Store	4540 Centerville Road	White Bear Lake	MN	f	t	\N	45.078705	-93.05533	2019-09-27 09:46:52.36-05	2019-09-27 09:46:52.517-05	US	f	f	f	f	f	ChIJxQHlLhrXslIRtkw8If5U0Ws
98	28793	Boston Scientific	7 Quality Drive	Arden Hills	MN	t	t	\N	45.068214	-93.148415	2017-02-24 13:56:04.734-06	2017-02-24 13:56:04.734-06	US	f	f	f	f	f	ChIJXQD4wKops1IR-0mskUdT348
99	66163	Key West Bistro	2803 E 38th Street	Minneapolis	MN	t	t	\N	44.93393	-93.231735	2023-06-13 22:38:11.41-05	2023-06-13 22:38:11.52-05	US	f	f	f	f	f	ChIJxdSxiAkp9ocRxitQFKdlWH4
100	45683	Apple Uptown 	3018 Hennepin Ave	Minneapolis	MN	t	t	\N	44.947704	-93.29863	2018-11-06 20:24:42.839-06	2020-04-14 16:29:41.859-05	US	f	f	f	f	f	ChIJxb2PAYIn9ocRvqLpjrgUAhg
101	35732	Potbelly Samdwich Shop	3833 Lexington Ave N	Arden Hills	MN	t	f	\N	45.056892	-93.14772	2017-06-13 14:21:55.776-05	2017-06-13 14:21:55.776-05	US	f	f	f	f	f	ChIJx9Icdqcps1IRwg9luMTivvw
102	26426	Super Target	14333 Hwy 13	Savage	MN	t	t	\N	44.74413	-93.37697	2016-11-12 08:07:34.221-06	2016-11-12 08:07:34.221-06	US	f	f	f	f	f	ChIJx8umyco99ocRVvpZXmIPxbo
103	52211	Mounds Theatre	1029 Hudson Rd	St. Paul	MN	t	t	\N	44.952465	-93.05695	2019-08-27 04:47:03.319-05	2019-08-27 04:47:03.429-05	US	f	f	f	f	f	ChIJx83bYoLV94cRCC8DyPHmLL0
104	16834	Modern Times Cafe	3200 Chicago Ave	Minneapolis	MN	t	t	\N	44.944576	-93.26293	2015-03-21 02:21:12.543-05	2024-03-25 16:40:02.738564-05	US	f	f	f	f	f	ChIJX77Drvwn9ocRw5H5MQNMvig
105	44036	Modern Times Cafe	3200 Chicago Ave S	Minneapolis	MN	t	t	\N	44.944622	-93.26288	2018-09-13 23:33:26.18-05	2020-04-14 16:27:05.679-05	US	t	t	f	f	f	ChIJX77Drvwn9ocRw5H5MQNMvig
106	44035	Modern Times Cafe	3200 Chicago Ave S	Minneapolis	MN	t	t	\N	44.944622	-93.26288	2018-09-13 23:32:27.739-05	2020-04-14 16:27:05.623-05	US	t	t	f	f	f	ChIJX77Drvwn9ocRw5H5MQNMvig
107	2169	Homewood Studios	2400 Plymouth Ave N	Minneapolis	MN	t	t	\N	44.991787	-93.311005	2014-02-02 14:52:06.719-06	2014-02-02 14:52:06.719-06	US	f	f	f	f	f	ChIJ-x74Vagzs1IRoTDjC6h_0_Y
108	2037	The Wedge Coop	2105 Lyndale Ave S	Minneapolis	MN	f	t	\N	44.96154	-93.28786	2014-02-02 14:51:54.722-06	2014-02-07 13:43:16.557-06	US	f	t	f	f	f	ChIJX5ttms8ys1IRLZImDorKVcs
109	57480	The Wedge Coop	2105 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.96134	-93.28756	2021-03-29 14:56:08.378-05	2021-03-29 14:56:08.484-05	US	f	f	f	f	f	ChIJX5ttms8ys1IRLZImDorKVcs
110	21265	Winner Gas Station	4545-4599 4th Ave S	Minneapolis	MN	t	t	\N	44.919716	-93.270226	2016-04-10 12:33:42.664-05	2016-04-10 12:33:42.664-05	US	f	f	f	f	f	ChIJx4aZ3M0n9ocR5B2LqBXCWNM
111	26433	Wedge Community Co-op	2105 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.96128	-93.28759	2016-11-12 10:00:14.32-06	2016-11-12 10:00:14.32-06	US	f	f	f	f	f	ChIJWyNGhc8ys1IRla3uGLAVVQA
112	54518	Whole Foods bathroom 	Selby Avenue	St. Paul	MN	f	t	\N	44.946632	-93.15172	2019-12-23 10:09:49.586-06	2020-04-14 16:05:52.611-05	US	f	t	f	f	f	ChIJwY0xRx4q9ocR2VfRsdqmRSE
113	54636	Whole Foods Market	Snelling/Selby	St. Paul	MN	t	t	\N	44.946575	-93.167	2020-01-01 12:43:47.763-06	2020-04-14 16:06:42.267-05	US	f	f	t	f	f	ChIJwY0xRx4q9ocR2VfRsdqmRSE
114	3842	Starbucks 	1062 Grand Avenue	St. Paul	MN	f	f	\N	44.939842	-93.14501	2014-02-02 14:54:39.146-06	2014-02-02 14:54:39.146-06	US	f	f	f	f	f	ChIJwVu5D2cq9ocRIM3J74jDl4Y
115	43657	Northwestern Health Science University Clinic	W 84th Street	Bloomington	MN	t	t	\N	44.851685	-93.320595	2018-09-10 21:50:56.131-05	2018-09-10 21:50:56.131-05	US	f	f	f	f	f	ChIJwSzUdc1OVEAR7BzUmkxzFNI
116	31087	Snap Fitness	2216 County Rd D West, St Paul, MN 55112	Roseville	MN	t	t	\N	45.034702	-93.19386	2017-02-26 20:12:07.329-06	2017-02-26 20:12:07.329-06	US	f	f	f	f	f	ChIJ-Wlg264us1IR6b8OQNuEF0g
117	63305	The Trailhead / Loppet Foundation	1221 Theodore Wirth Parkway	Minneapolis	MN	t	f	\N	44.99171	-93.326294	2022-08-31 17:55:28.904-05	2022-08-31 17:55:29.009-05	US	t	f	f	f	f	ChIJwcTq-Z4zs1IR2ltPm0LVtFo
118	48854	The Saloon 	830 Hennepin Ave	Minneapolis	MN	t	t	\N	44.976837	-93.27706	2019-04-03 19:26:50.584-05	2019-04-03 19:26:50.681-05	US	f	f	f	f	f	ChIJwbo195Mys1IRE8zTO9N-mAA
119	59549	Pimento Jamaican kitchen	2524 Nicolette avenue	Minneapolis	MN	t	t	\N	44.95647	-93.2782	2021-08-14 21:34:31.214-05	2021-08-14 21:34:31.3-05	US	f	f	f	f	f	ChIJw_AZpgozs1IRjU4QgindhtM
120	31891	Eastside Food Co-op	2551 Central Ave NE	Minneapolis	MN	t	t	\N	45.014782	-93.2468	2017-02-27 20:42:01.727-06	2017-02-27 20:42:01.727-06	US	f	t	f	f	f	ChIJwayviekts1IRKSKu8bFcRFY
121	30204	Eastside Food Co-op	2551 Central Ave. NE	Minneapolis	MN	t	t	\N	45.014782	-93.2468	2017-02-25 22:21:39.988-06	2017-02-25 22:21:39.988-06	US	f	t	f	f	f	ChIJwayviekts1IRKSKu8bFcRFY
122	31886	Eastside Food Co-op	2551 Central Ave NE	Minneapolis	MN	t	t	\N	45.014782	-93.2468	2017-02-27 20:41:02.95-06	2017-02-27 20:41:02.95-06	US	f	t	f	f	f	ChIJwayviekts1IRKSKu8bFcRFY
123	26432	Eastside Food Co-op	2551 Central Ave NE	Minneapolis	MN	t	t	\N	45.014782	-93.2468	2016-11-12 09:58:49.532-06	2016-11-12 09:58:49.532-06	US	f	t	f	f	f	ChIJwayviekts1IRKSKu8bFcRFY
124	31887	Eastside Food Co-op	2551 Central Ave NE	Minneapolis	MN	t	t	\N	45.014782	-93.2468	2017-02-27 20:41:03.033-06	2017-02-27 20:41:03.033-06	US	f	t	f	f	f	ChIJwayviekts1IRKSKu8bFcRFY
125	19888	Eastside Food Co-op	2551 central ave NE	Minneapolis	MN	t	t	\N	45.014782	-93.2468	2016-01-21 00:58:53.739-06	2016-01-21 00:58:53.739-06	US	f	f	f	f	f	ChIJwayviekts1IRKSKu8bFcRFY
126	49086	Chatime 	321 14th Ave SE	Minneapolis	MN	t	t	\N	44.980236	-93.236404	2019-04-12 10:49:49.365-05	2019-04-12 10:49:49.465-05	US	f	f	f	f	f	ChIJw9RbKRIts1IRhNkgZRfcGBA
127	24475	MSP Terminal 1 Concourse E	4300 glumack drive	St. Paul	MN	t	t	\N	44.88515	-93.21273	2016-08-02 09:16:31.768-05	2016-08-02 09:16:31.768-05	US	f	f	f	f	f	ChIJW8hCqS4p9ocRarv5nzzZ_64
128	26445	Maeve's Cafe 	300 13th Avenue NE	Minneapolis	MN	t	t	\N	45.000694	-93.26444	2016-11-12 12:19:28.541-06	2016-11-12 12:19:28.541-06	US	f	f	f	f	f	ChIJw83i73cys1IRxhonkd8qwsk
129	57757	Two scoops	Central Ave 	Osseo	MN	f	t	\N	45.11943	-93.40215	2021-05-15 22:03:20.672-05	2021-05-15 22:03:20.755-05	US	f	t	f	f	f	ChIJw50AHKY5s1IRRolUoi4NLvE
130	57758	Two Scoops	Central Ave	Osseo	MN	f	t	\N	45.11943	-93.40215	2021-05-15 22:04:47.036-05	2021-05-15 22:04:47.135-05	US	f	f	f	f	f	ChIJw50AHKY5s1IRRolUoi4NLvE
131	27453	Caydence Coffee	900 Payne Avenue	St. Paul	MN	f	t	\N	44.968334	-93.07331	2017-01-14 14:31:20.195-06	2017-01-14 14:31:20.195-06	US	f	f	f	f	f	ChIJw0e6BjrVslIRPtBeUOfkslE
132	31715	North Hennepin Community College	7411 85th Ave N	Brooklyn Park 	MN	t	t	\N	45.108517	-93.37426	2017-02-27 16:48:19.338-06	2017-02-27 16:48:19.338-06	US	f	f	f	f	f	ChIJVY4jT-Y5s1IR1dponVbumd0
133	59365	Prairie Care	5500 94th Ave N	Brooklyn Park	MN	t	t	\N	45.125942	-93.35222	2021-08-07 10:16:14.281-05	2021-08-07 10:16:14.896-05	US	f	f	f	f	f	ChIJVWkbWiQ6s1IRU_0bLG1x8zY
134	17708	Hennepin County Library - St. Anthony Library	2941 Pentagon Dr. N.E.	St. Anthony	MN	t	t	\N	45.01587	-93.21905	2015-06-11 14:18:54.674-05	2015-06-11 14:18:54.674-05	US	f	f	f	f	f	ChIJVVVVRjEss1IRxAfRRiHzMaU
135	25789	Lebanon Hills Visitor Center	860 Cliff Rd	Eagan	MN	t	t	\N	44.786427	-93.128815	2016-10-08 12:28:48.374-05	2016-10-08 12:28:48.374-05	US	f	t	f	f	f	ChIJVUSaLKIz9ocRe2cxzt2E50Y
136	26452	Lebanon Hills Visitor Center	860 Cliff Road	Eagan	MN	t	t	\N	44.786427	-93.128815	2016-11-12 13:38:41.28-06	2016-11-12 13:38:41.28-06	US	f	f	f	f	f	ChIJVUSaLKIz9ocRe2cxzt2E50Y
137	504	Kitty Cat Klub	315 14th Avenue SE	Minneapolis	MN	f	t	\N	44.980053	-93.23648	2014-02-02 14:49:42.976-06	2014-02-02 14:49:42.976-06	US	f	f	f	f	f	ChIJVQlDKxIts1IRI5uiSBFEIvg
138	30678	Seward Community Cafe	2321 Franklin Ave	Minneapolis	MN	t	t	\N	44.96276	-93.23835	2017-02-26 13:04:34.016-06	2017-02-26 13:04:34.016-06	US	f	t	f	f	f	ChIJvfJfb0gts1IR6pJXoFPcg1k
139	30679	Seward Community Cafe	2321 Franklin Ave	Minneapolis	MN	t	t	\N	44.96276	-93.23835	2017-02-26 13:04:34.852-06	2017-02-26 13:04:34.852-06	US	f	f	f	f	f	ChIJvfJfb0gts1IR6pJXoFPcg1k
140	31707	Seward Community Cafe	2129 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962566	-93.241165	2017-02-27 16:31:52.297-06	2017-02-27 16:31:52.297-06	US	f	t	f	f	f	ChIJvfJfb0gts1IR6pJXoFPcg1k
141	2817	Seward Community Cafe	2129 E Franklin Ave	Minneapolis	MN	f	t	\N	44.96254	-93.24121	2014-02-02 14:53:01.553-06	2014-02-07 13:50:06.861-06	US	f	f	t	f	f	ChIJvfJfb0gts1IR6pJXoFPcg1k
142	16833	The Seward Cafe	2129 Franklin Ave	Minneapolis	MN	t	t	\N	44.96254	-93.24121	2015-03-21 02:19:24.494-05	2015-03-21 02:19:24.494-05	US	f	f	f	f	f	ChIJvfJfb0gts1IR6pJXoFPcg1k
143	25428	Seward Community Cafe	2129 E Franklin Ave, Minneapolis, MN 55404	Minneapolis	MN	t	t	\N	44.96254	-93.24121	2016-09-09 19:17:45.288-05	2016-09-09 19:17:45.288-05	US	f	t	f	f	f	ChIJvfJfb0gts1IR6pJXoFPcg1k
144	37104	Minneapolis community & technical college	1501 Hennepin Ave	Minneapolis	MN	f	t	\N	44.972294	-93.284065	2017-08-20 13:50:11.102-05	2017-08-20 13:50:11.102-05	US	f	t	f	f	f	ChIJvbt3k5Azs1IRB-56L4TJn5M
145	52084	Textile Center 	3000 University Ave SE	Minneapolis	MN	t	t	\N	44.97037	-93.21466	2019-08-21 14:32:54.549-05	2019-08-21 14:32:54.583-05	US	t	f	f	f	f	ChIJv94mIdwss1IRJiqw8Gq4vjU
146	50141	Textile center	300 university ave SE	Minneapolis	MN	t	t	\N	44.985687	-93.25205	2019-06-01 14:51:50.026-05	2019-06-01 14:51:50.138-05	US	f	t	f	f	f	ChIJv94mIdwss1IRJiqw8Gq4vjU
147	32631	10K Brewing	2005 2nd ave	Anoka	MN	t	t	\N	45.198235	-93.38962	2017-03-01 18:59:35.208-06	2017-03-01 18:59:35.208-06	US	f	f	f	f	f	ChIJV62Il-w-s1IRHCEun8s17FI
148	4268	The Anchor Fish and Chips	302 13th Ave NE	Minneapolis	MN	t	t	\N	45.00091	-93.26435	2014-02-02 14:55:27.805-06	2014-02-02 14:55:27.805-06	US	f	f	t	f	f	ChIJv4aZ5Xcys1IROxn69iX4l_w
149	29444	VCA Cedar Animal Hospital 	3604 Cedar Ave So	Minneapolis	MN	t	t	\N	44.93745	-93.247635	2017-02-25 07:02:32.902-06	2017-02-25 07:02:32.902-06	US	f	f	f	f	f	ChIJV383hhIo9ocRdVY9rz9_P_8
150	24067	Wild Rumpus	2720 West 43rd street	Minneapolis	MN	f	t	\N	44.924732	-93.31361	2016-07-15 19:33:21.95-05	2016-07-15 19:33:21.95-05	US	f	f	f	f	f	ChIJv34kUxcn9ocRS6JmpXpG33Q
151	26244	The Cedar Cultural Center	416 Cedar Avenue South	Minneapolis	MN	t	f	\N	44.96944	-93.247604	2016-11-10 18:59:46.601-06	2016-11-10 18:59:46.601-06	US	f	f	f	f	f	ChIJv1UdCkMts1IRJx2heTQYc4w
152	17302	10700 Cedar Lake Road, Hopkins, MN 55305, USA	10700 Cedar Lake Road	Hopkins	MN	f	t	\N	44.954166	-93.41371	2015-04-30 07:53:56.425-05	2015-04-30 07:53:56.425-05	US	f	f	f	f	f	ChIJV1Jot1A1s1IRMMA82nAczAo
153	51956	Caffetto Coffee House	708 W 22nd Street	Minneapolis	MN	f	f	\N	44.961044	-93.28854	2019-08-15 14:39:56.852-05	2019-08-15 14:39:56.963-05	US	f	t	t	f	f	ChIJV0IZ6s8ys1IRIcqYn23Faxw
154	57976	Caffetto Coffee House	705 W 22nd Street	Minneapolis	MN	f	t	\N	44.960915	-93.28808	2021-06-15 04:35:59.322-05	2021-06-15 04:35:59.41-05	US	f	t	f	f	f	ChIJV0IZ6s8ys1IRIcqYn23Faxw
155	57975	Caffetto Coffee House	705 W 22nd Street	Minneapolis	MN	f	t	\N	44.960915	-93.28808	2021-06-15 04:34:02.111-05	2021-06-15 04:34:02.192-05	US	f	f	f	f	f	ChIJV0IZ6s8ys1IRIcqYn23Faxw
156	20948	Half Price Books	2982 White Bear Ave.	Maplewood	MN	f	t	\N	45.03126	-93.01603	2016-03-31 11:55:42.812-05	2016-03-31 11:55:42.812-05	US	f	f	f	f	f	ChIJUzcgv_zTslIRmqE243MfqcI
157	43069	Giordano’s	2700 Hennepin Ave	Minneapolis	MN	t	t	\N	44.965282	-93.2885	2018-08-18 19:50:29.939-05	2018-08-18 19:50:29.939-05	US	t	t	f	f	f	ChIJuXPlXNUys1IRVqZm3C0mkWw
158	42637	Midway YMCA	1761 University Ave W	St. Paul	MN	t	t	\N	44.95643	-93.17503	2018-07-29 09:07:12.178-05	2020-04-14 16:24:18.707-05	US	f	f	f	f	f	ChIJUXIinQAq9ocRfRMoHMyROUg
159	54865	Noodles $ Company	470 Hamline Ave N	St. Paul	MN	t	t	\N	44.955017	-93.15628	2020-01-17 08:05:50.122-06	2020-04-14 16:08:18.022-05	US	f	f	f	f	f	ChIJUxBMEXUq9ocRCQxQRUFrGQ8
160	30703	The Lowbrow	4424 Nicollet Ave	Minneapolis	MN	t	t	\N	44.92238	-93.27794	2017-02-26 13:33:14.604-06	2017-02-26 13:33:14.604-06	US	f	f	t	f	f	ChIJUwlN-scn9ocRtDZXalhHYw4
161	28969	The Lowbrow	4244 Nicollet ave	Minneapolis	MN	t	f	\N	44.925434	-93.27828	2017-02-24 17:14:49.279-06	2017-02-24 17:14:49.279-06	US	f	t	f	f	f	ChIJUwlN-scn9ocRtDZXalhHYw4
162	20495	The Lowbrow	4244 Nicollet avenue	Minneapolis	MN	t	t	\N	44.925434	-93.27828	2016-03-25 09:56:06.551-05	2016-03-25 09:56:06.551-05	US	f	t	f	f	f	ChIJUwlN-scn9ocRtDZXalhHYw4
163	39340	The Lowbrow	4244 Nicollet Ave	Minneapolis	MN	t	t	\N	44.925434	-93.27828	2018-01-07 11:12:42.886-06	2018-01-07 11:12:42.886-06	US	f	t	f	f	f	ChIJUwlN-scn9ocRtDZXalhHYw4
164	17547	The Lowbrow 	4244 Nicollet Ave	Minneapolis	MN	t	f	\N	44.925434	-93.27828	2015-05-25 12:35:20.813-05	2015-05-25 12:35:20.813-05	US	f	t	t	f	f	ChIJUwlN-scn9ocRtDZXalhHYw4
165	54421	Arc's Value Village	2751 Winnetka Ave N	New Hope	MN	t	t	\N	45.008778	-93.38166	2019-12-12 07:07:19.582-06	2020-04-14 16:04:59.574-05	US	t	f	t	f	f	ChIJu_vOjzY0s1IR2CJgjYbyfcc
166	33001	Twin Cities German Immersion School	1030 Van Slyke Ave	St. Paul	MN	t	f	\N	44.976154	-93.14365	2017-03-03 07:42:31.163-06	2017-03-03 07:42:31.163-06	US	f	f	f	f	f	ChIJUTHbylQrs1IRuhGIlTe4a4g
167	67806	The landing 	RG36+GR7 Shakopee, Minnesota	Shakopee 	MN	t	t	\N	44.803787	-93.48795	2023-11-05 13:49:35.072-06	2023-11-05 13:49:35.156-06	US	f	f	f	f	f	ChIJuScqx-UZ9ocRtcM5k4o1DjU
168	67807	The landing	RG38+89V	Shakopee 	MN	t	t	\N	44.803364	-93.48408	2023-11-05 14:00:06.326-06	2023-11-05 14:00:06.42-06	US	f	t	f	f	f	ChIJuScqx-UZ9ocRtcM5k4o1DjU
169	21005	Beat Coffeehouse	1414 West 28th Street	Minneapolis	MN	t	t	\N	44.952137	-93.2977	2016-04-02 13:07:46.957-05	2016-04-02 13:07:46.957-05	US	f	f	f	f	f	ChIJuRIbD4An9ocRUAuWzo70jlg
170	27346	Capella Tower	225 S 6th Street	Minneapolis	MN	t	t	\N	44.976208	-93.268585	2017-01-05 08:05:31.98-06	2024-04-24 09:53:17.205026-05	US	f	f	t	f	f	ChIJuR6Mgpkys1IR6DZdli6CMg0
171	16560	Five Watt Coffee	3745 Nicollet Avenue South	Minneapolis	MN	f	t	\N	44.934498	-93.27762	2015-03-11 10:26:23.814-05	2015-03-11 10:26:23.814-05	US	f	f	f	f	f	ChIJUfm3AsAn9ocRJyRbH1OWTXg
172	50443	Trader joes	12105 Elm Creek Blvd N	Maple Grove 	MN	t	t	\N	45.09219	-93.43409	2019-06-15 19:31:30.182-05	2019-06-15 19:31:30.28-05	US	f	f	f	f	f	ChIJud1D4gFIs1IR3JmTPrPCOKo
173	25070	YWCA Midtown	2121 E Lake St	Minneapolis	MN	t	t	\N	44.947468	-93.2415	2016-08-27 16:51:43.301-05	2016-08-27 16:51:43.301-05	US	f	f	t	f	f	ChIJU_C5Ghko9ocR5FkQ5NlPZZM
174	17208	Mattie's on Main	43 Main St SE, #144	Minneapolis	MN	t	t	\N	44.98615	-93.257996	2015-04-21 12:30:16.532-05	2015-04-21 12:30:16.532-05	US	f	t	f	f	f	ChIJU8wZHHwts1IROSnlrw9w9A8
175	17329	Mattie's on Main 	43 south main #144	Minneapolis	MN	t	t	\N	44.98615	-93.257996	2015-05-03 11:12:16.699-05	2015-05-03 11:12:16.699-05	US	f	f	f	f	f	ChIJU8wZHHwts1IROSnlrw9w9A8
176	59194	MHealth Fairview	909 Fulton St	Minneapolis	MN	t	f	\N	44.970776	-93.22483	2021-08-05 12:41:11.782-05	2021-08-05 12:41:11.833-05	US	f	f	t	f	f	ChIJu77d1iMts1IRR51CVn9tVJo
177	20384	Blue Moon Coffee Cafe	3822 East Lake Street	Minneapolis	MN	f	t	\N	44.948627	-93.21674	2016-03-24 18:26:52.797-05	2016-03-24 18:26:52.797-05	US	f	t	f	f	f	ChIJu6yoF9Mp9ocRJ0p7EGDZY6k
178	28797	Blue Moon Coffee Care	3822 East Lake Street	Minneapolis	MN	f	f	\N	44.948627	-93.21674	2017-02-24 13:58:51.474-06	2017-02-24 13:58:51.474-06	US	f	t	f	f	f	ChIJu6yoF9Mp9ocRJ0p7EGDZY6k
179	2461	Blue Moon Coffee Care	3822 East Lake Street	Minneapolis	MN	t	t	\N	44.94855	-93.21748	2014-02-02 14:52:29.54-06	2014-02-02 14:52:29.54-06	US	f	f	f	f	f	ChIJu6yoF9Mp9ocRJ0p7EGDZY6k
180	31271	McNeal Hall	1984 Buford Ave	St. Paul	MN	t	t	\N	44.98407	-93.18359	2017-02-27 02:59:30.733-06	2017-02-27 02:59:30.733-06	US	f	f	t	f	f	ChIJU6nmKYMss1IRJrHTYmYBxXw
181	17143	Bedlam Lowertown	213 EAST FOURTH ST.	St. Paul	MN	t	t	\N	44.948406	-93.0871	2015-04-14 19:23:59.829-05	2015-04-14 19:23:59.829-05	US	f	f	f	f	f	ChIJU6LIREXV94cRyIwx6iUiJtE
182	19353	Target	6445 Richfield Parkway	Richfield	MN	t	t	\N	44.885674	-93.24832	2015-11-20 01:53:58.186-06	2015-11-20 01:53:58.186-06	US	f	f	f	f	f	ChIJu_2SMa4o9ocRrSFXP96SZ74
183	17570	Hennepin County Library - Plymouth	15700 36th Ave N	Plymouth	MN	t	t	\N	45.02272	-93.48102	2015-05-27 08:49:51.243-05	2015-05-27 08:49:51.243-05	US	f	f	f	f	f	ChIJtZF3lGJJs1IRyNlbTarWQQ0
184	42283	Plymouth Library 	36th Ave N	Plymouth 	MN	t	f	\N	45.022137	-93.45898	2018-07-07 06:35:58.089-05	2018-07-07 06:35:58.089-05	US	t	f	f	f	f	ChIJtZF3lGJJs1IRyNlbTarWQQ0
185	35617	Royal Grounds Coffee	4161 Grand Ave S, Minneapolis, MN 55409	Minneapolis	MN	t	t	\N	44.927006	-93.2844	2017-06-08 17:29:30.139-05	2017-06-08 17:29:30.139-05	US	t	f	t	f	f	ChIJtZ_CM7on9ocRnahCtjl1aIE
186	16434	Half Price Books 	8601 Springbrook Dr NW	Coon Rapids	MN	f	t	\N	45.12615	-93.266495	2015-03-09 17:51:31.487-05	2015-03-09 17:51:31.487-05	US	f	f	f	f	f	ChIJtydEhzAls1IRxet9vZHOZ8U
187	28544	Starbucks	5300 Central Ave	Fridley	MN	t	f	\N	45.06469	-93.248245	2017-02-24 07:05:37.278-06	2017-02-24 07:05:37.278-06	US	f	f	f	f	f	ChIJTwnI4Eous1IRXTScFxRtYWk
188	65332	Inver Hills Community College	2500 80th St E	Inver Grove Heights	MN	f	t	\N	44.829224	-93.0559	2023-04-19 13:23:32.162-05	2023-04-19 13:23:32.261-05	US	f	t	f	f	f	ChIJtWixy1_S94cRiPatURhmz5s
189	45515	Inver Hills Community College	2500 80th St. East	Inver Grove Heights	MN	t	t	\N	44.830173	-93.05577	2018-10-30 10:37:03.777-05	2018-10-30 10:37:03.777-05	US	t	f	f	f	f	ChIJtWixy1_S94cRiPatURhmz5s
190	34547	Inver Hills Community College	2500 80th St. E	Inver Grove Heights	MN	t	t	\N	44.83343	-93.05488	2017-04-24 22:53:35.695-05	2017-04-24 22:53:35.695-05	US	f	t	f	f	f	ChIJtWixy1_S94cRiPatURhmz5s
191	62258	Blick Art Materials	3867 Gallagher Dr.	Edina	MN	t	t	\N	44.870316	-93.32834	2022-06-03 15:29:51.266-05	2022-06-03 15:29:51.35-05	US	t	f	f	f	f	ChIJtS1sFRsk9ocRowyOLxNXyKg
192	42815	Starbucks 	5512 Brooklyn Blvd	Brooklyn Center	MN	t	t	\N	45.055267	-93.32317	2018-08-06 19:03:24.219-05	2018-08-06 19:03:24.219-05	US	t	f	f	f	f	ChIJTRxqYhoxs1IRzCZ5dD5YLYg
193	43410	Nuway (Intensive Outpatient Treatment Center)	2118 Blaisdell Ave	Minneapolis	MN	f	t	\N	44.96115	-93.28016	2018-09-06 10:22:31.076-05	2018-09-06 10:22:31.076-05	US	f	f	f	f	f	ChIJ_TONF8gys1IRWP6xzCUbbDU
194	36439	Target	3300 124th Ave NW	Coon Rapids	MN	t	t	\N	45.19436	-93.35001	2017-07-16 20:15:09.958-05	2017-07-16 20:15:09.958-05	US	f	f	f	f	f	ChIJ_TI_Mz48s1IRNp_rnza2MQQ
195	23567	Morrisey's 	Lake and Bryant 	Minneapolis	MN	t	t	\N	44.949196	-93.29065	2016-06-24 20:57:19.42-05	2016-06-24 20:57:19.42-05	US	f	t	f	f	f	ChIJTbqiRSon9ocRdmmSVXnf2AU
196	23566	Morrisey's 	Lake and Bryant 	Minneapolis	MN	t	t	\N	44.949196	-93.29065	2016-06-24 20:57:18.92-05	2016-06-24 20:57:18.92-05	US	f	f	f	f	f	ChIJTbqiRSon9ocRdmmSVXnf2AU
197	22365	The Source Comics and Games	2057  N Snelling Ave	Roseville 	MN	t	f	\N	45.00316	-93.16751	2016-05-28 12:27:29.061-05	2016-05-28 12:27:29.061-05	US	f	f	f	f	f	ChIJTbaeb3Yrs1IREjvxKoLsO5U
198	41822	Empire Coffee + Pastry	451 Stinson Blvd NE Minneapolis, MN	Minneapolis	MN	t	f	\N	45.056904	-93.22703	2018-06-14 10:29:20.29-05	2020-04-14 16:23:41.188-05	US	t	f	f	f	f	ChIJTaL2t6sts1IR_o7NJJQdNC0
199	30992	The Pourhouse	10 S 5th St #11	Minneapolis	MN	t	t	\N	44.979652	-93.2714	2017-02-26 18:33:39.813-06	2017-02-26 18:33:39.813-06	US	f	f	f	f	f	ChIJt914nZoys1IRnYcH4sSTlDA
200	38820	Adler Graduate School	1550 East 78th Street	Richfield	MN	t	f	\N	44.86297	-93.252266	2017-11-27 11:09:16.584-06	2017-11-27 11:09:16.584-06	US	f	f	f	f	f	ChIJT7oXNlwv9ocRc4sqjg32mk0
201	48855	Lush	990 Central Ave NE	Minneapolis	MN	t	t	\N	44.995464	-93.247696	2019-04-03 19:29:33.663-05	2019-04-03 19:29:33.698-05	US	f	t	f	f	f	ChIJT69lpp4ts1IRruoO_fWkdG8
202	33853	Lush	990 Central Ave NE	Minneapolis	MN	t	t	\N	44.99545	-93.24768	2017-04-09 17:53:01.621-05	2017-04-09 17:53:01.621-05	US	f	t	f	f	f	ChIJT69lpp4ts1IRruoO_fWkdG8
203	32258	Lush	990 Central Ave NE	Minneapolis	MN	t	t	\N	44.99545	-93.24768	2017-02-28 21:25:35.041-06	2017-02-28 21:25:35.041-06	US	f	f	f	f	f	ChIJT69lpp4ts1IRruoO_fWkdG8
204	31352	Lush	990 Central Ave NE	Minneapolis	MN	f	t	\N	44.99545	-93.24768	2017-02-27 08:52:13.088-06	2017-02-27 08:52:13.088-06	US	f	t	f	f	f	ChIJT69lpp4ts1IRruoO_fWkdG8
205	31353	Lush	990 Central Ave NE	Minneapolis	MN	f	t	\N	44.99545	-93.24768	2017-02-27 08:52:50.395-06	2017-02-27 08:52:50.395-06	US	f	t	f	f	f	ChIJT69lpp4ts1IRruoO_fWkdG8
206	5264	Lush	990 Central Ave NE	Minneapolis	MN	t	t	\N	44.99525	-93.24769	2014-03-31 08:19:27.604-05	2014-03-31 08:19:27.604-05	US	f	t	f	f	f	ChIJT69lpp4ts1IRruoO_fWkdG8
207	26442	St. Louis Park Library	3240 library lane	St. Louis Park	MN	t	t	\N	44.943966	-93.369545	2016-11-12 12:14:38.145-06	2016-11-12 12:14:38.145-06	US	f	t	f	f	f	ChIJT3VQyIQg9ocREC7NZxek3Uc
208	25114	Minneapolis Institute of Art	2400 3rd Ave S, Minneapolis, 2400 3rd Ave S 55404	Minneapolis	MN	t	t	\N	44.958508	-93.27354	2016-08-29 06:43:00.998-05	2016-08-29 06:43:00.998-05	US	f	f	f	f	f	ChIJT0k6WbEys1IRpnx9LgDjLMU
209	35449	Minneapolis Institute of Art	2400 3rd Ave S	Minneapolis	MN	f	t	\N	44.958485	-93.273384	2017-06-01 15:37:09.218-05	2017-06-01 15:37:09.218-05	US	f	t	f	f	f	ChIJT0k6WbEys1IRpnx9LgDjLMU
210	27872	Unity Church	733 Portland Avenue	St. Paul	MN	t	t	\N	44.9427	-93.13098	2017-01-31 15:31:17.504-06	2017-01-31 15:31:17.504-06	US	f	t	f	f	f	ChIJswlsJYwq9ocRR_xhuqDXpEU
211	27871	Unity Church	733 Portland Avenue	St. Paul	MN	t	t	\N	44.9427	-93.13098	2017-01-31 15:31:17.082-06	2017-01-31 15:31:17.082-06	US	f	f	f	f	f	ChIJswlsJYwq9ocRR_xhuqDXpEU
212	52421	Target	300 Clydesdale Trail	Medina	MN	f	t	\N	45.04584	-93.52891	2019-09-08 12:24:43.224-05	2019-09-08 12:24:43.707-05	US	f	f	f	f	f	ChIJsWLFmcNOs1IRYwW3R4E_-iM
213	25300	Saffron Restaurant	123 N 3rd St	Minneapolis	MN	t	t	\N	44.982403	-93.2726	2016-09-03 19:37:34.747-05	2016-09-03 19:37:34.747-05	US	f	f	f	f	f	ChIJS_V8jY8ys1IRY5ZrvVq_DfU
214	43404	Spyhouse Coffee	2404 Hennepin Ave	Minneapolis	MN	t	t	\N	44.958935	-93.294586	2018-09-05 19:45:46.892-05	2018-09-05 19:45:46.892-05	US	f	f	f	f	f	ChIJsUi4zNYys1IRxII4CdBs8ZA
215	51485	Harriet Brasserie	West 43rd Street	Minneapolis	MN	f	t	\N	44.925087	-93.31885	2019-08-02 19:14:59.836-05	2019-08-02 19:14:59.96-05	US	f	f	f	f	f	ChIJSThxTRcn9ocRXqRANDTAxMI
216	928	Cafe Twenty Eight	2724 West 43rd Street	Minneapolis	MN	t	t	\N	44.9247	-93.31381	2014-02-02 14:50:16.335-06	2014-02-02 14:50:16.335-06	US	f	f	t	f	f	ChIJSThxTRcn9ocRNFLy_GKsUNg
217	52016	Tap Society	4555 Grand Ave S	Minneapolis	MN	t	t	\N	44.91977	-93.2842	2019-08-17 19:24:30.389-05	2019-08-17 19:24:30.487-05	US	t	f	f	f	f	ChIJsROxNKAn9ocRov8w-M6cMec
218	39366	Great Clips	Woodbury Village	Woodbury	MN	f	t	\N	44.92705	-92.96214	2018-01-08 16:44:32.394-06	2018-01-08 16:44:32.394-06	US	f	f	f	f	f	ChIJSQpjOafX94cR4nUXFifAQ_Y
219	62729	Caribou Coffee 	9008. Cahill Avenue	Inver Grove Heights 	MN	t	f	\N	44.819126	-93.03857	2022-07-14 23:19:57.747-05	2022-07-14 23:19:57.838-05	US	t	f	f	f	f	ChIJSQIZo3LS94cRJ-_ZcazB12E
220	25249	The Mill Northeast	1851 Central Ave NE	Minneapolis	MN	f	t	\N	45.007755	-93.24706	2016-09-02 12:37:36.442-05	2016-09-02 12:37:36.442-05	US	f	f	f	f	f	ChIJ-SOeFQsys1IRpeMgJvjTRFw
221	35947	Mojo Coffee Gallery	2205 California St NE	Minneapolis	MN	f	t	\N	45.01054	-93.26847	2017-06-23 13:49:24.335-05	2017-06-23 13:49:24.335-05	US	f	f	f	f	f	ChIJ-SOeFQsys1IRcKc0o-VqLD0
222	51949	Allianz Field	400 Snelling Ave N	St. Paul	MN	f	t	\N	44.952885	-93.165215	2019-08-14 21:19:38.006-05	2019-08-14 21:19:38.027-05	US	f	f	t	f	f	ChIJS-HKPQkq9ocR5OCe6eSJgXY
223	30563	The Good Earth Restaurant at the Galleria	3460 W 70th St.	Edina	MN	t	t	\N	44.876865	-93.32561	2017-02-26 11:04:04.149-06	2017-02-26 11:04:04.149-06	US	f	f	f	f	f	ChIJsfp6bx0k9ocRZ0exZyc8SrQ
224	43042	Generic Office Building	330 2nd Ave S.	Minneapolis	MN	t	t	\N	44.979225	-93.266945	2018-08-18 09:19:57.428-05	2020-04-14 16:24:40.432-05	US	f	f	f	f	f	ChIJSdmLfpsys1IRqUauHEeaDLI
225	62423	East side bar	858 Payne Ave	St. Paul	MN	t	t	\N	44.967144	-93.073425	2022-06-22 21:40:53.972-05	2022-06-22 21:40:54.079-05	US	t	f	f	f	f	ChIJSbE7SuDVslIR4Q1cNoqVE48
226	28546	Perpich Center for Arts Education	6125 Olson Memorial Hwy	Golden Valley	MN	t	t	\N	44.98361	-93.35879	2017-02-24 07:10:50.961-06	2017-02-24 07:10:50.961-06	US	f	f	f	f	f	ChIJSagE8Ys0s1IRawIjGJalVP0
227	38123	Ford Hall	224 Church Dt SE	Minneapolis	MN	t	t	\N	44.973892	-93.23444	2017-10-10 12:02:12.807-05	2017-10-10 12:02:12.807-05	US	t	f	f	f	f	ChIJS9PkaRYts1IRemsXgUWXyVg
228	5046	Ford Hall	224 Church St SE	Minneapolis	MN	t	t	\N	44.975487	-93.23388	2014-02-18 16:06:36.059-06	2014-02-18 16:06:47.321-06	US	f	t	f	f	f	ChIJS9PkaRYts1IRemsXgUWXyVg
229	31350	Boiler Room Coffee	1830 3rd Ave S	Minneapolis	MN	f	t	\N	44.964336	-93.273	2017-02-27 08:49:25.099-06	2017-02-27 08:49:25.099-06	US	f	f	f	f	f	ChIJS7C_Uboys1IRaHTNTlSvZ-k
230	24980	Ramsey County Library / Dunn Bros Coffee	2180 Hamline Ave N # 1	St. Paul 	MN	t	t	\N	45.007477	-93.15577	2016-08-25 19:43:46.558-05	2016-08-25 19:43:46.558-05	US	f	f	t	f	f	ChIJS6ZtLLors1IR8l2ZBqNnEWc
231	24785	Brake Bread	1174 7th St W	St. Paul	MN	t	t	\N	44.92367	-93.132195	2016-08-17 17:18:09.723-05	2016-08-17 17:18:09.723-05	US	f	f	f	f	f	ChIJS5cGGvwq9ocRSJtz4BTf8zA
232	58614	Castiel Swaser	990 Central Ave NE	Minneapolis	MN	t	t	\N	44.995464	-93.247696	2021-07-31 18:08:08.525-05	2021-07-31 18:08:08.62-05	US	f	f	f	f	f	ChIJS4TOqJ4ts1IRXPhOvy7BjD8
233	62607	2400 3rd Ave S, Minneapolis, MN 55404, USA	2400 3rd Ave S	Minneapolis	MN	t	t	\N	44.958588	-93.27422	2022-07-08 14:39:22.527-05	2022-07-08 14:39:22.619-05	US	t	f	f	f	f	ChIJs4ljrbYys1IRFX3z8br83bo
234	40270	Pizza Luce 	Selby	St. Paul 	MN	t	f	\N	44.94663	-93.150444	2018-03-05 14:09:22.732-06	2018-03-05 14:09:22.732-06	US	f	f	f	f	f	ChIJs3rc0m8q9ocRYpogcbkGJQY
235	26124	Seward Co-op Creamery Cafe	2601 E Franklin Ave	Minneapolis	MN	t	f	\N	44.96251	-93.23426	2016-11-10 11:01:57.322-06	2016-11-10 11:01:57.322-06	US	f	t	f	f	f	ChIJs1L6Sjcts1IRprfmpy2x9YA
236	50800	Seward Co-op Creamery Cafe	2601 East Franklin Avenue	Minneapolis	MN	t	t	\N	44.962532	-93.23427	2019-07-02 08:26:25.52-05	2019-07-02 08:26:25.618-05	US	t	f	f	f	f	ChIJs1L6Sjcts1IRprfmpy2x9YA
237	52303	Seward Co-op Creamery	2601 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962532	-93.23427	2019-08-31 22:02:55.546-05	2019-08-31 22:02:55.655-05	US	t	t	f	f	f	ChIJs1L6Sjcts1IRprfmpy2x9YA
238	50270	Seward Co-op Creamery Cafe	2601 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962532	-93.23427	2019-06-06 13:08:51.716-05	2019-06-06 13:08:51.756-05	US	t	t	f	f	f	ChIJs1L6Sjcts1IRprfmpy2x9YA
239	35752	Pop Culture 	3833 Lexington ave N	Arden Hills	MN	t	t	\N	45.056892	-93.14772	2017-06-14 12:12:21.042-05	2017-06-14 12:12:21.042-05	US	t	f	f	f	f	ChIJs0zXE6cps1IRw0YuXx9SOjA
240	37143	IGM gymnastics 	Southcross Drive West	Burnsville	MN	f	t	\N	44.73752	-93.2961	2017-08-23 12:52:06.47-05	2017-08-23 12:52:06.47-05	US	f	f	f	f	f	ChIJS0nLYzQ69ocRUJKDBQRcYFc
241	57952	Jenna Spiegelberg 	12355 Oak Park Blvd NE	Blaine 	MN	f	f	\N	45.194843	-93.2445	2021-06-12 08:12:13.655-05	2021-06-12 08:12:13.744-05	US	f	f	f	f	f	ChIJRZTUMp4js1IRlT3uVw3mcU8
242	42764	Super America	7601 Jolly Lane	Brooklyn Park	MN	t	f	\N	45.092365	-93.38191	2018-08-03 23:04:27.582-05	2018-08-03 23:04:27.582-05	US	f	f	f	f	f	ChIJrY7AymU3s1IRBn3RMZK6RhU
243	19887	Espresso Royale Dinkytown	411 14th St SE	Minneapolis	MN	t	t	\N	44.98101	-93.23575	2016-01-20 22:25:30.087-06	2016-01-20 22:25:30.087-06	US	f	f	f	f	f	ChIJrxd-khEts1IRlG6WJfJcFqE
244	48887	Hodges Bend	Hodges Bend 2700 University Ave W Suite 100	St. Paul	MN	t	t	\N	44.96761	-93.20737	2019-04-04 12:45:49.613-05	2019-04-04 12:45:50.225-05	US	f	f	f	f	f	ChIJrXbe-8Qss1IRdCvb7qrKGwo
245	50801	Seward Community Co-op	2823 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962463	-93.2302	2019-07-02 08:27:58.75-05	2019-07-02 08:27:58.855-05	US	t	t	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
246	27227	Seward Co-op - Franklin store	2823 East Franklin Ave	MInneapolis	MN	t	t	\N	44.96244	-93.230286	2016-12-23 14:03:57.006-06	2016-12-23 14:03:57.006-06	US	f	f	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
247	21206	Seward Community Co-op	2823 E Franklin Ave.	St. Paul	MN	t	t	\N	44.96244	-93.230286	2016-04-07 07:46:06.139-05	2016-04-07 07:46:06.139-05	US	f	t	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
248	21206	Seward Community Co-op	2823 E Franklin Ave.	St. Paul	MN	t	t	\N	44.96244	-93.230286	2016-04-07 07:46:06.139-05	2016-04-07 07:46:06.139-05	US	f	t	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
249	18372	Seward Community Co-op	2823 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962543	-93.23028	2015-08-13 19:47:26.176-05	2015-08-13 19:47:26.176-05	US	f	t	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
250	17706	Seward Community Co-op	2823 East Franklin Ave	Minneapolis	MN	t	t	\N	44.962543	-93.23028	2015-06-11 12:13:16.82-05	2015-06-11 12:13:16.82-05	US	f	t	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
251	3410	Seward Community Co-op	2823 East Franklin Avenue	Minneapolis	MN	t	t	\N	44.96248	-93.23047	2014-02-02 14:53:56.753-06	2014-03-07 00:13:01.466-06	US	f	f	f	f	f	ChIJrwGTnS4ts1IRzIrUOM2ZTLM
252	30605	Esker Grove/ Walker Art Center	723 Vineland Place	Minneapolis	MN	t	t	\N	44.96889	-93.289185	2017-02-26 11:48:39.659-06	2017-02-26 11:48:39.659-06	US	f	f	f	f	f	ChIJrUTCIcMys1IRw1YJoHGO4hw
253	50328	Rosedale Center	1595 MN-36	Roseville	MN	t	f	\N	45.01301	-93.16977	2019-06-10 13:10:35.959-05	2019-06-10 13:10:36.016-05	US	t	f	t	f	f	ChIJRTkiJu0rs1IRh6yFVjUI4qc
254	66255	Owamni by The Sioux Chef	420 S 1st St	Minneapolis	MN	t	t	\N	44.981136	-93.26041	2023-06-19 21:42:43.544-05	2024-03-22 15:02:35.90983-05	US	t	f	f	f	f	ChIJrSqctJQts1IRc4Q-7QQpN5I
255	37011	Studio 2 Cafe	818 W 46th St	Minneapolis	MN	f	t	\N	44.91973	-93.29044	2017-08-16 11:47:12.933-05	2017-08-16 11:47:12.933-05	US	f	f	f	f	f	ChIJrRTCjX8n9ocR6agTuYANfmg
256	30486	First Presbyterian Church of South St Paul	535 20th Ave N	South St Paul	MN	f	t	\N	44.89915	-93.059105	2017-02-26 09:41:28.267-06	2020-04-14 16:16:45.632-05	US	f	f	f	f	f	ChIJRRi1IYrU94cRNkn_gL51J_g
257	33910	Mon Petit Cheri	2401 Franklin Ave	Minneapolis	MN	t	t	\N	44.962585	-93.23754	2017-04-11 10:29:31.848-05	2017-04-11 10:29:31.848-05	US	f	f	f	f	f	ChIJrQiSljcts1IRBNdwDE_rZJA
258	26008	Apple valley high school	14450 Hayes Rd.	Apple Valley 	MN	f	t	\N	44.742775	-93.2304	2016-11-01 14:20:48.77-05	2016-11-01 14:20:48.77-05	US	f	f	f	f	f	ChIJRQ_c98Qw9ocR-8U7T7CopqA
259	33112	Hcmc Purple Building 7th Floor	701 park Avenue.	Minneapolis	MN	t	f	\N	44.972134	-93.26229	2017-03-03 15:02:15.144-06	2017-03-03 15:02:15.144-06	US	f	f	f	f	f	ChIJrQ50M-Uzs1IRxQWSh1sfcyY
260	30510	Hamline University Anderson Center	774 Snelling Ave N	St. Paul	MN	t	f	\N	44.964462	-93.1667	2017-02-26 10:06:02.683-06	2020-04-14 16:16:58.22-05	US	f	f	f	f	f	ChIJr_HAmE8rs1IR6bzPe7TGieA
261	35251	Nelson's Ice Cream	Snelling Avenue	St. Paul	MN	t	t	\N	44.988163	-93.16688	2017-05-24 18:32:45.054-05	2017-05-24 18:32:45.054-05	US	f	f	f	f	f	ChIJ_RHaDDAq9ocRaC4eEpJ3gII
262	32239	Ben and Jerry's	3070 Excelsior Boulevard	Minneapolis	MN	t	t	\N	44.946854	-93.322296	2017-02-28 20:48:04.306-06	2017-02-28 20:48:04.306-06	US	f	f	f	f	f	ChIJR7mcJVwn9ocRqn05RNfwtkQ
263	31735	Walmart	7835 150th St W	Apple Valley	MN	t	t	\N	44.73437	-93.22459	2017-02-27 17:03:12.755-06	2017-02-27 17:03:12.755-06	US	f	f	f	f	f	ChIJr7GRx9Mw9ocRBGs64sEUCYo
264	52511	Lodestone Coffee and Games	10982 Cedar Lake Rd	Minnetonka	MN	t	t	\N	44.952866	-93.41669	2019-09-11 16:13:10.884-05	2019-09-11 16:13:11.403-05	US	f	t	f	f	f	ChIJR6n5O1Q1s1IRHRBin2Jyzl8
265	36507	Lodestone Coffee And Games	10982 Cedar Lake Road	Minnetonka 	MN	t	t	\N	44.952843	-93.41654	2017-07-20 11:17:24.929-05	2017-07-20 11:17:24.929-05	US	t	f	f	f	f	ChIJR6n5O1Q1s1IRHRBin2Jyzl8
266	36812	Teahouse	2425 University Ave SE	Minneapolis	MN	t	t	\N	44.97381	-93.22146	2017-08-04 17:40:12.643-05	2017-08-04 17:40:12.643-05	US	f	f	f	f	f	ChIJR0bh8h8ts1IR2Zsy4xEpkdE
267	17139	Common Roots 	2558 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.955677	-93.28829	2015-04-14 16:13:40.396-05	2015-04-14 16:13:40.396-05	US	f	f	f	f	f	ChIJQYmOj80ys1IRWQVWzqffD6E
268	2643	Common Roots Cafe	2558 Lyndale Ave. S	Minneapolis	MN	t	t	\N	44.955666	-93.288246	2014-02-02 14:52:42.437-06	2014-02-07 13:42:40.977-06	US	f	f	f	f	f	ChIJQYmOj80ys1IRWQVWzqffD6E
269	1149	Tapestry Folkdance Center	3748 Minnehaha Ave S	Minneapolis	MN	f	t	\N	44.934597	-93.22479	2014-02-02 14:50:34.714-06	2014-02-02 14:50:34.714-06	US	f	f	t	f	f	ChIJQw2-v0ko9ocR9ATKPskBe9g
270	54016	University Recreation and Wellness Center	123 SE Harvard St	Minneapolis	MN	t	t	\N	44.975094	-93.229675	2019-11-16 12:46:47.308-06	2020-04-14 16:01:59.515-05	US	t	f	f	f	f	ChIJqTBqzhkts1IRhkeC39PGaeI
271	54015	University Recreation and Wellness Center	123 SE Harvard St.	Minneapolis	MN	t	t	\N	44.980267	-93.23896	2019-11-16 12:43:57.711-06	2019-11-16 12:43:57.806-06	US	f	t	f	f	f	ChIJqTBqzhkts1IRhkeC39PGaeI
272	38683	Punch Pizza	802 Washington Ave SE	Minneapolis	MN	t	t	\N	44.973454	-93.22681	2017-11-15 17:07:42.568-06	2017-11-15 17:07:42.568-06	US	t	f	f	f	f	ChIJqRo0mRgts1IRHnc1XLejRQU
273	36450	Bryant Lake Bowl	810 W Lake St.	Minneapolis	MN	t	t	\N	44.948524	-93.290215	2017-07-17 17:40:09.44-05	2017-07-17 17:40:09.44-05	US	f	f	f	f	f	ChIJqRmGeoYn9ocROJ_rUgwsy0o
274	21330	Normandale Community college	9700 France	Bloomington	MN	t	t	\N	44.829426	-93.331085	2016-04-13 12:38:31.799-05	2016-04-13 12:38:31.799-05	US	f	f	f	f	f	ChIJQR6y4Jok9ocR9qqcFCAUt4M
275	62432	Stillheart Distillery & Cocktail	124 3rd Ave North	Minneapolis 	MN	f	t	\N	44.97979	-93.30546	2022-06-23 20:35:05.409-05	2022-06-23 20:35:05.478-05	US	f	f	f	f	f	ChIJQQU3DJMzs1IR7xNaZoqz8Gc
276	60644	Valley Natural Foods Co-op	13750 County Road 11	Burnsville 	MN	f	t	\N	44.754513	-93.24917	2021-12-21 15:16:57.114-06	2021-12-21 15:16:57.201-06	US	f	t	t	f	f	ChIJ-QGEd5Aw9ocRIG0Chb_axjU
277	47391	Valley Natural Foods Co-op	13750 Co Rd 11	Burnsville	MN	t	t	\N	44.754513	-93.24917	2019-02-07 10:18:02.742-06	2019-02-07 10:18:02.763-06	US	t	f	t	f	f	ChIJ-QGEd5Aw9ocRIG0Chb_axjU
278	27500	Olson campus center	1490 Fulham street	St. Paul	MN	t	t	\N	44.98569	-93.196686	2017-01-16 19:00:08.948-06	2017-01-16 19:00:08.948-06	US	f	f	f	f	f	ChIJqfFs040ss1IR9uP9q_UsjnM
279	52952	Grandmarc Seven Corners	1849 Washington Ave S	Minneapolis	MN	f	t	\N	44.973248	-93.24641	2019-09-22 15:39:37.379-05	2019-09-22 15:39:37.491-05	US	f	f	f	f	f	ChIJqf9i6Gkts1IRWAkeSlAqU7Y
280	46258	Southwest high school 	47 Chowen	Minneapolis	MN	t	t	\N	44.917915	-93.32548	2018-12-03 15:41:10.708-06	2018-12-03 15:41:11.272-06	US	f	f	f	f	f	ChIJQcu7OCEn9ocRVfBQWrqnrQ4
281	29005	Kortes supermarket	1326 Randolph Avenue	St. Paul	MN	t	f	\N	44.926704	-93.15611	2017-02-24 17:55:48.661-06	2017-02-24 17:55:48.661-06	US	f	f	f	f	f	ChIJq9YFRUgq9ocRvAoOHM9zIzo
282	26360	Animal Humane Society	845 Meadow Lane N	Golden Valley	MN	t	t	\N	44.98735	-93.329414	2016-11-11 11:49:08.459-06	2016-11-11 11:49:08.459-06	US	f	f	f	f	f	ChIJq6qqqnpKs1IROmAL-2pO3vQ
283	29478	Common Good Books	38 S. Snelling	St. Paul	MN	t	f	\N	44.940445	-93.16671	2017-02-25 08:13:24.058-06	2017-02-25 08:13:24.058-06	US	f	f	f	f	f	ChIJq6q6chcq9ocRfd4xNv3yOi4
284	20177	Jakeeno's Pizza and Pasta	3555 Chicago Ave	Minneapolis	MN	t	t	\N	44.9379	-93.26233	2016-02-03 19:54:49.475-06	2024-03-12 19:28:47.833105-05	US	f	f	f	f	f	ChIJ_Q2TPOEn9ocRL85EwW6jtYM
285	52652	Comstock Hall	210 Delaware St SE	Minneapolis	MN	t	f	\N	44.972446	-93.23684	2019-09-12 12:02:38.913-05	2019-09-12 12:02:39.473-05	US	f	f	f	f	f	ChIJQ1o8Qj4ts1IRYvhsd1BnquM
286	45310	Boneshaker Books	2002 23rd Ave S	Minneapolis	MN	t	f	\N	44.96242	-93.23967	2018-10-21 13:59:44.655-05	2020-04-14 16:33:46.745-05	US	f	t	f	f	f	ChIJpy8WH0gts1IRm3C2d9i8-X4
287	27201	Boneshaker Books	2002 23rd Avenue South	Minneapolis	MN	t	t	\N	44.96242	-93.23967	2016-12-22 11:39:37.736-06	2016-12-22 11:39:37.736-06	US	f	f	f	f	f	ChIJpy8WH0gts1IRm3C2d9i8-X4
288	36271	Head To Toe Salon	2445 Nicollet Ave S	Minneapolis	MN	f	t	\N	44.95756	-93.27757	2017-07-08 14:59:50.096-05	2020-04-14 16:18:31.539-05	US	f	f	f	f	f	ChIJPxzp4LUys1IR9RPKwCZAT54
289	1648	Luther Seminary	1501 Fulham Street	St. Paul	MN	f	t	\N	44.986473	-93.19757	2014-02-02 14:51:23.019-06	2014-02-02 14:51:23.019-06	US	f	t	f	f	f	ChIJpX3GQYwss1IRea418TgBf44
290	38934	Coffey Hall	Eckles Ave	Falcon Heights	MN	t	f	\N	44.982418	-93.18553	2017-12-07 11:03:38.226-06	2017-12-07 11:03:38.226-06	US	f	t	f	f	f	ChIJ_-psTIMss1IR3gQMf7qh0ik
291	65331	Mason Jar Kitchen & Bar	1565 Cliff Rd #1	Eagan	MN	t	t	\N	44.79113	-93.17986	2023-04-19 12:39:26.466-05	2023-04-19 12:39:26.552-05	US	t	f	f	f	f	ChIJpR4_6_Ux9ocRHUG1hhEEdgw
292	52948	7 Corners Coffee	1851 Washington Ave South	Minneapolis	MN	t	t	\N	44.97327	-93.24622	2019-09-22 15:09:54.575-05	2019-09-22 15:09:54.693-05	US	f	f	f	f	f	ChIJpey1l4cts1IRsksp_BWNRY8
293	30253	Rarig Center	330 21st Ave S	Minneapolis	MN	t	t	\N	44.970333	-93.24241	2017-02-25 23:39:23.675-06	2017-02-25 23:39:23.675-06	US	f	f	t	f	f	ChIJPahe_kAts1IRChyndjnUskI
294	17039	Punch Pizza	704 Cleveland Avenue South	St. Paul	MN	f	t	\N	44.920277	-93.18694	2015-04-04 19:44:41.2-05	2015-04-04 19:44:41.2-05	US	f	f	f	f	f	ChIJp8TF3IIp9ocR_hUgUV66Ujc
295	26119	Gloria Dei Lutheran Church	700 Snelling Avenue South	St. Paul	MN	t	t	\N	44.920216	-93.1661	2016-11-10 10:06:35.749-06	2016-11-10 10:06:35.749-06	US	f	f	t	f	f	ChIJP6_764_-tFIR2OqRUsb0nZU
296	35265	Saint Dinette	261 East 5th Street	St. Paul	MN	f	f	\N	44.949875	-93.08635	2017-05-25 18:04:11.065-05	2017-05-25 18:04:11.065-05	US	f	f	f	f	f	ChIJP4vxz1rV94cRXigToL4QASk
297	61805	1490 Co Rd E East, Vadnais Heights, MN 55110, USA	1490 Co Rd E East	Vadnais Heights	MN	t	t	\N	45.049072	-93.039696	2022-04-17 17:12:03.882-05	2022-04-17 17:12:03.955-05	US	t	f	f	f	f	ChIJp2UZbrnWslIRPciNIPqW6WU
298	35674	Target	7000 York Ave S	Edina	MN	t	t	\N	44.87538	-93.324234	2017-06-10 19:16:54.364-05	2017-06-10 19:16:54.364-05	US	t	f	f	f	f	ChIJP-0Ueh4k9ocRx5NKXAlurMM
299	49931	Punch Pizza	1018 County Hwy 96, Vadnais Heights, MN 55127, USA	Vadnais Heights	MN	t	f	\N	45.07887	-93.05713	2019-05-21 20:14:21.167-05	2019-05-21 20:14:21.261-05	US	t	f	f	f	f	ChIJozZHOAXXslIRvGUZU3yftKY
300	3791	Super America	4001 Lyndale Ave S.	Minneapolis	MN	f	t	\N	44.930237	-93.28826	2014-02-02 14:54:35.433-06	2014-02-02 14:54:35.433-06	US	f	f	t	f	f	ChIJOyWasLwn9ocRgqDsQwc-1GE
301	26745	Element Wood Fired Pizza	96 Broadway St NE	Minneapolis	MN	t	t	\N	44.998558	-93.26773	2016-11-25 17:44:17.537-06	2016-11-25 17:44:17.537-06	US	f	f	f	f	f	ChIJoyoHjnkys1IR44-5_FWgKJE
302	66289	Milkweed	3822 East Lake Street	Minneapolis	MN	t	t	\N	44.948578	-93.21675	2023-06-21 20:30:51.381-05	2023-06-21 20:30:51.471-05	US	f	f	f	f	f	ChIJoXFmhPkp9ocRGS_S8ddODig
303	47442	Southdale Office Center	6600 France Ave	Edina	MN	t	t	\N	44.88195	-93.330315	2019-02-10 13:24:11.974-06	2019-02-10 13:24:12-06	US	f	f	f	f	f	ChIJOwJUTq8m9ocRX7-Ti1qdaD0
304	65099	North Regional Library	1315 Lowry Ave. N.	Minneapolis	MN	t	f	\N	45.012856	-93.296326	2023-03-31 09:05:41.403-05	2023-03-31 09:05:41.495-05	US	t	f	t	f	f	ChIJoVWlTzcys1IR31ZL5TrTl-M
305	40823	Hyatt Regency Minneapolis	Hyatt Regency Minneapolis, Nicollet Mall	Minneapolis	MN	t	t	\N	44.97065	-93.2784	2018-04-08 10:47:09.509-05	2020-04-14 16:20:43.18-05	US	f	f	f	f	f	ChIJoUgrtr8ys1IRYgWtqMmFSGQ
306	41859	Moon Palace Books & Geek Love Cafe	3032 Minnehaha Ave	Minneapolis	MN	t	t	\N	44.94713	-93.23393	2018-06-16 13:07:40.983-05	2018-06-16 13:07:40.983-05	US	f	f	f	f	f	ChIJoTvsAzso9ocRTZ1i6IpFpmY
307	52302	Moon Palace	3032 Minnehaha Ave	Minneapolis	MN	t	t	\N	44.94713	-93.23393	2019-08-31 21:56:10.166-05	2019-08-31 21:56:10.265-05	US	t	t	f	f	f	ChIJoTvsAzso9ocRTZ1i6IpFpmY
308	43880	Moon Palace Books	3032 Minnehaha Ave s	Minneapolis	MN	t	f	\N	44.94713	-93.23393	2018-09-12 12:05:06.301-05	2018-09-12 12:05:06.301-05	US	t	t	f	f	f	ChIJoTvsAzso9ocRTZ1i6IpFpmY
309	39809	Midway Campus, 1450 Energy Park Dr, St Paul, MN 55108, USA	Midway Campus	St. Paul	MN	t	t	\N	44.970943	-93.162094	2018-02-05 15:45:02.986-06	2018-02-05 15:45:02.986-06	US	t	f	f	f	f	ChIJOStOIEErs1IR_OyVJ0hGg-M
310	39811	Midway Campus, 1450 Energy Park Dr, St Paul, MN 55108, USA	Midway Campus	St. Paul	MN	f	f	\N	44.971066	-93.16218	2018-02-05 21:31:00.407-06	2018-02-05 21:31:00.407-06	US	f	t	f	f	f	ChIJOStOIEErs1IR_OyVJ0hGg-M
311	26431	Target	1650 New Brighton Blvd, Minneapolis, MN 55413	Minneapolis	MN	t	t	\N	45.005253	-93.22942	2016-11-12 09:57:22.146-06	2016-11-12 09:57:22.146-06	US	f	f	f	f	f	ChIJO-NsULEts1IRr7KCqJ7z5Gc
312	46941	Health Partners 	3930 Northwoods Dr	Arden Hills 	MN	t	f	\N	45.05971	-93.15123	2019-01-11 18:24:20.115-06	2019-01-11 18:24:20.151-06	US	t	f	f	f	f	ChIJofe6fggps1IRRw9GRh4Urvk
313	59398	Hennepin Healthcare CSC 6th floor	715 S 8th St	Minneapolis	MN	t	t	\N	44.97116	-93.26322	2021-08-07 14:47:18.779-05	2024-03-16 20:23:41.797282-05	US	t	f	f	f	f	ChIJoe4JtAYzs1IRjY0erCiAQ7U
314	40774	Walker Library 	2880 Hennepin Ave	Minneapolis	MN	t	t	\N	44.949654	-93.29869	2018-04-05 22:14:40.939-05	2018-04-05 22:14:40.939-05	US	f	f	t	f	f	ChIJocz12IEn9ocRr1Gc1yMMXbE
315	21754	Wedge Table	2412 Nicollet Ave S	Minneapolis	MN	t	t	\N	44.9585	-93.2783	2016-04-30 16:33:19.982-05	2016-04-30 16:33:19.982-05	US	f	t	f	f	f	ChIJOcEFEbYys1IRpGYZeUh-VQY
316	24948	The Wedge Table	2412 Nicollet Ave	Minneapolis	MN	t	t	\N	44.9585	-93.2783	2016-08-25 14:00:58.917-05	2016-08-25 14:00:58.917-05	US	f	f	f	f	f	ChIJOcEFEbYys1IRpGYZeUh-VQY
317	29197	Wedge table	2412 nicollet ave	Minneapolis	MN	t	t	\N	44.9585	-93.2783	2017-02-24 21:02:45.019-06	2017-02-24 21:02:45.019-06	US	f	t	f	f	f	ChIJOcEFEbYys1IRpGYZeUh-VQY
318	21754	Wedge Table	2412 Nicollet Ave S	Minneapolis	MN	t	t	\N	44.9585	-93.2783	2016-04-30 16:33:19.982-05	2016-04-30 16:33:19.982-05	US	f	f	f	f	f	ChIJOcEFEbYys1IRpGYZeUh-VQY
319	44081	Wedge Table 	2412 Nicollet Ave	Minneapolis	MN	t	f	\N	44.958546	-93.278244	2018-09-14 15:22:30.342-05	2020-04-14 16:24:24.744-05	US	f	t	f	f	f	ChIJOcEFEbYys1IRpGYZeUh-VQY
320	35200	Moose and Sadie's	212 3rd Avenue North #107	Minneapolis	MN	f	t	\N	44.98533	-93.27203	2017-05-21 09:53:15.563-05	2017-05-21 09:53:15.563-05	US	f	f	f	f	f	ChIJoaYc9IUys1IR2EjkZayEfp4
321	30945	HyVee	9409 MN-610	Brooklyn Park	MN	t	f	\N	45.12502	-93.34414	2017-02-26 17:49:31.585-06	2017-02-26 17:49:31.585-06	US	f	f	f	f	f	ChIJoaOT4yY6s1IR8GCqVT3Jw4g
322	17892	Izzy's Ice Cream 	212 11th Avenue South	Minneapolis	MN	t	t	\N	44.976017	-93.253075	2015-06-29 14:05:31.646-05	2015-06-29 14:05:31.646-05	US	f	f	f	f	f	ChIJO9MqYWYts1IRZBuerAxTyB0
323	5850	University of Minnesota, Elliott Hall	75 E River Rd	Minneapolis	MN	t	t	\N	44.97697	-93.23825	2014-05-12 23:02:51.439-05	2014-05-12 23:02:51.439-05	US	f	f	f	f	f	ChIJO7bYbBQts1IRCOLdLdrlkVU
324	44440	Starbucks	5351 Lyndale Avenue S	Minneapolis	MN	t	t	\N	44.905243	-93.28796	2018-09-19 15:18:24.563-05	2020-04-14 16:28:08.428-05	US	t	f	f	f	f	ChIJo6wISUUm9ocR3uMuUuRohCU
325	17152	Tiny Diner	1024 East 38th Street	Minneapolis	MN	t	t	\N	44.934395	-93.25906	2015-04-15 19:19:30.151-05	2015-04-15 19:19:30.151-05	US	f	f	f	f	f	ChIJO4Ff5d8n9ocRMW9JwS44QEA
326	54060	Whole foods	305 Radio Dr	Woodbury 	MN	t	f	\N	44.943142	-92.929924	2019-11-18 19:58:18.033-06	2020-04-14 16:02:21.402-05	US	f	f	f	f	f	ChIJo3i3tb_Z94cRKq1TSiz75dI
327	24068	Kowalski's Market 	5327 Lyndale Avenue South	Minneapolis	MN	t	f	\N	44.905678	-93.2878	2016-07-15 19:41:21.019-05	2016-07-15 19:41:21.019-05	US	f	f	t	f	f	ChIJO1RUW0Um9ocRI82cjXQ5s6c
328	46335	755 Prior Ave N, St Paul, MN 55104, USA	755 Prior Ave N	St. Paul	MN	f	f	\N	44.964317	-93.182465	2018-12-06 23:26:19.043-06	2018-12-06 23:26:19.165-06	US	f	f	f	f	f	ChIJo03qu8Ats1IR-546PYOm_Ys
329	37924	3900 Bethel Dr, St Paul, MN 55112, USA	3900 Bethel Dr	St. Paul	MN	t	t	\N	45.05794	-93.161606	2017-09-26 19:46:10.098-05	2017-09-26 19:46:10.098-05	US	f	f	f	f	f	ChIJnZl0mhAps1IRqYFYtFSAK3A
330	27210	Golden's Deli	275 e 4th Street	St. Paul	MN	t	t	\N	44.949127	-93.08555	2016-12-22 23:36:13.884-06	2016-12-22 23:36:13.884-06	US	f	f	f	f	f	ChIJnzfp5M7UslIRKS7aP9KRcsg
331	5027	Twin Cities Leather and Lattee	2717 Hennepin Ave	Minneapolis	MN	t	t	\N	44.9531	-93.29748	2014-02-17 22:48:17.647-06	2014-02-17 22:48:23.778-06	US	f	f	f	f	f	ChIJnZELSNUys1IRpi-OVLIzbE0
332	24216	Sebastian Joe's	4321 Upton S Upton Ave	Minneapolis	MN	t	t	\N	44.905315	-93.314575	2016-07-22 21:03:51.714-05	2016-07-22 21:03:51.714-05	US	f	f	f	f	f	ChIJNYSc5hkn9ocR0UqgY-_SJOY
333	35607	Sebastian Joe's ice cream 	4321 Upton Ave S	Minneapolis	MN	f	t	\N	44.923832	-93.31463	2017-06-08 12:37:53.987-05	2017-06-08 12:37:53.987-05	US	f	t	f	f	f	ChIJNYSc5hkn9ocR0UqgY-_SJOY
334	24225	Sebastian Joe's ice cream 	4321 Upton ave S	Minneapolis	MN	t	t	\N	44.923817	-93.31455	2016-07-23 07:54:39.354-05	2016-07-23 07:54:39.354-05	US	f	t	f	f	f	ChIJNYSc5hkn9ocR0UqgY-_SJOY
335	24226	Sebastian Joe's ice cream 	4321 Upton ave S	Minneapolis	MN	t	t	\N	44.923817	-93.31455	2016-07-23 07:54:47.328-05	2016-07-23 07:54:47.328-05	US	f	f	f	f	f	ChIJNYSc5hkn9ocR0UqgY-_SJOY
336	24218	Sebastian Joe's ice cream 	4321 Upton ave S	Minneapolis	MN	t	t	\N	44.923817	-93.31455	2016-07-22 21:07:10.132-05	2016-07-22 21:07:10.132-05	US	f	t	f	f	f	ChIJNYSc5hkn9ocR0UqgY-_SJOY
337	24219	Sebastian Joe's ice cream 	4321 Upton ave S	Minneapolis	MN	t	t	\N	44.923817	-93.31455	2016-07-22 21:07:10.586-05	2016-07-22 21:07:10.586-05	US	f	t	f	f	f	ChIJNYSc5hkn9ocR0UqgY-_SJOY
338	33658	Sonic	1960 Suburban Ave	St. Paul	MN	t	f	\N	44.94945	-93.01758	2017-04-05 19:18:29.506-05	2017-04-05 19:18:29.506-05	US	f	f	t	f	f	ChIJnyPEn-LV94cRVaghC8_Blx4
339	19661	Munkabeans Cafe and Coffee House	Mainstreet	Hopkins	MN	t	t	\N	44.924362	-93.415245	2015-12-20 20:35:30.8-06	2015-12-20 20:35:30.8-06	US	f	f	f	f	f	ChIJnybqjMcys1IRXjezTc6JuQk
340	24323	Namaste Cafe	2512 Hennepin Ave S	Minneapolis	MN	t	t	\N	44.956795	-93.29589	2016-07-28 10:03:37.274-05	2016-07-28 10:03:37.274-05	US	f	f	f	f	f	ChIJNxwjJNQys1IRYiQDwoG0XLE
341	45002	Caribou	1100 county 42 E	Burnsville	MN	t	f	\N	44.738174	-93.25887	2018-10-08 14:26:20.953-05	2018-10-08 14:26:20.953-05	US	t	f	f	f	f	ChIJnXv6uF869ocR1IoSyf44U7M
342	41889	Huge improv theater	3037 Lyndale Avenue S	Minneapolis	MN	t	t	\N	44.947025	-93.2877	2018-06-18 09:21:25.885-05	2020-04-14 16:23:48.956-05	US	t	f	f	f	f	ChIJNWpAQo8n9ocR6vreLhRXcg8
343	30330	Minneapolis Community and Technical College	1501 Hennepin Ave	Minneapolis	MN	t	t	\N	44.97243	-93.28445	2017-02-26 03:34:29.087-06	2020-04-14 16:15:42.495-05	US	f	t	f	f	f	ChIJnWP8Zuoys1IRGhJgJrweDP4
344	28253	Minneapolis Community and Technical College	1501 Hennepin Ave	Minneapolis	MN	t	t	\N	44.97324	-93.28409	2017-02-23 13:12:50.491-06	2017-02-23 13:12:50.491-06	US	f	f	f	f	f	ChIJnWP8Zuoys1IRGhJgJrweDP4
345	36069	Highland Park Library	1974 Ford Parkway	St. Paul	MN	f	t	\N	44.917564	-93.18299	2017-06-28 10:11:11.401-05	2017-06-28 10:11:11.401-05	US	f	t	f	f	f	ChIJnW6rtHgp9ocRW7D87M1SdJE
346	67471	Highland Park Library	1974 Ford Parkway	St. Paul	MN	t	f	\N	44.917725	-93.18328	2023-09-27 11:45:12.357-05	2023-09-27 11:45:12.46-05	US	f	f	f	f	f	ChIJnW6rtHgp9ocRW7D87M1SdJE
347	54231	Bad Waitress	26th st	Minneapolis	MN	f	t	\N	44.95554	-93.246124	2019-11-26 20:47:48.823-06	2020-04-14 16:03:32.442-05	US	f	f	f	f	f	ChIJnTywWLQys1IRkNxuj8Iz0xs
348	22662	36LYN	3551 Lyndale Ave s	Minneapolis	MN	t	t	\N	44.937897	-93.28782	2016-06-12 18:00:32.712-05	2016-06-12 18:00:32.712-05	US	f	f	f	f	f	ChIJnSpvQ5cn9ocR0_n346YPg5s
349	22700	DeWitt Wallace Library  (Macalester College)	110 Macalester Street	St. Paul	MN	t	t	\N	44.93917	-93.16954	2016-06-12 20:40:19.623-05	2016-06-12 20:40:19.623-05	US	f	f	f	f	f	ChIJN_rFwxkq9ocRqKaciP_6O-0
350	64207	The Home Depot 	1520 New Brighton Blvd	Minneapolis	MN	t	f	\N	45.00505	-93.234314	2022-12-28 10:31:09.594-06	2022-12-28 10:31:09.707-06	US	t	f	f	f	f	ChIJnQRR1rMts1IRoJvmIpR2FJ0
351	29001	Michael's arts and crafts	1620 New Brighton Blvd	Minneapolis	MN	t	f	\N	45.005035	-93.23127	2017-02-24 17:52:55.871-06	2017-02-24 17:52:55.871-06	US	f	f	f	f	f	ChIJnfZ_KLEts1IRTjVaT5KPUHI
352	65356	East Medicine Lake Park	1740 E Medicine Lake Blvd	Plymouth	MN	t	t	\N	44.997967	-93.40371	2023-04-22 16:12:52.191-05	2023-04-22 16:12:52.31-05	US	f	f	f	f	f	ChIJndh11L01s1IR4LAOjH0vKFw
353	53348	Eden Prairie Art Center	7650 Equitable Drive	Eden Prairie	MN	t	f	\N	44.865086	-93.45484	2019-10-12 15:09:02.477-05	2019-10-12 15:09:02.591-05	US	t	f	f	f	f	ChIJnciYytAY9ocRlZ3KlTE4RYs
354	53347	Eden Prairie Art Center	7650 Equitable Drive	Eden Prairie	MN	t	t	\N	44.865086	-93.45484	2019-10-12 15:07:16.025-05	2019-10-12 15:07:16.165-05	US	t	t	f	f	f	ChIJnciYytAY9ocRlZ3KlTE4RYs
355	44888	Minnesota History Center	Kellogg Blvd	St. Paul	MN	t	t	\N	44.946285	-93.10405	2018-10-04 15:22:14.993-05	2018-10-04 15:22:14.993-05	US	f	f	f	f	f	ChIJN-BrLq4q9ocRJT5wnCKW4LI
356	3841	Caribou Coffee	1055 Grand Ave	St. Paul	MN	f	f	\N	44.940308	-93.14471	2014-02-02 14:54:38.944-06	2014-02-02 14:54:38.944-06	US	f	f	f	f	f	ChIJn9RfGWcq9ocR_Rf5-zdbk3k
357	41507	Tilt Bar	113 E 26th St	Minneapolis	MN	f	t	\N	44.955536	-93.248055	2018-05-25 23:09:52.237-05	2018-05-25 23:09:52.237-05	US	f	f	f	f	f	ChIJN6gz-LQys1IRe01yLMJRAPw
358	35493	Tilt Bar	113 E 26th St	Minneapolis	MN	t	t	\N	44.955162	-93.275604	2017-06-03 01:28:36.273-05	2017-06-03 01:28:36.273-05	US	f	t	f	f	f	ChIJN6gz-LQys1IRe01yLMJRAPw
359	51211	Bull's Horn	4563 34th Ave S	Minneapolis	MN	t	t	\N	44.919678	-93.22292	2019-07-21 20:04:07.091-05	2019-07-21 20:04:07.113-05	US	f	t	f	f	f	ChIJN55LK1Qo9ocRwkSM-Snn4co
360	49048	Bull's Horn	4563 34th Ave S	Minneapolis	MN	f	f	\N	44.919678	-93.22292	2019-04-10 20:02:35.978-05	2019-04-10 20:02:36.077-05	US	f	t	f	f	f	ChIJN55LK1Qo9ocRwkSM-Snn4co
361	32858	Folwell Hall	9 Pleasant St. SE	Minneapolis	MN	t	t	\N	44.97839	-93.234726	2017-03-02 14:40:02.448-06	2017-03-02 14:40:02.448-06	US	f	f	f	f	f	ChIJN3cLxxYts1IR_MY7aQRDhDw
362	32859	Folwell Hall	9 Pleasant St. SE	Minneapolis	MN	t	t	\N	44.97839	-93.234726	2017-03-02 14:40:02.755-06	2017-03-02 14:40:02.755-06	US	f	t	f	f	f	ChIJN3cLxxYts1IR_MY7aQRDhDw
363	3987	Ichiban's Japanese Steakhouse	1333 Nicollet Mall	Minneapolis	MN	t	t	\N	44.970158	-93.27778	2014-02-02 14:54:55.497-06	2014-02-02 14:54:55.497-06	US	f	f	f	f	f	ChIJmzp-TL4ys1IRUU-csrW4N2A
364	2380	Starbucks 	2078 Ford Parkway	St. Paul	MN	t	f	\N	44.917515	-93.18817	2014-02-02 14:52:23.161-06	2014-02-02 14:52:23.161-06	US	f	f	f	f	f	ChIJMYqrHXgp9ocR5OZG3dTPb94
365	3986	Trader Joes	484 Lexington Parkway South	St. Paul	MN	f	t	\N	44.92683	-93.14658	2014-02-02 14:54:55.436-06	2014-02-02 14:54:55.436-06	US	f	f	f	f	f	ChIJM-wmSlAq9ocRo4Pl5Zr7Uu8
366	4624	McNamara Alumni Center	200 Oak St SE	Minneapolis	MN	t	t	\N	44.974457	-93.22735	2014-02-07 12:01:15.919-06	2014-02-07 12:01:23.116-06	US	f	f	f	f	f	ChIJMWBR7Rgts1IRrbbqTFlPmF8
367	42632	Anelace Coffee	2402 Central Ave NE	Minneapolis	MN	t	t	\N	45.012405	-93.24757	2018-07-29 02:15:30.76-05	2018-07-29 02:15:30.76-05	US	f	f	f	f	f	ChIJMVL5qOsts1IRvROqnWXRtLA
368	33117	Claddagh Coffee	459 7th St W	St. Paul	MN	t	t	\N	44.93825	-93.11157	2017-03-03 15:13:41.869-06	2017-03-03 15:13:41.869-06	US	f	f	f	f	f	ChIJmTWKQccq9ocR7vtHByiPSOk
369	64922	Ritz Theater	345 13th Ave NE	Minneapolis	MN	t	t	\N	45.001247	-93.262245	2023-03-11 07:25:59.917-06	2023-03-11 07:26:00.01-06	US	t	f	f	f	f	ChIJM_rObYgts1IRdJZpnAEqnI0
370	5969	Valleyfair	1 Valleyfair Drive	Shakopee	MN	t	f	\N	44.79906	-93.45421	2014-05-20 12:34:37.72-05	2014-05-20 12:34:37.72-05	US	f	f	t	f	f	ChIJMRDEWCoY9ocRejVyeNYs1X0
371	5968	Valleyfair	Valleyfair Drive	Shakopee	MN	t	f	\N	44.79708	-93.45006	2014-05-20 12:32:21.549-05	2014-05-20 12:32:21.549-05	US	f	t	f	f	f	ChIJMRDEWCoY9ocRejVyeNYs1X0
372	52274	Victory auto 	2128 Rice St	Maplewood	MN	t	t	\N	45.004887	-93.10525	2019-08-30 14:40:32.849-05	2019-08-30 14:40:32.871-05	US	t	f	f	f	f	ChIJ_-mmeXcqs1IRNNww51nNpts
373	61312	Texas roadhouse	8160 Old Carriage Ct North	Shakopee	MN	f	t	\N	44.78115	-93.41419	2022-03-06 21:09:07.12-06	2022-03-06 21:09:07.211-06	US	f	f	f	f	f	ChIJmcM4uJA99ocRntqRF-qLox4
374	32141	Holiday	2448 Hennepin Ave S	Minneapolis	MN	t	t	\N	44.95792	-93.295006	2017-02-28 11:13:53.682-06	2017-02-28 11:13:53.682-06	US	f	f	f	f	f	ChIJMclEmNYys1IROrQ63M42HVA
375	28199	Community Grounds Coffee Shop	560 40th Ave NE	Columbia Heights	MN	t	t	\N	45.040783	-93.25761	2017-02-22 21:20:43.946-06	2017-02-22 21:20:43.946-06	US	f	f	t	f	f	ChIJmcdomhAus1IRo8lRJmtF6NY
376	36227	Washburn Library	5244 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.907482	-93.28878	2017-07-05 22:14:49.391-05	2017-07-05 22:14:49.391-05	US	t	f	f	f	f	ChIJmb95308m9ocRIvZ9cU24B0o
377	29591	Pacifier	219 n 2nd st #102	Minneapolis	MN	f	f	\N	44.98473	-93.27107	2017-02-25 10:35:20.241-06	2017-02-25 10:35:20.241-06	US	f	f	f	f	f	ChIJm9ni7IUys1IRpH3r1fY5Qtg
378	18371	Birchwood Cafe	3311 E 25th St	Minneapolis	MN	t	t	\N	44.957226	-93.2234	2015-08-13 19:46:14.799-05	2015-08-13 19:46:14.799-05	US	f	f	f	f	f	ChIJm7-wgCsts1IRNgDPE2Vlk28
379	17768	Excelsior Library Hennepin County	337 Water Street	Excelsior	MN	t	t	\N	44.901207	-93.56687	2015-06-16 14:26:52.398-05	2015-06-16 14:26:52.398-05	US	f	f	f	f	f	ChIJLzwcfdkc9ocRSrEkajzvuRs
380	27455	Al Vento italian restaurant	5001 S 34 avenue	Minneapolis	MN	f	t	\N	44.91241	-93.222664	2017-01-14 14:39:27.091-06	2017-01-14 14:39:27.091-06	US	f	f	f	f	f	ChIJLZeFA_wo9ocRWbIqG7GUN0M
381	41165	Magrath Library	1984 Buford Avenue	St. Paul	MN	t	t	\N	44.984142	-93.18367	2018-05-01 11:08:10.389-05	2020-04-14 16:20:34.169-05	US	t	f	f	f	f	ChIJLywy0oIss1IRkLtzTBa1qvs
382	25310	Amore Coffee	879 Smith Ave South	St. Paul	MN	t	t	\N	44.91949	-93.10206	2016-09-04 10:22:50.225-05	2016-09-04 10:22:50.225-05	US	f	f	f	f	f	ChIJlYwqFior9ocRZAHPXA8csRQ
383	55995	3739 Tonkawood Rd, Minnetonka, MN 55345, USA	3739 Tonkawood Rd	Minnetonka	MN	t	t	\N	44.9347	-93.48124	2020-05-11 16:50:15.511-05	2020-05-11 16:50:15.603-05	US	t	f	f	f	f	ChIJlyd7OBYe9ocRmSC7yZuc1Cs
384	59306	Starbucks	11100 62nd St W	Eden Prairie	MN	f	t	\N	44.892056	-93.41871	2021-08-06 16:24:13.805-05	2021-08-06 16:24:13.879-05	US	t	f	f	f	f	ChIJlwGIFuAh9ocRoZzbQG8UC-0
385	62140	Mall of America (North food court) 	60 east broadway	Bloomington	MN	t	t	\N	44.854774	-93.24203	2022-05-21 16:24:20.507-05	2022-05-21 16:24:20.646-05	US	t	f	f	f	f	ChIJLWE8OWwv9ocRayh4boDxxrM
386	5047	West Bank Office Building, Univeristy of Minnesota	1300 2nd Street S	Minneapolis	MN	t	t	\N	44.97585	-93.24812	2014-02-18 16:08:56.122-06	2014-02-18 16:08:56.122-06	US	f	f	f	f	f	ChIJlSbXHWkts1IRnQG20L7P2w0
387	52079	Fort Snelling	Fort Snelling 	Minneapolis	MN	t	f	\N	44.89279	-93.18085	2019-08-21 12:29:21.917-05	2019-08-21 12:29:22.031-05	US	f	f	f	f	f	ChIJLQEuVVgp9ocRXc80ju8lvOI
388	60731	Magus Books & Herbs	1848 central ave	Minneapolis	MN	t	t	\N	45.007706	-93.247604	2021-12-30 21:59:11.411-06	2021-12-30 21:59:11.482-06	US	f	f	f	f	f	ChIJLeRpIhIts1IRn41wbypBRRE
389	54245	University Service/Nelson's Auto World	1625 Como Ave	Minneapolis	MN	t	t	\N	44.988182	-93.22863	2019-11-27 14:00:51.835-06	2020-04-14 16:03:45.209-05	US	f	f	f	f	f	ChIJLeLDlgYts1IRhr6fl0RcBCk
390	28419	The Bad Waitress NE	700 Central Ave NE	Minneapolis	MN	t	t	\N	44.990803	-93.25129	2017-02-23 22:01:27.332-06	2017-02-23 22:01:27.332-06	US	f	f	t	f	f	ChIJldqvtD8ts1IRKcdSmvmMX94
391	65800	Hope Breakfast Bar	1 South Leech St	St. Paul 	MN	t	t	\N	44.94117	-93.107994	2023-05-21 17:45:42.701-05	2023-05-21 17:45:42.806-05	US	f	f	f	f	f	ChIJLd8vPjwr9ocRvzzASelSZPE
392	40873	Cafe Racer Kitchen	2929 E 25th s	Minneapolis	MN	f	f	\N	44.957226	-93.228546	2018-04-10 11:28:11.469-05	2020-04-14 16:20:52.812-05	US	f	f	f	f	f	ChIJlarheDIts1IRDBmF1PoSQP0
393	66831	Saint Clements Episcopal Church	901 Portland Ave.	St. Paul	MN	t	t	\N	44.9432	-93.13842	2023-08-04 16:09:32.593-05	2023-08-04 16:09:32.799-05	US	t	f	f	f	f	ChIJl84qA2Iq9ocRLksnPlJsr5o
394	37329	lu's sandwiches	10 6th St NE	Minneapolis	MN	t	f	\N	44.98993	-93.252594	2017-08-29 15:51:29.166-05	2017-08-29 15:51:29.166-05	US	f	f	f	f	f	ChIJL4_lH3gts1IRrMqE72fIH40
395	59486	Andrews Park	7200 117th Ave N	Champlin 	MN	t	f	\N	45.167507	-93.37452	2021-08-07 23:15:19.172-05	2021-08-07 23:15:19.268-05	US	t	f	f	f	f	ChIJkzJJyFE5s1IRW4_99wEt30g
396	20567	Walker Art Center	1750 Hennepin Avenue	Minneapolis	MN	t	t	\N	44.968437	-93.28854	2016-03-26 10:53:25.086-05	2016-03-26 10:53:25.086-05	US	f	f	t	f	f	ChIJkXzI4m4rs1IRkr3SSCf_DcI
397	55227	Walker Art Center	Vineland Place	Minneapolis	MN	t	f	\N	44.96895	-93.28886	2020-02-08 09:44:30.797-06	2020-04-14 16:03:17.379-05	US	t	t	f	f	f	ChIJkXzI4m4rs1IRkr3SSCf_DcI
398	31566	Chin Dian 	1500 E Hennepin Ave	Minneapolis	MN	t	t	\N	44.991306	-93.230385	2017-02-27 13:24:56.218-06	2017-02-27 13:24:56.218-06	US	f	t	f	f	f	ChIJkxLkjgcts1IROIWds-oBhwM
399	26737	Chin Dian	1500 E Hennepin Ave	Minneapolis	MN	t	t	\N	44.991306	-93.230385	2016-11-25 13:51:12.848-06	2016-11-25 13:51:12.848-06	US	f	t	f	f	f	ChIJkxLkjgcts1IROIWds-oBhwM
400	32249	Chin Dian Cafe	1500 East Hennepin Ave	Minneapolis	MN	t	t	\N	44.991306	-93.230385	2017-02-28 21:13:13.537-06	2017-02-28 21:13:13.537-06	US	f	f	f	f	f	ChIJkxLkjgcts1IROIWds-oBhwM
401	29798	Kopplin's 	2038 Marshall Ave	St. Paul 	MN	f	f	\N	44.948135	-93.18641	2017-02-25 14:08:16.101-06	2017-02-25 14:08:16.101-06	US	f	f	f	f	f	ChIJKVCyN0gq9ocRKLhjMSOvkMA
402	25423	Heller Hall	19th Avenue South	Minneapolis	MN	t	t	\N	44.97164	-93.24376	2016-09-09 13:50:17.289-05	2016-09-09 13:50:17.289-05	US	f	f	f	f	f	ChIJkRdSwEEts1IRPFeqEPt6Dv0
403	17999	Heller Hall	19th Avenue South	Minneapolis	MN	f	f	\N	44.969757	-93.24564	2015-07-15 02:59:13.452-05	2015-07-15 02:59:13.452-05	US	f	t	f	f	f	ChIJkRdSwEEts1IRPFeqEPt6Dv0
404	27910	Parkway pizza	4359 minnehaha	Minneapolis	MN	f	t	\N	44.9235	-93.21644	2017-02-03 16:07:24.826-06	2017-02-03 16:07:24.826-06	US	f	f	f	f	f	ChIJK-MGUKkp9ocRcWmCjUaoE2o
405	27806	Peters Hall, UMN-St. Paul Campus	1404 Gortner Ave	St. Paul	MN	t	t	\N	44.98344	-93.18122	2017-01-27 16:47:29.233-06	2017-01-27 16:47:29.233-06	US	f	f	f	f	f	ChIJKfVlVp0ss1IRWUPA9UNAHK8
406	58776	Starbucks	7190 E Pt Douglas Rd S	Cottage Grove	MN	t	t	\N	44.833168	-92.95713	2021-08-01 18:47:57.2-05	2021-08-01 18:47:57.297-05	US	t	f	t	f	f	ChIJK9yGhmrQ94cR4EzX5F2IPLU
407	26170	Luther Seminary	1490 Fulham St	St. Paul 	MN	t	t	\N	44.98569	-93.196686	2016-11-10 13:57:15.609-06	2016-11-10 13:57:15.609-06	US	f	f	f	f	f	ChIJk7-KsvQss1IR5nLA0XSBJKM
408	64402	Starbucks	7802 Olson Memorial Highway #140	Golden Valley	MN	t	t	\N	44.98424	-93.3791	2023-01-19 09:16:23.62-06	2023-01-19 09:16:23.831-06	US	t	f	f	f	f	ChIJk6Cuxv40s1IRsPW8t9BtQWw
409	26482	University of Minnesota Institute of Child Development	51 E. River Rd.	Minneapolis	MN	f	t	\N	44.978447	-93.239296	2016-11-13 07:07:57.885-06	2016-11-13 07:07:57.885-06	US	f	f	f	f	f	ChIJK5hFchMts1IRsPNy-5dkaZ0
410	58193	Grandma's Bakery	2184 4th Street	White Bear Lake	MN	f	t	\N	45.08521	-93.00838	2021-07-07 22:56:20.749-05	2021-07-07 22:56:20.839-05	US	f	f	f	f	f	ChIJk4FjoenQslIRc8awlk2K4F8
411	22096	Lakewinds 	6420 Lyndale Ave S.	Richfield 	MN	t	t	\N	44.886536	-93.28854	2016-05-15 15:39:31.833-05	2016-05-15 15:39:31.833-05	US	f	f	f	f	f	ChIJk3nyDXAm9ocRjzGQc71PW44
412	50723	Caribou Coffee 	8208 MN-7	St. Louis Park	MN	t	f	\N	44.93689	-93.38369	2019-06-27 17:09:22.129-05	2019-06-27 17:09:22.148-05	US	t	f	f	f	f	ChIJk1jQ8WMg9ocRsQCNje3SqxI
413	36924	Espresso Royale	Fairview Avenue South	St. Paul	MN	f	t	\N	44.92611	-93.17719	2017-08-12 09:47:12.649-05	2017-08-12 09:47:12.649-05	US	f	f	f	f	f	ChIJjZ_YGigq9ocRI9WIXBHgCGM
414	30944	HyVee	8200 42nd Ave N	New Hope	MN	t	f	\N	45.035233	-93.383606	2017-02-26 17:46:49.2-06	2017-02-26 17:46:49.2-06	US	f	f	f	f	f	ChIJjYIfHYY2s1IRu0QdVgnzjt4
415	1653	Mississippi Market Natural Foods Co-op	622 Selby Ave.	St. Paul	MN	f	t	\N	44.94639	-93.12663	2014-02-02 14:51:23.205-06	2014-02-02 14:51:23.205-06	US	f	f	f	f	f	ChIJJxVBOJAq9ocRq1aCUBqBQIM
416	44397	St Louis Park Middle School	Texas Ave south	St. Louis Park	MN	t	t	\N	44.95303	-93.38104	2018-09-18 18:15:48.366-05	2018-09-18 18:15:48.366-05	US	f	f	f	f	f	ChIJJwqUwtg0s1IRsS66IMVpl1I
417	66426	Nouvelle Brewing by Travail	4124 W Broadway	Robbinsdale	MN	t	t	\N	45.030437	-93.33788	2023-06-30 19:10:05.118-05	2023-06-30 19:10:05.256-05	US	f	f	f	f	f	ChIJjVoiWpgxs1IRHOAn_JSJYi4
418	30507	Hamline University Drew Hall	1523 Hewitt Ave	St. Paul	MN	t	t	\N	44.96696	-93.16436	2017-02-26 10:03:58.455-06	2020-04-14 16:16:56.874-05	US	f	f	f	f	f	ChIJJ_sMWCQrs1IRDDmuMTn7TDI
419	28854	The Blake School	511 Kenwood Pkwy	Minneapolis	MN	t	t	\N	44.969337	-93.29324	2017-02-24 14:53:57.76-06	2017-02-24 14:53:57.76-06	US	f	f	f	f	f	ChIJjeKGvN0ys1IRxKmJgDzSURc
420	45480	Education Sciences Building	56 E River Rd	Minneapolis	MN	t	f	\N	44.978455	-93.239494	2018-10-28 23:05:19.661-05	2020-04-14 16:34:45.668-05	US	f	f	f	f	f	ChIJjdmMahMts1IRUJEbSKxtZUU
421	46369	3800 Lexington Ave N, Shoreview, MN 55126, USA	3800 Lexington Ave N	Shoreview	MN	t	f	\N	45.05633	-93.14399	2018-12-09 12:40:33.639-06	2018-12-09 12:40:33.769-06	US	f	f	f	f	f	ChIJjdbkm6Yps1IRTwGV1n-50ew
422	38671	270 Cottage Pl, Shoreview, MN 55126, USA	270 Cottage Pl	Shoreview	MN	t	t	\N	45.045246	-93.11154	2017-11-14 19:31:02.965-06	2017-11-14 19:31:02.965-06	US	f	f	f	f	f	ChIJj9VSjeMps1IRbwvxO8rJ1Zc
423	24271	Starbucks	16227 Kenrick Ave	Lakeville 	MN	t	f	\N	44.713505	-93.28022	2016-07-24 19:27:18.692-05	2016-07-24 19:27:18.692-05	US	f	f	t	f	f	ChIJJ3w6k5Q59ocRXxXiblDzTWs
424	32222	Starbucks 	16227 Kenrick Ave	Lakeville 	MN	t	t	\N	44.713505	-93.28022	2017-02-28 19:57:11.921-06	2017-02-28 19:57:11.921-06	US	f	f	f	f	f	ChIJJ3w6k5Q59ocRXxXiblDzTWs
425	29288	Scheunemann Tax Service	559 Coon Rapids Boulevard	Coon Rapids	MN	f	t	\N	45.14458	-93.281456	2017-02-24 22:38:17.421-06	2017-02-24 22:38:17.421-06	US	f	f	f	f	f	ChIJj1MloSw7s1IRufv-SJPgbCI
426	28245	Quixotic Coffee	769 Cleveland	St. Paul	MN	t	t	\N	44.918327	-93.187584	2017-02-23 12:31:57.137-06	2017-02-23 12:31:57.137-06	US	f	t	f	f	f	ChIJizDUqYIp9ocRkvvQkEGU9PQ
427	36499	Quixotic Coffee	769 Cleavland Ave S	St. Paul	MN	t	t	\N	44.918327	-93.187584	2017-07-19 16:20:27.096-05	2017-07-19 16:20:27.096-05	US	f	f	f	f	f	ChIJizDUqYIp9ocRkvvQkEGU9PQ
428	36500	Quixotic Coffee	769 Cleveland Ave S	St. Paul	MN	f	f	\N	44.918327	-93.187584	2017-07-19 16:23:25.638-05	2017-07-19 16:23:25.638-05	US	f	t	f	f	f	ChIJizDUqYIp9ocRkvvQkEGU9PQ
429	28389	Mechanical Engineering Building	111 Church St SE, Minneapolis, MN 55455 At this address	Minneapolis	MN	t	t	\N	44.975235	-93.23356	2017-02-23 21:12:38.11-06	2017-02-23 21:12:38.11-06	US	f	f	f	f	f	ChIJiYX2qhcts1IRNVU0wshc08w
430	53647	Mechanical Engineering Building	Church Street SE	Minneapolis	MN	f	t	\N	44.97489	-93.233864	2019-10-29 00:54:03.545-05	2019-10-29 00:54:03.698-05	US	f	t	f	f	f	ChIJiYX2qhcts1IRNVU0wshc08w
431	33317	YUM!	6001 Shady Oak Road	Minnetonka	MN	f	f	\N	44.89487	-93.420006	2017-03-30 16:36:46.569-05	2017-03-30 16:36:46.569-05	US	f	f	f	f	f	ChIJIyv6LmAf9ocRZdkOIRYoqn0
432	58666	Best Western Plus	4940 Highway 61	White Bear Lake	MN	t	f	\N	45.090515	-93.006096	2021-08-01 00:29:27.201-05	2021-08-01 00:29:27.292-05	US	t	f	f	f	f	ChIJIym-puzQslIR19SR4fhV8PM
434	29886	Half Price Books 	5017 Excelsior Boulevard	St. Louis Park 	MN	t	t	\N	44.93094	-93.34572	2017-02-25 15:22:20.884-06	2017-02-25 15:22:20.884-06	US	f	f	t	f	f	ChIJIxQHwskg9ocRvaMJlVO4pqs
435	2816	Hard Times Cafe	1821 Riverside Ave	Minneapolis	MN	f	t	\N	44.96954	-93.24612	2014-02-02 14:53:01.508-06	2014-03-07 00:12:11.495-06	US	f	f	f	f	f	ChIJIxHJx0Mts1IRlGMFZ_q61xo
436	59530	Trader Joe's	1041 Red Fox Rd	Shoreview	MN	t	t	\N	45.05799	-93.14473	2021-08-12 15:13:21.702-05	2021-08-12 15:13:21.783-05	US	f	f	f	f	f	ChIJIVyXaKYps1IRd15pP-ssctg
437	36908	J. Selby's 	169 N Victoria St	St. Paul	MN	t	t	\N	44.946373	-93.13668	2017-08-11 11:23:52.081-05	2017-08-11 11:23:52.081-05	US	t	f	f	f	f	ChIJiUzxP4gq9ocRvFPpu-wAMFU
438	36670	Ramsey County Library - Shoreview	4560 Victoria	Shoreview 	MN	t	t	\N	45.080505	-93.1355	2017-07-28 14:23:11.237-05	2017-07-28 14:23:11.237-05	US	f	f	f	f	f	ChIJITb4W0Yos1IRnxqReah-HEc
439	2806	Dunn Brothers Coffee	11 Water St	Excelsior	MN	t	f	\N	44.903896	-93.56555	2014-02-02 14:53:00.763-06	2014-02-02 14:53:00.763-06	US	f	f	f	f	f	ChIJIRfCyN4c9ocR02zWvyY-iiI
440	66201	Shakopee Community Center	1255 Fuller St S	Shakopee	MN	t	t	\N	44.78503	-93.52592	2023-06-16 13:33:35.795-05	2023-06-16 13:33:35.933-05	US	t	f	f	f	f	ChIJIf6FTZAQ9ocRWFvWdORDR_A
441	27232	Intermedia arts	2822 lyndale ave s	Minneapolis	MN	t	f	\N	44.951138	-93.288605	2016-12-23 23:39:56.614-06	2016-12-23 23:39:56.614-06	US	f	t	f	f	f	ChIJid_6D4gn9ocRGuBj5R0jpAc
442	26420	Intermedia Arts	2822 Lyndale Ave South	Minneapolis	MN	t	t	\N	44.951138	-93.288605	2016-11-12 01:02:14.759-06	2016-11-12 01:02:14.759-06	US	f	t	f	f	f	ChIJid_6D4gn9ocRGuBj5R0jpAc
443	37009	Intermedia Arts	2822 Lyndale Avenue	Minneapolis	MN	t	t	\N	44.951138	-93.288605	2017-08-16 11:39:41.828-05	2017-08-16 11:39:41.828-05	US	t	f	f	f	f	ChIJid_6D4gn9ocRGuBj5R0jpAc
444	46643	Hi-Lo Diner	4020 E Lake St	Minneapolis	MN	t	t	\N	44.948593	-93.214264	2018-12-27 11:44:15.391-06	2018-12-27 11:44:15.532-06	US	t	f	f	f	f	ChIJid5-x9Mp9ocRa8O-g-WPPRQ
445	41093	Hi lo diner	Lake street	Minneapolis	MN	f	f	\N	44.948307	-93.24022	2018-04-25 21:00:03.306-05	2018-04-25 21:00:03.306-05	US	f	t	f	f	f	ChIJid5-x9Mp9ocRa8O-g-WPPRQ
446	55051	Falling Knife	Harding	Minneapolis	MN	t	t	\N	44.99512	-93.22153	2020-01-27 17:09:22.744-06	2020-04-14 16:00:49.002-05	US	t	f	f	f	f	ChIJI8TapUMts1IR0t5gV3FVG4I
447	2390	Cahoots Coffee Bar	1562 Selby Avenue	St. Paul	MN	t	f	\N	44.94645	-93.1662	2014-02-02 14:52:23.853-06	2014-02-02 14:52:23.853-06	US	f	f	f	f	f	ChIJI7NUJBAq9ocRSX8SFSlj6SY
448	222	YWCA Uptown	2808 Hennepin Ave South	Minneapolis	MN	t	t	\N	44.95171	-93.29828	2014-02-02 14:49:21.157-06	2014-02-02 14:49:21.157-06	US	f	f	t	f	f	ChIJi6DyG4An9ocRg3irsNa2gAk
449	37378	Sassy Spoon	5011 34th Avenue South	Minneapolis	MN	t	t	\N	44.91217	-93.222565	2017-09-01 08:22:12.657-05	2017-09-01 08:22:12.657-05	US	t	f	f	f	f	ChIJi6dABfwo9ocR5p6kAM2azjA
450	17096	Sassy Spoon	5007 South 34th Avenue	Minneapolis	MN	f	t	\N	44.912247	-93.22268	2015-04-10 18:40:58.141-05	2015-04-10 18:40:58.141-05	US	f	t	f	f	f	ChIJi6dABfwo9ocR5p6kAM2azjA
451	3790	University of Minnesota - Coffman Union	300 Washington Ave SE	Minneapolis	MN	f	t	\N	44.97359	-93.23507	2014-02-02 14:54:35.396-06	2014-02-02 14:54:35.396-06	US	f	f	f	f	f	ChIJi2l8AD4ts1IR6hQ3FDu_3Qk
452	28385	Coffman Memorial Union	300 Washington Ave SE, Minneapolis, MN 55455	Minneapolis	MN	f	t	\N	44.97282	-93.235344	2017-02-23 21:10:44.883-06	2017-02-23 21:10:44.883-06	US	f	f	f	f	f	ChIJi2l8AD4ts1IR6hQ3FDu_3Qk
453	51035	Blue Sun Soda	1625 County Hwy 10 D	Spring Lake Park	MN	f	f	\N	45.118122	-93.229706	2019-07-14 14:24:21.228-05	2019-07-14 14:24:21.369-05	US	f	f	f	f	f	ChIJhZIwY5kls1IRKuOdWk44aGg
454	27437	Coffey hall	1420 Eckles avenue	St. Paul	MN	f	t	\N	44.983837	-93.1851	2017-01-13 18:23:04.863-06	2017-01-13 18:23:04.863-06	US	f	f	f	f	f	ChIJHZ6QS4Mss1IRTFIGiibgOTU
455	43711	Freeman Building	625 Robert Street N	St. Paul	MN	t	t	\N	44.95359	-93.09786	2018-09-11 10:09:44.243-05	2020-04-14 16:25:49.6-05	US	t	f	f	f	f	ChIJhyZQUasq9ocR-Dry3R6I-zg
456	22843	Mischief toy store 	818 Grand Avenue	St. Paul	MN	f	t	\N	44.939636	-93.13475	2016-06-13 09:21:14.661-05	2016-06-13 09:21:14.661-05	US	f	t	f	f	f	ChIJhYVAiZEss1IRsFiWeP95zzo
457	58782	Mischief Toys	818 Grand Avenue	St. Paul	MN	t	t	\N	44.939705	-93.13478	2021-08-01 19:06:41.85-05	2021-08-01 19:06:41.913-05	US	t	f	f	f	f	ChIJhYVAiZEss1IRsFiWeP95zzo
458	63582	Menards 	2700 Hwy 13 west	Burnsville	MN	f	t	\N	44.776592	-93.3134	2022-10-01 16:27:46.184-05	2022-10-01 16:27:46.296-05	US	f	f	f	f	f	ChIJhynqKhI79ocRNtl_gsSGro0
459	33040	Royal Grounds	4161 Grand Ave	Minneapolis	MN	t	t	\N	44.94011	-93.19251	2017-03-03 10:33:08.122-06	2017-03-03 10:33:08.122-06	US	f	t	f	f	f	ChIJhxULMron9ocRH2fFjAMWF7I
460	53671	Half Price Books	7600 W 150th St W	Apple Valley 	MN	t	t	\N	44.730648	-93.22072	2019-10-30 17:08:31.162-05	2019-10-30 17:08:31.305-05	US	t	f	f	f	f	ChIJh_Xh1dQw9ocRUMrlT6VDn9Y
461	30487	Midori's Floating World Cafe	2629 east Lake St	Minneapolis	MN	t	t	\N	44.948116	-93.23343	2017-02-26 09:47:05.405-06	2020-04-14 16:16:46.14-05	US	f	f	f	f	f	ChIJHUgbiSMo9ocRoZA8sXHtL1w
462	30953	Italian Pie Shoppe	1670 grand Ave.	St. Paul	MN	t	t	\N	44.939907	-93.170746	2017-02-26 18:00:18.917-06	2017-02-26 18:00:18.917-06	US	f	f	f	f	f	ChIJHRpVARkq9ocRwOi8pBWwCyg
463	20695	Target	1515 County B Rd W	Roseville	MN	t	t	\N	45.00795	-93.16435	2016-03-27 23:32:34.421-05	2016-03-27 23:32:34.421-05	US	f	f	f	f	f	ChIJhR8-CZYrs1IRMkoYeKZdZZc
464	57405	Trader Joe’s	4500 Excelsior Blvd	St. Louis Park	MN	t	t	\N	44.934536	-93.36959	2021-03-17 19:36:50.931-05	2021-03-17 19:36:51.094-05	US	t	f	t	f	f	ChIJHR0c3Uon9ocRBDjpVZs1ycU
465	64478	Saint Paul River Centre Kellogg Lobby 	175 Kellogg Blvd W	St. Paul	MN	t	t	\N	44.944653	-93.09958	2023-01-28 11:27:53.238-06	2023-01-28 11:27:53.351-06	US	f	f	f	f	f	ChIJhQqRkbMq9ocRG4p0QimGO7s
466	36999	Sparks	230 Cedar Lake Rd S	Minneapolis	MN	t	t	\N	44.974686	-93.30691	2017-08-15 18:36:25.908-05	2017-08-15 18:36:25.908-05	US	f	f	f	f	f	ChIJHdEwRhkzs1IRQAHmwpJBd28
467	30960	Starbucks - Grand Ave.	1062 Grand Ave.	St. Paul 	MN	t	t	\N	44.939785	-93.14481	2017-02-26 18:06:45.307-06	2017-02-26 18:06:45.307-06	US	f	f	f	f	f	ChIJhcWwD2cq9ocRIP4Bvnlyrrw
468	49227	Surly Brewing Company	520 Malcolm Ave SE	Minneapolis	MN	t	f	\N	44.97323	-93.20976	2019-04-18 12:19:38.942-05	2019-04-18 12:19:39.045-05	US	t	f	t	f	f	ChIJHa80f2sxs1IRSAlqsByPiLY
469	19935	Saint Paul College	235 Marshall Ave	St. Paul	MN	t	t	\N	44.9493	-93.10976	2016-01-25 12:11:13.35-06	2016-01-25 12:11:13.35-06	US	f	f	f	f	f	ChIJh9jLuaQq9ocRvBp_sLiYde4
470	48861	Eastlake Craft Brewery	920 East Lake Street	Minneapolis	MN	t	f	\N	44.948677	-93.26074	2019-04-03 22:17:55.679-05	2019-04-03 22:17:55.797-05	US	t	f	f	f	f	ChIJH98-0f0n9ocRDrAyltIlu2k
471	48862	Eastlake Craft Brewery	920 East Lake Street	Minneapolis	MN	t	f	\N	44.948677	-93.26074	2019-04-03 22:19:56.871-05	2019-04-03 22:19:56.898-05	US	t	t	f	f	f	ChIJH98-0f0n9ocRDrAyltIlu2k
472	24107	Half Price Books	2481 Fairview Ave N	Roseville	MN	t	t	\N	45.015717	-93.17801	2016-07-16 18:27:43.035-05	2016-07-16 18:27:43.035-05	US	f	f	f	f	f	ChIJH97KxfMrs1IRdia4huWCbv8
473	17430	Dunn Brothers Coffee	367 Wabasha St N	St. Paul	MN	t	t	\N	44.94576	-93.094864	2015-05-12 20:22:29.672-05	2015-05-12 20:22:29.672-05	US	f	f	f	f	f	ChIJh81kW0zV94cRy3S3jevwydk
474	35208	Dunn Brothers Coffee	367 Wabasha St. N	St. Paul	MN	f	f	\N	44.94576	-93.094864	2017-05-21 13:00:43.163-05	2017-05-21 13:00:43.163-05	US	f	t	f	f	f	ChIJh81kW0zV94cRy3S3jevwydk
475	5261	Sonic	American Parkway and Penn	Bloomington	MN	t	t	\N	44.85882	-93.3094	2014-03-30 15:32:43.256-05	2014-03-30 15:32:43.256-05	US	f	f	f	f	f	ChIJh5n0Cfok9ocRvAU53EyXcjo
476	47275	Tate Hall	Church St SE	Minneapolis	MN	t	t	\N	44.97489	-93.233864	2019-02-01 14:10:18.598-06	2019-02-11 23:42:18.672-06	US	f	t	f	f	f	ChIJH5HQYRYts1IRb1mKBqiZv7Q
477	43573	Tate Hall	Church St SE	Minneapolis	MN	t	t	\N	44.97489	-93.233864	2018-09-10 12:00:07.577-05	2020-04-14 16:25:33.206-05	US	f	f	f	f	f	ChIJH5HQYRYts1IRb1mKBqiZv7Q
478	42809	Bondesque	707 W Lake Street	Minneapolis	MN	t	t	\N	44.94823	-93.28863	2018-08-06 18:04:24.758-05	2018-08-06 18:04:24.758-05	US	f	f	f	f	f	ChIJH-4Mrown9ocRoDnnDvC7kAE
479	25074	Caribou Coffee	2134 Ford Pkwy	St. Paul	MN	f	f	\N	44.917427	-93.191	2016-08-27 17:26:53.459-05	2016-08-27 17:26:53.459-05	US	f	f	t	f	f	ChIJh4M00ncp9ocRp43cmJW96hY
480	1872	The Tea Garden	1692 Grand Ave	St. Paul	MN	f	t	\N	44.939953	-93.17223	2014-02-02 14:51:41.756-06	2014-02-02 14:51:41.756-06	US	f	f	t	f	f	ChIJh3O3Jhkq9ocRki-UotJVVXw
481	52349	The Naughty Greek	2400 University Avenue	St. Paul	MN	t	t	\N	44.96392	-93.19807	2019-09-03 17:52:11.892-05	2019-09-03 17:52:12.006-05	US	f	f	f	f	f	ChIJH32C7rcss1IR4I5G3JqsVS8
482	29624	Hot Plate	5204 Bloomington Ave	Minneapolis	MN	t	t	\N	44.90864	-93.25276	2017-02-25 11:16:58.889-06	2017-02-25 11:16:58.889-06	US	f	f	f	f	f	ChIJH1cpmoQo9ocR-z7wImMRsIQ
483	30811	Holy Name of Jesus Catholic Community	155 County Road 24	Wayzata	MN	f	t	\N	45.0135	-93.52524	2017-02-26 15:27:55.588-06	2017-02-26 15:27:55.588-06	US	f	f	f	f	f	ChIJGzGmEBlMs1IRn_cQLf2PAZo
484	55850	Goodwill	553 Fairview Ave N	St. Paul	MN	t	f	\N	44.95809	-93.178055	2020-03-11 14:38:42.852-05	2020-04-14 16:10:08.382-05	US	t	f	f	f	f	ChIJg_sWgFUrs1IRQK_FKNyWKn4
485	2072	Macalester College Campus Center	1600 Grand Ave	St. Paul	MN	f	t	\N	44.9399	-93.168	2014-02-02 14:51:57.457-06	2014-02-02 14:51:57.457-06	US	f	f	f	f	f	ChIJgSJGCRgq9ocRhcfyJmgzUt0
486	50112	Starbucks	N 1st Street	Minneapolis	MN	t	f	\N	44.98698	-93.27127	2019-05-31 14:44:24.218-05	2019-05-31 14:44:24.243-05	US	f	f	f	f	f	ChIJgQhOFIYys1IRBzpiEwqknKE
487	36166	Colossal Cafe	1340 Grand Ave	St. Paul	MN	t	t	\N	44.939816	-93.15709	2017-07-02 14:24:33.288-05	2017-07-02 14:24:33.288-05	US	t	f	f	f	f	ChIJg-Mf32oq9ocRrjmBuhwruCo
488	68124	Urban wok	8048 Old Carriage Ct	Shakopee	MN	t	t	\N	44.774963	-93.41564	2023-12-27 12:31:09.019-06	2023-12-27 12:31:09.108-06	US	t	f	f	f	f	ChIJgeQVXfk99ocRXktB33IqigA
489	22436	Grand Ole Creamery	705 Grand Avenue	St. Paul 	MN	f	f	\N	44.939945	-93.12984	2016-06-01 20:51:05.345-05	2016-06-01 20:51:05.345-05	US	f	f	f	f	f	ChIJg-eOlowq9ocRrjQq2PKvNlc
490	46851	Chatime	14 Ave SE	St. Paul	MN	t	t	\N	44.98484	-93.23235	2019-01-05 16:22:02.447-06	2019-01-05 16:22:02.51-06	US	f	t	f	f	f	ChIJgb5H2w4ts1IRKL8ln27P9Cg
491	63016	Grander Peace Counseling	658 Grand Ave	St. Paul	MN	f	t	\N	44.939728	-93.12786	2022-08-07 15:38:57.415-05	2022-08-07 15:38:57.498-05	US	f	f	f	f	f	ChIJG6dtDXcr9ocREJYzDVlrHos
492	66254	Heavy Rotation Brewing Co	9801 Xenia Ave N Suite 105	Brooklyn Park 	MN	t	t	\N	45.134598	-93.35577	2023-06-19 21:36:32.172-05	2023-06-19 21:36:32.281-05	US	f	f	f	f	f	ChIJG48EvdA7s1IRMfL7qi_InGE
493	35797	D'amico and Sons	975 Grand Ave	St. Paul	MN	f	f	\N	44.940155	-93.14115	2017-06-15 18:57:33.958-05	2017-06-15 18:57:33.958-05	US	t	f	f	f	f	ChIJg2Ne5GAq9ocRnpGOXulALwM
495	4357	Univ of Minnesota - Smith Hall	207 Pleasant Street SE	Minneapolis	MN	f	t	\N	44.974613	-93.23671	2014-02-02 14:55:34.1-06	2014-02-02 14:55:34.1-06	US	f	f	f	f	f	ChIJFzr5xBUts1IRMxqbRNW9cVs
496	5048	Smith Hall, University of Minnesota	207 Pleasant Street SE	Minneapolis	MN	t	t	\N	44.974613	-93.23671	2014-02-18 16:11:55.199-06	2014-02-18 16:11:55.199-06	US	f	f	f	f	f	ChIJFzr5xBUts1IRMxqbRNW9cVs
497	56485	Dunn Brothers Coffee	50th and Xerxes	Minneapolis	MN	t	f	\N	44.91245	-93.318855	2020-08-19 14:23:28.542-05	2020-08-19 14:23:28.669-05	US	t	f	f	f	f	ChIJFzkKK94m9ocRKepzH1LPSwI
498	5050	Appleby Hall, University of Minnesota	128 Pleasant Street SE	Minneapolis	MN	t	t	\N	44.974926	-93.237236	2014-02-18 16:13:18.537-06	2014-02-18 16:13:18.537-06	US	f	f	f	f	f	ChIJfzifsRUts1IRNDCBEQZPeZI
499	5005	Highland Grill	771 Cleveland Ave S	St. Paul	MN	t	t	\N	44.918236	-93.18779	2014-02-16 01:49:50.24-06	2014-02-16 01:50:51.356-06	US	f	f	f	f	f	ChIJFz2_B3gp9ocRNo2TZ4I1Szo
500	38052	Cafe Astoria	180 Grand Ave	St. Paul 	MN	f	t	\N	44.941322	-93.10731	2017-10-06 13:01:55.527-05	2017-10-06 13:01:55.527-05	US	f	t	f	f	f	ChIJfY-Xg7cq9ocRtrdHgMxxedM
501	39764	Cafe Astoria	180 Grand Ave	St. Paul 	MN	t	t	\N	44.940014	-93.14971	2018-02-03 07:06:49.719-06	2018-02-03 07:06:49.719-06	US	t	f	f	f	f	ChIJfY-Xg7cq9ocRtrdHgMxxedM
502	56181	Target	900 Nicollet Mall	Minneapolis	MN	t	t	\N	44.97493	-93.27442	2020-06-23 19:12:00.263-05	2020-06-23 19:12:00.397-05	US	t	f	f	f	f	ChIJFY3e2ZUys1IRLoFJKRSNO_U
503	54420	Bibles for Missions Thrift Center	4713 36th Avenue North	Crystal	MN	t	f	\N	45.020027	-93.33927	2019-12-12 07:01:01.157-06	2020-04-14 16:04:59.214-05	US	t	f	f	f	f	ChIJFXKfCvszs1IRaS6Y3fBc_7c
504	39535	Maplewood Mall, MN 55109, USA	Maplewood	Maplewood	MN	t	t	\N	45.017754	-93.05243	2018-01-18 16:16:52.484-06	2018-01-18 16:16:52.484-06	US	t	f	f	f	f	ChIJfWz4PEjTslIR7OdYq8Z-jVM
505	36236	Kings restaurant 	4555 grand avenue south	Minneapolis	MN	t	t	\N	44.91976	-93.28417	2017-07-06 19:19:51.403-05	2017-07-06 19:19:51.403-05	US	f	f	f	f	f	ChIJFwXB-rMn9ocRx1pQUD0_4Jo
506	25387	Grace Community Center for Life	1500 6th St NE	Minneapolis	MN	t	t	\N	45.003994	-93.25946	2016-09-07 10:37:47.451-05	2016-09-07 10:37:47.451-05	US	f	t	f	f	f	ChIJFWA-SYkts1IRsVsDgznePp0
507	24786	Grace Community Center for Life	1500 6th St NE	Minneapolis	MN	t	t	\N	45.003994	-93.25946	2016-08-17 17:19:52.67-05	2016-08-17 17:19:52.67-05	US	f	f	f	f	f	ChIJFWA-SYkts1IRsVsDgznePp0
508	35723	Gyst Fermentation Bar	25 E 26th st	Minneapolis	MN	t	t	\N	44.955387	-93.27679	2017-06-12 22:48:04.293-05	2017-06-12 22:48:04.293-05	US	t	f	f	f	f	ChIJFUHqB7Uys1IRqBKt6hxGbsU
509	26439	St Mark's Episcopal Cathedral	519 Oak Grove St	Minneapolis	MN	t	f	\N	44.968235	-93.28687	2016-11-12 11:15:47.859-06	2016-11-12 11:15:47.859-06	US	f	f	f	f	f	ChIJfTPuvcMys1IRLA0Eg7Nf8yU
510	36297	Blackbird Cafe	3800 Nicollet Ave S	Minneapolis	MN	t	t	\N	44.933945	-93.27815	2017-07-09 13:50:37.651-05	2017-07-09 13:50:37.651-05	US	f	t	f	f	f	ChIJfRHZBcAn9ocRtSBRUsobtf8
511	40551	Blackbird Cafe	3800 Nicollet	Minneapolis	MN	t	t	\N	44.933956	-93.278206	2018-03-25 10:46:53.444-05	2020-04-14 16:15:18.81-05	US	f	f	t	f	f	ChIJfRHZBcAn9ocRtSBRUsobtf8
512	35487	Wells Fargo	5116 Vernon Ave S	Minneapolis	MN	f	t	\N	44.91087	-93.35598	2017-06-02 18:18:05.825-05	2017-06-02 18:18:05.825-05	US	f	f	f	f	f	ChIJFQ73r5Uh9ocRU30Za3PXfQ4
513	35309	Hyland hills ski chalet	8800 Chalet Road, Bloomington, MN, United States	Bloomington	MN	f	t	\N	44.843594	-93.3639	2017-05-27 15:00:12.245-05	2017-05-27 15:00:12.245-05	US	f	f	f	f	f	ChIJffbj-6Mj9ocRRvZcYyizOWg
514	36226	Cafe Maude	5411 Penn Ave South	Minneapolis	MN	f	t	\N	44.904587	-93.30828	2017-07-05 22:13:06.626-05	2017-07-05 22:13:06.626-05	US	f	t	f	f	f	ChIJfdIfH_Am9ocRPmof6cBTDHY
515	36233	Cafe Maude	5411 Penn Avenue South	Minneapolis	MN	t	t	\N	44.904587	-93.30828	2017-07-06 16:50:32.101-05	2017-07-06 16:50:32.101-05	US	f	f	f	f	f	ChIJfdIfH_Am9ocRPmof6cBTDHY
516	57471	Pajarito	W. 7th and western	St. Paul 	MN	t	t	\N	44.92774	-93.12699	2021-03-25 23:37:54.844-05	2021-03-25 23:37:55.032-05	US	f	f	f	f	f	ChIJF9rCoTYr9ocR6oUKpR-WRlA
517	38694	The Copper Hen	2515 Nicollet Ave	Minneapolis	MN	t	t	\N	44.956657	-93.2775	2017-11-16 20:11:17.197-06	2017-11-16 20:11:17.197-06	US	t	f	f	f	f	ChIJF9KF6rUys1IR-R8tR4VCnL0
518	62899	Jimmy Johns	Robert Street	West St. Paul	MN	t	f	\N	44.903744	-93.08071	2022-07-31 15:06:31.945-05	2022-07-31 15:06:32.031-05	US	f	f	f	f	f	ChIJF8AIKbzU94cR2DlKJcNPZBw
519	21485	Target	Business Park Blvd N	Champlin	MN	f	t	\N	45.17301	-93.3902	2016-04-18 01:58:09.894-05	2016-04-18 01:58:09.894-05	US	f	f	f	f	f	ChIJf6j7bzM5s1IRS2gTG6jXQzI
520	32558	Park Yogurt	6416 West Lake Street	St. Louis Park	MN	t	t	\N	44.9419	-93.360855	2017-03-01 15:36:01.329-06	2017-03-01 15:36:01.329-06	US	f	f	f	f	f	ChIJf5BHJZgg9ocRuMjkouaSDQk
521	64835	CTC Coffee Ta Cream	1157 Shakopee Town Square, Shakopee, MN 55379	Shakopee	MN	t	f	\N	44.784313	-93.55445	2023-03-03 15:27:44.919-06	2023-03-03 15:27:45.033-06	US	f	f	f	f	f	ChIJF53ITG4Q9ocRP3A9AgGqbWI
522	35152	Baker's Square	1881 Highway 36 W	Roseville	MN	t	t	\N	45.01104	-93.17922	2017-05-19 18:35:43.729-05	2017-05-19 18:35:43.729-05	US	f	f	f	f	f	ChIJF0PnWYsrs1IRLILE79hlfC8
523	1148	Snuffy's Restaurant	244 Cleveland Ave S	St. Paul	MN	f	f	\N	44.934113	-93.18728	2014-02-02 14:50:34.552-06	2014-02-02 14:50:34.552-06	US	f	f	f	f	f	ChIJEZl7Mo4p9ocR83m4o9SOpz4
524	40825	The Nook	492 S Hamline Ave	St. Paul	MN	t	t	\N	44.92657	-93.15667	2018-04-08 12:11:58.727-05	2018-04-08 12:11:58.727-05	US	f	f	f	f	f	ChIJeYtpNkgq9ocRm-fvoiveNzk
525	2429	Sears	12737 Riverdale BLVD NW	Coon Rapids	MN	t	t	\N	45.201214	-93.35175	2014-02-02 14:52:27.577-06	2014-02-02 14:52:27.577-06	US	f	f	t	f	f	ChIJeYMenjk8s1IRF_OGmuWn8SQ
526	17027	Chef Shack Ranch	3025 East Franklin Avenue	Minneapolis	MN	f	f	\N	44.962494	-93.22714	2015-04-03 18:29:15.214-05	2015-04-03 18:29:15.214-05	US	f	f	f	f	f	ChIJexAmoy8ts1IRuNZWfhU1YqY
527	34712	Wayzata high school	4955 Peony Ln N	Plymouth	MN	t	t	\N	45.04491	-93.510765	2017-05-01 07:36:47.909-05	2017-05-01 07:36:47.909-05	US	f	f	f	f	f	ChIJeWR9ezRJs1IR5Tb4c3_P0yE
528	36701	Wayzata high school 	4955 Peony Lane North	Plymouth	MN	t	t	\N	45.04491	-93.510765	2017-07-29 16:19:29.026-05	2017-07-29 16:19:29.026-05	US	f	t	f	f	f	ChIJeWR9ezRJs1IR5Tb4c3_P0yE
529	52154	Eco Experience Building	1621 Randall Ave	Falcon Heights	MN	t	t	\N	44.984905	-93.1678	2019-08-24 10:35:06.803-05	2019-08-24 10:35:06.916-05	US	f	f	f	f	f	ChIJEwiaxXErs1IRhW_-xzWGu7U
530	42098	Indigo Tea co	1501 Riverwood Dr	Burnsville	MN	t	f	\N	44.78569	-93.25372	2018-06-27 12:48:47.483-05	2018-06-27 12:48:47.483-05	US	f	f	f	f	f	ChIJESGczXQw9ocR6iIKmx2zb44
531	413	Caribou Coffee	2111 Snelling Avenue North, St Paul, MN&#8206;	St. Paul	MN	t	f	\N	44.94383	-93.09332	2014-02-02 14:49:35.168-06	2014-02-02 14:49:35.168-06	US	f	f	f	f	f	ChIJee32JJcrs1IRbVujtBFrin8
532	24166	The Coffeeshop NE	2852 Johnson St NE	Minneapolis	MN	t	t	\N	45.02018	-93.23739	2016-07-20 10:19:24.29-05	2016-07-20 10:19:24.29-05	US	f	f	f	f	f	ChIJEdpJz9ots1IRGM2o0l7ffTM
533	18534	The Coffee Shop NE	2852 Johnson St NE	Minneapolis	MN	f	t	\N	45.02018	-93.23739	2015-08-30 17:44:48.818-05	2015-08-30 17:44:48.818-05	US	f	t	f	f	f	ChIJEdpJz9ots1IRGM2o0l7ffTM
534	17025	Caribou Coffee	757 grand avenue	St. Paul	MN	f	f	\N	44.940216	-93.13212	2015-04-03 17:46:36.848-05	2015-04-03 17:46:36.848-05	US	f	f	f	f	f	ChIJEcZwmowq9ocRIOCATz_7F1U
535	17029	World street kitchen 	2743 lyndale Ave s	Minneapolis	MN	t	t	\N	44.952427	-93.28781	2015-04-03 21:15:07.581-05	2015-04-03 21:15:07.581-05	US	f	t	f	f	f	ChIJEa33Aogn9ocRa86tLqTjRv0
536	33902	World Street Kitchen	2743 Lindale Ave S	Minneapolis	MN	t	t	\N	44.952393	-93.28767	2017-04-10 19:48:26.717-05	2017-04-10 19:48:26.717-05	US	f	t	f	f	f	ChIJEa33Aogn9ocRa86tLqTjRv0
537	26945	World street kitchen	2743 Lyndale Ave S #5	Minneapolis	MN	t	t	\N	44.952393	-93.28767	2016-12-02 23:01:24.451-06	2016-12-02 23:01:24.451-06	US	f	t	t	f	f	ChIJEa33Aogn9ocRa86tLqTjRv0
538	26944	World street kitchen	2743 Lyndale Ave S #5	Minneapolis	MN	t	t	\N	44.952393	-93.28767	2016-12-02 23:01:23.981-06	2016-12-02 23:01:23.981-06	US	f	f	t	f	f	ChIJEa33Aogn9ocRa86tLqTjRv0
539	16888	Recovery bike shop	2555 Central Ave NE	Minneapolis	MN	t	t	\N	45.014145	-93.24732	2015-03-23 22:11:07.204-05	2015-03-23 22:11:07.204-05	US	f	f	f	f	f	ChIJe5St_u8ts1IRBe-ePuBsBlc
540	52054	Bank of America 	355 Radio Dr	Woodbury	MN	t	f	\N	44.942226	-92.93293	2019-08-20 09:32:21.553-05	2019-08-20 09:32:21.574-05	US	f	f	f	f	f	ChIJe4a1wyHY94cRfl8vesnKZlY
541	56042	Mitchell Hamline School of Law	875 Summit Avenue	St. Paul	MN	t	f	\N	44.94219	-93.137856	2020-05-22 06:36:53.434-05	2020-05-22 06:36:53.553-05	US	f	f	f	f	f	ChIJE2TP4GEq9ocRfYFsEMBKFc8
542	31607	Galactic Pizza	2917 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.949677	-93.28783	2017-02-27 14:26:13.266-06	2017-02-27 14:26:13.266-06	US	f	t	f	f	f	ChIJe18Tmogn9ocR7UpRi67Wfz8
543	31608	Galactic Pizza	2917 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.949677	-93.28783	2017-02-27 14:26:13.72-06	2017-02-27 14:26:13.72-06	US	f	t	f	f	f	ChIJe18Tmogn9ocR7UpRi67Wfz8
544	28052	Galactic Pizza	2917 Lyndale Ave S	Minneapolis	MN	f	t	\N	44.949677	-93.28783	2017-02-14 20:29:10.037-06	2017-02-14 20:29:10.037-06	US	f	f	f	f	f	ChIJe18Tmogn9ocR7UpRi67Wfz8
545	46424	1696 Grand Ave, St Paul, MN 55105, USA	1696 Grand Ave	St. Paul	MN	t	t	\N	44.93993	-93.1722	2018-12-13 10:42:19.058-06	2018-12-13 10:42:19.109-06	US	f	f	f	f	f	ChIJE142Jhkq9ocRQ8gvQbGDvec
546	33942	Reclaim Office	771 Raymond Ave	St. Paul	MN	t	t	\N	44.964798	-93.19787	2017-04-11 23:02:25.319-05	2017-04-11 23:02:25.319-05	US	f	f	f	f	f	ChIJe0zGH7gss1IRQr3lEk9aFoA
547	27775	Groundswell 	1340 Thomas Avenue west	St. Paul	MN	f	t	\N	44.959198	-93.15702	2017-01-25 11:42:59.569-06	2017-01-25 11:42:59.569-06	US	f	t	f	f	f	ChIJE0vrojUrs1IRPqnyV_j6UOo
548	27774	Groundswell 	1340 Thomas Avenue west	St. Paul	MN	f	t	\N	44.959198	-93.15702	2017-01-25 11:42:57.483-06	2017-01-25 11:42:57.483-06	US	f	f	f	f	f	ChIJE0vrojUrs1IRPqnyV_j6UOo
549	36956	Keys Cafe Woodbury	Valley Creek Mall	Woodbury	MN	t	t	\N	44.926197	-92.96124	2017-08-13 18:39:16.551-05	2017-08-13 18:39:16.551-05	US	f	f	f	f	f	ChIJDZulmgDX94cRBabvfxbVGmo
550	19660	Depot Coffee House	Excelsior Boulevard	Hopkins	MN	t	t	\N	44.92118	-93.41023	2015-12-20 20:09:04.367-06	2015-12-20 20:09:04.367-06	US	f	f	f	f	f	ChIJDZSwcUQg9ocREYoto6ktAOQ
551	30014	Butter Bakery Cafe	3700 Nicollet Ave	Minneapolis	MN	t	t	\N	44.935715	-93.27823	2017-02-25 18:10:04.198-06	2017-02-25 18:10:04.198-06	US	f	t	f	f	f	ChIJdz9uvJYn9ocRBRrmokpqzqI
552	4510	Butter Bakery Cafe	3700 Nicollet Ave	Minneapolis	MN	t	t	\N	44.935715	-93.27823	2014-02-04 12:19:31.254-06	2014-02-07 13:42:11.187-06	US	f	f	f	f	f	ChIJdz9uvJYn9ocRBRrmokpqzqI
553	3213	Urban Bean	2401 Garfield Ave S	Minneapolis	MN	t	t	\N	44.958916	-93.28672	2014-02-02 14:53:39.763-06	2014-02-02 14:53:39.763-06	US	f	f	f	f	f	ChIJdy0aR84ys1IRfDvxPhIKSQY
554	41283	The Lynhall	2640 Lyndale Ave	Minneapolis	MN	f	f	\N	44.954094	-93.28847	2018-05-10 09:26:42.758-05	2020-04-14 16:14:21.362-05	US	f	f	f	f	f	ChIJdXfmZs0ys1IRjq5736bcCgs
555	38126	Blaze Pizza	1000 Washington Ave SE	Minneapolis	MN	t	t	\N	44.973484	-93.22346	2017-10-10 15:55:46.948-05	2017-10-10 15:55:46.948-05	US	f	t	f	f	f	ChIJdXBVYR8ts1IRQXsnCR0C8MQ
556	35382	Blaze Pizza	1000 Washington Ave SE	Minneapolis	MN	t	f	\N	44.973484	-93.22346	2017-05-29 11:54:11.283-05	2017-05-29 11:54:11.283-05	US	f	t	t	f	f	ChIJdXBVYR8ts1IRQXsnCR0C8MQ
557	39666	Blaze Pizza	1000 Washington Ave SE	Minneapolis	MN	t	t	\N	44.973484	-93.22346	2018-01-26 19:32:42.436-06	2018-01-26 19:32:42.436-06	US	f	f	f	f	f	ChIJdXBVYR8ts1IRQXsnCR0C8MQ
558	31604	Revival	4257 Nicollet ave	Minneapolis	MN	t	t	\N	44.925194	-93.27791	2017-02-27 14:24:43.288-06	2017-02-27 14:24:43.288-06	US	f	f	f	f	f	ChIJdUP14scn9ocR9UDCrj4rRMM
559	56105	HyVee	6150 Egan Dr	Savage	MN	t	f	\N	44.747738	-93.35705	2020-06-15 21:13:26.35-05	2020-06-15 21:13:26.48-05	US	t	f	f	f	f	ChIJdS_S5Wo89ocRts7vfdFTeCo
560	26246	The Minneapolis College of Art and Design	2501 Stevens Avenue	Minneapolis	MN	t	t	\N	44.956722	-93.274635	2016-11-10 19:03:46.711-06	2016-11-10 19:03:46.711-06	US	f	f	t	f	f	ChIJDSb7ErQys1IR_G-2p5c9KNM
561	2555	Minneapolis College of Art and Design	2501 Stevens Ave. S.	Minneapolis	MN	t	t	\N	44.957115	-93.27509	2014-02-02 14:52:35.551-06	2014-02-02 14:52:35.551-06	US	f	f	f	f	f	ChIJDSb7ErQys1IR_G-2p5c9KNM
562	16108	Minneapolis College of Art and Design	2501 Stevens Avenue	Minneapolis	MN	t	t	\N	44.9573	-93.27457	2015-03-03 23:13:45.004-06	2015-03-03 23:13:45.004-06	US	f	t	f	f	f	ChIJDSb7ErQys1IR_G-2p5c9KNM
563	26199	Minneapolis College of Art and Design	2051 Stevens Ave	Minneapolis	MN	f	t	\N	44.96132	-93.27527	2016-11-10 16:04:43.08-06	2016-11-10 16:04:43.08-06	US	f	t	f	f	f	ChIJDSb7ErQys1IR_G-2p5c9KNM
564	37069	U-Haul	1630 Hwy 13 W	Burnsville	MN	t	t	\N	44.772987	-93.30124	2017-08-19 11:37:24.52-05	2017-08-19 11:37:24.52-05	US	f	f	f	f	f	ChIJDQUWzzk79ocRKUzvpZUetyA
565	34820	Mechanical Engineering	111 Church St SE	Minneapolis	MN	t	t	\N	44.9755	-93.23322	2017-05-04 16:04:00.24-05	2020-04-14 16:18:10.056-05	US	f	t	f	f	f	ChIJddP9-BYts1IRicUI3Tgi_98
566	26756	Sencha Tea Bar	2601 Hennepin Ave S	Minneapolis	MN	t	t	\N	44.955494	-93.29681	2016-11-26 12:45:18.609-06	2016-11-26 12:45:18.609-06	US	f	t	f	f	f	ChIJDaHksdUys1IRf2uH1UJjUkc
567	17439	Sencha Tea Bar	2601 Hennepin Ave	Minneapolis	MN	t	t	\N	44.95543	-93.29648	2015-05-13 14:47:25.425-05	2015-05-13 14:47:25.425-05	US	f	f	f	f	f	ChIJDaHksdUys1IRf2uH1UJjUkc
568	3880	Cafe Southside 	3405 Chicago Ave	Minneapolis	MN	f	t	\N	44.941067	-93.26231	2014-02-02 14:54:43.81-06	2014-02-07 13:43:49.964-06	US	f	f	f	f	f	ChIJD58aluMn9ocRFKoNFP0BRdg
569	31693	Minnetonka High School	18301 highway 7	Minnetonka 	MN	t	t	\N	44.909676	-93.51088	2017-02-27 16:07:44.74-06	2017-02-27 16:07:44.74-06	US	f	t	f	f	f	ChIJd3Zki9Id9ocR4ka6W7Qgq24
570	31695	Minnetonka Highschool	18301 highway 7	Minnetonka 	MN	t	t	\N	44.909676	-93.51088	2017-02-27 16:09:30.203-06	2017-02-27 16:09:30.203-06	US	f	t	f	f	f	ChIJd3Zki9Id9ocR4ka6W7Qgq24
571	31694	Minnetonka High School	18301 highway 7	Minnetonka 	MN	t	t	\N	44.909676	-93.51088	2017-02-27 16:07:44.829-06	2017-02-27 16:07:44.829-06	US	f	f	f	f	f	ChIJd3Zki9Id9ocR4ka6W7Qgq24
572	17994	Phillips-Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:33:37.176-05	2015-07-15 02:33:37.176-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
573	17991	Phillips-Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:33:27.676-05	2015-07-15 02:33:27.676-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
574	17996	Phillips Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:34:28.767-05	2015-07-15 02:34:28.767-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
575	17993	Phillips-Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:33:35.094-05	2015-07-15 02:33:35.094-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
576	17997	Phillips Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:34:46.557-05	2015-07-15 02:34:46.557-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
577	17992	Phillips-Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:33:33.99-05	2015-07-15 02:33:33.99-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
578	17998	Phillips Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:35:09.358-05	2015-07-15 02:35:09.358-05	US	f	t	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
579	17995	Phillips-Wangensteen Building	516 Delaware St SE	Minneapolis	MN	f	f	\N	44.97227	-93.231575	2015-07-15 02:33:40.941-05	2015-07-15 02:33:40.941-05	US	f	f	f	f	f	ChIJd27OaT0ts1IR7p68Fv1qg2I
580	52155	The Hangar	1673 Murphy Ave	Falcon Heights	MN	t	t	\N	44.987434	-93.170006	2019-08-24 12:28:00.917-05	2019-08-24 12:28:00.954-05	US	f	f	f	f	f	ChIJCzy9NEkrs1IRr2Ycl8DfwwE
581	28424	Day Block Brewing Company	1105 S Washington Ave	Minneapolis	MN	t	t	\N	44.97504	-93.253105	2017-02-23 22:07:31.54-06	2017-02-23 22:07:31.54-06	US	f	t	f	f	f	ChIJCZ_XDRgts1IRRR-YhQHQ2zg
582	16391	Day Block Brewing	1105 Washington Ave S	Minneapolis	MN	t	f	\N	44.97526	-93.25302	2015-03-09 11:58:24.324-05	2015-03-09 11:58:24.324-05	US	f	f	f	f	f	ChIJCZ_XDRgts1IRRR-YhQHQ2zg
583	22770	KEYS CAFE	8299 UNIVERSITY AVE NE	Spring Lake Park	MN	t	t	\N	45.118305	-93.26265	2016-06-12 23:36:40.241-05	2016-06-12 23:36:40.241-05	US	f	f	f	f	f	ChIJCZLgx0Yls1IRJNr65fQioTg
584	60509	Longfellow Market	3815 E Lake St	Minneapolis	MN	t	t	\N	44.948074	-93.21725	2021-11-29 22:12:29.208-06	2021-11-29 22:12:29.309-06	US	f	f	f	f	f	ChIJ-cYLJNMp9ocRxn4drpl3jWk
585	53464	Eastman Nature Center	13351 Elm Creek Rd	Maple Grove	MN	t	f	\N	45.159054	-93.449394	2019-10-18 15:00:23.093-05	2019-10-18 15:00:23.182-05	US	t	f	f	f	f	ChIJCWa0y15Hs1IRgCpTCsp0Fes
586	55266	The Wing Joint	10603 University Ave NE	Blaine	MN	t	f	\N	45.1638	-93.26563	2020-02-11 18:37:57.401-06	2020-04-14 16:04:17.234-05	US	f	f	f	f	f	ChIJcW7mpr4ks1IReXUzVIqB0V4
587	42679	St. Stephen’s Human Services	2309 Nicollet Ave South	Minneapolis	MN	t	t	\N	44.95988	-93.27745	2018-07-30 19:55:25.852-05	2018-07-30 19:55:25.852-05	US	f	f	t	f	f	ChIJCV3bTbYys1IRQZUPN7f_INY
588	34434	Mixed Blood Theatre	1501 South 4th Street	Minneapolis	MN	t	f	\N	44.970806	-93.24934	2017-04-22 19:48:51.246-05	2017-04-22 19:48:51.246-05	US	f	t	t	f	f	ChIJcV21xEIts1IR26QQntpAatI
589	56351	Mixed Blood Theatre	1501 South 4th Street	Minneapolis	MN	t	t	\N	44.970848	-93.24932	2020-07-13 18:03:04.732-05	2020-07-13 18:03:04.856-05	US	f	f	f	f	f	ChIJcV21xEIts1IR26QQntpAatI
590	28966	Whole Foods	Hennepin & Washington 	Minneapolis	MN	t	t	\N	44.982185	-93.26899	2017-02-24 17:11:47.321-06	2017-02-24 17:11:47.321-06	US	f	f	f	f	f	ChIJCTKP34Qys1IRWOH_Wc_VyRU
591	67724	New Brighton Community Center	400 10th Street NW	New Brighton	MN	t	t	\N	45.06598	-93.19133	2023-10-24 13:10:22.078-05	2023-10-24 13:10:22.128-05	US	t	f	f	f	f	ChIJCT9iO9Uus1IRGDfv--HPgRs
592	18509	Moscow on the Hill 	371 Selby Ave	St. Paul	MN	t	t	\N	44.946712	-93.11555	2015-08-27 22:56:20.23-05	2015-08-27 22:56:20.23-05	US	f	t	f	f	f	ChIJ_cr5G70q9ocRjzD-eldgDoE
593	19649	Moscow on the Hill	371 Selby Ave	St. Paul	MN	t	t	\N	44.946785	-93.11555	2015-12-19 14:41:44.01-06	2015-12-19 14:41:44.01-06	US	f	f	f	f	f	ChIJ_cr5G70q9ocRjzD-eldgDoE
594	39088	Hasty Tasty	701 W. Lake St.	Minneapolis	MN	t	t	\N	44.94817	-93.288345	2017-12-21 18:54:16.358-06	2017-12-21 18:54:16.358-06	US	f	f	f	f	f	ChIJC-Irq4gn9ocREqTUTs0vYto
595	19485	Galleria 	3510 Galleria Minneapolis, MN  55435 United States	Minneapolis	MN	t	t	\N	44.877098	-93.32619	2015-12-01 15:57:29.181-06	2020-04-14 16:13:04.686-05	US	f	f	f	f	f	ChIJCcmJYKcm9ocRwiOwiVzuiAY
596	35028	Galleria Edina	France Ave S & 69th Street	Edina	MN	t	f	\N	44.87807	-93.329094	2017-05-13 09:02:11.753-05	2017-05-13 09:02:11.753-05	US	f	t	t	f	f	ChIJCcmJYKcm9ocRHE4Au-8sspo
597	24942	Super Target	1515 County Road B W	Roseville	MN	t	t	\N	45.00795	-93.16435	2016-08-25 12:58:40.742-05	2016-08-25 12:58:40.742-05	US	f	f	f	f	f	ChIJc9YSQZYrs1IRksMcTgIVn_Q
598	25591	Ginkgo Coffee	721 N Snelling Ave	St. Paul	MN	f	t	\N	44.963055	-93.16742	2016-09-21 15:45:58.534-05	2016-09-21 15:45:58.534-05	US	f	f	f	f	f	ChIJC9McNU4rs1IRJrX_nQkcLJs
599	28201	Silverwood Park	2500 County Rd E	St. Anthony	MN	t	t	\N	45.046658	-93.22464	2017-02-22 21:25:47.843-06	2017-02-22 21:25:47.843-06	US	f	f	t	f	f	ChIJc_93fO0us1IR19_9-E7xKQA
600	44583	Vicinity Coffee	3350 Lyndale Ave S	Minneapolis	MN	f	t	\N	44.94146	-93.2885	2018-09-22 21:42:01.902-05	2020-04-14 16:29:08.907-05	US	f	f	f	f	f	ChIJc6SieJAn9ocRYA_8J0g1g0k
601	40783	Lake Harriet United Methodist Church	4901 Chowen Ave S, Minneapolis, MN 55410	Minneapolis	MN	t	t	\N	44.91392	-93.324814	2018-04-06 09:57:41.201-05	2018-04-06 09:57:41.201-05	US	f	t	f	f	f	ChIJC2YZu9gm9ocRw-8QF-bdoqM
602	36272	Lake Harriet United Methodist Church	4901 Chowen Ave S	Minneapolis	MN	t	t	\N	44.91392	-93.324814	2017-07-08 16:22:21.563-05	2020-04-14 16:18:31.949-05	US	t	f	f	f	f	ChIJC2YZu9gm9ocRw-8QF-bdoqM
603	30495	Lake Harriet United Methodist Church	4901 Chowen Ave S	Minneapolis	MN	t	t	\N	44.91392	-93.324814	2017-02-26 09:52:25.677-06	2020-04-14 16:16:50.657-05	US	f	t	f	f	f	ChIJC2YZu9gm9ocRw-8QF-bdoqM
604	50819	The Works Museum	9740 Grand Ave S	Bloomington	MN	t	t	\N	44.82715	-93.28642	2019-07-03 12:00:54.047-05	2019-07-03 12:00:54.068-05	US	t	f	f	f	f	ChIJc2psrDAh9ocRnQmgPdO2Dj8
605	33106	PrairieCare	9400 Zane Ave N	Brooklyn Park	MN	t	t	\N	45.12531	-93.35466	2017-03-03 14:51:00.318-06	2017-03-03 14:51:00.318-06	US	f	f	f	f	f	ChIJC08F5yY6s1IRD5LbcJQvKkc
606	17990	TCF Bank Stadium	420 Southeast 23rd Avenue	Minneapolis	MN	t	f	\N	44.977474	-93.22469	2015-07-15 01:55:18.527-05	2015-07-15 01:55:18.527-05	US	f	f	f	f	f	ChIJbyL77h4ts1IRa79fA9QpoTM
607	27229	Seward Co-op (Friendship store)	317 E. 38th St.	MInneapolis	MN	t	t	\N	44.933968	-93.27182	2016-12-23 15:32:47.123-06	2016-12-23 15:32:47.123-06	US	f	f	f	f	f	ChIJbYkTbsIn9ocRaPMifKwZ6Ks
608	365	Byerly's grocery / restaurant	County Road 'C' & Snelling Ave.	Roseville	MN	f	f	\N	45.005398	-93.15663	2014-02-02 14:49:31.862-06	2014-02-02 14:49:31.862-06	US	f	f	f	f	f	ChIJBXx1jM8rs1IROiuGmgNx2K4
609	16561	I Am Coffee	2758 Lyndale Ave S.	Minneapolis	MN	t	f	\N	44.952187	-93.288086	2015-03-11 10:34:25.032-05	2015-03-11 10:34:25.032-05	US	f	f	f	f	f	ChIJBXwMD4gn9ocR-dR81IPR6S4
610	5003	Zeke's Unchained Animal	3508 E Lake St	Minneapolis	MN	t	t	\N	44.948658	-93.221115	2014-02-16 01:48:34.902-06	2014-02-16 01:52:12.997-06	US	f	f	f	f	f	ChIJBxBeXCwo9ocRbzF1aZsjHoU
611	33145	Border Town Coffee	315 16th Ave SE	Minneapolis	MN	f	t	\N	44.979073	-93.23365	2017-03-27 13:23:21.995-05	2017-03-27 13:23:21.995-05	US	f	f	t	f	f	ChIJbx5iHhEts1IRr81sTp4Zp14
612	32806	Centennial Dining Hall	614 Delaware St SE	Minneapolis	MN	t	t	\N	44.972202	-93.22934	2017-03-02 12:06:24.644-06	2017-03-02 12:06:24.644-06	US	f	f	f	f	f	ChIJBWDsuiIts1IRuHdCyHs2iJA
613	25427	Vicinity Coffee	4301 Nicollet Avenue, Minneapolis, MN 55409	Minneapolis	MN	t	t	\N	44.924885	-93.277534	2016-09-09 19:16:33.927-05	2016-09-09 19:16:33.927-05	US	f	f	f	f	f	ChIJb_prCcgn9ocR2LjHDKqrYxw
614	64424	New Bohemia	222 7th St W	St. Paul 	MN	t	t	\N	44.94339	-93.10373	2023-01-20 19:21:30.87-06	2023-01-20 19:21:31.046-06	US	f	f	t	f	f	ChIJb-p5t7Yq9ocR4uNP_q9Hmx4
615	58742	Olive Garden	4701 American Bvld W	Bloomington	MN	t	f	\N	44.857395	-93.34011	2021-08-01 15:43:54.096-05	2021-08-01 15:43:54.182-05	US	t	f	f	f	f	ChIJbfsiuYoj9ocRBXZWr0G1TDQ
616	32610	Reverie Cafe & Bar	1931 Nicollet Ave	Minneapolis	MN	f	t	\N	44.962864	-93.27762	2017-03-01 17:49:20.695-06	2017-03-01 17:49:20.695-06	US	f	f	f	f	f	ChIJBcF-L7gys1IRjnmtgEDJYlc
617	21186	Integrated Life Counseling Center	8931 33rd St N	Lake Elmo	MN	t	t	\N	44.996513	-92.88806	2016-04-06 16:38:39.478-05	2016-04-06 16:38:39.478-05	US	f	f	t	f	f	ChIJb9Yd3HbNslIRtm8yxkRpBgw
618	2073	Dunn Brothers Coffee	1569 Grand Ave	St. Paul	MN	f	t	\N	44.940155	-93.16663	2014-02-02 14:51:57.53-06	2014-02-02 14:51:57.53-06	US	f	f	f	f	f	ChIJB9hNCRcq9ocRHHVc2dn_xKE
619	2453	Weisman Art Museum	333 East River Parkway	Minneapolis	MN	t	f	\N	44.972836	-93.23783	2014-02-02 14:52:29.16-06	2014-02-02 14:52:29.16-06	US	f	f	t	f	f	ChIJb8naNT4ts1IROphKc-DT8cw
620	60074	HyVee	16150 Pilot Knob Rd	Lakeville	MN	f	f	\N	44.71488	-93.17589	2021-10-01 05:07:05.959-05	2021-10-01 05:07:06.062-05	US	f	f	t	f	f	ChIJb8dqyB809ocROH8vR-oDokw
621	25496	Dollar Tree	8545 Edinburgh Centre Drive	Brooklyn Park	MN	t	t	\N	45.110687	-93.30285	2016-09-15 01:59:37.664-05	2016-09-15 01:59:37.664-05	US	f	f	f	f	f	ChIJb7fsDJo6s1IR7JqX4tmx-uQ
622	17828	Cheeky Monkey Deli	521 Selby Avenue	St. Paul	MN	t	f	\N	44.946823	-93.12211	2015-06-20 21:04:46.95-05	2015-06-20 21:04:46.95-05	US	f	f	f	f	f	ChIJb5QtOJcq9ocRMdXlAMkZGVY
623	59102	Hidden MN	1975 Oakcrest Ave, Suite 1	Roseville	MN	t	f	\N	45.018166	-93.182785	2021-08-04 15:18:02.449-05	2021-08-04 15:18:02.54-05	US	f	f	f	f	f	ChIJB4TjMPQrs1IRZaBGqArGzDc
624	22902	Toppers Pizza	1154 Grand Ave	St. Paul	MN	t	t	\N	44.939827	-93.14896	2016-06-13 17:53:43.924-05	2016-06-13 17:53:43.924-05	US	f	f	f	f	f	ChIJb3-tZ2gq9ocRi71mPVuRmMg
625	39724	MSP airport	4300 glumack drive	St. Paul	MN	t	t	\N	44.883606	-93.21503	2018-01-31 22:30:20.422-06	2018-01-31 22:30:20.422-06	US	t	f	f	f	f	ChIJB2rAhSov9ocRkTV4eHzT0ys
626	61589	wabasha Brewing	429 Wabasha St S	St. Paul	MN	f	t	\N	44.932957	-93.08455	2022-03-29 09:46:50.045-05	2022-03-29 09:46:50.148-05	US	f	f	f	f	f	ChIJb14CqjvV94cRuimOjMf5F6A
627	52168	Dunn Brothers Coffee	1160 County Road E W	Arden Hills	MN	t	t	\N	45.049683	-93.14949	2019-08-24 21:00:07.027-05	2019-08-24 21:00:07.142-05	US	f	f	f	f	f	ChIJB0moDDops1IRl3wU53tuDOU
628	32339	UP Cafe	1901 Traffic Street NE	Minneapolis	MN	t	t	\N	44.99191	-93.22531	2017-03-01 04:36:13.911-06	2017-03-01 04:36:13.911-06	US	f	f	f	f	f	ChIJb0hUeqots1IRBdpaXkAoTt8
629	60123	The Alchemist	2222 4th St	White Bear Lake	MN	t	t	\N	45.102917	-93.000916	2021-10-09 16:16:14.303-05	2021-10-09 16:16:14.399-05	US	f	f	f	f	f	ChIJb0DoPenQslIRxnA55D7UzIk
630	28498	Victor's 1959 Cafe	3756 Grand Ave South	Minneapolis	MN	t	f	\N	44.934235	-93.28469	2017-02-24 00:37:33.979-06	2017-02-24 00:37:33.979-06	US	f	f	f	f	f	ChIJAzVY9b0n9ocR4J7ffirBPLI
631	36245	Pow Wow Grounds	1414 E Franklin Ave	Minneapolis	MN	t	t	\N	44.96294	-93.254425	2017-07-07 13:01:38.429-05	2017-07-07 13:01:38.429-05	US	t	f	f	f	f	ChIJAwm8VFcts1IRd-jDoFOLqDQ
632	33616	Science Museum of Minnesota	120 Kellogg Blvd W	St. Paul	MN	t	t	\N	44.943268	-93.097946	2017-04-04 14:36:11.945-05	2017-04-04 14:36:11.945-05	US	f	t	f	f	f	ChIJASkitrQq9ocRHP15PiT4PPY
633	33617	Science Museum of Minnesota	120 Kellogg Blvd W	St. Paul	MN	t	t	\N	44.943268	-93.097946	2017-04-04 14:36:12.179-05	2017-04-04 14:36:12.179-05	US	f	t	f	f	f	ChIJASkitrQq9ocRHP15PiT4PPY
634	24779	Science Museum of Minnesota	120 W Kellogg Blvd	St. Paul	MN	t	t	\N	44.94257	-93.09858	2016-08-17 14:26:47.93-05	2016-08-17 14:26:47.93-05	US	f	f	f	f	f	ChIJASkitrQq9ocRHP15PiT4PPY
635	59213	Flux Arts	2505 NE Howard St NE	Minneapolis	MN	f	f	\N	45.01343	-93.25291	2021-08-05 17:02:29.164-05	2021-08-05 17:02:29.242-05	US	f	f	f	f	f	ChIJaSdTl8Yts1IRn6sbvrU4Xbg
636	32144	Kowalski's Market	2440 Hennepin Ave S	Minneapolis	MN	t	t	\N	44.95804	-93.294914	2017-02-28 11:17:45.289-06	2017-02-28 11:17:45.289-06	US	f	t	f	f	f	ChIJa_rXhNYys1IRfUCKBfYq5BY
637	32143	Kowalski's Market	2440 Hennepin Ave S	Minneapolis	MN	t	t	\N	44.95804	-93.294914	2017-02-28 11:17:45.181-06	2017-02-28 11:17:45.181-06	US	f	f	f	f	f	ChIJa_rXhNYys1IRfUCKBfYq5BY
638	5004	Glam Doll Donuts	2605 Nicollet Ave S	Minneapolis	MN	t	t	\N	44.95518	-93.2775	2014-02-16 01:49:19.056-06	2014-02-16 01:51:30.037-06	US	f	f	f	f	f	ChIJaRIBdLUys1IRJ9oxz9RkNdg
639	17494	Glam Doll Donuts	2605 Nicollet Ave S	Minneapolis	MN	t	f	\N	44.95518	-93.2775	2015-05-19 17:07:40.537-05	2015-05-19 17:07:40.537-05	US	f	t	f	f	f	ChIJaRIBdLUys1IRJ9oxz9RkNdg
640	5999	Minnesota Zoo	13000 zoo boulevard	Apple valley 	MN	t	t	\N	44.764805	-93.192085	2014-05-26 16:11:04.822-05	2014-05-26 16:11:04.822-05	US	f	t	f	f	f	ChIJA-qYtHUx9ocRI1q3y1QdFlM
641	33128	Minnesota Zoo	13000 zoo blvd.	Apple Valley	MN	t	t	\N	44.767433	-93.19577	2017-03-26 23:19:45.25-05	2017-03-26 23:19:45.25-05	US	f	f	f	f	f	ChIJA-qYtHUx9ocRI1q3y1QdFlM
642	34734	Carley Coffee	821 W. Lake St.	Minneapolis	MN	t	t	\N	44.948193	-93.29046	2017-05-01 18:25:34.725-05	2017-05-01 18:25:34.725-05	US	f	f	f	f	f	ChIJAQAweIYn9ocRAl0NsNzZf24
643	34981	Hidden Treasures Thrift Store	2915 Pentagon Dr	Minneapolis	MN	f	t	\N	45.016315	-93.21959	2017-05-10 10:59:20.7-05	2017-05-10 10:59:20.7-05	US	f	f	f	f	f	ChIJ-aGYWTEss1IREGfqbgTBzr0
644	30897	Gandhi Mahal Restaurant	3009 27th Ave S	Minneapolis	MN	t	t	\N	44.94793	-93.23291	2017-02-26 16:52:41.19-06	2017-02-26 16:52:41.19-06	US	f	f	f	f	f	ChIJAduNeiQo9ocR5S7_NPlncfQ
645	46297	Como Park Zoo & Conservatory	1225 Estabrook Dr	St. Paul	MN	t	t	\N	44.98186	-93.151405	2018-12-04 22:18:38.655-06	2018-12-04 22:18:38.698-06	US	t	f	f	f	f	ChIJad26thYrs1IRhLssxvICTaw
646	36720	Richfield Outdoor Pool	630 E. 66th Street	Richfield	MN	f	t	\N	44.883602	-93.26614	2017-07-30 11:00:22.415-05	2017-07-30 11:00:22.415-05	US	t	f	f	f	f	ChIJaclL1gUm9ocRcL6dT6_NTOw
647	26325	Ferguson Hall, University of MN West Bank	2106 S 4th St.	Minneapolis	MN	t	t	\N	44.97081	-93.24144	2016-11-11 06:57:15.127-06	2016-11-11 06:57:15.127-06	US	f	f	t	f	f	ChIJA9GQW0Ats1IR6BLuKW89CyA
648	36234	First Universalist Church	3400 Dupont Ave South	Minneapolis	MN	f	t	\N	44.94069	-93.29358	2017-07-06 16:53:03.823-05	2017-07-06 16:53:03.823-05	US	t	f	f	f	f	ChIJA8FQf5sn9ocRD6PMBhVYG4U
649	62473	First Universalists Church	3400 DuPont Ave S.	Minneapolis	MN	t	f	\N	44.940914	-93.293564	2022-06-27 10:28:41.894-05	2022-06-27 10:28:41.987-05	US	f	t	f	f	f	ChIJA8FQf5sn9ocRD6PMBhVYG4U
650	33248	Erbert and Gerbert's	1700 Grand Ave	St. Paul	MN	t	f	\N	44.93991	-93.17231	2017-03-29 12:16:46.107-05	2017-03-29 12:16:46.107-05	US	f	f	f	f	f	ChIJa4QpJhkq9ocRGBk9yaIh_lo
651	64492	2412 Nicollet Ave, Minneapolis, MN 55404, USA	2412 Nicollet Ave	Minneapolis	MN	f	f	\N	44.958546	-93.278244	2023-01-29 14:03:52.45-06	2023-01-29 14:03:52.556-06	US	f	f	f	f	f	ChIJa0f9ELYys1IR7Qofe0CGgsM
652	62135	Harbor Frieght 	11727 Ulysses Ln NE	Blaine	MN	t	f	\N	45.184082	-93.23661	2022-05-21 14:37:08.376-05	2022-05-21 14:37:08.477-05	US	f	f	f	f	f	ChIJ9zWFpIojs1IR4UBi59rsay0
653	24057	Northern Clay Center	2424 E Franklin Ave	Minneapolis	MN	t	t	\N	44.963	-93.23653	2016-07-15 13:16:21.154-05	2016-07-15 13:16:21.154-05	US	f	f	f	f	f	ChIJ9ym0dzcts1IR0Okd_bNLhAo
654	67522	Mississippi Market	1500 7th St W	St. Paul	MN	t	t	\N	44.9184	-93.14009	2023-10-03 08:35:00.258-05	2024-03-08 16:35:19.60253-06	US	f	f	f	f	f	ChIJ-9Ll4Kor9ocRcPAmnHbRtQ0
655	39378	Cabot Psychological Services	401 Groveland Avenue	Minneapolis	MN	f	t	\N	44.96575	-93.28591	2018-01-09 15:37:52.975-06	2018-01-09 15:37:52.975-06	US	f	f	f	f	f	ChIJ9fp7doEzs1IRTH2g7tmxI2A
656	17235	Toppers Pizza	712 SE Washington Ave	Minneapolis	MN	f	t	\N	44.9736	-93.22846	2015-04-25 05:57:07.298-05	2015-04-25 05:57:07.298-05	US	f	f	f	f	f	ChIJ9dp4fBgts1IRa4gmj_amYa8
657	4401	Smiley's Family Medicine Clinic	2020 East 28th Street	Minneapolis	MN	t	t	\N	44.95215	-93.24365	2014-02-02 14:55:37.706-06	2014-02-02 14:55:37.706-06	US	f	f	f	f	f	ChIJ9515ch4o9ocREeTnWJkE-WY
658	26155	Target Lino Lakes	749 Apollo Dr	Lino Lakes	MN	t	t	\N	45.184944	-93.10512	2016-11-10 13:07:09.523-06	2016-11-10 13:07:09.523-06	US	f	f	t	f	f	ChIJ925KpkvfslIRGTaTRLstAHg
659	39168	west elm	3879 Gallagher Dr	Edina 	MN	t	f	\N	44.869812	-93.328316	2017-12-27 23:41:12.18-06	2017-12-27 23:41:12.18-06	US	f	f	f	f	f	ChIJ8SwSFRsk9ocRdigF-qUzoHE
660	64674	Speedway Gas Station 	56 Snelling Ave N	St. Paul	MN	f	f	\N	44.943176	-93.16675	2023-02-19 13:45:51.009-06	2023-02-19 13:45:51.115-06	US	f	f	f	f	f	ChIJ8S4RwRAq9ocRRmUO47MlI38
661	17268	Turn Style Consignment Shop	2393 Fairview Avenue N	St. Paul 	MN	f	t	\N	45.01248	-93.17774	2015-04-27 21:10:55.116-05	2015-04-27 21:10:55.116-05	US	f	f	f	f	f	ChIJ8_JiN_Mrs1IR5jITq2BDUP4
662	35616	Pastisserie 46	4552 Grand Ave S, Minneapolis, MN 55419	Minneapolis	MN	t	t	\N	44.919758	-93.284805	2017-06-08 17:27:16.473-05	2017-06-08 17:27:16.473-05	US	f	f	t	f	f	ChIJ8fv1whkn9ocR6HUhb-sWe84
663	27633	Starbucks	171 Snelling ave	St. Paul	MN	t	f	\N	44.946415	-93.16738	2017-01-21 13:58:44.567-06	2017-01-21 13:58:44.567-06	US	f	f	t	f	f	ChIJ8fLvGhAq9ocROhISHHjpO_Q
664	3840	Black Sheep Pizza	600 Washington Avenue North	Minneapolis	MN	f	t	\N	44.987305	-93.27571	2014-02-02 14:54:38.715-06	2014-02-02 14:54:38.715-06	US	f	f	f	f	f	ChIJ8dlFFIkys1IRlWsLIEd2EB8
665	30958	Sencha Tea Bar	1692 grand Ave.	St. Paul 	MN	t	t	\N	44.940098	-93.17204	2017-02-26 18:04:18.582-06	2017-02-26 18:04:18.582-06	US	f	f	t	f	f	ChIJ8cmkJhkq9ocRpnJj7Ly3ZIE
666	17989	Akerman Hall	110 Union St SE	Minneapolis	MN	f	f	\N	44.975407	-93.232315	2015-07-15 00:30:03.598-05	2015-07-15 00:30:03.598-05	US	f	f	f	f	f	ChIJ_8cK92kts1IRuuMGRESa4ew
667	24822	Super Target	111 Pioneer Trail	Chaska	MN	t	f	\N	44.827343	-93.60121	2016-08-19 18:31:41.312-05	2016-08-19 18:31:41.312-05	US	f	f	f	f	f	ChIJ8aWol0ous1IRCxOd6GzOFO0
668	882	Target	851 W 78th St	Chanhassen	MN	t	f	\N	44.862038	-93.5446	2014-02-02 14:50:11.947-06	2014-02-02 14:50:11.947-06	US	f	f	f	f	f	ChIJ8aWol0ous1IR1TWIIEej8Ak
669	27931	Augustines	1668 selby	St. Paul	MN	t	t	\N	44.9463	-93.17122	2017-02-04 16:32:15.051-06	2017-02-04 16:32:15.051-06	US	f	t	f	f	f	ChIJ87DVLxsq9ocRCafTr7QL-wQ
670	27932	Augustines	1668 selby	St. Paul	MN	t	t	\N	44.9463	-93.17122	2017-02-04 16:32:16.407-06	2017-02-04 16:32:16.407-06	US	f	f	f	f	f	ChIJ87DVLxsq9ocRCafTr7QL-wQ
671	1425	Anoka Ramsey Community College	13000 Highway 10	Coon Rapids	MN	f	t	\N	45.193287	-93.33559	2014-02-02 14:51:01.992-06	2014-02-02 14:51:01.992-06	US	f	f	t	f	f	ChIJ8_0NBvc7s1IRn7PqAYI1OiY
672	22612	The Smitten Kitten	3016 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.94766	-93.28862	2016-06-10 19:09:08.134-05	2016-06-10 19:09:08.134-05	US	f	f	f	f	f	ChIJ802N_oUn9ocRWGu4yO1pjUs
673	27243	Ikea	8000 Ikea Way	Bloomington	MN	t	t	\N	44.858402	-93.24483	2016-12-26 17:46:12.395-06	2016-12-26 17:46:12.395-06	US	f	f	f	f	f	ChIJ7Z8ooGkv9ocR44Hb0i-TwJ0
674	59823	Linhoff Photo	4811 Excelsior Blvd	St. Louis Park	MN	f	t	\N	44.932503	-93.341705	2021-09-05 21:06:13.655-05	2021-09-05 21:06:13.754-05	US	f	f	f	f	f	ChIJ7ylP8y8n9ocRKYnsQuhednY
675	64234	Pryes Brewing 	1401 West River Rd N	Minneapolis	MN	t	t	\N	44.993587	-93.27642	2023-01-01 19:05:46.478-06	2023-01-01 19:05:46.578-06	US	f	f	f	f	f	ChIJ7wa5xmMys1IRa1RQC6U-vY8
676	36184	Black Coffee and Waffle Bar	2180 Marshall Ave	St. Paul	MN	f	t	\N	44.94814	-93.192726	2017-07-03 19:33:05.583-05	2017-07-03 19:33:05.583-05	US	t	f	f	f	f	ChIJ7dDT0-Up9ocRw-1SUHvU6sM
677	66862	Barry Family Campus	4330 Cedar Lake Road S	Minneapolis	MN	f	f	\N	44.965595	-93.3344	2023-08-07 12:41:49.366-05	2023-08-07 12:41:49.506-05	US	f	f	f	f	f	ChIJ_7BIClwzs1IR90aK5_8tiYs
678	30518	Rondo Library	461 Dale St N	St. Paul	MN	t	f	\N	44.955536	-93.12673	2017-02-26 10:09:56.071-06	2020-04-14 16:17:01.855-05	US	f	f	f	f	f	ChIJ7awyHp0q9ocRZFk0jksTWvM
679	66066	Arbeiter Brewing Co	Minnehaha 	Minneapolis	MN	t	t	\N	44.91054	-93.21564	2023-06-05 17:31:47.524-05	2023-06-05 17:31:47.618-05	US	f	f	f	f	f	ChIJ-74_cycp9ocRtteAzcOfGIU
680	66643	Arbeiter Brewing Company	3038 Minnehaha Ave	Minneapolis	MN	t	t	\N	44.947178	-93.23387	2023-07-18 00:05:32.492-05	2023-07-18 00:05:32.581-05	US	f	f	f	f	f	ChIJ-74_cycp9ocRtteAzcOfGIU
681	29479	Caribou Coffee	68 Snelling Ave S.	St. Paul	MN	f	f	\N	44.939465	-93.16647	2017-02-25 08:15:35.8-06	2017-02-25 08:15:35.8-06	US	f	f	f	f	f	ChIJ6wX8ohcq9ocRf98vp8i0ao8
682	42995	Midas New Hope	5604 Winnetka Ave N	New Hope	MN	t	t	\N	45.055435	-93.379974	2018-08-16 08:55:28.131-05	2018-08-16 08:55:28.131-05	US	f	f	f	f	f	ChIJ6Vh_3-Q2s1IRyS4bRK6l4JE
683	47283	Local Roots	817 east 66th st	Richfield	MN	t	t	\N	44.88315	-93.26209	2019-02-01 18:38:48.922-06	2019-02-01 18:38:48.96-06	US	f	t	f	f	f	ChIJ6SJlZwEm9ocR8gWPM6qIWSs
684	47281	Local Roots	817 East  street	Richfield	MN	t	t	\N	44.88315	-93.26209	2019-02-01 18:36:02.988-06	2019-02-01 18:36:03.051-06	US	f	f	f	f	f	ChIJ6SJlZwEm9ocR8gWPM6qIWSs
685	47282	Local Roots	817 east 66th street	Richfield	MN	t	t	\N	44.88315	-93.26209	2019-02-01 18:37:40.006-06	2019-02-01 18:37:40.103-06	US	f	t	f	f	f	ChIJ6SJlZwEm9ocR8gWPM6qIWSs
686	28200	First Lutheran Church	1555 40th Ave NE	Columbia Heights	MN	t	f	\N	45.0422	-93.23669	2017-02-22 21:23:19.233-06	2017-02-22 21:23:19.233-06	US	f	f	t	f	f	ChIJ6-grx2Uus1IRG8zDuynXvaw
687	55788	The C.H.A.P Store	2020 Highway 13 East	Burnsville	MN	t	t	\N	44.790085	-93.24325	2020-03-05 17:32:07.491-06	2020-04-14 16:09:46.803-05	US	t	f	t	f	f	ChIJ6-F5jxIw9ocRFU7UyQ5kAHs
688	24014	Guthrie Theater 	818 S 2nd St	Minneapolis	MN	t	f	\N	44.978157	-93.255424	2016-07-13 18:28:28.579-05	2016-07-13 18:28:28.579-05	US	f	t	f	f	f	ChIJ6dxNCmQts1IRc8PPh1iADMg
689	25503	Guthrie Theater	818 S 2nd St	Minneapolis	MN	t	t	\N	44.978157	-93.255424	2016-09-15 13:09:21.254-05	2016-09-15 13:09:21.254-05	US	f	f	f	f	f	ChIJ6dxNCmQts1IRc8PPh1iADMg
690	24013	Guthrie Theatre 	818 S 2nd St	Minneapolis	MN	t	f	\N	44.978157	-93.255424	2016-07-13 18:25:13.138-05	2016-07-13 18:25:13.138-05	US	f	t	f	f	f	ChIJ6dxNCmQts1IRc8PPh1iADMg
691	19488	The Guthrie Theater	818 S 2nd St	Minneapolis	MN	t	t	\N	44.978065	-93.255486	2015-12-01 22:42:55.259-06	2015-12-01 22:42:55.259-06	US	f	f	f	f	f	ChIJ6dxNCmQts1IRc8PPh1iADMg
692	24267	Guthrie Theater	South 2nd Street	Minneapolis	MN	t	t	\N	44.978703	-93.25778	2016-07-24 18:28:19.206-05	2016-07-24 18:28:19.206-05	US	f	t	f	f	f	ChIJ6dxNCmQts1IRc8PPh1iADMg
693	34229	Playwrights' Center	2301 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962498	-93.239075	2017-04-17 13:50:10.435-05	2017-04-17 13:50:10.435-05	US	f	t	f	f	f	ChIJ63iR4Dcts1IRZy4UQWLnxms
694	34230	Playwrights' Center	2301 E Franklin Ave	Minneapolis	MN	t	t	\N	44.962498	-93.239075	2017-04-17 13:50:10.919-05	2017-04-17 13:50:10.919-05	US	f	f	f	f	f	ChIJ63iR4Dcts1IRZy4UQWLnxms
695	38676	Caribou Coffee	917 Washington Ave SE	Minneapolis	MN	t	t	\N	44.974125	-93.224815	2017-11-15 12:58:19.791-06	2017-11-15 12:58:19.791-06	US	t	f	f	f	f	ChIJ5ZewTx8ts1IR6nQUFCF4pc0
696	29904	Reverie 	1929 Nicollet ave	Minneapolis	MN	f	f	\N	44.962837	-93.277435	2017-02-25 15:46:23.838-06	2017-02-25 15:46:23.838-06	US	f	t	f	f	f	ChIJ5ZCPLrgys1IRIez419HzY9g
697	29905	Reverie 	1929 Nicollet ave	Minneapolis	MN	f	f	\N	44.962837	-93.277435	2017-02-25 15:46:24.679-06	2017-02-25 15:46:24.679-06	US	f	t	f	f	f	ChIJ5ZCPLrgys1IRIez419HzY9g
698	24556	Cold Stone Creamery	Southport Centre, 15100 Cedar Ave #202	Apple Valley	MN	t	t	\N	44.74679	-93.21781	2016-08-05 17:28:02.33-05	2016-08-05 17:28:02.33-05	US	f	f	f	f	f	ChIJ5wvdtSox9ocR5th7Feg44Ug
699	42639	Hennepin Square 	2021 e Hennepin Ave	Minneapolis	MN	t	f	\N	44.991802	-93.22373	2018-07-29 12:55:35.989-05	2018-07-29 12:55:35.989-05	US	f	f	t	f	f	ChIJ-5wjdQAts1IRLB75gtJ1sIA
700	24304	County Rd C, Andover, MN 55304, USA	County Rd C	Andover	MN	t	f	\N	45.21451	-93.28607	2016-07-26 20:41:42.307-05	2016-07-26 20:41:42.307-05	US	f	f	f	f	f	ChIJ5U7viCgjs1IRfDTE1OaewEg
701	38903	Red Wagon Pizza	5416 Penn Avenue South	Minneapolis	MN	t	t	\N	44.904594	-93.308975	2017-12-03 16:43:56.679-06	2017-12-03 16:43:56.679-06	US	t	f	f	f	f	ChIJ5RLJH_Am9ocRtHcfcIrr080
702	51955	Interfaith Outreach & Community Partners	1605 County Road 101 N	Plymouth	MN	t	f	\N	44.996956	-93.502655	2019-08-15 14:37:27.414-05	2019-08-15 14:37:27.557-05	US	f	f	f	f	f	ChIJ5Q-q1AzZsokRokTVt8n0-fY
703	44610	SPNN	550 Vandalia Street Ste 170	St. Paul	MN	t	f	\N	44.95795	-93.191246	2018-09-23 17:20:15.689-05	2020-04-14 16:29:13.549-05	US	f	f	f	f	f	ChIJ5cPL_bIss1IROc-N68r98-c
704	43319	Como Park Zoo and Conservatory	1225 Estabrook Dr	St. Paul	MN	t	t	\N	44.98186	-93.151405	2018-09-01 11:39:31.601-05	2020-04-14 16:25:02.351-05	US	f	t	f	f	f	ChIJ5c3H2xArs1IRWl8vqH3Jq0U
705	52773	El Burrito	4820 Chicago Ave	Minneapolis	MN	f	t	\N	44.915436	-93.26296	2019-09-15 17:26:53.617-05	2019-09-15 17:26:53.737-05	US	f	f	f	f	f	ChIJ57VFXCsm9ocRWEC4nrl2ZHw
706	20314	Super Target	1300 University Ave	St. Paul	MN	t	t	\N	44.952908	-93.15565	2016-02-11 11:59:40.468-06	2016-02-11 11:59:40.468-06	US	f	f	f	f	f	ChIJ56VWVXQq9ocRXnZj5eDhQ44
707	51032	Old Southern Smokehouse	3845 Lexington Ave N	Arden Hills	MN	t	t	\N	45.056858	-93.148705	2019-07-14 13:57:02.866-05	2019-07-14 13:57:02.976-05	US	f	f	f	f	f	ChIJ55qlU-gps1IRP1PFU6Bqx_Q
708	23644	Noodles and Co	2865 White Bear Ave	Maplewood 	MN	f	f	\N	45.02764	-93.01863	2016-06-27 13:02:41.612-05	2016-06-27 13:02:41.612-05	US	f	f	f	f	f	ChIJ54o9NPrTslIRZOyoAALiCgQ
709	29326	Cornerstone 	1000 E 80th St.	Bloomington	MN	t	t	\N	44.858414	-93.26038	2017-02-24 23:36:13.28-06	2017-02-24 23:36:13.28-06	US	f	f	f	f	f	ChIJ52Hd-ool9ocRrWTaoVOW3qU
710	65990	The Fox and Pantry	15725 37th Ave N Unit 7	Plymouth	MN	t	t	\N	45.023407	-93.48098	2023-05-31 12:15:17.876-05	2023-05-31 12:15:17.979-05	US	f	f	f	f	f	ChIJ4Z_PGlpJs1IRZBqXGZvO-iI
711	39884	Finnish Bistro	2278 Como Ave	St. Paul	MN	f	t	\N	44.981613	-93.19499	2018-02-10 19:09:04.664-06	2018-02-10 19:09:04.664-06	US	t	f	f	f	f	ChIJ4xkkmpEss1IRdil5xVyvdB4
712	21006	Muffin Top Cafe	1424 Nicollet Avenue South	Minneapolis	MN	t	t	\N	44.967884	-93.278206	2016-04-02 13:13:37.386-05	2016-04-02 13:13:37.386-05	US	f	f	f	f	f	ChIJ4TBVIb8ys1IRLf_x-FuyIE0
713	33371	Leeann Chin	3875 Gallagher Dr	Edina	MN	t	t	\N	44.86993	-93.32827	2017-03-31 16:38:57.778-05	2017-03-31 16:38:57.778-05	US	f	t	f	f	f	ChIJ4Ta1KBsk9ocRoSMfohQhhyE
714	33372	Leeann Chin	3875 Gallagher Dr	Edina	MN	t	t	\N	44.86993	-93.32827	2017-03-31 16:38:58.391-05	2017-03-31 16:38:58.391-05	US	f	t	f	f	f	ChIJ4Ta1KBsk9ocRoSMfohQhhyE
715	33373	Leeann Chin	3875 Gallagher Dr	Edina	MN	t	t	\N	44.86993	-93.32827	2017-03-31 16:45:29.151-05	2017-03-31 16:45:29.151-05	US	f	f	f	f	f	ChIJ4Ta1KBsk9ocRoSMfohQhhyE
716	21901	The Country Bar	3006 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.948006	-93.288475	2016-05-05 20:45:05.552-05	2016-05-05 20:45:05.552-05	US	f	f	f	f	f	ChIJ4RxzVY8n9ocRHnRUz8e2pME
717	3789	May Day Cafe	3500 Bloomington Ave	Minneapolis	MN	t	t	\N	44.939396	-93.25266	2014-02-02 14:54:35.343-06	2024-03-25 17:24:15.981341-05	US	f	f	t	f	f	ChIJ44k5qA4o9ocRX-OeW8FtATI
718	33008	Shevlin Hall	164 Pillsbury Drive SE	Minneapolis	MN	f	t	\N	44.978447	-93.237625	2017-03-03 08:51:17.378-06	2017-03-03 08:51:17.378-06	US	f	f	f	f	f	ChIJ42KCvBMts1IRBjYMdzYnuIY
719	17762	Minnetonka Library	17524 Excelsior Blvd.	Minnetonka	MN	t	t	\N	44.908672	-93.50284	2015-06-15 19:44:24.437-05	2015-06-15 19:44:24.437-05	US	f	f	f	f	f	ChIJ3x8T1yoc9ocRXmDj5do03io
720	29374	Target	3601 Highway 100 S.	St. Louis Park	MN	f	f	\N	44.937256	-93.346855	2017-02-25 01:02:15.78-06	2017-02-25 01:02:15.78-06	US	f	f	f	f	f	ChIJ3UqsBLog9ocRo3vcS07aRGY
721	59298	Olivia's Organic Cafe	11849 Millpond Ave	Burnsville	MN	t	t	\N	44.79096	-93.24393	2021-08-06 15:36:21.768-05	2021-08-06 15:36:21.878-05	US	t	f	f	f	f	ChIJ3T3ZWxEw9ocRbipHECGi9PM
722	34027	Starbucks	190 Lake Drive East	Chanhassen	MN	t	t	\N	44.860893	-93.52422	2017-04-13 15:07:21.771-05	2017-04-13 15:07:21.771-05	US	f	f	f	f	f	ChIJ_3oyEpIb9ocR2ds6MY2Btn4
723	34026	Starbucks	190 Lake Drive East	Chanhassen	MN	t	t	\N	44.860893	-93.52422	2017-04-13 15:07:20.793-05	2017-04-13 15:07:20.793-05	US	f	f	f	f	f	ChIJ_3oyEpIb9ocR2ds6MY2Btn4
724	36372	Stark Mental Health Clinic	2120 Park Avenue South	Minneapolis	MN	t	f	\N	44.96117	-93.265884	2017-07-13 11:25:50.201-05	2017-07-13 11:25:50.201-05	US	f	f	f	f	f	ChIJ388sEa8ys1IR25oO538d3Mo
725	50623	LynLake Brewery	2934 Lyndale Ave S	Minneapolis	MN	t	t	\N	44.94889	-93.288506	2019-06-23 19:28:10.163-05	2019-06-23 19:28:10.186-05	US	f	f	f	f	f	ChIJ33dlp4gn9ocR3IhpL0yjBZU
726	37452	Lyn Lake Brewery	2894 Lyndale Ave S	Minneapolis	MN	f	t	\N	44.95009	-93.28875	2017-09-03 16:27:40.945-05	2017-09-03 16:27:40.945-05	US	f	t	f	f	f	ChIJ33dlp4gn9ocR3IhpL0yjBZU
727	52974	Lakewinds	17501 Minnetonka Blvd	Minnetonka	MN	t	t	\N	44.941174	-93.50074	2019-09-23 16:08:43.483-05	2019-09-23 16:08:43.591-05	US	f	f	f	f	f	ChIJ2UpXVgce9ocReWT6j_uRMrQ
728	19894	Workhorse Coffee	2399 University Avenue	St. Paul	MN	t	t	\N	44.964245	-93.198074	2016-01-21 12:27:40.853-06	2016-01-21 12:27:40.853-06	US	f	f	f	f	f	ChIJ2T3T87css1IRhQLO04AmErQ
729	19895	Workhorse Coffee Bar	2399 University Avenue	St. Paul	MN	f	f	\N	44.964245	-93.198074	2016-01-21 12:28:55.593-06	2016-01-21 12:28:55.593-06	US	f	t	f	f	f	ChIJ2T3T87css1IRhQLO04AmErQ
730	50799	Workhorse Coffee Bar	2399 University Ave	St. Paul	MN	t	f	\N	44.96432	-93.19805	2019-07-02 08:23:00.774-05	2019-07-02 08:23:00.851-05	US	f	t	f	f	f	ChIJ2T3T87css1IRhQLO04AmErQ
731	4086	Tea Source, St Anthony Village, MN	2908 Pentagon Dr. NE St. Anthony Shopping Center	St. Anthony	MN	f	t	\N	45.0159	-93.21923	2014-02-02 14:55:07.367-06	2014-02-02 14:55:07.367-06	US	f	f	f	f	f	ChIJ2SuNWTEss1IRjJIwMA8MaA0
732	41802	Minnesota state capital 	Rev Dr Martin Luther King Junior Boulevard.	St. Paul	MN	t	t	\N	44.953896	-93.100655	2018-06-12 10:42:04.938-05	2020-04-14 16:23:36.665-05	US	t	f	f	f	f	ChIJ2Qha5qsq9ocRk0Jv3NQ8Msc
733	59396	Brooklyn Park City Hall	5200 85th Ave N	Brooklyn Park	MN	t	t	\N	45.10966	-93.34765	2021-08-07 14:30:29.194-05	2021-08-07 14:30:29.282-05	US	f	f	f	f	f	ChIJ_2N_UQU6s1IRoMZpe7eEPas
734	27540	Alderman hall	1970 Folwell avenue	Falcon Heights	MN	t	t	\N	44.98748	-93.183464	2017-01-20 15:07:58.101-06	2017-01-20 15:07:58.101-06	US	f	f	f	f	f	ChIJ2_N9woMss1IRowco7HnVjjE
735	3493	Hamline University	1536 Hewitt Ave	St. Paul	MN	t	f	\N	44.966476	-93.16536	2014-02-02 14:54:05.502-06	2014-02-02 14:54:05.502-06	US	f	f	f	f	f	ChIJ2etUBkYrs1IRukE2CCG5w7I
736	67805	The landing 	44.8034764, -93.4914016	Shakopee	MN	t	t	\N	44.797398	-93.52728	2023-11-05 13:41:40.264-06	2023-11-05 13:41:40.36-06	US	t	t	f	f	f	ChIJ2cWktVgM9ocRmuScS_2coLE
737	26116	Moose and Sadie's	212 3rd Ave N #107	Minneapolis	MN	t	t	\N	44.98533	-93.27203	2016-11-10 09:34:16.065-06	2016-11-10 09:34:16.065-06	US	f	t	f	f	f	ChIJ2b0f2pwys1IRklQVPAJ_esg
738	26570	Icy Cup	63 George Street West	St. Paul	MN	f	t	\N	44.92987	-93.08778	2016-11-16 13:39:47.255-06	2016-11-16 13:39:47.255-06	US	f	f	f	f	f	ChIJ2_1n9y_V94cRLPIDN-DvrJ0
739	48232	Dangerous Man Brewing Company	1300 2nd St NE	Minneapolis	MN	t	f	\N	45.00113	-93.26642	2019-03-18 06:12:44.946-05	2019-03-18 06:12:44.969-05	US	t	f	t	f	f	ChIJ1YIFdXcys1IRWaTmoj43oAo
740	4356	Northbound Smokehouse & Brewpub	2716 East 38th Street	Minneapolis	MN	t	t	\N	44.934288	-93.23247	2014-02-02 14:55:34.002-06	2014-04-12 20:25:48.274-05	US	f	f	f	f	f	ChIJ1QcgOkco9ocR2aQTns3afhI
741	45768	Scott Hall	Pleasant St SE	Minneapolis	MN	f	t	\N	44.976883	-93.23706	2018-11-09 15:27:20.083-06	2018-11-09 15:27:20.083-06	US	f	f	f	f	f	ChIJ1ffPbBQts1IRj6uD2v5SkfE
742	36726	Common Ground Meditation 	2700 E 26th St	Minneapolis	MN	t	t	\N	44.95578	-93.23284	2017-07-30 15:12:53.78-05	2017-07-30 15:12:53.78-05	US	f	f	f	f	f	ChIJ1eOrZzMts1IRTv6EVtCXwno
743	51180	Sonder Shaker	130 E Hennepin	Minneapolis	MN	t	t	\N	44.987206	-93.25809	2019-07-20 16:42:14.179-05	2024-03-15 15:33:52.15226-05	US	f	f	f	f	f	ChIJ1cGsvn4ts1IR3puvn6kWZbw
744	46943	StevenBe	3448 Chicago Ave	Minneapolis	MN	t	t	\N	44.939693	-93.2629	2019-01-11 19:05:07.963-06	2019-01-11 19:05:07.992-06	US	f	f	f	f	f	ChIJ1bpQ_OMn9ocRUAZtCDOlgWM
745	66597	Blaze Pizza	MN-7	St. Louis Park	MN	t	t	\N	44.93747	-93.37205	2023-07-13 20:02:24.859-05	2023-07-13 20:02:25.021-05	US	f	f	f	f	f	ChIJ1aZ3wmMg9ocRRKBEXPu-9Hs
746	45402	Subway	Victoria and Selby	St. Paul	MN	t	f	\N	44.946926	-93.13634	2018-10-25 12:30:28.734-05	2018-10-25 12:30:28.734-05	US	f	f	f	f	f	ChIJ_1-aaogq9ocRklotC1dAxI8
747	47504	BP/Speedway gas	2151 sale street north	Roseville	MN	t	t	\N	45.006077	-93.15661	2019-02-14 08:40:21.721-06	2019-02-14 08:40:21.858-06	US	f	f	t	f	f	ChIJ1_-7rbkrs1IRLzKVMYFsANM
748	27436	Twin cities premium outlet	3965 eagan outlets parkway	Eagan	MN	t	f	\N	44.814987	-93.21563	2017-01-13 13:58:22.457-06	2017-01-13 13:58:22.457-06	US	f	f	f	f	f	ChIJ0ZXiCzIu9ocRaSMe8yTO6sc
749	23357	Cold Stone Creamery	2700 39th Ave NE	Minneapolis	MN	t	f	\N	45.039192	-93.22071	2016-06-18 16:10:11.92-05	2016-06-18 16:10:11.92-05	US	f	f	f	f	f	ChIJ0ZtoZY8us1IRaRlX7uf0w7Q
750	67014	Saint Joseph's School of Music	1619 Dayton Ave. Suite 200	St. Paul	MN	t	t	\N	44.947834	-93.16836	2023-08-15 14:05:49.208-05	2023-08-15 14:05:49.387-05	US	f	f	f	f	f	ChIJ0zRG0nUq9ocRhSQZHTeEsiw
751	45772	U of MN Architecture and Design	80 Church St SE	Minneapolis	MN	t	t	\N	44.976284	-93.23314	2018-11-09 17:15:43.058-06	2018-11-09 17:15:43.058-06	US	t	f	f	f	f	ChIJ0Zqj6RYts1IRzpWzHjUz6KA
752	24158	church	4100 Lyndale Ave S, Minneapolis, MN 55409	Minneapolis	MN	t	t	\N	44.9283	-93.288994	2016-07-18 23:10:16.899-05	2016-07-18 23:10:16.899-05	US	f	f	f	f	f	ChIJ0-Z6tqQn9ocR-ylTBaHSqas
753	41099	Hubert H. Humphrey Center	301 19th Ave S	Minneapolis	MN	t	t	\N	44.971416	-93.244545	2018-04-26 15:14:11.838-05	2018-04-26 15:14:11.838-05	US	f	f	f	f	f	ChIJ0z51jUEts1IRSCGuG_eg3Zc
754	44650	BP	5150 W 98th	Bloomington	MN	t	t	\N	44.825397	-93.34805	2018-09-25 14:02:47.118-05	2020-04-14 16:29:29.12-05	US	t	f	f	f	f	ChIJ0z2EdXIj9ocRGxNeKryIC5U
755	31301	White Bear Unitarian Universalist Church	328 Maple Street	Mahtomedi 	MN	t	t	\N	45.071514	-92.94839	2017-02-27 06:50:46.844-06	2017-02-27 06:50:46.844-06	US	f	t	t	f	f	ChIJ0ytsfCrOslIR0djPUp3zJ8I
756	16794	White Bear Unitarian Universalist Church	328 Maple St	Mahtomedi	MN	t	t	\N	45.071514	-92.94839	2015-03-19 15:55:20.541-05	2015-03-19 15:55:20.541-05	US	f	t	f	f	f	ChIJ0ytsfCrOslIR0djPUp3zJ8I
757	16793	White Bear Unitarian Universalist Church	328 Maple St	Mahtomedi	MN	t	f	\N	45.071514	-92.94839	2015-03-19 15:52:58.646-05	2015-03-19 15:52:58.646-05	US	f	t	f	f	f	ChIJ0ytsfCrOslIR0djPUp3zJ8I
758	64774	White Bear Unitarian Universalist Church 	328 Maple St	Mahtomedi 	MN	t	t	\N	45.071533	-92.94857	2023-02-28 08:49:56.463-06	2023-02-28 08:49:56.556-06	US	t	f	f	f	f	ChIJ0ytsfCrOslIR0djPUp3zJ8I
759	33615	Widmer Supermarket	1936 St. Clair Ave	St. Paul	MN	t	t	\N	44.934097	-93.18208	2017-04-04 14:33:20.227-05	2017-04-04 14:33:20.227-05	US	f	f	f	f	f	ChIJ0wMCmosp9ocRK8_U-cUN0kw
760	44307	The Riverview Cafe and Wine Bar	3753 42nd Ave S	Minneapolis	MN	t	t	\N	44.934414	-93.21248	2018-09-16 23:50:33.237-05	2020-04-14 16:27:35.44-05	US	t	f	f	f	f	ChIJ0WE1ZbYp9ocRzfc0hHv6gJQ
761	28274	Chaska High School	545 Pioneer Trail	Chaska	MN	f	t	\N	44.82405	-93.58925	2017-02-23 16:26:14.136-06	2017-02-23 16:26:14.136-06	US	f	f	f	f	f	ChIJ0VtDly8F9ocRzlZ1UG3QsbQ
762	41838	Cycles for Change Minneapolis	2010 26th Ave S	Minneapolis	MN	t	t	\N	44.962543	-93.23481	2018-06-15 09:00:50.229-05	2020-04-14 16:23:42.966-05	US	f	f	f	f	f	ChIJ0SBlWYIq9ocRvKhZZiqMZnk
763	30516	Hamline University Drew Science Center	MN-51	St. Paul	MN	t	f	\N	44.95407	-93.166885	2017-02-26 10:08:07.809-06	2020-04-14 16:17:01.022-05	US	f	f	f	f	f	ChIJ0fI9_TIrs1IRblASPuR0gsE
764	48065	Sam's Club	14940 Florence Trail	Apple Valley	MN	t	t	\N	44.734863	-93.201035	2019-03-12 10:58:03.131-05	2019-03-12 10:58:03.673-05	US	t	f	f	f	f	ChIJ0fHrRzQx9ocR-W7uqrYzcsg
765	27133	Young Joni	165 13th Ave NE	Minneapolis	MN	t	t	\N	45.001114	-93.26671	2016-12-15 16:19:05.685-06	2016-12-15 16:19:05.685-06	US	f	f	t	f	f	ChIJ0cmWdHcys1IRLPghJwH8Nlw
766	18535	Hill Valley Cafe	3301 Central Ave NE	Minneapolis	MN	f	t	\N	45.027733	-93.24703	2015-08-30 17:46:35.953-05	2015-08-30 17:46:35.953-05	US	f	t	f	f	f	ChIJ06IuDOAts1IRxElYRVr-IxY
767	18533	Hill Valley Cafe	3301 Central Ave NE	Minneapolis	MN	f	f	\N	45.027733	-93.24703	2015-08-30 17:42:26.674-05	2015-08-30 17:42:26.674-05	US	f	f	f	f	f	ChIJ06IuDOAts1IRxElYRVr-IxY
768	3793	East Lake Library	2727 East Lake St.	Minneapolis	MN	f	f	\N	44.948364	-93.23267	2014-02-02 14:54:35.5-06	2014-02-02 14:54:35.5-06	US	f	f	t	f	f	ChIJ05X2ZyQo9ocR1qrvzDfDKvQ
769	18042	340 West Market, Bloomington, MN 55425, USA	340 West Market	Bloomington	MN	t	t	\N	44.854702	-93.24443	2015-07-19 13:42:45.5-05	2015-07-19 13:42:45.5-05	US	f	t	f	f	f	ChIJ054AvG4v9ocRw-9yC9oM0Es
770	18039	340 West Market, Bloomington, MN 55425, USA	340 West Market	Bloomington	MN	t	t	\N	44.854702	-93.24443	2015-07-19 12:27:16.743-05	2015-07-19 12:27:16.743-05	US	f	f	f	f	f	ChIJ054AvG4v9ocRw-9yC9oM0Es
771	49717	Gorkha Palace	25 4th St NE	Minneapolis	MN	f	f	\N	44.989292	-93.25498	2019-05-11 18:41:30.285-05	2019-05-11 18:41:30.306-05	US	f	f	f	f	f	ChIJ02_O-ngts1IRNDRHYVqX6kY
433	47878	Municipal Building	350 S. 5th St	Minneapolis	MN	t	t	\N	44.97728	-93.26543	2019-03-04 10:37:52.435-06	2024-06-04 14:54:57.30844-05	US	f	f	t	f	f	ChIJiXW5Gpwys1IRtAwsAGrj2cU
494	3788	Fireroast Mountain Cafe	3800 37th Ave. South	Minneapolis	MN	f	t	\N	44.93405	-93.219505	2014-02-02 14:54:35.307-06	2024-09-17 12:56:48.890207-05	US	f	f	t	f	f	ChIJG2KV3Uoo9ocRft-HxftqSg8
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: rileyalexis
--

COPY public."user" (id, username, password, is_admin, is_removed, inserted_at, updated_at, reset_password_token, reset_password_expires) FROM stdin;
8	riley@riley.com	$2a$10$XskhPu4L5SRsxLSVs9Aumefy.waHzvQLvReVFrUygjaQD2It0NI0G	t	f	2024-08-29 13:23:26.39641-05	2024-08-29 13:23:26.39641-05	\N	\N
9	riley2@riley.com	$2a$10$3vR0qofdQB/zznWLA4QCe.kW5xjvO9dUThGem8YlcAGC1pgf0mDGq	t	f	2024-08-29 18:01:33.397376-05	2024-08-29 18:01:33.397376-05	\N	\N
\.


--
-- Name: comment_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rileyalexis
--

SELECT pg_catalog.setval('public.comment_votes_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rileyalexis
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, true);


--
-- Name: opening_hours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rileyalexis
--

SELECT pg_catalog.setval('public.opening_hours_id_seq', 466, true);


--
-- Name: restroom_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rileyalexis
--

SELECT pg_catalog.setval('public.restroom_votes_id_seq', 2, true);


--
-- Name: restrooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rileyalexis
--

SELECT pg_catalog.setval('public.restrooms_id_seq', 771, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rileyalexis
--

SELECT pg_catalog.setval('public.user_id_seq', 9, true);


--
-- Name: comment_votes comment_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: opening_hours opening_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_pkey PRIMARY KEY (id);


--
-- Name: restroom_votes restroom_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_pkey PRIMARY KEY (id);


--
-- Name: restrooms restrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.restrooms
    ADD CONSTRAINT restrooms_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: comments trigger_update_updated_at_comments; Type: TRIGGER; Schema: public; Owner: rileyalexis
--

CREATE TRIGGER trigger_update_updated_at_comments AFTER INSERT ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();


--
-- Name: restroom_votes trigger_update_updated_at_restroom_votes; Type: TRIGGER; Schema: public; Owner: rileyalexis
--

CREATE TRIGGER trigger_update_updated_at_restroom_votes AFTER INSERT ON public.restroom_votes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();


--
-- Name: restrooms trigger_update_updated_at_restrooms; Type: TRIGGER; Schema: public; Owner: rileyalexis
--

CREATE TRIGGER trigger_update_updated_at_restrooms AFTER UPDATE ON public.restrooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();


--
-- Name: comment_votes comment_votes_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comment_votes comment_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: comments comments_restroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: opening_hours opening_hours_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;


--
-- Name: opening_hours opening_hours_restroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;


--
-- Name: restroom_votes restroom_votes_restroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;


--
-- Name: restroom_votes restroom_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rileyalexis
--

ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

