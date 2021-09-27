drop database acopio;
create database acopio DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci;
use acopio
create table ingreso_inventario(
    drogueria varchar(12),
    fecha date,
    CodProducto varchar(20) ,
    Nombre varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
    ContenidoInternoCaja varchar(10),
    ContenidoInternoBlister varchar(10),
    ContenidoInternoUnidad varchar(10),
    ValorCajaContado varchar(20),
    ValorBlisterContado varchar(20),
    ValorUnidadContado varchar(20),
    InventarioCaja varchar(20),
    InventarioBlister varchar(20),
    InventarioUnidad varchar(20)
);

create index ingreso_inventario_nombre on ingreso_inventario (Nombre);
create index ingreso_inventario_CodProducto on ingreso_inventario (CodProducto);

DROP TABLE Mas_vendidos_tmp;
CREATE TABLE Mas_vendidos_tmp(
   drogueria varchar(12),
   Nombre varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
   procesado varchar(1),
   ID_rec INT not Null Auto_increment,
   primary key(ID_rec)

);

create index Mas_vendidos_tmp_i1 on Mas_vendidos_tmp(Nombre, drogueria);

create table inventario_completo(
    drogueria varchar(12),
    fecha date,
    CodProducto varchar(20),
    Nombre varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
    Presentacion varchar(20),
    Laboratorio varchar(100),
    Ubicacion varchar(100),
    Exento  varchar(20),
    Excluido varchar(20),
    NoGravado varchar(20),
    Gravado varchar(20),
    Costo varchar(20),
    ContenidoIntCaja  varchar(20),
    ContenidoIntBlister varchar(20),
    ContenidoIntUnidad varchar(20),
    Iva varchar(20),
    InventarioCaja varchar(20),
    InventarioBlister varchar(20),
    InventarioUnidad varchar(20),
    CostoCaja varchar(20),
    CostoBlister varchar(20),
    CostoUnidad varchar(20),
    ValorIvaCaja varchar(20),
    ValorIvaBlister varchar(20),
    ValorIvaUnidad varchar(20),
    CostoTotal varchar(20),
    CostoTotalIva varchar(20),
    VentaTotal varchar(20),
    Sucursal varchar(20),
    CodigoBarras varchar(20),
    PrecioUnidad varchar(20),
    PrecioCaja varchar(20),
    PrecioBlister varchar(20),
    IdProducto  varchar(20)
);


create table Codigo_barras(
  drogueria varchar(12),
  fecha date,
  IdCodigoBarras varchar(30),
  IdProducto varchar(20),
  CodigoBarras varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
  ID_Sucursal varchar(20)
);

DROP table Mas_vendidos;
create table Mas_vendidos(
  drogueria varchar(12),
  Nombre varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci
);


DROP TABLE consistentes_tmp;
create table consistentes_tmp(
    
    drogueria varchar(12),
    fecha date,
    CodProducto varchar(20),
    Nombre varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
    Presentacion varchar(20),
    Laboratorio varchar(100),
    Ubicacion varchar(100),
    Exento  varchar(20),
    Excluido varchar(20),
    NoGravado varchar(20),
    Gravado varchar(20),
    Costo varchar(20),
    ContenidoIntCaja  varchar(20),
    ContenidoIntBlister varchar(20),
    ContenidoIntUnidad varchar(20),
    Iva varchar(20),
    InventarioCaja varchar(20),
    InventarioBlister varchar(20),
    InventarioUnidad varchar(20),
    CostoCaja varchar(20),
    CostoBlister varchar(20),
    CostoUnidad varchar(20),
    ValorIvaCaja varchar(20),
    ValorIvaBlister varchar(20),
    ValorIvaUnidad varchar(20),
    CostoTotal varchar(20),
    CostoTotalIva varchar(20),
    VentaTotal varchar(20),
    Sucursal varchar(20),
    CodigoBarras varchar(20),
    PrecioUnidad varchar(20),
    PrecioCaja varchar(20),
    PrecioBlister varchar(20),
    IdProducto  varchar(20),
    procesado varchar(1),
    ID_rec INT not Null Auto_increment,
    primary key(ID_rec)
);

