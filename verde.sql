--XDisparadores
DROP TRIGGER autogenerarParqueNatural;
DROP TRIGGER autoPais;
DROP TRIGGER generar_id_departamento;
DROP TRIGGER generar_codigo_ecosistema;
DROP TRIGGER generar_codigo_especie_planta;
DROP TRIGGER generar_codigo_especie_animal;
DROP TRIGGER generar_id_actividad;
DROP TRIGGER generar_id_requisito;
DROP TRIGGER modificar_parque_natural;
DROP TRIGGER actividadUpdate;
DROP TRIGGER trg_eliminar_parque;
DROP TRIGGER trg_eliminar_ecosistema;
DROP TRIGGER trg_eliminar_ubicacion;
DROP TRIGGER deleteActividad;
DROP TRIGGER autogenerar_amenaza;
DROP TRIGGER accion_mitigacion_impacto;
DROP TRIGGER generar_codigo_especieA;
DROP TRIGGER fecha_mitigacion_estado;
DROP TRIGGER autogenerarPublicacion;
DROP TRIGGER generarReserva;
DROP TRIGGER actualizar_amenaza;
DROP TRIGGER actualizar_imapcto;
DROP TRIGGER publicacionUpdate;
DROP TRIGGER eliminar_amenaza;
DROP TRIGGER generar_id_servicio;
DROP TRIGGER adultoReserva;
DROP TRIGGER reservaUpdate;
DROP TRIGGER servicioUpdate;
DROP TRIGGER reservaDelete;
DROP TRIGGER deleteServicio;
DROP TRIGGER eliminar_impacto;
DROP TRIGGER NINIO_DIFERENTE_ADULTO;
DROP TRIGGER ADULTO_DIFERENTE_NINIOS;
DROP TRIGGER personaGenerar;
DROP TRIGGER adultoUpdate;
DROP TRIGGER personaUpdate;
DROP TRIGGER adultoDelete;
DROP TRIGGER personaDelete;
DROP TRIGGER UpdateEcosistema;
DROP TRIGGER UpdateEspeciePlanta;
DROP TRIGGER UpdateEspecieAnimal;
DROP TRIGGER UpdateUbicacion;
DROP TRIGGER UpdatePais;
DROP TRIGGER PAISDELETE;
DROP TRIGGER departamentoDelete;
DROP TRIGGER departamentoUpdate;

-- Tuplas
-- La fecha de apertura debe ser menor a la fecha de cierre
ALTER TABLE PARQUES_NATURALES ADD CONSTRAINT ck_parque_natural
    CHECK (hora_apertura < hora_cierre);

ALTER TABLE RESERVAS ADD CONSTRAINT fecha_reserv_asistencia
  CHECK (fecha_reservacion < fecha_asistencia);

ALTER TABLE RESERVAS ADD CONSTRAINT fecha_asistenca_fin
  CHECK(fecha_asistencia < fecha_fin);

-- Acciones
ALTER TABLE RESERVAS DROP CONSTRAINT FK_RESERVAS_ADULTOS;
ALTER TABLE RESERVAS ADD CONSTRAINT FK_RESERVAS_CLIENTES
  FOREIGN KEY (id_adulto) REFERENCES ADULTOS(ID_USUARIO)
  ON DELETE SET NULL;

-- Disparadores
--- Calcular precio reserva
CREATE OR REPLACE TRIGGER calcular_precio_reserva
BEFORE INSERT ON RESERVAS
FOR EACH ROW
DECLARE
    resultado NUMBER;
    precioD NUMBER;
    precioP NUMBER;
BEGIN
    SELECT precio_dia, precio_persona
    INTO precioD, precioP
    FROM SERVICIOS s
    WHERE :NEW.ID_SERVICIO = s.ID;

    resultado := (:NEW.FECHA_FIN - :NEW.FECHA_ASISTENCIA) * precioD
                + (:NEW.CANTIDAD_PERSONAS * precioP);

    -- Asignar el resultado al campo correspondiente en la tabla RESERVAS
    :NEW.PRECIO_TOTAL := resultado;
END;
/

--- Mantener parque

-- Adicionar
--El codigo es autogenerado. 
--La fecha de registro es autogenerada
CREATE OR REPLACE TRIGGER autogenerarParqueNatural
BEFORE INSERT ON PARQUES_NATURALES
FOR EACH ROW
DECLARE
  v_fecha_actual DATE := SYSDATE;
