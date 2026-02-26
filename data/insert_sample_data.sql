-- =====================================================
-- SAMPLE DATA
-- CARGA REALISTA (UNLa - Lic. en Sistemas plan 2025)
-- Orden recomendado: borrar datos -> cargar -> cursadas
-- =====================================================


PRAGMA foreign_keys = ON;

BEGIN;

-- 0) VACÍO (por si quedó algo previo)
DELETE FROM cursada;
DELETE FROM estudiante;
DELETE FROM profesor;
DELETE FROM correlatividad;
DELETE FROM materia;

------------------------------------------------------------
-- 1) PROFESORES (10) - DNIs válidos (8 dígitos) y estados ok
------------------------------------------------------------
INSERT INTO profesor (id_profesor, nombre, apellido, dni, email, titulo, estado) VALUES
(1,'Ana','López','23111222','ana.lopez@unla.edu.ar','Ing.','activo'),
(2,'Marcos','Suárez','24999888','marcos.suarez@unla.edu.ar','Lic.','activo'),
(3,'Carla','Ramos','27888777','carla.ramos@unla.edu.ar','Mg.','activo'),
(4,'Diego','Paz','26555444','diego.paz@unla.edu.ar','Ing.','activo'),
(5,'Laura','Méndez','25222111','laura.mendez@unla.edu.ar','Lic.','activo'),
(6,'Pablo','Gutiérrez','24123456','pablo.gutierrez@unla.edu.ar','Ing.','licencia'),
(7,'Florencia','Martínez','29444555','flor.martinez@unla.edu.ar','Mg.','activo'),
(8,'Santiago','Herrera','22333444','santiago.herrera@unla.edu.ar','Lic.','activo'),
(9,'Valeria','Romero','26666777','valeria.romero@unla.edu.ar','Ing.','activo'),
(10,'Nicolás','Silva','25555888','nicolas.silva@unla.edu.ar','Lic.','retirado');

------------------------------------------------------------
-- 2) ESTUDIANTES (20) - DNIs válidos y legajos distintos
------------------------------------------------------------
INSERT INTO estudiante (legajo, nombre, apellido, dni, email, fecha_nacimiento, estado) VALUES
(82250,'Carla','Casal','41234567','carla.casal@mail.com','2005-03-10','activo'),
(82251,'Natalia','Gómez','40111222','natalia.gomez@mail.com','2004-07-22','activo'),
(82252,'Sara','Díaz','42333444','sara.diaz@mail.com','2005-11-01','activo'),
(82253,'Lucía','Pérez','38999000','lucia.perez@mail.com','2003-01-15','activo'),
(82254,'Micaela','Fernández','40666123','mica.fernandez@mail.com','2005-05-19','activo'),
(82255,'Tomás','Álvarez','39555111','tomas.alvarez@mail.com','2004-09-30','activo'),
(82256,'Bruno','Silva','42111000','bruno.silva@mail.com','2006-02-14','activo'),
(82257,'Valentina','Romero','40999888','valentina.romero@mail.com','2005-08-03','activo'),
(82258,'Julieta','Sosa','43333222','julieta.sosa@mail.com','2006-12-20','activo'),
(82259,'Camila','Torres','41888777','camila.torres@mail.com','2005-06-11','activo'),
(82260,'Franco','Benítez','39222111','franco.benitez@mail.com','2004-04-08','activo'),
(82261,'Agustina','Rojas','41444111','agustina.rojas@mail.com','2005-09-27','activo'),
(82262,'Joaquín','Paredes','40333999','joaquin.paredes@mail.com','2004-02-02','activo'),
(82263,'Martina','Navarro','40777123','martina.navarro@mail.com','2005-01-06','activo'),
(82264,'Facundo','Vega','39666111','facundo.vega@mail.com','2004-10-12','activo'),
(82265,'Milagros','Acosta','42000111','milagros.acosta@mail.com','2006-03-05','activo'),
(82266,'Thiago','Ruiz','41000999','thiago.ruiz@mail.com','2005-07-01','activo'),
(82267,'Candela','Molina','42555111','candela.molina@mail.com','2006-05-18','activo'),
(82268,'Iván','Flores','39777000','ivan.flores@mail.com','2004-12-09','activo'),
(82269,'Abril','Suárez','41999111','abril.suarez@mail.com','2005-10-25','inactivo');

