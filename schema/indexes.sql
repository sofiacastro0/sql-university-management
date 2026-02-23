CREATE INDEX IF NOT EXISTS idx_cursada_legajo ON cursada(legajo);
CREATE INDEX IF NOT EXISTS idx_cursada_codigo_materia ON cursada(codigo_materia);
CREATE INDEX IF NOT EXISTS idx_cursada_id_profesor ON cursada(id_profesor);