BEGIN
  :NEW.codigo := TO_CHAR(SEQ_MI_VALOR_UNICO.NEXTVAL);
  :NEW.FECHA_REGISTRO := SYSDATE;
END;
/
--El codigo del pais es autogenerado
CREATE OR REPLACE TRIGGER autoPais
BEFORE INSERT ON PAISES
FOR EACH ROW
  BEGIN    
    :NEW.id_pais := TO_CHAR(SEQ_MI_VALOR_UNICO2.NEXTVAL);
END;
/

CREATE OR REPLACE TRIGGER generar_id_departamento
BEFORE INSERT ON DEPARTAMENTOS
FOR EACH ROW
  BEGIN 
    :NEW.id_departamento :=  TO_CHAR(SEQ_MI_VALOR_UNICO3.NEXTVAL);     
END;
/



CREATE OR REPLACE TRIGGER generar_codigo_ecosistema
BEFORE INSERT ON ECOSISTEMAS
FOR EACH ROW 
  BEGIN
    :NEW.codigo := TO_CHAR(SEQ_MI_VALOR_UNICO4.NEXTVAL);
END;
/


CREATE OR REPLACE TRIGGER generar_codigo_especie_planta
BEFORE INSERT ON ESPECIES_PLANTAS
FOR EACH ROW
  BEGIN
    :NEW.ID := TO_CHAR(SEQ_MI_VALOR_UNICO5.NEXTVAL);
END;
/



CREATE OR REPLACE TRIGGER generar_codigo_especie_animal
BEFORE INSERT ON ESPECIES_ANIMALES
FOR EACH ROW
  BEGIN
    :NEW.ID := TO_CHAR(SEQ_MI_VALOR_UNICO6.NEXTVAL);
END;
/



CREATE OR REPLACE TRIGGER generar_id_actividad
BEFORE INSERT ON ACTIVIDADES_PERMITIDAS
FOR EACH ROW 
  BEGIN
   :NEW.ID :=  TO_CHAR(SEQ_MI_VALOR_UNICO7.NEXTVAL); 
END;
/


CREATE OR REPLACE TRIGGER generar_id_requisito
BEFORE INSERT ON EQUIPOS_BASICOS
FOR EACH ROW
  BEGIN  
    :NEW.ID:= TO_CHAR(SEQ_MI_VALOR_UNICO8.NEXTVAL);
END;
/

-- ACTUALIZAR

--Se puede actualizar todo excepto codigo, nombre y fecha de registro.

CREATE OR REPLACE TRIGGER modificar_parque_natural
BEFORE UPDATE ON PARQUES_NATURALES
FOR EACH ROW
BEGIN
  IF :NEW.codigo <> :OLD.codigo OR
  :NEW.nombre <> :OLD.nombre OR
  :NEW.fecha_registro <> :OLD.fecha_registro THEN
  RAISE_APPLICATION_ERROR(-200001,'No se permite actualizar codigo, nombre o fecha de registro.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER actividadUpdate
BEFORE UPDATE ON ACTIVIDADES_PERMITIDAS
FOR EACH ROW
  BEGIN
    IF :NEW.id <> :OLD.id OR
        :NEW.tipo_de_actividad <> :OLD.tipo_de_actividad THEN 
        RAISE_APPLICATION_ERROR(-200004, 'No se permiten actualizar estos datos de la actividad.');
    END IF;
END;
/

-- ELIMINAR

-- Los parques no se pueden eliminar.
CREATE OR REPLACE TRIGGER trg_eliminar_parque
BEFORE DELETE ON PARQUES_NATURALES
  BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'No se permite eliminar ningun parque natural.');
END;
/
-- Los ecosistemas no se pueden eliminar.
CREATE OR REPLACE TRIGGER trg_eliminar_ecosistema
BEFORE DELETE ON ECOSISTEMAS
  BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'No se permite eliminar ningun ecosistema.');
END;  
/

-- La ubicacion no se puede eliminar.
CREATE OR REPLACE TRIGGER trg_eliminar_ubicacion
BEFORE DELETE ON UBICACIONES
  BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'No se permite eliminar ninguna ubicacion.');
END;  
/
-- La actividad no se puede eliminar si tiene servicios asociados. 

CREATE OR REPLACE TRIGGER deleteActividad
BEFORE DELETE ON ACTIVIDADES_PERMITIDAS
FOR EACH ROW
DECLARE 
  reserva NUMBER;
