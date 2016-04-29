CREATE OR REPLACE VIEW dependentview2 AS
  SELECT 1;

CREATE OR REPLACE VIEW dependentview1 AS
  SELECT * from dependentview2;

CREATE OR REPLACE VIEW dependentview3 AS
  SELECT * from dependentview2;
