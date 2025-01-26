--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-01-26 22:57:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 233 (class 1255 OID 17146)
-- Name: getallexhibitionnames(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getallexhibitionnames() RETURNS TABLE(exhibitionname text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT OfficialName FROM Exhibition;
END;
$$;


ALTER FUNCTION public.getallexhibitionnames() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 17145)
-- Name: getexhibitiondetails(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getexhibitiondetails(exhibition_id integer, OUT exhibition_address text, OUT exhibition_dates text) RETURNS record
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT Address, Dates
    INTO exhibition_address, exhibition_dates
    FROM Exhibition
    WHERE ExhibitionID = exhibition_id;
END;
$$;


ALTER FUNCTION public.getexhibitiondetails(exhibition_id integer, OUT exhibition_address text, OUT exhibition_dates text) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 17144)
-- Name: getexhibitionnamebyid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getexhibitionnamebyid(exhibition_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (SELECT OfficialName FROM Exhibition WHERE ExhibitionID = exhibition_id);
END;
$$;


ALTER FUNCTION public.getexhibitionnamebyid(exhibition_id integer) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 17148)
-- Name: getexhibitionsbydirection(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getexhibitionsbydirection(direction text) RETURNS TABLE(exhibitionid integer, officialname text, address text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT e.ExhibitionID, e.OfficialName, e.Address
    FROM Exhibition e
    JOIN Director d ON e.DirectorID = d.DirectorID
    WHERE d.Directions LIKE '%' || direction || '%';
END;
$$;


ALTER FUNCTION public.getexhibitionsbydirection(direction text) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 17147)
-- Name: getexpensiveapplications(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getexpensiveapplications(min_cost numeric) RETURNS TABLE(applicationid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT a.ApplicationID
    FROM Application a
    WHERE a.Cost > min_cost;
END;
$$;


ALTER FUNCTION public.getexpensiveapplications(min_cost numeric) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 17143)
-- Name: gettotalexhibitions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gettotalexhibitions() RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM Exhibition);
END;
$$;


ALTER FUNCTION public.gettotalexhibitions() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 17166)
-- Name: log_exhibition_truncate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_exhibition_truncate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    VALUES (CURRENT_TIMESTAMP);
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.log_exhibition_truncate() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 17163)
-- Name: logapplicationdelete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.logapplicationdelete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO ApplicationLog(ApplicationID, ParticipantID, OperationType)
    VALUES (OLD.ApplicationID, OLD.ParticipantID, 'DELETE');
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.logapplicationdelete() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 17159)
-- Name: logapplicationinsert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.logapplicationinsert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO ApplicationLog(ApplicationID, ParticipantID, OperationType)
    VALUES (NEW.ApplicationID, NEW.ParticipantID, 'INSERT');
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.logapplicationinsert() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 17165)
-- Name: logapplicationtruncate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.logapplicationtruncate() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO ApplicationLog(OperationType, OperationTime)
    VALUES ('TRUNCATE', CURRENT_TIMESTAMP);
END;
$$;


ALTER FUNCTION public.logapplicationtruncate() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 17161)
-- Name: logapplicationupdate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.logapplicationupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.Cost <> OLD.Cost THEN
        INSERT INTO ApplicationLog(ApplicationID, ParticipantID, OperationType)
        VALUES (NEW.ApplicationID, NEW.ParticipantID, 'UPDATE');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.logapplicationupdate() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 17114)
-- Name: accommodation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accommodation (
    accommodationid integer NOT NULL,
    transportid integer,
    hotelname text,
    recommendations text
);


ALTER TABLE public.accommodation OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17090)
-- Name: application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application (
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


ALTER TABLE public.application OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17150)
-- Name: applicationlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicationlog (
    logid integer NOT NULL,
    applicationid integer,
    participantid integer,
    operationtype text,
    operationtime timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.applicationlog OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17149)
-- Name: applicationlog_logid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applicationlog_logid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applicationlog_logid_seq OWNER TO postgres;