BEGIN
  SELECT COUNT(*) INTO reserva FROM RESERVAS
  JOIN SERVICIOS ON RESERVAS.id_servicio = SERVICIOS.id
  WHERE id_actividad = :OLD.id;
  IF reserva > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar una actividad ya que tiene reservas asociadas');
  END IF;
END;
/


-- MANENER AMENAZA

--ADICIONAR

-- El codigo es autogenerado 

CREATE OR REPLACE TRIGGER autogenerar_amenaza
BEFORE INSERT ON AMENAZAS
FOR EACH ROW
  BEGIN 
-- El estado inicial de la amenaza es 'activa'
    :NEW.estado := 'ACTIVA';

-- La fecha de deteccion es autogenerada
    :NEW.fecha_deteccion := SYSDATE;


    :NEW.codigo:= TO_CHAR(SEQ_MI_VALOR_UNICO9.NEXTVAL);

-- La fecha de mitigacion debe ser mayor o igual a la fecha de deteccion
   IF :NEW.FECHA_MITIGACION < SYSDATE THEN
     RAISE_APPLICATION_ERROR(-20001, 'La fecha de mitigacion debe ser mayor o igual a la fecha de deteccion');
  END IF;
--	SI tiene fecha de mitigacion, el estado es en proceso de mitigacion
  IF :NEW.FECHA_MITIGACION IS NOT NULL THEN
    :NEW.estado := 'EN PROCESO DE MITIGACION';
  END IF;

END;
/


CREATE OR REPLACE TRIGGER accion_mitigacion_impacto
BEFORE INSERT ON IMPACTOS
FOR EACH ROW
  BEGIN   
  :NEW.accion_mitigacion := 'NINGUNA';
END;
/


CREATE OR REPLACE TRIGGER generar_codigo_especieA
BEFORE INSERT ON ESPECIES_AFECTADAS
FOR EACH ROW
  BEGIN  
    :NEW.codigo_especie:=TO_CHAR(SEQ_MI_VALOR_UNICO10.NEXTVAL);
END;
/


-- MODIFICAR
CREATE OR REPLACE TRIGGER  actualizar_amenaza
BEFORE UPDATE ON AMENAZAS
FOR EACH ROW  
  BEGIN
  -- Solo puede modificar datos especificos
    IF :NEW.codigo <> :OLD.codigo OR  
    :NEW.gravedad <> :OLD.gravedad OR
    :NEW.tipo> :OLD.tipo OR
    :NEW.fecha_deteccion <> :OLD.fecha_deteccion THEN 
      RAISE_APPLICATION_ERROR(-200009,'No se pueden modificar esos datos en la tabla');
    END IF;
  -- Error de fecha menor
    IF :NEW.fecha_mitigacion < :OLD.fecha_deteccion THEN
      RAISE_APPLICATION_ERROR(-200009,'La fecha de deteccion debe ser menor a la fecha de mitigacion');
    END IF;
  -- Si la fecha de mitigacion es nula y el estado 
    IF :NEW.fecha_mitigacion IS NULL AND :NEW.estado <> 'ACTIVA' THEN
      RAISE_APPLICATION_ERROR(-200001,'La fecha demitigacion es null, el estado no puede ser actualizado');
    END IF;    
END;
/


CREATE OR REPLACE TRIGGER actualizar_imapcto
BEFORE UPDATE ON IMPACTOS
FOR EACH ROW
  BEGIN 
    IF :NEW.CODIGO_AMENAZA <> :OLD.CODIGO_AMENAZA OR 
    :NEW.descripcion <> :OLD.descripcion OR  
    :NEW.severidad <> :OLD.severidad THEN
    RAISE_APPLICATION_ERROR(-20001, 'No se pueden modificar esos datos en la tabla IMPACTO');
    END IF;
END;
/

-- ELIMINAR
--	No se puede eliminar amenaza 
CREATE OR REPLACE TRIGGER eliminar_amenaza
BEFORE DELETE ON AMENAZAS
FOR EACH ROW
  BEGIN
      RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar la amenaza');
END;
/




-- PUBLICACION 
--ADICIONAR


CREATE OR REPLACE TRIGGER  autogenerarPublicacion
BEFORE INSERT ON PUBLICACIONES_CIENTIFICAS
FOR EACH ROW
  BEGIN
    :NEW.id:= TO_CHAR(SEQ_MI_VALOR_UNICO11.NEXTVAL);
    IF :NEW.fecha_publicacion > SYSDATE THEN 
        RAISE_APPLICATION_ERROR(-20001, 'La fecha de publicacion debe ser menor o igual a la fecha actual.');
    END IF;
    :NEW.fecha_registro := SYSDATE;