create table consolidado(
   drogueria varchar(12),
    fecha date,
    CodProducto varchar(20),
    Nombre varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci,
    Presentacion varchar(20),
    Laboratorio varchar(100),
    Ubicacion varchar(100),
    Exento  varchar(20),
    Excluido varchar(20),
    NoGravado varchar(20),
    Gravado varchar(20),
    Costo varchar(20),
    ContenidoIntCaja  varchar(20),
    ContenidoIntBlister varchar(20),
    ContenidoIntUnidad varchar(20),
    Iva varchar(20),
    InventarioCaja varchar(20),
    InventarioBlister varchar(20),
    InventarioUnidad varchar(20),
    CostoCaja varchar(20),
    CostoBlister varchar(20),
    CostoUnidad varchar(20),
    ValorIvaCaja varchar(20),
    ValorIvaBlister varchar(20),
    ValorIvaUnidad varchar(20),
    CostoTotal varchar(20),
    CostoTotalIva varchar(20),
    VentaTotal varchar(20),
    Sucursal varchar(20),
    CodigoBarras varchar(20),
    PrecioUnidad varchar(20),
    PrecioCaja varchar(20),
    PrecioBlister varchar(20),
    IdProducto  varchar(20),
    ID_rec INT not Null Auto_increment,
    primary key(ID_rec)

);


create table interfaz_wc(
   ID varchar(100),
   Tipo varchar(100),
   SKU varchar(100),
   Nombre varchar(100),
   Publicado varchar(100),
   Destacado varchar(100),
   Visible_catalogo varchar(100),
   Descripcion_corta varchar(100),
   Descripcion varchar(100),
   empieza_precio_rebajado varchar(100),
   termina_precio_rebajado varchar(100),
   Estado_impuesto varchar(100),
   Clase_impuesto varchar(100),
   En_inventario varchar(100),
   Inventario varchar(100),
   Cantidad_inventario varchar(100),
   Permitir_reservas_agotados varchar(100),
   Vendido_individualmente varchar(100),
   Peso varchar(100),
   Longitud varchar(100),
   Anchura varchar(100),
   Altura varchar(100),
   Permitir_valoraciones_clientes varchar(100),
   Nota_compra varchar(100),
   Precio_rebajado varchar(100),
   Precio_normal varchar(100),
   Categorias varchar(100),
   Etiquetas varchar(100),
   Clase_envio varchar(100),
   Imagenes varchar(100),
   Limite_descargas varchar(100),
   Dias_caducidad_descarga varchar(100),
   Superior varchar(100),
   Productos_agrupados varchar(100),
   Ventas_dirigidas varchar(100),
   Ventas_cruzadas varchar(100),
   URL_externa varchar(100),
   Texto_botón varchar(100),
   Posicion varchar(100),
   Nombre_atributo1 varchar(100),
   Valores_atributo1 varchar(100),
   Atributo1_visible varchar(100),
   Atributo1_global varchar(100)
);


create table siglas (
    sigla varchar(10),
    palabra varchar(30)
);
delete from siglas;
insert into siglas values ('TBS','TABLETAS');
insert into siglas values ('TAB','TABLETAS');
insert into siglas values ('JBE','JARABE');
insert into siglas values ('UDS','UNIDADES');
insert into siglas values ('UD','UNIDAD');
insert into siglas values ('SOBS','SOBRE');
insert into siglas values ('SBS','SOBRES');









DELIMITER //
CREATE FUNCTION `levenshtein`( s1 text, s2 text) RETURNS int(11)
    DETERMINISTIC
