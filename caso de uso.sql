INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Parque Nacional Natural Amacayacu', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 150, 300, 500, 'ABIERTO');

INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Parque Nacional Natural los Churumbelos', TO_TIMESTAMP('09:30:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), 120, 250, 400, 'ABIERTO');

INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Parque Nacional Natural Rio Pure', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 100, 280, 450, 'ABIERTO');

INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Reserva Nacional Natural Puinawai', TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('15:30:00', 'HH24:MI:SS'), 80, 200, 350, 'ABIERTO');

INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Reserva Nacional Natural Nukak', TO_TIMESTAMP('09:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 110, 270, 400, 'ABIERTO');

INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Parque Nacional Natural La Paya', TO_TIMESTAMP('08:30:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:30:00', 'HH24:MI:SS'), 130, 320, 500, 'ABIERTO');

INSERT INTO parques_naturales(nombre, hora_apertura, hora_cierre, CANT_TRABAJADORES, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, ESTADO) VALUES
('Parque Nacional Natural Cahuinarí', TO_TIMESTAMP('09:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('17:30:00', 'HH24:MI:SS'), 90, 260, 420, 'ABIERTO');

SELECT * FROM PARQUES_NATURALES
WHERE CODIGO > 1000;

INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.5, 0.0, 89);
INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.5, 0.5, 54);
INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.0, 1.0, 39);
INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.0, 1.5, 41);
INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.5, 2.0, 90);
INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.0, 2.5, 58);
INSERT INTO ubicaciones(latitud,longitud,tamano) VALUES
(1.5, 3.0, 74);


INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1001, 1.5, 0.0);
INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1002, 1.5, 0.5);
INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1003, 1.0, 1.0);
INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1004, 1.0, 1.5);
INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1005, 1.5, 2.0);
INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1006,1.0, 2.5);
INSERT INTO ubicaciones_por_parque(codigo_parque,latitud,longitud) VALUES
(1007, 1.5, 3.0);


INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.5, 0.0);
INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.5, 0.5);
INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.0, 1.0);
INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.0, 1.5);
INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.5, 2.0);
INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.0, 2.5);
INSERT INTO paises(nombre,latitud,longitud) VALUES
('Colombia', 1.5, 3.0);


INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Cundinamarca', 1.5, 0.0);
INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Antioquia', 1.5, 0.5);
INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Arauca', 1.0, 1.0);
INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Cundinamarca', 1.0, 1.5);
INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Cundinamarca', 1.5, 2.0);
INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Cundinamarca', 1.0, 2.5);
INSERT INTO departamentos(nombre,latitud,longitud) VALUES
('Antioquia', 1.5, 3.0);


--senderismo y observación de aves

INSERT INTO ACTIVIDADES_PERMITIDAS(DESCRIPCION_ACTIVIDAD,TIPO_DE_ACTIVIDAD) VALUES
('Actividad recreativa y deportiva que implica caminar', 'SENDERISMO TERRESTRE'); -- 1001
INSERT INTO ACTIVIDADES_PERMITIDAS(DESCRIPCION_ACTIVIDAD,TIPO_DE_ACTIVIDAD) VALUES
('Actividad fascinante que implica la identificación y observación de aves', 'OBSERVACION AVES'); -- 1002


SELECT * FROM ACTIVIDADES_PERMITIDAS WHERE DESCRIPCION_ACTIVIDAD = 'Actividad fascinante que implica la identificación y observación de aves';

INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1001, '1001');
INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1002, '1001');
INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1003, '1001');
INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1004, '1001');


INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1001, '1002');
INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1002, '1002');
INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1003, '1002');
INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE,ID_ACTIVIDAD) VALUES
(1004, '1002');






INSERT INTO amenazas(estado,gravedad,tipo,fecha_mitigacion) VALUES
('ACTIVA', 'MUY SIGNIFICATIVA', 'ACTIVIDAD RECREATIVA', TO_DATE('15-12-2025', 'DD-MM-YYYY'));
INSERT INTO amenazas(estado,gravedad,tipo,fecha_mitigacion) VALUES
('RESUELTA', 'POCO SIGNIFICATIVA', 'CAMBIO CLIMATICO', TO_DATE('15-12-2033', 'DD-MM-YYYY'));
INSERT INTO amenazas(estado,gravedad,tipo,fecha_mitigacion) VALUES
('EN EVALUCACION', 'MUY SIGNIFICATIVA', 'MINERIA', TO_DATE('15-12-2025', 'DD-MM-YYYY'));
INSERT INTO amenazas(estado,gravedad,tipo,fecha_mitigacion) VALUES
('EN MONITORIZACION', 'MUY SIGNIFICATIVA', 'CONFLICTO HUMANO', TO_DATE('15-12-2029', 'DD-MM-YYYY'));
INSERT INTO amenazas(estado,gravedad,tipo,fecha_mitigacion) VALUES
('ACTIVA', 'POCO SIGNIFICATIVA', 'CONFLICTO HUMANO', TO_DATE('15-12-2025', 'DD-MM-YYYY'));
INSERT INTO amenazas(estado,gravedad,tipo,fecha_mitigacion) VALUES
('RESUELTA', 'MUY SIGNIFICATIVA', 'INCENDIO FORESTAL', TO_DATE('15-12-2029', 'DD-MM-YYYY'));