--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 228
-- Name: applicationlog_logid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applicationlog_logid_seq OWNED BY public.applicationlog.logid;


--
-- TOC entry 225 (class 1259 OID 17130)
-- Name: applicationwithtax; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.applicationwithtax AS
 SELECT applicationid,
    participantid,
    service,
    cost,
    (cost * 1.2) AS costwithtax,
    participationstatus,
    applicationdate,
    ispaid,
    confirmationstatus
   FROM public.application;


ALTER VIEW public.applicationwithtax OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17052)
-- Name: director; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director (
    directorid integer NOT NULL,
    contactdetails text,
    exhibitionconcept text,
    goals text,
    tasks text,
    directions text,
    themes text
);


ALTER TABLE public.director OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17059)
-- Name: exhibition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibition (
    exhibitionid integer NOT NULL,
    directorid integer,
    dates text,
    address text,
    officialname text,
    "position" text,
    contactinfo text
);


ALTER TABLE public.exhibition OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17071)
-- Name: program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program (
    programid integer NOT NULL,
    exhibitionid integer,
    eventname text,
    eventdateandtime text
);


ALTER TABLE public.program OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17134)
-- Name: exhibitionwitheventcount; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.exhibitionwitheventcount AS
 SELECT e.exhibitionid,
    e.officialname,
    e.dates,
    e.address,
    count(p.programid) AS totalevents
   FROM (public.exhibition e
     LEFT JOIN public.program p ON ((e.exhibitionid = p.exhibitionid)))
  GROUP BY e.exhibitionid, e.officialname, e.dates, e.address;


ALTER VIEW public.exhibitionwitheventcount OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17083)
-- Name: participant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participant (
    participantid integer NOT NULL,
    organizationname text,
    contactdetails text,
    activityfield text,
    sectionordirection text
);


ALTER TABLE public.participant OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17138)
-- Name: participantexhibitiondetails; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.participantexhibitiondetails AS
 SELECT p.participantid,
    p.organizationname,
    e.officialname AS exhibitionname,
    a.service,
    a.cost
   FROM ((public.participant p
     JOIN public.application a ON ((p.participantid = a.participantid)))
     JOIN public.exhibition e ON ((e.exhibitionid = ( SELECT ex.exhibitionid
           FROM public.exhibition ex
          WHERE (ex.exhibitionid = a.participantid)
         LIMIT 1))));


ALTER VIEW public.participantexhibitiondetails OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17126)
-- Name: publicdirectors; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.publicdirectors AS
 SELECT directorid,
    exhibitionconcept,
    goals,
    tasks,
    directions,
    themes
   FROM public.director;


ALTER VIEW public.publicdirectors OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17102)
-- Name: transport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transport (
    transportid integer NOT NULL,
    applicationid integer,
    necessityinfo text,
    recommendations text,
    providedgoodsorservices text,
    transportname text
);


ALTER TABLE public.transport OWNER TO postgres;

--
-- TOC entry 4696 (class 2604 OID 17168)
-- Name: applicationlog logid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicationlog ALTER COLUMN logid SET DEFAULT nextval('public.applicationlog_logid_seq'::regclass);


--
-- TOC entry 4877 (class 0 OID 17114)
-- Dependencies: 223
-- Data for Name: accommodation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accommodation (accommodationid, transportid, hotelname, recommendations) FROM stdin;
1	1	Отель Искусство	Рекомендуется проживание вблизи выставочного центра
2	2	Гостиница Техно	Комфортабельные номера для групп участников
3	3	Отель Зеленая Долина	Эко-дружественное жилье недалеко от места проведения
4	4	Архитектурный Люкс	Отель в стиле минимализма с высоким рейтингом
5	5	Цифровой Уют	Современные номера с высоким уровнем комфорта
6	6	Гостиница Здоровье	Рекомендуется для участников семинаров по ЗОЖ
7	7	Отель Наука+	Рядом с университетом и научным центром
8	8	Кино Отель	Рекомендуется для участников кинофестиваля
9	9	Гостиница Высокая Мода	Роскошные номера для VIP-гостей
\.


