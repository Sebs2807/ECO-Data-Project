--XSEGURIDAD

REVOKE EXECUTE ON pc_administrador FROM ADMINISTRADOR_ECO;
DROP ROLE ADMINISTRADOR_ECO;
REVOKE EXECUTE ON pc_encargado FROM ENCARGADO_ECO;
DROP ROLE ENCARGADO_ECO;
REVOKE EXECUTE ON pc_JUNTA_DIRECTIVA FROM JUNTA_DIRECTIVA_ECO;
DROP ROLE JUNTA_DIRECTIVA_ECO;
REVOKE EXECUTE ON PK_USUARIO FROM USUARIO_ECO;
DROP ROLE USUARIO_ECO;
REVOKE EXECUTE ON pc_INVESTIGADOR FROM INVESTIGADOR_ECO;
DROP ROLE INVESTIGADOR_ECO;

DROP PACKAGE pc_administrador;
DROP PACKAGE pc_ENCARGADO;
DROP PACKAGE pc_JUNTA_DIRECTIVA;
DROP PACKAGE PK_USUARIO;
DROP PACKAGE pc_INVESTIGADOR;
DROP PACKAGE PC_ENTIDAD;


--ActoresE Administrador
create or replace PACKAGE PC_ADMINISTRADOR AS 
    PROCEDURE parqueRegister(xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xestadoParque VARCHAR2, xnombre VARCHAR2, xvalor_ingresoninos NUMBER, xvalor_ingresoadultos NUMBER,latitud NUMBER, longitud NUMBER, tamano NUMBER,xestado VARCHAR);

    PROCEDURE parqueUpdate(xcodigo VARCHAR2, xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xvalor_ingreso_ninos NUMBER, xvalor_ingreso_adultos NUMBER, xestado VARCHAR2);

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
    PROCEDURE actividadRegister(xdescripcion_actividad VARCHAR2, xtipo_de_actividad VARCHAR2, xid_parque VARCHAR2);

    PROCEDURE actividadDelete(xid VARCHAR2);

    PROCEDURE actividadUpdate(xid VARCHAR2, xdescripcion_actividad VARCHAR2);

    -- Equipo
    PROCEDURE equipoRegister(xnombre_equipo VARCHAR2, xid_actividad VARCHAR2);

    PROCEDURE equipoUpdate(xid VARCHAR2, xnombre_equipo VARCHAR2);

    PROCEDURE equipoDelete(xid VARCHAR2);

    FUNCTION parqueConsultar(xnombre_parque VARCHAR2) 
      RETURN SYS_REFCURSOR;

    PROCEDURE reservaModificar(xnumero VARCHAR2, xfecha_reservacion DATE, xfecha_fin DATE);

    PROCEDURE reservaEliminar(xnumero VARCHAR2);
END PC_ADMINISTRADOR;
/
  