END;
/


-- MODIFICAR


CREATE OR REPLACE TRIGGER publicacionUpdate
BEFORE UPDATE ON PUBLICACIONES_CIENTIFICAS
FOR EACH ROW
  BEGIN
    IF :NEW.CODIGO_PARQUE <> :OLD.CODIGO_PARQUE OR
    :NEW.ID <> :OLD.ID OR
    :NEW.FECHA_PUBLICACION <> :OLD.FECHA_PUBLICACION THEN
    RAISE_APPLICATION_ERROR(-20001, 'No se pueden modificar esos datos en la tabla publicacion cientifica');
    END IF;
END;
/




-- RESERVA
-- ADICIONAR


CREATE OR REPLACE TRIGGER generarReserva
BEFORE INSERT ON RESERVAS
FOR EACH ROW
  BEGIN
    :NEW.NUMERO:= TO_CHAR(SEQ_MI_VALOR_UNICO12.NEXTVAL);
    :NEW.fecha_reservacion := SYSDATE;


    IF :NEW.FECHA_ASISTENCIA < SYSDATE THEN
      RAISE_APPLICATION_ERROR(-20001, 'La fecha de asistencia debe ser mayor o igual a la fecha actual');
    END IF;
--El estado inicial de la reserva es Pendiente
    :NEW.ESTADO:='PENDIENTE';
--El estado pagado debe iniciar como 0
    :NEW.PAGADO:= 0;  
END;
/

--El id de servicio es autogenerado 

CREATE OR REPLACE TRIGGER generar_id_servicio
BEFORE INSERT ON SERVICIOS
FOR EACH ROW
  BEGIN
    :NEW.ID:= TO_CHAR(SEQ_MI_VALOR_UNICO13.NEXTVAL);
END;
/

--Solo los adultos pueden crear una reserva. 

CREATE OR REPLACE TRIGGER adultoReserva
BEFORE INSERT ON RESERVAS
FOR EACH ROW 
DECLARE 
  cont NUMBER;
BEGIN
  SELECT COUNT(*) INTO cont FROM ADULTOS WHERE 
  :NEW.ID_ADULTO = ADULTOS.id_usuario;
  IF cont = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El usuario no es adulto');
  END IF;
END;
/

-- MODIFICAR
--Solo se puede actualizar el estado y el pago. 
CREATE OR REPLACE TRIGGER reservaUpdate
BEFORE UPDATE ON RESERVAS
FOR EACH ROW
  BEGIN
    IF :NEW.numero <> :OLD.numero OR
       :NEW.id_servicio <> :OLD.id_servicio OR
       :NEW.id_adulto <> :OLD.id_adulto OR
       :NEW.fecha_reservacion <> :OLD.fecha_reservacion OR
       :NEW.cantidad_personas <> :OLD.cantidad_personas OR
       :NEW.fecha_asistencia <> :OLD.fecha_asistencia THEN 
        RAISE_APPLICATION_ERROR(-200003,'Solo es posible actualizar el estado y el pagado');
    END IF;
END;
/

--El servicio se puede actualizar si no tiene reservas asociadas. 
CREATE OR REPLACE TRIGGER servicioUpdate
BEFORE UPDATE ON SERVICIOS
FOR EACH ROW
DECLARE
  cont NUMBER;
BEGIN
  SELECT COUNT(*) INTO cont FROM RESERVAS
  WHERE RESERVAS.id_servicio = :OLD.id;
    IF cont > 0 THEN
      RAISE_APPLICATION_ERROR(-200003,'El servicio ya tiene reservas asociadas');
    END IF;
END;
/


-- ELIMINAR

CREATE OR REPLACE TRIGGER reservaDelete
BEFORE DELETE ON RESERVAS
FOR EACH ROW
BEGIN
  IF :OLD.estado <> 'PENDIENTE' THEN 
  RAISE_APPLICATION_ERROR(-200003,'La reserva ya tiene una respuesta, no es posible eliminarla');
  END IF;
END;
/
--El servicio se puede eliminar si no tiene reservas asociados 
CREATE OR REPLACE TRIGGER deleteServicio
BEFORE UPDATE ON SERVICIOS
FOR EACH ROW
DECLARE
  cont NUMBER;
BEGIN
  SELECT COUNT(*) INTO cont FROM reservaS
  WHERE RESERVAS.id_servicio = :OLD.id;
    IF cont > 0 THEN
      RAISE_APPLICATION_ERROR(-200003,'El servicio ya tiene reservas asociadas');
    END IF;
