-- =====================================================
-- TRIGGERS DE INTEGRIDAD
-- =====================================================

CREATE TRIGGER validar_cursada_condicion_nota_insert
BEFORE INSERT ON cursada
FOR EACH ROW
BEGIN
	SELECT RAISE(ABORT, 'Un inscripto no puede tener nota cargada')
	WHERE NEW.condicion = 'inscripto' 
		AND NEW.nota_final IS NOT NULL;
	
	SELECT RAISE(ABORT, 'Una cursada regular debe ser NULL')
	WHERE NEW.condicion = 'regular' 
		AND NEW.nota_final IS NOT NULL;

	SELECT RAISE(ABORT, 'Una cursada aprobada requiere una nota ≥ 4')
	WHERE NEW.condicion = 'aprobado' 
			AND (NEW.nota_final IS NULL OR NEW.nota_final < 4);

	SELECT RAISE(ABORT, 'Una cursada recursa no puede tener nota cargada')
	WHERE NEW.condicion = 'recursa'
		AND NEW.nota_final IS NOT NULL;

	SELECT RAISE(ABORT, 'Una cursada libre no puede tener nota cargada')
	WHERE NEW.condicion = 'libre'
		AND NEW.nota_final IS NOT NULL;
END;

CREATE TRIGGER validar_cursada_condicion_nota_update
BEFORE UPDATE OF condicion, nota_final ON cursada
FOR EACH ROW
BEGIN
	SELECT RAISE(ABORT, 'Un inscripto no puede tener nota cargada')
	WHERE NEW.condicion = 'inscripto' 
		AND NEW.nota_final IS NOT NULL;
	
	SELECT RAISE(ABORT, 'Una cursada regular debe ser NULL')
	WHERE NEW.condicion = 'regular' 
		AND NEW.nota_final IS NOT NULL;

	SELECT RAISE(ABORT, 'Una cursada aprobada requiere una nota ≥ 4')
	WHERE NEW.condicion = 'aprobado' 
			AND (NEW.nota_final IS NULL OR NEW.nota_final < 4);

	SELECT RAISE(ABORT, 'Una cursada recursa no puede tener nota cargada')
	WHERE NEW.condicion = 'recursa'
		AND NEW.nota_final IS NOT NULL;

	SELECT RAISE(ABORT, 'Una cursada libre no puede tener nota cargada')
	WHERE NEW.condicion = 'libre'
		AND NEW.nota_final IS NOT NULL;
END;