--ActoresI Administrador
create or replace PACKAGE BODY PC_ADMINISTRADOR AS 

  PROCEDURE parqueRegister(xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xestadoParque VARCHAR2, xnombre VARCHAR2, xvalor_ingresoninos NUMBER, xvalor_ingresoadultos NUMBER, latitud NUMBER, longitud NUMBER, tamano NUMBER, xestado VARCHAR) IS
  BEGIN
    PK_PARQUE_NATURAL.parqueRegister(xhoraApertura, xhoraCierre, xcantTrabajadores, xestadoParque, xnombre, xvalor_ingresoninos, xvalor_ingresoadultos, latitud, longitud, tamano,xestado);
  END parqueRegister;

  PROCEDURE parqueUpdate(xcodigo VARCHAR2, xhoraApertura DATE, xhoraCierre DATE, xcantTrabajadores NUMBER, xvalor_ingreso_ninos NUMBER, xvalor_ingreso_adultos NUMBER, xestado VARCHAR2) IS 
  BEGIN  
    PK_PARQUE_NATURAL.parqueUpdate(xcodigo, xhoraApertura, xhoraCierre, xcantTrabajadores, xvalor_ingreso_ninos, xvalor_ingreso_adultos,xestado);
  END parqueUpdate;

  -- Ecosistema
  PROCEDURE ecosistemaRegister(xcodigo_parque VARCHAR2, xnombre_ecosistema VARCHAR2, xclima VARCHAR2) IS 
  BEGIN
    PK_PARQUE_NATURAL.ecosistemaRegister(xcodigo_parque, xnombre_ecosistema, xclima);
  END ecosistemaRegister;

  PROCEDURE ecosistemaDelete(xcodigo VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.ecosistemaDelete(xcodigo);
  END ecosistemaDelete;

  PROCEDURE ecosistemaUpdate(xcodigo VARCHAR2, xclima VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.ecosistemaUpdate(xcodigo, xclima);
  END ecosistemaUpdate;

  -- Especie Planta
  PROCEDURE especiePlantaRegister(xnombre_cientifico VARCHAR2, xcodigo_ecosistema VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.especiePlantaRegister(xnombre_cientifico, xcodigo_ecosistema, xnombre_comun);
  END especiePlantaRegister;

  PROCEDURE especiePlantaDelete(xid VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.especiePlantaDelete(xid);
  END especiePlantaDelete;

  PROCEDURE especiePlantaUpdate(xid VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.especiePlantaUpdate(xid, xnombre_comun);
  END especiePlantaUpdate;

  -- Especie Animal
  PROCEDURE especieAnimalRegister(xnombre_cientifico VARCHAR2, xcodigo_ecosistema VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.especieAnimalRegister(xnombre_cientifico, xcodigo_ecosistema, xnombre_comun);
  END especieAnimalRegister;

  PROCEDURE especieAnimalDelete(xid VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.especieAnimalDelete(xid);
  END especieAnimalDelete;

  PROCEDURE especieAnimalUpdate(xid VARCHAR2, xnombre_comun VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.especieAnimalUpdate(xid, xnombre_comun);
  END especieAnimalUpdate;

  -- Ubicacion
  PROCEDURE ubicacionRegister(xlatitud NUMBER, xlongitud NUMBER, xtamano NUMBER) IS
  BEGIN
    PK_PARQUE_NATURAL.ubicacionRegister(xlatitud, xlongitud, xtamano);
  END ubicacionRegister;

  -- Pais
  PROCEDURE paisRegister(xnombre VARCHAR2, xlatitud NUMBER, xlongitud NUMBER) IS
  BEGIN
   PK_PARQUE_NATURAL.paisRegister(xnombre, xlatitud, xlongitud);
  END paisRegister;

  -- Departamento
  PROCEDURE departamentoRegister(xnombre VARCHAR2, xlatitud NUMBER, xlongitud NUMBER) IS
  BEGIN
    PK_PARQUE_NATURAL.departamentoRegister(xnombre, xlatitud, xlongitud);
  END departamentoRegister;

  -- Contacto
  PROCEDURE contactoParqueRegister(xcontacto VARCHAR2, xcodigo_parque VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.contactoParqueRegister(xcontacto, xcodigo_parque);
  END contactoParqueRegister;

  PROCEDURE contactoParqueUpdate(xcontacto VARCHAR2, xnuevoContacto VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.contactoParqueUpdate(xcontacto, xnuevoContacto);
  END contactoParqueUpdate;

  PROCEDURE contactoDelete(xcontacto VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.contactoDelete(xcontacto);
  END contactoDelete;

  -- Actividad
  PROCEDURE actividadRegister(xdescripcion_actividad VARCHAR2, xtipo_de_actividad VARCHAR2, xid_parque VARCHAR2) IS
  BEGIN 
    PK_PARQUE_NATURAL.actividadRegister(xdescripcion_actividad, xtipo_de_actividad, xid_parque);
  END actividadRegister;

  PROCEDURE actividadDelete(xid VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.actividadDelete(xid);
  END actividadDelete;

  PROCEDURE actividadUpdate(xid VARCHAR2, xdescripcion_actividad VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.actividadUpdate(xid, xdescripcion_actividad);
  END actividadUpdate;

  -- Equipo
  PROCEDURE equipoRegister(xnombre_equipo VARCHAR2, xid_actividad VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.equipoRegister(xnombre_equipo, xid_actividad);
  END equipoRegister;

  PROCEDURE equipoUpdate(xid VARCHAR2, xnombre_equipo VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.equipoUpdate(xid, xnombre_equipo);
  END equipoUpdate;

  PROCEDURE equipoDelete(xid VARCHAR2) IS
  BEGIN
    PK_PARQUE_NATURAL.equipoDelete(xid);
  END equipoDelete;

  FUNCTION parqueConsultar(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR 
  IS result_parqueConsultar SYS_REFCURSOR;
  BEGIN 
    OPEN result_parqueConsultar FOR 
    SELECT * FROM PARQUES_NATURALES WHERE nombre = xnombre_parque;
    RETURN result_parqueConsultar;
  END parqueConsultar;

  PROCEDURE reservaModificar(xnumero VARCHAR2, xfecha_reservacion DATE, xfecha_fin DATE) IS
  BEGIN
    PK_RESERVA.reservaModificar(xnumero,xfecha_reservacion,xfecha_fin);
  END reservaModificar;

  PROCEDURE reservaEliminar(xnumero VARCHAR2) IS
  BEGIN
    PK_RESERVA.reservaEliminar(xnumero);
  END reservaEliminar;
END PC_ADMINISTRADOR;
/

--ActoresE Encargado

create or replace PACKAGE PC_ENCARGADO AS

  PROCEDURE reservaActualizacion(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2);

  PROCEDURE reservaPagada(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2); 

  PROCEDURE servicioInsertar(xid_actividad VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2, xresponsables VARCHAR2, xmayor_de_edad NUMBER,  xprecio_persona NUMBER, xprecio_dia NUMBER);

  PROCEDURE servicioEliminar(xid VARCHAR2);

  PROCEDURE servicioActualizar(xid VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2, xresponsable VARCHAR2, xmayor_de_edad NUMBER, xprecio_persona NUMBER, xprecio_dia NUMBER);

  PROCEDURE reservaEliminar(xnumero VARCHAR2);

  FUNCTION consultarServicios(xid VARCHAR2)
    RETURN SYS_REFCURSOR;
END PC_ENCARGADO;
/


-- ActoresI Encargado
create or replace PACKAGE BODY PC_ENCARGADO AS

  PROCEDURE reservaActualizacion(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2) IS
  BEGIN
    pk_reserva.reservaActualizacion(xnumero, xpagado, xestado);
  END reservaActualizacion;

  PROCEDURE reservaPagada(xnumero VARCHAR2, xpagado NUMBER, xestado VARCHAR2) IS
  BEGIN
    pk_reserva.reservaPagada(xnumero, xpagado, xestado);
  END reservaPagada;

  PROCEDURE servicioInsertar(xid_actividad VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2,xresponsables VARCHAR2, xmayor_de_edad NUMBER, xprecio_persona NUMBER, xprecio_dia NUMBER) IS
  BEGIN
    pk_reserva.servicioInsertar(xid_actividad, xdescripcion, xtipo_servicio, xresponsables,xmayor_de_edad, xprecio_dia, xprecio_persona);
  END servicioInsertar;

  PROCEDURE servicioEliminar(xid VARCHAR2) IS
  BEGIN
    pk_reserva.servicioEliminar(xid);
  END servicioEliminar;

  PROCEDURE servicioActualizar(xid VARCHAR2, xdescripcion VARCHAR2, xtipo_servicio VARCHAR2,xresponsable VARCHAR2, xmayor_de_edad NUMBER, xprecio_persona NUMBER, xprecio_dia NUMBER) IS
  BEGIN
    pk_reserva.servicioActualizar(xid, xdescripcion, xtipo_servicio,xresponsable,xmayor_de_edad, xprecio_persona, xprecio_dia);
  END servicioActualizar;

  PROCEDURE reservaEliminar(xnumero VARCHAR2) IS
  BEGIN
    pk_reserva.reservaEliminar(xnumero);
  END reservaEliminar;

  FUNCTION servicioConsultar(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_servicio_consultar SYS_REFCURSOR;
  BEGIN
    OPEN c_servicio_consultar FOR
      SELECT * FROM VServiciosParque
      WHERE NOMBRE_PARQUE = xnombre_parque;
    RETURN c_servicio_consultar;
  END servicioConsultar;

    FUNCTION consultarServicios(xid VARCHAR2) RETURN SYS_REFCURSOR IS
        c_consultar_servicios SYS_REFCURSOR;
      BEGIN
        OPEN c_consultar_servicios FOR SELECT * FROM SERVICIOS WHERE ID = xid;
        RETURN c_consultar_servicios;
      END consultarServicios;

END PC_ENCARGADO;
/

-- ActoresE Junta Directiva
create or replace PACKAGE PC_JUNTA_DIRECTIVA AS
  FUNCTION servicioMasSolicitado(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;
  FUNCTION consultarDinero(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;
  FUNCTION consultarTotalReservasPorParque(xid_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;
  FUNCTION consultarReservasRechazadas(xnombre_parque VARCHAR2)          
    RETURN SYS_REFCURSOR; 
  FUNCTION consultarEstadoAmenazas 
    RETURN SYS_REFCURSOR;
END PC_JUNTA_DIRECTIVA;
/

-- ActoresI Junta Directiva
create or replace PACKAGE BODY PC_JUNTA_DIRECTIVA AS 
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

  FUNCTION consultarReservasRechazadas(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_reservas_rechazadas SYS_REFCURSOR;
  BEGIN
    OPEN c_reservas_rechazadas FOR SELECT * FROM VRechazadasParque WHERE NOMBRE_PARQUE = xnombre_parque AND estado = 'RECHAZADA';
    RETURN c_reservas_rechazadas;
  END consultarReservasRechazadas;

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

END PC_JUNTA_DIRECTIVA;
/

-- ActoresE Entidad
create or replace PACKAGE PC_ENTIDAD AS 
  PROCEDURE amenazaRegister(xgravedad VARCHAR2, xtipo VARCHAR2, xfecha_mitigacion DATE,xid_parque VARCHAR2);

  PROCEDURE amenazaUpdate(xcodigo VARCHAR2, xestado VARCHAR2, xfecha_mitigacion DATE);

  -- Impacto
  PROCEDURE impactoRegister(xcodigo_amenaza VARCHAR2, xdescripcion VARCHAR2, xseveridad VARCHAR2);

  PROCEDURE impactoUpdate(xcodigo_amenaza VARCHAR2, xaccion_mitigacion VARCHAR2);

  -- Especie Afectada
  PROCEDURE especieAfectadaRegister(xcodigo_amenaza VARCHAR2, xnombre_especie VARCHAR2);

  FUNCTION amenazaConsulta(xcodigo VARCHAR2) 
    RETURN SYS_REFCURSOR;
  FUNCTION impactoConsultar(xcodigo_amenaza VARCHAR2) 
    RETURN SYS_REFCURSOR;
  FUNCTION especieAfectadaConsultar(xcodigo_amenaza VARCHAR2) 
    RETURN SYS_REFCURSOR;  

END PC_ENTIDAD;
/

-- ActoresI Entidad
create or replace PACKAGE BODY PC_ENTIDAD AS

  PROCEDURE amenazaRegister(xgravedad VARCHAR2, xtipo VARCHAR2, xfecha_mitigacion DATE, xid_parque VARCHAR2) IS
  BEGIN
    PK_AMENAZAS.amenazaRegister(xgravedad, xtipo, xfecha_mitigacion, xid_parque);
  END amenazaRegister;

  PROCEDURE amenazaUpdate(xcodigo VARCHAR2, xestado VARCHAR2, xfecha_mitigacion DATE) IS
  BEGIN
    PK_AMENAZAS.amenazaUpdate(xcodigo, xestado, xfecha_mitigacion);
  END amenazaUpdate;

  PROCEDURE impactoRegister(xcodigo_amenaza VARCHAR2, xdescripcion VARCHAR2, xseveridad VARCHAR2) IS
  BEGIN
    PK_AMENAZAS.impactoRegister(xcodigo_amenaza, xdescripcion, xseveridad);
  END impactoRegister;

  PROCEDURE impactoUpdate(xcodigo_amenaza VARCHAR2, xaccion_mitigacion VARCHAR2) IS
  BEGIN
    PK_AMENAZAS.impactoUpdate(xcodigo_amenaza, xaccion_mitigacion);
  END impactoUpdate;

  PROCEDURE especieAfectadaRegister(xcodigo_amenaza VARCHAR2, xnombre_especie VARCHAR2) IS
  BEGIN
    PK_AMENAZAS.especieAfectadaRegister(xcodigo_amenaza, xnombre_especie);
  END especieAfectadaRegister;

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

END PC_ENTIDAD;
/

-- ActoresE Investigador
create or replace PACKAGE PC_INVESTIGADOR AS
  PROCEDURE publicacionInsertar(xcodigo_parque VARCHAR2,xtitulo VARCHAR2,xfecha_Publicacion DATE,xresumen VARCHAR2,xpalabra_clave VARCHAR2,xenlace VARCHAR2,xtipo_publicacion VARCHAR2,xautor VARCHAR2);

  PROCEDURE publicacionEliminar(xid VARCHAR2);

  PROCEDURE publicacionModificar(xid VARCHAR2,xtitulo VARCHAR2,xresumen VARCHAR2,xpalabra_clave VARCHAR2,xenlace VARCHAR2);

  PROCEDURE publicacionConsultar(xtitulo VARCHAR2);

  FUNCTION consultarPublicacionPorParque(xnombre_parque VARCHAR2)
    RETURN SYS_REFCURSOR;

  FUNCTION consultarPublicacionFiltradaPorPalabraClave(xnombre_parque VARCHAR2,xpalabra_clave VARCHAR2)
    RETURN SYS_REFCURSOR;  -- Vista
  FUNCTION consultarMayorGravedad 
    RETURN SYS_REFCURSOR;

  FUNCTION especieAfectadaConsultar(xcodigo_amenaza VARCHAR2) 
    RETURN SYS_REFCURSOR;
  FUNCTION parqueConsultar(xcodigo_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarClimaPredominante(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR; -- vista

  FUNCTION consultarAnimalPorParque(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

  FUNCTION consultarPlantaPorParque(xnombre_parque VARCHAR2)
      RETURN SYS_REFCURSOR;


  FUNCTION consultarEcosistemaPorParque(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR;

END PC_INVESTIGADOR;
/

-- ActoresI Investigador
create or replace PACKAGE BODY PC_INVESTIGADOR AS
  PROCEDURE publicacionInsertar(xcodigo_parque VARCHAR2, xtitulo VARCHAR2, xfecha_Publicacion DATE, xresumen VARCHAR2, xpalabra_clave VARCHAR2, xenlace VARCHAR2, xtipo_publicacion VARCHAR2, xautor VARCHAR2) IS
  BEGIN
    PK_PUBLICACION.publicacionInsertar(xcodigo_parque, xtitulo, xfecha_Publicacion, xresumen, xpalabra_clave, xenlace, xtipo_publicacion, xautor);
  END publicacionInsertar;

  PROCEDURE publicacionEliminar(xid VARCHAR2) IS
  BEGIN
    PK_PUBLICACION.publicacionEliminar(xid);
  END publicacionEliminar;

  PROCEDURE publicacionModificar(xid VARCHAR2, xtitulo VARCHAR2, xresumen VARCHAR2, xpalabra_clave VARCHAR2, xenlace VARCHAR2) IS
  BEGIN
    PK_PUBLICACION.publicacionModificar(xid, xtitulo, xresumen, xpalabra_clave, xenlace);
  END publicacionModificar;

  PROCEDURE publicacionConsultar(xtitulo VARCHAR2) IS
  BEGIN
    PK_PUBLICACION.publicacionConsultar(xtitulo);
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


  FUNCTION parqueConsultar(xcodigo_parque VARCHAR2) 
  RETURN SYS_REFCURSOR 
  IS result_parqueConsultar SYS_REFCURSOR;
  BEGIN 
    OPEN result_parqueConsultar FOR 
    SELECT * FROM PARQUES_NATURALES WHERE CODIGO = xcodigo_parque;
    RETURN result_parqueConsultar;
  END parqueConsultar;

  FUNCTION consultarClimaPredominante(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR
    IS result_climaPredominante SYS_REFCURSOR;
    BEGIN
      OPEN result_climaPredominante FOR
      SELECT * FROM VClimaPredominante
      WHERE nombre_parque = xnombre_parque;
      RETURN result_climaPredominante;
    END consultarClimaPredominante;

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


  FUNCTION consultarEcosistemaPorParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR -- vista
  IS result_ecosistemaPorParque SYS_REFCURSOR;
  BEGIN 
    OPEN result_ecosistemaPorParque FOR
    SELECT * FROM VEcosistemaParque 
    WHERE nombre_parque = xnombre_parque;
    RETURN result_ecosistemaPorParque;
  END consultarEcosistemaPorParque;


END PC_INVESTIGADOR;
/

-- ActoresE Usuario
create or replace PACKAGE PK_USUARIO AS
  -- crear reserva
  PROCEDURE crearReserva(xid_servicio VARCHAR2, xid_adulto VARCHAR2, xcantidad_personas NUMBER, xfecha_asistencia DATE, xfecha_fin DATE);

  PROCEDURE reservaModificar(xnumero VARCHAR2, xfecha_reservacion DATE,xfecha_fin DATE);

  PROCEDURE reservaEliminar(xnumero VARCHAR2);
-- Adulto
-- cuando se crea un adulto tambien se crea la persona
  PROCEDURE adultoRegister(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2,xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2);

  PROCEDURE adultoUpdate(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2, xid_usuario VARCHAR2,xdocumento_identificacion VARCHAR2, xgenero VARCHAR2, xtipo_documento VARCHAR2 );


  PROCEDURE adultoDelete(xid_usuario VARCHAR2);

-- Ninio

  PROCEDURE ninioRegister(xresponsable VARCHAR2, xrh VARCHAR2, xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2, xestatura NUMBER,xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2);

  PROCEDURE ninioDelete(xid_usuario VARCHAR2);

  PROCEDURE ninioUpdate(xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2,xid_usuario VARCHAR2, xdocumento_identidad VARCHAR2, xgenero VARCHAR2,xtipo_documento VARCHAR2);

FUNCTION parqueConsultar(xcodigo_parque VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarEcosistemaPorParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarServicios(xid VARCHAR2) RETURN SYS_REFCURSOR;

FUNCTION servicioConsultar(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR;

FUNCTION consultarActividades(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION reservaConsultar(xid_adulto VARCHAR2) RETURN SYS_REFCURSOR;

FUNCTION consultarAmenazasParque(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR;

PROCEDURE publicacionConsultar(xtitulo VARCHAR2);

FUNCTION consultarPublicacionPorParque(xnombre_parque VARCHAR2)
  RETURN SYS_REFCURSOR;

FUNCTION consultarPublicacionFiltradaPorPalabraClave(xnombre_parque VARCHAR2,xpalabra_clave VARCHAR2)
  RETURN SYS_REFCURSOR;  -- Vista

FUNCTION personaConsultar(xid_usuario VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarReservasporUsuario(xdocumento_identificacion VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarParqueEnPais(xnombre_pais VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarClimaPredominante(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR; -- vista

FUNCTION consultarParqueEnDepartamento(xnombre_departamento VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarParqueActividad(xactividad VARCHAR2)
  RETURN SYS_REFCURSOR;

FUNCTION consultarParqueEcosistema(xecosistema VARCHAR2)
  RETURN SYS_REFCURSOR;

FUNCTION consultarServicioIdParque(xid_actividad VARCHAR2,xcodigo_parque VARCHAR2) 
  RETURN SYS_REFCURSOR;

FUNCTION consultarParqueActividadPais(xactividad VARCHAR2,xpais VARCHAR2)
  RETURN SYS_REFCURSOR;

END PK_USUARIO;
/
create or replace PACKAGE BODY PK_USUARIO AS

  PROCEDURE crearReserva(xid_servicio VARCHAR2, xid_adulto VARCHAR2, xcantidad_personas NUMBER, xfecha_asistencia DATE, xfecha_fin DATE) IS
  BEGIN 
      PK_RESERVA.reservaInsertar(xid_servicio, xid_adulto, xcantidad_personas, xfecha_asistencia, xfecha_fin);

  END crearReserva;

  PROCEDURE reservaModificar(xnumero VARCHAR2, xfecha_reservacion DATE,xfecha_fin DATE) IS
  BEGIN
    PK_RESERVA.reservaModificar(xnumero, xfecha_reservacion, xfecha_fin);

  END reservaModificar;

  PROCEDURE reservaEliminar(xnumero VARCHAR2) IS
  BEGIN 
    PK_RESERVA.reservaEliminar(xnumero);
  END reservaEliminar;

  PROCEDURE adultoRegister(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2, xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2) IS
  BEGIN
    PK_PERSONA.adultoRegister(xpais_residencia, xcontacto, xcorreo, xnombre, xfecha_nacimiento, xgenero, xdocumento_identificacion, xtipo_documento);
  END adultoRegister;

  PROCEDURE adultoUpdate(xpais_residencia VARCHAR2, xcontacto VARCHAR2, xcorreo VARCHAR2, xid_usuario VARCHAR2, xdocumento_identificacion VARCHAR2, xgenero VARCHAR2, xtipo_documento VARCHAR2) IS
  BEGIN
    PK_PERSONA.adultoUpdate(xpais_residencia, xcontacto, xcorreo, xid_usuario, xdocumento_identificacion, xgenero, xtipo_documento);
  END adultoUpdate;

  PROCEDURE adultoDelete(xid_usuario VARCHAR2) IS
  BEGIN
    PK_PERSONA.adultoDelete(xid_usuario);
  END adultoDelete;

  PROCEDURE ninioRegister(xresponsable VARCHAR2, xrh VARCHAR2, xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2, xestatura NUMBER, xnombre VARCHAR2, xfecha_nacimiento DATE, xgenero VARCHAR2, xdocumento_identificacion VARCHAR2, xtipo_documento VARCHAR2) IS
  BEGIN
    PK_PERSONA.ninioRegister(xresponsable, xrh, xcarnet_vacunas, xconsentimiento, xestatura, xnombre, xfecha_nacimiento, xgenero, xdocumento_identificacion, xtipo_documento);
  END ninioRegister;

  PROCEDURE ninioDelete(xid_usuario VARCHAR2) IS
  BEGIN
    PK_PERSONA.ninioDelete(xid_usuario);
  END ninioDelete;

  PROCEDURE ninioUpdate(xcarnet_vacunas VARCHAR2, xconsentimiento VARCHAR2, xid_usuario VARCHAR2, xdocumento_identidad VARCHAR2, xgenero VARCHAR2, xtipo_documento VARCHAR2) IS
  BEGIN
    PK_PERSONA.ninioUpdate(xcarnet_vacunas, xconsentimiento, xid_usuario, xdocumento_identidad, xgenero, xtipo_documento);
  END ninioUpdate;


  FUNCTION consultarClimaPredominante(xnombre_parque VARCHAR2) 
    RETURN SYS_REFCURSOR
    IS result_climaPredominante SYS_REFCURSOR;
    BEGIN
      OPEN result_climaPredominante FOR
      SELECT * FROM VClimaPredominante
      WHERE nombre_parque = xnombre_parque;
      RETURN result_climaPredominante;
    END consultarClimaPredominante;


FUNCTION consultarActividades(xnombre_parque VARCHAR2) 
  RETURN SYS_REFCURSOR --vista
  IS result_consultarActividades SYS_REFCURSOR;
  BEGIN 
    OPEN result_consultarActividades FOR
    SELECT * FROM VActividadPorParque 
    WHERE nombre_parque = xnombre_parque;
    RETURN result_consultarActividades;
  END consultarActividades;

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

FUNCTION servicioConsultar(xnombre_parque VARCHAR2) RETURN SYS_REFCURSOR IS
  c_servicio_consultar SYS_REFCURSOR;
BEGIN
  OPEN c_servicio_consultar FOR
    SELECT * FROM VServiciosParque
    WHERE NOMBRE_PARQUE = xnombre_parque;
  RETURN c_servicio_consultar;
END servicioConsultar;

FUNCTION reservaConsultar(xid_adulto VARCHAR2) RETURN SYS_REFCURSOR IS
  c_reserva_consultar SYS_REFCURSOR;
BEGIN
  OPEN c_reserva_consultar FOR
    SELECT * FROM RESERVAS WHERE ID_ADULTO = xid_adulto;
  RETURN c_reserva_consultar;
END reservaConsultar;

FUNCTION consultarAmenazasParque(xnombre_parque VARCHAR2) 
RETURN SYS_REFCURSOR 
IS
  result_consultarAmenazasParque SYS_REFCURSOR;
BEGIN
  OPEN result_consultarAmenazasParque FOR
    SELECT ap.CODIGO_PARQUE,pn.NOMBRE AS NOMBRE_PARQUE,ap.CODIGO_AMENAZA,a.ESTADO AS ESTADO_AMENAZA,a.GRAVEDAD AS GRAVEDAD_AMENAZA,a.TIPO AS TIPO_AMENAZA
    FROM AMENAZAS A
    INNER JOIN AMENAZAS_POR_PARQUE AP ON A.CODIGO = AP.CODIGO_AMENAZA
    INNER JOIN PARQUES_NATURALES PN ON AP.CODIGO_PARQUE = PN.CODIGO
    WHERE PN.NOMBRE = xnombre_parque;

  RETURN result_consultarAmenazasParque;
END consultarAmenazasParque;


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


FUNCTION personaConsultar(xid_usuario VARCHAR2) 
  RETURN SYS_REFCURSOR
IS result_personaConsultar SYS_REFCURSOR;
  BEGIN 
  OPEN result_personaConsultar FOR 
  SELECT * FROM PERSONAS JOIN ADULTOS ON ADULTOS.ID_USUARIO = PERSONAS.ID_USUARIO
  WHERE PERSONAS.ID_USUARIO = xid_usuario;
  RETURN result_personaConsultar;
  END personaConsultar;


FUNCTION consultarReservasporUsuario(xdocumento_identificacion VARCHAR2) 
  RETURN SYS_REFCURSOR
  IS result_consultarReservasporUsuario SYS_REFCURSOR;
  BEGIN 
    OPEN result_consultarReservasporUsuario 
    FOR SELECT * FROM RESERVAS 
    JOIN PERSONAS ON (ID_ADULTO = ID_USUARIO) 
    WHERE DOCUMENTO_IDENTIFICACION = xdocumento_identificacion;
  RETURN result_consultarReservasporUsuario;
  END consultarReservasporUsuario;

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

FUNCTION consultarServicios(xid VARCHAR2) RETURN SYS_REFCURSOR IS
    c_consultar_servicios SYS_REFCURSOR;
    BEGIN
        OPEN c_consultar_servicios FOR SELECT * FROM SERVICIOS WHERE ID = xid;
        RETURN c_consultar_servicios;
    END consultarServicios;

FUNCTION consultarParqueActividad(xactividad VARCHAR2) RETURN SYS_REFCURSOR IS 
    result_consultarParqueActividad SYS_REFCURSOR;
    BEGIN 
        OPEN result_consultarParqueActividad FOR 
        SELECT * FROM VParquePorActividad 
        WHERE tipo_de_actividad = xactividad;
        RETURN result_consultarParqueActividad;
    END consultarParqueActividad;

FUNCTION consultarParqueEcosistema(xecosistema VARCHAR2) RETURN SYS_REFCURSOR IS 
    result_consultarParqueEcosistema SYS_REFCURSOR;
    BEGIN 
      OPEN result_consultarParqueEcosistema FOR
      SELECT * FROM VEcosistemaParque
      WHERE nombre_ecosistema = xecosistema;
      RETURN result_consultarParqueEcosistema;
    END consultarParqueEcosistema;

FUNCTION consultarServicioIdParque(xid_actividad VARCHAR2,xcodigo_parque VARCHAR2) RETURN SYS_REFCURSOR IS
    c_id_servicio SYS_REFCURSOR;
    BEGIN 
        OPEN c_id_servicio FOR
        SELECT * FROM VServiciosParque
        WHERE xcodigo_parque = codigo_parque AND xid_actividad = id_actividad;
        RETURN c_id_servicio;
    END consultarServicioIdParque;

FUNCTION consultarParqueActividadPais(xactividad VARCHAR2, xpais VARCHAR2) RETURN SYS_REFCURSOR IS 
    result_consultarParqueActividadPais SYS_REFCURSOR;
  BEGIN 
    OPEN result_consultarParqueActividadPais FOR 
    SELECT codigo_parque,nombre_parque,id_actividad,tipo_de_actividad,nombre_pais,nombre_departamento FROM VParquePorActividad 
    WHERE tipo_de_actividad = xactividad AND nombre_pais = xpais;
    RETURN result_consultarParqueActividadPais;
END consultarParqueActividadPais;
END PK_USUARIO;
/


-- SEGURIDAD 
  CREATE ROLE ADMINISTRADOR_ECO
  NOT IDENTIFIED;
  -- Asiganmos los metodos del paquete
  GRANT EXECUTE ON pc_administrador TO ADMINISTRADOR_ECO;
  --Nos asiganmos el rol de usuario
  --GRANT ADMINISTRADOR_ECO TO BD1000096696;

  CREATE ROLE ENCARGADO_ECO
  NOT IDENTIFIED;
  -- Asiganmos los metodos del paquete 
  GRANT EXECUTE ON pc_encargado TO ENCARGADO_ECO;
  --Nos asiganmos el rol de usuario
  --GRANT ENCARGADO_ECO TO BD1000096696;

  CREATE ROLE JUNTA_DIRECTIVA_ECO
  NOT IDENTIFIED;
  -- Asiganmos los metodos del paquete 
  GRANT EXECUTE ON pc_JUNTA_DIRECTIVA TO JUNTA_DIRECTIVA_ECO;
  --Nos asiganmos el rol de usuario
  --GRANT JUNTA_DIRECTIVA_ECO TO BD1000096696;

  CREATE ROLE USUARIO_ECO
  NOT IDENTIFIED;
  -- Asiganmos los metodos del paquete 
  GRANT EXECUTE ON PK_USUARIO TO USUARIO_ECO;
  --Nos asiganmos el rol de usuario
  --GRANT USUARIO_ECO TO BD1000096696;

  CREATE ROLE INVESTIGADOR_ECO
  NOT IDENTIFIED;
  -- Asiganmos los metodos del paquete 
  GRANT EXECUTE ON pc_INVESTIGADOR TO INVESTIGADOR_ECO;
  --Nos asiganmos el rol de usuario
  --GRANT INVESTIGADOR_ECO TO BD1000096696;

/*
Actores OK

begin
    PK_PERSONA.adultoRegister('Colombia', '3123589553', 'correo@mail.com', 'Camilo Quintero', TO_DATE('15-11-2000', 'DD-MM-YYYY'), 'HOMBRE', '1031801790', 'CC');
end;
/


VAR printeo REFCURSOR;
BEGIN 
  :printeo := bd1000091167.PK_USUARIO.consultarParqueActividadPais('OBSERVACION AVES', 'Colombia');
END;
/
PRINT printeo;


VAR printeo REFCURSOR;
BEGIN 
  :printeo := PK_REERVA.servicioConsultar(Parque Nacional Natural Amacayacu);
END;
/
PRINT printeo;
*/