END;
/


-- PERSONA
-- ADICIONAR

CREATE OR REPLACE TRIGGER personaGenerar
BEFORE INSERT ON PERSONAS
FOR EACH ROW
DECLARE 
  edad NUMBER;
BEGIN
  edad := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.FECHA_NACIMIENTO) / 12);
  IF edad < 18 AND :NEW.tipo_documento = 'CC' THEN
    RAISE_APPLICATION_ERROR (-200003, 'No coincide la fecha con el tipo de documento');
  END IF;
  IF edad >= 18 AND :NEW.tipo_documento = 'TI' THEN
    RAISE_APPLICATION_ERROR (-200003, 'No coincide la fecha con el tipo de documento');
  END IF;
  :NEW.id_usuario := TO_CHAR(SEQ_MI_VALOR_UNICO14.NEXTVAL);
  IF :NEW.FECHA_NACIMIENTO > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-200003,'La fecha de nacimiento es incorrecta');
  END IF;
END;
/



-- MODIFICAR
-- No se puede modificar un adulto y tiene asociada una reservacion
CREATE OR REPLACE TRIGGER adultoUpdate
BEFORE UPDATE ON ADULTOS
FOR EACH ROW
DECLARE
  reservas NUMBER;
  BEGIN
    SELECT COUNT(*) INTO reservas FROM RESERVAS JOIN ADULTOS ON RESERVAS.id_adulto = ADULTOS.id_usuario 
    WHERE id_adulto = :OLD.id_usuario AND estado = 'PENDIENTE' OR estado = 'Aceptado' AND pagado = 0; 
    IF reservas > 0 then
      RAISE_APPLICATION_ERROR(-20001, 'La persona ya tiene una reserva activa');
    END IF;
END;
/



-- No se puede modificar una persona si tiene asociada una reservacion

CREATE OR REPLACE TRIGGER personaCrea
BEFORE INSERT ON PERSONAS
FOR EACH ROW
DECLARE
  reservas NUMBER;
  edad NUMBER;
  BEGIN

    edad := FLOOR(MONTHS_BETWEEN(SYSDATE, :OLD.FECHA_NACIMIENTO) / 12);
    IF edad < 18 AND :NEW.tipo_documento = 'CC' THEN
      RAISE_APPLICATION_ERROR (-200003, 'No coincide la fecha con el tipo de documento');
    END IF;
    IF edad >= 18 AND :NEW.tipo_documento = 'TI' THEN
      RAISE_APPLICATION_ERROR (-200003, 'No coincide la fecha con el tipo de documento');
    END IF;


    SELECT COUNT(*) INTO reservas FROM RESERVAS
    WHERE id_adulto = :OLD.id_usuario;

    IF reservas > 0 then
      RAISE_APPLICATION_ERROR(-20001, 'La persona ya tiene una reserva activa');
    END IF;
END;
/


-- ELIMINAR
CREATE OR REPLACE TRIGGER adultoDelete
BEFORE DELETE ON ADULTOS
FOR EACH ROW
DECLARE
  reservas NUMBER;
BEGIN
  SELECT COUNT(*) INTO reservas FROM RESERVAS
  WHERE id_adulto = :OLD.id_usuario;

  IF reservas > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'La persona tiene una reserva activa');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER personaDelete
BEFORE DELETE ON PERSONAS
FOR EACH ROW
DECLARE
  reservas NUMBER;
BEGIN
  SELECT COUNT(*) INTO reservas FROM RESERVAS JOIN ADULTOS ON RESERVAS.id_adulto = ADULTOS.id_usuario
  WHERE id_adulto = :OLD.id_usuario AND estado = 'PENDIENTE' OR estado = 'Aceptado' AND pagado = 0;

  IF reservas > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'La persona tiene una reserva activa');
  END IF;
END;
/




-- nuevos 
CREATE OR REPLACE TRIGGER UpdateEcosistema
BEFORE UPDATE ON ecosistemas
FOR EACH ROW 
BEGIN
    IF :NEW.CODIGO <> :OLD.CODIGO OR 
    :NEW.NOMBRE_ECOSISTEMA <> :OLD.NOMBRE_ECOSISTEMA OR 
    :NEW.CODIGO_PARQUE <> :OLD.CODIGO_PARQUE THEN
      RAISE_APPLICATION_ERROR(-200004, 'No se puede actualizar');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER UpdateEspeciePlanta
