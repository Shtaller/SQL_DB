PGDMP  &    .                 }            ExhibitionDB    17.2    17.2     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    17051    ExhibitionDB    DATABASE     �   CREATE DATABASE "ExhibitionDB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "ExhibitionDB";
                     postgres    false            �            1259    17114    accommodation    TABLE     �   CREATE TABLE public.accommodation (
    accommodationid integer NOT NULL,
    transportid integer,
    hotelname text,
    recommendations text
);
 !   DROP TABLE public.accommodation;
       public         heap r       postgres    false            �            1259    17090    application    TABLE       CREATE TABLE public.application (
    applicationid integer NOT NULL,
    participantid integer,
    service text,
    serviceconditions text,
    cost numeric(10,2),
    participationstatus text,
    applicationdate date,
    ispaid boolean,
    confirmationstatus text
);
    DROP TABLE public.application;
       public         heap r       postgres    false            �            1259    17052    director    TABLE     �   CREATE TABLE public.director (
    directorid integer NOT NULL,
    contactdetails text,
    exhibitionconcept text,
    goals text,
    tasks text,
    directions text,
    themes text
);
    DROP TABLE public.director;
       public         heap r       postgres    false            �            1259    17059 
   exhibition    TABLE     �   CREATE TABLE public.exhibition (
    exhibitionid integer NOT NULL,
    directorid integer,
    dates text,
    address text,
    officialname text,
    "position" text,
    contactinfo text
);
    DROP TABLE public.exhibition;
       public         heap r       postgres    false            �            1259    17083    participant    TABLE     �   CREATE TABLE public.participant (
    participantid integer NOT NULL,
    organizationname text,
    contactdetails text,
    activityfield text,
    sectionordirection text
);
    DROP TABLE public.participant;
       public         heap r       postgres    false            �            1259    17071    program    TABLE     �   CREATE TABLE public.program (
    programid integer NOT NULL,
    exhibitionid integer,
    eventname text,
    eventdateandtime text
);
    DROP TABLE public.program;
       public         heap r       postgres    false            �            1259    17102 	   transport    TABLE     �   CREATE TABLE public.transport (
    transportid integer NOT NULL,
    applicationid integer,
    necessityinfo text,
    recommendations text,
    providedgoodsorservices text,
    transportname text
);
    DROP TABLE public.transport;
       public         heap r       postgres    false            �          0    17114    accommodation 
   TABLE DATA           a   COPY public.accommodation (accommodationid, transportid, hotelname, recommendations) FROM stdin;
    public               postgres    false    223   &       �          0    17090    application 
   TABLE DATA           �   COPY public.application (applicationid, participantid, service, serviceconditions, cost, participationstatus, applicationdate, ispaid, confirmationstatus) FROM stdin;
    public               postgres    false    221   (       �          0    17052    director 
   TABLE DATA           s   COPY public.director (directorid, contactdetails, exhibitionconcept, goals, tasks, directions, themes) FROM stdin;
    public               postgres    false    217   �)       �          0    17059 
   exhibition 
   TABLE DATA           u   COPY public.exhibition (exhibitionid, directorid, dates, address, officialname, "position", contactinfo) FROM stdin;
    public               postgres    false    218   \-       �          0    17083    participant 
   TABLE DATA           y   COPY public.participant (participantid, organizationname, contactdetails, activityfield, sectionordirection) FROM stdin;
    public               postgres    false    220   �/       �          0    17071    program 
   TABLE DATA           W   COPY public.program (programid, exhibitionid, eventname, eventdateandtime) FROM stdin;
    public               postgres    false    219   �1       �          0    17102 	   transport 
   TABLE DATA           �   COPY public.transport (transportid, applicationid, necessityinfo, recommendations, providedgoodsorservices, transportname) FROM stdin;
    public               postgres    false    222   w3       E           2606    17120     accommodation accommodation_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.accommodation
    ADD CONSTRAINT accommodation_pkey PRIMARY KEY (accommodationid);
 J   ALTER TABLE ONLY public.accommodation DROP CONSTRAINT accommodation_pkey;
       public                 postgres    false    223            A           2606    17096    application application_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (applicationid);
 F   ALTER TABLE ONLY public.application DROP CONSTRAINT application_pkey;
       public                 postgres    false    221            9           2606    17058    director director_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.director
    ADD CONSTRAINT director_pkey PRIMARY KEY (directorid);
 @   ALTER TABLE ONLY public.director DROP CONSTRAINT director_pkey;
       public                 postgres    false    217            ;           2606    17065    exhibition exhibition_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.exhibition
    ADD CONSTRAINT exhibition_pkey PRIMARY KEY (exhibitionid);
 D   ALTER TABLE ONLY public.exhibition DROP CONSTRAINT exhibition_pkey;
       public                 postgres    false    218            ?           2606    17089    participant participant_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.participant
    ADD CONSTRAINT participant_pkey PRIMARY KEY (participantid);
 F   ALTER TABLE ONLY public.participant DROP CONSTRAINT participant_pkey;
       public                 postgres    false    220            =           2606    17077    program program_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (programid);
 >   ALTER TABLE ONLY public.program DROP CONSTRAINT program_pkey;
       public                 postgres    false    219            C           2606    17108    transport transport_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (transportid);
 B   ALTER TABLE ONLY public.transport DROP CONSTRAINT transport_pkey;
       public                 postgres    false    222            J           2606    17121 ,   accommodation accommodation_transportid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.accommodation
    ADD CONSTRAINT accommodation_transportid_fkey FOREIGN KEY (transportid) REFERENCES public.transport(transportid);
 V   ALTER TABLE ONLY public.accommodation DROP CONSTRAINT accommodation_transportid_fkey;
       public               postgres    false    223    222    4675            H           2606    17097 *   application application_participantid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_participantid_fkey FOREIGN KEY (participantid) REFERENCES public.participant(participantid);
 T   ALTER TABLE ONLY public.application DROP CONSTRAINT application_participantid_fkey;
       public               postgres    false    4671    220    221            F           2606    17066 %   exhibition exhibition_directorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.exhibition
    ADD CONSTRAINT exhibition_directorid_fkey FOREIGN KEY (directorid) REFERENCES public.director(directorid);
 O   ALTER TABLE ONLY public.exhibition DROP CONSTRAINT exhibition_directorid_fkey;
       public               postgres    false    218    4665    217            G           2606    17078 !   program program_exhibitionid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_exhibitionid_fkey FOREIGN KEY (exhibitionid) REFERENCES public.exhibition(exhibitionid);
 K   ALTER TABLE ONLY public.program DROP CONSTRAINT program_exhibitionid_fkey;
       public               postgres    false    219    4667    218            I           2606    17109 &   transport transport_applicationid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transport
    ADD CONSTRAINT transport_applicationid_fkey FOREIGN KEY (applicationid) REFERENCES public.application(applicationid);
 P   ALTER TABLE ONLY public.transport DROP CONSTRAINT transport_applicationid_fkey;
       public               postgres    false    222    221    4673            �   �  x��S�N�@<�|���x�'p�)'>f׆��EI�Ey �H�wM�}x��R��V�8D�屻������6�R���1�2�1Me��*P�q�fl�s>�u*,S��GL���<>`��oL���)
+�2��MH�F���t��W�D8ǀ[2�����c���!&ę8Y��ƌP܈�%�X�s�h�Ҩf*��V:�`-FUa���D�_�Yg�B|$O6G�b� y =����h`,�\SgF�u���ں�m��pA��JӔޔLT�O��9?�WW�5l&�yv�����3��q�h f����|�;n���ǭ�F�w�<7�bEy:� )[$�1y�����ΉiI�Ke�˗��5[
2�6��F�5�!���ﹽ#2�di\#aH�z��@+�IL�oE��B�,��\i�������@�g��mɌ%M�[���1���N3?=��6��cm�R�>����;|���0Tn�?z��=�}      �   �  x��TIn�@<�_1 �1�_r�� �K�$�r��= ���=?Ju�㛧�����?�g\rʉ�c?9(��G����Z��8���3���#�9뺝�ulH��f�.����9�N�~��-��8�� @N�~Ba��k�QD��[L�#��4�6�֜����H����Q�=���M4 \��A̜�Kݚq��L�g��G�{"1휨k-x��hL1�WM�*?R�h��..�`x�K�a��Q�M(z�;�]D\ɤ�|ꧠ?�(V�,�2��ߐ�/m�wq}����.1���)�5�Y�/]���\[�M*h@����;ٝ���u&����Ơ6�-,!�D%��=�B4A��"�<(�>��Э��Y�Z	�I�˶�G����#~�q���^��<p�%���C�KA�K��
���t��      �   u  x�}V�nA<�~�� Qޏ��������"'Ơ�x(QB7���&�^��=Du����G���yTwUw�d)x�rg�����Ý��w_��Y�����H����KG�����HnZ����ā\�c(=H�F)�D2���
sl�i�Z�n���o�@.p�+1�n%6�$5�H:��Wc`�%�F75�TL^N"�K����ȕ�b9���,x�4�e�x���r8~L�i�ѱ�i"W�5P	�[���q�!������9�W��e��4U!����X t�d�`�?]l9�؎x��S�Lr��r����c1T�8\�|W�|�)�P2�HU���^R�c�~T�!��D�L������/�w�GT�@�p��E�w������dc�jM@�QL+�,�E=���*H;\��W������b�W������!e���7���n�S��3�+�n�)��dځ|e�h�����@�I�y�kU�p�ȵ��D$tDȁK5�/�(�嚬iMuD���Wm~��W_8	F��	^�n�����ļ@G��t�h6i��I�{��U�'�C�E�F�Cvb��l��"qSk��)p;B`R�0Y)�oX�B������X@��BV����I�p=2$�rf"X ��%�n��V)���F���O�:��)����M�S�|?����pRo�õ�t[D�ʈ�{����c��7=��*�3�iߣ���%�)QQ-A}���x�]��HJ*�r�lM4X�~�"�E}UwI%�Sݩ m�-�d���O'�S��cX�=?�R;��ˑҹ�mQ\�����N]�$9��JcuX���5�2�#�8\Z�ɰX��ݱ��wg�!�JmBs�s�E
g�ɗ;��2j����h"�;��s6��,�����I�<B�-�a��H�      �   *  x�}T�n�0<���`�$�q��R�5H�9�v� =�h��C�KQ�q����!M+�b�d��ڙ�R��8��(�#���V��8"=��X�g=嵞�)~3^������3����v��?�^�_��MNO���髣�7����AL��G2�A�=�w|}�J-op�rë�HUF�[W���5���l�Wo�2�k�-�K��A�uL�IB�c�������L�!�C�%�7�����[EP�W���f+�[�=B��}E�$Y{D��HJ�#�Bz��N���-��2}�y�U�H���[;��J��_-T��9�Ҁ�"�x���7� 8�qC���HR�ƽ2D��r�tև��6e�M��lwl>��SJ_6�C��Ũ���qepN��{�&���4?�4�'�m��s��	��+p3.�Ѡ�i��E��[�S�z�^ѳu������.#��RS7w�/�Qx%��칢�\q�f��� ���቗�㲵eJ��Q��;${\��04�ٻ�^3�Ո�m\?�d�y9�D��|      �   -  x�uSMo�@=�������������eq�:��F�▤EE
P�
Z
.H&��&�_��G���[�*��̛�ތ��ܘ�ܮ�М����j*��@����0L��$��'[��u�N��9W�7�5���Uf�ˊ>�)R��s��wl�Ga�t ���j�UT�'� �BIC_Q:��+:�B_Q�AC��3aQAC6l�Qh3���g��pj���a.�_�
/�**�P-`�;h�؝c뫊^�8�@v�h��4��\�F>�K�1��`u#j���h�=W`pJk}M���x�����9������0��v����#��4��{$(]�)f�,��N��v�a�f�B#��q�������:^%Z����B���y���� ��c�c��K7Vi�E�[0H�^�Eo/[]���n��7�o����X��ҋ�]���hc�!�ּ�>(eT<���=�~�1���s��RuLca��M��-x���H��xGb��M��%ή.����ǣ��N�$��I<K�QA�,��RY=��0X������C�NM      �   �  x�]�MN�0���)|��8�{��`�a�DP� �+����M m��
��f�R@�"��߼��FEo�ROT۩����h����N���ޖ�:lmligx
��*���oRm�Ӏ_/d�#�0�ΩR�k[R�'xm��G@�M� �
��`@���������4��xZ�?�B�m�c�*R���h�ԇ��,g�͗PZA���g0�B����R���~iD�����ΑV�o�����G [K����1��LU��	e����C4�Ṣ^c��^xg�;b"��f*���_.Ӵ�4�<���o~�M���NT�w<�g�>����m- �r�A�&����!,ɡñ�>*���;<�M��@���z���\����!f�^�V9F.)D�qu�y�7l@�`      �     x��U�NQ}>��4r�G� $�!��KC'�Ѵ�>�\c����>�"�``�a:-������i˴3�&�L�9{����gwL�):&��tnv�yI�l��Q��隺�f�4v��P㷋=�n�O��X9��3]l �<s���|,���%�@�3�B� 0��M.u�J������Q�#)�}v�i �sS�{����^+e�|�W�N���� �t��Z��Y�Gѷ4��r��&��	P�+�m�~)�����0��Kv�.��7�|�b��	5�����b���`�r�<f��>`�����@*���@]��^�K�IJ�C��Q��<\�kO2֤�T�����&}��B�����pQ�����~
�pѡÊ��H��$΄;k��i(��G6ʁ��^|���.��.���\nӚRSw�V�Q����-t�-�)���!��& �L���u�>��d)Բ1j�R�����W�Y�jz�6��4l���OND������1�2��1�3M��V�i�`�$���j!������)kV��)9���D��v���Ӣ!$�ً�``��+���X�)��̗bD/�=_��V�֜�K0�Y�����6S�XRW���A|���IK�#M��M�b�Qr�JH����΄��K����Zc^94���ʭ�ɲى�#�}y��c�
@����C�_2���~�y�g��]��ekF�$q=|��{�.�z'��yf�H�k�?e���?ƀm���{�{\zҝ�#�k��X/�[����Q�     