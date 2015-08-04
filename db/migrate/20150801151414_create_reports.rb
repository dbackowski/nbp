class CreateReports < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION array_median(double precision[])
        RETURNS double precision AS
      $$
          SELECT CASE WHEN array_upper($1,1) = 0 THEN null
                      ELSE asorted[ceiling(array_upper(asorted,1)/2.0)]::double precision END
             FROM (SELECT ARRAY(SELECT $1[n]
                      FROM generate_series(1, array_upper($1, 1)) AS n
                     WHERE $1[n] IS NOT NULL
                     ORDER BY $1[n]) As asorted) As foo
      $$ LANGUAGE 'sql' IMMUTABLE;

      CREATE AGGREGATE median(double precision) (
        SFUNC=array_append,
        STYPE=double precision[],
        FINALFUNC=array_median
      );

      CREATE OR REPLACE VIEW Reports (code, converter, avg_buy_price, avg_sell_price, median_buy_price, median_sell_price, year, month) AS
        SELECT code, converter, avg(buy_price)::NUMERIC(10,4), avg(sell_price)::NUMERIC(10,4), median(buy_price)::NUMERIC(10,4), median(sell_price)::NUMERIC(10,4),
          date_part('year', quotation_date)::INTEGER, date_part('month', quotation_date)::INTEGER
        FROM exchanges e
        JOIN currencies c ON c.exchange_id = e.id
        GROUP BY 1,2,7,8
    SQL
  end

  def down
    execute 'DROP FUNCTION array_median(double precision[]) CASCADE'
  end
end

