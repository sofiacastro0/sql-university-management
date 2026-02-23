--Listar estudiantes (legajo, apellido, nombre) ordenados por apellido.
SELECT legajo, apellido, nombre FROM estudiante ORDER BY apellido;

--Listar materias obligatorias del año 2.
SELECT codigo_materia, nombre, carga_horaria 
FROM materia 
WHERE anio_plan = 2 AND es_obligatoria = 1;

--Mostrar cursadas 2026-1 con: estudiante (apellido, nombre), materia (nombre), profesor (apellido), condición y nota.
SELECT 
estudiante.apellido, 
estudiante.nombre, 
materia.nombre, 
profesor.apellido, 
cursada.condicion, 
cursada.nota_final
FROM cursada
JOIN estudiante ON estudiante.legajo = cursada.legajo
JOIN materia    ON materia.codigo_materia = cursada.codigo_materia
JOIN profesor   ON profesor.id_profesor = cursada.id_profesor
WHERE cursada.anio = 2026 
    AND cursada.cuatrimestre = 1
ORDER BY estudiante.apellido, estudiante.nombre, materia.nombre;

--Contar cuántas cursadas tiene cada estudiante (incluyendo 0).
SELECT
estudiante.apellido,
estudiante.nombre,
estudiante.dni,
COUNT (cursada.id_cursada) AS total_cursadas
FROM estudiante
LEFT JOIN cursada    ON cursada.legajo = estudiante.legajo
GROUP BY estudiante.apellido, estudiante.nombre, estudiante.dni
ORDER BY estudiante.apellido DESC;

--alumno, materia, profesor, año, cuatrimestre, condición y nota.

--La consulta lista todas las cursadas realizadas, incluyendo datos del estudiante, la materia, el profesor y el estado académico, ordenadas por alumno.
SELECT
estudiante.apellido,
estudiante.nombre,
estudiante.dni,
cursada.anio,
cursada.cuatrimestre,
materia.nombre,
profesor.nombre,
profesor.apellido,
cursada.nota_final,
cursada.condicion,
cursada.fecha_inscripcion
FROM cursada
JOIN estudiante ON estudiante.legajo = cursada.legajo
JOIN materia    ON materia.codigo_materia = cursada.codigo_materia
JOIN profesor   ON profesor.id_profesor = cursada.id_profesor
ORDER BY estudiante.apellido, estudiante.nombre, estudiante.legajo DESC;

--Promedio de nota por estudiante (ignorando NULL) y cantidad de materias con nota cargada.
SELECT
estudiante.legajo,
estudiante.apellido,
estudiante.nombre,
ROUND(AVG(cursada.nota_final), 2) AS promedio_nota,
COUNT(cursada.nota_final) AS cant_materias_con_nota
FROM estudiante
LEFT JOIN cursada ON cursada.legajo = estudiante.legajo
GROUP BY estudiante.legajo, estudiante.apellido, estudiante.nombre
HAVING COUNT(cursada.nota_final > 0)
ORDER BY estudiante.apellido, estudiante.nombre;

--Materias más cursadas (top 3) por cantidad de inscripciones.
SELECT
materia.nombre,
COUNT(cursada.id_cursada) AS cantidad_inscripciones,
materia.anio_plan
FROM materia
LEFT JOIN cursada    ON cursada.codigo_materia = materia.codigo_materia
GROUP BY materia.codigo_materia, materia.nombre, materia.anio_plan
ORDER BY cantidad_inscripciones DESC
LIMIT 3;

--Profesores con más estudiantes en 2026-1.
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

--Estudiantes que cursan BD (por código 11510) y todavía no tienen nota.
SELECT DISTINCT
estudiante.apellido,
estudiante.nombre
FROM estudiante
JOIN cursada    ON cursada.legajo = estudiante.legajo
JOIN materia    ON materia.codigo_materia = cursada.codigo_materia
WHERE materia.codigo_materia = 11510
    AND cursada.nota_final IS NULL
ORDER BY estudiante.apellido, estudiante.nombre;

--Consultas de control académico

--Materias nunca cursadas
--Materias que no tienen ninguna cursada registrada.
SELECT
materia.codigo_materia,
materia.nombre
FROM materia
LEFT JOIN cursada ON cursada.codigo_materia = materia.codigo_materia
WHERE cursada.id_cursada IS NULL
ORDER BY materia.nombre;

--Estudiantes sin materias aprobadas
--(no sin cursadas, ojo con la diferencia)
SELECT
estudiante.apellido,
estudiante.nombre
FROM estudiante
LEFT JOIN cursada 
    ON cursada.legajo = estudiante.legajo
    AND cursada.condicion = 'aprobado'