BEGIN 
    DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT; 
    DECLARE s1_char CHAR; 
    DECLARE cv0, cv1 text; 
    SET s1_len = CHAR_LENGTH(s1), s2_len = CHAR_LENGTH(s2), cv1 = 0x00, j = 1, i = 1, c = 0; 
    IF s1 = s2 THEN 
      RETURN 0; 
    ELSEIF s1_len = 0 THEN 
      RETURN s2_len; 
    ELSEIF s2_len = 0 THEN 
      RETURN s1_len; 
    ELSE 
      WHILE j <= s2_len DO 
        SET cv1 = CONCAT(cv1, UNHEX(HEX(j))), j = j + 1; 
      END WHILE; 
      WHILE i <= s1_len DO 
        SET s1_char = SUBSTRING(s1, i, 1), c = i, cv0 = UNHEX(HEX(i)), j = 1; 
        WHILE j <= s2_len DO 
          SET c = c + 1; 
          IF s1_char = SUBSTRING(s2, j, 1) THEN  
            SET cost = 0; ELSE SET cost = 1; 
          END IF; 
          SET c_temp = CONV(HEX(SUBSTRING(cv1, j, 1)), 16, 10) + cost; 
          IF c > c_temp THEN SET c = c_temp; END IF; 
            SET c_temp = CONV(HEX(SUBSTRING(cv1, j+1, 1)), 16, 10) + 1; 
            IF c > c_temp THEN  
              SET c = c_temp;  
            END IF; 
            SET cv0 = CONCAT(cv0, UNHEX(HEX(c))), j = j + 1; 
        END WHILE; 
        SET cv1 = cv0, i = i + 1; 
      END WHILE; 
    END IF; 
    RETURN c; 
  END//
  DELIMITER ;

SELECT levenshtein('BEDOYECTA 3 AMPOLLAS (M) COPI', 'OMEPRAZOL 20 MG 10  GF');




DELIMITER //
DROP FUNCTION IF EXISTS Nombre_diferente //
CREATE FUNCTION Nombre_diferente(Nombre1 varchar(100), Nombre2 varchar(100)) RETURNS varchar(100)
BEGIN
/*Retorna true si los nombres son diferentes segun las reglas establecidas
  */
  DECLARE Aux_n1 varchar(100);
  DECLARE Aux_n2 varchar(100);
  DECLARE caracteres_omitir varchar(30) DEFAULT ' .,-_()';
  DECLARE a int DEFAULT 0;
  DECLARE c varchar(1);
  DECLARE finished INTEGER DEFAULT FALSE;
  DECLARE valor_sigla varchar(10);
  DECLARE valor_palabra varchar(30);
  -- declare cursor for employee Sigla
  DECLARE curSigla CURSOR FOR SELECT Sigla,palabra FROM acopio.siglas;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;
  OPEN curSigla;
  SET Aux_n1 = Nombre1;
  SET Aux_n2 = Nombre2;
  IF (Nombre1=Nombre2) THEN
    RETURN 0;
  END IF;
  
 getSigla: LOOP
  FETCH curSigla INTO valor_sigla, valor_palabra;
  IF finished = 1 THEN 
   LEAVE getSigla;
  END IF;
  SET Aux_n1 = replace(Aux_n1, concat(' ',valor_sigla,' '), concat(' ', valor_palabra, ' '));
  SET Aux_n2 = replace(Aux_n2, concat(' ',valor_sigla,' '), concat(' ', valor_palabra, ' '));
  
  IF (Aux_n1 REGEXP concat(valor_sigla,' ','%')) THEN
    SET Aux_n1 = CONCAT(REPLACE(LEFT(Aux_n1, INSTR(Aux_n1, concat(valor_palabra,' '))), concat(valor_palabra,' '), concat(valor_sigla,' ')), SUBSTRING(Aux_n1, INSTR(Aux_n1, concat(valor_palabra,' ')) + 1));
    RETURN concat(Aux_n1,'----',Aux_n2);
  END IF;
  IF (Aux_n2 like concat( valor_sigla,' ','%')) THEN
    SET Aux_n2 = CONCAT(REPLACE(LEFT(Aux_n2, INSTR(Aux_n2, concat(valor_palabra,' '))), concat(valor_palabra,' '), concat(valor_sigla,' ')), SUBSTRING(Aux_n2, INSTR(Aux_n2, concat(valor_palabra,' ')) + 1));
  END IF;

 END LOOP getSigla;
 CLOSE curSigla;


 RETURN concat(Aux_n1,'++',Aux_n2);
    


  simple_loop: LOOP
    SET a=a+1;
    SET c=substr(caracteres_omitir, a, 1);
    SET Aux_n1 = replace(Aux_n1, c, '');
    SET Aux_n2 = replace(Aux_n2, c, '');
    IF a=length(caracteres_omitir) THEN
      LEAVE simple_loop;
    END IF;
  END LOOP simple_loop;


  IF (Aux_n1 like concat('%',Aux_n2,'%') or Aux_n2 like concat('%',Aux_n1,'%')) THEN
    RETURN 0;
  END IF;
  IF (levenshtein(Aux_n1, Aux_n2)<3) THEN
      RETURN 0;
  END IF;
  RETURN 1;
