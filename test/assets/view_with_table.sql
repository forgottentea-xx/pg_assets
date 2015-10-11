CREATE TABLE table_for_view (
  test integer,
  test2 text
);

CREATE OR REPLACE VIEW view_from_table AS
  SELECT test, test2 FROM table_for_view;
