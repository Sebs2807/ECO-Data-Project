
-- XCRUD

DROP PACKAGE pk_publicacion;
DROP PACKAGE pk_reserva;
DROP PACKAGE pk_parque_natural;
DROP PACKAGE pk_amenazas;
DROP PACKAGE pk_persona;

set serveroutput on;

-- CRUDE PUBLICACION
create or replace PACKAGE pk_publicacion AS
  PROCEDURE publicacionInsertar(xcodigo_parque VARCHAR2,xtitulo VARCHAR2,xfecha_Publicacion DATE,xresumen VARCHAR2,xpalabra_clave VARCHAR2,xenlace VARCHAR2,xtipo_publicacion VARCHAR2,xautor VARCHAR2);

  PROCEDURE publicacionEliminar(xid VARCHAR2);

  PROCEDURE publicacionModificar(xid VARCHAR2,xtitulo VARCHAR2,xresumen VARCHAR2,xpalabra_clave VARCHAR2,xenlace VARCHAR2);

  PROCEDURE publicacionConsultar(xtitulo VARCHAR2);

  FUNCTION consultarPublicacionPorParque(xnombre_parque VARCHAR2)
    RETURN SYS_REFCURSOR;

  FUNCTION consultarPublicacionFiltradaPorPalabraClave(xnombre_parque VARCHAR2,xpalabra_clave VARCHAR2)
    RETURN SYS_REFCURSOR;  -- Vista

END pk_publicacion;
/