--
-- TOC entry 4875 (class 0 OID 17090)
-- Dependencies: 221
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application (applicationid, participantid, service, serviceconditions, cost, participationstatus, applicationdate, ispaid, confirmationstatus) FROM stdin;
1	1	Аренда стенда	10 м2	5000.00	Подтверждено	2024-12-01	t	Подтверждено
2	2	Проведение мастер-класса	60 минут	1500.00	Подтверждено	2024-12-02	t	Подтверждено
3	3	Экспонат	1 изделие	3000.00	Ожидание	2024-12-03	f	На рассмотрении
4	4	Презентация проекта	30 минут	2000.00	Подтверждено	2024-12-04	t	Подтверждено
5	5	Спонсорство	Логотип на баннере	10000.00	Подтверждено	2024-12-05	t	Подтверждено
6	6	Продажа продукции	5 наименований	2500.00	Ожидание	2024-12-06	f	На рассмотрении
7	7	Реклама в каталоге	1 страница	1200.00	Подтверждено	2024-12-07	t	Подтверждено
8	8	Выступление на панельной дискуссии	20 минут	1800.00	Подтверждено	2024-12-08	t	Подтверждено
9	9	Организация модного показа	30 минут	5000.00	Подтверждено	2024-12-09	t	Подтверждено
10	10	Дегустация блюд	10 позиций	3500.00	Ожидание	2024-12-10	f	На рассмотрении
\.


--
-- TOC entry 4879 (class 0 OID 17150)
-- Dependencies: 229
-- Data for Name: applicationlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicationlog (logid, applicationid, participantid, operationtype, operationtime) FROM stdin;
\.


--
-- TOC entry 4871 (class 0 OID 17052)
-- Dependencies: 217
-- Data for Name: director; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director (directorid, contactdetails, exhibitionconcept, goals, tasks, directions, themes) FROM stdin;
1	director1@example.com	Искусство и культура	Продвижение местных художников	Организация выставки	Творческое развитие	Современное искусство
2	director2@example.com	Наука и инновации	Стимулирование исследований	Координация мероприятий	Технологический прогресс	ИИ и робототехника
3	director3@example.com	Устойчивое развитие	Повышение осведомленности	Управление экспонентами	Экологическая направленность	Зеленая энергия
4	director4@example.com	Современная архитектура	Демонстрация инноваций	Организация мероприятий	Архитектурные достижения	Городской дизайн
5	director5@example.com	Цифровая трансформация	Вдохновлять развитие технологий	Координация участников	Революция технологий	Облачные вычисления
6	director6@example.com	Здоровье и благополучие	Пропаганда здорового образа жизни	Планирование семинаров	Фокус на сообщество	Ментальное здоровье
7	director7@example.com	Образование и исследования	Стимулирование обучения	Управление программами	Обмен знаниями	STEM-образование
8	director8@example.com	Кино и медиа	Празднование творчества	Организация кинофестивалей	Медийный охват	Кинематография
9	director9@example.com	Мода и тренды	Выделение дизайнеров	Координация модных показов	Глобальное влияние	Устойчивая мода
10	director10@example.com	Еда и культура	Популяризация кулинарного искусства	Планирование дегустаций	Многообразие и единство	Мировая кухня
\.