END;//
DELIMITER ;

SELECT Nombre_diferente('KETOPROFENO 100 MG 30 TABLETAS GF','KETOPROFENO 100 MG 30 TAB ');
SELECT Nombre_diferente('TABLETAS KETOPROFENO 100 MG 30 TABLETAS GF','TAB KETOPROFENO 100 MG 30 TAB ');
SELECT Nombre_diferente('TABLETAS KETOPROFENO 100 MG 30 TABLETAS GF','TBS KETOPROFENO 100 MG 30 TBS ');

SELECT a.CodProducto, a.drogueria, concat(a.Nombre, '='), b.drogueria, concat(b.Nombre,'='), Nombre_diferente(a.Nombre, b.Nombre), Nombre_diferente('KETOPROFENO 100 MG 30 TABLETAS GF','KETOPROFENO 100 MG 30 TAB')
  from ingreso_inventario a, ingreso_inventario b 
 where a.CodProducto = b.CodProducto
   and a.drogueria != b.drogueria
   and Nombre_diferente(a.Nombre, b.Nombre)=1
   and a.CodProducto='100001749' 
   and a.drogueria = 'BellaVista'
   and b.drogueria = 'La9';

select replace('KETOPROFENO 100 MG 30 TAB ' , substr(' .,-_()',1,1), '');


--Comprueba si en el nombre contiene una sigla
DELIMITER //
DROP FUNCTION IF EXISTS contiene_sigla //
CREATE FUNCTION contiene_sigla (Nombre varchar(100)) RETURNS varchar(10)
BEGIN

  DECLARE done INT DEFAULT FALSE;
  DECLARE val_sigla CHAR(10);
  DECLARE val_palabra CHAR(100);
  DECLARE cur CURSOR FOR SELECT sigla, palabra FROM acopio.siglas;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO val_sigla, val_palabra;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF Nombre LIKE concat('%',val_sigla,'%') THEN
      IF Nombre NOT LIKE concat('%',val_palabra,'%') THEN
        RETURN val_sigla;
      END IF;
    END IF;
  END LOOP read_loop;
  RETURN 'NULL';
  CLOSE cur;
END//
DELIMITER ;

SELECT contiene_sigla('ATORFIT 10 MG X 30 TBS');

SELECT Nombre FROM ingreso_inventario where contiene_sigla(Nombre) and Nombre LIKE '';
SELECT Nombre, CodProducto, contiene_sigla(Nombre)FROM ingreso_inventario where contiene_sigla(Nombre)!='NULL';

-- Cantidad de ocurrencias por sigla: 2323
Select count(1) from ingreso_inventario where nombre like '%TAB%';

-- Cantidad de ocurrencias por sigla con espacios 200
Select count(1) from ingreso_inventario where nombre like '% TAB %';

-- Cantidad de ocurrencias por sigla con espacios al inicio y seguida de punto
Select count(1) from ingreso_inventario where nombre like '% TAB.%';

-- Cantidad de ocurrencias por sigla con espacio y al final 126
Select count(1) from ingreso_inventario where nombre like '% TAB';

-- Cantidad de ocurrencias por sigla al inicio con espacio 0
Select count(1) from ingreso_inventario where nombre like 'TAB %';

-- Cantidad de ocurrencias con palabra tableta 1798
Select count(1) from ingreso_inventario where nombre like '%TABLETA%';

