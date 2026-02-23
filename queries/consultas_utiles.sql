-- =====================================================
-- CONSULTAS ÚTILES DEL SISTEMA ACADÉMICO
-- Descripción: consultas operativas frecuentes
-- =====================================================


-- ============================================
-- CONSULTA: listar todas las cursadas
-- Descripción: muestra cursadas con estudiante, materia y profesor
-- ============================================

SELECT 
    c.id_cursada,
    e.legajo,
    e.apellido,
    e.nombre,
    m.nombre AS materia,
    p.apellido AS profesor_apellido,
    p.nombre AS profesor_nombre,
    c.anio,
    c.cuatrimestre,
    c.condicion,
    c.nota_final
FROM cursada c
JOIN estudiante e ON e.legajo = c.legajo
JOIN materia m ON m.codigo_materia = c.codigo_materia
JOIN profesor p ON p.id_profesor = c.id_profesor
ORDER BY c.anio DESC, c.cuatrimestre DESC;

-- ============================================
-- CONSULTA: cursadas por estudiante
-- ============================================

SELECT *
FROM analitico_estudiantes
WHERE legajo = 1;

-- ============================================
-- CONSULTA: listar estudiantes activos
-- ============================================

SELECT *
FROM estudiante
WHERE estado = 'activo'
ORDER BY apellido;

-- ============================================
-- CONSULTA: listar materias
-- ============================================

SELECT *
FROM materia
ORDER BY nombre;

-- ============================================
-- CONSULTA: listar profesores
-- ============================================

SELECT *
FROM profesor
ORDER BY apellido;

-- ============================================
-- CONSULTA: materias obligatorias de un año
-- ============================================
SELECT codigo_materia, nombre, carga_horaria 
FROM materia 
WHERE anio_plan = 2 AND es_obligatoria = 1;

-- ============================================
-- CONSULTA: cursadas con datos completos
-- ============================================
SELECT 
e.apellido,
e.nombre,
m.nombre,
p.apellido,
c.condicion,
c.nota_final
FROM cursada c
JOIN estudiante e ON e.legajo = c.legajo
JOIN materia m ON m.codigo_materia = c.codigo_materia
JOIN profesor p ON p.id_profesor = c.id_profesor
ORDER BY e.apellido;

-- ============================================
-- CONSULTA: estudiantes que cursan una materia sin nota
-- ============================================
SELECT DISTINCT
e.apellido,
e.nombre
FROM estudiante e
JOIN cursada c ON c.legajo = e.legajo
WHERE c.codigo_materia = 11510
AND c.nota_final IS NULL;