--
-- TOC entry 4872 (class 0 OID 17059)
-- Dependencies: 218
-- Data for Name: exhibition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibition (exhibitionid, directorid, dates, address, officialname, "position", contactinfo) FROM stdin;
1	1	2025-01-15 по 2025-01-20	ул. Искусств, 123	Арт Экспо 2025	Менеджер	expo1@example.com
2	2	2025-02-10 по 2025-02-15	ул. Технологий, 456	Ярмарка инноваций	Координатор	expo2@example.com
3	3	2025-03-05 по 2025-03-10	ул. Эко, 789	Саммит устойчивого развития	Директор	expo3@example.com
4	4	2025-04-01 по 2025-04-05	ул. Архитекторов, 12	Ярмарка современной архитектуры	Координатор	expo4@example.com
5	5	2025-05-10 по 2025-05-15	ул. Цифровая, 34	Мировой саммит технологий	Менеджер	expo5@example.com
6	6	2025-06-20 по 2025-06-25	ул. Здоровья, 56	Экспо здоровья	Директор	expo6@example.com
7	7	2025-07-15 по 2025-07-20	ул. Науки, 78	Ярмарка образования и исследований	Организатор	expo7@example.com
8	8	2025-08-05 по 2025-08-10	ул. Кино, 90	Кинофестиваль	Директор	expo8@example.com
9	9	2025-09-10 по 2025-09-15	ул. Моды, 123	Экспо моды	Менеджер	expo9@example.com
10	10	2025-10-15 по 2025-10-20	ул. Еды, 456	Шоу кулинарного искусства	Координатор	expo10@example.com
\.


--
-- TOC entry 4874 (class 0 OID 17083)
-- Dependencies: 220
-- Data for Name: participant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.participant (participantid, organizationname, contactdetails, activityfield, sectionordirection) FROM stdin;
1	Искусство Галерея	contact@artgallery.ru	Искусство	Современное искусство
2	ТехКорп	info@techcorp.ru	Технологии	ИИ и робототехника
3	ЭкоРешения	support@ecosolutions.ru	Устойчивое развитие	Зеленая энергия
4	АрхСмарт	info@archsmart.ru	Архитектура	Городской дизайн
5	ОблакоИнноваторы	cloud@innovators.ru	Технологии	Облачные вычисления
6	Здоровый Образ	health@healthy.ru	Здоровье	Психическое здоровье
7	НаукаПлюс	research@plus.ru	Образование	STEM
8	МедиаМейкеры	media@makers.ru	Кино	Кинематография
9	МодаВперед	fashion@forward.ru	Мода	Устойчивые тренды
10	Мировые Шефы	chefs@global.ru	Кулинария	Мировая кухня
\.


--
-- TOC entry 4873 (class 0 OID 17071)
-- Dependencies: 219
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program (programid, exhibitionid, eventname, eventdateandtime) FROM stdin;
1	1	Семинар по современному искусству	2025-01-16 10:00:00
2	1	Встреча с художниками	2025-01-17 14:00:00
3	2	Панель по искусственному интеллекту	2025-02-11 11:00:00
4	3	Мастер-класс по зеленой энергии	2025-03-06 09:00:00
5	4	Воркшоп по городскому планированию	2025-04-02 10:00:00
6	5	Доклад по облачным вычислениям	2025-05-11 14:00:00
7	6	Сессия йоги и медитации	2025-06-21 09:00:00
8	7	Панель STEM-образования	2025-07-16 11:00:00
9	8	Кинопроизводство 101	2025-08-06 15:00:00
10	9	Тренды устойчивой моды	2025-09-11 13:00:00
\.


--
-- TOC entry 4876 (class 0 OID 17102)
-- Dependencies: 222
-- Data for Name: transport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transport (transportid, applicationid, necessityinfo, recommendations, providedgoodsorservices, transportname) FROM stdin;
1	1	Необходим транспорт для перевозки оборудования	Рекомендуется использовать грузовой фургон	Оборудование для выставки	Фургон Ford Transit
2	2	Транспортировка участников	Использовать пассажирский автобус	Перевозка участников	Автобус Mercedes Sprinter
3	3	Перевозка экспонатов	Требуется изотермический транспорт	Произведения искусства	Грузовик MAN TGM
4	4	Доставка рекламных материалов	Рекомендуется использовать малотоннажный транспорт	Рекламные материалы	Минивэн Volkswagen Caddy
5	5	Транспортировка выставочного оборудования	Требуется грузовик с гидробортом	Выставочные стенды	Грузовик Isuzu NPR
6	6	Доставка продуктов питания	Нужен рефрижератор	Продукты питания	Рефрижератор Hyundai HD35
8	8	Транспортировка звукового оборудования	Рекомендуется использование специального кейса	Звуковое оборудование	Микроавтобус Fiat Ducato
9	9	Доставка мебели для выставки	Использовать грузовик с защитой от повреждений	Мебель для выставочного зала	Грузовик Volvo FL
10	10	Перевозка участников VIP	Рекомендуется комфортный автомобиль	VIP-гости	Седан BMW 7 Series
7	7	Перевозка декораций	Использовать автомобиль с открытым кузовом	Декорации для сцены	Грузовик Газель
\.


