--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: array_median(double precision[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION array_median(double precision[]) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$
          SELECT CASE WHEN array_upper($1,1) = 0 THEN null
                      ELSE asorted[ceiling(array_upper(asorted,1)/2.0)]::double precision END
             FROM (SELECT ARRAY(SELECT $1[n]
                      FROM generate_series(1, array_upper($1, 1)) AS n
                     WHERE $1[n] IS NOT NULL
                     ORDER BY $1[n]) As asorted) As foo
      $_$;


--
-- Name: median(double precision); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE median(double precision) (
    SFUNC = array_append,
    STYPE = double precision[],
    FINALFUNC = array_median
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: currencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE currencies (
    id integer NOT NULL,
    name character varying NOT NULL,
    converter integer NOT NULL,
    code character varying NOT NULL,
    buy_price double precision NOT NULL,
    sell_price double precision NOT NULL,
    exchange_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE currencies_id_seq OWNED BY currencies.id;


--
-- Name: exchanges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE exchanges (
    id integer NOT NULL,
    name character varying NOT NULL,
    quotation_date date NOT NULL,
    publication_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: exchanges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exchanges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exchanges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exchanges_id_seq OWNED BY exchanges.id;


--
-- Name: reports; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW reports AS
 SELECT c.code,
    c.converter,
    (avg(c.buy_price))::numeric(10,4) AS avg_buy_price,
    (avg(c.sell_price))::numeric(10,4) AS avg_sell_price,
    (median(c.buy_price))::numeric(10,4) AS median_buy_price,
    (median(c.sell_price))::numeric(10,4) AS median_sell_price,
    (date_part('year'::text, e.quotation_date))::integer AS year,
    (date_part('month'::text, e.quotation_date))::integer AS month
   FROM (exchanges e
     JOIN currencies c ON ((c.exchange_id = e.id)))
  GROUP BY c.code, c.converter, (date_part('year'::text, e.quotation_date))::integer, (date_part('month'::text, e.quotation_date))::integer;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY currencies ALTER COLUMN id SET DEFAULT nextval('currencies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exchanges ALTER COLUMN id SET DEFAULT nextval('exchanges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (id);


--
-- Name: exchanges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY exchanges
    ADD CONSTRAINT exchanges_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_currencies_on_exchange_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_currencies_on_exchange_id ON currencies USING btree (exchange_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_f9c11b60ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currencies
    ADD CONSTRAINT fk_rails_f9c11b60ac FOREIGN KEY (exchange_id) REFERENCES exchanges(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150731170016');

INSERT INTO schema_migrations (version) VALUES ('20150801085501');

INSERT INTO schema_migrations (version) VALUES ('20150801085619');

INSERT INTO schema_migrations (version) VALUES ('20150801151414');

