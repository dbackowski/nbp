CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

CREATE OR REPLACE VIEW Reports (code, converter, avg_buy_price, avg_sell_price, median_buy_price, median_sell_price, year, month) AS
  SELECT code, converter, avg(buy_price), avg(sell_price), median(buy_price), median(sell_price),
    date_part('year', quotation_date), date_part('month', quotation_date)
  FROM exchanges e
  JOIN currencies c ON c.exchange_id = e.id
  GROUP BY 1,2,7,8