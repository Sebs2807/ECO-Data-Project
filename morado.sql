---XIndices

DROP INDEX INombre;
DROP INDEX INombre2;
DROP INDEX IServicio;
DROP INDEX ITitulo;
DROP INDEX IPalabraClave;
DROP INDEX IActividad;

---XVistas

DROP VIEW VClimaPredominante;
DROP VIEW VAnimalesAfectados;
DROP VIEW VPubliParquePalabra;
DROP VIEW VServiciosParque;
DROP VIEW VActividadPorParque;
DROP VIEW VAnimalParque;
DROP VIEW VEcosistemaParque;
DROP VIEW VPlantaParque;
DROP VIEW VRechazadasParque;
DROP VIEW VServiciosPopularesParque;
DROP VIEW VParquePorActividad;

-- Indices
-- Indice tipo_de_actividad en actividades permitidas
CREATE INDEX IActividad
ON ACTIVIDADES_PERMITIDAS(tipo_de_actividad);

---Indice tipo de servicio
CREATE INDEX IServicio
ON SERVICIOS (tipo_servicio);

--- indice nombre del pais
CREATE INDEX INombre
ON PAISES (nombre);

--- Indice nombre del departamento
CREATE INDEX INombre2
ON DEPARTAMENTOS (nombre);

--- Indice por el tiulo de las publicaciones
CREATE INDEX ITitulo
ON PUBLICACIONES_CIENTIFICAS (titulo);

--- Indice por la palabra clave de las publicaciones
CREATE INDEX IPalabraClave
ON PUBLICACIONES_CIENTIFICAS (palabra_clave);

--- Vistas

-- Vista ecosistemas en parque 
CREATE OR REPLACE VIEW VEcosistemaParque AS 
SELECT 
  p.codigo AS codigo_parque,
  p.nombre AS nombre_parque,
  e.codigo AS codigo_ecosistema,
  e.nombre_ecosistema AS nombre_ecosistema
FROM PARQUES_NATURALES p JOIN ECOSISTEMAS e ON p.codigo = e.codigo_parque;

--- Vista clima predominante en parque
CREATE OR REPLACE VIEW VClimaPredominante AS
SELECT
  p.codigo AS codigo_parque,
  p.nombre AS nombre_parque,
  ec.nombre_ecosistema AS nombre_ecosistema,
  ec.clima AS clima
FROM
  PARQUES_NATURALES p
JOIN
  ECOSISTEMAS ec ON p.codigo = ec.codigo_parque
ORDER BY clima;

--- Vista animales afectados por amenaza
CREATE OR REPLACE VIEW VAnimalesAfectados AS
SELECT 
    a.codigo AS codigo_amenaza,
    a.tipo AS tipo_amenaza,
    e.nombre_especie
FROM 
    AMENAZAS a
JOIN
    IMPACTOS i ON a.codigo = i.codigo_amenaza
JOIN
    ESPECIES_AFECTADAS e ON e.codigo_amenaza = i.codigo_amenaza;

--- Vista publicaciones por parque filtradas por palabra clave
CREATE OR REPLACE VIEW VPubliParquePalabra AS
SELECT
    p.codigo AS codigo_parque,
    p.nombre AS nombre_parque,
    pu.id AS id_publicacion,
    pu.titulo AS titulo_publicacion,
    pu.palabra_clave AS palabra_clave_publicacion
FROM
    PUBLICACIONES_CIENTIFICAS pu
JOIN
    PARQUES_NATURALES p ON pu.codigo_parque = p.codigo
ORDER BY
palabra_clave_publicacion;

--- Vista servicios por parque
CREATE OR REPLACE VIEW VServiciosParque AS
SELECT
  p.codigo AS codigo_parque,
  p.nombre AS nombre_parque,
  ac.id AS id_actividad,
  ac.tipo_de_actividad,
  s.id AS id_servicio,
  s.tipo_servicio,
  s.precio_dia,
  s.precio_persona,
  CASE WHEN s.mayor_de_edad = 1 THEN 'Si' WHEN s.mayor_de_edad = 0 THEN 'No' END AS necesita_mayor_de_edad
FROM
    SERVICIOS s
JOIN 
    ACTIVIDADES_PERMITIDAS ac ON s.id_actividad = ac.id
JOIN
    ACTIVIDADES_POR_PARQUE acp ON acp.id_actividad = ac.id
JOIN
    PARQUES_NATURALES p ON p.codigo = acp.id_parque;

--- Vista actividad por parque
CREATE OR REPLACE VIEW VActividadPorParque AS
SELECT
  p.codigo AS codigo_parque,
  p.nombre AS nombre_parque,
  ac.id AS id_actividad,
  ac.tipo_de_actividad AS tipo_de_actividad
