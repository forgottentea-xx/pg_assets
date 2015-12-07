CREATE TABLE table_with_multiple_constraint (
  test integer CHECK (test > 1),
    CHECK (test < 2),
  test2 text UNIQUE NOT NULL
);
