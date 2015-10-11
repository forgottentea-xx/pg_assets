CREATE TABLE test (
  test text
);

CREATE OR REPLACE FUNCTION womp() RETURNS trigger AS $$
        BEGIN
                RETURN 'WOMP';
        END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger1 BEFORE INSERT OR UPDATE ON test
    FOR EACH ROW EXECUTE PROCEDURE womp();
