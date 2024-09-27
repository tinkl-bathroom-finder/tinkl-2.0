PGDMP     
                    |        	   bathrooms    15.3    15.3 >    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    25463 	   bathrooms    DATABASE     �   CREATE DATABASE bathrooms WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = icu LOCALE = 'en_US.UTF-8' ICU_LOCALE = 'en-US';
    DROP DATABASE bathrooms;
                rileyalexis    false                        3079    25588    postgis 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    DROP EXTENSION postgis;
                   false            �           0    0    EXTENSION postgis    COMMENT     ^   COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
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
       public          rileyalexis    false            �            1259    25519    comment_votes    TABLE     �   CREATE TABLE public.comment_votes (
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
       public          rileyalexis    false    222            �           0    0    comment_votes_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.comment_votes_id_seq OWNED BY public.comment_votes.id;
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
       public          rileyalexis    false    220            �           0    0    comments_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;
          public          rileyalexis    false    219            �            1259    25559    opening_hours    TABLE       CREATE TABLE public.opening_hours (
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
       public          rileyalexis    false    226            �           0    0    opening_hours_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.opening_hours_id_seq OWNED BY public.opening_hours.id;
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
       public          rileyalexis    false    224            �           0    0    restroom_votes_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.restroom_votes_id_seq OWNED BY public.restroom_votes.id;
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
    place_id text
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
       public          rileyalexis    false    218            �           0    0    restrooms_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.restrooms_id_seq OWNED BY public.restrooms.id;
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
       public          rileyalexis    false    216            �           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;
          public          rileyalexis    false    215            /           2604    25522    comment_votes id    DEFAULT     t   ALTER TABLE ONLY public.comment_votes ALTER COLUMN id SET DEFAULT nextval('public.comment_votes_id_seq'::regclass);
 ?   ALTER TABLE public.comment_votes ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    222    221    222            *           2604    25499    comments id    DEFAULT     j   ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);
 :   ALTER TABLE public.comments ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    219    220    220            5           2604    25562    opening_hours id    DEFAULT     t   ALTER TABLE ONLY public.opening_hours ALTER COLUMN id SET DEFAULT nextval('public.opening_hours_id_seq'::regclass);
 ?   ALTER TABLE public.opening_hours ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    226    225    226            2           2604    25543    restroom_votes id    DEFAULT     v   ALTER TABLE ONLY public.restroom_votes ALTER COLUMN id SET DEFAULT nextval('public.restroom_votes_id_seq'::regclass);
 @   ALTER TABLE public.restroom_votes ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    224    223    224                        2604    25481    restrooms id    DEFAULT     l   ALTER TABLE ONLY public.restrooms ALTER COLUMN id SET DEFAULT nextval('public.restrooms_id_seq'::regclass);
 ;   ALTER TABLE public.restrooms ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    217    218    218                       2604    25468    user id    DEFAULT     d   ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public."user" ALTER COLUMN id DROP DEFAULT;
       public          rileyalexis    false    215    216    216            �          0    25519    comment_votes 
   TABLE DATA           _   COPY public.comment_votes (id, user_id, comment_id, vote, inserted_at, updated_at) FROM stdin;
    public          rileyalexis    false    222   NR       �          0    25496    comments 
   TABLE DATA           v   COPY public.comments (id, content, restroom_id, user_id, is_removed, is_flagged, inserted_at, updated_at) FROM stdin;
    public          rileyalexis    false    220   �R       �          0    25559    opening_hours 
   TABLE DATA             COPY public.opening_hours (id, place_id, weekday_text, day_0_open, day_0_close, day_1_open, day_1_close, day_2_open, day_2_close, day_3_open, day_3_close, day_4_open, day_4_close, day_5_open, day_5_close, day_6_open, day_6_close, updated_at, restroom_id) FROM stdin;
    public          rileyalexis    false    226   �R       �          0    25540    restroom_votes 
   TABLE DATA           m   COPY public.restroom_votes (id, user_id, restroom_id, upvote, downvote, inserted_at, updated_at) FROM stdin;
    public          rileyalexis    false    224   ��       �          0    25478 	   restrooms 
   TABLE DATA           �   COPY public.restrooms (id, api_id, name, street, city, state, accessible, unisex, directions, latitude, longitude, created_at, updated_at, country, changing_table, is_removed, is_single_stall, is_multi_stall, is_flagged, place_id) FROM stdin;
    public          rileyalexis    false    218   Ȋ                 0    25901    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          rileyalexis    false    228   �L      �          0    25465    user 
   TABLE DATA           �   COPY public."user" (id, username, password, is_admin, is_removed, inserted_at, updated_at, reset_password_token, reset_password_expires) FROM stdin;
    public          rileyalexis    false    216   �L      �           0    0    comment_votes_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.comment_votes_id_seq', 1, false);
          public          rileyalexis    false    221                        0    0    comments_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.comments_id_seq', 1, true);
          public          rileyalexis    false    219                       0    0    opening_hours_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.opening_hours_id_seq', 466, true);
          public          rileyalexis    false    225                       0    0    restroom_votes_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.restroom_votes_id_seq', 2, true);
          public          rileyalexis    false    223                       0    0    restrooms_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.restrooms_id_seq', 771, true);
          public          rileyalexis    false    217                       0    0    user_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.user_id_seq', 9, true);
          public          rileyalexis    false    215            A           2606    25528     comment_votes comment_votes_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.comment_votes DROP CONSTRAINT comment_votes_pkey;
       public            rileyalexis    false    222            ?           2606    25507    comments comments_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public            rileyalexis    false    220            E           2606    25567     opening_hours opening_hours_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.opening_hours DROP CONSTRAINT opening_hours_pkey;
       public            rileyalexis    false    226            C           2606    25547 "   restroom_votes restroom_votes_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.restroom_votes DROP CONSTRAINT restroom_votes_pkey;
       public            rileyalexis    false    224            =           2606    25494    restrooms restrooms_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.restrooms
    ADD CONSTRAINT restrooms_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.restrooms DROP CONSTRAINT restrooms_pkey;
       public            rileyalexis    false    218            9           2606    25474    user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_pkey;
       public            rileyalexis    false    216            ;           2606    25476    user user_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_username_key;
       public            rileyalexis    false    216            Q           2620    25575 +   comments trigger_update_updated_at_comments    TRIGGER     �   CREATE TRIGGER trigger_update_updated_at_comments AFTER INSERT ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();
 D   DROP TRIGGER trigger_update_updated_at_comments ON public.comments;
       public          rileyalexis    false    220    233            R           2620    25576 7   restroom_votes trigger_update_updated_at_restroom_votes    TRIGGER     �   CREATE TRIGGER trigger_update_updated_at_restroom_votes AFTER INSERT ON public.restroom_votes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();
 P   DROP TRIGGER trigger_update_updated_at_restroom_votes ON public.restroom_votes;
       public          rileyalexis    false    233    224            P           2620    25574 -   restrooms trigger_update_updated_at_restrooms    TRIGGER     �   CREATE TRIGGER trigger_update_updated_at_restrooms AFTER UPDATE ON public.restrooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_restrooms();
 F   DROP TRIGGER trigger_update_updated_at_restrooms ON public.restrooms;
       public          rileyalexis    false    233    218            J           2606    25534 +   comment_votes comment_votes_comment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.comment_votes DROP CONSTRAINT comment_votes_comment_id_fkey;
       public          rileyalexis    false    4415    222    220            K           2606    25529 (   comment_votes comment_votes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comment_votes
    ADD CONSTRAINT comment_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.comment_votes DROP CONSTRAINT comment_votes_user_id_fkey;
       public          rileyalexis    false    4409    216    222            H           2606    25508 "   comments comments_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_restroom_id_fkey;
       public          rileyalexis    false    4413    220    218            I           2606    25513    comments comments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_user_id_fkey;
       public          rileyalexis    false    4409    220    216            N           2606    25568 )   opening_hours opening_hours_place_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.opening_hours DROP CONSTRAINT opening_hours_place_id_fkey;
       public          rileyalexis    false    226    4413    218            O           2606    25581 ,   opening_hours opening_hours_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT opening_hours_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.opening_hours DROP CONSTRAINT opening_hours_restroom_id_fkey;
       public          rileyalexis    false    226    218    4413            L           2606    25553 .   restroom_votes restroom_votes_restroom_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_restroom_id_fkey FOREIGN KEY (restroom_id) REFERENCES public.restrooms(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.restroom_votes DROP CONSTRAINT restroom_votes_restroom_id_fkey;
       public          rileyalexis    false    218    224    4413            M           2606    25548 *   restroom_votes restroom_votes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.restroom_votes
    ADD CONSTRAINT restroom_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.restroom_votes DROP CONSTRAINT restroom_votes_user_id_fkey;
       public          rileyalexis    false    216    224    4409            �   6   x�3��4�45�4202�5��54W04�2��26г44416�50�/����� �pE      �   <   x�3��t�4�4��LB##]K]CsC#+S3+=K#s]S��\1z\\\ �no      �      x��}ˎ%Irݺ�+�Ȁ���n"��l� " � �Zh7[��!�����{�͏{�{3+oVp�]�Y'�*O�5������_~�ӿ��_�������?��?�����?���L_��w!������?��o�������_�����˿v���������@���_?����_��ߤ�7��E<�?��JJ(�"�����we7f�VJK_���Aa���I�k��
d�j��Y�����Q`��߈�D�ʤ���!-��1���&&à�Lx�fz!j�1~�B4��lC�J9��h�����>&�ٶ��J�Dv&���;�ޠ �ۧ�7�:��J����y��]Nj�D��MK��g��R'���>�Kz�BԆ>���>�郠N�|�&ҿz�:}^i'�)��n����t���F?Q�S��J��D��M�TZ�C��ri�xS���Τ�W���W����Uͳ���j�oBv�y��[����	3���3ߞ�Po�ķ���잏��O0n�1�-��:��rF�h�SX�jwy�1BOw����y@r�[���P۲����q�g�^Q̀q?�?+Y9���z+�i��RQ(7�n��15[�7��	�bVZ����=@�jVU1u~�b�A�&3]��`g��JU�қ|�T���|�K+F�V�~�;Ϩ����v�Q�������?W����rfW�I���k�z���|K�R���f�A�˜Op��r���J���cϩ�PB��I:�;ǉ�԰ǵ��!S��6� hʟ���'�Y.���ѯ��fr[udhп�nv�6.�ط����w���?5�?%ROLܚ1D�dRS;���2�K�(c5���c��°͟2����	g��(��n����GdԬ�>5�/�~
 \��.����rtHq�5�Ic;(��4G1D�3�a�3�ҋa�3m�g�������턕2�7��_�r�[�s�a��r��9Ǩ����b(��ܠ����c��4>�o�����a���ܛ�8g�ݨU���qP�>̯;�n�����bP�aKr!Rö!��8`��i���z��w[\,7�tfߏ*J�&GʪA�\�sxWr�?�j���0���}����_QS�Yt��c�y+픗�zP;W��,�������a3�����G�D�m��*{#6*|+��\M��f��.'�K�ҥ[!�0��5B(�c���!��F���SG�M�w�3�X'pDA��pV�	��@dp�����Ĭ��ɗvv�3��. 
2��. ��,����Vnc��.�}�(���c>������z�'5f�]��~����1xr��޹���h�����y=�i�끰��@�Ճ�O��>����ȳ���z�iPc�Q�ɺ�b�8�8�5�".6�-¸z-ǆ�%*tN=,Q��HҙI=z��nK�m^a�8��>�r3JgL�]3�X��3O���d�8�9�(����$�A��$>xylA�H�'ۡ�q'����Rauo��?fVz��I�cT&y?h\r�ڃ�� :w�����1��Y5ٰ>�Qp�	����9�{��G/��eB�n�F%����Q�#3�z0��oL'�ߜ݆�[�V�WE�I�`�ȸݼv�j���8;��4z����t�X����dcE�	����r[=z���.��v�A��m��gO�Ne&� �'��.��=v�2ۥ���6�2�[�eu����t���r����f)����}%�VzU��}�q����?�GzSj��3���]���r�B��4'��n����\�daw�oO���A���+n�.�g��9O-El#�t'�z�zD�s��|+K1؝�����+��Ӟ����A�7�T�|�%���,p�/dјiB���&��X=
].��R�0�C�^:���]�=m��5J@W��)=�#T��D�ҚB����鋴��WZ�����7��}������,�O�����j�`_f�qla���q��
B���(��wÞEC6��e*�`��1��܌�*���D�|�������Zj]�d\cvWKQ�1[���l]%��1[D�K�%��'P�����0��m�֜��@킵�*=���s�OFgTT�w9��`>�#�a�Ƅ��p�����v�ɏ2���ۤ��34~e���&��JEw��:�_�(�l}�8�ˉ�_��@D�2P�r��LԮ������-�����(��;��:l��l�Z��\��V���3�aQ�2�rp;ǂi��Ҥ����7Ɓ�66M������O�Ǆ3�i������`�48ˮ���ٞ;�[�0�I�ky���O)Ӕ6�'�8�qa5�P���q&�&�'1�hKl[��／������Y�v��1J��U���ܗcO�4P;�=m� �� �CM����F+�����w��W���*e�?�^ܜ��k���Z�l���1b�y����XQx��ih�
� 8��a?�?�os���g��h���X5x{3�QL��<P�,��7f�=�ܴW����ÌW���B�¥ղW���7c���1gS��_,9c�,nwDز�������>�O+'�DI���`Z}ZD��ʖ�.C��岸_�>c����!�5?��b@�.E���IQX=ȳ}� ��� L��j�C�7��ԣ4����A�����TcF��L���������!4�h�3(�X��a�Ģ�X����v
�po�D]i�+�n���;-Uvѭ�]�v)s���K�N&��x�@��m�҆!4����tV�R~e�l��׮�.QJ'���|ѥdf&P�{M0�x�(uT�ԩ!��kW	���>z���ל����*+�h��ss��f�WN�yF:��GO^O��;?ĝ�sO{����v:c���NזQP_��*V��㻭/�ل��/�����=t��N�%�k��4K�G�C���9�毀T������:f��#�QH�K�[pC��My�QF��ry�P겾�Ϩ��-�w��yP�Q�(8D���CX}���Wv��+��]��)����7�Λ�0�^�i�WW��F��������py]8�Gi�+��(���q�B�_]
m㨴�o�xs�9�IVH6�%��M��oC̻�eL���T�q6]����^Vw���d��8�s1Y3�&�s��օ��Y�d��mF�i&��J�E�"5�&�3��#ُ�5I	9��u�9ī�s%<�&���p��*ލZM����΢c� )��]=m��5�@��[�)�����t�������:3�G���㕔����a}�νJST���{{�{�x��'�R��5|�k0�4����LL�Z�{��yZY��(�$�S��5|�k���"o+V2]��~?�-��(C�!ܯ�g���6�K�����~�bZ��kp�T�~���(9h��@n�j�t�a�C�l[$����0�s֐f���3�Sr��kj���,����A�|(I���s��I�PnP魩Y��N�K1
��-ˌ��W{��\�ƫ��5�U������j�z]�VՈEq<!q�AEiM�P���[���k��� �Ӡ|Q?��¡�4����*b��=���Ǳͬ4�'9)d+J�<��5�)%5/�7r��j]>�:i��׻��p�UDuN?��焰�u˫�Ӛg�?!q�F'L�VVZ�~���MD�v}�40��
��O[A�Q
�s�[餇MvoV�a�j���^��>g��ȶ��<1n1��_��oOCJ71�4]\s-::�m0������Ƙ�Y��69�eH��Ü��_��W!�� ��Xm�a`8�n[H�.p����	C�W76v݌?�xp��HSF��f�C��PV䍒�b\�6�kmd?j'l�I��u�̗7��5~�'Y3��PcX5
��K��Y83�+���Fy�M�ӄ{�K�%�O7��qˮ��T���8^P�����[�����J/����ɵ�����c{`0ހ|���@^C7p�[p�3��z��;���'ʕI=�X�n� Ƹ&d����M��Y5s�    ���;�3���d�8�2�bX�t#6F����
���� Vw�ٖ�3����=C�!,�ǉY9
�M,
��~~����xO*�.g3�0���LKv�X���?Crs%]���ɣ�Z�I_���+H�Q�A���Eovگ�H�Hk<�E}$*�٭�}��I�}�馛VElخ?e!�
�9nx_��N�@7M�Q�K��i��8cRZ��F��9Τ�O{j��7�Z˰���1�F�K���}��v��u�+�8[@=#�ِ0|T�ve/vc7�.Zv���|�,�9u�Q�l�U>��lL3���l���(l�?�M�]��8f"��%	��k2��i�"��Ik�Z�']:iL�5������Q�(��UDm�<U!����a �۰�V��U[R�e�H�ΐ5�����ZMǌA�0\"�8C�@���L���X��N�.q�GGnh��n+۪ϼ��!m��.׫y�lk	�M�˨פ�l�瑨W���֢���!��p(����kUl��-lr�z��8�-�:�s�\i�UW�Sg2���u��h�j[�������Ǐ<W�P�($U�]^�Db>�ҪȄ���k�(��cc�V���?1�J��1�ĸ��.�"T���&��	�A���\2㭿�`ƣ��\��xoLع	�p9��)�'��1Z�f�iƵKm=�q2�]c����ӌݥn<��t����v>�
P�t!z�&�
`k���u�Vm���q"<*���1�*wx��g峖��ջd��guv��@x;�Un�R5�M�l��(����u�h,�ƅd;��v��*�S@V��L�r�w~ב�K�7�>rV\s����a��
k�lo�[�W��f�-C)sj��ϯW���;�6���⺋��;�s�$k2)�	��:P�ys�0�V�Q�erM��%�]/1�ޟ�rW��c9�8������ r�DA㘵� �n_/y�E�#�%o!Uo�|>�:��t���X6(���H��y(���H4k�5p�H��-�y����q$}kU��cҸ�{fv�$<^�Y�=��uړ}��%-�k�nf���AI��D��MP�ew%��5�o">���`O��vڸ+� a�.�>`Xu��}p��}L83.G%��ˌ���x�E��־p+;�])h~L83nF����dZ&���x΅4!
jm6�	au�͆41�:�aiNƮ,����1,�q�';�7�o(�q��6�������xƏ
C��q�;�S՞�"�Y83n�@D�:�?�\�U��*nڊ�PT+�d�����@�B��>����0)�㠑���E pjat�9���9܄R��\QD��,z����zf�7�f��!T�i�ɖ�![o&Mm�;o�n(}uC�tjM0�Mk2�p��k͠Z��E�r-�*��5C�i�>�Q/�UE�ZbT�>ȇ� �����Ό;b\݌(�~$�چ���xs�7n��k��؁ ��:;�]���)mzE�e��T��|�e:M�;�ܠ��N ;���N`砖G]��˰���]�VJ/�y�51�p�oƟf�Eb�Hu2M���3�)È�N���i`Z� 
^��s!�~��]İ�E����w?g��(CTy݇��"=�`{L���j+)�����Θ.��ec�D���^���1��
��UP�����FpMZص����p��%�z�/9E�z�O�0�|�УS"�f!�c'fA\�N,k1
�m^��T۸o ݽt.RRET]y6BR�T���a�u{���O�k��I�tY�<4B������!Avp��	����`\ݹ�t���v{F:�/G��+֟��1��<Y��pa��(��ǰzQ�B���b^\8ƝѪx8i�g������5��/�e��Ȩ�]���7y���ث�v�^�RY�r<%M�������B�ءM�����,�M���6�l������wΚ�����o�n�ƈ�p�ا�X�l�s�t_���S=&{Q溜4�5~�ѬV��Yk�/Mj=�Q�P���Jӭ@>^��΅��V���o���~����ޕ��bb�	-UVN���7k�x�N�K���:0���i5&�5�N�sͩf��\����\?>5�ֹ؏	g��h�u��N����ܦ�����2�l�Rrֵ��ȇ�R?j�C�T���~���UM�5󵔎nro���l����K"�Q�����vcx�]�_��0Zg�Οv����G�k��q�{�Y��@�Gg
���c���U�R*�hcp�:�'Ň�h�/��P��#	�f�c0�N[&8�xMb�Y�/V�N�d������2.���g7b��Ϛ�� )���c���ĉ�R�ၮ��c���ڋ��I��:'J�(�(נ��V^�_���}���`�g$�-XeE^w�]�r���/�-`42�w�qu3�7�������U�-���U03�oTn�Ŀ��(e,s�%��7�!^�R�ʉwD|���&�Uī(�,ē/"�M��o��1��Q��fʳ��]u�~��͸�����w��G�M�#q�zMޡ�� ^w��.�Þ�*b�|�)�����칭C��?[�p�~M�;�L����l#檞M�ɽL��^�rr��V;G��3����\B-��G�rY�F��͵��v8�Z��#K]7��ke��RO����q�X�����ܹ��t8~!�Ѿ���V�
l��>�r������:�^D����H�����J��7���WN�<�9=�?��g��'�(��>�y��^�3�fjdi���<b���߇�vf��Zy��j�?o�v(	1Kg6mZ]�b�8�Hl���&fS똫|��D&�Cy���4�ڜt4B����ԡ�h �#��m�� ��A��O�T#\�Z1d;zTNG�<���X.�����8���u^׋;	z9��V�׸��u��D��͋M_��؞�/V�,���m��5_L/��	�#7� |9�n �m�E�v���z��eQ��6YT [�� �͢ [��U�˻��'�]�^fD �����PChǀ�Wv��0�@7c9�d�iՠ�{�A�&�>���V��Z8�&�H���{gSYE��}L�}'p�[C�$���@mn��Y�%x-�#��ӭ|*7���gg�c8�����~�����y���3�qT��
��bw���-p�a��mŨ�3ŷ�d���Z~�'@A��2����O��(rc2�����{���-P�?��y��p��{DiN?4p?�?k9��q��V8��N�*��2*݉�1�w�b�h�8�^�\�b]v�5҆�aX�}�4q�@վi ���n�3�ץ3�f������ȟr!DAu�^�VW��%�a���J|�yL�'�ݕ`�"�m��cs׋�S?O� MqM��Q�M�s�F�T7�۶aX��� h�g�}��!�+��O3���s�t)��)}+�W*p?z��G_���hɓ�EH07����+l����7������1�#>Z!s����Ș�������S^��8g�è��"u�9#f�=�9�:��Y�zW�}sԗ����xc��,:��������Pp�je�;�Շ�V��a�L��b] �b�=�K��s>��;8b)#k��l�j��Bu�������*�R��w��1�Uyf>�i������O���4ry��n<�1�A3�g�@�,�F�o�Q#˔���x��X,�Ӎi[V�s�"0Ǿ���1���T?����=JcȡW��Jc� {�1�ޞ���)c��D<.�;,��6�!����uc��JW�3[�&6�&���%����xZA,�*�_���΃�%�� �&Kf�!��U��>Gf�^�J@?u�s!��%�\@�o��3��t��T�5�cf�]��">��Բ�Xit��;~�
��WTO=�[�
���Ӽ:���`���iT�T(cr��I]#�r�OFM��4��8��N��O�İ�BX�ć閗b��M{?�|��N�̾�Y�L��v���͙�}��@�/�\�����5plJo2�an�$�e'��s����r��+��(x��[�j��î�k��pU��J8����g ���Ȏ��Z����a��.<&���6��-Mu؟    �:>�����^�F�<�S5��l��^���X5ףLޯ^�����H'��E0y���I���[�~�*���U�Ƨz���{�,��'�n���"�1П�y@��-���:�3 ��3wb&�G�[�̸�n�o�@��+���/��1�!+�4��7��nƟd<�Ц��iثo���qm��Ns]�aLR�
g�:M��=�0���ϡ�����:V8[��y/g8Ɲr�T����a�}㾓q�Ǹ�a�s��k�<�x41>ŧ�a�.��C���%��{��dm���T�U&Mr�����,�j+�ڽ�p}܅.��e�ɳM��>hO#��ƹZ�@G)#F��9~�P�T�@�U`��K&�Aq1��!�&�AH�0qĮ��&�rYO޽�"'i6[������Ġ�!�\V�M��	_�`�3��/z5��-�^��N$��ި�ک���� �Ue���3����#��p}MOV�Mc��]�əo/���b�DV[��41/�|�ݐoNm� �}���!�}/-_�ú�^�@�x�L-]�W����ى�Xl�y�k��r^Q0y��]�l��0G<ibb;�������(/m.��{#�*�">`�lDA��\��Ie�Ú'[j��R����d�Ϧ����[ȅ� 
v��=����=���{L8G�ȃ�l�Ş�*D��
�B��xW@�["zb�ֹ����L�̌��G�<ay��ם	P�B|l��*q�M�_�D�1��B�w_4���&�b�xl�01k�(��y6�Mc"㱳������#�4+p�2M�n��DƆ�i%Q����!��nvm�S��{Rk��c6H��1��@F��y�1�\��aA6�����<�Q��/#ڿ���3�r^�\�m�X���i�ju 
�f6a�g0�z���O��c�x4��@��A�;�Ƞ^�qLīQF�mQ/��~ �����8����B�Zrݵ*�&3��Jru]I�n��d�n�7T]I�n�1�̸mT~*��JeI�,9�U�`	@�%�i�`	��� ���"<�`�=�$.�	�HB�#�< �%�#�qg�=!��7��ߖ��Q��ǎ$���i1<ՈTpW� �Z:��j1����W�e��Hlyb+��w�<��� ��9�[�kg �@���ꡌ���sy�QN�.�d�ǥe�U��<���\O��m����4�W��nQ�t`���:�⒍�|י�@����:]pk\����Ʀ!�n��5Kv%����1�y����óh>���
�\�F���8��W:��"�rr5���n�y��h���Ӗxl�k�xR�ё
�٩Ўo5,~��Ɩ��8n�������VF��٘s.���G�+��f�f��~q@��S�$z����O������Z��NO��6;=u��TS��&���n��������C/�(��y+�5d��Ơכ��)���r�1����s�ęq�j�t0�C��`��5N�Ћk:&�m,[֐}-�>�yz�ܪ`�z�a�zl[W/Г{��L�e��=([���!�m��7,�|��z<O�e*w�C�*��v5*e\�V�!�\:��� ���'���z�2M��y��	��qcb��O���w��Q������M��3�K�kpA)UN����Z�V�|d�Vm�3�:%\)b��4�9�w��3��i�|��Z��Uk�_ʄq8�R��8LyqǦ�)Yy���Q�wf݌�n�,�[b���i��K[,���ǵW�{�)�c�",a6s8Q蕷%�m��P8��dA�`׈�-1Ͷ.�po�i���y�̠e.渵�Ġ�v2w!
Z��au���Ը+BeNMfܻ`}f�%ek���A�]p�4`(tEQYî����W���SY�:E����}+.,�yMc�L�=���&�Sk��?��B�8s���F��ͫ��Kƅ���+i;�{�b	r��M	�:rUk�������#�[*q\�gb+�\�F4�� @�8Q8��h�jI�Ɣ'�"-�p/�Z�B�j=�꺕ȼ_��_@�*�-]֓}��lG�3�a�ҩ��=�Z��7����?���e 6��V���<4�g����3�����[o�ك�ړ��(�?�ަv� J��bC�جJ��UjW��9�[�PX��ޥ���/�e˴�@%Mn����;���uH�򲒕��5����1l��6�f���qlu42;���n����V�@��HC�k	6��;��a�C1���E��|׉q)FGg:�z!Y���7���׻ǧ����h�+[��`�S��q�f��KCRR��賶ɦh�_�BH��F��蓶6�=�\b�`��M�BX=���`XU[��ީ�F|]83�F�,Y���F�Qw1Ώ��O�3#o 1Ό��|���ʻ,p�[i��:&
b��'�yB2-41���0K����2��J�hؔ2����ck���]�k�w�n�9���.����lӘ�\zڵ2��3G�rm�"djk�4*#r(.��a��S�`�:$�}[~����e}��D.�G�TYJ3*��!3��csH��B�.=�U4
akz��h�Ѻ/&Yr�{�u��r��J*�'���O�םf�`���O�Q:х�dN}�,_���`��̿��yV���j�o�J����A�?�m��:�W�;a3�t��V����k��V��p�ݙ�5+�����{eM�s;��࿲��0��]E ���*B��#��l�\����l+�֙I��=t2�ܾ՘ΐah8C}g'�y��L��yQ'���7Q���Nҍk��o>�ê��=㗧�-q%ƴ-F�3�t�e��n�EVc���
����7kjj����@.]oG	��(9��ζ�$��6��s�B�ZXU^�;�d��۱b�XRU�K�jc�ܦY����m-����k������y�SI��g�����(�	bN%�X)ڳ���Ǹk���Uǃ����GO��^��7M���w�x;h��_���k��0*������¦MV���(=
��.���B�b�k�!{I �?�zTdj�r��Fs
+⟒U}<}�aլ���3& �ʧW8ƭ*�D.�8u�U"�O[�QCT��J��/���3�Vl��j����ܚQ����Hc�\#�y�u/X82��yοK�L]�5�k�zs����7�s�z;
%rM�ӊ�w8��� 8���O$w6�!E��xF�F&��3,ݕZ�AJ�f]�)�!a>�l	�Vx@�%ǵ�K�}��3њlwhr_\+������D���pعcr�G��M�쾈-�������¶��mcn�-T��֫\J�4Y}�Q.z�;�Q�i�wR�4�Է�_��xm�B=a��z��c>�iة?&���@��D>p��`b%,� �E���预��ίaZU���rz����׽���D���'�`��>�Q�����KAkQ��#��1f�=���f�j"_9���W����?�8p����
k�fpD�aVi׉�0�Z��#�Փ��R8߃�7rn|U�$i�눣W��.�􍥑_���5���o�-B=1��(����H�~�!3_����J�2��b��W'��.����D�%;7��40�����9Dw0���d����g���*�n����L��^��@?S�+�I�I�H�3�d��C������f=n��]��i�k��k��xܽ����*�Y�.x���y��~��GO���[��_����M��=���D|c��;����ŕ�K|��x��/)�4M64҇wS�sM��8]�1�v�L��JrSO0�����&��A�ٱ6���!����W2�Bti2ohL)� 
Zul��խ:���c\p��$�vK��9ש|Fڼ�̥ɼ�]��j��umĿ����2�k+���w-��t����NsU���\��>��43�An%��1��R��ϫ=�PS�f�J����}�as��������O��Ɩ�V%Ք8��"���X���빒/b�:�K����>x�P|F��/	�4�;3��k����1yC�K�����x�X�%�]B�i> �  w�7�I��F��.M����y����oo7�>���]����R5��,��@�]H���%_(_�|���E�w��ޕ�
��_���1���޾*7<7C^k� ���1����溑��P�]��&)[����ٙ�[wm��3��J�R!��c��]���5�z*�:׵A�A�>�ŏ)-�M�w&��٪�q�eP!+� �S�ց�7+�&�S�.�+�׽~%^Q /�{�'����Cg��(M�!�A�;�����0���v�0�շ�\o/�jR~�G�E�è���!���E�Z�`���pU���0�7(h8o���n8o@WJ�v�C�Pg�KR"$C�1��f��`Εim!����f��`E���0)��ݵ\���B�˩}tKж���G�A-ɟʉ���Fj��I �Ѵ��5s�@��u��lr������(�ʻR�u����_�Ş����=�x��8��բdp#9Sr�L�B+�D�9�O[(��O�'e��*
��������}�Ĭ�Ɨk+��$6>� �A��`\� ��F`��}5��KKg-ça�x�et9��o��	y{���^�#�G�J�+��%k�����]U8/�U7r&�$��&>ڝ�x.�A�+k]I�G��d��+5�(�_�RS�k6��u�&��-,M]�47b܋�E��c�`>�w,��j����ϨQ8�P�H�j���C�����!�]�x�^��&@�TA��SNG�l��7�'�6gz� �D5&���ts��\"���q���i�~��p&܌�,z2T��f�iƕ�2�O��㭾�o'��x{i��Q;c�5'�5ת��%�nT��ܛ�%y��c��f}o维K�[f�|I^�u��F��6��qr�U��㜑��8#��3|Ċk�-p����ef<ݪ;�/O�@A�*b�j���ͪ�
�7��=����b�H���B7�~Z�zFL_g�+,��ti����խy��8 ���	ȠL��@�&�|�9���W ���RV���S��bh;�Ƈ2��+M��n>�qg��!3N���K���-U�Jj2���+��������%yU��_δ�QDr��+2�������}M>7�Zۨ�N�D�γ�[9@:��&=$s�5� tq�ɸ(|њTb�����&�1����Z��:�#{9���:�1��V./Q.V����r�5�����aذoN���_�W������Xa�8ͦ��!��^�)bZ�[���ǥ3�j4�[_N?�4���U;wv�j��[�x����h���-����x�E��j�h��i�ڃ�V�ɰ1wM�\�z$s�ɢ�}�p����igg_CX��볯'���ZB���T�G�U�����y��%Y�xɳ�����bؘ��T˥��K4L��)Ѡf���)g��Poqۘ�ɵ�@L4�m5VO4�>���3��I�K��G�1��!G�L2�#�$��g�S��>'sYֶQ7y�U���L������m˓��aO��#7���_�-p���L��V6~bMچe�T��(l>���:�ʃ�TV��A
�2���lM)���R�m�%ob�J���Q*�����-���f�g�nTQD�`�̂;�Š^� �ъ`�!l-��k؊=8v����K#��1��^�G"{�l��n�7d��������h�ʽ��z�?�j�3Ԏ����Ƒ��v^�9���D�0s��nV2.�fO6s�(Ǌә}L�!���Ȳq�f�Ci��0Y�;2i�s�������3�F:�"�xW��D��b���PbK�lw(���u��"��Ŗ��6�% [cK t��w������(�0*[�.��?�>��O{bJ�"����S#�����z��UV�����g|�A�T�%���9���%q�v���?��0�V��      �   7   x�}�A  ����0p����9l�~7���(�L���<٧�8�V�o�5y�Dm      �      x�ԽYr�L�.��f�v�;�tb�&QEI��Ie�L� 	q �A�t��K�u�Nz%� SYu�����JWfz<�?��!��Q��S�l��#�tg}�r�3��_��Am�9f�����3ܱ��O&�Q�+����B\X�q��F-��P眨sNL�~���[�D�,ɐ�j�����z�)�ƭ�X��7��?���\T2K�%w�~�r5[{��|>��gX�"o������4oD�y�F�	=�Ԥ���B����$qN�I�_��%��"�9nH�(ܟ�\y�ޟ"sf;XL�fa�.�f��ƛ`ևkTT�u�����hA��^l���aܲ�Ov�pj��(�eR���E��d�f��pI�l
CZ\8F��+L�]C�`>"��b�C�,����s�o/��VTXB_�����甛T��	�!��/�%qˉ.o��J�۸�fZ���b�����<���ܩ�s��1Q���j�y+��m�����r��t,GٚMI�/��0�3)�O�K��Y,b4C�E��Ųep�3ֳ�R�z����ҐT:��[�LG�F&�u5	��?�����U�;��O�8~?���9uL�1�~QvA=�c��OkLH�2� N/�L��lo�!fì]o���3��icua>��I�^�@����G!����O��&����b�E7w�rȜ2�M�2�ko8�Z��@�&KCB���̝i>��*|�/�i�����/�R5��6�_J�iyA����-�Tѵc��O*����In4�tȴ?�˸qAW�����s'����]ϖ���A)� w�s�~��f̓7��3�Y��vt���ꡨ_��:��%�I	\!¸�x0��3S.)�+'�P��j�h����#�Z��\^�X��hFV)F(hhA��܉��g���
�ef�}aڪy�x�yH�����L�H�1|��8�0x���(h�K�ۢ��]�.�!I>sf����В0�$��>i�1JP:,Wǀ�A��?sA���������@)Ï�-f��3���t�S��*�� �\k��C�,�C�4�uHxˌ�b.4��8apI81���,�4ՠן��>���x�-1n�2��Aˁ��oC��yV�"�K�́��W�fdO����)�|R�e	,s���g�ݯ�x��ڧ�:���	
�~9�Y򹁱�k�~d���?)�%e�\N�2�Y��m��jFP�fi�Q��#��V	����lmϨ����`��T���eH,��l0i�����f	�H�3�=�̀�(�ɛ��/�q6�B~�H����F�����d��(�Xp���=� HK��H�@��< ���W�-U � eM��9fEH�S�`�da��ƣ{;J�.n�|�X)찁�b���1�,C�g"������Ҳ;#�R�T  KDRNt]�uA�|�L �s��W��D��`�����j����P }��H���vj2�$�[`I�!}��r-,���Í�p�/�l.@��k���@a�����-�>�2�>��,��/q=�����m@�/a��[��K�0��8z�]L�2���E�+��%�����������~��o����Q�^Ch��P �jg�sI�3pC�j�Ɠ��'h�sІ��U������4��H����T���98mTD��(��3aP��*��� ߠ����K�Yʲ#9u�	�G�o�E�g�e�fEWx�t���X��ojn������sW#����w��fS "07�s�u�A��[ȩ-b �f�8i�����J�(� �Y3J~�軳@;���I�R�'��+rT��0k�!Q�M!�\RFmC�pڛ�7�̊������؆�1+��K<lg�G����/FF̂�١����=yg�nrIf����1�^FoZd�+�1�/G�l@�j�[��9M^Q<R��F* g����N[��`�z���%�b�0o�e䈌������x��O�H&b�<�X�%0�%F��H��!6`Ô���b	��/�Y0���E/ƀ�7 ��-�*���ŉϭ8�ѣlb��,���$��Վ�@��1|5` с�����W�.����Q��Y����j��ڽ}�v�p��a�����Ͳ[�$��pY.�yw*'����ni��P��6�KZm�h��>?W��~�-�vaT�/g��r��g߭э�-��mӽ����ԟ{j�� Fs���� �j6f�]��� ���eL��H���
bc`�	��r��sI{*��^���_~�o������m�Y�x�^W�p�R����en�y��F����-1�6[_�k����f�Q�*����2hZo=���{��(��W�#[2+�ʽ�����[}��.����1,=�͠�ߜqf�=V �iBc��W$<A��'��&jK�#bM�h`��K�H�;%�Kڗ���w��rX��qtC��u��pKݒ���/�~J~6�D~���&����Χ�� ?�y�C��2�,G�j������.s����w���9 ���\��s߬�+?���[��5G�����y	��	8��>��EF����p��J#�(0�/�ո|�E����>
��ZU�=��)BXm;�/���*v���/��l�םm�X��׸��j�6�c-��n!-����<�Am������e�O����hF"����ͼ��G_ū��ۧ���q"��e;����LXQxE\��,��@X5�#塓�1��k�ba�Wa�$Oa�E���;��R��D��|W���r�5�1�vguY.~����M���4/���}�o���5����r���fY����~f����G���&�J�w��\��~��V¸�7�w�ƭ?m�-<��0���boN]q1\�4Q;��;2���`�P7(����!���_]w��;���a�9�9Y���7�m9����6���"=��M�� �e�s�o��ԛh��;��͇����D���ПW���;\���-�t��mN=D�0@p�I����䆂o|$!�`�dq[�3�#�/� ���>I�9V�pՄ{!n���׷�B��٣��n^K�ugw/��݊�eX���VaT�c/�l|ߙ:A���������{6������:㶎��������b��#��FA�zz�hz����p��HA�S�䠠(�T3�tx�r}�*e��Qc(!w�r���ӿ�~wf�[��z:���y]>N/_�U�w�6,ɑgu�J�<|:����#�:�r�.|���n�s^;o���������pT��x���+n�D��"�����0S��SJ+����Q���<v���_\j�]��%��E�U������v�U����~�y����5���Z��y��t�M��ދ��M(;���v�����tԚQ��YX��M1|W-�Y+����{[���V�k��^��Kpw����0lu�t y��� � ��B ��׀���K�D#��!-�1����DȰ����Xk��=������ĲE~N�fU��y�}fH��:�E?���1����?�|�mg�7T.
����eZk!�z,_�h�Ypc�-R�+��g����/���P�G�5^��c.ܫ��Bx����o/��\���K��e�A�N!A�q5q{c�F�7�` ��@�Z'� �hȑ��	C���(��t��:1E��c�DW{�z��-�r0�ͪ��eB��ZVy՝����~ "����^m>W��æ)�z��f����Lk%_~�{�9�CX��Fݛ���g��'S�ǣ!6SN�
�GqJ��R\ ��9(���E�U�#zw^�����_x.���l��k��R���Ux�ߋ~���z.T���y��U|,^E�����~���(��VqS�9gϵ3�N|_LQ/��nn���<��%I�m��M�$s5	�,SW#wJ��Lw~1�B�rO�dI���_��V�[,� ����*�ͩ[�4s|���s���ҋg�[otvW]��ݒ|xe�u�Bϥ��>�UY:U�%aX�m�#��:Jv�F��,-��A�A�%�_�є>%!��.��A�QH ��    Q��吜Bs9��J.S�D�����\���
`�&^��:���OS
�#c�>Y�0�DP��v�z�*�w~>y��W��aq{&0��3�!ʃ������䜐c�1��P�v�*]�c"�]���GI>!�Ă���ހ���+�
��dݝ>�z%g�T��W�/�����읛�ws[� ���s���꽭�CpT�/���K,\ =�.���xi�}�0n��W��е|����b| 	�<*��Nlk퓿����TdH6�y��T�/��.��N�н}#�J�rn��./�>�+ko&��|�Wߠ#J����p�w'_���6�7��V���|ꝏ���E��d��(��! �686 ��d��-��#��+V �d�}�v�j����s�4h�͠���0r^��ERyCB��n���n�kB�8`!>.�Cm��k�f��kKq�Z�S��2���h��0�߸/.g�7��gB�[��;���y'\�#�]�� 0��̼����T��A�$�;RT1�jZ�ucF2�G�%�����s0��Z�Ə��|�@�|b8�
��ؼ\� �0>Y�+Ǽq�ŧ�m�����eX�a�m;L�1$�0��t��u�������P��Œ�뛆k�\�'�3��Ϣ��3n*���(�AC�(�)��;���Gq�mj |r���lf^-�����:�Y5��rt<�֠"�mڌ�l T����c���|7�NGm��uW��ζu&���C)h4����.�9����b��V���2���'am��\ٿX}�B���䒲Ҹ|iޔ��^|t<�E6��3 t�qp��H`̳��Lǹ��(�,�2�� ���9A�J�1��f��ײl_0��YNHY�8ƲD���*��Pf�B���|׿�#y��IN�lM�h�M#��8��8�gi4�Ip����K�j��go�NV(�S���̝�ׅ8ʀ8�m���Kkr.l�hrK���<�v�G�"��"ST��rvaM�.�cc�H;CtDZtv���]~>?jEnW��Reu;�b�n.�1�9Y�϶1ώ���BXN�:IH��y�_�[����L�D����b4���"�������7;�&cBQ��q*M��cDZ�OS�c��%g�)��%�/u�e���� 2���+x��y�N'b?mO�-�zi�5��.2"��KЈ�g�K�>��t�Km����ʞ/��ޙE@���`�!�@�����8�iP��o�t��ԫ�**
<c�8��K�yJ��Ov0�6��ߨ�����=�3�sh����]���DC#/^g0��<v�`s= N�R;E�Lt�*˲�tL��s�q5#Â��s�M-n�Jv�J��g��0��'�Y�H$�/� )�A\,Ǒ"�� 4~� ����3AS��Ld�f�/��2�]n<��^������<�͈Q����a]I�ƥY?���DƩq����dQ̈�%S)�\R��{#w�	tD����|�k��g� ��9��b|pX�4#E+�A��Џ�8�ꋔ
�#��>d�Px��m��z)�z�k�->u�����8�j�YҠx��t毧敏�E�`�({;�n3��)�(,+@�*NfrT������1R�Avٺ��ӱ�Yg|�<���n�28u�'����d�5umw��P`��Xu�����͆X*u,+�=�{!#���"��:B�^�{w��yxƫ�+���ht�=>���J_7q�0��6%9b�S���ȁg��U*��n�<9�\�$@z���gg|�{�y�N>^��ʙ�P=��`>G[f�h�t����X/�"�w����V��;�����aQ���JNG���](��dc��U�������<����UiS(�Y�!�t���lgyƒE�q豷ʔZ�o��p�	E�0��C�fW8�"a3���.o���~�'�j�Q/n��3�`i=xZ���F��&�vw��8R�DMe��ws�1��ŷ�.�DK#e�}S�U�i7m�Z$��~��V;De4z� �i����_�)H�;1��u����v̻`4��������J^�jC(�(=�/��T�x�IS�b�l�>�����������qh߼\m�g�̅#��/6���_-�k�B��#+��#�9�c���Q�����i;(��4C������:��Ӏ�47շ�ǘ=��lt?AA�����p�{og'-��Z�6����î�X�+�T��D��#8f���%m�&]W�红�ﯯ�:x�W�uqSx�ؘ�������c@`�3'�,=ƍ�Μ��?�s.���,}��������,t���!�M�vSj5n�;�� *���+e�,�"O)G���(l�ȩF^�����j�uL�N���ھ#�3Pb�����O0��A� ��u��������TX�-v���ڸ`���j�dI�+�v����=�x�]p:�{+����X�%ڃO�V,w=	V��,�%V�*%�e�.�('�??xnT69���)W�a-=�%�BE�����x�Z�h��8S��p�]g6k�5�ix3��#� ���c�t�d�Z��v�ƣ���V�M��2�q��5ZT[Z�o��ޫ��; !�f�'L7C���x&���f�9����р�xV�S����XjnIe��R�ى���`1������_�BҦ�CRX��V+솁�h+���otǡHݡ{�['le��mW�@�sD�#`%;��<Fʾ�va�hK������R.:g`ư���u��=׻D��*�O �z4.G�m��j
�N�->I���s���F~֝��VM�Z��a]��=��'������l3+a;��Ǟc��4)0�F)M�:����cl�ج�^tݙ��e�B
l�68,����1�.��Xq�he�|*�|[�����e�h�����t=y�]�),m��u(��]w�d�k�rߑǊCF�i����)��Kʚ��[�:]Ǯ`�v�������Ґ��	��]q{��[I������J�ݮ,ɱ��GyT�� 7�4��>\���O�6�Ǯ��@k���
3P|���aexNT��(U�����ž\�w>n.)������.���{�����#�;G�p�Q0�MV	��Y&S?��0GF���c��~�F����.Kʲ�wy�U�Q�`z=/��ׇ�Cp��{�>�����ȉz(�N����f��Ɍ�h��&V�]�c�m��_\a2���咲'�_�K2��k���ۼ/���;3��d�. Eq Q�`�����T=-S"���u"U���h��TO���p�-��eq�|~>��<�5	q+g �%��`�N�c����ci�#m��gJD����Q�/������1h�-d)���ԮL�N�u������g7��-k7�ż�bsw߼=₻�pDv�`D����*�K`+��AI�r�U:��#�JX�#}y]۷��\�E��=x\ϯ��3G贎4n��2mvI��)�(/�x�E�����[@u�����N�\R�ٶ�|-�.o�v_��|�?�YJx�\�ty�m9;����ۊ���ţG��+:4&�	�v�-����_ϓ�Pl�X<�=�Ձ���3P���_o<�	��&X��U	��u����MR��73۩:��93��ºÉ,�e݆f��X�$J�c�/���[e��Rj7�es͟��mL�	;nY M6��X�(�D2J����A[�Q�>���Z �@O�"=i�"i�����NF�,M]�7�<�-҆׉u�6�ѫ`�:\W<����3l��v'��#����� Uf)�)*���K8v��2��������ڵ��s�s2]�[�&��q�B_�����)����ڍ�8�4���9Q7FU��cڊP�K��[�)9S�=�_��x����j7��I�V��e�����
MI�����(;걵�.�p|N�z�w�!�`xp�,w��e��!�����}1l]���2̊���`��t���7>�h̭���v	I����$C����N'������8�1R�}������l��d]i���`    �����G=�v��3�'&�
���6��n��(��8��Ŏ�1R�M��n{�������eZ~��gXW!f~+�ng�>:�C���������ÀB�-�$r��N���؜���'���
!���	¼L����O�Ӈr����ඏ�d���[�m؜�]}=w�N����<��I�����s+� Qu��a2���6W2g\�V�}���ha��[Y�U+�>
���� ��=�'s�BX�Ŭ�8��۰G�Ǭ��h��8��J����4ۖf[���g#q�(ߌ�!��p���;S-;��u�� !��t�q�jG��I����i^QL����/[<�C]4���荼u�o�f���c
Vރ��:�A�*8���v�cَR�vnA�\��˰,��<��Ͻ%�����9���5�	�2��q��J+P��Q@�$�����ϔ {�����,��:!h��B:���36��D�خk�����h%s����P���B�d�+��q�RhW+�:E��,���t=�͇a�Ɵ�z�ތ���	�����X�J����Z��;��|]z�|~�]�8S�o��I�W�4��j� �<�Y��X��`U*+')#�Z��_Z�7�U��G`σ���1�7��2�Ft�X���x��iƏΰ�!��m#��y��{�-�ï�[,;ק9�/8�J�tKhpv��J��I�ӱ��X9�.Mʈ��y-�Y>+W��-ޯ'4�t��v�G�D����Ѱ�1]�W����m*�C�'f�L�����"a�a'	�����c��y߭~�>>/���wk:������<X�--��;7o���[��+������fӃ	(;Z��t	�\���q�����\�,)k�ړ!��5�R��k�u�ᤶ�=�Z�7�?<�7��|���@����p8��A�-�>�C`���ݞ���J�:5���-RQ�����<�:��$炐���.�������MVOS��|
G(Q&qA`��Q�w��R�/����$)�����ٺR�zt�I�:"G݀:���dQa�}�|z�j̩#�c<�X��w���53�>���@w8�[�t��t~�j2�E�S��	G�qz����)?.�y�|�}��-Q���h։�th~� ��o�5�%�V,)�ث�"X@(�D�v���~��X����kս��o@�H7���G�_�c�K]�Fu}�R{�gI�:�M�ֿ��q�҅�ӱ����\C�/�;��@`��2��?�\���W�8�֜�_yB�ΥA�n>�y/���G��g3�kF�8t��U-G9W�! �؟�gb�: ����  ,��-AD��C@+4r�Lk�4IX�Y��S���˚�Qu<|�z�+���Z�~�Ɠ�� R�JA,�Y/X/��Y�nYb'�)6��u�3E�������:q4���Ճ�l+���K�"u5*|4����O9��~}��:�.0�z���Cc�$�Ӧ'y��f�c��g�S�4�R��I�WܷyO�ͯQ0���f9>��>i�Ks�ti�ߠ�\z�~�lmT�+��)�Z�3�,;UG�O�S��{oO�����D�������	�ͣ�<62<�,bt��â&�#���Y��Ֆ�(�۾��Q�
��>�ۙ�+���Nl�ݙ$��.�xq4mBrIY��g]�/�1��Z���r�����f�r�ԥ��pȕ�� J&Q���1��t+ �2��m��t/�$ꦲ���1�;�y�;�σ�sw=�3�u�( #)�Ĝ��Ae��g��c&���2��\���@�ͧi��&����8n��m�f!ǭ7�}(�/����P��ԕG��t�y�kL.g+x��T/��8�y��_/ I]/�ԏZ�	�N�z@�����Fc�}��=���^\j=r9�����ۂc��#m�^םq+��Nh����"��)��%X\0��U �SG�)#Z��P>)�[�[����� X��{Ŋ���PgK�c����<T��Ou���)��>ʷm`�ӽ�§��{����/�Dt��[w"yb�р���&��jGʲ\�\����,�~��X��+0������q�����`������Υ�g\�T���%z�yXq�����ݠK��sk~��<���$w4���Εd�8�H�;?ʹ@�+��p��,��wi�e� �@��%��g������c��'��1���Ϛi��&��������r�#S���t�ᓈ���_�ϩt��W���Ṥ?,0���?���vcPKr��W��M�,= ���e@t�#�����̕��� �^�w�$��C�m�b��I^����������){�奎]�K�A4�f��ش�����V~��?k�I���sJ�v�(#��i��o��tĴ��h|p�lT�C|�>��?t�x/�6$�zǶ�[�Tƛ\D̜�<`��\����'Q~D���mXVEJ�ͫ����?,�9�m��`��JG1E� �5\��J��a$�sIY�j���|s�\���ZR��\*�SZ�������
�dn�^�B���Ӥ���|	�ǯ���/b��Ķ�N��q�̟��s�n�+14��� ;h/l+ma���c1�C�-l���z0ףQYW���;���y{zSg�-07n�F۟���z:_�~x��I�.Z��4��Nz��@��Z��<GW'�d	�1JV�s1n}�����t�2/q^�1�=�z�����z�Z�?^����O2��q8��v��[�H��ua���E��=m��V�w_l�5k�� ��Nmjx�vRN+�S�o��؟�6�����i#��î����۱����q5 V�]���%e%��+zI�H�ʥb����e G_�x��7x�U�K����i���5r���&/�K�ÉU�vp*��B,)sI���L�=�gR~����r�3c���¯!p=�}�u�;�w �O��A�u��,�1���@���K�$���>ιԜ�=�B/��4����&g����֝̧nO�
�1�)f��U1�NSĚ�ù�4�+�gI� i��N�{��@rI�[߽��۷��:�(2�+���*ic �r�xgI�����s�vC���p�m�'I�������%�n{�x�����x�ڶX��}�jީ.���nUQ:�J�$��v�;Ѫ?j�՞a4��&v����Y�RW�඲�?��ϖ.N�d����H�B
�p��1��%[����hi��K&��Rq1�A/�MG���R|ii���Z�u�(����P�<����.�0'l��,J��*�6'[�b��.�1"�W�2����Tϗ�	]]�����mg#�_�L����6u�oNKi�^�l�xj�b������,@ٯOȒ2z�8�B�#O3|:!�ó�xbJ�o���iU�C��9N��T�����2��h�g�ŪZ��uOGI�0�v����?���X��XF��0ֿ��K���K\���)1[RSW���n�/���Ufꖲm9<4v'����qXavd�'�'Ho���~�||��]�R��w��A�w�ב�-�*y��;3�8�H�+Gy �\���d;�r�5w���P�EV;�G�x9����۲���k�v����$\�J�I�� Un�e+�-(0�ְ�ƨ������m�;��JM���pH���J\e;Q�F�FU��Ď�@�j>��u���u�zՒӫȱ�5:�8>G��L�����T��	.y�NZ�#%������C.cR���L:X�	�0h!��vT��i������Eq'�*'����de@�2�|�K��n�ܽ��]�.����&��J��I�s^#v4��l:6��0l[�T"f�ݎd}��	ǆ�(�D4d�5�~��(��1��U��)Yׯ��o*Cr�j�P�����Ͷ����@�|Ou)Ӌ�p�Qt��T������!e�`�/���m��[��n���3L� Tk.ܾ�0�o��~���Y��I"X��M~���aԉf��?�b�ۦ/�J�^���    �����Zo�x��n�|Z<��iĲ	�����&�؟��Zl�v(��M��(�+�����؏��蹤,lz+��h��%�f\�����k�E�rY��D�t� 	��7�h���7�ܞ�Z��Λ�]:Dɢ�t��j=F�v�y����h�cc6Yl��s	��C�i�d�6�q=q����������Q��N��y�!eE�(ߖ!
x�ǳ��8��z�{OMd�#NX1�7F9p�:�V��U��')��u�m���u��g����u+.��B$R����FlP$��p�����{K7,���d�-�XZ�RSva;�d͒���7NE� ݑ�],]�v��ެ���c�c�'�Owa*x��t�L�f��샾µ[��i��y����q9 ?�HNQ����84�20A�^���1ƣ���z�+'O���������ѹK=c����%<$e��5��w*aNaq��L;W_/`줍ٶ+�?q��)x�Hos�x�h�7��:��o^���S4h+�DT��ZQ@Պ9i�C�j�\/���my�e�-�nU�\&�<�M�unf���7�'��ɯd*�P|�Q�<��Յ� X�*���5�9��4��F���,7/O��x���Q8gU�Y<^e7�Tb�IOz}���o��Y]u�j���h��`�]�,)s�������PJ��I�]��(��$]w1�F��A�.K���MO$zZ6�J����,)��;�-����`�������3/o�r���S�Dj6����#�J�~�H�r��V���؟�;*��'�-��[ e�?���XD��|�N��pcM�mP[�ݹ�?���=����فULlۈ� ��ϖƱ9���l�����D�by+�����U��n S�է��JNH��ڸY��d��n���A���7	��K�E�lu`nIN��YY�4��l�n��Nu6����:(�p�`Xz��@�{G�'�?b��@��l�J<��	=IT��F�7�z�Y2$f�ǩVm�kK���'wժ���r	�p������Ǹ�v��QR� v���������Dp<(������Oʾ�cgq���l��Y~r.�s�;���8�\����K��7q�a���rלpe�f��(�( ����l£U��[��h#+�z<Z%KJj���A�7��X�f�l��/�{�?���@�Rm� V�'��#%%�V}s����@p׍��V���#9�����Gg|�y�Wٿ���2����5&G��<͖��?�Wsw�cI�&�Ʈ���� �C���}/\�w�1;ɫF7��p�ӑ7��K�h���c�Fu��d}}Z��5�O�߉���,)'���tᇈ�%�$$��q���i�Nz�u.)���[�[(d�:[̾]V�����*0��Q	�m�3��t�G4W��,@�ă-��%=8
���ư�H���(�7��~��FhT��i��e6`�x������q�.�#�Ɣ�q:ʭ�s-��̎���.K��[�_$mӬ�mk?ؘ����>gN�U �f[�iZ�hK.)����].�~��G�'P �p�qq:�qK����֗+�V'Ȭ��*	�Z�C\v,2���8�Xf'i�p�2ѫ��E��e5q�l��1}������v��֯ `:X��c��s<����l�C����XNl�d�6��~�P�Y�N�>�N��(̡b�h-2��nŲќ\_�1�T)F���D�F����$�$�/m����SPs��7fE����U$B�vq�|RVr��:�|������}��tL�y����^��!?���>e)�]%��i�Ţ�+W�%9�zM˙��B�b<���~I�4����uW+��$��5�V�l�(�8�ט俉S���_L�&IW�1R����49vE�����9ծ�d�����fIp�Rs����Jr�3M���?�_���G>>�1�D�2]����]Z�f�c�?`��m��`�n5ĜD���;�N��$��qK_9��[�K���/�)�?�m˵�^�V���_ޘ�zg�^`gz�k�˳��_�Wz�
x�@#��H�[�.��sm6�q�Y�
��:,g��4��}�dl��Em[�/�ax��Pi�	\�"�?9���J�Chm�U*�n]��s������:�?���͌V�T�ev��`��ɑ�+i��[�x�qMg6y����L��2�.7��]'yY��?�_�Ed�jv鿐]��1v#RF:���p�.������ɶ�-�p#=�Ĩx�Û*2��&�J�Ս����[��&+T[�n���^e�i�(���`s����t����]/�0(� ��ů�j ��.ϸaމ ד�l�J��27ޞ�{�ʳ#_��o��Z��.��|��g��~���R9<�3)��Ցת��BbŀJ�c��=�|�]�=��(�����(xϒ��u���V�j�˥��Rv5�M�1I��nQݥ��c���Q�	���#}����Y+�^>�����W�L[�Ô�[�c�E�+am�0�w:r,b����}�t0�y�iR&��f�z�}+�/[�!�mc�0�t��5���ђ2�>=͎��,�Hjk�����$j�!�B��Nղ��U�K�O�9�X����*���\Z��	��$��:����@�o6u�xs�*���H���1RV j��Gw��=1k������[��*,�����x[�ՅYpG~IBE��4|*�$���>�Q��S|8b'i�tG��x�ۨ�_��#�w�o�=�����W'�%��U��{�귣ORj�ضL !Ii�pt��{RD:l�K�ζj<z7�eh������Y�� �8PVo�ޓ�x��UR ���'� X�|���S7 ZJ�	�`<�Ec"|t��$��	Ο?���e�*��/'ߝ}�7ڽFh���TB���.2�62%=<=�	m��O����H{s�S�����6��[><�k�_@�x�DZa)t	��]Ѱ3�&<��(����b��6�(�̶�v�V��z' ����Fg0��_DG�_������Ƣv�	�	�0\Ƽ�{��`��hk�kqSg2�=g�n*p�X�@s�^Y?�7�s,��^�V<���џ>��|���m�s�����f��z֏���t݅��ڍ�8�,��d��`�� c(�蕐�p���ߕ�ot�vc}�y��U��� oQ��ŜO�b�3���Px��,�b��Y�I�q�ᾊ70���R0���y;���ha@�U��(���|6#�G�^�;,��R�����{�Ν<?�s���p�7X��k8@��u�׿[w��Qո�:�cp������B;Q.����;Oc�����˗a���}c��	+������
N׮<��h�%�j"�F�&$�
i�s�YGGJ�q������������8A5���"�����ɆL�HYi�o�nCuo�����z>>c{+E��;]z����2�e�'E�3i�Xk5�E+]S��A�ض��gIY�n���W�z�Q�ۀ�p����� {�O��Jma�a�h�V�C�h]��?Lo�n3��4���z�+�>C'�q��Ẃ�����T�
� :L��ظ�2�ӱ��ZQ��B��d�B�%YG�h>~܅�������־z�]�9(n�W��;񔂰#�t�d?ȣ� �`,�ju�$cp�=��&YG2�K1y_tC�����B�n ��N�&F�}�a����{ i���H�I���.'	K�5v2��)k���G�JIg{�q�P۫-��8�X(�N�E<5����NO��5�2Ic�R�@��EKϓ��H��}���ޕ�b0�oٗ�A)ǩ
#�; "��NwJ�1xb��C[��ӵ��������Ǐ�N''<�?���]O�e�RJ�]���4ɒ����}4�(�������
�Z$������4IZx��ṇNz���f��_��+�8�fC�P89� �Sw�����R��5��~�r���4N�E��R�n�3��=�u[Fo�k��k9����qV�I�
�}6�;��K��w2{�|�,�sw}U��:7`>�    fm������������I.��1��Q>����g��u�������vl���DEr�G�E~gI��٪�Ż�������Z`�V��`
Õ&�St�p�H�]�Z0��3�.ɶ;�!j�c�a�^>��;y��ayѱ/��׃ff�^y�����b�y��Q\��r����3���x����ƈ��*\I>Gi��D���^��+��D�瓲���ǣ�~���վ��n>�g8�B(d�6���y����6u��a��Xc�<.�9��E��.�*�8���R���c�B��8��K�;W5]%�/|v��}i�G��m�9Ә¡���?щ��vhvl�1]�$MQGt�bSj�!�./Z���|���\f�3����w�.������ը�O�B$�P1�NU:s���Gρ�P0s��op�`?�w[7���]	�1R��]���w]R���M�/�N��j��T�����') <F�9��cS=��$�Y����;�"���n�<��O]��G���}���I�Oj���C� �^��- N,8tq9�� �e��	�?,�Jg�+6������<�RQq�rh�OGI��*1K�P�H�C���r/\h������(F8���kc9��j{�Hpb��y9�~���#�K��[9l4գ�8\�?���d��1s�%�ͱ�&:�1��7�ﭲ� \&�a��J�q�Ng��ݚ�h��_fa� �`��9�Υ4/Y�?��!��/�{�K�cS�8��D�#s����ꮦE�'j�v�6���2���1D���L:��%vZ���Q'���ݮ"�њo=���y�Ӥ�Lԛ����u�;l�;���t�Z ������|d����Yvacu�+Ő\��$C����	'`D�Cɞ�� ���r��)����H��^�i��haJ�:��$�{����na��[�+����A�?���[�l�����/�H�䒲ߠ�7&��wU�o��o��;p�$Ny'DE!?u���Ñ��j;���(� g��`^?�]m�_`�D5&Q�pf!�+ \��_ȥd���sTm��s�Zv�.�dU�[sn{Ӟ��^ _qBF� o&A z��9zQ�b�I����Y����3ۍ��%wK�jqrI9�/I弥`~�ڍ]z��Ӄ�$�L�M��Y�)H:#l[�J��N�g/R�����q���Tξ)섇'qķz����"�����͒��g�0��f��a2��K�����0����(R�ơ>�J�idԼ����F���璲��[��:�)��W���a�$�g� J���y����K=��,~��$~�0������p���RQ
�H�여�\c��'(�)+���w�.5��Y�6�q��"��b���H%�c��z0֛�x�8d{���P��}�)RV4�R�˩�zUZZbYl:��Y�@ɠ�C��p�oR���9�ǻ�gF�?>v�� ��!����p�
�4@$J��t�H ���uk&iM1��_�3v����3��-I��.O �0�`f�/s�V��m=IK�0�Iz���2�����Z
�d�s�.&����Xk�����?�#�n���.�!e%�tGj��Mb�˭�*�����|Qǔ#X�B� ��@7��K����#jr��tS��IyI��ϵ���]��ͪ�����-�YoK��,����/~�w<��9���W��x���ʏ/g�S[�t��ј7�d�w�ҏh��-T�s�#��IU�%Q2�sx�p�|���()���m��'	��8�������s v�Đk�R]�zX�S�PӴ�
�"��� O�Q����O�x[�x(6hw;R,���t8,L_�ӏ���Q=��7N~4�>�Gᆣ��+p��z`�l��#���*@Q$�d8���<:�dӸ"CR){���yv�b��z�^��`<��(���7HąV�Ԣ�<r&�ye��5b䓲��i=��~;�ї�^k�a9 ���}|Z�_�	�RX��9u�BI/J���D=�v��s!DZ�g)�w�Q�����a���ۢ5�,�l-�S��\�3uCm�v����+��N��d���	9n�܅��Nwp�J9{�RV	խ��ty���ѻ)\�V���%�M���<�5浿���Y�����+��� �����8��8PE6�;<�Z�FJ���SZ���/K��}�Z�ů�*��_U�5��V���°��ÿC��S�Í�a���WG�]������Q��ʍS;�n�fTǁuI=v����4Kb$]V�S��R�//5b+�Ha�}s��Q�mC�������t������)�D]�D�����q��+��H���\^O�GpD�ȝ�̏9#2ApFR���r���H�|咲wp�$��̈�~r>�Z��ʾ Ӏ��}�lx�.�/f�����Q���8�$>),�k|cK�.���Ar��*_��*�
�}9��ˏ�N�"���E������	eF�ƛ�*��`gRD^p���q����$�������E�-�W���c��	����Q���C����T�4��L9x�u��d>��\wN-;j�Ң�:T-����T��w�tnꭡ�\?/��ۊ�]�-��[-n#�*�]�%��JH���`�s�f�t5��u�}\�)�z"�p�R�$|��e�������������9�?�O�\q��Z5ɺ8��͕ٸH��n[!d�HݶI��"W����z�p;��/���|�裔�ޙm܁��f�ߗ!|� ��]�c3Da���a�������+��,���z���n�%�}��^��`��s�o5�|z��A��m��:�Y�W�6q�op^{㨪̵7q7��;��NEĄHvf*�h���ՠ��y�4	O����h�j�a���9Z����c�<[��pT�
�����G4� fd'j�ReW".�q�ݐ4�\oh�z�`����Y�[վ���Ly��_�����zC��'�N��sf}��P=�|?!�%e.�8�
P.:��ݻ����3�[�?��tϥ-�:Z[�	�+�������^�Q�E�������\<�C������zٔȷ���|�o.V]l�eG��od�|z[�%�Tu"�Ӟ(ő�a.�)+#/�T넋w<WP�^p����ƆmÇX�q���`�Nz��/=l(�g��O�&�I*SM�&�tݢ��K�0�v>_6��D?>�U�ǈ�c`��AVԨ���܅yn$~�b�Β��C�o4w��Ci�'�Q� �h6�U�V�
��$)�+��u�f���P�ݶJt4*��0�}��?�Ӯ��<D�Pv�;�I8VX\�t��>�r����҉�0��r�vծ�;
��.̑�݅?L/�S�Y���l�y���س�8�$^X�<����L���yo�K�na����g��\z����6n5� rM�G�|��w��Օ�9�q�ji�I2���7��7�\�5�F�a�ٲZ���9���:Fi��"` }3TI�Ѱڨ���;@2'�s��D�`M��S���v�Ͷ����\g��ֲKf���8fZ,i4\���[���4�蕻�+�7�P�����ڭ�
��c6�4�R�j�����_�t��l���f� j��$�aQ�E�_��X�����?s�g�t^T�N)�v���7T�G-A0��|��J�8���/T2�7Crd~�n�Z��Ŭ�w��j��m��k(�i��1�Ɲu� �3�s�m[��^�Y��(zQ7(n�bB���O�卄��|�����d�� �rC8h��C������fk:�я���c�^}R�a����H��H#J�[8L`A/�읲�'��*�~�}�|y���,�^[|;X�wΰ��4=(?l�^v �K�	��@������y��O�2O�qv�!L�?���M�gX��"8/ŉ�G�a�y�/�~�U[\��'��4݉0 ��oǫ�qJ�y�~ĹI��)�mp�>G�q.�n���;�aE��	���������h��~�M�	'z�`��:Cv~L"x�����Zݗo��?^��3��    ����[�DԱ�V�J���V��Ia��W�E�EL�D'�W}@�H<n�Z�5���O?��59�j	Kx���7�8���ː��b搪G��`
\�x���Y��I:�7I24��u�N�������=���A6��y��������$ �ެ�M7*���s3*��O�+��v ���%HĹ�I47�7K�Њ�s��p�ZD�1���Gez�(��H��� �8���z�hh%\������w��~��䒂8*ʹ�4g�6�ET�u��=G�sy�����+����f>EmvӰ�9�Y��6�ː(A�s�A���_m}�ae��^|���D �������Y�u�H��cpG��Z�t �/�8<��6��^���ņ�������c��&N���y�L��I��']�]g\.)cq��r��K|���wdT��O���N�§6%V�q�G�{��q�� ���IO������'Å(�`�B]-�D�$s;.A�Nl��,^F����gz'����TX{�A�����e�!lY����;�[�zpf�t c��Xi��0Q��)��E�k�p���/E��m=|�a�W�Uc�ԩ�����r<k0ꮭ��)�G����ܐH�n�}�#��FA��E|w��
��Ӡ4���aWk���F�&��T;N}DAV=�6�i;6S�q��w�ˎN��w��(��5�g��V܀� ;k�k3:DI8V�ކ���l���!�?�m��%e�h����F��ԣ�J����v3�^�M�;�� ���!������l�16��R�V��p)�N{śb�=</u^�������$�`!�I����^���N���%e_�Q�m�a=utë���+�r�@ّ��1	O#���������n�Z �4ͯ�a�؍��bIw��1��ö��;Tư0��5��+f�7DÚeX �p��}	��T� � �F�}U�'��H, ڱ����i�J�rIY�vzN9��������s�S�W������G�6,L���L�h�S�m���^��8l29 �p��ێ�R�
�M~���1\�������m���wL�j��Lv��C�C�z�����^8g�Ta.)+�N����^����Ws{ �[����
�M�������ҩ[�E��?���9���z�x��D��ʹL�։]9F���v�Wa�I����_L��`qL���-�{q}�'8�w�)�ٍ������N��ޥ�!��s��ڔ��v����n�����,�24\���g[S]�A��?Z����MhN����Uh��%Y%{���fq3���q��v�6!j��3�� 1ڣ nu��	̺�]?��w�.���c��Į�/\*�;�9�D7������U��#�����m�/�a��ʸ6�d9��YVt��	���h���N<�8���xi�]'������S�l܎�[mJGY���KM.- ��Q�s	N��`V�eݜh ���st��SLX���c�E"x����uD5��Va��,�S�q��Y��?n��!敷y�<w������r�J�-���
^k��n��bB�}"5�9��^d	� ��(�������%�=��TV��f�ݵ˳:`�Ç�kQ��,��zAF�X�7�➎�bc	~�J���S�^&�tX�������Y�ap�BI"ᮁ��Y:&#�}�"��K.Dc=G	a����a�6��1S����\��6v�o�үy7���#(,�dO��6����[�B�'I��VY����"t�߇��+��|�(��d`f/��H-~>:yx��~�]����fg\��5�Y*!HY8d��\.F���ߎ`�E��7AFtq��N���)���s�+�c#������y� ��GL {ҁ�ElwMR�x��!���XX��&\nD̤&e��L�t1�}�o.�����&;���_�k�gjx�L�������������r*������Ͻ���7\�*�g?i���/�����Pn�����W�4����\��\C:��ώ�s/B�(&�RZ�3�6�3�r�ٶv1;����G0<S����D�C�\R�[���[���Ə�њXE/\��n:���1�C�ՙE�RQ��x�8�D�k�6��������k�ރ�V׽^�ǿGB�7��)����)A柼��W���/2��~w=�A�
��Ǔ�)�A~mޯ��f3��o�+���|&�o8PLFt�B ?�!6�ŋݞ
�]�b��h�i�Q���ֲM��b���/��u"հ��sޖw�*�����zG��"�D�[_Cz�Ny��^���^N�4W�VDA5Ҍb�!��Kp���μT����Ep;l<u��ځ��e%�*v[$x�[Aw_�?���4����w<)���`p-eɓ���B�����:5��6��W����b���ž��V�_�<����H�<�&y&ZZE���c�����<���p�F����Hj�H
����*�� � >FT�P~x^���o��,K��L�)�wp��@��;�\�;��!���Wr��~'"<�2��b�:��^$���2aY+S���L���l�9-��b���;�@q*�<ƣ��%
Մ��Ȧz��%~��f�Z�3��|��n:�&:������|Aq�� uq�ݽ}�GL�>&cH�@�+�"��:U�8�}9�${:t�����g]I�u'�6�+�6�,+���j�<6z�k�&�����k�H�}���ᾘ�Ϗ�y̳�5J�$�Ʒ�`��&�e3M��uq��2�7~wT{uN�HN��3�ÉJ8�(���"�1M<��p�c�3�Qcpj�F��8!M�"i��ǟWU�� #O^N����F���u�C?�@��#�6~�݅�_-8a��g�z �`��O�ڋf�T2k#&iJ�����M4�l�?�-qSkW��P��P�zs��"���%�4��N����"K�Uҋd9�֖��k���#7=%^��ob�ͼYoHȭ����m���|�\n~�ڗ`�	_�X���G�Q���C鋏�H������
���H�+Hn���������ǛuG��U�����LZ���%������V?| �4`�M$q�� �Z�T!�+#����'�	&�p00�&���R+���d2iJ��~��6���Iyq��uعn�����o��� /�)'�ΒvX��E8�)!-U��D7y��!����٤zm���w�m̠��b$�h�&+�C@�����
�RK�ŕ#� \DviQ�J���3M����O��4p����Q�����^�����@\��)\'�<Ɗ�M!�,�Ve�҅r��^�6��;��]	3�.+2��{\�'�Sܟ�Y�A^�R�<ul�K��qW��R� �͸ywҜ�x7��k��s �����3��.G�%�d8Ӥڹ�4AĐ9-�\wIrL8��d���z��k��_") ~[�Y��}	z�(�)�?&{�}�LS����ח�!��=K��8��yмF�Y�K=�c�4��q���e�P�Go>6����A1Ł?�dqc�%-�T��Y�dfhۙR/}�=?i�r���'����i	�s�#�"������ ��Q$��F�iO���<S�׻�E��4����Z�7�G�3�e����A}�ܰ	b����,� ���<\���5�<S����ʵ��M��B���*z���w]�X-�bi�Fb��r�����+Q¹��4���oR�>	#���?kMr��2�Y��}�.'��%�w��
%���&���U'4��;�<��- �%7�t�I��,K���[��`t�?��Scu��YiN=Y8����?Z���~��!�Xo�Z�<�v���bGڔ��Z��z���sU)oG����u�Gi�1Z}#E��qQ$�D{��jeL��wPxBpt@��#��4��6u�юw����gsz�/�Y��cV�j��<p����!�-������9���<8�bz�+�Rbj�5���(6�p���9�Tg��q~�9uB�?n���    %yBO	z�����O�خu����G������)n}"��㨫v�
5�G8���͟OD�����-��b��]h����״If�I�'�i�������~�dv?_A�!Y�%L�}��".���M"ؤW<CEK �b��$�r�F������4�sr�������J�o�i����K����qy�q�^/������6������@Z+Ϟ	˂��D��Q7��iJǰ��b	�>,�.���1�ˊx�>�4z��zֳ���0� C/rg(�B�U�F~�~�#�K�
�T�ӓ.�c�Ő�<S��v{�tXZ�ތ�4���K���i��t7��֋Y�-��̃�H��]t�v(&�a�y�No�)uȧo��
� f>_�n��I3)<�B���#���W�im��
Q��H���V>��_��M.��z �6��7��8���?��j �*M���h�� �h��@���o+>I#�,�s&��]��w4Yy����d383����vA'c
�����ԶM��,v�#�b�O�J����!غ�G�k�c�.���bO�)��ߛn�7�j)������\7 
*����4)>BG+�,���^��e�&��8�� cO�2p�=*
]���D7ԍZUTĺ�Li�_����FW����Ǖ�j�;w��	�C*(�Z,|8 �!$��u?\�N@[q�|��%H��u��&��{���8v�3����f�U��0�]}��>���WNQ��8��4\�i��^�9���؞��5%�uM<ݾr�}�9bJ��������,UjO%�]6��/+�y�eμbIT��ٰ�8�W5B�A�!��p>�,��>��t߱��bQ)Y�
Bv���:��ɶ'��>δy&�/�.9���q�bP,��k��N���Is�Ky�L7ڬ���iNB������9�\U/ץ�.�^���W�}���T|�;,��-X����l����꿋�BQ��m.�\�1<7�uM4�Yy�h�HX5˴i��>8�����|j��퐿��__�NQ�K�	^�g�C��F���Ժ@Pc��6:�So�{x�v�;�m�P��oy����|{�t�ڬ~E�[Y��u� ���b������b>|NSDBE��P=�Z`�"� �s`��N�l�~�~|4����r��j��P��B��#5��`���g+��M��)Mχu�e���&�4�UCv�R�a�Җ�4Ô�C��yuX5��v^n4.�q'�|���,>� ���缄�F'\Lz8&,��RĦcT�l7�v�
a+�~0�A���6�=�Lm�p���-�A���m��D��dr��/��\��Q��	݃:P�"����g�iS*���>>W����kN?�wOت�$D(fX��Gk����2j�G��A��i�Qq�A�$��(����PK�rEO���훔��>������F�\��ߥf0i����@��9�Ɓ5�nS'AZL=�T��8�S*C[j6��6$U�@���dd*g"?���ܜ�������f�1Ń��U�Z�3�P�,^�G�n8Gd��ǁ\�X�Hc	~r�x�%p����NpkP�C����i��X��hU��n��Ymr�\(9�w����d��ی��#3{��l2O����<{���v�'To� ᗗXp�3�	�TX������_�p|���=)�z�`�4cj�mL8�����П�Q0�`�ʕ"Jء0{;����z@,ɝ2Q7{Af�}}����ޓ�z��b�(���pe!�8D�6���n��;ҕ��"a
���rG�iJ����w�O���/X�y�=�����e)L	}���t�v����R6(SD:��
{�v�p�IL��E绬
�@!
��9�E�GC �ia��dK*;Ɉ��J�I2ӦTn�u;~j��<	��$ZsQB0v���q�Y���f���L?��#�EU��K�e�q/���V�{ Ώ%�x�L�Б�9v���Ts����&�p�j9Ą=9�/�,��2;mr�i�0�P<��+���7�g�{ǐ�������x�u'GV� y��4�x��Ib�m��ť�|�0����3mJ��F���0P��e�qQ[���� �yp�����v5��qX���W�p���ߜ�J�y��A�u�
��Svj7�TR�	�8�4)G�Z��d��\ʸ���H����0�����U��p2u;ӳ��^����HH�
�`���z���?�l��'/^���"�˦�(VB�ȰI�]-w�!�K���aJ?@�q�87Lݝv���K� %��2Y�K�a������z0�Q"�ųp��>���;(�#�2+�]ZtIk&py��n�����{w�x۫�tQ�%~��$.i�v��%�J'͕� D?�Ag���D��a:")��S��'7�O�+f�%�Y���#�ȑx�(a8��)�7N��#��ة8�q�#����3�&�ebG��!����,�eO������;�Ƴ�Q+���w6�4��~{�w�:[�F��*��n�I�x����S� ŋ�x���T��.���/_�=9���x�>ϔ>�bx���v�=������P別n�22o�0���eg���� �CJ:�9���]�8���K��Rd������&���>��a0��fW��ɘ��K�d���f���lF8�`�C��T�Q ��!���9��[ņ1��8Ӕv�Ͷ�O%=?y���w%�u8�i�{�`}ł��sB���S�ףe�q[�n�����\+㥻8�&f�&�S�������e���=`͏��/dA��>�a�¥?Z|���ψ`�:�PKb[*�D2�n<��3����������%U�S}*WgWc�d<"�PXyq:�DE
�vƦ���	Qn�MSV�8/���.>W���g���ک�����\T���\���]�ϒ�p)��>yۦ���k�n�"�5���5uD�W�aJ=���c����v>��.��U|�.��X�A�;�{=��F]�����B|Bwb�ٱ� q�-
/H�����d����hoVΛ�[�{�OnYp]T¹ן�bj�V��]��(H�Q��sw���h���r��d�-��.��T�X��=Q��Ⱦ��l���Qg>��F���u��y�gH!'$ ��<�:��c��w1��Z.Rꚝ
����^���ѷı�{�r���_�w������ϧ��L����{ou�r�9F́�o�����ƛ��~��l��c4A?íP�� )��%������{#��u3��7ۍ�/�T
Ww
�u�hu5��`���̡ ܣ�-���.��,d�G�3���t�q-^�f�e�{�;?����o͛��K�D��!<���D�в]�E��<fv��[�/���^�e7ȼ������Q5��1�K�L2 ��{O�g���\=�ىpHǨVÙ�D*i���&G�f�>�"hD�H��`3X��2$��%�mJ?���|��m>��⚼��b��-Ir������f���NC*ɂ��"!��^Rv��#���{��iS��v�6�Xԅ�|=��&�߭��&�(�J���߻�:�n�	��ȺK�AO�Д5��
l�C<� �g�ԟ͊-���{p�E����L��&���45�-K�b��M��y�"mJ�r7	�����I�6x;�x�Pm���z��F];减f�ʟ;�WV�()T"RQ7�e��XiS�q1�>o<6���g}|q��jupW����w�O;c�b�Ϝ��)JC4�#ѷ�4��q��J��:��q�Ӊ��֍n�����?x�x��8�.�}��|1@:,0��o&�dVt]�3IO�(�V���3���۰�F�q�1�?��-.rp�,�_���~Mk����l�î� �3(P�L��>h��f���%�l��6\$�E4DX;�fwة�{�hI����X��@
�!1�s���)�5�{[o?��?X����ȒY�E������2M��]�~���R_ctz�j�9��9�p�'JՖ_��k�3�3���+NܠqIVC �x�]� ��M��-kO#C�m��    �Ձ�ӓ��[���l���Qՠ,A����H����zC�Md���~Ur�#cV!�q!������`��3����W��Y�u����]O��.,�����Wl��A$4L%&�\�zA�袟̍�+�d��T�z{�(ב����$A|��Y��\9&��\�]��~��+��%���-�y��r�8�A-���p^�%���ˊ���Y���9��^�tϔC�^}�>�7&o�1��,����Vi�	;�p}j����+��|�'[��=Pf���ⴈ[I�A�ԱR���y���j<�����'���%d�Ȗ��)4��2�Ze=�e��k�ď�{�Ń׭�=t�DB�ܰ�h%���e�)��[o��<�k�����I��[�W���5$^PGc�z'�Db�!�u�	�u��5�u;8̎U=bJ;��m﹆�:���}>� ���a8$F�'(EbEf�*/�z��������/��B,T�2�3�e�<�l	$Mˆ"V��e�T�����N�q�x-��XQ��U�r��$��?&��8�z��ox��g6�U�-�������n,�gJߋ�W��4g�պ�.���'A$صM�]���k��f��㺡_��Ɉ�>мL���uV`�q�ߺ~:��	n���TT�7��J�߼�]���NnÈ�;�]���q���!P����l,gC,Fe�L"F��+N��;�����dpҩ���B�É㡻�IX�iw���L��DJ�s��6�75܊ja�E��DW1Ӕq"�\���+A�?׼��������#hA,t�h@l������+�{PЎ��'��?o�+�Y��#�|���d�"~����*ޝ�����#���鵦��ªDV\N��qY޷�˦��|R�����m>��H�Cϝ��f����b9�T�m���aS���V��Ddl�R���=�^��b���ާ��|F^V\Di���؜���P���(A�%��T�;�UL��&����H\ٙ�����J�Y�sw\����;�#�A@�t���� 3�]݈0)5���@G�M?e ߧMN��_^��9ps)�!U�3>�g�)�B��n��r	L�(��2�c^�Z�Δ�x�D�΍T�;�����+���A�Bԑ�:��q?��?�T�"��`|�7�ź���1)˨㓦?x,V9��<�����oֱj��s]���~�]Sb�GE3Om Q�?ߚ)˩��/�ͳO4hy���9���r�^���!�y�	Λ#�W?.���L1����HQ	�*����Y2L)o+/n�ɍ�k�z5�ZP9 ��n"�"� �=|׍�-���'��+w�=�'U������[�<��]୔��1ܾ���RG���Ŗ5���7�_���z.���~qn�HՃr�v�7G�2|h�H�03��I!ϋG+��T�>?�F/�5//G����o�}�Dؐ�;�[�vy��=63Wc\ZȄ�y(%��8h���d��ު��z� %A�!�	�O�7�ru@��XK���,I2��e����iw�`�x���Ds�����fX�x�W����y�p�C�\��4��.�B"�ґ,ձ��Ɵ�!%���	�vw�L�s�վ�[�������{�s)!�ru�IO�b��"�eX(��PD��2NnypI��#��$b5�m�8���#�O��Ӑ����}������i��8�^���~�ǲx9	�^���Ǻ�3�`?)b�&����i�Au8�;��d<C���J{�6jޅf����O��-��P�{��R�6Mk#�>�Z�Nq���F�H��G����B$j��kJ�ܘ?��Tp�0R�rgs��H���'be2A�믌 ���e� �M,Ky6��,��K 9!�|�)�6���˳�ߍ�������I��Dp箵������|��f��N�Ew0n�Vp�
/
gL��zا�t�h'M8�*�.k��|�>|Y�m�?ȓ]�u�{/�hF�z)*(Zַ��*�v(&���P�Ƌ����,҃D�T3�S���ä����ǰ������r��N}4�z�Kx�
@�rs�u	u.v��������q#�=�,���J�ؐ��N���ZH��G�w�i�Z1�^�L7��r�*�V���&�Nv���@�.�ҟd��	��maE�;q���$���[�v6����Tk��9�l#��t3��\/&�tN��i��t�'ӜR!��@�m !m�y)�p%�Ua�co��L(���Z�ӧKj�&��6���T�ɣn�!��^8<�QG�X�]}n�v7N�n�iI�j��v��MO�<]ގ�{�ťS�J�Ń��s�t���#�ԣ�ԇ-WZ����;u�"r��SWz�ם4I/�<��|����r�(m'��dM���;ݧ���AX�������V?rU?��$*��\LB;�.Ȼ���v�R*�����AL�P�=��iJ�O�|���=��|�}BX����c��9$^P�A9����S.�En��1����X��4�O�"��E���ރ�Ͷ��kY8��O���2ܶ�o(l�Szp��t.�부xߧQh�(v�qz�.�͎�����"[ng�3�,��)����9�cPJm�.�O�w�j������N�|L��ގ l����	�NJ�8�t�S����UBET�����F�7��˧����w�0�;<5��&��n�<����gxe��|O�>��w\g�`�%,��P��T�^�*ڄW��B!�(�,
�u��ޞp(�6:�������.�[H(F��\
�j�Ոh�<܎����P���;���Vb-Ӕj
���̺zD0�;��x��k���(���V��|���4ͥ�M�*Q�I$�0o�YmȤ)�,{`�CS��G'�pu���id^�"�;z{�CM�cd:t�����E��)�>�t��E��� ��K�(�G��gr�Ս^W��c�؄�Yq<����+\^���b"d�N�J��DA�>��h�:Uj_�5mJ;L��ih�hO��:�k,��)�@�J��?�[D��r� ��<��&�P1�#B��%�����?XɱK�c_�S�D�B�>̢L������^�'wz��ڭ��i����p���U�6�7�?�Ü"g�$0�،B�0�Y��Ii��_��7p�c�r�����ಭS��������s3�4To��w�V$�6�q?6p~�eFuy�3U�(y�\iϔz̓���YàB����z:�n��_\���ܣ�/����٦r=K���c�:a�s|)I��L<l3�.�����=]l>Ƴ��
�67��I�\"ۄ31��F�J@5� ی�Wd��(����CSf�����h����}Z^7��^Up5gT[kQm�qA9\�7�=$� q9��`(���7�DbY紉8�[;p7�?>�ǚ��i�*3V�J�0�(-e����Hk������8�Z;ĥ���i8�
��#��l�g���$x�����?h���~���=��\���h
G��z:�OMEq�Qf�%�C:���J[�2�}S�ْL�o�B7f>us�&3*k�� �#�����
!�r��lh6&W��I#~j'�O6R�c~����Ӧ޽+��:�jj�������ɢ.�m��%�]�╰2;*�6F�]R|
fQ�0\l��I���y>����*�����*UT��1 s��e�H�2Q��q����W�`������VgW2<�v���p�:�FL;�-�����o�<�4��7M-!12x"42M鯐����f󫇧��t�����;�����I����(��c��{Ch���egH�����*������xk�w��#�ͦ�
;�Y����AV�Ô	���#��0����D_��3kn=��#�,��c88B��4U*NG��k4$��0)!�orsx/��77׻�7���Bnk�M�V�dNz8����π��3x�x�I�R/��R�Ɍ�!iJ���Q�0����Y���R^�y<Č��(���A)��u��jG�JJo疋�=�i��=c�h��l���7}-3Cgw�����w�w?$���{��GKTV�R<\�    %,�"͈g�]�"�Z'�t��6�������@�n�jѫ���J
pŸ�Ǿ�F�mE�3���?�A@/4˘)?ϔ:���R� 	�Ѱ��,�`��TrC6��vͳ���4)�ob9���g�C|^^�4����_�����:�ᢨ����)���Q?�⒰"sw(.C�}��.W�^iEuj��=�v���π������8��S³������C��>�~��*���.�ر��˙{f!2���âN��6	��ඏCld�$�<�~�3��J��.�[��!z������
J �WY�2A\w��5�\���vʏ)�HK���囖���t���^��6����|���=�/2��ϝW~���E"^�x��Q��0ݎ,��ݬ����E��@���\$����TT��N�φt��<|ς����am�տ�	��J���+w�eI������k\�GX�DD��&��~+���w�zbѶ����g�$@k�;W��2ȴ)���+ei��G�f���ޖt4��IY ��GΈz򽅏���ӬC���]���"�o�u���áR0�CS��o�֟�;6K��@�����8��B�U�����ha��U2����Bc�qA�D�e�b��d�{M��wh��R�p�Yn���۪��kR�Dã^�7�niY�Z�Mw����л��j�0Z��_��e
I�'�e�n�	��c���@�8ѹ�B�S��u��'��ũ����L鯱.�B�5�t�9/>�=����B���lu�7�������j��3��u���,�U:�]H�� Y?�7%x��-��C�x
�kj�؆�m{��)}��o�'��;>Z����}?t�h\�7�&����=�,���c�| z�p��?�!ѓ����.�[o�0�{�گ���4��r����0�be������c+�!�7�)��s�v|$Qn��_�Va�s�u��8m�Vjn�K-#9�����@� �q���%{�{�-��ֳ���a�f�8�4&%�U"�g8M�}���T^{1��k������qf	���mJ_<�ͥ�0�IC���lv�%Q�*x7ף�t[���eal��s���A���]��Z�a,�X`G׻WҔO7~�J՛��6N�����{_{)o�]�	�QQ^/G3$��]+�����06H�0(�ˑ�Q7X)l�*/�g�iJ�[�]�}�iR�&������w���HA*��̍��p�^�
.�K����(f�rLLsT����pZ`{�F�%�Ҧ�ۢ\�~������8\�����r��\A�p�:�A-�4�(�U�W"[�fVl~��E���?���3��GA��zAB��&�Q
Ch߉������_
Vm]q�Yc%�4��x���W&��^��Abe\.�_����#pK�TTf(��t%Bwz
�pv*cƵ<S�a�6�</�L�z{!��w<䮄`'n���q3���MAa�Q0���vNR{NB��'\�aJ�}�2�w!׭Ŧ<���o��)Gft*̔8ǈ�+6����Ȑ�ڐ���V-�#���	o�Vy�����j~?6���I�3}��x�����Ų@�d��B��f���x�9�~ٝ��F�8X2��L��@�0���bS*�����Xၸ|}���;3լ��.�bQ�_���u��ج;,0�ę]��Or9��¥ܖcT�Ҁ2�fy��5���o��4���}������.pd������4�����Jҏp�-�� tg	v#�dt� �twߙ�����B�]��	f��>w^�ݸ���7�e�5g{>�ƽ��"������v}��u��U���2g?��0���|׽q�ݰx�)�f(K���H"��Z�A�^"�u�%��'o��Mq�����(�*LɆl\lF��Ӆ�}�����w�j-��dN�S
��7����_�>���`C%y�X:[*����n4e�J�D�N�;۔v�y��~2��z3���o�C��C.O�Q ���Z���b�C ^���X3����LY�9c�˵�ÕB�t��3�}���uW�������|����a�Q����sl�P%�����7�|�v�`�0�8���S���$(4mI������ut����3��~����R	�N�ŏ�y�?浰z��� ���Ay��g��7�1]�	V���?����w�C�f$e����L���}�L��}����~��?L���
f!����F���w"cv�R6�ĮġjG�4�~� ��'�1*r���)��}�J�a:𕻺�h�7>��an����M�b�t�v�3�EH��0BI����ֲ�1���2�W�3���H�-�����$�(�Gj��������c(� � ��`�)�~�����]�3��r��M��+�{�J�T�tC�z�ŷ�M��(�A���9��3�+��P	�)W�)�Es��6)W98	j��<���A�#� Z-�������7
���]��^l�j�(��c���)j�-�+����)�	6�>�l+�X��'�3X�n^&� r�J��g�`hQ{S2BX|�[SPR���t��'�jf�0(X�?J���CÞ,K�d�Mѳ�c#m��Յ�������]��'�Έ��?�HX�*�#��2�܋W@���PLIq\��M��y"Q�it�e{�����F��vZ��NK��sp>�e�lP�����߻L���@.�Sg�3Ô>ݹN�w�1��������z�\���#۪;��dq����q-
a3Ô��H6\N- �������� ㉾@�C$���i$��qʞ�κ\F�1�I��4��Cqǐo��L�ү����ȁ�}�lr1��˰��_!�y�o0��ikN9f�z�=�'<b��IH�h�7GEé�3�oz�s�$r�c�}|}w�!8����/v:*q���M郑봇k�bo���(,ƗJ��~�{��$�<i��Н:�a�`��1y�N/mJ9}���L�Oxߔ���������Fj�u��y0W�h�h��,j�J8�f��J<}��!4���X�2����6��2�nn�����^<����J�_8�d�S^�po�9�a�<�X
I�+MDl�D=��Õ�S�X�������Y�n,��x���Q�)d@���6/�;�
�=��%ϸ�*!*�u��#��ޠ�ˁ?�U�{:FD䷅��,�re�&�rw���[�o(��8��ϯڰzӬC�'�3���.Լ4��{:(�4)��8�J�b5љ�ר�i!�{s�G'{T�{�O_��K��CH�u��_H���<�<��"'�O����0�)����5�@,wq-	��0�O�S��a���rv�p��~�.��������PC���cS��r�M�2,�kY`�f��7�k���/�[��j7N:�M'$�k�TI���ӟ8r/��	ct�g)=r�~r�bz��6��m�_vu����g�w�h�݁���g\"��� B�YM���)���"�e�HD$H�S�:�������M�	���,�g�w�
��ʃˎ��h��!���e'�+=S?��ά��z@ұ�*�M����ܵ�$�T�������(�3M�����&/u?^�N�\t��{x�.�5x�_{�ST�:�4�ķ�p��M��*D�>iJ_�C!�'P��%?��ѳB��G���9�8<�S�M���(��<紐∽G9�gM�=a�ʽS�1��(��׾���+�O*�f��Y���a��E������ʹ�b��cI�z���=��X7����K;Xm��q��:9��)���L�1�b��X��c@���_�Xd��z��wR6k�n��Z�ѫ%1�Dԕp�6�8��<��¹ާ�<
ь瘞�H���CQ�w��u3L�#�W�˞A���B����1�����o�>�3�.sK�)t9õf�8�1�.ϔ> �.���c�^إy���8�	�� S�~o��q-3	e�$�q)��w3���̎�B����O_ބ��5���~��.}�%d4F�jC���"jC&��!N�s#�7�J�]�Z�T�	��%}��    �x�U{�7�nG����+\�-�^����P��:,���'�q���p�D*e��)W��Tk��BA������p��� At)������� ;&� I�`�!5|��]���>�LS��S��	��U���c@�̔F�����@婛�;�<�����P�˟��r��w�L�B?�{ϒ��vGL��~���(,#�����A�g����N=/�g��?x��@����@|**���?xO?��[�`���3�L��!���aP�X���ޕ�x�^̇� �$�E|�N�,`�M�&�^<�O�D���{��_�u/}A��u��l.�cH����9\��I��	���yе9��;v񊑸��p�q�T��@)K�؜��>�7��7'��z�N�!wSX�2��R`?l6�	��,����;���Xbto^�aJ��\ϡh�r����f�tyQ�t�+�𢡊�f��\,=^��?��<���ْ�ٲ�`��8#b!�O<�6e8~;�r�5������(l���:ء�g�>2�n"a쮊*y8ђ%�F�X,y��I鶴��&�3L<�>�^�u���-����Ϣ r�"n9ɵ�q�0�"�i49jD��f�m��ωVS9����o�T��C5z.�HL$�/��;["*��g���r�\Kp�=h����Q�G�2�:��Ky�C9~�k�^\�.�%��Ù�o���&�g���v�t��ct9xj?V?��#��J8�F�6W�|̐��XY�ۏ405��w���;!OY!�-�RF��B`�s5�R-��G��z3<B��v�^�_���� P�r�w������zE���"0Q#M�P�?a�2���NG �Ak	��iət�)Ճ�>R�uQ�!����l5/�+���A'���*����J��Ƣ��
�,AK�oR9܊��{\M���0�/Q���&#��%�G�y�;��m_��[�RL=4��c�Ƹ��u*�������I��.T�{//�SB^�`G���#�?�_8�r�"�2@�*'G;�pFJ�#w
�&�#�t��F^{�a���ϓ�JmЀx�0�4�w��`�	��L��FO�X��D����DD_1\�V�)e��4˒�^�q%�y�>?	&��yI�P�sy��?v�R>��E���U�(uj�c�%uD��E�lVT�.�[��>�Ω�9��	���<J1ng�T�*=�sM��3�O�Iu�Iv]|�ڭ����
�](SQyP� E
q��)��x����/Ll��>����<a?~�f�LH��ʸ���+�ʎ+g����MW�vnF����zT����8աj�<PY�\f�ZL�]o�؋�J����Q/���Q�� ��<5Ô��I�+��>Q���H@8Ts����������*b��t*cv�<S:�{��z��?^�u[�����Koz�W��x�`s8��{{
y�"�9"^�v{���Y`G] ;Pb{2Ӕ>�]��͵�׋��Y}ܽ�Ƹ���G����m���-���1�4[����s׵ݔ�	�K��Tjh�~+5mJ�'�W������\ȯ�z��8g��Qwdn������[܈���9�)�tzN�f�~=����U���׆O�����8c����]	�
���] ��7Z��)R�{N��M�p�ZS�9��b)`2�[
c�4���N8ה.J�����s��'o�����λ����ٓ�mw1":�K�����ln��'ArX�����Ċ��t�>�X�p�r?�MxA8�>�N�/�w�e��<������iS.�$r����
[@6�ݙ����u�|�8/i"�Y}:����������A�W�-���3\!F��o�[�����l�DxT�	�!M�TU$H�4���.����`t.nߺ��ϛq�5�`��:�,�5 ��{#xǨU�k-�C٢��!�UK��E��d���49M��L)�߶�R�/�~ɫ���D�R���A��$���w{Pk̍"��y����j�#L-n�z�����F��~$�g�ҏ�<n�-�f{�v7��l^ܛ�/D�3W��`1�%��"�"��%�
�t�g��\'y������`1��u���C*7c�{ϔz���y�S�:~�����/z��ap17�bi/9J�����\y0��/N����9�ČGL>o�I��H��p��3\C�+��K0���qh?�A�,�FS����a�l�G��N4�A�p]^_�)B�[�Ŝ����3�b��}I���{%l��c��p����h��HT1���<�˹���c-� 2-��Y��\S*�y����B�E��9�|�p�j�o]W�f(Syy�e�~�q|\��pP�i�w�k�0}�)��P(78��iS��wΗ��p�+��meIGא���n%�n��ɮ�̬��<ܫ��!�`<N��m�(v=j�h�)}^狳�9����r~�x����pT����pLG>J�j��?��	�2"�D��X�Jw���9U68�̹3s淓�X�g]���}��ëL���TN���a2�� p,�cɑ����R�@\�	ɢj�i���J"Rp��sw4?���&�[9Z?�������Y8W�u^��l�_�'�כŇ�4��#GA�ɢ���R�tw��^����zbM�C޽<�����MW�����	��H�^T*,|L��/�lm�b
�an��tt���LÃ��Bs��S�T��#�'�+�ܶ�rM���=�X���!WS��7��k����̤�����=+w��M_���?S�:aI�rox�0����c��f�_7�t�n;�h��v�?F�.c�PwE�HX�XF��{U�s=�!Y�	K�U���2)��|x�=9o�.�j������ ���4�F�pU���o8��S��N��$<��}o35�J�.p#��g�TM.���s�7��ؖ������>'�y8FO
�������p].�_%��ݤ��b0�z�x�G�tH�c'U�h���ft��t�����u��ty���Wӯ�5��(&�Q;�x[�g�`���?�`�B;3�(}r��� X��K�
�,i�E}�pm��]�iR��\=>�Ǭ <�seԃ`�=)�����m��h��`qK2Mv"*U"2�F4���^�N�r��e�z���u�◯>J���s�}ƥ��ҴlK�A�����ʳaN��:����M�W�NV/��$��׍�� ���.�5kE(7��b���SL�S���郜���0ag[��:�tJ��˃ǲ�y��}X��Ұ~j}��#*�-g�uq���M$df���zII�C�����^D �(.,U�93���.��d��7�2�7��>�?���z4}x��K�=�1��rs$�q��F���bb�����y"��=�%� ��iQ.�&:�&���-;���<��I��M[������&����k��
�zZwr�!ֱ��#%�M�Dn���l�����Д~�ΰ|��ro�?�Kak��an��u��4�b2�\a6J�qg�3�hQ"=Ӄ�����9��ku��E](�!\��%i��ߜ���f|�JB���wu��e8�D2~�V!r����֢p�-��y��mG�uN�d��͘��}Tlڔr�����eG~-�_�k�Up�`�j�Z�)v��f6rP�IN�9"�Y��	*O�3q"���iJ���f�/����N���ˇ�L��(Thv]�I������B~�"�$��+v\_!� 'x)sM��f�9�FδR#�6j�Z.Eƴ����W�l�c��ϑ�A"�����S�=�Ցw�ޚ�9���̲��|��PCz��{9Ya���)��X���}����KF�]��KԏBk�G�3�KE&���f�5Qf�e�.�>m���;�Q�y�ܛ,�(���(����(�'ٸ�R�D�e�}��)uJ������ p����r��C��MK�8�[�͹���uuU௼���"�	�fk<(�#~�N.�O�6�gX7܌6���1���j�wk�w�����k��{    xL��;N����\��b��O��y��u9jJ��<��{ȳ�Z�%���w�b^-rS�44�t.W��x�Q�e�¥e��Dm�8ϔ�'ϫJ�K��%������=W����pw�l�-]��Ey�g4������)=����[S�t����"�&�b��f�䮊�vŲiyNb	�� �%�d��LS��ziT�Bi��/�_����pCBJEl�U��\C�h5U�8�A.�֜��A�����$;Qj���ۡ���ɤ�)C��_=wZ�R����6h��x�Q��C��Yo8��7�'Ib^8'^�Jۘ?��}�z������Sn��S��[�QM�z_�̺}ȫ4��2���Аdñ.�'���2X|��ҷp�#�,<�vF��z�v�؉p;�'���
s?W���<4��!�i��CE�[�.�_�ճ���]�a�N�1����z��E���i��{qZt�@(���5�.�����&��Iյ�;5�\S�����z�ݽu{-������#s���2X��@�)�uo��qB[��q�ͨ&:��JGE�4�څg�$fB"M/��{&ϔj����z�)�|�-߮o:�;�B�̕�����b��O�Op�����<���ua-K��DJD �!<%�s`J���K�w�������+53��.R�e<���j�#�fr�#<~ #�I-���+ �����&Oe_��O ��(��ͯ������Dj�|-դ�'��a���E(���E岽*mJ�/�>��aW屷����I.#�<�R�)�{�J� ��ԟ>�Z��ɯp�JiP�ô ��W%,"G�w��ŭ�#e=����`	���p�PM��/� ! a0\^�,�'��n4�����+�H�¿�Z���r�~T1�ۙi��?��ݹ�W�w���.���{�`H\՘f���ď��P��IS �p,��4���.Ό�H�@3MiǷS��m:�ø��v;,���W"y��^���#[lh��$�դ����)<U�43?R�|F\7�4pL���]�3�9�n'�&���Zi:��5Vu|�شeRAF��z��mwB��i�-M"��,��0�!�ʙ��L��-�wE(.K%;���K��e/�Кq�
����J!�Da�j�K.�l^�f�,	=�s*�yEeG��Q�Hi��Qg��N��_6�[>L�_�鳯~�v ��K!��"�����8�٨��kf�F�O�,p0�e#�āƪ<�Nּ-iJ?� �;�:U�Z�����5*^���X�xb�$u"�,@X,��Mۚ0��I�"1�Bw���;s�AE�iJ�7��gۤW-�ո]�J(� �f�ё��L������� b:���Ń�=��"#	t�Ċ�����ͧ,�7����ec9�7�.O>��a��R�A&)y�9��\�K��GU��p�PW��ۆ31וV��l 0�t&��eI���U�76#+ܘ����Tl��k���Z/��|��ސ��3��<�$E�?��lb��l�R,�(��Y$��?@�ɥ��Kܽo3mJ?������N'�������v�>�W��[�����K@L�B�d=H|R�3Ge�*�Y\�%����=��S괫�'��:s+���ɲ(|��$6z��,���1�]	�??��.'1z��t�蛝iL??1Yd�)���ϫ�98�j�Ry�?�BՇ�E�hQ;8&A0�"��"}�ɖ��s%�V)�:�k;IDF(L�ҧ�7����u�5�,o�=zQƃW���!�q=��kx�u[���qЌ�c�1�������N�6ӝϮ��햽T1�h���
�q�@����Pi�������x܏��:8���G$��LSz�Iuo<jD2�뻫�E���Ȟ�=�`A)8�7��h�&���_��m���r�]߈�o�[^�0�O��	'N��*ξz�����$V �̑�J�b�(�����ep�	s�m�
�3���Gf�ؤ騏�թV/�wU���aJ�����j��iuUq����e7K�Lb�-�n1���#����T	������R��3��Z������t�����#DRGf����1�G��p�X��c���K�یW6�\Ԗ��]�9kJ���[@J^�Q]�Q�e�`%M�X��ܗ?�Rwd���\%#H��"�ݐ��V��&��@P#�Ϲե/�v�ʵ��z݇�}�Iڔ~����z�\�������K��7�w������⿃�b{dC�5�����*$&�j�H�Xa�3���/*��j�y����6� e�`G&�ð�/ֆ�*,p�+��lG���z{���(��`��������m�9��Njj���y�-��aЛ���b���˘�N;n�1���G�L�t����j`k~w�j�Q�n�I���Yn|�55��>i������3���XI�T"����������x�9��rh%��ʊ�{p�l�0�92�8.���_ڔj���y�9i�͢i�+�m�5R ��(��Xlm]x�O�k��s�gA/�O�f�N8M3fq�Ii�����)sm�&eNv��*�ճ�F���߈W�=�� ^���zP����b[�.)�c���ܜ�S����/;��h
r�:2k������H��������y/[�O|��h�Ui��4�wL]c�������%�۵/׍��L ���2erIvt"�kw��'"p��п���
JBgR��Cq�����DZ�(��G�D��=�ݹ�o*��%�}Ⱥp�t���^)�<ͫe\�1���	���8=d��7��u7O*�h�S�s5r��$o�z���7�$T�y�U_�De��~Tz��}���c7�r�ٽQ�'�J3������4�}~���:ůo��o�w¯!����#�pb����eAY�[sn$ �7l�C`��ȱ�@P�B�0/`�M�R.n�z�У&5���܏j�	��3�JR��fW$��/��"�֋��Ll/���Y���G_���a�Zp�\�Dr2�v�*�͎nqsJP;6B��"w���������m����X#Nw���,�# CH�NzҔ�Fݓ��F�!��|��=}� b��K_y���i�f'���Sh����l�9����Ԯ43��3"\k�t�Fdtu'��_U��xٖ�m]�K|�J.���oli���pV �鬗������:�<�]��L8��Оa�)}Nz_�gӺ����V�Q�A۸� 0�<��7�~��QP�!Ҹ�L�/1�ad��W|��"���b��2a*�'M?���'�4�˯ى.>t���J��q,#�������΅!|2���II�"�T��Dn!}`168n�Eg���E#X��k��LH��CC\��$1�lj�9V�Ã�c��9�l��aJ��F~n�/[ޮwng_S������w��(W�M鳒�;��`�u�ס��iupB���W�204��
��zK٦T�%^�M�ˈu��z���ϻP��R������zG�:��$Z���N,=��+r�)�R%:0�Έx9��.�&d5��ī|?{x��vW�e��S� ԟ6���x���-Bj.@A��nEKn����8��ţ��K}�ȱ~� ծ�k�v�׭�Z;mIq��쭚�.��P^���,�2o���X�J����P��?�GT�!n�Š��]�x����T&u"6ｺAݖ���ɲZ�%�-�����?�%(��E+f1,�?S���~H	�җ8r�]�Î����gJ�����ލ<T�<���b��̙��iغAl�	eR^�������"Zр��vj\�R���lS:�4n�+�%��*�~��X8���2v�xB��E��������w��h��5��lj;�L\w��wI��I�C]����q7R[b�)Ir��@��R�~Y��F8n=���9�?��s\o���!=w�Ė�ȷ�[M\��Nnw'&����<�W.98p��? �"8ɾ�D�v��V��ׇ�ɽ��:���e�; �b�    �#�+�b(��ĵ$P{ t��$P��*����Н����������B5+\L�P�,F�e���40����Rϖ�&����"ة�d��7I�s@�����R�����-&���w�`P��O�p�s�a6��
�9�F�4ĆbVo*C�c��<S�a����d6p�f/�"8�9��ʄ�Yz���8jYE��(�_�����J�pU4�'\���\������Z�&Of�Z����Oz��Fj�m����Z���!��>{�`�m(�]QL,'�s�lĚ��`�;�f�	��ȹ�����nr,�iJ��Cﾶh!���a�J���g�7=F1)X`��Y��u�(*'�X�밄^��QUx?�JY���J�$'xD��>>t�|��\����H ���p͇�←8���kR��<����N˹���]Ys�H~ƿ��}��1+�T��0l��Al�C��`0�\6����R	aI�{bf��:;���R�_~�}~]Q�8Ì`U�,�J&
��"Of�?��t]���((�|<�{��QT��)����t�+��r"e�*�I<��P���T��Io}oq��դ�(�-ݯ��}�^F�u�Y�T�SDؗ�t���` AT'�ES���Fd�R���e���!h'm=a*�xf��wݩ�5�E������զYgo�%�v�"�)�FSD��Tٷ�,�Jd�(g7~�?=�pY�1I�(�S܎o�W4�,l���f8��@S�4u�	MU�yv����74�)��5u9F�M�D�~����p�]W+1��o����7�ʲ�ι+������P7�%�%��վ���=��ncz�ݪ���PmY`Ry�6E�}�������?-��?f�#�pT��Y��+;:�p1�;����2���>_��tY�]S�.,p}�a��b�F-	i^&�Ԭ	S~�S�k�KR8������6KL&<I�(}��yu]ii>������q�jB�l�\$�%%vQ��-9"��� ��?����n�(�WI�6q,ׁ���pd�(�:�R{����O��Kh�Qx��L೥k�L�v��0�4��vm;�"�-@��Wz�l"4�%�j��K��v?����N�l�o[ҿ��U;6�V��Ez���Ǣx5�M��OA�q��efV�h ����[/ăԂ��4# ���D*6��~�uX���F���ѬQ��G�u���B� 6+���,��׏����c;�ɭ6}�b��K�kb*B}e��e���~nj��3��,D�ѩ,��F��N_~��o,�}��	t����I�����	(]<n�
k��S\�݌jJ���J����[�E��ц��+��k��y���F�Z��55������9�:
J�=��[��c��|��H��Lf�%kg��҃P	����}�����	��q,&R;.m{Q�Ƒz�R�,�)JE!�Z#�v�Q��Q�H�{�����5�.�72֖t�\�!�����$�y_Ľ���tgw�� 5�;��iuۚC��(��FHQ<� f>e�h/O�s�h�Xt
�"Ņ�x;�}*�����ﰎ�}��7W�[~���)�S�k����'k�?(� ��,哢�;�U�!m��L�W�ϫ�	7���'X�= �����DUo_�rjL�z#��Ī�����mi��w#�q��ՙ�{	�J<�4�1K�1~�O�spS���# ���
�D��^]�)����g��Z~�3�P���;���(����?�S�@\B@���sړ��R@f�J��+��H�Xn���)˶�!*$��X���9{R۹��Cc���ٚ]ި֢�BB;���x�U|_s"3�My� ��	�I��e����<,�9	���S�'��{�%���՛2�]��#$�ppz�P���у!񞴊���3�L����O��b�]	�ܕbH<m+�E��_�ӥ���%���P6�woo�21\]K������.؜	��s�\���c!�1�0a&geẓ�����[k*�ո�T�u�)![��BH4$����&�w1���v�,RE�C@/DqC΂T,o7wп�T�j4݆K�L5(-b".�٤��xy����j��ON?��[F�i��B�v���(�c��Y1�~/^�e[���&��y�2 oĭô��	�w�(mJ���3���l<���.�=��#���R�هdz5+V�!dL�A��鼊[���R1T5x��C�����M�2^�=�6O�%xq�<�<>Y���&z�J �x�;2��
)���ՍX��X�Lr������k�.����虌���&I�]�~l��<���,����,,C��e�R��3R�%���i瘭����-�����,s��9_�mDօ�&>O�6!Z�|E�C�3�7�׫q���ә.�?�����@�����I�/|�̞�ڕ0�Rf�]��%f�ڡ�R���(��`p�\��7�:qּ=�w��=BR���l��裁e3��H��;��� 'U�<v�>�	�G�(�̘Ғ���ռ�ե��Z��Շ�)�p���[�6��������F��4���W1vS�/��mwGk��\6'�5��q��%�__���Ƙ�V����?Ac��
�ũ� �`%���P�o�('W�Xjm�LEOT@�	�,�"/���ϳ����H�roY=���޷�p�"/��a�m5�[��2�&��RF�7HǓ s��R�a����7�S��"����Մn�+���ձ׀���wqꧽzF�j͑9�{�%K��z�ZW�	a�qC!�0R%�4����}�����O�e�~)5�^�K+p+���G�_}t~�..0I�P��`s�u	KF��\svhX1D��ZZT���Djo�[�&?����|�=�k=�.ʗ��kIl9w�����(Xg��}�����+�����W���E� ^ÿ�6i��+�|��8,�И1R�	�Q���è�m�h�I��M�J`L�<��q��X"�Ƽd:�2���ǒ�$h����t��멦%Z/�ޣ"��;y����)!���x:n�#pg�f�?�v��kZ-F}$C�����K�5���(�2ۤ�bf8� Ip8+Z��3ELe���mݚv���7�F'�-F`�8�C���Ty��6v�V��z �@AY����1�@�N��	�W
k,V��0O�Jˬ�Ǜ��,�������݊�2����*���VX�+n��=��+�y	��"">�U�����X~��4�I��7���q�Z{^��"ҦF	��Ά� f�a4���q�vmS@��[��P��
<x���DO��o]�ϥ]���O�+��'�]�)�'Q��ϑ�Ճ���J.μ�F�K�/Y�Q��w����5�֩�<4iG��28�o�U�!����N�G#r�g4�f)sTQ/�6�?\��v��|�Ȥ.��\�s�x�,�iH��E)���[��bP�_!��zy�����LA���;Bb��ew����+Q�QV�����D��-������c~��Z.�8)���1TA�H���(�#�Y1f�͜ ��b�@s���(Ӣ_ٷO$� �R������u��G$ZTu�N�����0�Q��� �b�iF��c��<Q��|���Ⴆ��S��߽���.�d��R�E�m١�c�, ,l�u�m�����D8�4�D�
-��/�4I켻n�i��ٽ�G:�vз���x=�@�D1\D�A-�(�(�b�<��_%���J��D�W�`���fb� �E�;�[�L6�4���n��,�Qc*�2U�n����"6_�������I�O7.nH���2�#�ɢ���Re�p�Dv�g�+���&E<��a�7�h��c8 �qi�QR,����f���B^AR�� ̐C%n_�O+L�T���������s���:M���'�����z]Ԏ8��\R��x�:Y=p��U<��sR[?�(~�eC�?Kԇ�n�q�{bD6%�e?�Ac~��!$��\}��},�ay[���p��p:�-��5�엉:W?&��uޜ���P{��TRe���_��uq�:<�l��	��ԑ�w����:���?��;�qAqtͮ��Pښ�e��� �  �x�t�(�Dsur���j��ۻ�q�����7��z~Qo<7C�(��s�V`�!��!u�F�A���_gP�&����͎4�CtY���H�~"���m4Y��1_oO'�k��\�E�ږ���|�&q\&�p����on]��Jq�/ G��4��-M����ny]wך���T��e� �B���Q��`M���a��ҏ)�8��z���cS��=��AM�|��c��sL����<*�!/��;��㾈�0wX����TR^��6�>���i�!ߗ��ZMG���ǩ��;F,�KE�SYWb{(���&��q��{�d���(䂇�%����u��G��5]���E�>s��#�3�pP�t4�!~�-`��idmm"�v�G�gf��f�R��h��� MNB�.���<p�2�u���uC�|����`��~UG�-���׌            x������ � �      �   �   x�}ι�@�zy
Z�wY*Q#����'^ O/�N��4S�g���,��qtM�LC���NO��Su����l�r뙈�įpT垓�b9|,��1�t��;e(F����P�"̤ut̸���c�֑��D�&��p��[�׮��ʱT�/�i��|·�����9G��'�]���7L�	�d�������j�_U�%Iz�O�     