INSERT INTO AMENAZAS_POR_PARQUE(CODIGO_PARQUE,CODIGO_AMENAZA) VALUES
(1003, 1001);
INSERT INTO AMENAZAS_POR_PARQUE(CODIGO_PARQUE,CODIGO_AMENAZA) VALUES
(1002, 1002);
INSERT INTO AMENAZAS_POR_PARQUE(CODIGO_PARQUE,CODIGO_AMENAZA) VALUES
(1002, 1003);
INSERT INTO AMENAZAS_POR_PARQUE(CODIGO_PARQUE,CODIGO_AMENAZA) VALUES
(1004, 1004);



INSERT INTO  SERVICIOS(ID_ACTIVIDAD,DESCRIPCION,TIPO_SERVICIO,RESPONSABLE,MAYOR_DE_EDAD,PRECIO_DIA,PRECIO_PERSONA) VALUES
(1001, 'Actividad recreativa', 'ACOMPANIAMENTO', 'Marta Fernandez', 1, 26, 38);

INSERT INTO  SERVICIOS(ID_ACTIVIDAD,DESCRIPCION,TIPO_SERVICIO,RESPONSABLE,MAYOR_DE_EDAD,PRECIO_DIA,PRECIO_PERSONA) VALUES
(1002, 'Identificación y observación de aves', 'ACOMPANIAMENTO', 'Dilan Cruz', 1, 24, 10);


begin
    PK_PERSONA.adultoRegister('Colombia', '3123589553', 'correo@mail.com', 'Camilo Quintero', TO_DATE('15-11-2000', 'DD-MM-YYYY'), 'HOMBRE', '1031801790', 'CC');
end;
/

--------------------------------------------- OBSERVACION AVES -------------------------------------------------------------
--- Consultar todos los parques que tienen esa actividad
VAR printeo REFCURSOR;
BEGIN 
  :printeo := bd1000096696.PK_USUARIO.consultarParqueActividadPais('OBSERVACION AVES', 'Colombia');
END;
/
PRINT printeo;

--- Consultar si el parque es seguro para asistir (no tiene amenazas)
VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_USUARIO.consultarAmenazasParque('Parque Nacional Natural Rio Pure');   --- SI TIENE AMENAZAS
END;
/
PRINT printeo;

--- Consultar si el parque es seguro para asistir (no tiene amenazas)
VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_USUARIO.consultarAmenazasParque('Parque Nacional Natural Amacayacu'); --- NO TIENE AMENAZAS
END;
/
PRINT printeo;

--- Consultar el id del servicio para crear la reserva
VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_USUARIO.consultarServicioIdParque('1002','1001');
END;
/
PRINT printeo;

--- Crear la reserva para la actividad de observacion de aves
BEGIN
    pk_reserva.reservaInsertar(1002,'1031801790', 3, TO_DATE('20-12-2023', 'DD-MM-YYYY'), TO_DATE('24-12-2023', 'DD-MM-YYYY'));
END;
/

----------------------------------------------- SENDERISMO ------------------------------------------
--- Consultas los parques que tienen la actividad de senderismo
VAR printeo REFCURSOR;
BEGIN 
  :printeo := bd1000096696.PK_USUARIO.consultarParqueActividadPais('SENDERISMO TERRESTRE', 'Colombia');
END;
/
PRINT printeo;

--- Consultar si el parque es seguro para asistir (no tiene amenazas)
VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_USUARIO.consultarAmenazasParque('Reserva Nacional Natural Puinawai'); --- SI TIENE AMENAZAS
END;
/
PRINT printeo;


--- Consultar si el parque es seguro para asistir (no tiene amenazas)
VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_USUARIO.consultarAmenazasParque('Parque Nacional Natural Amacayacu'); --- NO TIENE AMENAZAS
END;
/
PRINT printeo;

--- Consultar el id del servicio para crear la reserva
VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_USUARIO.consultarServicioIdParque('1001','1001');
END;
/
PRINT printeo;

--- Crear reserva con actividad de senderismo
BEGIN
    pk_reserva.reservaInsertar(1001,'1031801790', 3, TO_DATE('20-12-2023', 'DD-MM-YYYY'), TO_DATE('24-12-2023', 'DD-MM-YYYY'));
END;
/

--- Consultar todas las reservas por usuario
VAR printeo REFCURSOR;
BEGIN
    :printeo := PK_USUARIO.consultarReservasporUsuario('1031801790');
END;
/
PRINT printeo;