------------------------------------------------------------
-- 3) MATERIAS (40) - reales del plan que pasaste
--    (codigo_materia INTEGER, anio_plan 1..5)
------------------------------------------------------------
INSERT INTO materia (codigo_materia, nombre, carga_horaria, es_obligatoria, anio_plan) VALUES
(11500,'Expresión de Problemas y Algoritmos',6,1,1),
(11501,'Organización de Computadoras',6,1,1),
(11502,'Elementos de Matemática',6,1,1),
(11503,'Programación',8,1,1),
(11504,'Arquitectura de Computadoras',6,1,1),
(11505,'Taller de Inglés I',4,1,1),

(11506,'Ingeniería de Software I',6,1,2),
(11507,'Introducción a las Bases de Datos',6,1,2),
(11508,'Algoritmos y Estructuras de Datos',8,1,2),
(11509,'Taller de Inglés II',4,1,2),
(11510,'Seminario de Lenguajes',4,1,2),
(11511,'Introducción a los Sistemas Operativos',6,1,2),
(11512,'Matemática Discreta',6,1,2),

(11513,'Orientación a Objetos I',8,1,3),
(11514,'Taller de Inglés III',4,1,3),
(11515,'Programación Concurrente',6,1,3),
(11516,'Ingeniería de Software II',6,1,3),
(11517,'Análisis Matemático I',6,1,3),
(11518,'Bases de Datos I',6,1,3),
(11519,'Redes y Comunicaciones',6,1,3),
(11520,'Prácticas Preprofesionales I',4,1,3),

(11521,'Conceptos y Paradigmas de Lenguajes de Programación',6,1,4),
(11522,'Orientación a Objetos II',8,1,4),
(11523,'Ingeniería de Software III',6,1,4),
(11524,'Bases de Datos II',6,1,4),
(11525,'Sistemas Operativos',8,1,4),
(11526,'Análisis Matemático II',6,1,4),
(11527,'Desarrollo de Software en Sistemas Distribuidos',6,1,4),
(11528,'Fundamentos de Teoría de la Computación',6,1,4),
(11529,'Sistemas y Organizaciones',6,1,4),

(11530,'Proyecto de Software',8,1,5),
(11531,'Taller de Metodología de la Investigación',4,1,5),
(11532,'Probabilidad y Estadística',6,1,5),
(11533,'Seminario Optativo',4,0,5),
(11534,'Escenarios Tecnológicos',4,1,5),
(11535,'Aspectos Sociales y Profesionales de la Informática',4,1,5),
(11536,'Prácticas Preprofesionales II',4,1,5),
(11537,'Taller de Proyectos I+D+I',4,1,5),

-- Optativas/Módulo O que aparecen en tu extracto (para llegar a 40)
(671,'Módulo O: Elementos de Matemática (TI671)',4,0,1),
(672,'Módulo O: Organización de Computadoras (TI672)',4,0,1),
(673,'Módulo O: Expresión de Problemas y Algoritmos (TI673)',4,0,1);

------------------------------------------------------------
-- 3.b) CORRELATIVIDADES
--    Se cargan correlativas para materias de 3ro a 5to año
------------------------------------------------------------
INSERT INTO correlatividad (codigo_materia, codigo_materia_correlativa, tipo) VALUES
(11513,11503,'fuerte'),
(11515,11508,'de_cursada'),
(11516,11506,'de_cursada'),
(11518,11507,'de_cursada'),
(11519,11511,'fuerte'),
(11522,11513,'fuerte'),
(11523,11516,'fuerte'),
(11524,11518,'fuerte'),
(11525,11511,'fuerte'),
(11527,11519,'de_cursada'),
(11530,11523,'fuerte'),
(11530,11527,'de_cursada');