BEFORE UPDATE ON ESPECIES_PLANTAS
FOR EACH ROW 
BEGIN
    IF :NEW.id <> :OLD.id OR 
    :NEW.NOMBRE_CIENTIFICO <> :OLD.NOMBRE_CIENTIFICO  THEN
      RAISE_APPLICATION_ERROR(-200004, 'No se puede actualizar');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER UpdateEspecieAnimal
BEFORE UPDATE ON ESPECIES_ANIMALES
FOR EACH ROW 
BEGIN
    IF :NEW.id <> :OLD.id OR 
    :NEW.NOMBRE_CIENTIFICO <> :OLD.NOMBRE_CIENTIFICO  THEN
      RAISE_APPLICATION_ERROR(-200004, 'No se puede actualizar');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER UpdateUbicacion
BEFORE UPDATE ON UBICACIONES
FOR EACH ROW 
BEGIN
    IF :NEW.latitud <> :OLD.latitud OR 
      :NEW.longitud <> :OLD.longitud OR
      :NEW.tamano <> :OLD.tamano THEN 
      RAISE_APPLICATION_ERROR(-200004, 'No se puede actuaizar');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER UpdatePais
BEFORE UPDATE ON PAISES
FOR EACH ROW 
BEGIN
  IF :NEW.id_pais <> :OLD.id_pais OR 
    :NEW.nombre <> :OLD.nombre OR
    :NEW.latitud <> :OLD.latitud OR
    :NEW.LONGITUD  <> :OLD.LONGITUD THEN
    RAISE_APPLICATION_ERROR(-200004, 'No se puede actuaizar');
  END IF;
END;
/



CREATE OR REPLACE TRIGGER PAISDELETE
BEFORE DELETE ON PAISES
FOR EACH ROW
BEGIN 
  RAISE_APPLICATION_ERROR(-20004, 'NO SE PUEDE ELIMINAR');
END;
/


CREATE OR REPLACE TRIGGER departamentoDelete
BEFORE DELETE ON departamentos
FOR EACH ROW
BEGIN 
  RAISE_APPLICATION_ERROR(-20004, 'NO SE PUEDE ELIMINAR');
END;
/


CREATE OR REPLACE TRIGGER departamentoUpdate
BEFORE UPDATE ON departamentos
FOR EACH ROW
BEGIN 
  IF
  :NEW.ID_DEPARTAMENTO <> :OLD.ID_DEPARTAMENTO OR
  :NEW.NOMBRE <> :OLD.NOMBRE OR 
  :NEW.LATITUD <>  :OLD.LATITUD OR
  :NEW.LONGITUD <> :OLD.LONGITUD THEN
    RAISE_APPLICATION_ERROR(-20004, 'NO SE PUEDE ACTUALIZAR');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER delete_especies_afectadas
BEFORE DELETE ON ESPECIES_AFECTADAS
BEGIN
  raise_application_error(-20001,'No puedes eliminar la tabla ESPECIES_AFECTADAS.');
END;
/


