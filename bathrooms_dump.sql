PGDMP     -    
    
            |         	   bathrooms    15.3    15.3 X               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                        1262    25463 	   bathrooms    DATABASE     �   CREATE DATABASE bathrooms WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = icu LOCALE = 'en_US.UTF-8' ICU_LOCALE = 'en-US';
    DROP DATABASE bathrooms;
                rileyalexis    false                        3079    25588    postgis 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    DROP EXTENSION postgis;
                   false            !           0    0    EXTENSION postgis    COMMENT     ^   COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
                        false    2            �            1255    25573    update_updated_at_restrooms()    FUNCTION     �  CREATE FUNCTION public.update_updated_at_restrooms() RETURNS trigger
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
 4   DROP FUNCTION public.update_updated_at_restrooms();
       public          rileyalexis    false            �            1259    26686 	   bookmarks    TABLE     i   CREATE TABLE public.bookmarks (
    id integer NOT NULL,
    user_id integer,
    restroom_id integer
);
    DROP TABLE public.bookmarks;
       public         heap    rileyalexis    false            �            1259    26685    bookmarks_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bookmarks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.bookmarks_id_seq;
       public          rileyalexis    false    237            "           0    0    bookmarks_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.bookmarks_id_seq OWNED BY public.bookmarks.id;
          public          rileyalexis    false    236            �            1259    25519    comment_votes    TABLE     �   CREATE TABLE public.comment_votes (
    id integer NOT NULL,
    user_id integer,
    comment_id integer,
    vote text,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
 !   DROP TABLE public.comment_votes;
       public         heap    rileyalexis    false            �            1259    25518    comment_votes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.comment_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.comment_votes_id_seq;
       public          rileyalexis    false    222            #           0    0    comment_votes_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.comment_votes_id_seq OWNED BY public.comment_votes.id;
          public          rileyalexis    false    221            �            1259    25496    comments    TABLE     5  CREATE TABLE public.comments (
    id integer NOT NULL,
    content text,
    restroom_id integer,
    user_id integer,
    is_removed boolean DEFAULT false,
    is_flagged boolean DEFAULT false,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.comments;
       public         heap    rileyalexis    false            �            1259    25495    comments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.comments_id_seq;
       public          rileyalexis    false    220            $           0    0    comments_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;
          public          rileyalexis    false    219            �            1259    26669    contact    TABLE     �   CREATE TABLE public.contact (
    id integer NOT NULL,
    user_id integer,
    details character varying,
    resolved boolean DEFAULT false,
    inserted_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.contact;
       public         heap    rileyalexis    false            �            1259    26668    contact_id_seq    SEQUENCE     �   CREATE SEQUENCE public.contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.contact_id_seq;
       public          rileyalexis    false    235            %           0    0    contact_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.contact_id_seq OWNED BY public.contact.id;
          public          rileyalexis    false    234            �            1259    26647    flagged_restrooms    TABLE     =  CREATE TABLE public.flagged_restrooms (
    id integer NOT NULL,
    restroom_id integer,
    user_id integer,
    api_id character varying,
    name character varying,
    address character varying,
    public boolean,
    accessible boolean,
    changing_table boolean,
    unisex boolean,
    is_single_stall boolean,
    menstrual_products boolean,
    is_permanently_closed boolean,
    other_comment character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    resolved boolean DEFAULT false
);
 %   DROP TABLE public.flagged_restrooms;
       public         heap    rileyalexis    false            �            1259    26646    flagged_restrooms_id_seq    SEQUENCE     �   CREATE SEQUENCE public.flagged_restrooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.flagged_restrooms_id_seq;
       public          rileyalexis    false    233            &           0    0    flagged_restrooms_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.flagged_restrooms_id_seq OWNED BY public.flagged_restrooms.id;
          public          rileyalexis    false    232            �            1259    25559    opening_hours    TABLE       CREATE TABLE public.opening_hours (
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
 !   DROP TABLE public.opening_hours;
       public         heap    rileyalexis    false            �            1259    25558    opening_hours_id_seq    SEQUENCE     �   CREATE SEQUENCE public.opening_hours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.opening_hours_id_seq;
       public          rileyalexis    false    226            '           0    0    opening_hours_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.opening_hours_id_seq OWNED BY public.opening_hours.id;
          public          rileyalexis    false    225            �            1259    25540    restroom_votes    TABLE       CREATE TABLE public.restroom_votes (
    id integer NOT NULL,
    user_id integer,
    restroom_id integer,
    upvote integer,
    downvote integer,
    inserted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
 "   DROP TABLE public.restroom_votes;
       public         heap    rileyalexis    false            �            1259    25539    restroom_votes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.restroom_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.restroom_votes_id_seq;
       public          rileyalexis    false    224            (           0    0    restroom_votes_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.restroom_votes_id_seq OWNED BY public.restroom_votes.id;
          public          rileyalexis    false    223            �            1259    25478 	   restrooms    TABLE     �  CREATE TABLE public.restrooms (
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
    place_id text,
    is_approved boolean DEFAULT true
);
    DROP TABLE public.restrooms;
       public         heap    rileyalexis    false            �            1259    25477    restrooms_id_seq    SEQUENCE     �   CREATE SEQUENCE public.restrooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.restrooms_id_seq;
       public          rileyalexis    false    218            )           0    0    restrooms_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.restrooms_id_seq OWNED BY public.restrooms.id;
          public          rileyalexis    false    217            �            1259    25465    user    TABLE     �  CREATE TABLE public."user" (
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
    DROP TABLE public."user";
       public         heap    rileyalexis    false            �            1259    25464    user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.user_id_seq;
       public          rileyalexis    false    216            *           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;
          public          rileyalexis    false    215            N           2604    26689    bookmarks id    DEFAULT     l   ALTER TABLE ONLY public.bookmarks ALTER COLUMN id SET DEFAULT nextval('public.bookmarks_id_seq'::regclass);
 ;   ALTER TABLE public.bookmarks ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    237    236    237            ?           2604    25522    comment_votes id    DEFAULT     t   ALTER TABLE ONLY public.comment_votes ALTER COLUMN id SET DEFAULT nextval('public.comment_votes_id_seq'::regclass);
 ?   ALTER TABLE public.comment_votes ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    221    222    222            :           2604    25499    comments id    DEFAULT     j   ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);
 :   ALTER TABLE public.comments ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    220    219    220            K           2604    26672 
   contact id    DEFAULT     h   ALTER TABLE ONLY public.contact ALTER COLUMN id SET DEFAULT nextval('public.contact_id_seq'::regclass);
 9   ALTER TABLE public.contact ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    235    234    235            G           2604    26650    flagged_restrooms id    DEFAULT     |   ALTER TABLE ONLY public.flagged_restrooms ALTER COLUMN id SET DEFAULT nextval('public.flagged_restrooms_id_seq'::regclass);
 C   ALTER TABLE public.flagged_restrooms ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    233    232    233            E           2604    25562    opening_hours id    DEFAULT     t   ALTER TABLE ONLY public.opening_hours ALTER COLUMN id SET DEFAULT nextval('public.opening_hours_id_seq'::regclass);
 ?   ALTER TABLE public.opening_hours ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    225    226    226            B           2604    25543    restroom_votes id    DEFAULT     v   ALTER TABLE ONLY public.restroom_votes ALTER COLUMN id SET DEFAULT nextval('public.restroom_votes_id_seq'::regclass);
 @   ALTER TABLE public.restroom_votes ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    224    223    224            /           2604    25481    restrooms id    DEFAULT     l   ALTER TABLE ONLY public.restrooms ALTER COLUMN id SET DEFAULT nextval('public.restrooms_id_seq'::regclass);
 ;   ALTER TABLE public.restrooms ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    217    218    218            *           2604    25468    user id    DEFAULT     d   ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public."user" ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    216    215    216                      0    26686 	   bookmarks 
   TABLE DATA           =   COPY public.bookmarks (id, user_id, restroom_id) FROM stdin;
    public          rileyalexis    false    237   �t                 0    25519    comment_votes 
   TABLE DATA           _   COPY public.comment_votes (id, user_id, comment_id, vote, inserted_at, updated_at) FROM stdin;
    public          rileyalexis    false    222   �t                 0    25496    comments 
   TABLE DATA           v   COPY public.comments (id, content, restroom_id, user_id, is_removed, is_flagged, inserted_at, updated_at) FROM stdin;
    public          rileyalexis    false    220   �t                 0    26669    contact 
   TABLE DATA           N   COPY public.contact (id, user_id, details, resolved, inserted_at) FROM stdin;
    public          rileyalexis    false    235   8u                 0    26647    flagged_restrooms 
   TABLE DATA           �   COPY public.flagged_restrooms (id, restroom_id, user_id, api_id, name, address, public, accessible, changing_table, unisex, is_single_stall, menstrual_products, is_permanently_closed, other_comment, created_at, updated_at, resolved) FROM stdin;
    public          rileyalexis    false    233   Uu                 0    25559    opening_hours 
   TABLE DATA             COPY public.opening_hours (id, place_id, weekday_text, day_0_open, day_0_close, day_1_open, day_1_close, day_2_open, day_2_close, day_3_open, day_3_close, day_4_open, day_4_close, day_5_open, day_5_close, day_6_open, day_6_close, updated_at, restroom_id) FROM stdin;
    public          rileyalexis    false    226   ru                 0    25540    restroom_votes 
   TABLE DATA           m   COPY public.restroom_votes (id, user_id, restroom_id, upvote, downvote, inserted_at, updated_at) FROM stdin;
    public          rileyalexis    false    224   '�                 0    25478 	   restrooms 
   TABLE DATA              COPY public.restrooms (id, api_id, name, street, city, state, accessible, unisex, directions, latitude, longitude, created_at, updated_at, country, changing_table, is_removed, is_single_stall, is_multi_stall, is_flagged, place_id, is_approved) FROM stdin;
    public          rileyalexis    false    218   n�       )          0    25901    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          rileyalexis    false    228   'p      
          0    25465    user 
   TABLE DATA           �   COPY public."user" (id, username, password, is_admin, is_removed, inserted_at, updated_at, reset_password_token, reset_password_expires) FROM stdin;
    public          rileyalexis    false    216   Dp      +           0    0    bookmarks_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.bookmarks_id_seq', 1, false);
          public          rileyalexis    false    236            ,           0    0    comment_votes_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.comment_votes_id_seq', 1, false);
          public          rileyalexis    false    221            -           0    0    comments_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.comments_id_seq', 1, true);
          public          rileyalexis    false    219            .           0    0    contact_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.contact_id_seq', 1, false);
          public          rileyalexis    false    234            /           0    0    flagged_restrooms_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.flagged_restrooms_id_seq', 1, false);
          public          rileyalexis    false    232            0           0    0    opening_hours_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.opening_hours_id_seq', 466, true);
          public          rileyalexis    false    225            1           0    0    restroom_votes_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.restroom_votes_id_seq', 2, true);
          public          rileyalexis    false    223            2           0    0    restrooms_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.restrooms_id_seq', 771, true);
          public          rileyalexis    false    217            3           0    0    user_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.user_id_seq', 9, true);
          public          rileyalexis    false    215            e           2606    26691    bookmarks bookmarks_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.bookmarks DROP CONSTRAINT bookmarks_pkey;
       public            rileyalexis    false    237            Y           2606    25528     comment_votes comment_votes_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.comment_votes DROP CONSTRAINT comment_votes_pkey;
       public            rileyalexis    false    222            W           2606    25507    comments comments_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public            rileyalexis    false    220            c           2606    26678    contact contact_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.contact DROP CONSTRAINT contact_pkey;
       public            rileyalexis    false    235            a           2606    26657 (   flagged_restrooms flagged_restrooms_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.flagged_restrooms
    ADD CONSTRAINT flagged_restrooms_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.flagged_restrooms DROP CONSTRAINT flagged_restrooms_pkey;
       public            rileyalexis    false    233            ]           2606    25567     opening_hours opening_hours_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.opening_hours DROP CONSTRAINT opening_hours_pkey;
       public            rileyalexis    false    226            [           2606    25547 "   restroom_votes restroom_votes_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.restroom_votes DROP CONSTRAINT restroom_votes_pkey;
       public            rileyalexis    false    224            U           2606    25494    restrooms restrooms_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.restrooms
    ADD CONSTRAINT restrooms_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.restrooms DROP CONSTRAINT restrooms_pkey;
       public            rileyalexis    false    218            Q           2606    25474    user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_pkey;
       public            rileyalexis    false    216            S           2606    25476    user user_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_username_key;
       public            rileyalexis    false    216            t           2620    25575 +   comments trigger_update_updated_at_comments    TRIGGER     �   CREATE TRIGGER trigger_update_updated_at_comments AFTER INSERT ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();
 D   DROP TRIGGER trigger_update_updated_at_comments ON public.comments;
       public          rileyalexis    false    239    220            u           2620    25576 7   restroom_votes trigger_update_updated_at_restroom_votes    TRIGGER     �   CREATE TRIGGER trigger_update_updated_at_restroom_votes AFTER INSERT ON public.restroom_votes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();
 P   DROP TRIGGER trigger_update_updated_at_restroom_votes ON public.restroom_votes;
       public          rileyalexis    false    224    239            s           2620    25574 -   restrooms trigger_update_updated_at_restrooms    TRIGGER     �   CREATE TRIGGER trigger_update_updated_at_restrooms AFTER UPDATE ON public.restrooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();
 F   DROP TRIGGER trigger_update_updated_at_restrooms ON public.restrooms;
       public          rileyalexis    false    218    239            q           2606    26697 $   bookmarks bookmarks_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.bookmarks DROP CONSTRAINT bookmarks_restroom_id_fkey;
       public          rileyalexis    false    237    4437    218            r           2606    26692     bookmarks bookmarks_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.bookmarks DROP CONSTRAINT bookmarks_user_id_fkey;
       public          rileyalexis    false    4433    216    237            h           2606    25534 +   comment_votes comment_votes_comment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.comment_votes DROP CONSTRAINT comment_votes_comment_id_fkey;
       public          rileyalexis    false    222    220    4439            i           2606    25529 (   comment_votes comment_votes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.comment_votes DROP CONSTRAINT comment_votes_user_id_fkey;
       public          rileyalexis    false    4433    222    216            f           2606    25508 "   comments comments_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_restroom_id_fkey;
       public          rileyalexis    false    4437    220    218            g           2606    25513    comments comments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_user_id_fkey;
       public          rileyalexis    false    216    4433    220            p           2606    26679    contact contact_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.contact DROP CONSTRAINT contact_user_id_fkey;
       public          rileyalexis    false    235    216    4433            n           2606    26658 4   flagged_restrooms flagged_restrooms_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.flagged_restrooms
    ADD CONSTRAINT flagged_restrooms_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.flagged_restrooms DROP CONSTRAINT flagged_restrooms_restroom_id_fkey;
       public          rileyalexis    false    233    218    4437            o           2606    26663 0   flagged_restrooms flagged_restrooms_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.flagged_restrooms
    ADD CONSTRAINT flagged_restrooms_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.flagged_restrooms DROP CONSTRAINT flagged_restrooms_user_id_fkey;
       public          rileyalexis    false    4433    216    233            l           2606    25568 )   opening_hours opening_hours_place_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.opening_hours DROP CONSTRAINT opening_hours_place_id_fkey;
       public          rileyalexis    false    4437    218    226            m           2606    25581 ,   opening_hours opening_hours_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.opening_hours DROP CONSTRAINT opening_hours_restroom_id_fkey;
       public          rileyalexis    false    4437    226    218            j           2606    25553 .   restroom_votes restroom_votes_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.restroom_votes DROP CONSTRAINT restroom_votes_restroom_id_fkey;
       public          rileyalexis    false    218    4437    224            k           2606    25548 *   restroom_votes restroom_votes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.restroom_votes DROP CONSTRAINT restroom_votes_user_id_fkey;
       public          rileyalexis    false    224    216    4433                  x������ � �         6   x�3��4�45�4202�5��54W04�2��26г44416�50�/����� �pE         <   x�3��t�4�4��LB##]K]CsC#+S3+=K#s]S��\1z\\\ �no            x������ � �            x������ � �            x��}ˎ%Irݺ�+�Ȁ���n"��l� " � �Zh7[��!�����{�͏{�{3+oVp�]�Y'�*O�5������_~�ӿ��_�������?��?�����?���L_��w!������?��o�������_�����˿v���������@���_?����_��ߤ�7��E<�?��JJ(�"�����we7f�VJK_���Aa���I�k��
d�j��Y�����Q`��߈�D�ʤ���!-��1���&&à�Lx�fz!j�1~�B4��lC�J9��h�����>&�ٶ��J�Dv&���;�ޠ �ۧ�7�:��J����y��]Nj�D��MK��g��R'���>�Kz�BԆ>���>�郠N�|�&ҿz�:}^i'�)��n����t���F?Q�S��J��D��M�TZ�C��ri�xS���Τ�W���W����Uͳ���j�oBv�y��[����	3���3ߞ�Po�ķ���잏��O0n�1�-��:��rF�h�SX�jwy�1BOw����y@r�[���P۲����q�g�^Q̀q?�?+Y9���z+�i��RQ(7�n��15[�7��	�bVZ����=@�jVU1u~�b�A�&3]��`g��JU�қ|�T���|�K+F�V�~�;Ϩ����v�Q�������?W����rfW�I���k�z���|K�R���f�A�˜Op��r���J���cϩ�PB��I:�;ǉ�԰ǵ��!S��6� hʟ���'�Y.���ѯ��fr[udhп�nv�6.�ط����w���?5�?%ROLܚ1D�dRS;���2�K�(c5���c��°͟2����	g��(��n����GdԬ�>5�/�~
 \��.����rtHq�5�Ic;(��4G1D�3�a�3�ҋa�3m�g�������턕2�7��_�r�[�s�a��r��9Ǩ����b(��ܠ����c��4>�o�����a���ܛ�8g�ݨU���qP�>̯;�n�����bP�aKr!Rö!��8`��i���z��w[\,7�tfߏ*J�&GʪA�\�sxWr�?�j���0���}����_QS�Yt��c�y+픗�zP;W��,�������a3�����G�D�m��*{#6*|+��\M��f��.'�K�ҥ[!�0��5B(�c���!��F���SG�M�w�3�X'pDA��pV�	��@dp�����Ĭ��ɗvv�3��. 
2��. ��,����Vnc��.�}�(���c>������z�'5f�]��~����1xr��޹���h�����y=�i�끰��@�Ճ�O��>����ȳ���z�iPc�Q�ɺ�b�8�8�5�".6�-¸z-ǆ�%*tN=,Q��HҙI=z��nK�m^a�8��>�r3JgL�]3�X��3O���d�8�9�(����$�A��$>xylA�H�'ۡ�q'����Rauo��?fVz��I�cT&y?h\r�ڃ�� :w�����1��Y5ٰ>�Qp�	����9�{��G/��eB�n�F%����Q�#3�z0��oL'�ߜ݆�[�V�WE�I�`�ȸݼv�j���8;��4z����t�X����dcE�	����r[=z���.��v�A��m��gO�Ne&� �'��.��=v�2ۥ���6�2�[�eu����t���r����f)����}%�VzU��}�q����?�GzSj��3���]���r�B��4'��n����\�daw�oO���A���+n�.�g��9O-El#�t'�z�zD�s��|+K1؝�����+��Ӟ����A�7�T�|�%���,p�/dјiB���&��X=
].��R�0�C�^:���]�=m��5J@W��)=�#T��D�ҚB����鋴��WZ�����7��}������,�O�����j�`_f�qla���q��
B���(��wÞEC6��e*�`��1��܌�*�����=��BATcJC-��)QW?��O�"]�m&P�����0fd�֘��@킵��Qzp���hNFgT���w9�`>�#�aպ����p�����v�ɏ2�����"U�G@��Di/M�4�*�r�/C�f�<U��<�/CT �t`'w9�&jW��$���T�W�f��^f�|s6�,�i�=Y���ҙ�0�(E�V9��]��*qY>�}Yl��@_��k��}Ybw�� �c�4�IϾ����)��0β�A*!�x��!sƖ;L�R�=b�S�0�M�D�$�u�U�D'�4�D7x�H�I�I�2���~�;��-G���g}ր��pzF��h���?�/ǖ���v�z��}��}��j�B�}!��VfkS������6N�U8HV@���9R���%�%7a��[�֏#�f���0����,�Fp
�~4���\��_�L��(r	�4j��f�����3yY�o���[�a�HW!��0�^��	zK�`��1�72;n���g�cΦ��Xr��rU�Y���ۇ>��(�D���LZmFD��ʖ�$C��媮_�>c����!f?��b@�.Æ��ɰX=ȳ}����� L��j�C�7��ԣ4���M@w����TcF��L��������!4��5�L,j���zbQ,���`;H�7e ��v��I7�O���*����.Ѻ�9O�ь�K'HV��	�H����hi�c�nO:+��v�%��1E�&�D���D)��������K��L���j��x�(uT��ѩ!��kW	���6p���ט����*+�h��ss��b�W�yF:��GO^O��;?ĝ�s+�V�V�9c���N�UQP_��V��㻭/��z��/������t��N�%�k��4K�G�C���9�毀T������:%��#�QH�K�[pC��My�QF��nt�P겾�Ϩ��-�w��y�
�Q�(8���CX}��WV��+��]��)������7��K�0�^�a�WW��B�������Ѻpy]8�Gi�+��(���q�B�_]
m㨴�o�xs�9�IVH6�%��M��oC̫�eL���T�q�Z����^��v���d��8�s1Y3�&�s��օ��X�d��mF�i&��J�=�"5�&�3��#ُ�5I	9��u�9ī�s%<�&���p��*ލZM����ʝc� )��]=m��5�@��[�)�����t�������:3�G���Ӂ�����a}�νJST���{{�{�x��'�R��5|�k0�4����LL���z��yZY��(�$�S��5|�k���"/�U2]��~?�-��(C�!ܯ�g���6�K�����~�b�(�kp�T�~���(9h��@n�j�t�Y�C�l[$����,�s֐�����3�Sr��kj���a�g���c6_J�߫��h`�� �Tzkja���R�B;r�2����5>W���pMcE�` �j����^׸U5bQOH�kPQZ�#*i�Va��>�5H�4(_�O��p�/M>⿊�E�jO��ql39�IN
ي�-�ja�wJI͋���j��D��N~����&\9iQ���A�9!l�h�������OH��	����VD�߇�A`v��]@=�Gf�B!��v�v����V:��F�ݛU<cX��l=�����q2���/O�A���׳u�����M�=Aw��A���s�r<�l(���dbV{�MmR��0g���D�I��6���$V`�����6F)s�Ð�Ս�S7�O3�)���ĸ��P��(�y!�2�׷��Zُ�	[r�|r�(��͸�C���I֌�:�V�������wΌ�J�(�G"�Q�{�4���R|d�����|ܮ��7U�>&�WԼ>������f����R�Ƌ�0��|rm�8<����7 ��q�;���\����Lf����a���r%FR>���.�Ƃ,�	� �l2�}V��:&y�N�LiC�(�#    έ��6݈��-��o��nye�7���r���Lfk�l��E��qbV��z�����*���-���Ǡ��Ġ����Ӓ]3�0w�ϐ�\IW��:as�h����iҗ9���
;iTl��rtћ���+5��(��yQ�Jqv+r߼r�x߹i��U��OY��Bf���G�i�S2�MSz��蒳s�(�;Θ���aj�3i�ӞZ���ͪ�2l{'E�k̠�Ҥ�y_*�]��l���,�P�y6$U�]ً��E���]��2_:gN�h�)�\�O*��L�>vq%�"
���Gp�j���$��H�gIBz򚌿vڪ�/~�ڣ�ֳ�I��_`M(,'��s�*�z�rQ$�_AU���s ��6�U��eՖ�bY-G�3dM�@�wDo�V�1c�1�:�P�8P �8����?�r�S�K�ёZ���ʶ�3o�_D}H����j��-�Z�vS�2�5i"[�y$�U�zn9����`��:
��@=�Z�9t��ıw8�KF���\ W��_Օ�ԙD�wsE ;ڶ�����s�`.��#�ղ8�I�~�W9����*2!m#1���!
&��X;��c���O�iL81���˳U�D��	�`�}�.�5W��x�o�?��h�/�h2�vn$\�28o
��fo�ֹ�q�R[Of�Luט�s3�4�Dw�O#1�a�ñ��O��.]���I�ؚ6�m�8�U[?�n��J��pLE���a�Y���hjE�.Yg�Y���%�Nm���T�"FS*[�"J/o�{�8�t�q!��&�].�J���4ӧ���]��u$�R�M����o��oش��=ۛ�����:��c�PʜZ�*y�������έ��������b���朄3ɚL�b¥A��k�?̱�iCTf�\�yI�c��KL���ܕ �X&�-�iĪk8���Q�8fm5���K��lQ�l�[H���+�ϩN�#]lD�7��Do`8�}�Dop �h\=��~�}=�>sI�Zl�4��^��]=	�Wk�z&f��d�ffI������nfcPRfb��beT�Dنp�]�1zM���O��!3�}���6�>@ت���V�(�F�|xΌ�Q	k�2c-%1�h�㬵/�ʎaW
�Ό��)�r5��I�46�s!M��Z�iBX]k�!M�NfXC���+���.p�Kg�e��N����a����8�!�n�)���P=g\���T��~Ό�1�y�N��|#xk�'����"/Պ<y� 7Ѓ����O���0�F
�8h$��|�Z�gi�e7����WQ�3���9� ��Y ��M��(no�z�%t�֛IS��Λ�J_�P:�Z�0EӚ��<ܻ��e3�Vo.Gx�\�J,}����FZ��c�gUѤ����>�#�/��3�W7�ʸɳ�!d�=1��#[h�9>v�B��|��N�CrvzJ�^�j�0U�;s��N�#��N 7����j����9��Q�d�2l��|Ǹ�ҋl�iM�7���wф�/R�Lw3���o�0"�����E��"��i��E�_��s1�z�.�k����8�U^��u�H)�����J
��t� �3���y�X7Q⨣����@��B��FT&-��Q\�vm��@�9\�q����KN@�AFѠ���0L=�'���Y�؉�YW��Z�Bi�ׅ�4�6�@w/���TUW���T!��r~~��?�S�㚤vG/]�!��i�gl5y�uH�>pq���C(Wwn6]�r�ݞ����Q)��g�f��&O֩(\X�;� �j8�1�^T�?�纘��qg�*N�w>�a?o��mYbF#2��|��j�M^*s;�*mF��W�TV�OIS@����,교%vh�-�n�?�y�w��M#[����,ꝳ��(�&��[�1�/�4��5�;��\'�W�~�T��^��.'�f��k4+�U�r��K�Z��x�&��k���t+��W ��s�d�m$���o���=-�w�`�؁tBK�Յ�`�F�͚/^��R(�����tZ��k��ĵ�\s�� ׬j��:׏O��u.�cq7o�|��j�#a?�)y�-�8��"����umw;�!|�ԏZ��'�k!�_8�aUSb�|-���ܛ�:3F%b)��m��r��/���e��W��,��٠��'������{��^~����P�љ�C:���9`s�����8�\���I��:���r<Ե�H��Y���Ӗ	D0^��u��U�*�zz��;��̃��x�ٍ�䳦�+@
����s1qb<�T�Dx��A6�r�����q��ΉR9�(J�5(���W�|}߽�8���{VY����@W�ܹDg�}�L�`\���M��jhn�_vvz+p�{�L�!���7�">J��`��F�M�k�W��ƫr�ߨ㼉�*
%��H�9��l�p�|y�����BW]���9�}3n�l��]��s���H��E�w��(�ם�K��g���0_
���;�{ {n�n���"\�_��N:��G�)!�H���g�nr/������\2��Α|�D�9�7�P�}�ф�\֩��fs�D��N�ֵ���R�M��Z���r��S�j�h\0���t8w.�=�_�:m��=��վ�醠��\�3�=B�r��Q�5�:�/����Ro�Mgl�%�� EN�O~D�Y��	3
���n^$�W�̣�Yz��l��X�,��a��{àV�Z�ϛe�JB�ҙM�V׹�#�1�8�x����:�*_z0���P�db2M�6'����~F�<u�E~�����y�(2�}by�S7�פVَ^��QF$��1?�KG1�/�F4ΰ�~e����N�^N���m�5nt:h�-2��}�b��"�'��U!�9�w��n���!|B��&_���e�gQ�ݿe���vYT��M��,* m����,j��.g�qW����}��/��1���]�&�"��X;pZ5��mЭI��v<�dĲN�ɟ3�,;���TV�7pi�	�֐6�F�$#P�[�|�f	^�<`�H��t+��;�0|�����<;������u�}b^t���q�)�Fj��ݧ{w�fX��t[1��L�m$Y�1����	P��L�����y�
�ܘ�`2�����dv��/z������Q��܏��ZN�r;���k���뷌Jwbc��]��*Z$N��*װE��i��a��@��|�,�M�;P�oȢ��۬���u�̿�$?��+7��EQP�� ���1{	bX5��f�8��ew%X�H}����\�������"HS\�"vTdS��Q�8�-¶-C�"�'�Z�tA�=w��Jg�ӌ`G��7]��eJ�
��
܏^:���ש|�0Z��Aq��+l��@�
!i��,k�d�+zL���V��/e492fg��}q��h���j:��0*m���@�nΈg�:�A����qu�����Uy�����1�#�Xr8������e���,g$�ZY�`�a��e�G�9S��X@�Xg��Ҧ���g�N�X��Ț�;��Z�P]Elh�?e��
�T��]�uLU���fC��C����� �hb>͆\���r�a����8�*˪�G��l��2��1�#�)2�tcږ����̱/h*nLu�7��`�!y�_�R�r��$��X)�|��g��ko�c"����K>�qH�0��%nݘ��U��ߖ�����	�¶E�cɫhe>�VK���We)D��`{c�߶x$ȯɒy%�g��ϑ�C����C��\@�`	#ꛧ���5]/9Ub�ߘ�x�m��n��O�&�,6V��D㎟�����SO�����..��4��(&/:~mU.ʘ��n��F�H�����Q��6�+6�t�S�F���-1���(�a�奁�gf��O3߂i<��7�/bV;���~s�a_�� ��>�q��`3z�қ�e��%�c�I/�b�,�ܨ��Jl!
j���ꇚ-�Ű+�'!\8ƣ�f��9b|��Y���7�����'�!�så��	g�㨍4�`K�G�美O�����W��*    ��TM<;l����x>V��(����|s�3҉�FLޫj|R,��ָ�C��2�|���^��C�#�&�I�[�3�o��rig�c �Nz�&��̝�I��V83�GG�[�5���
3~��$p��D��%Ms��.���'O�8�)vz���.oƟf\[?G��\W�Գ��N�'jO;�����s(*��d����p^�˙��q��*UGi��w�q�Ÿ�d��1�{���.�1^M�O�)sEX��c<�g�b����k�.Yi�5�yl�I�\�k�z:���ʸvo-\w�K`bY;c�@�ƶ���Sǈa�q��%�QʈQ�q�*TE=� Pm���B��	qPA\LG�qD�Cj��#BR"L�+r�IG,�܆pf֓wo���I���$�$$1he6��Dr�Ck{��.�����^Mo�o���&⅃	j�7*�v*=m�2 lU�z����|��3FA_ӓa��p�wr��K�;��f�Ֆ��6M�;�p7�S5@mG�*j~C�K��W�.E�W$P8��%SAK��Uįk(gv��5�l��ڬ8��WLlq�*���"���O�����k"�n.�4�K�3��H�
��x.[Q�v6Wau�_Y���ɖwE�T>dƣ3���i0dh�r�=����lx��}�lxD�.��΄�Qz'�  ��EF�g�'�
Q;ƻ��2�P喈��u��%�+�"3�)��'OXA^b�u�ET�x�J�A��3�|�x����/������?[4L�Z1J�t�MoӘ�x�,�*#�6C���H,�
�L���Ʀ1���rF�CT#��(q���]g�����鞀���R�c̦)�Ѷ|nd��z�A��e���2�u��ˈ�/;��̹��:Wu�42:|��Z����M�@�����;�q��1���,Цi���82��f�j�Qj[�K���8~�E9h1Nk�a�P��\w�
���n��\�DAW��[���+Y�[@�UW��[xL83�G��J,�CY�K�>XP�`	z�&X`k���p���>�|O*I�ˆm�:��� �v	�Hb�řoOHg�ͨ�evw�"��#�x�|ZO5"��1 ���&�ZL�져�Uq٬ó [�؊���*Ol�.Hfq����'��uƸz(c3Ci�\�r�Ӱ�0���q�E��fU *e�'�S0w��,��y M����[2�i` �Ψ�d�-�uf=��f�l�N����d�(h���F�kl��]I;>&p�+C^au���,�Ϫ��j�8�Ѭ�;����<� ����\M<6�o+<�m�ô%�ڭ�� qt�tv*�#�[�_{��宺��#�9�z>竕�!m6��t3�QG����ٯY��_��� �^�)��!E�c����Vy#����NO��@:�x�Io@~�s�����8��9J�t�
`q�1����yʵ��rE��}��\9qf�5��j:ƹr�� �⚎�pKǖ5d_K�}�^>�*�p��A�@��������w=SyY�xʖ�%c�w���#-�^ϓ~����吵Jk�]�J�Un�*��8?�`���� �|�LS�h� f@�%�cܘg����m�]G��k�!����D�q������\PJ��5�m�V��6��U[�̭N	W��l2�w�ݾ�L���o;_��p���Ǘ2a���� S^���)dJV��~iT�Y7#�'�Xo�r�������q�����n
�Ř�K��Nz�m�s[�6γ2�CP0�5"yKA���-�[mZ�s���F^83hG��9nm#1����B��V2{mAX�F��95�P�S��.X�wI�l(�EPy?
]QT�ǰk#�ru�U��<F�TV�N�q�}�Ɗ�m^�X!�qEO-�>�������x�Ϡ�)�ܽ�Ļ�)a�*!�q��:;�J�Î�޴�A��'mS���\A՚d{s�*��H�ŖJ��؊�p��a-�EC6N��l� �Z�9�1副H�/��V���ZO��n%2����
yK��d_��<ۻc��L|�t��}OF�V8��/C�r�O�ov� ��)�<���u�x�Ly�Ĭ�����b���d-!
���)�]����%��&6k��0z��3�d��:�$��w)�����Ke�2-7�FI��#��h{epR���de�n�s1u[}����Y�>#q[��N�'�[;�%��(�;���Z����j��PLbfu�+,�ub\��љΦ^H�F�7�Ͷ������e"0Z���41���o\�Y��Ґ���E+��-B�)Z��ߗ��$��Qb>���Mc&�؅(��aS�VO�"V��k�w*��E_Ό�Qx+K=Db��o�]��#o�� ���B�3#o (�tv��.�VZi������	�`��LM���+̒�m������>6e��6p���ڽ�v��ZF�ݷ�v�}G.ǥ�*�E$�4&=W���v�� ��ѽ\�����1�ʈ��dc{��.��sߖ�nE�8~Y_�;�K��$�C�Ҍ��y�L$��҃=E��Kv�Bؚ�*}��I�\�c�e��{��
�����S�u�.X����v�Nta0�S�0���=�@<��;��G�b���D��Z����0�|/"�}���d[:;����N��?�m�U3z��Z��:7�;Aw�m͊��-�^Y���Nx�_5���*0�mW��k����%1�%ץ3�)�J�u�_�om��=�/D5�3�C��P���x�6�f�_��(��MTy:��t��C+�Oqð*�n���)n�pb\�1m�Q�'s��[o��5����d��͚����:m�8�K��Q��,J�"z��m"�4���@���ܭP�V�W��N6��e�v��D#�TU��Z�3�i����l�F�����/�5x�}���TR����Y��+5�e��SɁ9V������1��p��x��`��!��S��W!��M�6�]&���<Ǘws�ڢ3�
ｫE0,��i���50J�B��ˡ&��5���c�^H�O����f�ќ��dUO�`X5��:���	ȡ���q�J/�K#N�~�����l��B:�R�������*��������,Ň�3�f�.�?�2�Hr^5D����d���� S�jM��i���C��/��C�ގB�\��"�� ��5 �5���@ɝMhB$6�Q��	{E �Kw��*G�ҰY�jJ�BH��:D¸��s��q���r_��L�&����J?~���3�%�>vnĘ9���rS&�/bK��4?>����{ۘsU��*��8MV�o�����~Td��.�7�����64^[�POX��^��7AƘOpv�	Cf������b X�X	�4�`�&p�(�g��k�V���ᤁ�^7�~��u�kh<E�*��'X��Tb���R�ZTk��+C��}O�9�������W���Uv���38"q��ڢQr�U�u"1�V��q��*��� ㍜_��IZ�:��U4y$�K2}ci��-pfM������w�PO�j1
�E(�4��p���-�$���L����>���y��K�b�4o����k.�����q��i�B7�la��������~�<p���2P����
g�eR.��L:j��.h���Y��v�&z�������+wo�_��&�
e�K^�j�gޮC��>��ѓ�q��q�,>pt��dOlg��j���7p�{q%��g�#�h�KJ%M�������\S71NWc̻��#0�҇���&8;��	~}�tv��l*wH5}�G�̻]��SJ����V[e au���68�%�6	����.�u�u*��6�=si2oxo��(z�F�o�#/>�L��ڊ�?�]K+.�l>8��F��|;��熏(9͌a�[�jf���j��j Ԕ��Ҧ���A�q�g�\6y}cm%<�S榱%�UI5%�`��E;"�1�.�z���N�Һ�<1���-��BA����KB<���L��>�5DgLސ�������0�!�jGI|��u���M�Gҭ��yF� �  KӸ�{�^������M��}{AW�f�T���6�..Pc��`���'_(�|��]��w�F��,�i$xu���������Ɛך3@ihx�w4�C��n$ g׻�D+�I�u�vv&���];�������T�{��X#{�h~|���Je��u-A�kP���@C�cJ�l���Ʉzz��r�zT��<H�T�u���ʿ��T������u�_G�W��˸Þ뉯��$�Ù�0Jl�F|���ο=�1�1�(���!a�-<��˦ڟ���j�0j+�`�Aw3x�A��9Xb�1\U�n:�
�ۧ�y��Еҩ�� ���ǒ��n���<1�seZ[H�l�y�<0G�,-�!F
xcw-gs��x�rj���g��cPK�r�+Db��Z�n�j4mvq��$c`]d3��/�x.s?8ʭ�ԃEr�dk,��n�g'56p�7��%�eo�(�HΔ�9S��
$Qx����g�S�IY.���zp>+l�Av_?1k�(���ڊ�&I��O6 �a����/W7@�|,���y_�t���Y��iX"�z]}E���oB�޽6�W���Q���n����.�E�zW΋jՍ���6��Ɇ�v'7�Kn��ZWR�|:���JM!
�����څ>�g]�I� ClKS?͍�"h���<���K����"/*�3j��2T6�ǣcj8�� �aa=���=��;#UP*����&>����Ac�͙/�9Q���7�'ݜ�!W�lxw\�1D�A���,�	7��*ˇ�Lը��qe���S���x�o��Ɖ:;�^A2v�Θr��t͵�Bo�_ɿ��6��{I^��X�Y���.��8��8_����B]��h�Mmf�n�p�8g�Çx0����� ���u�!�x�O�����S1PP��حZ�=e�j���,x��*�4�?��v��M������Y�
�'#]�l�+�Auk��;@n?z2(Ӥ7�	6xE��~����¨�����T����������J�����fܙ�uȌ����D���*FK��Z�̄.��b��6p�y�rI^U��3mqQ��m�?���}�s_�ύ��6���=��,�V�έ�IEO�\vM* ]\+F2�
_�&����<�ɫ@�7Ơ~Gƻ����H�^NsyE��i伕�K���#��uM�i9=o6�Sv����Un�q��|)VX/N�i$j�y��d������=�q�̿��֗�O6�i�|g����]������.^�4p?�?�oK��1�#�y�#��,cn�?����Յx2l�]��)׬ɜt�(�d�4�'n�5DA����V'�����>����P)� ���fUm1��v�5wI� /^�,w >砪6潹�r�9F�SfaJ4�Y�u�ټ2�E�6fvrm5l[��l�3|�L�y�䒬�j��}��=���=�{��#�T ����C��m�M�a��ªĸ%�"���li��$9-�aؓd��ͬ/�W�F��3�!S.����X��a�3�v4�����ζ�`7�U*m�ªL�$*[SJn*�TzeɛX����|�ʨ�-!}Kf���Y�f�U�f�&��Nb1��;�n�"�b[KĿ�Z�b��}�:�҈�e�,Ǿ�����&۬����o�~�.�?�r/����������G'bi�qd���x�&�Q0����Ճ́�ٓ�x ʱ�tf8�C���8�l���P�C�*$L��L�0�\�� �l��ꌳ�����0���?�(;���3�ؒ#[��$�a]$?��v�%��Ml	��� ]��+��?)�=
/��֠Ġ����'�Ӟ�� �o,k��D�H?�, ��g���-p�x���{�&UpI�8wN���{I��]x����e5~��lK��4ۿC��r�b$-u���ß�a�?�t��         7   x�}�A  ����0p����9l�~7���(�L���<٧�8�V�o�5y�Dm            x�ԽYr�L�.��^̪����I�b�&QEI��Iem&I��8�� Ow��^G�W� 23�N�{oV�+3=>��Ԑ��ʨ����7���7�iϼZ��Լ��y`P�b�Y�z�ܼ���Gw�}��gT����U!.-�s˸p�%��MF�sA�'&U?��I�Kɭ"sI�dHj5�~�o������%-aw�w��Y�}�3(g���y��7s`�_z&3*�l셿��O^R"��	�����᯼�ܤ�'�?��t�2xLr.	�>�TveZ)\�u'{o\���g�_����N�5����ޤ�(�S��E+��|,\��Hѿ��°�p{4
o�w���nWž�..�o7�ʶ8(n��C�.}��y��F�;{�Yn�q7��w�?.���ѷqT��S%%�/`_P�qۤp:���K���X�H�����a���b�h�+�-���V��_C��1ap�2Kw�YuGӠ����M�~wt(K�0ٔK�l-M�����"�)�:?����K�ф�|���B����ɚt�n�m��w�7�����/��\l�|=�:F�eE�[ן���6�F=Xd�!�6�Ë�ѯ �.�BQg�O�/	��+8E��}���~e���]1\�:�
��-�K�A.��b�w���FwcC
i>�����fs���臐�~r� �]K�0��P�~�'�~RqI�up�YR�g�o�-��n�N[%^[tj�gf�<re�]��~07����3+�t깳`�/�o#&��C}�#M;�bR���q�Z�;0uA�I������؉�6� �
}�S0��V����]��#|?���������*ʍ;��}o�������0�d�4K����r=]y��U��Wo�|�.mf���lz6b�^PjRxy�Ob]*;�4���G�Y���&7$W��+�b	���� {�k0����],̦����
^�5�ݞ�"5^���YͷG7̸�rwũ�BN�1�ʟT89���dHw22jwCZ\8F�9,�WC�a>!��|� �����`�y��k+*,�u
�ޒ�5����������D�<�K�۸���"�{������Z�;�܉�3��1Q������f.�xu�;wy���Q�f��b���0md,P]���"V3$[�Y]�Y��.0���մ���^o��x�0$����K�Q�����qL��`L��b܉�7|[rAdM���]RGD��)��mP�ұ�*�>u�Lf�t��!f�#�͗p��+��X^���j|h��0+d�(BD�>��S�N��L\2�W�y�,{��6!ʸ������k!��/A1���P㘏S�
���a>���`��0+USJ!l#����s��}t!��U��:�����V=��|R�m~����y\���;��gox5]xc������y��y(��\���v-����N�`�7v�כK�2J	\#�j���}�hL|���o�0C-�E
��"m�������%�u�	ʁ��BAg��`��W�黪 c�`1_/M[5�PO?�0;z(���H�1|��P�50x�`"�*[����u��gL��H�Ϟ�f�a5�.�2	hf�CZy�T�;�q��F՟��C��u����6���|�?���{�?kb�B��ʵ��a�ZZ�`=h��	�#3��$Zn��	��SN�kw>��N5�!��f����{`_�۹;�z����r����?{h��v����;"z�:^ e@Y{e�O�aZ�lÍ�~��^�_��A5P��\8C���/�yK>:�}sЗ,��!���J�ZgH9�Y��m��jJP�r��������	9�)���Q}5����ΤP�̐ةK���Y�G_ͻ�)�@�^�;� x���ٛN�D*%��HN��$LE;"��B$�ر�%%&�ȗ ?L��\�A��=�A[/�9�?���l<����cV�)���T�8��,"�Gww�]^�);��R�g�r��d�p�<�w�E�(ޑ�":rV�b ���g]:rS�)��'��C2V�z5�z�A���hr�u�j�0�9P��D����r��H��	�˨�-�p�8��*�sPw�
�i0P�fk�{���l��R}�Tq��*��?BV�S� �����rXdw����n�Vc�WX�0-!�����D��~ӧo�t>�)$�<2�4v��OB��U{k�K�9��sj<�K}��;�a�� ��|��{}âP�ي���⬎�=�A�D��IR�=3aPp�U��N� ��t�Y�,;�W��@�$FQp^��6�;0vq~��}��� �j��������s�C���Gw��fSH`o��~�T #9ڼ�W[�������SP��kͣd�3f�SA�Q�yϝ:�f����+u��K�'G%:�ڈH7AS>l.)GmC�p�۹7�͊���5���7߆��Zf��x�N�}�<�F�|;2Nq)��|�ҟ������K�a�\3n�t���[C�b^ȣY-�b�:���!�G*��^��I!�������SO��-�͹���歿���?[�>�����1h	{`�M0� �HF�sV����	�+6��)�ä���f�`�s~W�n�#�0oAduF�D�t;�<���<z>��{��i��A�֎�r��c�~�lb��pNXX]�:�~T.���zQ�)o�����e�f�A��-�4J��N��JLI�:9n�]wJ��c����h�Y���z��R�.�5�<^��Cq0����[�>۵���N.�ۦ{mo��ԟ��� �1�C�
�]"B���cX��'3��)9<R�t=>Y��L�OAQm�_s.�@!?˛��զ|[]��n��������گ��pG/�w6$��z�l�A���Tn�n_��FyS�U��o}t�vF0e���E�l�lX�+��ƻm��t������5(��u��[�1l�w�f��l6~D�C�9��!���D9"ֻ�v�NBL*�^%��鳻����Ew�,�ԉ��)9�]�
��dh]Idh�ޯc߳��b�{ *��_�[�Ae1,W�w��\|_t��-�Tv�+�'nP���U���l�Uw�S���L��{���_6��~��1�+c�����0�?]jO,�܀��l5��o3�����O���aa!�'L8Rto�%�?�B��Vq�p�tTEjo�7�m�X��ͨ��n���-��N!-����=�Am��}���E�O����hFb�������Ƈ�������}�u.��څ ʸs'c��R��f��F��0<�b�J�B�S.�Q`�R�R�Nj��R'�q�D�$9i$���fY�?:���N�"J����Xr�{\@��>.@��(�yăU��!	!��nّ��ba�[a�(��arI�S!�t�.K90yE�����bkPc�L�\��{i���ܼ�~���x7�H�Q|�c�WϷ�b��Fx���Ϳ��-�ey]z��岥���0�@q�ܭ��������w��la������^�Q:�ؑ�bI����\���FK{,9�#�_o*��M���zw�AkRT�#P+��{�e��*G����FrE�*��+Z}��xm?�Z���}�!-.FN�j����������/K�n���um�,Â��	�Q� �� �Y$ٖ��|s�C[�H��(�"Y�����Ԋ�S:�_�}n��$���7S�n���Tb-����r��yjv)(����x�����Z��JC��A����ނ��=�:�wV��N�sи�)�ꮅ�`�t�m<���}�w;�:C�m��A�j8Y!"$~>�&q�V]��`iX�T�6�t|�rs��8C�1���q�X�����P��ӗ��H=��V��/�&Wo�5�w�1(ɡg��J�"|@Ӧ��%�:y�Z؍�]��=�j%z���6 L�����f\��^q� (��)��0@�̆��DA`Zu��*����c�Z�0Aqr����a������/6����u��Zz��J/[p��_�W����^{�]\'��g���G�6+�>�u�    �dؚR��]X��u1|]-�]+��÷{W�їV{3bu������S��oO����#���~{�A��B?���E`E���4�vx�Ð��=��_����;�O�Hk��M��ﱕ�·��0���W�!)'�g(��~����g��x�:+��rQ�w�.��k��,���R/�n�d�q_��4a��}0��f½��y,��O��v��\��u�Y��zV��!A��q=v�#�$�n���sF�	K�ߣL�y$K.�G�2��*<Ď
^BW�H�k͐h�GX��h�]���j ��"��O�y���;�����b�	���^������)�z��v��1ڸ��J�������8��uo����	a�Luu�N��L9Q�-l�U(�La����3��w��.�˨�V������ ���v�a�Y*�"Jd/����{��c�y�P���^��[ŧ�u��mn�__?o�2��U\n/�jt./U���Z��{���A��IJm��n")��I<"d�rR��E*��d֥���ɒ"��'��~�(X�1�����Z�Q�(o��S�����߃����<�������XU����;����c���Y,�ҩ�{�ܡ"�x�x~BV���Q�'���`���8�ĥǞJw��L�`�,�;I:r�	�������[�U�|<��Ug�2얜��VI�M��j�t�m�^�q׾���R}º���+o��Ǫ8���cO0)��Ml��0���5���a��������/"���C:��ut.Ob�W�2i�ȐlJs\C��ϫ�����ݸ.t��G�z%����˩���&�t�w�|��;x$�����p�wƛ��j*]�j���>/>�.���ż��.����mr��̯��h�6��|�������-;�B����as���O���d��0t��7ERy{��B��~���Ni3ms��_�W�����^��X���x�ԩ�m��"���������x(.�O�O;<�28�1 ��yS�θ��3w�fѕy�罓)���,ITm���j�_�.�p�C�jȹ�L����ݟ����-J���dNvS-��a��z��/�K��K,������G�/a��}�0(t�ÐF�9X�H>��{�r��n�����i���K�dQ��Y7��5�ʂ�zT��!{K�^�}�rDav����� _�1nVөy=��7L�Vf�|u�Ӆ��6qE�faG�a���J��)RF^v�'��V[�}i���oG��ŐP2�3�b��,yS�O`ObHx=ߺ��k�UG�A��o(\�e�d` �KERr�K��I��y[��l���؆�?���2�K�ņ���k�Oَ�2QQr�ui2�� ��&:C���i��f���2m_2��NHY�8ʹD��:�N���\7�5<x���0OTP��%��q�ȣ=OJ��^a�=K�i�O		��<�-rIYY��>�e~b�_�3��}.�X���8�]��@�kv.l�hrK���9�LuT7�"��"[T7�r2{[���@�qH�m������/����_�,�fZ��=���e�tN� ŵ-D̵�r����ZR杞�X�>6Dm<�.�(�H7��=�T�����q��fG�e��O�N��#ZL�*���iJ|�����ŀ�����N־����Ud�+�§��q����%�H�j��c:��h@�~L=�\R�A�'6_hK��Q�K{��	�A[�=�&����;�s% Ç�J��Ͻ_����3���wi)�#UiR����fm}�k�6���ռg�G���9�څ�l���7j�:�_��1�<���!p���+e��@�bYց�ɒrn]5����,�kg&wԲ��3�B�w��L� A���x;���%Ř�}�q��{���]��<�<�����Dֿ����S���F�w��ˇ��>Х��6g3bT�Q0������	ǍZ��	A�������ɢ�
��J��j����w�n�c�����K���x�)#K��Dg�u�>��3��	#!�U����ˣ�w��HYaF�8B��u��)^�c[iW>��e���m��mG@�2��΋ȼ�Y*���&S51�}�13W	��qg���Ly���rOR�EL�*�8��<�,=E�>�[U޻:�9m�n_���]�۶N�*ݪ;oM�g{���Z`R�:`g��n8�X���
���ıS�a6�*VZ�%��s.���u��7������Ҫo���;����J�8I`��Ք�G�r�X4���Xđ�u��	�O8�<�&�"e���_��vͼ�s/_�o�N�U("��f0���	�94U��Ps��Qkb��`»È�{Nup�Z��Hdo��yDp�y}˪�]M[��_>z����.`)�r��c�&h;�T-62JL܎�e�!;}������9*�em��t�8���	ǀNhuu�q�;����F���㴠M����~
�`��a�;&�~�4�@�aYK��:�#�+S�v�1N��(�*�t07z/���^���G�aL3������oL' ��\,W=��:�0��t
�_�L�7@�yyn�\�PR@���1x�����O:�2�d;��iĔ����������}�v�EQ�'/�착�1���ra���%�R:�i:���L�*�0;0a�8�/Pg�x���҉�D3$� xJ���=�x]�����1��G�'6�� � ���|��������L~-��^���a,�2b*L����XHp,�:qO�A����=7dm�6���x���}~[���=-����#��`���3g��?f�����!B�1s.������3G���8ft��."�'M�~Sj�nO�;jt!*���ke�Q�(��R�̙��I�˜�b�v�^�.Zߴ�����{��]:ୠ��ǘ�L���ġv�H/LO�ɪ(�$��[��fjs�����O%K�\��T\��Pԛ���Y����;�;�SH����}����0:a�ձzI���,��I���)Q���tՒi�����@�"7�k�o�R�B�����x��0`c�]���7�7&r�q��w$��;�%��|�����4��r��y�ۏ�p^mi5�~���r\�lk9q4�<a���_�5�z97#�1�G��><͵��4/�p��閤Q��)%���:Q{	�K;��w��׌�ܦt����,�8AO�VCC���B�.��x:O��bq����-���K��d6�)�_�F+X�L5�,Ur�F��RbTV��t\�M%?�[?㸀H�u��c���i��s�gIٻ~)}~��\Ѫ]�٪�sK����s�g�3\�#�qXn� gV�x<�S��oR`f�R�\w>){ݧ�y]c5�SSO؄}	88np^V:���~�'�cWz�ߕ!���	�g�����{w@ʲ_��{�ٿ/��W�������¾AʉQ�t�;���J&OĘ���,'�1y�Dd��S�؅��4�����}���0��6{m�ޟW�zSa��5���"a+�+��@rߜGc�gY�c��j�p�p n�y��~0��j�ݮ?Gs����-$3KMLAi��*?8Q듢T���燐�|�Gù����?���F����o�͓�~���P�`��/�Of�L�~އ92j�g���;���=����,�=�wZ5��	&7��x|��Ļ�������]��ا��UM'���g��l4#gƮ��W��q[�'W8�q��L���:��悌�L�F.GC�1롳������'��+�U3X�y�9&��&(�������Ś���f��}�4'p������m��vť�My�x{�o�bn��������b�����{��=1D�~�DDj�J%
�����pS�v�j搲z�L��$�/vT�-a�Z	C}��▕�*��}��xϼ	c�;�&g~&KFIZFۗp���t&���*]�ؓ�%%,�����컫+������?�f7���]��m�X�"na�/.9�[����ce�`G?CX�/h���\R��W��^��b��\y�~(~�*�rӝȶ��e#���V��0W    �Y<z^8�j�h��?E�x���qs �Z8^�?�j�Ut�@�Z�ST���57�A�[��8!�w�0�J:�{�`�k�O��F�aJY�y8��A=�G�,�dB��l�DI~~��uS���t�K���h��˦�ߥ��5a�S���Q�l
�E�Hr���ڣi������%�H��#�L'��U�2wH�4��njw����{@���*�e�h /�[*^�u�@��ۋ�~���Y[��p��W�w��f)�YT(�SL��p�`%�u�q�1){��~f(�d��zM.��q����j��v�)±��Pg����3��W�Y����+�[���CJ惾�^c�_�f(.Y�}�_�Fu!8��y��fK46h8�/�u�OU{�Ѵ�͍��Q��!4��b��A���t�=_��ڡ��z�}����@3M���<�s��x�
�Nzk;�O�0�6��Y��JRm��G9g
g��V4��Q�T�){ ���}u����xUi���k} l�E�w�L`ͻ���h��X:<j�4*A���m��X�Y\#��;E�2�V�m7p�V����M�ϛN��,	j��yϣ�$w߭z����;L?Ě�Jr=J�����g�٫�C�ȁn��v�w
u�}��<>ͯ0(H� ~{\��'�"��,�캃�W-�'�!>MJg1��1��]�D�R'����\�`�>l�f���B��w�R�V��P�%���_�~�V/��X̼�+z��qt�uIU�d6�X�������qK3.�Ō�xL<�/��?����Gh⡽����E�1X�?N3�P;r��� 	pK
�\l��ݤIa������n��y�Y��䣭9���a���òN!��w��t
�CHc��gT��0mGe� K;���M.��E؆��^����B3����9���7�	�2�r��v+P�)�C����4ה ��0�"Os��.b�
�)y!�㘿ec�8�$��'�)��4��V�6u��Շ�}��%\^�ǯ��k����hh�i��{2YM�`8"�g7L��;i���D9;�=G���ji��}��U����v�YGdN	Q��0����.�s��sI���P���B4`��RY9�������E|�&��F�(�����פ�(j��^b�y�tǈ	׬�N��E��F���/'�-�ñ�-,;7�9�1�J�������2"v�$�#�P���&e�b���7,L��+���7c��8���>������h�=�UX�����Tb�}����!��%2Σ��L��$O�O��'j�Z�.}z)^���]k2��n�e}"l����ԝ���r�-� �]JŘ7:�����4�e'��@�����U*��N9F؈yw�dIY��:�BY�{�:�V]o�6���}nRkw�Q�b������+Kx�A�j���Еz8 ��c��۬�홞>0�4�c�����?����;5��&9���=��o�m~]�me�x�<!�/�[����J����'.��F��
�(ũx<7e'M�\2��JM�,uB�:udE+͢¾����*T�`b)���v���w'.�_Ss�#���`����[�r�+.��D��&�[,��
�NI��%K��3�������}6��Dm�O{å�W��@�C��@���n�bI3�A��fB�9;�w@��~w��{#��zh<�T�[�պ	�@'�����c^��7����:`>K�#晞������M�N�e��G�s��	�I��$���G�}��ǭ#&=Ͽ���G�K�:�[}��nĻ���;���k�;U�8�t��U3gx���! �!X��gb�<8&�v��x=����]��JnɴVO���_kY;��C���VG��z�[��Z�!�� ���x6����V�`�V�gq�����j�s�=���0��Ņ��yt�����5��m�FqrIYO^_�s���[Nw��K����w�o�07�9F�`�i��0qVU�H?@��s��Kq��:&e/]q��]mJ7�`:ꩯ�b���hՖؚ��.�#�����s�`�aAM��j�L8"�Yv�{��d���^�$Wwm�\փq+�E��[��h.�沑��`�o��&5���=�$�Z��F���B�p��l�����E ��n��'6"�&�o���(^M�\R�e�Yן��A</���S��,�=��v�F���KG�!>���)J&y�d�=�#`*p�e��m�t1��@�a����A^��y�=�͂�Kg5��(���ud$��X���|��xf҉�<.�y���ǔt��%S4��I馬�_G�W�f!ϭ�y,э�i��uW*QF��#�/ݝ`^������65�-(D/�8�7s�.��F�G�펌a���KЭ��^k잟"e���.��U�^��v�����c<zw�c�/>��9%,�*�`���cj=���V�`qK�Rt�����pf����|RFϼ���Cy�GXw�[��$�'�P�K�ۜ�h�;�{��qGք�:V䇔읟��6����_�u��n&�8�k:�V�M>�<1��c�h�Y8��Ӳ�'e���o6��/˕߸�-��u0��G�VF�[��^Z�h�ZtW�~4�ejūW<U��R�d�+Α2��ݿ�w�@�n��߂���j��ͻ��û���)s�gxbG�	��+0��Ͻ��\�q���6I���Ym@���G(E�	������fF;q�B����$���6�9�.��0�� ���/���T��2�I��\����"��o�y�X4��?9T8(�{�Ás�F2�%��a�=���&'�7s�u�S�^f7�$�w��m�bo^	����B	B��d*�){�Β���,]_H�Q4�Rg� ���(a4���O�.t�g��6��zTXqRO�vR��"�󰨝&����oGLʽ������*}��O�5 x���ލ����3��2r��#W�gE�X�#���:yI���3���oQ���z�q�k��qx�j��#��Q�GYxp�~���K�b$�$璲��b������+WS����NMo\i����;4�3�Ԃ�^C��Ӥ���|է��r�71���$�V�`L�R�������]�����hp��}K��ε �1�����Օ��4��E�Z�,){�`ò���������x���)�Xq�l�����j2[�� x�J�0-r;�R:aۢ0����F�D8v�LNQ�z��Qk�05����mV⼦���*�hDG}���x���;r�q�K?�D�_$���p�$�� �x��"�Y�,){
��F���7l�5k����=�A���I�k�������ȟ�V��w������\C�	p�c��A�q�!v�]
�B�%e��KzE�P�ʕbӫ��J�m�Y����~�[.�x��]�Z@���k�4�ߏ�*qZ`cK���X���qΤ��2��X�)��s~!�w+�7(w��S�o�M�E.�O3/���m U�,��-#�L/�D��9�,��:$����9ޥ�]��yzq�9��$'�����0ٽ�`��T�,�oBpm�:�e�Q_;<P�W�%{2�u��]�K����u�;�:�*2�+���6^�����������ֻ�p�xp>�	�~�%e�Vo��h����}�d2z�Z�[p�*~!�ە����_�\J�%c�7I�]E�l��2�v^�fo.mb���[ٟ֮t�A�^	�*��SKG���E��L�k����Ka��bܸdǖ��-��u���^V�ru4lL�IP���R|ki��M�޺��jڲ"�j��;�`��%����Rk��+��~�8��;VGd#�Rƛi��ՋEhV�7�o�xx�^�b�ނ��c��{�s�^S61�b,�R�0\��2@9�|Ȓ2Z���
G�g�|�=�k+�+�#6�@�M�j#��G\s�>�����hdY�K��}�خ�,�:I�#�1/,��f����	��������Ղ�)�\RƜ��Y�R��lIM�W����zk��28bʶU�8쌶��Z�a/ۉm��� �    �p������s�&���p?�lw��nWsn��B����ĝ�e�R��тrJ�g{Jc�y9�{h���b+�>���b����,)��w�����W�Ry��+���²�&�1�t8�c�K���R�6�}�?R؆��[@��V�ah/Dw������WȐ@��2�jt�6�w-?݊��ބ!4� �-�)�w���y9�'��i+zO	3B�9����Ϙ����Wl:�L
�2������P�q�&`p�`��p�<��d��������\R����΍��/�u�z�6�k�!���@�{����yKZ��h���m+�Wb��o��wv�LD�a��9�'dDFi���\խ�`6�>�u���V�2Ѕ=��@����E��Ww_����B<z��.�$�>L���(V�6�1�� q�C�>���_-�{���;w����;���q͹����g�-�.�8������A��{�ɦ4�3�~F�	E�x׫�8�}IU*@;$�l��ޣ7bp[�{�����������Kl���S�����NLa�G���g����%���[,¼��?N
��|.)�P}di8��y;������]'>5��gD�����\	$�������7����Zq<!���	��d��L�iO���^�����:7�Ԙ��kg�\i��H�m�d87�u�aN���C�K�k���-N��琲�}�sː��&ǨֆC�v5�s���g!B�K_L轍Qe]{#wG^�*�����Ķ{�3AuI/Sg�r�5�Z\�}�J{]���A�(�Bd�3{PvoX,N�[	�/׾�����v��6Kʚ k�:�ftOfv�t�޶t���F���� �3HO�*x�!gf�4M�����m\��iE�bijgjָ��B���NQ�j�4��C�J��a�A����y���R�3#*Y6�x���k�g����]<&eu�5�<�+a]b~�lO�כ7�P`;m��]{��;�XGz��ūFӼ}j՛wf�yyrRKWtX*��^���S��V�I��RV�X��z�M7n�������IR.�K�i��:��w�}�����W2}(��2�,<.y!|��V�`1q)+�Qq�6=���۳c5�m�(D��`*O���Cv�����a�P�=c6�[=FGi:�^�D��� .K�b�~�ǥ�{��mu܁~�մ�Q0GI�c�nͣ�b�x�B*g�I4V8�Y����,)S-<�/�����z��w>��܍|CA����4����;��K"���"����d�)R&]�*v_4u���瘺�P�-pt1l?�˚�oD��l1Q;�̛�Y}5
�;����D"4I�_U8{W��6�X�Cd��rsHY�������X�|yK�����]���E�$\�rVrBҍ�����%Py{ha�`���	�CPac�� �2�6�Ӳ(z�����n���k��!֔TCy�0�a�W��Q�XU$FV8��S�it��A�	#NT��K=�a}��dH���m-_�͖~4PS���UNvR�l*nۜ� �ڶ�:LJ��-x'1�����}J�P	����.�|R�E�>�C4µ�g����p�D�8SCZ#x��W�r.�O��C�j����+�6K.fƆ	Tj!XلGS��)��Y�
W��&KJ�����A���H�L��O�����Aǩ��Y L�I.�;��ْ�Ek�9"{$�����o�]��K)�v���j��Ft/��ލl?�C�9DI����˿����sO���]"����M�8)q�� Qr�E�7�!Ojt���Hd����|I��2��T�U��x}�6�B�ӹ��!��8���K�3�?�V"��.	�{�m5ıG�x��sI9̖?*;�����c>ݹ����5�bۨ���j4)�Wa�E:�N�5Ii,|���S�"UỊd^g�������M&���i�]��ki~����9�oLɚ�3�ڈ�h��nzT�~7��,�o��M�z���h�T��&�B>���6O�z��JegrI9gp�o��t��{�<.�dx.B='3F��	��b�8|��?E��0V<��Ne4��C�0;)��x�D/g"�q�rP%E���5m�8�#[Z�D����}�W-h����_��O��$��C1��dN�R��!�a�Qit`',�X�HY�̡b�h�2mw�Ģ��ŀ��qU��7������$%u)Iu۩��Q���Ŝ���Y�G�	���>g�O�ʏ�U��o|]���p6�����ei<�C�q�oN�<�־��Ɍ'ckԥ�@ugIN~?`�rƳ���1_O��Q��4�4����vߕ��U"�\w#[�:���?�\�*�E�2T��dzM1If�N��Rp�W�#�8��{��ͫ�%�u��h�8K��{���ߖ�?�U�K�->&���6�?"lϪ��t��r8��i%;!O���U[Y����%bLse.���;��|��i�[����T�^EHE|٧H��ڶ\�Et����F���'�/*�$�s^�.��r�ԫe ^���<?}qH�e[�T2���\�9j���,D[��a��(l)�P��z����M7�������gtp�p��� ޕ�Awm�U*n��5�;M9����W:}�C��͌V|����`����	И�d��_<�P�+�<�b=T��rI����{�?6����۬2L5��_�0Q��)##�f����$��l�x���IC�/�S��BF�$S�����"c�ӤSMq����I�����_y]?.��fk��:����s����]�!P0(��v�t��@ؓm��9\��"U&�%exn|���hj[�Ͽ_�>n���
��A/4f[�&K���cR*��[:��S���-��*	vN��w��Ů����eQ�]/ԻvT!Җ���љ����],<\"���eY�I�`�E��N4��B�WH��\I'fy��Y��޾�W՛�զR�l[�Ô�G��k��E�Ea�0�y:�,b���L��3�yciR�F�f�z���(=,ZՁf�Ɓ!`��� ��c8&e:}~�͎��,�LjkZo�I�?C�'�C�E�iS}�)�o���X݊��'U��F�4�-8c[Iv��g��wi�!~���x� ������k�S��X�f�On�3�b�z���W5`�=H��1�;�*|@]�w��'T�9�L�(�N�v���l�F�ѫ��^�dI�燺�Z�=��:�y���uwהaY�AȈXJa�j��Pf���%tKJmۖ��HR:0o�q��H'zrIY��Ɠw[[�Fܫ�?��۵�t���3���ԫ^�.:|����S�Ř�,���É�v�g0��1>?y�t���C�/_�7:�e�;���cߝ��[��Ӕ���a��&���yd�=A�]��E�g9Ђ����6��{x���Q�O����7-��I"����@9E�%�ӄG�Ɵ�wq�1_M;���'�-eŀuҊ��aRD/3%\�c��cR��gVgCt6��x��mW5�5}4�4����]�����?ֽ���4���YV�J�0��q0\���0�o��#O�n�&��Y(9_-wuW�ܛGm��������ԠEwn(��0$��@˦"� l_]`%C�P3w9"	�]�)�F�h7V7�D�h�|�5���U���ٛ��:�Y���q��,�V�RϢL�OcLV�I�D�6J�a��vq9
��8. ?,"R����x@�^�;(��Bw���g���<��6�v���bC��y�����j�8�a�q�x�����#��R;Q4����;�#��!�&��A��m��] �[ ������s��`��p���:Auy 
��"0��H���ά�:�1�YG��ȹ�M�R"ZlRˏ�(�����ɦXHY���N�u�����~�5g�q��QĨ����=���/�>�|���I�g{����[�~GC����a��%eu���||tN_����WuZ|՞	,x�#�ݞA�-L;L���jb܊cM�q�b��$�ی�    y�!e�_vK��0�l�/w��W;Up��
@#�5k��:��_ͪpz	|:�xfI�	E.�O_�a���y�����?o�f���9�s�Y!�Y=�U9L�8-$KFty�`'cp�_2M�N�jb�9��ߩ�\q��.��7W>����0�G��6���D�P�v���_sb'`��HY���]2QZTڳ`��J�5���(����	��E0�6mw��c�Ko\:�ձ�e��
���D{(�?O�O��� �h5>Í4�y2۲�����+~u�ҧ8?��ibv�4�8Ow��nL	R,�|�;�������g��=�i�)�{q��I�ܷT��w@Ê��ϊ�/�`�~�jF�K�b[�I���3`*ז��dM�#����7�Ⱦ-����S��zI���)+9d�V���#��z�8��O�6"���r�b��)��.��z@�;��Rz���͜^l���N�$q�ґ����+�K��{2}l�j��ѹ���ջ�[mR��r�����E�� ԣ7��N.��ЩQ�����g���u��z����q���iE�G�E��K��٪�ħ��o��˚O�-m�v�`�U/W�pH�}��k����T������yݰAH/ƀH����<G�0=o�W�I�k��)�W���P�H���6����[,S7�z�?mu���`��`��z)��oѭňW,1�E��(�|R��M�b4,�9.Y������Ǹ1
��zoa^{�^��M=<hn6V8ߏ�N�Q��  �5s���բ����;c1�x����{���5(��W��E`�h�T���)�Ď�cCd�m�2�Di�:����Rs�]�]y�z���森@��l�t�Ş݅�H�����s��*v¥��]��9K�~�3'�51X���prh �{[���a�}��)R��9ǽ�ߚ{CW���Eo@���ǿ�^��2�n��a��O��h�j����g���"���ҋnSSxy�?: 5t���+oY��a��XPZ��R��\�#z)�?~��7pb����Q\H������arԲ��N�.
?����S(��+�&3�q~U(�G�dN����=F�Y(w��kھ�JOb���kD8|sl_Ե��o*	���7G�@���
S+��Ga5�6�K�{��{�'Y!
h��F�9��WD'A�����U_�c�°@V��v'S��lMݦ���Yz}p��+���/S'�,�����CG�Vq+D'�
�p�<���sqo���.�kZ`��va�j���yb`�cR	��,IE�(΄�ɡQ'���"q�������y��Ӥ�dԛ��7�k�;h��W��Dg��.@!��s��g��:[�W?�ӕA?�w��K��d��x8���PLD:��:.Q����WcO`����zݧ����ŵ�h�1x���#<�mp���{�����D���������Jj[��A�s�8~�D�9&���5�1�b��jo}S������J"�=!*ڦ�������E�O
Qf/����{������}�6��Le�	1quxl�Έ\J��k]G��(D�e7�B0�
�����N���k>���Y\�ѩ��q����f��V��sJ<�)f�lk�0=�������T�O.)�HR�hi��M��1��~w��T�H���	ⴟ?��?Ʉ�m�s�t�
wF�Ӳ�9�e ���r�r��><�����դ���.�ݳg7K��?���Y4�UK:-�2��c~�Hs|�kI)'-+�ѐ5ǰ�~�Kʎ;��ܛ�!�-�8�烲V�pC�aZ�,݀���ۿ��,n�p?����j�}�3qn��RQQ�H�6ʢ|c��'^�)RV��I��%\�5%�^���#]�D<$�r7޽n+АT�8g�~�G��\Đ%�0S�B��w;X�HY�K��S�o����Ģ�*�uhh	��A��-����~���Kc4F7?>r�s���� ���h8Z!Z�y$�J��I����X֭�|�5�xW����~��Ĉ6֒�����fr3{�x���ok�`l�Æ'��>E�x
�N��R�4���:0���	c?S(<��D��	��vi�o!���t����V��/�bS��z:A��ӎ�<6�6Ԁף~{��V�ޤB�.Sz�c��;�H*���֞<}*�~�^^w_���r����C��L�㗿�<Fe�E��`�����k�^��s�C�0�Mw��T�y�G=W/B���m�������,�r�2�±��#���?I��4kkv�MB���]{�v�lbH��p)ɮ{]l5C0�:�`�pya�@4�(��3Ge�ɷ%��A�ۑ�����ShaI<�|>�7�ތ�u~5��v�p�p���\r=m�l�O$���koQ$��dc}|"���i�^�!��[����"R�j
��%�D��aj�/���۹��E�}�Mj��0l����䓲��I=Ě��v�ۣ�Y��d3�J�ضNjE��oaTwr�,^A�4�&8�HS�R����R2/��>)yA[;O���`��m�rNp=��5�>5C�;�h�`��Y:��.r��O�Q]2�J��r�j9��B�[[q�&.��{[�j-�N�غ�㰈?�=��y�/��`����,����)8�q�\�7L.�%��H�X�.(�����[�x�0K���Z��o�+�۷7U�=�ک�N2ؖa��� �������0CE!�#�.U��ާ�Z�A��D��fT�uS?:��%�Uk��H�mg�Z/j�bO^i_�\"�a���|��o`�w��`�?rD�ܣ���LJ��,Q:Ǥ\�0�s�{�(��a�Y�E��xC=�pWCw��
WdvAWRk��!x�m"�H͡咲O�� ��ꊳzv�>Z��i�p����۹���B*����A�p2���R��5�%��a6����%����&����B}ǷJ���y���W����"��$G���m��\�	be��ڛ�kS���gRD 5B��pD#�v�l�Dqh#���BQ�Η�u�u�5�ׄ���A���'��\`at�Ȧb�:|�`<�G�{,Wˎ����h��UDK���2��Ǥ�};��zk�#�������;��q��-b��V���d8@	iV<��uM׬�ﾴ�%��,���������'��S�,�����t��Q�&W�l�Ŀu��0rh�؅�m�!�9Wf�2I���qA��I$u��j�
"�����X���p�w�'6�o�}�CY	c8۸'��-B�F�g8"�G2
C���_$yd���d�-e�<����{�N�'�4G�:��p?j���
��������lk-�p���ÝC��E}����xcw�νS�TM�d����-1�
0]yN��L�b���L���E�^O�V!ז!$׸��|1t�NA��'ٙ.�Ts��rk��ƒ�}"�i�r�n��E>��l�^E^`=�Wo���zg��g�p,O�֑��P]���Ĝ%e.��
|`I�pgz3���ǧ������D�-��][ډ��'JG�����L�v%%�w%�7��x�����ú�~Ք!��s��Q{.��o�uP��odMz��%�r	u"��+Exٰ&u����7^��õD�+�j��B�0D��V\�Y�ݹ��G���ł�%����h�&C��x��"����VP+�U�\����[����>Z�%w����@���v�컻G��U�����b��
cG.	b�K�n9$YN�R�y[:aqd1Z�>�_���N�98�E̺;�I��E�����M8�][&��!��e�#�sL��<�ݡ�1����i�s�Z�t<� r.��A<m�"�18�����O�7|��]Y�w��k-Ӊ�!{˪y��e���1lZ/����!���t�c��8V�7÷���hR*�˃#$�8�j��W�?��}�dI٫�>lK|\,o�u��Uo-:d���
���%���O16�z�%��F��r��rx�{_��h��[�B8,��J��XZ.)�	��fG����4    �GQ�j�I�6,��7�'�Պ�����.���bԚN)��)���7��G(� �Q�=�&���җ*�ΐ��.���{g>}���~����j��_D!��-�t�浃�7w:MF�C8]��	P8�>qP$�J�erI.�/H�
��������x5�h��q�8���O���' ��[ӱN~f�$���f
[E�=DڔG�Q�k�pa;s�e�U�!i�gxx�`�~�t�����]j�����|�@'��w�G=����=H�grd�1a|����R\�t)8�1�iR�?m��<����͢��^�RQs��p�\q�i�9>6o��׋��c�d��w 厙��L��1Ⱦ�G %�}m��I��)�mp�9�����������-,
�:ƣ�����hibHǎ��'�0Y��!	;?%��N��#��K������n���Cԯa`P�kɈ4#{kYINRGKy�V��Q��$<�eQK�
�I���H�����}���&!��h�����q^lm�$���Z�{?�Bt#�P�����۰�S=�q�}Nq�tg�[��8�*�je.�Ikƽ�/���.ܿ����lΛ㋊�_�KT�w[\� �{��6=�t��c��W0.<��X1ҋ��}���	��R&����,��(��YZ��r�d^�_��m�TӇ��N��#�ⳋ�p�%������!4<��xuv�A����I!�Y�r5l�!eO��^\��r�|��U���&��GeX�$�,����K��[t<����:}�ee��^~���L�{�Iz@�50ɶ�S�?b�1��4������vq� fl�1������,6�D���ෞrIm���,\���)7�M��al���%e��Sc�T.uW�����K��S�g�������|W�+v��#�?Cj��>:�1)�;���s��F6q���|2w���2\�_T�aPb�0�#mE��:����5��.Z�����~(|��;�KB�2C@��3)�y>�R�ʈ�B��ZWVn����c$P	_!J.��z����B;���S�7�G$Is�+�{V0ЃY��S�Ek�=ҌsC: _{���]L���v�Q\M�r�P�O�Ҹq��c���:�AW���;5�m��i;6S�9���˫���}��7/�W5��O���6�	Qwu���[<]I8V\��g�쭝�� ��R�2�j��QVӴsZ��m���Ѯ:9�Z�x�z�l��1v�,�ϼN��9�-�E�aJ�:u�.�搲/�[�-F#óR��k/^�4.��2�� �>����N��E`��)�\R�m���66GG����;=���$�qQT	��<�)�ݱ�_F*~��!�g��96G$�)��b��X2X�hRj�nr���#T&F$��d���"�`l�=\���Kf*oF��>�*�@9�����k�RZ�~�\R��t�]���Y�s��n�����S=�8�n��y�#����ON�uR&I��\�#�c[����1��G�H9|>5Ŷmi\�R�����z"� j�qy�ۦ{�M}ϔ.��[ ����<���s����,����%eE۩|�_Ct���7��4��:L#�x��v���_���,��~ a�.���,�u�ɤ���A��I��`����e:
O,�)R�v�ݹGK
O����|<z���_�`�<�������r*M�.x�[�Vf��:�S���+�@#��t# ��A]�k��������A@l�:�iVU�����;�k����p�gT�0%�=� ����d��Pd����ѫ�n��vSt�yش7�pti�%6Њo��;��.sD���~����fY6�j�kH�B�:L�p{ʔ�j~=}3���n�M��WE������:�P�� �>��7|���_L�w�6�8�><�y��zF���1�Ŀ�s��ɾ�C6f���T��>I�9���_Eg���U��p�OW���@�������B�C��ғ�VOXF[
#;ļ��)]�#�v�1g��h��.V.�T'�.cBzTz¥��S�����ϝJ� -���]��e&��O��Y���{�t��F��OA�y�ק���
��A�U���s�|)X��iVRG�Y����X!��ĕ�čouou �z��q�LSj�31��|�~]_7�w? �V���kp(�D����Z� ϳ[(�zQ��QB�1#�uC[��f&�=gJ;�3X�ن:�]S�5��[��P�9P�|�,CXp��� %��5S+���^RO��u$�T�]~���M�z�+��f$m����?�+|�@X�C��t�Zß�u��C��|{�ʏѿ����"��S'ȈU�ى�r�5��|m��h�7����ޛ�O����	�U:r>�	��A��)�^�kC17bf�b��S�T(ynv_?W�[����]/���'Hl3
RCcĻ`��H��j�:>�� Ӝ�\���WG�����0]b�ьo i��_@����rO- 2��TN�
�
�iu�x��ont�����ٹ����(
&S(s��2�"���v5/�c����.�{i��y��9��6�������>���L��F��J���H�C�h@��0�G!$<HN0�!�&fҗ�����`Z>/�O���n�X��@Zɣ?�g$�sH:7H>K�+���0Љ�}l��+5�)�i~o?n릧3�����r�E.Nt��3�\��㖞i�s��J���ـ5�*��m�|W4f<�qE.۔J9�/_��Z!����݀�Ċ4�&�X�l�A~<[,�/���4�t@|���X�Ye%����D�(��	��� ;��΢X����ep?j��
���_�i����V���ӟ�~��eX#�) OjC�y8ը,���O�x�	�y���6���ft;�]n�r?V�)(���V����t�͊�+���B��s��G|fE0������#C��L!:`�#��=��ҷe�~�ϋC�b�cI2��0e��r]b��#�J>�f� ��s%����čO��>�r�@C܋4����R&,�e�t��s�q�3r�G-��|���\,G���:G����/��6�د��RE��qT=Ő>o���{sWN�7���|c
�ua�ݽ}��!�&�隀�+[Tҩw��2Lr�/s�%I��2Lio����0Z��\����Po��V�\9��k���������ǃ���`�����?���'���� �lz@I��p �v�̴���k����~���;�7���OL���s9�A�����.�u^_*4�7y���h@a� ���B���Ū�M2n�=^�F�,���~ͪ���5����F~0�ѣ|�����`��A��oWa%G@h=�〙��T2k�%iJ�����]�Jm}<�-qWkW�$%(���k��Aq��}�z��	��Ց��%�.�E3�\���ˇ#��ś�^/��:4���?"����|~_|��8_w(t 2c���|����/���4��>7clF�˃?|xe*��Uē ��� �q��v�u#�ؿ#�����u�.��w0}cw��o�b���`	��t	�_.AO�CE��DN�Y�-A�X)��������vvw�t���*G�Ԫ68<h���v��M�+�PZ�r��n[b;����{��9�t�|�Q�#NR�$ �a���\�kP%͋�oN�҇�kn:fX�1��~w�0+R�����O�f�� 9�#a�~_-�W��mu!�9F�Di�q�4�����6p����Q��/���c�t�����V"T�NB����2*Y2��0�S�3�z9�����.�J���K�eyf���Kŵx
S4b�4XO������&BN8,���#k;i>��9���"�(r����_8�8��s@y�W�XM���I��=����ING��P\��-Oc��צ��V ���(��W>R3�R�Q��?����LS�������H�?�J��(��x*��0��R���2M�}>�3��U{�qׇ�������h���Dz����@�̖R��m����̋noJm��gQh�s���Bo    ���G�}�nQ�-Լ��,�/sAlΣHjڌBٟ�SçL)o^?���􈧷�oպ�@tb����a�m�r��M��G.�a��=�s���$�2��.lg0Q��b�6oK��`�ua���zP�Z���tL�ѓMI����¹�\5���w��@��x�5����wJ�,������6�6��w o�"Py������$�N��%l�H�(��A�0�m�eI{�|/>��t�W��s�yi��͡VH�'s�S����#�6��C�����x�Ӓ���)�;�GҦ�'����{&֐_�Ji7�5�0�p=��y����0{��y�,��݅�13 ߃�	���6Hl+ir��d�+ޗO�Ws*��o�y��s^Ŝ�<�����8G������ȟ�����b!
������Q(��ԯM�OXR��F��sb�|<���y1��U%}���2�:��������W��ԋr�W�JB��qCz�Q���@0�/��n�O��T�¹?�D��*�6m����{a6^z�p
�[A揋5�"��\���_�a��<y���>��� ������o�;�`�Q$zH8��3���\��x�Ѹ�pd�$�������F�ן����}h�%z�%�l��S_�pT�,�o�V=˳'��&B!�A��M
�f��7Zoz5�K��u�=pZy�Z֊x�gΔ�o��f޷s���(\�t����Ҹ�;���f=�TȤ�v�̼�C�O�R_��g���9jڸ����Gl�I��&{���n���*�O�k�<GrE� ��6��.{�Kԉ3M��>�zBg������ڔ����A������x0�G�x�9��ր��g� e���e��Kc�:�H�>mJpo>��rQaK2x�5�?�� ׻β������"�,Bf(��J1i�h�4I��B`ϣuʔ�X��K�f?˵+�<�P�4�����޳�ڒk�]��S�����:k�_9>&���Ầ�&��ӠÄN�R������I5��W���k��;QLz��i�Y�Ga~��AY3���96m��:���Ɇ��Gɣ����`IވdE�{Δ^�[p]|�b���V?o�M���f�"�G�����1ٷBt�]���T�'�>����^�s8l��Gv�CU<���mwNXE�����U����v
����g�2R������&���Q�<�4�O���@�k�:rƔ������ZK��,Vj/E�[5p(P߻Bx��3/�V�Jv2IY#t��#t��>�Bˢ��+��}�,9�A��'84�Nv�y��˧�k �5/��m�#��'�0s�1�`S܅+��Bj��:�r�*S�66n���:2��no�כ�S���n�F�/MODo�NRr�?G����a�� q���r�?�9���q�MX�� \��>7�y�F�7iVZ3mڣ���J=u�_H��nX��^�/�ظ4��%>9֑���Cw�:z�s�¬�Hϓ���p��?#��@j��
s�L�O��}�t%ۼ~C�{Y�[��j����r�'�:���iخ>SGQNB�����Bb&��D/��������T'^z��ب��ָ��E"�p��G|+���x
�� c>3�cD�[B��*k�������m�N3L'��������f�9�vw�R���d�A7�0�6��>F�+&N/B6�	��>��@�D���U.�w���~�)�՚?�6뭠Nvqܗ�CS�-���i�J��M{�V�D@�3��x�Z~/��(�FǄ�(�)������)O��_�a��������Ë)o!�h*Vt��b�����J����}�bn�H+4K��.�o�y�a��[����N�1xhRNv�徯�j[|˾~~��`�|�����w��pq��{AL��f�ـ3��OD��xS�S3�hd*��f:VS':�S9
��̗K�kR�u�P�!n����\f�U�j1^��`oǏ�#�5}�X����N<����hwŸ�*��e�.�д����0�?�������j^�ޮ�����@��F�+��v�w�����y��i���N��WW�8��`^b��)}T���¢z��畤�j��=:J u�⼿�+���P ��6VP������y�RD�N���.��3R�u�S&�f��L~now�WyA���m����D
g��+si�#<�ɚ���ߓ�İ)_���I�j�)u�L^~�|�q}�d����������0�����fڏ�(��TJ�K�"�A^-��چ���Mb��T����*ǈN���ӻZ��	�o ��%��#�>��aI9)��x��Cnʹ)U��|�O>�������
ai���j.(�N�|�yw`e���)�_�́��(�~��D`�g��x��$�+d	:�S��5r�w I&�pO��VL���j}M�?zkt��l��=����D!4�I�c�L)�/w��a���}<4��&E��S�6Ђ��&��bH�Ī�PC��P���U�A~�6�w��on�`�v|^��n��A����<}�����&�H@i\�� �h|z���X���)}�ϸ��	BW��@b,΄��Y���#6��K��14w\��P��?��f�҇��pӾ3�R�����W4D�ʥ�r�`���:U{x,�7�6�i*�߄Ⱦ�1v�����YB��	�]�]�&Y,�0��0x�>/�w�]+z��b�N�tꩤL&��xp����r�N}���y�e�^C' �Rfƈ�̈hD=����2��7=i�d�M߿�w��f4[�aX�_���kZ�ݷ�k	��I�&8��D��1Q#N�
J���Ȕ�e�n�e�k����4K�w�ә%�[$�ϠFa����SN�a���P�8K��#�8R�h��г�����i�-)�b��{����ҕ�:j����݇�*�'����j=^o����=���e����_]�#�������/��(��GF�T �L�o@��{#P]�wџ�ox��G(���^�E% L��t ������"��H�)�:�w��R��(���.1~��E��)2M�����_����=�o�zǱ�ρ�H'�n�َ���0�cĆ�)�@�&��vnuKD���?$�	 s�)�2���/E��|���{��:�6�	����#a>���H��)�7�U�'��n$4����\� �uB=�#?�>����<��U���#`���*:�,0�|������˯q���-p�zdIl!BE�NF�ҍ[��L�}�x{��x��u�/�������G4
�3N�vI��P�8�U3A#���4ن���zɱ!��kuPy}���m�z�y8��X�� �[�hV+���bl���t?\J�M?���)|b����uM�*ŒM��rf�R���~.=�h�'�/ۥ�R�j���/�j:Yߟ[}7���l�K�a�a����Ę�c�$Hg<���@�d��K�~��롹ޛ�[}x^L�9�2� ��n� \������T���@����M'�(�5�nw<_�EsT�d�M��ʎҸW�@E���}��DE�>��qg1�F٤�����y�:6'I��2�.�K8����s�-L��	�\ 6��u8 8�Q��{�N�"޾�:�u̘����5����~/g�_�xN�M�AH�.�c��6���U'<f��	
n��%��3���w7_�F���nv;,�4�����L �N���fo�{�*�[�{�yf�x�����ۜ�C�ɀ'�f\�.2���nv���?{�W�}{�m�}���C�Z_�aJߍ{������ ���ٍ:x<��c�<�Y�"�"�6�s"�=�vt��l��2�P��~w2s_�墵�y&�p�(ʞA�M��	�k�3�9���+�#M��� U/b�����ݣs�M�x�͏����~}?��-y3���$�~$ O��X�{ȵ���^�*�",t�q��;�x衳�5�]?�(N�Rź[�u'�.�y��2�N�?��
�P+�ם�v��<���y���6���N�\���W	���zS�B�%�!:O~�    5ψ���x��ؔ�v�0�[����м���x�ZA#����q�6��iܓ��l�+��@�*q�6��aG���)U5��۟�����U�\ݴ�Z� �����_�쯳ؿs["�v(��(�g�R�|�m�����}�p;Q����Xwv��p;i��݆�
��Ao�	��P�������ׄ�[GTt&_���:��8���q �\�:.�0&{vPC�I!B�N֑%����ϑ�Q>>���j�sޥL��d�?.5^�i��6���+;���������;�B��y����N�`gVAr�k�k���ʹ�\���Տ$����xHՏ�%�,/��D�M�-��ԖWw_���8@PM�Tm���sLřNHҖ 
��Yܹ~�6���
��>⒬\<��z��lЎ;���<9(jO#}B�m�������b��8�>=�� ��Ţc��y�$�:�%2S��08.S1�˸�t�E4�G���)S�	�~�+����/��v������1��
��|k<"Qa�(1a�j���	�d ��O?βt0G.D���L����ן)�8�3���w���1���������%�X��1���)1T��r�s��)�7��!=/�Lܗ.͔'��ȅt������݋gB�>�Za��!�R#v:*w{a�Y�}}�?�j|�'k���Of�t�g��*���׺��"���)u��������k�Ma[|��@(t\W:��?[;+b���}h	CuN����珶\�C脉���!IA��|�)Sz�[]�q^C�|6T�\a(���ҧ���!�N`�h�׋"1���'D�b�C��ߎ�c�BϘ�.7��G�8T��t�v����0�ކCb�}�_$V`�����;��MA��"*' F���� c�J�d6�4y,IX�׭�b��_��S��x�ft�$�wy��}}�a�K��F�I�t�:�e6�U��Ӊy�Q�Jg�n,�}ʔ~+��n��:�fS��cQ�s�(�&/ƎTU���;�atGf Y)Z�M�<�1�8��?�r���\#n��CRTΛ�7�ϹN�Aξ2.܇�*�i~��j˜ו� ��[;����Cˆ��I�0�c�E��{� �WO�a�S�!�H�8q<p8?�}t=]e2�&Bv��c��Q^�()�� ��щ�^�)�\�vV?���%�k� .��c�����X� �G��.䠠.���rāj�㜈�T�_��C���]?�ps���ߥ?
�u<�&��g�p��WeM8��D�=�4��i�ؾ-��o�E5������>7ͽv.�H����Ss<����BZbNE��Y9]��>0���[���Q�b���ѧ���RW�1i���.�\���T����@�彦T�{�V�2M�W$�LS��s�����6��;)>P��_�
�~�����V&�?;��[Rjb(a��
joB����}9mJ�g�&@�{��[Qp�g�
�zI��>��<�V+�I+����F�2�e�C�M�ܘNU�lDq�Q�]�7�I��� *d��[�gp�pn]Ԃ��`�����󿱋�2r����r� �Pi
_�f�OV߷p�X6$�s���@��;��0�$�����|���_Ҕ��ȟGo����L�y�w&��7�[@aVB��W�.?¶���z��N����T`��z���*���e�1� ~�aJ�[ys�M�����u�f<��Z�[ �D�M�لc�T`�a7�QSWy<�	{�O�<�~�+S�� /��ʞ����m�7~��ܱ�[-��=�Uۖ��8���.>��&jφsf��'u�	�1���Pda�1`��8iJ]A������
�zu=�5O��^;�d`��n���y�(�d��qi��ぶ)�~⨜[<��D��W�\&��`�C��?>����CgbY�³\��r�9�~����	�#=Q���w���3񸞾W͛e�u+} stΆ� ;٫�D�$ȑ�İ��x4��/t�@�`?�sʔ>����e�@��?��k�����M`M<*V�$h"v�D8�f��X������JTRǣܒ�8��EK�J�[2����wdb��>�/#үo����r�r��s. �q�0�0������4��p�dKD?�R�L|�&������&����d7|�$e�{+�aw�|��ZQ�^*�{�%Y��q����F�����^���N~��Ӡ�(����]j$O$jOqҔ���x.6��i����r���)\OĲh��Ob	0�}�WA�171�٠��:���!L��)�=6T���;���5�{뿙ޡ��|�$���?��
)��X˰v���EH��Xx���P@؃:� ��D9i"�EJ������X�|������mEv=|u�r��9� |�t�q�)�[z�����!b�'�N��L0ҟstnga$b6�H3O�J��&&�;(��gc�}�#s�N}<�y�XOv�, 0�ͅ�ڕ��`z�����Y�q��[Ƴ��B��A�siS�����������l��-�q���>L7I�T���9��,�&�q�
�:������d�9YgҔ��^g[����Z㥯�t�\�+E倁F暛�t�w.��7��N{�tv"�H�1���CP٨�#ƈ� ������d��V|��
�;���sU�����J�s��䑷��:�Ϟ	8>�Q�X�]<��A��ǌfZ���}�o��������k?@��tr\)���v.�����u~!��(
�� ��<�W���T\��Kny�$��D����LyY�M���b��_~X ��,�3�(�� c��5��/ �Тͬ���F��]���8Cw���F7"W񌃈�z�����q�4�O�"���<�;�d��v�7~s�wS����P��V���qJ��ؔ��8.�-�O�R�f��tm8�����U�̳H��ێ����3��;cJo��;��p�i�-�������!.���e`�p�����Cф@vN0���a�o����xET�3��%������Kb�V=:2҇���I��
���BXޣ�������|�oY�R8��O�4�T��Ձ�ϋ�ʕe�P@�	��¾�Li\�:[�*��|^��������6��u-չaD���S�-��� F����2�N���LS�4;��3�a�~�Yov���>����3)���?�./4��I��dZ�xDR��~-[�UL���'v;2Y�d\h�����<tt#(p�����f8Bf� � Š��/0�,Jى�L	�Â1�h�	B���4Q@ydF/岇^7��s���`(g<�t��k��]&�|���(��3}��CA4��P�P�5mJ�Lz�Yh�a?r[�=4VU��(i��v%�Aޣ?�q��`���z�}����:C�4 ��)(�~��4�b�)�^ȡ����_\��8Z=2��q�s3�*M��ޫ�h���73P͠~�M��:a����ɉ�ԓ��du"���ؙ�RCBD`MRH�`��uj%섌��}�^�1��߽_�=�:ws�p V�iـh�/n�C��7�h���Kɳ:=��V��7����������r��<{̓���1�r=�dQ��]V`��/cJ��#��룧몡�+�,�W�����i����4\����G���Ճ�KEE"d,�"����:u���0��E�a�h�;����6��rsi�ʹH��F1�m8�)��c��S����&��Z�rG�i�-�
�iq�Ww�pP~L�3�e�.1V��	�J�e�ܴ���-����e���k}zm��zj�}� G�>�� �Z�p�aJ�B�4��>�?i���q��O�Z.�#.G�z<����$}���eF�=��|`�Cõ�Go��D�#���B��gtw��s*k�%Vƀ���Ś���C-0L���*@�#W��\�F$��42��k4��lp[cO�N��ݸ�u����/W��?���b}F���K�~����ؗr�1&��``�����.������0^������@��Z�A{��@��'�H��ʮ��pu��/"p�ap/?����    ^�5�T8W��?�B���W9O�J��[�2S�囒��pKx"q�d���#}č��7O/�i��p xc~l
������I���c�(����K"��/��R�~��ߥ6����n�����B�2��{�_�m�_.e��b2J���x|���Z����X?���96E� ����z�Pn�J�����{D2R�B&��M�	
���ݝ�q��.X�T�}��Ŗ��܄�c*l�tw�)���/
��;1IYj�&�Lf�IS������-˗���[-x3+� �!��^7K��$g$�:�m�*)��c.@���܏�#�"�׌�l\��}/1� �����&v-a��鰔&��� a�ʊ`�Ǔ��Ex�$tf����`�l�=�&۔z�����4U���_>|��������_{{в�;ݗ��4Uĩ��8,c*�S��?�-՟&�	gԀ��_�2��0��0{98���X'��I��C;Q`�~e}3������]�����FgYNp����] ^�e����o���AL��%ay��qW�i�r�[����G�j�q����lXN(�G%�'�;@�q`���g���np��¦��t_٠�{�=\	H&���ٱ��g���'Ή��d��@���{K c/��N��'���kW-ɐO��O�V�x6'T�����*��������Y&&�>'\#-W'�Z�'�a��A��6���K��|���7Y��e�ߚ��N\�鏱��㑺[§3tq�>,D�Q���	"�`	2�\$����s�)���t��*�Am��@@����]%n6�p�~	Y���pf���7�s�_�zn�d�!�Ӕm<�ib�,����bB7�s��eڔ�lەϒ4�g�n펾o�+s!e� H�q��2����N�!�O&N"�$�ߩ����֡�%�����ؔ Z��W��\�E�j(j�k |�:$+M�ޤ;^Zt�����5�/�(�iI|��`��W��/7mJ����[�g��f��^���@��$�}7�����������!�H幩-s����:�:H�ֿ����t���/l�n�9X�!oO��|�t�S�!vP����B��ۧL��.�R����͜7��^u�C���)��0����d��|�^�}��˟��������: �d�����U��ȢI<`�;j�}��p�4�Ҧ��t?
��,����{ݍ�:C\G��f���s��b��4�<�{8\�ĉ0�I4�.=h�0�}�:��j��,��R�\yE��c�N��H�I�݈��9~e�L�>�P!	��r�s���C�5�'�`j��	u�=:���GS�ᱟ�	�R������2l�b���w�F�Ә�[	���
���F@n]܈g��]K�'��%d>��0K�8��)٦�S��]�K�j��ϗ�{|B�ʹT����f��m8��r�^C}~���0��9�1�� ���f�#���Œ��<�תX������M�ӻ��c���E��OI�e��j<j�t!�jOq{�� �c���s,�"d KSP�U^B�>Ӕ>����< �m�[7��K��dA�T�����p�Y�s.�?�i�'{�,4�sT<�ɰ�-�(��
FU�Ҧ��T�}����cn�f��@��r�#��֥�i��$��|<��
��|�s�/����S+�����O�ގ�GB�������/߫�����Ƴ_Vm�p�|���W�|v;�ǀg���	�t�e�΁�^<���3PI�O�����kC
�d8��1��)S�e�6Ｎ��u_����h:�ė_G��@�n�`���9E�_RQ0}�3[iI�0	��@] Ôr��m*B���f<��O� (�r*L�9'���7��L���x���	Nd�	J��!N�R������t�f��W8�
�Y�e�j�/W9B%�ԉ3����r��sL�?�[���c
��Țk�M��0x}������f���U���0iE�9�7כh��Q�9�� 6�Z���$uv�t��ۤ�JbqV���0���Szǿ��pg��7�o���M^?�YV��S�����P�h�V��|L�%�|����<K�8�����q��������_���1Ô�������-҄�����k��
��Y{����n�s['�+�Q���k�a �aJ���r�R<w��W�:4A:�%�4>",�5@R�Y�f����ĉk��t�t���zK��l@��v��\�M8��:7��&sr�::y����a��^����k_����I�����T0ig{ݨo��P�^�;۔v�y��y1��z7��?]������4u좣�X`%YT�/(����������IZ�,Z���QZ��� qU��90����m�����X����9�D�p�������(Q%���f�"�[ۨ0ٚ��r�t��z�>˲�������y��3��A��:�!J0�p�9~�����<B�܎*\�2�>�s�s������:�J�FO�L��\0j�^�IA�kx��9Sz�{o�Y��>][?��OT��^Ό��i���H��q�1�(f�K�� j�}TIҷ.R�YpR�#�M���+����W������@~s�$a�[,��ߏ����6��Pҵ�h3���}B�k#�2�����������Od��#5�{�$��Wņ��� �Zb�)��+����]�3����?6��s�{��TJ�A/ԏ�.����Rhf�^̙�93�ٲH���+�e��7�h��7&+���)�J��h��P�,!զ�%�#��8�w�����f�;~��Q�:ˠ�?�N�wP�WFI�	Bր�d���B�?���`5�{�b��	�r����j�&�0����{�SR䛛�l��+��k� H�Y�>J�ҥA=�%깇�hu雒�j��
o������tw���T;ψ��܍?�{@/XC1��k�V��c
�fc���46	|�ʦM����,:岽h�]�������nKz����sNs���Y�_;=��ӄ�	�#_8�ę��)?��qt�����A���H������L�#�M��iW���Z5�L䄲�����j�U�ޔ�s�࣪�����xi'"J����輻.�N�xR%R��p(L2�<�iSz۝���"dӫ��_�X��	��hJ|��A��F��ЄCĎ3�'���#�m!��R�9���E��)��;_��à�k�������~�n4�H(w�kݎҠ,�cS�x�qۃT}��;�f����h������J��{Ҽ@.�{�5�~�@XC�ч�{iS����f:�_�*�ݯ�w��f�nэ�N�,µM+*�ΞE$Y	����"ԉ�� Ǝ��#v�� �u~�\{��2e�����u��^���Н��OX5���6kh����)�����B��eK78".��aN�x��Ȕ:��o�u�jƮ�Y8Y|�|b�V�����|�Mj��,��� q�r�	�������Ť�E(�R��a���ܐ���c*�<K�\�A�ɼ�܆{S���7�~Р��]U�u�t �	�od��}D����sR���R��^��`ԧ_qȴP݃�xī��v�fo+Cv��)$s����
=9���BKS�'��w����)	Bc10�2��@���o��qI�_�)}�_Jϯx�_V�ˆs����B�\���߃�~C����,8�r��aӴ)����[昇<����FTE\̕Ru�q0�m�8'��V�r�|���i�S!�w��`����ZJ���`��Ҧ�����^�|��������J@آJ�K����kD'cM��8��̢�e,ID�H]��϶�P��7ߛ�*����נ�
p���7�+�����1�1iIjN�-F��� �q��-3�}���"F�!3�=AX�������j�ټ�m�똧�7���� �[�ǎg� �]�^PV�!4{��iu��rо��VLr�ҩDe�.C�'Q{�4�j�fW^-�x����B���G<    '.�C�Р:�I�'S8��#C��,D��BҔ�R�,��\��$�_���h,d\@q����&���8��6���s�a���y�]�#s�ț0{��g	�� ǧ���W-d��r�B>dⲘ����#�bs|�j;�*�',��Sow~~&H�u���Z�����7W�\Q�*@J�ଠA,g�h�;��لT�0����~��Jfn�kWYk8~�0���)շ��ks�:������}�Wz��r=W��Ǉ���9 j'f��ïLV}�M��o?���]�T��>�5�Ns��)0K㨞).xO<eJ�3N�H@)ǀ�������8{�0�����6ג�P�����L��T����^g��(�?����]�x]sJ�>�A��K(B hŪQ�?1lI�E&��1��s#��Ω�:�WPp���H�В>��m2��}�O|�#��O�}P������?�q䲩�2<O���u���Ϧ�$�+Ӕ���NQc��j��/V��?�e	.OA\��L����/�Dr'���1"䱶0p��"����iJ�T>�-�E�p���R̠�QJ&��UPy�X���W��
7^E�_�
��2�8e��U\���(a��Θ�j.�B�[P�ٿ���W���
���-؅�e���WkP��o�% y�P�H��j�B�[	�@��S�M����*���0ج� ��+Y�a�\�v�@�IY�HO���� ���q d�b�C�$�;��?;��j��%}�MUy��"�\��.�Ƿ4{��"!:�k��F���_c$NKh�c� ���Qʒ:<�o�/�����(���:E�j�P֩�~�RK0�W�����S�S�P1z �0�����:��RGwwW���e��*��/�~�>_5���k��|p�,.�DQ���n�TA�ׄd�o;m�p�~���"������8l�y�u��q· h���SD�R�ĉ�K(�4"���C8rR���M�D7��{��}4b!�s�_.�죃@e%r�}. |�������1�r�΢�Y#��5デ��DxN4�˹Ǽ��L��pEpa����	��ˎ�숨��/���¹�NlG����[�m8�����aG\dpjJS_'�G~�V����
&�H�=����&Rߦه�ב�ŒO�����\�,9�E+���B���\�Q0��|e�@$������tE<e)�$��S�-�mL�uҔ*^>�n�k(��o�ڣ�W����:��~}����oᯗ�����r��n4�N�c���c�l���\�5�aJ�zϔ|_U�n�>_/��ڼPP�'����u�}K��ݷ�2�;(� Y��ФN^�q�s�c�������D��\\ ���M�oE��W���+�q�� T��$g�M髲uWc�T�:O��N��y�@T'�'I�Y��/-���.��΀N�8����D�p�rsE��зV\�W��)�p�^���DN�X]����� ��<�**�a�(���C����^/a��pL��|�im?).�̉�QR���f/(�?�Y�Td��[�� t��\��a9��F�Y�sy�ǿv��\�H2�pPغ�W�)Kꠜs�(��Qѯ�.߂������\���\��+�W���J�Wa��5ѹ{Δ>م��3R6��l�[+��u�0�(d�4 eG�s��?�"G��'W�thdY��	o��� �2+�w���������������v��������P�_ѕ�=���,t�?󮷿"�8�ەT�|�^�,��+�O!�AK9Ô�ۓ�W�xqSP�����D8���f3D�#���2*� u!cb�S���6둌�d��k���wl'� ����f<����O�����)�����p;���P�@̔G�4�χ��{lst�v��>�Oz����M
�����x�B���t?o�����(������U=��M�R�%S�&���iS*n�{l����M�w�p%�����q'J�,�<�͛r���{'�H�lH�E�q
c���x�c"f�I='{���6���!mx-��[gH����	����W�I�,Fw�C���?^��nT�{t��m%z�r\�9G�c9zu*��嚆�>M}�p�U>iJ'���m��uSP��B�~>�)�
H��\�߭��	��
��IJ�D�γ	�έ�{���ߴ�`#�����#�$��~���p1�ϝp9Y�6�`3�y2Iת�>MOc��ry�� ��˅�x��sdr�C�]���"r���a��D�
���ֹ`����z�/a6���o���?�Z��d�_@܄&Ę����H��iJ_����W.�����n�_w�FtSIvr���<NO蘠?���n����e��Il�>����(�n${�!�<}4UC>2�����jT_z��W_�-sN �Lq�y��a!\���5���u6�0�i�3�@!�"��:���!�qcbb�iF�7R���b�t�)���I����ћ��xp�}s�V�����.XNaB~�{��_	F�\2����?t�|�/�
[���B���ǔ�����?0��Sz�&
����f6|��w��D��拳xfT
u��eD�{���P�Q{0�݃�OLorƔ������E����D��ä#�{&��� ���Y��g��R�ˢ�>� �k�R>�)VH���b�#߿K�˥����\�m�Q	��;�{Gg�p	���ga#`�������CK���n��|��{V���)u�Ÿ2�¯w�Ȫ��ob�\��(���|��e�3�Դ�~E�7���ߞh������W�		��gڔ��Ny��zȦҿ�UVt|�Q�_��!�㨎CK=YI��ff4�xg��Z[(�R0��P��?������)}�/��=����J��s����q���p��>��q�)�N}mFܢLF���b�h��e�#��<3��b-_1U�����W�}��#@nR��Oӱ>ؑ��d=֎)}MA�, �Y��,ʸ*$&�%��� ���+�N����x�"�V�孳tnH�\G�uzK�i_�_`&F��hP{���H&^4ֆ�ҥ�Mp�ك��뉃Þ6�{�p/��>���W��W��t���}���p�CP	̊	r[HS�j#�y5��GG�sR���T,��#�-�-ܖ�N�҇�{��J��:�3���4��9� Zѧ3�{Y?�ޟI�4�n�952
��	Kz۽��eÐ�V*�=ڟ��h]@4��WP��e	3�O���΅gT��bY�|Ǟ�oIX�ۭ��c�gO��]�Pn�n7ur:��������p����]����HE-�Bu�����>��������YY�c��C���BW�?w%��>?U�W��É� �@6^֟���Х�X	.����,�#+�X^��>�� ƌR����`�C�G��,�aJ_�r�*߆������}6x�P@J���(&��C8�;x<������UN"�D���3[a��0fY�>�������˴�0y�y~E�YNxD�ٕq__��I�W�@ڃ�75z �E�8�%
(=1�*qS�<�U9��O�N��K���P�c|��n>�˛�2ބ �@��B~��!��JG��=q��K՗AlЕ��4�Ӧ�6����n��$���1{��H����Z^���p�������.��@g;���a�dX��$���)��:<'<�>eJ��%�,���J>��yP�i9;L���"���FJuN���T�;�
��1�"�-GqaY���ApkN����DN��t	����B��x���0�.F��'�_�{Bu��9(_��1,�9�OзPČC�ǽ$��6T\sh�nqh"'��%g���N��mۂ�7�'���B ׮E�8Pj-}u��a�o�DlPK��C���=B�cSzǝQ;�4�2������K-:�w�kc��8�A��ZC�J��i�3���Dr�Gw����8L(��U���7;xc�&/{2���Z0�C��=/
Q��*�S�OAGA�����~���p�    e���{�oϕUZl��A:m���!7mJ9_�y~��F��J��/K��*:O�R�s�Z��w��Zr���':I�v��΢�t��`Y��� S��H��g�R�Iq;S��=<)��G9�~��4!7�I&�>�=�f§c�
�*�:~Wo���iE���9�	�Г�T1�؜��K�[�Q�x��%c���[h�x�+�M�4� A��
:k8�j�wO�����Y6����,K���^��@_O7�����$􍘯�Xv<A��R��K�����(	=q���~k��,��]u��m���G��(�<w���&�c��(��_��(�&�OQ�����L�aڔ:+���e�h0>���]i��)Jf�%���-���듦���q$r�_z3�gyH$���oุ��=��$�U�ʇ��8q3ʇXe9E��7�����%�����1y���_�����=8�t��$K�Q�H�YS����h�<;���Voa�#��0ߍ�+P�(�e�8��\�"�&��+C�'@KQ[k>eJ_����u���4s��H�=Ů�z-U�=ח�E�a9vZrň��?�
�.{z���jS��x�c
t�5n���D���6��yNb��A Em0��8Ӕv�^�UC\Q�:��ǟ��@���-b�K�����N,�<N:C@����?q0�4�"�APtA�G� ���ʚL� eHCe���N�
y|�n��a���t�b�0l��#K��${�>-^�J[�?����=����lO�wN��%����c062��)�k�yo�?���e8��>���ԧf�
�_����~��W����8!�UG��"ܶ�	r� YA\�
g�Ǧ���0d�� �bp1������z���O��N�1����f��e�3s09|u�w�=)����(��QW�u0  �b�F�^t�)�|ozO�ml����~�}l=�H����:X7@����h�ۡ監�q��(o:�KGEi�����l\rB�2����)U�+z7��S�8�-�o�:ʻ�ih�����/Wk�� 20诗7�p~�|P��$�)�h0}��t��L�D]�b�Q٭=�Fϯ7�k�»�������"j�"�uG��/�h�R����0
'{���S�O�5G�XT�WK�U@�� ��?V��zZB7)�J,s[�F T.�j�0����6��^_X궛�������԰{� ����J�f7<t�?}�*H	�W��|��B ��PYL4�qB�w�ս�1e=���p�/���4��v�_v��P��h����2ߞ�V+���������s�V�B 2�C� d���h��e���t�����ۥ���!��S&pF�I���<9�cܵNo����u
�w�"h�}h"��LS���������4�w�GEs��zʤҁOt�W��(�	*�2ģH�#*ӄ���ę��!���
�Pɒj�)���B��+��kU�P�g�U�ר �T�K�R���F˒�>��S�s �:�V9Ôv��������p����^},���3>گ:���F���?}�������L+��ߌN��`�E@�#�Zy!��FXҔ^� �7�]�y�vrU�`b�����UN'^��vr��	�a�Rq/�!� t��:X�0�)���LS�����[L�P��i����j]�`v�\�AM��t�cJz-���#wz�?�뀋X��b$v���p�E�C|ʒ�]��6��	�n<�.|��
�H]G��:#�5A����vP��	� *�<�7�HDp@\WZ=3T��L.K=�6��]�&olF��1k?q�0�2<����ߥ���f	�;�L�A�x8@�y��>�c}�ۘn?[���m��4�OQ"Q�����=�JӦ�"�oǏ�-��j듖��&Z.��@������~} נ�.M������0�T�ʭ���E�����@�0Ô:�j�E��	:n�=�V�@���GEB�U�ewӛ@t�P;�O�7\��1��Ȓ�����/DL�yʔ��������Q�Y�|,�����~͍�>,A��nv7Ee�~=}�+O�J�V��NI"2.Ƥ)}v�������igu_��ӫ�� ����(�{���4�xF%آu�v�L��.GX��ǹ�)�������퇼߱���l1��\q,��H5�/[���s�:д��0��u�k���|F3M�&ջ��lnWM��<W�x4����GK<��o���x��J[��~ٗԍ,�������S�L��p�8,q���wo~���0Z�ס�j�$��K󮃋s��*8�r�ԉ�j�P�y�'7i:�%iu�ի�C��M7��<���Y�����uU~P��m���Ĕ\4��b�dGT�3L��M�����
O�?h-e����B:�%��z�oVGf{��{y�K�B3�8'~���VXb��3�\T�2g�9�J���%[���X0,�eɅ%M�{��y,}�$v\d���Z%Oc�ٖ��:`]��9ho��Wq�./�x�ǵ#U��X�Y�"iSz��������l��,>ڈ� �����$�s
���~?vg�+�~x�,�s�b�\����C9#O�R~�7�7ąp^�:�Bk{���f��Gɣp0��F�:�q�/�g��*�C �bP�D�=7hj"�!	XP�6�Y��Mkj�p��^��f���p�B������R|�SåA��k����{�g#3�%���_Y|�f�������3���F��m�^�}�P	�SbD<��,w�� ��(�(Zt���:�TQ݊x����Ì�x@���$��ҦT�M��-��^�9"�lW�ڮ��H�ӷ������揗�l��Y;cN�2�G �������	a��,��((P:�.�k')�p�C�wY�^N���{�'��z�j>M���5�y_'����_�r�%�2�%��=�
!�t�P���R��Y���@%�;.���*3>�v=q>&�V��l��7�ѷWq��Hss٘]�#�7 ��:Aw��Q3�����9+S&�d�F��{��}zO��*�5�N]he�l�w��+�{����$�jl1T{ /%j�:�2z�=�_��I�l�s��w�5����6/Ne�L?�1����9@bU'qq̄hH��n_T82�ρ��j��!^(:���C&žN�aΠ.��F�y���Q��q8�n�B A�c�
��
�E�L��f��^?��Y�N�;�5y�q�N�-��}〞�݇P�k��z�SD�q8�@�������@���Ѩ����y1�2m��q��ӷ�v�԰S{p?��&���oI�[,�E�T�Mo]��z1K���Ĩ�_�+�]zvs�\Fx���R&r�T��.N�;QK��$u�j�9@V��Nԙ}�ҁ�t3��C������sh��u�1��4�bU�0\~ӈJD��7��˗�o�I�`@I���E�f��PJ�Cl3`p��sWR��df�VR1}�e����kFz��k��]EE��l��bR���W(?�s7zϡЄ�9���'F_yy:�g����oE�:��H�����8�GGJ���i�?^���T�6"�b� �a�A@�y��\^��e/�m�&E��!Ι���i���Go�������"i�T�6'M��A2s���[�D�!�mO�	�(��8e��������R��pA�����c�R�xG�r.������_m6�k`�6�w[�HZ�#�����_@��g�&ϑ	!,�B�ƹ�� Q�aJ{��^6]��o�;����"@���1���w��6�O��A-R������J��*츾"����側2�lHo_��6��1�l[�F�ĝ��ח�|��&^<��`�@��;�`�̿tf�_Q���L����b)ݦ#S꤈����Ҍ=V�N��ϫgιD�ſ�a~���Ӧ�rH��1�!�I��?t�W
 E�l���*��$����!�,/b�T�j�y�)NT��uڒ:�b��_7C���H^C��f5p2oO3����48Vf�����    �#*7�Ɇ�� L�2���)C�)c���_7ȥ����-YU��.xA�>�{N����u��Q��br��3�����pA,��#���zjP_л�gN��;ߖ_����j]�'?�^��/O�*� �= �4�%�u2U��n�Jb�t��f>ϸ�E�ڎ�����G�mJ_3����{��u�7�U�KG9�<�	�	���ˁ?���Fx�7B�--���z,�(�u����nf�wx�P��u�~�G�P���LI��%�����
'�p�z^��S��t
�ar�Y{|�ợ�O((�};�Մ9I霬��b��Z���%�):������U��)ѫݿw��`}�]��T��.s(��
��"��W��ĵ�PKx��l~(�c�]��vg��>+���i�DN諛宦y�-�Xp�)��$6��2�RϦ�&:�0�"؅�$�>4Iv���������%�/����E��/a:?:�����!=��=�s,_����?-(댙�{]�lS�e����b�k^�o"(�ꜣ�:�98P9�#�! C��I0BAJ����߉������pU� \��AN@#ы���k[N]G�Ϝ�p�<����-��yB�$ j�R�@�pK��Gݲ����}���~K�j����Z��4}ڴ��}Z�>'��P���e��>��!^�/�jw��f&�2��9����C�����[w4$=}=դ�����c� �'Z3Mi���k�@��n�a�x�"��Zեu UX@�\A��U,I"4��' �C�&A܈�4����%��S��pe���Ç�G���Q?ΐ�j����[�JdTaBj��M�=��Q ���C�+�+A���F�qʀjY�D+����`��^Z���
����S���͏�輺O=)�<���#�4^�!��K䙇isی{��3W�ɋ_�\��ϙR7����1����x¾��A	%@�l��o��C�^u�y4h�#n�S .�QJ*z&�>Dg��
��5Ӕ�ޝ�C�Ub|3|��_���
� 6MRa�n���Akn<�@��kn$��#��ll $a� b^�S��-�v|���la�1Gw�Ѷ������U�gg��~�W��ҿ�W��$������N��6���>'$w�-�X���7�%!�+�e�(L�;x�d�ȜiJ;~��{x��ŵ�}w'g�Ў��Sw��Y="��h��T��g����bjXN�8��sRAs�*���q��Y�@ק�m�(/WŎ�rR�����(�@�D����/�%h_k���Ȥ�����~CheM3�*wK�)�ɝ���Є�ύ��y��c~m�$P)%��{�-@�0��/<�sU�@0Q���@P��&'!3M)����۰��}z��!�c@�è��Ʌk@S��b�1�ǘ��#��=y��P��A���Ȋ�
"�xhI{��\�nBT���&¿���vl��V7/�w��?������[ �VC�yM��y�0��U{>OPs��#�_p�Ğ2�8\ލ�C{��|�x�k�ru��;C�t-�����͍�&�X�}Te��j[� +��Ha�D �4�q4�V��W�u,y��)�fx�;=��;���;�l�c�oy��DW"x�a5`@sb��2<�� ,+ϧ!�v�m�9�r?��"�3#	~�S��6�rY�u��Q9�}0U�H��H]6��^ �8�(��Hz1�s��ɱt���O@Vd_��NdO�&���G��}/�0�V[E���֡�����Dg��9�ƽ���-��h�g�R��9���0����Ik$�:"�NoW�7
�D�q]�c�q�fH|�C���ӝ?=���9x�����}c�e�#�aT_5<ǣp�b�T
ZDe{��k�d�@Ϣ����܉��d��lS���H��*atwsK�����,�ƅ��~�W��� �P�7���)�[θO��U�z�W�?�[�n$e�'�HIT�KT�n�I��K����%�^^E�E��V���zC*c���s���-I����<A�xD��-a���9)�@��7�2��W{�4#��W��FQ6�"�p꣺ظ��$,A�����1��*���ÕJ65úFa��S5�Q8��2���e���]6Ab}H�L��*B+C��#����g���A�6�y'Kl�R`�����D�*�.Ä�9*g��43Β���M�D���7@��A�� �I��]��8͗�]��Fo�����l�.�'=1�$�ĺ'_�d�bp��ۋ�t��e43,f�@�I�iJ輪��6p?�_�P�f��XVQ��V�L͟N`|p�s6�\��5^��t��#b �LUP�,\yҔ�9XuK��`�Qq��*�XQ���*P��x)�!)#�w�ia�(���F�G8R)�0$�́�FK��8�sw�Ag�Gi�q�� >�?Vo���u��~q����@B`+�a�Ԁ�?.!k�"6y�i��&�X�F��!d��� ���9�'@晦t`}%Cg��	����U�z	���mLz���*����V5UUe�Y �}�Ok��0�'ߒz Ruء�iSƎ�g���oZ��f�b���҃�'/@�s��+i�֐���F�d����������dE�*�����C�ّ�'�����~9x�km.�3�]�|�Paĥ���ѴW`�Kt��Y�d�~UG})�/�_�c�騣Q�G���Zm⠺(�HP�E������o�}l}8�]g���p��UW2S�f��U�8ޚ�҇A�쩰}ÃKi�ELdb������󦴻�a뵤<�|}�lX�c�'}����t�b�����j38�|	p4��Yª���C�[��d��J[Ү���N�j:^yX���fzϨ��VyA�΀���G��p.��4����o�����tg�FPE��9NvAe����Ls!��z3���W|�sݜ�=�Ju7�2��Zy�� ���U�l�ʮ<n6G��e_:����嶁eT��[�/n'o���P��Jk<c� z�o4�"����SD];U�'!�p������G&x��.�l�G���"�_�*O�u�C4��)c�Cj�_��Zk�}}�d��%�u�Hk֦�Fr�C|�F� �1�S�t�d�}?�<��pU���D_E�Em�R�_���"��%���l�pL��J'"bf��CC�UN
%(�Q���2���D�~ɋū)��]?4�/�Ŧ��&��Q������Қ/��(׫	t=ά�S���������?=״]sS¤�<h��@4p��Y�S���Ӹ���Qd���s�u�D��2����HG�=`��I=�3H""���,�!z'=x�M[2�^��g�Xm�~�$�C�%��cD� xn�cu�\�]1�����QN��i���]݃���a�gH�Ԕ��F�KjF�PF�"�_�i�2�MMv�U2����z�NPY�12�"���FT�E���g�" $��g�E�@9��t
z2$�\<eJo�����5��n����ww��]�����#!-�4���ԇ�����VZ"g�\VƲ��L�D��W�wZ�f;��Z�S�p��ߞ����ϩV 5��hĴ<G�]Nخm�*��l���6���ާL���]-�.W�՗����03�P�h�Z*`�면��^t7&	�~�;ZK7�YE��t���9��S�>����z���v"�8He$v��0	���f�Df���ڵ�n��*����:���r��Ṓ&&F����HJ�d���h��j9,/n*B���$&�@ ��(��j�+�y!Z�	s[�"˦�2��s���,d���t�ǅ�)�o-D�/����J26�f)��0"7.$87�l3m�S��3K�ߚ�ǃ)�� ]�j�_ۣ���?^�UVP!6ʋ�C)����a��2���W�<�8{y-_��~�IP3DpP��D`k���%}pDzL7P��r�X��\�C���Ǆ)�[��X!f�)�����+v��װ�ɨ��oW�^pIq��OUVQ� m  �Zd�u9	�խ�A�`�UD5�l�&4��*���@f���v{X[���������4��������7��� :�2�39�*�刁k��p��0S�©��wA�)�B���qP�m������&��U8�wk�u��:��E4�?9�y�X��S�B7�P�
j�V �z�k|ʔ�3�����8������a���C=�9����sU����<iJ�3�Ku�T�Ǯ�a<�L��gp�&ޥT<7R[ƴ�p4'(�"Cz��'���ܹ��b��^\o�y���&H�L43��>�g�crJ����=�tŞ��5ax�`�NH�d�{���M��h�o[���`�),F]����8�p��r�L�-ufA��� �U�C_]C��T��s��;y�)���S���f�}�#�>L��	����g�@�yq_{~�|�p�#\UyB��ٸ?���bO��dV�`���{"Є�����$#%N���Uu ���7yr��`��ȪQ~U�Z��w��3P�SO�/�E��=U G�GB�a}?2�R�0��$����p����ᄞ��8􂥧nZ����s�@�!��*_��>�o���O�?��/]O�      )      x������ � �      
   �   x�}ι�@�zy
Z�wY*Q#����'^ O/�N��4S�g���,��qtM�LC���NO��Su����l�r뙈�įpT垓�b9|,��1�t��;e(F����P�"̤ut̸���c�֑��D�&��p��[�׮��ʱT�/�i��|·�����9G��'�]���7L�	�d�������j�_U�%Iz�O�     