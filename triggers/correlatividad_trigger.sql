-- =====================================================
-- TRIGGER DE CORRELATIVIDAD
-- =====================================================

--Trigger en cursada para validar que legajo tenga la correlativa aprobada.

CREATE TRIGGER validar_correlativas
BEFORE INSERT ON cursada
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'No cumple correlativas')
    WHERE EXISTS (

        SELECT 1
        FROM correlatividad co
        WHERE co.codigo_materia = NEW.codigo_materia

        AND (

            -- correlativa fuerte → debe estar aprobado
            (
                co.tipo = 'fuerte'
                AND NOT EXISTS (
                    SELECT 1
                    FROM cursada c
                    WHERE c.legajo = NEW.legajo
                    AND c.codigo_materia = co.codigo_correlativa
                    AND c.condicion = 'aprobado'
                )
            )

            OR

            -- correlativa de cursada → debe estar regular o aprobado
            (
                co.tipo = 'de_cursada'
                AND NOT EXISTS (
                    SELECT 1
                    FROM cursada c
                    WHERE c.legajo = NEW.legajo
                    AND c.codigo_materia = co.codigo_correlativa
                    AND c.condicion IN ('regular', 'aprobado')
                )
            )

        )
    );
END;