--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 228
-- Name: applicationlog_logid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicationlog_logid_seq', 1, false);


--
-- TOC entry 4711 (class 2606 OID 17120)
-- Name: accommodation accommodation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accommodation
    ADD CONSTRAINT accommodation_pkey PRIMARY KEY (accommodationid);


--
-- TOC entry 4707 (class 2606 OID 17096)
-- Name: application application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (applicationid);


--
-- TOC entry 4713 (class 2606 OID 17158)
-- Name: applicationlog applicationlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicationlog
    ADD CONSTRAINT applicationlog_pkey PRIMARY KEY (logid);


--
-- TOC entry 4699 (class 2606 OID 17058)
-- Name: director director_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director
    ADD CONSTRAINT director_pkey PRIMARY KEY (directorid);


--
-- TOC entry 4701 (class 2606 OID 17065)
-- Name: exhibition exhibition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibition
    ADD CONSTRAINT exhibition_pkey PRIMARY KEY (exhibitionid);


--
-- TOC entry 4705 (class 2606 OID 17089)
-- Name: participant participant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant
    ADD CONSTRAINT participant_pkey PRIMARY KEY (participantid);


--
-- TOC entry 4703 (class 2606 OID 17077)
-- Name: program program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (programid);


--
-- TOC entry 4709 (class 2606 OID 17108)
-- Name: transport transport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (transportid);


--
-- TOC entry 4719 (class 2620 OID 17164)
-- Name: application afterapplicationdelete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER afterapplicationdelete AFTER DELETE ON public.application FOR EACH ROW EXECUTE FUNCTION public.logapplicationdelete();


--
-- TOC entry 4720 (class 2620 OID 17160)
-- Name: application afterapplicationinsert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER afterapplicationinsert AFTER INSERT ON public.application FOR EACH ROW EXECUTE FUNCTION public.logapplicationinsert();


--
-- TOC entry 4721 (class 2620 OID 17162)
-- Name: application afterapplicationupdate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER afterapplicationupdate AFTER UPDATE ON public.application FOR EACH ROW EXECUTE FUNCTION public.logapplicationupdate();


--
-- TOC entry 4718 (class 2606 OID 17121)
-- Name: accommodation accommodation_transportid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accommodation
    ADD CONSTRAINT accommodation_transportid_fkey FOREIGN KEY (transportid) REFERENCES public.transport(transportid);


--
-- TOC entry 4716 (class 2606 OID 17097)
-- Name: application application_participantid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_participantid_fkey FOREIGN KEY (participantid) REFERENCES public.participant(participantid);


--
-- TOC entry 4714 (class 2606 OID 17066)
-- Name: exhibition exhibition_directorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibition
    ADD CONSTRAINT exhibition_directorid_fkey FOREIGN KEY (directorid) REFERENCES public.director(directorid);


--
-- TOC entry 4715 (class 2606 OID 17078)
-- Name: program program_exhibitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_exhibitionid_fkey FOREIGN KEY (exhibitionid) REFERENCES public.exhibition(exhibitionid);


--
-- TOC entry 4717 (class 2606 OID 17109)
-- Name: transport transport_applicationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transport
    ADD CONSTRAINT transport_applicationid_fkey FOREIGN KEY (applicationid) REFERENCES public.application(applicationid);


-- Completed on 2025-01-26 22:57:55

--
-- PostgreSQL database dump complete
--

