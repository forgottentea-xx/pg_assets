CREATE OR REPLACE FUNCTION function2(integer, text, integer) RETURNS text AS $$
        BEGIN
                RETURN 'not so simple';
        END;
$$ LANGUAGE plpgsql;
