CREATE TABLE table_with_check_constraint (
  test integer CHECK (test > 0),
  test2 text
);