------------------------------------------------------------
-- 4) CURSADAS COHERENTES
--    Reglas:
--    - 2025: alumnos cursan 1er año (11500..11505)
--    - 2026: algunos pasan a 2do (11506..11512)
--    - condiciones/notas coherentes: aprobado => nota >=4; regular => nota NULL o >=4; inscripto => nota NULL
--    - respeta UNIQUE(legajo, codigo_materia, anio, cuatrimestre)
------------------------------------------------------------

-- 2025 - 1er cuatri: 11500,11501,11502
INSERT INTO cursada (legajo, codigo_materia, id_profesor, anio, cuatrimestre, nota_final, condicion) VALUES
(82250,11500,4,2025,1,10,'aprobado'),
(82250,11501,2,2025,1,10,'aprobado'),
(82250,11502,5,2025,1,7,'aprobado'),

(82251,11500,4,2025,1,9,'aprobado'),
(82251,11501,2,2025,1,10,'aprobado'),
(82251,11502,5,2025,1,6,'aprobado'),

(82252,11500,4,2025,1,8,'aprobado'),
(82252,11501,2,2025,1,7,'aprobado'),
(82252,11502,5,2025,1,NULL,'regular'),

(82253,11500,4,2025,1,6,'aprobado'),
(82253,11501,2,2025,1,NULL,'regular'),
(82253,11502,5,2025,1,5,'aprobado'),

(82254,11500,4,2025,1,7,'aprobado'),
(82254,11501,2,2025,1,6,'aprobado'),
(82254,11502,5,2025,1,4,'aprobado'),

(82255,11500,4,2025,1,NULL,'regular'),
(82255,11501,2,2025,1,5,'aprobado'),
(82255,11502,5,2025,1,NULL,'regular'),

(82256,11500,4,2025,1,4,'aprobado'),
(82256,11501,2,2025,1,6,'aprobado'),
(82256,11502,5,2025,1,4,'aprobado'),

(82257,11500,4,2025,1,10,'aprobado'),
(82257,11501,2,2025,1,9,'aprobado'),
(82257,11502,5,2025,1,8,'aprobado');

-- 2025 - 2do cuatri: 11503,11504,11505
INSERT INTO cursada (legajo, codigo_materia, id_profesor, anio, cuatrimestre, nota_final, condicion) VALUES
(82250,11503,7,2025,2,10,'aprobado'),
(82250,11504,8,2025,2,9,'aprobado'),
(82250,11505,1,2025,2,9,'aprobado'),

(82251,11503,7,2025,2,8,'aprobado'),
(82251,11504,8,2025,2,7,'aprobado'),
(82251,11505,1,2025,2,8,'aprobado'),

(82252,11503,7,2025,2,6,'aprobado'),
(82252,11504,8,2025,2,NULL,'regular'),
(82252,11505,1,2025,2,7,'aprobado'),

(82253,11503,7,2025,2,NULL,'regular'),
(82253,11504,8,2025,2,6,'aprobado'),
(82253,11505,1,2025,2,7,'aprobado'),

(82254,11503,7,2025,2,7,'aprobado'),
(82254,11504,8,2025,2,6,'aprobado'),
(82254,11505,1,2025,2,9,'aprobado'),

(82255,11503,7,2025,2,5,'aprobado'),
(82255,11504,8,2025,2,NULL,'regular'),
(82255,11505,1,2025,2,NULL,'regular'),

(82256,11503,7,2025,2,4,'aprobado'),
(82256,11504,8,2025,2,5,'aprobado'),
(82256,11505,1,2025,2,6,'aprobado'),