FROM
    ACTIVIDADES_PERMITIDAS ac
JOIN
    ACTIVIDADES_POR_PARQUE acp ON acp.id_actividad = ac.id
JOIN
    PARQUES_NATURALES p ON p.codigo = acp.id_parque;

--- Vista animales en parque
CREATE OR REPLACE VIEW VAnimalParque AS
SELECT 
    ea.nombre_comun,
    ea.nombre_cientifico,
    p.nombre AS nombre_parque
FROM
    ESPECIES_ANIMALES ea
JOIN
    ECOSISTEMAS e ON ea.codigo_ecosistema = e.codigo
JOIN
    PARQUES_NATURALES p ON p.codigo = e.codigo_parque
ORDER BY
    nombre_parque;

-- Vista plantas por parque
CREATE OR REPLACE VIEW VPlantaParque AS
SELECT 
    ea.nombre_comun,
    ea.nombre_cientifico,
    p.nombre AS nombre_parque
FROM
    ESPECIES_PLANTAS ea
JOIN
    ECOSISTEMAS e ON ea.codigo_ecosistema = e.codigo
JOIN
    PARQUES_NATURALES p ON p.codigo = e.codigo_parque
ORDER BY
    nombre_parque;

--- Vista reservas rechazadas por parque
CREATE OR REPLACE VIEW VRechazadasParque AS
SELECT
  p.nombre AS nombre_parque,
  r.id_adulto AS usuario,
  r.pagado,
  a.tipo_de_actividad AS actividad,
  r.precio_total AS valor,
  r.estado
FROM
  RESERVAS r
JOIN
  SERVICIOS s ON r.id_servicio = s.id
JOIN
  ACTIVIDADES_PERMITIDAS a ON s.id_actividad = a.id
JOIN
  ACTIVIDADES_POR_PARQUE ap ON ap.id_actividad = a.id
JOIN
  PARQUES_NATURALES p ON p.codigo = ap.id_parque
ORDER BY
  nombre_parque;

--- Vista servicios mas populares por parque
CREATE OR REPLACE VIEW VServiciosPopularesParque AS
SELECT
  PN.CODIGO AS CODIGO_PARQUE,
  PN.NOMBRE AS nombre_parque,
  S.ID AS ID_SERVICIO,
  COUNT(R.NUMERO) AS NUMERO_DE_RESERVAS
FROM
  PARQUES_NATURALES PN
  JOIN SERVICIOS S ON PN.CODIGO = S.ID_ACTIVIDAD
  LEFT JOIN RESERVAS R ON S.ID = R.ID_SERVICIO
GROUP BY
  PN.CODIGO, PN.NOMBRE, S.ID, S.DESCRIPCION
ORDER BY
  NUMERO_DE_RESERVAS DESC;

--- Vista parque por actividad
CREATE OR REPLACE VIEW VParquePorActividad AS
SELECT
  p.codigo AS codigo_parque,
  p.nombre AS nombre_parque,
  ac.id AS id_actividad,
  ac.tipo_de_actividad AS tipo_de_actividad,
  s.ID AS id_servicio,
  pa.nombre AS nombre_pais,
  d.nombre AS nombre_departamento
FROM
    ACTIVIDADES_PERMITIDAS ac
JOIN
    ACTIVIDADES_POR_PARQUE acp ON acp.id_actividad = ac.id
JOIN
    PARQUES_NATURALES p ON p.codigo = acp.id_parque
JOIN
    SERVICIOS s ON s.ID_ACTIVIDAD = ac.ID
JOIN
    UBICACIONES_POR_PARQUE up ON up.codigo_parque = p.codigo 
JOIN
    UBICACIONES u ON u.latitud = up.latitud AND u.longitud = up.longitud
JOIN
    PAISES pa ON u.latitud = pa.latitud AND u.longitud = pa.longitud
JOIN
    DEPARTAMENTOS d ON u.latitud = d.latitud AND u.longitud = d.longitud;

--- Indices y vistas Ok
/*
SELECT * FROM VClimaPredominante;
SELECT * FROM VAnimalesAfectados;
SELECT * FROM VPubliParquePalabra;
SELECT * FROM VServiciosParque;
SELECT * FROM VActividadPorParque;
SELECT * FROM VAnimalParque;
SELECT * FROM VEcosistemaParque;
SELECT * FROM VPlantaParque;
SELECT * FROM VRechazadasParque;
SELECT * FROM VServiciosPopularesParque;
SELECT * FROM VParquePorActividad;
*/