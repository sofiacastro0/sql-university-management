-- =====================================================
-- AUDIT TRIGGER
-- =====================================================

CREATE TRIGGER cursada_audit_condicion_nota 
AFTER UPDATE OF condicion, nota_final ON cursada
FOR EACH ROW
	WHEN (OLD.condicion IS NOT NEW.condicion)
	OR (OLD.nota_final IS NOT NEW.nota_final)
BEGIN
	INSERT INTO cursada_audit(id_cursada, old_condicion, new_condicion, old_nota, new_nota)
	VALUES(OLD.id_cursada, OLD.condicion, NEW.condicion, OLD.nota_final, NEW.nota_final);
END;