-- Ocurrencias de casos diferentes a los anteriores
Select distinct Nombre 
  from ingreso_inventario 
 where nombre like '%TAB%'
   and not (nombre like '% TAB %' OR  nombre like '% TAB' OR nombre like 'TAB %' OR nombre like '%TABLETA%');


-- Ocurrencias de la sigla TAB con espacios con discrepancias 78
Select distinct A.nombre, B.nombre 
  from ingreso_inventario A, ingreso_inventario B
 where A.CodProducto = B.CodProducto
   and A.Nombre != B.Nombre
   and A.Nombre Like '% TAB %'
   and B.Nombre like '%TABLETAS%';

-- Discrepancias que quedan reemplazando la sigla TAB cuando esta entre espacios 67
Select distinct replace(A.Nombre,' TAB ',' TABLETAS '), B.nombre 
  from ingreso_inventario A, ingreso_inventario B
 where A.CodProducto = B.CodProducto
   and replace(A.Nombre,' TAB ',' TABLETAS ') != B.Nombre
   and A.Nombre Like '% TAB %'
   and B.Nombre like '%TABLETAS%';

-- Contar ocurrencias de todas las siglas detectadas

Select count(1) o, 'TAB' from ingreso_inventario where nombre like '% TAB %' OR  nombre like '% TAB' OR nombre like 'TAB %' OR nombre like '% TAB.%'
Union ALL
Select count(1) o, 'TBS' from ingreso_inventario where nombre like '% TBS %' OR  nombre like '% TBS' OR nombre like 'TBS %' OR nombre like '% TBS.%'
Union ALL
Select count(1) o, 'FCO' from ingreso_inventario where nombre like '% FCO %' OR  nombre like '% FCO' OR nombre like 'FCO %' OR nombre like '% FCO.%'
Union ALL
Select count(1) o, 'UDS' from ingreso_inventario where nombre like '% UDS %' OR  nombre like '% UDS' OR nombre like 'UDS %' OR nombre like '% UDS.%'
Union ALL
Select count(1) o, 'JBE' from ingreso_inventario where nombre like '% JBE %' OR  nombre like '% JBE' OR nombre like 'JBE %' OR nombre like '% JBE.%'
Union ALL
Select count(1) o, 'UD' from ingreso_inventario where nombre like '% UD %' OR  nombre like '% UD' OR nombre like 'UD %' OR nombre like '% UD.%'
Union ALL
Select count(1) o, 'SOBS' from ingreso_inventario where nombre like '% SOBS %' OR  nombre like '% SOBS' OR nombre like 'SOBS %' OR nombre like '% SOBS.%'
Union ALL
Select count(1) o, 'SBS' from ingreso_inventario where nombre like '% SBS %' OR  nombre like '% SBS' OR nombre like 'SBS %' OR nombre like '% SBS.%';

-- Discrepancias que quedan reemplazando la sigla TAB cuando esta entre espacios 67
Select distinct replace(A.Nombre,' UDS ',' UNIDADES '), B.nombre 
  from ingreso_inventario A, ingreso_inventario B
 where A.CodProducto = B.CodProducto
   and replace(A.Nombre,' UDS ',' UNIDADES ') != B.Nombre
   and A.Nombre Like '% UDS %'
   and B.Nombre like '%UNIDADES%';


Select Nombre 'UDS' from ingreso_inventario where nombre like '% UDS %';

-- Productos con la sigla UDS al final que tienen nombre diferente mismo codigo 716
Select A.NOMBRE, B.NOMBRE
  from ingreso_inventario A, ingreso_inventario B
 where A.CodProducto = B.CodProducto
   and A.Nombre != B.Nombre
   and A.Nombre Like '% UDS';

-- Cuantos produtos se arreglan al reemplazar UDS por UNIDADES (mismo caso anterior)
Select distinct replace(A.Nombre,' UDS',' UNIDADES'), B.nombre 
  from ingreso_inventario A, ingreso_inventario B
 where A.CodProducto = B.CodProducto
   and A.Nombre Like '% UDS'
   and replace(A.Nombre,' UDS',' UNIDADES') = B.Nombre;


