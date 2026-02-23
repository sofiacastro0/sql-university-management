--VIEW analitico_estudiantes
/*La vista analitico_estudiantes centraliza la información académica de las cursadas, 
integrando datos de estudiantes, materias y profesores, 
facilitando consultas analíticas sin repetir joins complejos.*/
CREATE VIEW analitico_estudiantes AS 
SELECT
estudiante.apellido AS apellido_estudiante,
estudiante.nombre   AS nombre_estudiante,
estudiante.dni,
cursada.anio,
cursada.cuatrimestre,
materia.nombre      AS materia,
profesor.apellido   AS apellido_profesor,
profesor.nombre     AS nombre_profesor,
cursada.nota_final,
cursada.condicion,
cursada.fecha_inscripcion
FROM cursada
JOIN estudiante ON estudiante.legajo = cursada.legajo
JOIN materia    ON materia.codigo_materia = cursada.codigo_materia
JOIN profesor   ON profesor.id_profesor = cursada.id_profesor;

--VIEW de resumen académico
/*“La vista resumen_academico consolida información por estudiante, 
mostrando total de cursadas, materias aprobadas y promedio de notas, 
incluyendo alumnos sin cursadas mediante LEFT JOIN.”*/
CREATE VIEW resumen_academico AS
SELECT
    e.legajo,
    e.apellido,
    e.nombre,
    e.dni,
    COUNT(c.id_cursada) AS total_cursadas,
    SUM(CASE WHEN c.condicion = 'aprobado' THEN 1 ELSE 0 END) AS aprobadas,
    SUM(CASE WHEN c.condicion IN ('inscripto', 'regular') THEN 1 ELSE 0 END) AS en_curso,
    COALESCE(ROUND(AVG(c.nota_final), 2), 0) AS promedio_nota
FROM estudiante e
LEFT JOIN cursada c 
    ON c.legajo = e.legajo
GROUP BY e.legajo, e.apellido, e.nombre, e.dni;