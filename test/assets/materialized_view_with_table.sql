CREATE TABLE IF NOT EXISTS table_for_view (
  test integer,
  test2 text
);

CREATE MATERIALIZED VIEW matview_from_table AS
  SELECT test, test2 FROM table_for_view;