WHERE cursada.id_cursada IS NULL
ORDER BY estudiante.apellido, estudiante.nombre;

--Estudiantes en riesgo
--Tienen cursadas pero 0 aprobadas.
SELECT
estudiante.apellido,
estudiante.nombre
FROM estudiante
JOIN cursada ON cursada.legajo = estudiante.legajo
GROUP BY estudiante.apellido, estudiante.nombre
HAVING SUM(CASE WHEN cursada.condicion = 'aprobado' THEN 1 ELSE 0 END) = 0
ORDER BY estudiante.apellido, estudiante.nombre;

--Pensar reglas (sin triggers todavía)
/*Detectar incoherencias
Consulta que muestre:
condición = 'aprobado'
nota_final < 4 o NULL
*/

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

--Promedio por alumno
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    ROUND(AVG(c.nota_final), 2) AS promedio_nota,
    SUM(CASE WHEN c.nota_final IS NOT NULL THEN 1 ELSE 0 END) AS cantidad_notas_cargadas
FROM estudiante e
LEFT JOIN cursada c ON c.legajo = e.legajo
GROUP BY e.legajo, e.apellido, e.nombre
ORDER BY e.apellido, e.nombre;

--Alumnos con > 3 cursadas
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    COUNT(c.id_cursada) AS total_cursadas
FROM estudiante e
JOIN cursada c ON c.legajo = e.legajo
GROUP BY e.legajo, e.apellido, e.nombre
HAVING total_cursadas > 3
ORDER BY total_cursadas DESC;

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

--Top 3 materias más cursadas en 2026 – 1, incluyendo empates
WITH conteo AS (
    SELECT
        m.codigo_materia,
        m.nombre,
        COUNT(c.id_cursada) AS cantidad_inscripciones
    FROM materia m
    JOIN cursada c ON c.codigo_materia = m.codigo_materia
    WHERE c.anio = 2026
      AND c.cuatrimestre = 1
    GROUP BY m.codigo_materia, m.nombre
)
SELECT * FROM (
    SELECT 
        codigo_materia,
        nombre,
        cantidad_inscripciones,
        DENSE_RANK() OVER (ORDER BY cantidad_inscripciones DESC) AS ranking
    FROM conteo
) AS ranked
WHERE ranking <= 3
ORDER BY cantidad_inscripciones DESC, nombre;

--Profesores con más estudiantes en 2026-1
EXPLAIN QUERY PLAN
WITH estudiantes_por_profesor AS (
    SELECT DISTINCT
        c.id_profesor,
        c.legajo
    FROM cursada c 
    WHERE anio = 2026 AND cuatrimestre = 1
)
SELECT
  p.id_profesor,
  p.apellido,
  p.nombre,
  p.titulo,
  p.estado,
  COUNT(*) AS cantidad_estudiantes
FROM estudiantes_por_profesor ep 
JOIN profesor p ON p.id_profesor = ep.id_profesor
GROUP BY p.id_profesor, p.apellido, p.nombre, p.titulo, p.estado
ORDER BY cantidad_estudiantes DESC;
--INDEX UTIL
CREATE INDEX IF NOT EXISTS idx_cursada_anio_cuatri
ON cursada(anio, cuatrimestre);

--reporte que lista todas las materias y cuántas inscripciones tuvieron en 2026–1, incluyendo 0
EXPLAIN QUERY PLAN
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
--INDEX UTIL
CREATE INDEX IF NOT EXISTS idx_cursada_anio_cuatri_materia
ON cursada(anio, cuatrimestre, codigo_materia);

--Materias nunca cursadas (en un período)
SELECT 
    m.codigo_materia,
    m.nombre,
    m.anio_plan,
    COUNT(c.id_cursada) AS total_inscripciones
FROM materia m
LEFT JOIN cursada c ON c.codigo_materia = m.codigo_materia
    AND c.anio = 2026
    AND c.cuatrimestre = 1
GROUP BY m.codigo_materia, m.nombre, m.anio_plan
HAVING total_inscripciones = 0
ORDER BY m.codigo_materia;

--Alumnos sin aprobadas
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    e.estado
FROM estudiante e 
LEFT JOIN cursada c ON c.legajo = e.legajo
    AND condicion = 'aprobado'
WHERE c.id_cursada IS NULL
ORDER BY e.apellido, e.nombre;

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

--Profesores sin cursadas en un cuatrimestre (2026–1)
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
