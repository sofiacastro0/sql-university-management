-- =====================================================
-- REPORTES ÚTILES DEL SISTEMA ACADÉMICO
-- Descripción: consultas analíticas
-- =====================================================

-- =====================================================
-- REPORTE 1: promedio de nota por estudiante
-- =====================================================
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    ROUND(AVG(c.nota_final), 2) AS promedio
FROM estudiante e
LEFT JOIN cursada c ON c.legajo = e.legajo
WHERE c.nota_final IS NOT NULL
GROUP BY e.legajo, e.apellido, e.nombre
ORDER BY promedio DESC;

-- =====================================================
-- REPORTE 2: materias aprobadas por estudiante
-- =====================================================
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    COUNT(*) AS materias_aprobadas
FROM estudiante e
JOIN cursada c ON c.legajo = e.legajo
WHERE c.condicion = 'aprobado'
GROUP BY e.legajo, e.apellido, e.nombre
ORDER BY materias_aprobadas DESC;

-- =====================================================
-- REPORTE 3: promedio de nota por materia
-- =====================================================
SELECT
    m.nombre AS materia,
    ROUND(AVG(c.nota_final), 2) AS promedio
FROM materia m
JOIN cursada c ON c.codigo_materia = m.codigo_materia
WHERE c.nota_final IS NOT NULL
GROUP BY m.nombre
ORDER BY promedio DESC;

-- =====================================================
-- REPORTE 4: cantidad de estudiantes por materia
-- =====================================================
SELECT
    m.nombre AS materia,
    COUNT(*) AS cantidad_estudiantes
FROM materia m
JOIN cursada c ON c.codigo_materia = m.codigo_materia
GROUP BY m.nombre
ORDER BY cantidad_estudiantes DESC;

-- =====================================================
-- REPORTE 5: ranking de estudiantes por promedio
-- =====================================================
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    ROUND(AVG(c.nota_final), 2) AS promedio,
    DENSE_RANK() OVER (ORDER BY AVG(c.nota_final) DESC) AS ranking
FROM estudiante e
JOIN cursada c ON c.legajo = e.legajo
WHERE c.nota_final IS NOT NULL
GROUP BY e.legajo, e.apellido, e.nombre;

-- =====================================================
-- REPORTE 6: tasa de aprobación por materia
-- =====================================================
SELECT
    m.nombre AS materia,
    COUNT(CASE WHEN c.condicion = 'aprobado' THEN 1 END) * 100.0 / COUNT(*) AS porcentaje_aprobacion
FROM materia m
JOIN cursada c ON c.codigo_materia = m.codigo_materia
GROUP BY m.nombre
ORDER BY porcentaje_aprobacion DESC;

-- =====================================================
-- REPORTE 7: estudiantes sin cursadas
-- =====================================================
SELECT
    e.legajo,
    e.apellido,
    e.nombre
FROM estudiante e
LEFT JOIN cursada c ON c.legajo = e.legajo
WHERE c.id_cursada IS NULL;

-- =====================================================
-- REPORTE 8: Materias más cursadas
-- =====================================================
SELECT
m.nombre,
COUNT(c.id_cursada) AS cantidad
FROM materia m
LEFT JOIN cursada c ON c.codigo_materia = m.codigo_materia
GROUP BY m.codigo_materia
ORDER BY cantidad DESC;

-- =====================================================
-- REPORTE 9: Ranking con DENSE_RANK
-- =====================================================
WITH conteo AS (
SELECT
m.codigo_materia,
m.nombre,
COUNT(c.id_cursada) AS cantidad
FROM materia m
JOIN cursada c ON c.codigo_materia = m.codigo_materia
GROUP BY m.codigo_materia
)
SELECT *
FROM (
SELECT *,
DENSE_RANK() OVER (ORDER BY cantidad DESC) AS ranking
FROM conteo
)
WHERE ranking <= 3;

-- =====================================================
-- REPORTE 10: Estudiantes en riesgo
-- =====================================================
SELECT
e.legajo,
e.apellido,
e.nombre
FROM estudiante e
JOIN cursada c ON c.legajo = e.legajo
GROUP BY e.legajo
HAVING SUM(CASE WHEN c.condicion = 'aprobado' THEN 1 ELSE 0 END) = 0;

-- =====================================================
-- REPORTE 11: Profesores sin alumnos
-- =====================================================
SELECT
p.id_profesor,
p.apellido,
p.nombre
FROM profesor p
LEFT JOIN cursada c ON c.id_profesor = p.id_profesor
GROUP BY p.id_profesor
HAVING COUNT(c.id_cursada) = 0;

-- =====================================================
-- REPORTE 12: Profesores con más estudiantes en un anio y cuatrimestre.
-- =====================================================
SELECT
profesor.id_profesor,
profesor.apellido,
profesor.nombre,
profesor.titulo,
profesor.estado,
COUNT(DISTINCT legajo) AS cantidad_estudiantes
FROM cursada
LEFT JOIN profesor   ON profesor.id_profesor = cursada.id_profesor
WHERE cursada.anio = 2026
    AND cursada.cuatrimestre = 1
GROUP BY profesor.id_profesor, profesor.apellido, profesor.nombre, profesor.titulo, profesor.estado
ORDER BY cantidad_estudiantes DESC;

-- =====================================================
-- REPORTE 13: Cantidad de inscripciones que tuvieron las materias en un anio y cuatrimestre (incluyendo 0)
-- =====================================================
SELECT
    m.codigo_materia,
    m.nombre,
    m.anio_plan,
    COUNT(c.id_cursada) AS total_inscripciones
FROM materia m
LEFT JOIN cursada c ON c.codigo_materia = m.codigo_materia
    AND anio = 2026
    AND cuatrimestre = 1
GROUP BY m.codigo_materia, m.nombre, m.anio_plan
ORDER BY total_inscripciones ASC;
/*INDEX UTIL
CREATE INDEX IF NOT EXISTS idx_cursada_anio_cuatri_materia
ON cursada(anio, cuatrimestre, codigo_materia);
*/
