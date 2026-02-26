-- =====================================================
-- CONSULTAS DE CONTROL ACADEMICO
-- Descripción: consultas para detectar incoherencias
-- =====================================================


--Materias nunca cursadas
--Descripcion: materias que no tienen ninguna cursada registrada.
SELECT
materia.codigo_materia,
materia.nombre
FROM materia
LEFT JOIN cursada ON cursada.codigo_materia = materia.codigo_materia
WHERE cursada.id_cursada IS NULL
ORDER BY materia.nombre;


--Alumnos en riesgo - Definición: tienen cursadas, pero 0 aprobadas
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    COUNT(*) AS total_cursadas,
    SUM(CASE WHEN c.condicion = 'aprobado' THEN 1 ELSE 0 END) AS aprobadas
FROM estudiante e 
JOIN cursada c ON c.legajo = e.legajo
GROUP BY e.legajo, e.apellido, e.nombre
HAVING SUM(CASE WHEN c.condicion = 'aprobado' THEN 1 ELSE 0 END) = 0 --pongo la expresion completa para que sea mas portable
ORDER BY e.apellido, e.nombre;

--Detectar incoherencias en condicion-nota
--Descripcion: Consulta que muestra: condición = 'aprobado' nota_final < 4 o NULL
SELECT
estudiante.legajo,
estudiante.apellido,
estudiante.nombre,
cursada.anio,
cursada.cuatrimestre,
materia.codigo_materia,
materia.nombre AS materia,
profesor.apellido AS profesor_apellido,
profesor.nombre AS profesor_nombre,
cursada.id_cursada,
cursada.condicion,
cursada.nota_final
FROM cursada
JOIN estudiante ON estudiante.legajo = cursada.legajo
JOIN materia    ON materia.codigo_materia = cursada.codigo_materia
JOIN profesor   ON profesor.id_profesor = cursada.id_profesor
WHERE cursada.condicion = 'aprobado'
    AND (cursada.nota_final IS NULL OR cursada.nota_final < 4)
ORDER BY estudiante.apellido, estudiante.nombre, cursada.anio, cursada.cuatrimestre, materia.nombre;


--Materias con menos de X inscripciones (X = 2)
SELECT
    m.codigo_materia,
    m.nombre,
    m.anio_plan,
    COUNT(c.id_cursada) AS cantidad_inscripciones
FROM materia m
LEFT JOIN cursada c ON c.codigo_materia = m.codigo_materia
GROUP BY m.codigo_materia, m.nombre, m.anio_plan
HAVING cantidad_inscripciones < 2
ORDER BY cantidad_inscripciones ASC, m.codigo_materia;


--Profesores con 0 alumnos
SELECT
    p.id_profesor,
    p.apellido,
    p.nombre,
    p.estado,
    COUNT(DISTINCT c.legajo) AS cantidad_alumnos
FROM profesor p
LEFT JOIN cursada c ON c.id_profesor = p.id_profesor
GROUP BY p.id_profesor, p.apellido, p.nombre, p.estado
HAVING cantidad_alumnos = 0
ORDER BY p.apellido, p.nombre;


--Profesores sin cursadas en un anio y cuatrimestre
SELECT
    p.id_profesor,
    p.apellido,
    p.nombre,
    p.estado,
    COUNT(c.id_cursada) AS total_cursadas_periodo
FROM profesor p 
LEFT JOIN cursada c ON c.id_profesor = p.id_profesor
    AND c.anio = 2026
    AND c.cuatrimestre = 1
GROUP BY p.id_profesor, p.apellido, p.nombre, p.estado
HAVING COUNT(c.id_cursada) = 0
ORDER BY p.apellido, p.nombre;


--Cursadas que incumplen correlatividades
SELECT
    c.id_cursada,
    c.legajo,
    e.apellido,
    e.nombre,
    c.codigo_materia,
    m.nombre AS materia,
    co.codigo_materia_correlativa,
    mc.nombre AS correlativa_faltante
FROM cursada c
JOIN estudiante e ON e.legajo = c.legajo
JOIN materia m ON m.codigo_materia = c.codigo_materia
JOIN correlatividad co ON co.codigo_materia = c.codigo_materia
JOIN materia mc ON mc.codigo_materia = co.codigo_materia_correlativa
WHERE NOT EXISTS (
    SELECT 1
    FROM cursada c_prev
    WHERE c_prev.legajo = c.legajo
      AND c_prev.codigo_materia = co.codigo_materia_correlativa
      AND c_prev.condicion = 'aprobado'
)
ORDER BY c.legajo, c.codigo_materia, co.codigo_materia_correlativa;