CREATE OR REPLACE TRIGGER update_especies_afectadas
BEFORE UPDATE ON ESPECIES_AFECTADAS
FOR EACH ROW
BEGIN
  IF :NEW.CODIGO_ESPECIE <> :OLD.CODIGO_ESPECIE OR
     :NEW.NOMBRE_ESPECIE <> :OLD.NOMBRE_ESPECIE OR
     :NEW.CODIGO_AMENAZA <> :OLD.CODIGO_AMENAZA THEN
        raise_application_error(-20001, 'No puedes actualizar la tabla ESPECIES_AFECTADAS.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER eliminar_impacto
BEFORE DELETE ON IMPACTOS
FOR EACH ROW
  BEGIN
      RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar ningun IMPACTO');
END;
/

CREATE OR REPLACE TRIGGER NINIO_DIFERENTE_ADULTO
  BEFORE INSERT ON NINIOS
  FOR EACH ROW
  DECLARE 
    cont  NUMBER;
    contu  NUMBER;
  BEGIN 
    SELECT COUNT(*) INTO CONT FROM ADULTOS
    WHERE ID_USUARIO = :NEW.ID_USUARIO;  
    SELECT COUNT(*) INTO CONTU FROM ADULTOS
    WHERE ID_USUARIO = :NEW.RESPONSABLE;
    IF CONT = 1 THEN 
      RAISE_APPLICATION_ERROR(-2000004,'Un ninio no puede ser adulto');
    END IF;
    IF CONTU = 0 THEN 
      RAISE_APPLICATION_ERROR(-2000004, 'El responsable no existe');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER ADULTO_DIFERENTE_NINIOS
  BEFORE INSERT ON ADULTOS
  FOR EACH ROW
  DECLARE 
    cont  NUMBER;
  BEGIN 
    SELECT COUNT(*) INTO CONT FROM NINIOS
    WHERE ID_USUARIO = :NEW.ID_USUARIO;  
    IF CONT = 1 THEN 
      RAISE_APPLICATION_ERROR(-200004,'Un adulto no puede ser ninio');
    END IF;
END;
/

/*
--Tuplas NoOk
-- Disparadores NoOK
DELETE FROM PARQUES_NATURALES

DELETE FROM ECOSISTEMAS 

DELETE FROM UBICACIONES

INSERT INTO PARQUES_NATURALES (CODIGO,NOMBRE,HORA_APERTURA,HORA_CIERRE,CANT_TRABAJADORES,FECHA_REGISTRO,VALOR_INGRESO_ADULTOS,VALOR_INGRESO_NINOS) 
VALUES ('CODIGO_PARQUE','Nombre del Parque',TO_DATE('2023-12-15 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_DATE('2023-12-15 05:00:00', 'YYYY-MM-DD HH24:MI:SS'),20,SYSDATE,10.50,5.0);

INSERT INTO RESERVAS (NUMERO,ID_SERVICIO,ID_ADULTO,FECHA_RESERVACION,PAGADO,CANTIDAD_PERSONAS,CONTACTO,ESTADO,FECHA_ASISTENCIA) VALUES ('NUMERO_RESERVA','ID_SERVICIO','ID_ADULTO',SYSDATE,0,2,'contacto@ejemplo.com','PENDIENTE',TO_DATE('2023-12-15', 'YYYY-MM-DD');

INSERT INTO RESERVAS (NUMERO,ID_SERVICIO,ID_ADULTO,FECHA_RESERVACION,PAGADO,CANTIDAD_PERSONAS,CONTACTO,ESTADO,FECHA_ASISTENCIA) 
VALUES ('NUMERO_RESERVA','ID_SERVICIO','ID_ADULTO',TO_DATE('2023-12-15','YYYY-MM-DD'),0,2,'contacto@ejemplo.com','PENDIENTE',TO_DATE('2023-09-15','YYYY-MM-DD'));

UPDATE PARQUES_NATURALES
SET CODIGO = '21'
WHERE CODIGO = '1'

UPDATE ACTIVIDADES_PERMITIDAS
SET TIPO_DE_ACTIVIDAD = 'PESCA'
WHERE ID = '1'
*/

/*
--Tuplas NoOk
-- Disparadores NoOK
DELETE FROM PARQUES_NATURALES

DELETE FROM ECOSISTEMAS 

DELETE FROM UBICACIONES

INSERT INTO PARQUES_NATURALES (CODIGO,NOMBRE,HORA_APERTURA,HORA_CIERRE,CANT_TRABAJADORES,FECHA_REGISTRO,VALOR_INGRESO_ADULTOS,VALOR_INGRESO_NINOS) 
VALUES ('CODIGO_PARQUE','Nombre del Parque',TO_DATE('2023-12-15 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_DATE('2023-12-15 05:00:00', 'YYYY-MM-DD HH24:MI:SS'),20,SYSDATE,10.50,5.0);

INSERT INTO RESERVAS (NUMERO,ID_SERVICIO,ID_ADULTO,FECHA_RESERVACION,PAGADO,CANTIDAD_PERSONAS,CONTACTO,ESTADO,FECHA_ASISTENCIA) VALUES ('NUMERO_RESERVA','ID_SERVICIO','ID_ADULTO',SYSDATE,0,2,'contacto@ejemplo.com','PENDIENTE',TO_DATE('2023-12-15', 'YYYY-MM-DD');

INSERT INTO RESERVAS (NUMERO,ID_SERVICIO,ID_ADULTO,FECHA_RESERVACION,PAGADO,CANTIDAD_PERSONAS,CONTACTO,ESTADO,FECHA_ASISTENCIA) 
VALUES ('NUMERO_RESERVA','ID_SERVICIO','ID_ADULTO',TO_DATE('2023-12-15','YYYY-MM-DD'),0,2,'contacto@ejemplo.com','PENDIENTE',TO_DATE('2023-09-15','YYYY-MM-DD'));

UPDATE PARQUES_NATURALES
SET CODIGO = '21'
WHERE CODIGO = '1'

UPDATE ACTIVIDADES_PERMITIDAS
SET TIPO_DE_ACTIVIDAD = 'PESCA'
WHERE ID = '1'

UPDATE AMENAZAS
SET FECHA_DETECCION = SYSDATE
WHERE CODIGO = '1'

UPDATE IMPACTOS
SET SEVERIDAD = 'BAJA'
WHERE CODIGO_AMENAZA = '1'

INSERT INTO PUBLICACIONES_CIENTIFICAS(ID,CODIGO_PARQUE,TITULO,FECHA_PUBLICACION,RESUMEN,PALABRA_CLAVE,ENLACE,TIPO_PUBLICACION,FECHA_REGISTRO,AUTOR) 
VALUES('1','1','titulo', TO_DATE('15-12-2024','DD-MM-YYYY'),'RESUMEN_PUBLICACION','ARQUEOLOGIA','https://www.youtube.com','ARTICULO DE REVISTA CIENTIFICA',SYSDATE,'AUTOR_PUBLICACION');

UPDATE PUBLICACIONES_CIENTIFICAS
SET FECHA_PUBLICACION = SYSDATE
WHERE ID = '1'

INSERT INTO RESERVAS (NUMERO,ID_SERVICIO,ID_ADULTO,FECHA_RESERVACION,PAGADO,CANTIDAD_PERSONAS,CONTACTO,ESTADO,FECHA_ASISTENCIA) 
VALUES ('1','1', '1',TO_DATE('2021-10-15', 'YYYY-MM-DD'),1,5,'CONTACTO_RESERVA','ACEPTADA',TO_DATE('2021-12-25','YYYY-MM-DD');

UPDATE RESERVAS
SET CONTACTO = '123'
WHERE ID_SERVICIO = '1'

DELETE FROM SERVICIOS
WHERE ID = '1'

DELETE FROM RESERVAS
WHERE ESTADO = 'PENDIENTE'

DELETE FROM PERSONA
WHERE ID = '1'

UPDATE ECOSISTEMAS
SET NOMBRE_ECOSISTEMA = 'ECOSISTEMA_NUEVO'
WHERE CODIGO = '1'

INSERT INTO PERSONAS(ID_USUARIO,NOMBRE,FECHA_NACIMIENTO,GENERO,DOCUMENTO_IDENTIFICACION,TIPO_DOCUMENTO)
VALUES('1','YO',SYSDATE,'HOMBRE','1234567891','CC');

INSERT INTO PERSONAS(ID_USUARIO,NOMBRE,FECHA_NACIMIENTO,GENERO,DOCUMENTO_IDENTIFICACION,TIPO_DOCUMENTO)
VALUES('1','YO',TO_DATE('21-08-1977','DD-MM-YYYY'),'HOMBRE','1234567891','TI');

UPDATE ESPECIE_PLANTA
SET NOMBRE_CIENTIFICO = 'NOMBRE_NUEVO'
WHERE ID = '1'

UPDATE ESPECIE_ANIMAL
SET NOMBRE_CIENTIFICO = 'NOMBRE_NUEVO'
WHERE ID = '1'

UPDATE UBICACIONES
SET LATITUD = '1.34'
WHERE LONGITUD = '1'

DELETE FROM PAISES

DELETE FROM DEPARTAMENTOS

UPDATE PAISES
SET NOMBRE = 'PAIS_NUEVO'
WHERE ID_PAIS = '1'

UPDATE DEPARTAMENTOS
SET NOMBRE = 'DEPARTAMENTO_NUEVO'
WHERE ID_DEPARTAMENTO = '1'

DELETE FROM ESPECIES_AFECTADAS

UPDATE ESPECIES_AFECTADAS
SET NOMBRE_ESPECIE = 'NUEVO_NOMBRE'
WHERE CODIGO_ESPECIE = '1'

DELETE FROM IMPACTOS

INSERT INTO ADULTOS(ID_USUARIO,PAIS_RESIDENCIA,CONTACTO,CORREO)
VALUES('1','COLOMBIA','1234234213','prueba@hotmail.com');

INSERT INTO NINIOS(ID_USUARIO,RESPONSABLE,RH,CARNET_VACUNAS,ESTATURA,CONSENTIMIENTO)
VALUES('1','1','A+','carnet.pdf',1.2,'consentimiento.pdf');
*/