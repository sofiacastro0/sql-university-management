CREATE TABLE estudiante (
	legajo INTEGER PRIMARY KEY,
	nombre TEXT NOT NULL,
	apellido TEXT NOT NULL,
	dni TEXT NOT NULL UNIQUE 
        CHECK (dni GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
        AND dni <> '00000000'
        AND trim(dni) = dni),
	email TEXT NOT NULL UNIQUE,
	fecha_nacimiento TEXT,
	fecha_ingreso TEXT NOT NULL DEFAULT (date('now')),
	estado TEXT NOT NULL DEFAULT 'activo' 
        CHECK (estado IN ('activo', 'inactivo'))
);
CREATE TABLE materia (
	codigo_materia INTEGER PRIMARY KEY,
	nombre TEXT NOT NULL,
	carga_horaria INTEGER NOT NULL CHECK(carga_horaria > 0),
	es_obligatoria INTEGER NOT NULL DEFAULT 1 
        CHECK(es_obligatoria IN (0,1)),
	anio_plan INTEGER NOT NULL CHECK (anio_plan BETWEEN 1 AND 5)
);
CREATE TABLE profesor (
	id_profesor INTEGER PRIMARY KEY,
	nombre TEXT NOT NULL,
	apellido TEXT NOT NULL,
	dni TEXT NOT NULL UNIQUE 
        CHECK (dni GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
        AND dni <> '00000000' 
        AND trim(dni) = dni),
	email TEXT NOT NULL UNIQUE,
	fecha_ingreso TEXT NOT NULL DEFAULT (date('now')),
	titulo TEXT,
	estado TEXT NOT NULL DEFAULT 'activo' 
        CHECK (estado IN ('activo', 'licencia', 'retirado'))
);
CREATE TABLE cursada (
	id_cursada INTEGER PRIMARY KEY,
    legajo INTEGER NOT NULL,
	codigo_materia INTEGER NOT NULL,
	id_profesor INTEGER NOT NULL,
	anio INTEGER NOT NULL CHECK(anio >= 1900),
	cuatrimestre INTEGER NOT NULL CHECK(cuatrimestre IN (1,2)),
	nota_final REAL 
        CHECK (nota_final IS NULL OR (nota_final >= 0 AND nota_final <= 10)),
    condicion TEXT NOT NULL DEFAULT 'inscripto' 
        CHECK (condicion IN ('inscripto','regular','aprobado','libre','recursa')),
    fecha_inscripcion TEXT NOT NULL DEFAULT (date('now')),

	FOREIGN KEY (legajo) REFERENCES estudiante(legajo),
	FOREIGN KEY (codigo_materia) REFERENCES materia(codigo_materia),
	FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    
    UNIQUE (legajo, codigo_materia, anio, cuatrimestre)
);

CREATE TABLE cursada_audit (
	id_audit INTEGER PRIMARY KEY,
	id_cursada INTEGER NOT NULL,
	fecha_cambio TEXT NOT NULL DEFAULT (datetime('now')),
	old_condicion TEXT NOT NULL,
	new_condicion TEXT NOT NULL,
	old_nota REAL,
	new_nota REAL,

	FOREIGN KEY (id_cursada) REFERENCES cursada(id_cursada)
);