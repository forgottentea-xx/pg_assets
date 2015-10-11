CREATE OR REPLACE FUNCTION function1() RETURNS text AS $$
        BEGIN
                RETURN 'so simple';
        END;
$$ LANGUAGE plpgsql;
