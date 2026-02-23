# Roadmap de mejoras para SQL University Management

Este documento propone un plan **accionable** para evolucionar el proyecto en fases, priorizando impacto funcional, calidad de datos y esfuerzo de implementación.

## Resumen por prioridad

| Prioridad | Mejora | Impacto | Esfuerzo |
|---|---|---|---|
| P1 | Correlatividades con validación en inscripción | Alto | Medio |
| P1 | Comisiones + cupos | Alto | Medio |
| P1 | Auditoría de `INSERT/UPDATE/DELETE` en cursada | Alto | Bajo |
| P1 | Suite de pruebas SQL automática | Alto | Bajo |
| P2 | Exámenes finales separados de cursada | Alto | Medio |
| P2 | Alertas de riesgo académico | Medio/Alto | Medio |
| P2 | Índices compuestos orientados a reportes | Medio | Bajo |
| P3 | Migraciones versionadas | Medio | Medio |
| P3 | Bajas lógicas y auditoría de estado | Medio | Bajo |

---

## Fase 1 (MVP+) — 2 a 4 semanas

### 1) Correlatividades
**Objetivo:** impedir inscripciones si no se aprobaron materias previas.

- Nueva tabla sugerida: `materia_correlativa(codigo_materia, codigo_correlativa, tipo)`.
- Trigger en `cursada` para validar que `legajo` tenga la correlativa aprobada.
- Permitir `tipo` (`fuerte`, `de_cursada`) si se quiere extender luego.

### 2) Comisiones y cupos
**Objetivo:** separar la oferta académica de la inscripción del alumno.

- Nueva tabla `comision(id_comision, codigo_materia, id_profesor, anio, cuatrimestre, cupo, aula, horario)`.
- En `cursada`, referenciar `id_comision` (además o en reemplazo de `id_profesor`).
- Trigger para bloquear inscripciones cuando se alcance el cupo.

### 3) Auditoría completa de cursada
**Objetivo:** trazabilidad total del ciclo de vida de la cursada.

- Mantener auditoría de update y agregar triggers para `INSERT` y `DELETE`.
- Añadir columna `operacion` (`I`, `U`, `D`) en `cursada_audit`.
- Guardar timestamp y snapshot de estado para análisis histórico.

### 4) Tests SQL automatizados
**Objetivo:** evitar regresiones en constraints y triggers.

- Carpeta `tests/` con scripts SQL de casos válidos e inválidos.
- Script `run_tests.sh` que ejecute DB temporal y verifique códigos de salida.
- Casos mínimos:
  - nota en `aprobado` obligatoria,
  - nota nula en `regular`,
  - unicidad de cursada,
  - correlativa incumplida.

---

## Fase 2 — 3 a 6 semanas

### 5) Exámenes finales desacoplados
**Objetivo:** modelar intentos de final y resultado final correctamente.

- Tabla `examen_final(id_examen, legajo, codigo_materia, fecha, nota, condicion)`.
- Regla: una cursada puede derivar en múltiples intentos de final.
- Vista para último estado por materia (aprobada/no aprobada).

### 6) Analítica académica avanzada
**Objetivo:** mejorar seguimiento estudiantil y toma de decisiones.

- Vista de avance por plan: `% materias aprobadas` por alumno y por año.
- Ranking de materias con mayor recursado/libre.
- Alerta de riesgo académico (ejemplo: promedio < 4 y >2 recursadas en 12 meses).

### 7) Performance para reportes
**Objetivo:** sostener tiempos de respuesta al crecer volumen de datos.

- Índice recomendado: `cursada(anio, cuatrimestre, condicion)`.
- Índice recomendado: `cursada(legajo, condicion, nota_final)`.
- Revisar planes con `EXPLAIN QUERY PLAN` en consultas de `queries/reportes.sql`.

---

## Fase 3 — hardening y operatividad

### 8) Migraciones versionadas
- Crear carpeta `migrations/` con naming secuencial (`001_...sql`).
- Agregar script de bootstrap para levantar schema + triggers + datos demo.

### 9) Calidad de datos adicional
- Normalización de email: `lower(trim(email))`.
- Validación de fechas no futuras en estudiantes/profesores.
- Bajas lógicas (`estado`) con auditoría específica de cambios.

---

## Backlog técnico sugerido (issues)

1. `feat(schema): crear materia_correlativa y trigger de validación`
2. `feat(schema): incorporar comision y cupo con control de sobreinscripción`
3. `feat(audit): extender cursada_audit a operaciones I/U/D`
4. `test(sql): agregar suite de pruebas de integridad y negocio`
5. `feat(schema): modelar examen_final y vistas de estado académico`
6. `perf(indexes): agregar índices compuestos y validar query plans`
7. `chore(migrations): estructurar migraciones versionadas`

## Criterios de aceptación global

- Todas las reglas críticas tienen cobertura en tests SQL.
- No se rompe compatibilidad de consultas existentes en `queries/`.
- Se documenta cómo recrear la base desde cero en un único flujo reproducible.