-- CRUDI PUBLICACION
create or replace PACKAGE BODY pk_publicacion AS
  PROCEDURE publicacionInsertar(xcodigo_parque VARCHAR2, xtitulo VARCHAR2, xfecha_Publicacion DATE, xresumen VARCHAR2,xpalabra_clave VARCHAR2,xenlace VARCHAR2,xtipo_publicacion VARCHAR2,xautor VARCHAR2) IS
  BEGIN
    INSERT INTO PUBLICACIONES_CIENTIFICAS (ID, CODIGO_PARQUE, TITULO, FECHA_PUBLICACION, RESUMEN, PALABRA_CLAVE, ENLACE, TIPO_PUBLICACION, FECHA_REGISTRO, AUTOR)
    VALUES (NULL, xcodigo_parque, xtitulo, xfecha_Publicacion, xresumen, xpalabra_clave, xenlace, xtipo_publicacion, NULL, xautor);
  END publicacionInsertar;

  PROCEDURE publicacionEliminar(xid VARCHAR2) IS
  BEGIN
    DELETE FROM PUBLICACIONES_CIENTIFICAS 
    WHERE ID = xid;
  END publicacionEliminar;

  PROCEDURE publicacionModificar(xid VARCHAR2, xtitulo VARCHAR2, xresumen VARCHAR2, xpalabra_clave VARCHAR2, xenlace VARCHAR2) IS
  BEGIN
    UPDATE PUBLICACIONES_CIENTIFICAS 
    SET TITULO = xtitulo, RESUMEN = xresumen, PALABRA_CLAVE = xpalabra_clave, ENLACE = xenlace
    WHERE ID = xid;
  END publicacionModificar;

  PROCEDURE publicacionConsultar(xtitulo VARCHAR2) IS
    v_resultado PUBLICACIONES_CIENTIFICAS%ROWTYPE;
  BEGIN
    SELECT * INTO v_resultado FROM PUBLICACIONES_CIENTIFICAS WHERE TITULO = xtitulo;
  END publicacionConsultar;

  FUNCTION consultarPublicacionPorParque(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_publicacion_por_parque SYS_REFCURSOR;
  BEGIN
    OPEN c_publicacion_por_parque FOR SELECT * FROM PUBLICACIONES_CIENTIFICAS WHERE CODIGO_PARQUE = xnombre_parque;
    RETURN c_publicacion_por_parque;
  END consultarPublicacionPorParque;

  FUNCTION consultarPublicacionFiltradaPorPalabraClave(xnombre_parque VARCHAR2, xpalabra_clave VARCHAR2) RETURN SYS_REFCURSOR IS
    c_consultar_publicacion_por_palabra SYS_REFCURSOR;
  BEGIN
    OPEN c_consultar_publicacion_por_palabra FOR
      SELECT *
      FROM VPubliParquePalabra
      WHERE palabra_clave_publicacion = xpalabra_clave AND codigo_parque = xnombre_parque;

    RETURN c_consultar_publicacion_por_palabra;
  END consultarPublicacionFiltradaPorPalabraClave;

END pk_publicacion;
/

-- CRUDE RESERVA
create or replace PACKAGE pk_reserva AS
  PROCEDURE reservaInsertar(xid_servicio VARCHAR2, xid_adulto VARCHAR2, xcantidad_personas NUMBER, xfecha_asistencia DATE, xfecha_fin DATE);

  PROCEDURE reservaModificar(xnumero VARCHAR2, xfecha_reservacion DATE, xfecha_fin DATE);

  PROCEDURE reservaActualizacion(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2);

  PROCEDURE reservaEliminar(xnumero VARCHAR2);

  FUNCTION reservaConsultar(xid_adulto VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarReservasRechazadas(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR; -- Vista

  PROCEDURE reservaPagada(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2); -- Corregido

  PROCEDURE servicioInsertar(xid_actividad VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2, xresponsables VARCHAR2, xmayor_de_edad NUMBER,xprecio_dia NUMBER, xprecio_persona NUMBER); 

  FUNCTION consultarServicios(xid VARCHAR2) RETURN SYS_REFCURSOR;

  PROCEDURE servicioEliminar(xid VARCHAR2);

  PROCEDURE servicioActualizar(xid VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2,xresponsable VARCHAR2, xmayor_de_edad NUMBER, xprecio_persona NUMBER, xprecio_dia NUMBER);

  FUNCTION servicioConsultar(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR;

  FUNCTION consultarServicioMenoresEdad(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR;

  FUNCTION servicioMasSolicitado(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR;

  FUNCTION consultarDinero(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR; -- Vista

END pk_reserva;
/

-- CRUDI RESERVA
create or replace PACKAGE BODY pk_reserva AS
  PROCEDURE reservaInsertar(xid_servicio VARCHAR2, xid_adulto VARCHAR2, xcantidad_personas NUMBER, xfecha_asistencia DATE, xfecha_fin DATE) IS
  documento VARCHAR2(50);
  BEGIN
    SELECT ID_USUARIO INTO documento FROM PERSONAS WHERE DOCUMENTO_IDENTIFICACION = xid_adulto;
    INSERT INTO RESERVAS(NUMERO, ID_SERVICIO, ID_ADULTO, FECHA_RESERVACION, PAGADO, CANTIDAD_PERSONAS,ESTADO, FECHA_ASISTENCIA,FECHA_FIN,PRECIO_TOTAL)
    VALUES(NULL, xid_servicio, documento, NULL,NULL, xcantidad_personas, NULL, xfecha_asistencia,xfecha_fin,NULL);
  END reservaInsertar;

  PROCEDURE reservaModificar(xnumero VARCHAR2, xfecha_reservacion DATE, xfecha_fin DATE) IS
  BEGIN
    UPDATE RESERVAS
    SET FECHA_RESERVACION = xfecha_reservacion, FECHA_FIN = xfecha_fin
    WHERE NUMERO = xnumero;
  END reservaModificar;

  PROCEDURE reservaActualizacion(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2) IS
  BEGIN
    UPDATE RESERVAS
    SET PAGADO = xpagado, ESTADO = xestado
    WHERE NUMERO = xnumero;
  END reservaActualizacion;

  PROCEDURE reservaEliminar(xnumero VARCHAR2) IS
  BEGIN
    DELETE FROM RESERVAS
    WHERE NUMERO = xnumero;
  END reservaEliminar;

  FUNCTION reservaConsultar(xid_adulto VARCHAR2) RETURN SYS_REFCURSOR IS
    c_reserva_consultar SYS_REFCURSOR;
  BEGIN
    OPEN c_reserva_consultar FOR
      SELECT * FROM RESERVAS WHERE ID_ADULTO = xid_adulto;
    RETURN c_reserva_consultar;
  END reservaConsultar;

  FUNCTION consultarReservasRechazadas(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_reservas_rechazadas SYS_REFCURSOR;
  BEGIN
    OPEN c_reservas_rechazadas FOR SELECT * FROM VRechazadasParque WHERE NOMBRE_PARQUE = xnombre_parque AND estado = 'RECHAZADA';
    RETURN c_reservas_rechazadas;
  END consultarReservasRechazadas;

  PROCEDURE reservaPagada(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2) IS
  BEGIN
    UPDATE RESERVAS
    SET PAGADO = xpagado, ESTADO = xestado
    WHERE NUMERO = xnumero;
  END reservaPagada;

  PROCEDURE servicioInsertar(xid_actividad VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2, xresponsables VARCHAR2, xmayor_de_edad NUMBER,xprecio_dia NUMBER, xprecio_persona NUMBER) IS
  BEGIN
    INSERT INTO SERVICIOS(ID, ID_ACTIVIDAD, DESCRIPCION, TIPO_SERVICIO, RESPONSABLE, MAYOR_DE_EDAD, PRECIO_DIA, PRECIO_PERSONA)
    VALUES(NULL, xid_actividad, xdescripcion, xtipo_servicio, xresponsables,xmayor_de_edad,xprecio_dia, xprecio_persona);
  END servicioInsertar;

  FUNCTION consultarServicios(xid VARCHAR2) RETURN SYS_REFCURSOR IS
    c_consultar_servicios SYS_REFCURSOR;
  BEGIN
    OPEN c_consultar_servicios FOR SELECT * FROM SERVICIOS WHERE ID = xid;
    RETURN c_consultar_servicios;
  END consultarServicios;

  PROCEDURE servicioEliminar(xid VARCHAR2) IS
  BEGIN
    DELETE FROM SERVICIOS
    WHERE ID = xid;
  END servicioEliminar;

  PROCEDURE servicioActualizar(xid VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2,xresponsable VARCHAR2, xmayor_de_edad NUMBER, xprecio_persona NUMBER, xprecio_dia NUMBER) IS
  BEGIN
    UPDATE SERVICIOS
    SET DESCRIPCION = xdescripcion, TIPO_SERVICIO = xtipo_servicio, RESPONSABLE = xresponsable, MAYOR_DE_EDAD = xmayor_de_edad, precio_persona = xprecio_persona, precio_dia = xprecio_dia
    WHERE ID = xid;
  END servicioActualizar;

  FUNCTION servicioConsultar(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_servicio_consultar SYS_REFCURSOR;
  BEGIN
    OPEN c_servicio_consultar FOR
      SELECT * FROM VServiciosParque
      WHERE NOMBRE_PARQUE = xnombre_parque;
    RETURN c_servicio_consultar;
  END servicioConsultar;

  FUNCTION consultarServicioMenoresEdad(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_consultar_servicio_menores_edad SYS_REFCURSOR;
  BEGIN
    OPEN c_consultar_servicio_menores_edad FOR
      SELECT * FROM VServiciosParque
      WHERE nombre_parque = xnombre_parque
      AND necesita_mayor_de_edad = 0;
    RETURN c_consultar_servicio_menores_edad;
  END consultarServicioMenoresEdad;

  FUNCTION servicioMasSolicitado(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_servicio_mas_solicitado SYS_REFCURSOR;
  BEGIN
    OPEN c_servicio_mas_solicitado FOR
      SELECT * FROM VServiciosPopularesParque WHERE NOMBRE_PARQUE = xnombre_parque;
    RETURN c_servicio_mas_solicitado;
  END servicioMasSolicitado;

  FUNCTION consultarDinero(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_consultar_dinero SYS_REFCURSOR;
  BEGIN
    OPEN c_consultar_dinero FOR
      SELECT nombre_parque,usuario,actividad,SUM(valor) AS total_recaudado
      FROM VRechazadasParque
      WHERE pagado = '1' AND nombre_parque = xnombre_parque
      GROUP BY nombre_parque, usuario, actividad;
    RETURN c_consultar_dinero;
  END consultarDinero;

END pk_reserva;
/

-- CRUDE PARQUE
create or replace PACKAGE PK_PARQUE_NATURAL AS 
  -- Parque
  PROCEDURE parqueRegister(xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xestadoParque VARCHAR2, xnombre VARCHAR2, xvalor_ingresoninos NUMBER, xvalor_ingresoadultos NUMBER,latitud NUMBER, longitud NUMBER, tamano NUMBER, xestado VARCHAR);

  PROCEDURE parqueUpdate(xcodigo VARCHAR2, xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xvalor_ingreso_ninos NUMBER, xvalor_ingreso_adultos NUMBER, xestado VARCHAR);

  -- Ecosistema
  PROCEDURE ecosistemaRegister(xcodigo_parque VARCHAR2, xnombre_ecosistema VARCHAR2, xclima VARCHAR2);

  PROCEDURE ecosistemaDelete(xcodigo VARCHAR2);

  PROCEDURE ecosistemaUpdate(xcodigo VARCHAR2, xclima VARCHAR2);

  -- Especie Planta
  PROCEDURE especiePlantaRegister(xnombre_cientifico VARCHAR2, xcodigo_ecosistema VARCHAR2, xnombre_comun VARCHAR2);

  PROCEDURE especiePlantaDelete(xid VARCHAR2);

  PROCEDURE especiePlantaUpdate(xid VARCHAR2, xnombre_comun VARCHAR2);

  -- Especie Animal
  PROCEDURE especieAnimalRegister(xnombre_cientifico VARCHAR2, xcodigo_ecosistema VARCHAR2, xnombre_comun VARCHAR2);

  PROCEDURE especieAnimalDelete(xid VARCHAR2);

  PROCEDURE especieAnimalUpdate(xid VARCHAR2, xnombre_comun VARCHAR2);

  -- Ubicacion
  PROCEDURE ubicacionRegister(xlatitud NUMBER, xlongitud NUMBER, xtamano NUMBER);

  -- Pais
  PROCEDURE paisRegister(xnombre VARCHAR2, xlatitud NUMBER, xlongitud NUMBER);

  -- Departamento
  PROCEDURE departamentoRegister(xnombre VARCHAR2, xlatitud NUMBER, xlongitud NUMBER);

  -- Contacto
  PROCEDURE contactoParqueRegister(xcontacto VARCHAR2, xcodigo_parque VARCHAR2);

  PROCEDURE contactoParqueUpdate(xcontacto VARCHAR2, xnuevoContacto VARCHAR2);

  PROCEDURE contactoDelete(xcontacto VARCHAR2);

  -- Actividad
  PROCEDURE actividadRegister(xdescripcion_actividad VARCHAR2, xtipo_de_actividad VARCHAR2,xid_parque VARCHAR2);

  PROCEDURE actividadDelete(xid VARCHAR2);

  PROCEDURE actividadUpdate(xid VARCHAR2, xdescripcion_actividad VARCHAR2);

  -- Equipo
  PROCEDURE equipoRegister(xnombre_equipo VARCHAR2, xid_actividad VARCHAR2);

  PROCEDURE equipoUpdate(xid VARCHAR2, xnombre_equipo VARCHAR2);

  PROCEDURE equipoDelete(xid VARCHAR2);

-- CURSORES

  FUNCTION parqueConsultar(xcodigo_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarEcosistemaPorParque(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarActividades(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR; --vista

  FUNCTION consultarAnimalPorParque(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR; -- vista

  FUNCTION consultarPlantaPorParque(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarTotalReservasPorParque(xid_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarParqueEnPais(xnombre_pais VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarClimaPredominante(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR; -- vista

  FUNCTION consultarParqueEnDepartamento(xnombre_departamento VARCHAR2) 
    RETURN SYS_REFCURSOR;

END PK_PARQUE_NATURAL;
/

-- CRUDI PARQUE
create or replace PACKAGE BODY PK_PARQUE_NATURAL AS
  -- Parque
  PROCEDURE parqueRegister(xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xestadoParque VARCHAR2, xnombre VARCHAR2, xvalor_ingresoninos NUMBER, xvalor_ingresoadultos NUMBER,latitud NUMBER,longitud NUMBER, tamano NUMBER, xestado VARCHAR) IS
  nuevaUbicacion NUMBER;
  xlatitud NUMBER;
  xlongitud NUMBER;
  xparque VARCHAR2(50);
  BEGIN
  -- insertamos en parque
    INSERT INTO PARQUES_NATURALES (CODIGO, NOMBRE, HORA_APERTURA, HORA_CIERRE, CANT_TRABAJADORES, FECHA_REGISTRO, VALOR_INGRESO_ADULTOS, VALOR_INGRESO_NINOS, estado)
    VALUES (NULL, xnombre, xhoraApertura, xhoraCierre, xcantTrabajadores, SYSDATE, xvalor_ingresoadultos, xvalor_ingresoninos, xestado) 

     RETURNING CODIGO INTO xparque;

  SELECT COUNT(*) INTO nuevaUbicacion 
    FROM ubicaciones WHERE latitud = parqueRegister.LATITUD and longitud = parqueRegister.LONGITUD;

  IF nuevaUbicacion = 0 THEN 
    INSERT INTO ubicaciones (latitud, longitud, tamano) VALUES (latitud,longitud,tamano);
  END IF;
  SELECT latitud, longitud INTO  xlatitud, xlongitud FROM ubicaciones WHERE latitud = parqueRegister.LATITUD and longitud = parqueRegister.LONGITUD;

  INSERT INTO UBICACIONES_POR_PARQUE(codigo_parque, latitud,longitud) VALUES (xparque, xlatitud, xlongitud);

  END parqueRegister;

  PROCEDURE parqueUpdate(xcodigo VARCHAR2, xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xvalor_ingreso_ninos NUMBER, xvalor_ingreso_adultos NUMBER, xestado VARCHAR) IS
  BEGIN
    UPDATE PARQUES_NATURALES
    SET HORA_APERTURA = xhoraApertura,
        HORA_CIERRE = xhoraCierre,
        CANT_TRABAJADORES = xcantTrabajadores,
        VALOR_INGRESO_ADULTOS = xvalor_ingreso_adultos,
        VALOR_INGRESO_NINOS = xvalor_ingreso_ninos,
        estado = xestado
    WHERE CODIGO = xcodigo;
  END parqueUpdate;

  PROCEDURE equipoRegister(xnombre_equipo VARCHAR2, xid_actividad VARCHAR2) IS 
    BEGIN 
      INSERT INTO equipos_basicos(ID,ID_ACTIVIDAD,NOMBRE_EQUIPO) 
      VALUES(NULL,xid_actividad,xnombre_equipo);
    END equipoRegister;

  PROCEDURE equipoUpdate(xid VARCHAR2, xnombre_equipo VARCHAR2) IS 
    BEGIN
      UPDATE EQUIPOS_BASICOS SET NOMBRE_EQUIPO = xnombre_equipo WHERE ID = xid;
    END equipoUpdate;

  PROCEDURE equipoDelete(xid VARCHAR2) IS 
    BEGIN  
      DELETE FROM EQUIPOS_BASICOS WHERE ID = xid;
    END equipoDelete;

  -- Ecosistema
  PROCEDURE ecosistemaRegister(xcodigo_parque VARCHAR2, xnombre_ecosistema VARCHAR2, xclima VARCHAR2) IS
  BEGIN
    INSERT INTO ECOSISTEMAS (CODIGO, NOMBRE_ECOSISTEMA, CLIMA, CODIGO_PARQUE)
    VALUES (NULL, xnombre_ecosistema, xclima, xcodigo_parque);
  END ecosistemaRegister;

  PROCEDURE ecosistemaDelete(xcodigo VARCHAR2) IS
  BEGIN
    DELETE FROM ECOSISTEMAS WHERE CODIGO_PARQUE = xcodigo;
  END ecosistemaDelete;

  PROCEDURE ecosistemaUpdate(xcodigo VARCHAR2, xclima VARCHAR2) IS
  BEGIN
    UPDATE ECOSISTEMAS
    SET CLIMA = xclima
    WHERE CODIGO_PARQUE = xcodigo;
  END ecosistemaUpdate;

  -- Especie Planta
  PROCEDURE especiePlantaRegister(xnombre_cientifico VARCHAR2, xcodigo_ecosistema VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    INSERT INTO ESPECIES_PLANTAS (ID, NOMBRE_CIENTIFICO, NOMBRE_COMUN, CODIGO_ECOSISTEMA)
    VALUES (NULL, xnombre_cientifico, xnombre_comun, xcodigo_ecosistema);
  END especiePlantaRegister;

  PROCEDURE especiePlantaDelete(xid VARCHAR2) IS
  BEGIN
    DELETE FROM ESPECIES_PLANTAS WHERE ID = xid;
  END especiePlantaDelete;

  PROCEDURE especiePlantaUpdate(xid VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    UPDATE ESPECIES_PLANTAS
    SET NOMBRE_COMUN = xnombre_comun
    WHERE ID = xid;
  END especiePlantaUpdate;

  -- Especie Animal
  PROCEDURE especieAnimalRegister(xnombre_cientifico VARCHAR2, xcodigo_ecosistema VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    INSERT INTO ESPECIES_ANIMALES (ID, NOMBRE_CIENTIFICO, NOMBRE_COMUN, CODIGO_ECOSISTEMA)
    VALUES (NULL, xnombre_cientifico, xnombre_comun, xcodigo_ecosistema);
  END especieAnimalRegister;

  PROCEDURE especieAnimalDelete(xid VARCHAR2) IS
  BEGIN
    DELETE FROM ESPECIES_ANIMALES WHERE ID = xid;
  END especieAnimalDelete;

  PROCEDURE especieAnimalUpdate(xid VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    UPDATE ESPECIES_ANIMALES
    SET NOMBRE_COMUN = xnombre_comun
    WHERE ID = xid;
  END especieAnimalUpdate;

  -- Ubicacion
  PROCEDURE ubicacionRegister(xlatitud NUMBER, xlongitud NUMBER, xtamano NUMBER) IS
  BEGIN
    INSERT INTO UBICACIONES (LATITUD, LONGITUD, TAMANO)
    VALUES (xlatitud, xlongitud, xtamano);
  END ubicacionRegister;

  -- Pais
  PROCEDURE paisRegister(xnombre VARCHAR2, xlatitud NUMBER, xlongitud NUMBER) IS
  BEGIN
    INSERT INTO PAISES (ID_PAIS, NOMBRE, LATITUD, LONGITUD)
    VALUES (NULL, xnombre, xlatitud, xlongitud);
  END paisRegister;

  -- Departamento
  PROCEDURE departamentoRegister(xnombre VARCHAR2, xlatitud NUMBER, xlongitud NUMBER) IS
  BEGIN
    INSERT INTO DEPARTAMENTOS (ID_DEPARTAMENTO, NOMBRE, LATITUD, LONGITUD)
    VALUES (NULL, xnombre, xlatitud, xlongitud);
  END departamentoRegister;

  -- Contacto
  PROCEDURE contactoParqueRegister(xcontacto VARCHAR2, xcodigo_parque VARCHAR2) IS
  BEGIN
    INSERT INTO CONTACTOS_PARQUE (CODIGO_PARQUE, CONTACTO)
    VALUES (xcodigo_parque, xcontacto);
  END contactoParqueRegister;

  PROCEDURE contactoParqueUpdate(xcontacto VARCHAR2, xnuevoContacto VARCHAR2) IS
  BEGIN
    UPDATE CONTACTOS_PARQUE
    SET CONTACTO = xnuevoContacto
    WHERE CONTACTO = xcontacto;
  END contactoParqueUpdate;

  PROCEDURE contactoDelete(xcontacto VARCHAR2) IS
  BEGIN
    DELETE FROM CONTACTOS_PARQUE WHERE CONTACTO = xcontacto;
  END contactoDelete;

  -- Actividad
  PROCEDURE actividadRegister(xdescripcion_actividad VARCHAR2, xtipo_de_actividad VARCHAR2, xid_parque VARCHAR2) IS
    registro NUMBER;
    id_actividades VARCHAR2(50);
  BEGIN
    SELECT COUNT(*) into registro FROM PARQUES_NATURALES
    WHERE CODIGO = xid_parque;
    IF registro = 1 THEN
      INSERT INTO ACTIVIDADES_PERMITIDAS (ID, DESCRIPCION_ACTIVIDAD,TIPO_DE_ACTIVIDAD)
      VALUES (NULL, xdescripcion_actividad, xtipo_de_actividad)
      RETURNING ID INTO id_actividades;
      INSERT INTO ACTIVIDADES_POR_PARQUE(ID_PARQUE, ID_ACTIVIDAD) VALUES (xid_parque,id_actividades);
    END IF;

  END actividadRegister;

  PROCEDURE actividadDelete(xid VARCHAR2) IS
  BEGIN
    DELETE FROM ACTIVIDADES_PERMITIDAS WHERE ID = xid;
  END actividadDelete;

  PROCEDURE actividadUpdate(xid VARCHAR2, xdescripcion_actividad VARCHAR2) IS
  BEGIN
    UPDATE ACTIVIDADES_PERMITIDAS
    SET DESCRIPCION_ACTIVIDAD = xdescripcion_actividad
    WHERE ID = xid; 
END actividadUpdate;

-- CURSORES 

FUNCTION parqueConsultar(xcodigo_parque VARCHAR2) 
  RETURN SYS_REFCURSOR 
  IS result_parqueConsultar SYS_REFCURSOR;
  BEGIN 
    OPEN result_parqueConsultar FOR 
    SELECT * FROM PARQUES_NATURALES WHERE CODIGO = xcodigo_parque;
    RETURN result_parqueConsultar;
  END parqueConsultar;



FUNCTION consultarEcosistemaPorParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR -- vista
  IS result_ecosistemaPorParque SYS_REFCURSOR;
  BEGIN 
    OPEN result_ecosistemaPorParque FOR
    SELECT * FROM VEcosistemaParque 
    WHERE nombre_parque = xnombre_parque;
    RETURN result_ecosistemaPorParque;
  END consultarEcosistemaPorParque;


FUNCTION consultarActividades(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR --vista
  IS result_consultarActividades SYS_REFCURSOR;
  BEGIN 
    OPEN result_consultarActividades FOR
    SELECT * FROM VActividadPorParque 
    WHERE nombre_parque = xnombre_parque;
    RETURN result_consultarActividades;
  END consultarActividades;



FUNCTION consultarAnimalPorParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR --vista
  IS result_consultarAnimalPorParque SYS_REFCURSOR;
  BEGIN 
    OPEN result_consultarAnimalPorParque FOR
    SELECT * FROM VAnimalParque 
    WHERE nombre_parque = xnombre_parque;
    RETURN result_consultarAnimalPorParque;
  END consultarAnimalPorParque;

FUNCTION consultarPlantaPorParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR -- vista
  IS result_consultarPlantaPorParque SYS_REFCURSOR;
  BEGIN  
    OPEN result_consultarPlantaPorParque FOR
    SELECT * FROM VPlantaParque
    WHERE nombre_parque = xnombre_parque;
    RETURN result_consultarPlantaPorParque;
  END consultarPlantaPorParque;

FUNCTION consultarTotalReservasPorParque(xid_parque VARCHAR2) 
  RETURN SYS_REFCURSOR
  IS result_ReservasParque SYS_REFCURSOR;
  BEGIN
    OPEN result_ReservasParque FOR
    SELECT COUNT(*) AS TOTAL_RESERVAS
    FROM RESERVAS R
    JOIN SERVICIOS S ON R.ID_SERVICIO = S.ID
    JOIN ACTIVIDADES_POR_PARQUE APP ON S.ID_ACTIVIDAD = APP.ID_ACTIVIDAD
    JOIN PARQUES_NATURALES PN ON APP.ID_PARQUE = PN.CODIGO
    WHERE PN.CODIGO = xid_parque;
    RETURN result_ReservasParque;
  END consultarTotalReservasPorParque;

FUNCTION consultarParqueEnPais(xnombre_pais VARCHAR2)

  RETURN SYS_REFCURSOR
  IS result_consultarParqueEnPais SYS_REFCURSOR;
  BEGIN  
    OPEN result_consultarParqueEnPais FOR
    SELECT PN.CODIGO, PN.NOMBRE
    FROM PARQUES_NATURALES PN
    JOIN UBICACIONES_POR_PARQUE UP ON PN.CODIGO = UP.CODIGO_PARQUE
    JOIN PAISES P ON UP.LATITUD = P.LATITUD AND UP.LONGITUD = P.LONGITUD
    WHERE P.NOMBRE = xnombre_pais;
    RETURN result_consultarParqueEnPais;
  END consultarParqueEnPais;

  FUNCTION consultarClimaPredominante(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR
    IS result_climaPredominante SYS_REFCURSOR;
    BEGIN
      OPEN result_climaPredominante FOR
      SELECT * FROM VClimaPredominante
      WHERE nombre_parque = xnombre_parque;
      RETURN result_climaPredominante;
    END consultarClimaPredominante;

  FUNCTION consultarParqueEnDepartamento(xnombre_departamento VARCHAR2) 
    RETURN SYS_REFCURSOR
    IS result_consultarParqueEnDepartamento SYS_REFCURSOR;
    BEGIN  
      OPEN result_consultarParqueEnDepartamento FOR
      SELECT PN.CODIGO, PN.NOMBRE
      FROM PARQUES_NATURALES PN
      JOIN UBICACIONES_POR_PARQUE UP ON PN.CODIGO = UP.CODIGO_PARQUE
      JOIN DEPARTAMENTOS P ON UP.LATITUD = P.LATITUD AND UP.LONGITUD = P.LONGITUD
      WHERE P.NOMBRE = xnombre_departamento;
      RETURN result_consultarParqueEnDepartamento;
    END consultarParqueEnDepartamento;

END PK_PARQUE_NATURAL;
/

-- CRUDE AMENAZA
create or replace PACKAGE PK_AMENAZAS AS

  -- Amenaza
  PROCEDURE amenazaRegister(xgravedad VARCHAR2, xtipo VARCHAR2, xfecha_mitigacion DATE,xid_parque VARCHAR2);

  PROCEDURE amenazaUpdate(xcodigo VARCHAR2, xestado VARCHAR2, xfecha_mitigacion DATE);

  -- Impacto
  PROCEDURE impactoRegister(xcodigo_amenaza VARCHAR2, xdescripcion VARCHAR2, xseveridad VARCHAR2);

  PROCEDURE impactoUpdate(xcodigo_amenaza VARCHAR2, xaccion_mitigacion VARCHAR2);

  -- Especie Afectada
  PROCEDURE especieAfectadaRegister(xcodigo_amenaza VARCHAR2, xnombre_especie VARCHAR2);

  -- Consultas
  FUNCTION especieAfectadaConsultar(xcodigo_amenaza VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION amenazaConsulta(xcodigo VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarMayorGravedad 
    RETURN SYS_REFCURSOR;

  FUNCTION impactoConsultar(xcodigo_amenaza VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarEstadoAmenazas 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarAmenazasParque(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

END PK_AMENAZAS;
/

-- CRUDI AMENAZA
create or replace PACKAGE BODY PK_AMENAZAS AS
  -- Amenaza
  PROCEDURE amenazaRegister(xgravedad VARCHAR2, xtipo VARCHAR2, xfecha_mitigacion DATE,xid_parque VARCHAR2) IS
  determinar NUMBER;
  xid_amenaza  VARCHAR2(50);
  BEGIN 
    SELECT count(*) INTO determinar  FROM PARQUES_NATURALES 
    WHERE CODIGO = amenazaRegister.xid_parque;
    IF determinar = 1 THEN 
    INSERT INTO AMENAZAS (CODIGO, ESTADO, GRAVEDAD, TIPO, FECHA_DETECCION, FECHA_MITIGACION)
    VALUES (NULL, NULL, xgravedad, xtipo, SYSDATE, xfecha_mitigacion) 
      RETURNING CODIGO INTO xid_amenaza;
    INSERT INTO AMENAZAS_POR_PARQUE (CODIGO_PARQUE, CODIGO_AMENAZA) VALUES 
      (xid_parque, xid_amenaza);
    END IF;
  END amenazaRegister;
  PROCEDURE amenazaUpdate(xcodigo VARCHAR2, xestado VARCHAR2, xfecha_mitigacion DATE) AS
  BEGIN
    UPDATE AMENAZAS
    SET ESTADO = xestado, FECHA_MITIGACION = xfecha_mitigacion
    WHERE CODIGO = xcodigo;
  END amenazaUpdate;

  -- Impacto
  PROCEDURE impactoRegister(xcodigo_amenaza VARCHAR2, xdescripcion VARCHAR2, xseveridad VARCHAR2) AS
  BEGIN
    INSERT INTO IMPACTOS (CODIGO_AMENAZA, DESCRIPCION, SEVERIDAD)
    VALUES (xcodigo_amenaza, xdescripcion, xseveridad);
  END impactoRegister;

  PROCEDURE impactoUpdate(xcodigo_amenaza VARCHAR2, xaccion_mitigacion VARCHAR2) AS
  BEGIN
    UPDATE IMPACTOS
    SET ACCION_MITIGACION = xaccion_mitigacion
    WHERE CODIGO_AMENAZA = xcodigo_amenaza;
  END impactoUpdate;

  -- Especie Afectada
  PROCEDURE especieAfectadaRegister(xcodigo_amenaza VARCHAR2, xnombre_especie VARCHAR2) AS
  BEGIN
    INSERT INTO ESPECIES_AFECTADAS (CODIGO_ESPECIE, NOMBRE_ESPECIE, CODIGO_AMENAZA)
    VALUES (NULL, xnombre_especie, xcodigo_amenaza);
  END especieAfectadaRegister;

  -- Consultas
  FUNCTION especieAfectadaConsultar(xcodigo_amenaza VARCHAR2)
  RETURN SYS_REFCURSOR -- vista
  IS
    result_especieAfectadaConsultar SYS_REFCURSOR;
  BEGIN
    OPEN result_especieAfectadaConsultar FOR
      SELECT * FROM VAnimalesAfectados
      WHERE codigo_amenaza = xcodigo_amenaza;
    RETURN result_especieAfectadaConsultar;
  END especieAfectadaConsultar;

  FUNCTION amenazaConsulta(xcodigo VARCHAR2) 
  RETURN SYS_REFCURSOR 
    IS
    result_amenazaConsulta SYS_REFCURSOR;
  BEGIN
    OPEN result_amenazaConsulta FOR
      SELECT * FROM AMENAZAS
      WHERE CODIGO = xcodigo;
    RETURN result_amenazaConsulta;
  END amenazaConsulta;

  FUNCTION consultarMayorGravedad
  RETURN SYS_REFCURSOR
    IS
    result_consultarMayorGravedad SYS_REFCURSOR;
  BEGIN
    OPEN result_consultarMayorGravedad FOR
      SELECT PN.NOMBRE AS NOMBRE_PARQUE, AP.CODIGO_AMENAZA
      FROM PARQUES_NATURALES PN
      JOIN AMENAZAS_POR_PARQUE AP ON PN.CODIGO = AP.CODIGO_PARQUE
      JOIN AMENAZAS A ON AP.CODIGO_AMENAZA = A.CODIGO
      WHERE A.GRAVEDAD = 'MUY SIGNIFICATIVA';
    RETURN result_consultarMayorGravedad;
  END consultarMayorGravedad;

  FUNCTION impactoConsultar(xcodigo_amenaza VARCHAR2) 
  RETURN SYS_REFCURSOR 
  IS
    result_impactoConsultar SYS_REFCURSOR;
  BEGIN
    OPEN result_impactoConsultar FOR
      SELECT * FROM IMPACTOS
      WHERE CODIGO_AMENAZA = xcodigo_amenaza;
    RETURN result_impactoConsultar;
  END impactoConsultar;

  FUNCTION consultarEstadoAmenazas
  RETURN SYS_REFCURSOR 
  IS
    result_consultarEstadoAmenazas SYS_REFCURSOR;
  BEGIN
    OPEN result_consultarEstadoAmenazas FOR
      SELECT CODIGO, ESTADO, FECHA_DETECCION
      FROM AMENAZAS;
    RETURN result_consultarEstadoAmenazas;
  END consultarEstadoAmenazas;


  FUNCTION consultarAmenazasParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR 
  IS
    result_consultarAmenazasParque SYS_REFCURSOR;
  BEGIN
    OPEN result_consultarAmenazasParque FOR
      SELECT *
      FROM AMENAZAS A
      JOIN AMENAZAS_POR_PARQUE AP ON A.CODIGO = AP.CODIGO_AMENAZA
      JOIN PARQUES_NATURALES PN ON AP.CODIGO_PARQUE = PN.CODIGO
      WHERE PN.NOMBRE = xnombre_parque;

    RETURN result_consultarAmenazasParque;
  END consultarAmenazasParque;


END PK_AMENAZAS;
/

-- CRUDE PERSONA
create or replace PACKAGE PK_PERSONA AS
-- Adulto
-- Cuando se crea un adulto tambien se crea la persona
  PROCEDURE adultoRegister(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2,xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2);

  PROCEDURE adultoUpdate(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2, xid_usuario VARCHAR2,xdocumento_identificacion VARCHAR2, xgenero VARCHAR2, xtipo_documento VARCHAR2 );


  PROCEDURE adultoDelete(xid_usuario VARCHAR2);

-- Ninio

  PROCEDURE ninioRegister(xresponsable VARCHAR2, xrh VARCHAR2, xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2, xestatura NUMBER,xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2);

  PROCEDURE ninioDelete(xid_usuario VARCHAR2);

  PROCEDURE ninioUpdate(xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2,xid_usuario VARCHAR2, xdocumento_identidad VARCHAR2, xgenero VARCHAR2,xtipo_documento VARCHAR2);

-- consultas

  FUNCTION personaConsultar(xid_usuario VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarReservasporUsuario(xid_usuario VARCHAR2) 
    RETURN SYS_REFCURSOR;

END PK_PERSONA;
/

-- CRUDI PERSONA
create or replace PACKAGE BODY PK_PERSONA AS
  --ADULTO

  PROCEDURE adultoRegister(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2, xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2) IS
   v_id_usuario VARCHAR2(50);
BEGIN
  INSERT INTO PERSONAS(ID_USUARIO, NOMBRE, FECHA_NACIMIENTO, GENERO, DOCUMENTO_IDENTIFICACION, TIPO_DOCUMENTO)
  VALUES(NULL, xnombre, xfecha_nacimiento, xgenero,xdocumento_identificacion, xtipo_documento)
  RETURNING ID_USUARIO INTO v_id_usuario;

  IF MONTHS_BETWEEN(SYSDATE, xfecha_nacimiento) < 216 THEN
    RAISE_APPLICATION_ERROR(-20001, 'La persona debe ser mayor de 18 anios.');
  END IF;

  IF MONTHS_BETWEEN(SYSDATE, xfecha_nacimiento) > 216 THEN
    INSERT INTO ADULTOS(ID_USUARIO, PAIS_RESIDENCIA, CONTACTO, CORREO)
    VALUES (v_id_usuario, xpais_residencia, xcontacto, xcorreo);
  END IF;


  END adultoRegister;

  PROCEDURE adultoUpdate(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2, xid_usuario VARCHAR2,xdocumento_identificacion VARCHAR2, xgenero VARCHAR2, xtipo_documento VARCHAR2 ) AS 
    BEGIN 
    UPDATE ADULTOS SET PAIS_RESIDENCIA = xpais_residencia, CONTACTO = xcontacto, CORREO = xcorreo  WHERE ID_USUARIO = xid_usuario;
    UPDATE PERSONAS SET DOCUMENTO_IDENTIFICACION = xdocumento_identificacion, GENERO = xgenero, tipo_documento = xtipo_documento WHERE  ID_USUARIO = xid_usuario;
  END adultoUpdate;



  PROCEDURE adultoDelete(xid_usuario VARCHAR2) AS 
    BEGIN 
    DELETE FROM ADULTOS
    WHERE ID_USUARIO = xid_usuario;
    DELETE FROM PERSONAS
    WHERE ID_USUARIO = xid_usuario;
  END  adultoDelete;

-- Ninio

  PROCEDURE ninioRegister(xresponsable VARCHAR2, xrh VARCHAR2, xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2, xestatura NUMBER,xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2) IS
    v_id_usuario VARCHAR2(50);
    BEGIN 
      INSERT INTO PERSONAS(ID_USUARIO, NOMBRE, FECHA_NACIMIENTO, GENERO, DOCUMENTO_IDENTIFICACION, TIPO_DOCUMENTO)
      VALUES(NULL, xnombre, xfecha_nacimiento, xgenero,xdocumento_identificacion, xtipo_documento)
      RETURNING ID_USUARIO INTO v_id_usuario;

  IF MONTHS_BETWEEN(SYSDATE, xfecha_nacimiento) > 216 THEN
    RAISE_APPLICATION_ERROR(-20001, 'La persona debe ser menor de 18 aÃ±os.');
  END IF;
  IF MONTHS_BETWEEN(SYSDATE, xfecha_nacimiento) < 216 THEN
   INSERT INTO NINIOS(ID_USUARIO, RESPONSABLE, RH, CARNET_VACUNAS,ESTATURA, CONSENTIMIENTO) VALUES(v_id_usuario, xresponsable, xrh, xcarnet_vacunas, xestatura, xconsentimiento);
  END IF;
  END ninioRegister;



  PROCEDURE ninioDelete(xid_usuario VARCHAR2) AS 
    BEGIN 
    DELETE FROM NINIOS WHERE ID_USUARIO = xid_usuario;
    DELETE FROM PERSONAS WHERE ID_USUARIO = xid_usuario;  
  END ninioDelete;

 PROCEDURE ninioUpdate(xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2,xid_usuario VARCHAR2, xdocumento_identidad VARCHAR2, xgenero VARCHAR2,xtipo_documento VARCHAR2) AS 
    BEGIN 
    UPDATE NINIOS SET CARNET_VACUNAS = xcarnet_vacunas, CONSENTIMIENTO = xconsentimiento WHERE ID_USUARIO = xid_usuario;
   UPDATE PERSONAS SET DOCUMENTO_IDENTIFICACION = xdocumento_identidad, GENERO = xgenero, TIPO_DOCUMENTO = xtipo_documento WHERE  ID_USUARIO = xid_usuario;
    END ninioUpdate;

-- consultas

  FUNCTION personaConsultar(xid_usuario VARCHAR2) 
    RETURN SYS_REFCURSOR
  IS result_personaConsultar SYS_REFCURSOR;
    BEGIN 
    OPEN result_personaConsultar FOR 
    SELECT * FROM PERSONAS JOIN ADULTOS ON ADULTOS.ID_USUARIO = PERSONAS.ID_USUARIO
    WHERE PERSONAS.ID_USUARIO = xid_usuario;
    RETURN result_personaConsultar;
    END personaConsultar;


  FUNCTION consultarReservasporUsuario(xid_usuario VARCHAR2) 
    RETURN SYS_REFCURSOR
    IS result_consultarReservasporUsuario SYS_REFCURSOR;
    BEGIN 
      OPEN result_consultarReservasporUsuario 
      FOR SELECT * FROM RESERVAS WHERE ID_ADULTO = xid_usuario;
    RETURN result_consultarReservasporUsuario;
    END consultarReservasporUsuario;

END pk_persona;
/

/*
-- CRUDNoOK
BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'Cualquier Cosa','NOMBRE PARQUE',3,5,3,5,100,'ESTADO');
END parqueRegister;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'ABIERTO','NOMBRE PARQUE',3,-5,3,-5,100,'ESTADO');
END parqueRegister;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'CERRADO','NOMBRE PARQUE',3,-5,3,-5,100,'ESTADO');
END parqueRegister;

BEGIN PK_AMENAZAS.amenazaRegister('CUALQUIER COSA','CUALQUIER COSA',SYSDATE,'1');
END amenazaRegister;

BEGIN PK_PARQUE_NATURAL.actividadRegister('DESCRIPCION','CUALQUIER COSA','1');
END actividadRegister;

BEGIN PK_PARQUE_NATURAL.equiporegister('CUALQUIER COSA','1');
END equipoRegister;

BEGIN PK_RESERVA.reservaInsertar('1','1','-5',SYSDATE,SYSDATE);
END reservaInsertar;

BEGIN PK_PERSONA.adultoRegister('COLOMBIA','3125981241','prueba@gmail.com','John Doe',SYSDATE,'CUALQUIER COSA','310818298','CUALQUIER COSA');
END adultoRegister;

BEGIN PK_PERSONA.ninioRegister('1','CUALQUIER COSA','vacunas.pdf','consentimiento.pdf',1.23,'PRUEBA',SYSDATE,'HOMBRE','1029387744','CC');
END ninioRegister;

BEGIN PK_PERSONA.ninioRegister('1','A+','vacunas.doc','consentimiento.pdf',1.23,'PRUEBA',SYSDATE,'HOMBRE','1029387744','CC');
END ninioRegister;

BEGIN PK_PERSONA.ninioRegister('1','A+','vacunas.pdf','consentimiento.doc',1.23,'PRUEBA',SYSDATE,'HOMBRE','1029387744','CC');
END ninioRegister;

BEGIN PK_PERSONA.ninioRegister('1','A+','vacunas.pdf','consentimiento.pdf',1.23,'PRUEBA',SYSDATE,'CUALQUIER COSA','1029387744','CC');
END ninioRegister;

BEGIN PK_PERSONA.ninioRegister('1','A+','vacunas.pdf','consentimiento.pdf',1.23,'PRUEBA',SYSDATE,'HOMBRE','1029387744','CUALQUIER COSA');
END ninioRegister;

BEGIN PK_PARQUE_NATURAL.ubicacionRegister(-3.21,5.56,100);
END ubicacionRegister;

BEGIN PK_PUBLICACION.publicacionInsertar('1','TITULO',SYSDATE,'RESUMEN','TURISMO SOSTENIBLE','ENLACE','TIPO','AUTOR');
END publicacionInsertar;

BEGIN PK_PUBLICACION.publicacionInsertar('1','TITULO',SYSDATE,'RESUMEN','TURISMO SOSTENIBLE','https://www.youtube.com','ARTICULO DE REVISTA CIENTIFICA','AUTOR');
END publicacionInsertar;

BEGIN PK_PUBLICACION.publicacionInsertar('1','TITULO',SYSDATE,'RESUMEN','PALABRA','https://www.youtube.com','TIPO','AUTOR');
END publicacionInsertar;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'CUALQUIER COSA','NOMBRE PARQUE',20,30,5.34,4.23,100,'ESTADO');
END parqueRegister;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'ABIERTO','NOMBRE PARQUE',-20,30,5.34,4.23,100,'ESTADO');
END parqueRegister;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'ABIERTO','NOMBRE PARQUE',20,-30,5.34,4.23,100,'ESTADO');
END parqueRegister;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'ABIERTO','NOMBRE PARQUE',20,30,-5.34,4.23,100,'ESTADO');
END parqueRegister;

BEGIN PK_PARQUE_NATURAL.parqueRegister(SYSDATE,SYSDATE,5,'ABIERTO','NOMBRE PARQUE',20,30,5.34,4.23,-100,'ESTADO');
END parqueRegister;

BEGIN PK_AMENAZAS.impactoRegister('1','DESCRIPCION','CUALQUIER COSA');
END impactoRregister;
*/