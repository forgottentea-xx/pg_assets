CREATE TABLE test2 (
  test text
);

CREATE OR REPLACE FUNCTION womp2() RETURNS trigger AS $$
        BEGIN
                RETURN NEW;
        END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger2 BEFORE INSERT OR UPDATE ON test2
    FOR EACH ROW EXECUTE PROCEDURE womp2();