(82257,11503,7,2025,2,9,'aprobado'),
(82257,11504,8,2025,2,8,'aprobado'),
(82257,11505,1,2025,2,9,'aprobado');

-- 2026 - 1er cuatri (2do año): 11506,11507,11508
-- Algunos inscriptos/regular sin nota aún
INSERT INTO cursada (legajo, codigo_materia, id_profesor, anio, cuatrimestre, nota_final, condicion) VALUES
(82250,11506,2,2026,1,NULL,'inscripto'),
(82250,11507,3,2026,1,NULL,'inscripto'),
(82250,11508,4,2026,1,NULL,'inscripto'),

(82251,11506,2,2026,1,8,'aprobado'),
(82251,11507,3,2026,1,9,'aprobado'),
(82251,11508,4,2026,1,NULL,'regular'),

(82252,11506,2,2026,1,NULL,'regular'),
(82252,11507,3,2026,1,6,'aprobado'),
(82252,11508,4,2026,1,NULL,'inscripto'),

(82253,11506,2,2026,1,7,'aprobado'),
(82253,11507,3,2026,1,NULL,'regular'),
(82253,11508,4,2026,1,5,'aprobado'),

(82254,11506,2,2026,1,NULL,'inscripto'),
(82254,11507,3,2026,1,NULL,'inscripto'),
(82254,11508,4,2026,1,NULL,'inscripto'),

(82255,11506,2,2026,1,4,'aprobado'),
(82255,11507,3,2026,1,NULL,'regular'),
(82255,11508,4,2026,1,NULL,'regular'),

(82256,11506,2,2026,1,6,'aprobado'),
(82256,11507,3,2026,1,NULL,'inscripto'),
(82256,11508,4,2026,1,7,'aprobado'),

(82257,11506,2,2026,1,9,'aprobado'),
(82257,11507,3,2026,1,8,'aprobado'),
(82257,11508,4,2026,1,9,'aprobado'),

(82258,11506,2,2026,1,NULL,'inscripto'),
(82258,11507,3,2026,1,NULL,'inscripto'),
(82258,11508,4,2026,1,NULL,'inscripto');

-- 2026 - 2do cuatri (2do año): 11509,11510,11511,11512
INSERT INTO cursada (legajo, codigo_materia, id_profesor, anio, cuatrimestre, nota_final, condicion) VALUES
(82250,11509,1,2026,2,NULL,'inscripto'),
(82250,11510,9,2026,2,NULL,'inscripto'),
(82250,11511,8,2026,2,NULL,'inscripto'),
(82250,11512,5,2026,2,NULL,'inscripto'),

(82251,11509,1,2026,2,8,'aprobado'),
(82251,11510,9,2026,2,7,'aprobado'),
(82251,11511,8,2026,2,6,'aprobado'),
(82251,11512,5,2026,2,6,'aprobado'),

(82252,11509,1,2026,2,NULL,'regular'),
(82252,11510,9,2026,2,6,'aprobado'),
(82252,11511,8,2026,2,NULL,'inscripto'),
(82252,11512,5,2026,2,5,'aprobado'),

(82253,11509,1,2026,2,7,'aprobado'),
(82253,11510,9,2026,2,NULL,'regular'),
(82253,11511,8,2026,2,4,'aprobado'),
(82253,11512,5,2026,2,NULL,'regular'),

(82254,11509,1,2026,2,NULL,'inscripto'),
(82254,11510,9,2026,2,NULL,'inscripto'),
(82254,11511,8,2026,2,NULL,'inscripto'),
(82254,11512,5,2026,2,NULL,'inscripto');

COMMIT;

-- Verificación rápida
SELECT 'estudiantes' AS tabla, COUNT(*) AS cantidad FROM estudiante
UNION ALL SELECT 'profesores', COUNT(*) FROM profesor
UNION ALL SELECT 'materias', COUNT(*) FROM materia
UNION ALL SELECT 'cursadas', COUNT(*) FROM cursada;
