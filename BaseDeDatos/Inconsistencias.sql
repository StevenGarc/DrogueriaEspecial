--Listar los mas vendido por drogueria
\! rm -f /tmp/test-query.csv
SELECT i.CodProducto,m.drogueria, m.Nombre
  FROM Mas_vendidos m, inventario_completo i 
 WHERE m.Nombre = i.Nombre
   and m.drogueria=i.drogueria
   
  into outfile '/tmp/test-query.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';


\! rm -f /tmp/test-query.csv
SELECT 'Codigo', 'Nombre 1', 'Nombre 2', 'Drogueria 1','Drogueria 2'
UNION ALL
 SELECT i.CodProducto, i.Nombre, m.Nombre, i.drogueria, m.drogueria   
   FROM Mas_vendidos m, inventario_completo i   
  WHERE (m.Nombre like i.Nombre) or i.Nombre like concat('%', m.Nombre, '%'))
    and m.drogueria=i.drogueria
   into outfile '/tmp/test-query.csv'
 FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n';


/* Un producto es consistente cuando cumple las siguientes condiciones:
        - Los codigos son consistentes en las tres droguerias. Un codigo se considera consistente cuando:
            - Los codigos con iguales.
            - Los codigos son diferentes pero son codigos de barras pertenecientes al mismo producto.
        - Su Nombre  es igual en las tres droguerias.
        - Su costo para cada presentacion es similar en las tres droguerias con una variacion no mayor al porcentaje definido por la gerencia  
        - Las cantidades para cada presentacion coinciden
        - La categorizacion de los productos coinciden.
*/

\! rm -f /tmp/Mas_vendidos_consistentes.csv
DELIMITER //
DROP PROCEDURE IF EXISTS generar_mas_vendidos_consistentes //
CREATE PROCEDURE generar_mas_vendidos_consistentes ()
BEGIN
   DECLARE por_procesar int;
   DECLARE coincidencias INT;

   DECLARE V_Drogueria varchar(12);
   DECLARE V_Nombre varchar(100);
   DECLARE finished INTEGER DEFAULT FALSE;
   DECLARE c_mas_vendidos CURSOR FOR SELECT drogueria, Nombre 
                                       FROM Mas_vendidos_tmp 
                                       where procesado='N'
                                       limit 0,1; 
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

   DECLARE V_CodPoducto varchar(20);
   DECLARE V_Nombre_P varchar(100);
   DECLARE c_consistentes_tmp CURSOR FOR SELECT CodPoducto, Nombre
                                           FROM consistentes_tmp
                                          where procesado='N'
                                          limit 0,1;

   delete from Mas_vendidos_tmp;
   delete from interfaz_wc;
   INSERT INTO Mas_vendidos_tmp
   SELECT drogueria, Nombre, 'N' FROM Mas_vendidos;

   simple_loop: LOOP
      
      SELECT count(*) Into por_procesar from Mas_vendidos_tmp WHERE procesado = 'N';

      IF por_procesar = 0 THEN
         LEAVE simple_loop;
      END IF;

      OPEN c_mas_vendidos;
         FETCH c_mas_vendidos INTO V_Drogueria, V_Nombre;
      CLOSE c_mas_vendidos;
      /* Buscar todos los productos de la tabla inventario_completo que coincida con el nombre 
         y para todos los productos consistentes insertarlo en la tabla consistentes_tmp */
      DELETE FROM consistentes_tmp;
      INSERT INTO consistentes_tmp
      SELECT 
         CodProducto,
         Nombre,
         Ubicacion,
         Costo,
         ContenidoIntCaja,
         ContenidoIntBlister,
         ContenidoIntUnidad,
         Iva,
         InventarioCaja,
         InventarioBlister,
         InventarioUnidad,
         CostoCaja,
         CostoBlister,
         CostoUnidad,
         ValorIvaCaja,
         ValorIvaBlister,
         ValorIvaUnidad,
         CostoTotal,
         CostoTotalIva,
         VentaTotal,
         CodigoBarras,
         PrecioUnidad,
         PrecioCaja ,
         PrecioBlister ,
         IdProducto,
         'N'
      FROM inventario_completo
      WHERE Nombre=V_Nombre;
      
      SELECT COUNT(*) INTO coincidencias  FROM consistentes_tmp group by NOMBRE;
      SELECT coincidencias;

      IF coincidencias > 1 THEN
         
         simple_loop2: LOOP

            SELECT count(*) Into por_procesar from consistentes_tmp WHERE procesado = 'N';
            
            IF por_procesar = 0 THEN
               LEAVE simple_loop2;
            END IF;

            OPEN c_consistentes_tmp;
               FETCH c_consistentes_tmp INTO V_CodPoducto, V_Nombre_P;
            CLOSE c_consistentes_tmp;

            


            UPDATE c_consistentes_tmp set procesado = 'S' WHERE Nombre = V_Nombre_P and CodPoducto = V_CodPoducto;

         END simple_loop2


      END IF;


      UPDATE Mas_vendidos_tmp set procesado = 'S' WHERE Nombre = V_Nombre and drogueria = V_Drogueria;

   END LOOP simple_loop;

END//
DELIMITER ;

call generar_mas_vendidos_consistentes();

into outfile '/tmp/Mas_vendidos_consistentes.csv' 
   FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n';

------------------------------------------------------------------
set sql_mode=ORACLE;
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_wc //
CREATE PROCEDURE insertar_wc(r_consistentes_tmp consistentes_tmp%RowType) AS 

BEGIN
   INSERT INTO interfaz_wc(
      ID ,
      Tipo ,
      SKU ,
      Nombre ,
      Publicado ,
      Destacado ,
      Visible_catalogo ,
      Descripcion_corta ,
      Descripcion ,
      empieza_precio_rebajado ,
      termina_precio_rebajado ,
      Estado_impuesto ,
      Clase_impuesto ,
      En_inventario ,
      Inventario ,
      Cantidad_inventario ,
      Permitir_reservas_agotados ,
      Vendido_individualmente ,
      Peso ,
      Longitud ,
      Anchura ,
      Altura ,
      Permitir_valoraciones_clientes ,
      Nota_compra ,
      Precio_rebajado ,
      Precio_normal ,
      Categorias ,
      Etiquetas ,
      Clase_envio ,
      Imagenes ,
      Limite_descargas ,
      Dias_caducidad_descarga ,
      Superior ,
      Productos_agrupados ,
      Ventas_dirigidas ,
      Ventas_cruzadas ,
      URL_externa ,
      Texto_botón ,
      Posicion ,
      Nombre_atributo1 ,
      Valores_atributo1 ,
      Atributo1_visible ,
      Atributo1_global 
   ) values(
      r_consistentes_tmp.
   )
END;
//
DELIMITER ;

------------------------------------------------

set sql_mode=ORACLE;
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_consolidado //
CREATE PROCEDURE insertar_consolidado(r_consistentes_tmp consistentes_tmp%RowType) AS 

BEGIN
   INSERT INTO consolidado(
      drogueria ,
      fecha ,
      CodProducto ,
      Nombre ,
      Presentacion ,
      Laboratorio ,
      Ubicacion ,
      Exento  ,
      Excluido ,
      NoGravado ,
      Gravado ,
      Costo ,
      ContenidoIntCaja  ,
      ContenidoIntBlister ,
      ContenidoIntUnidad ,
      Iva ,
      InventarioCaja ,
      InventarioBlister ,
      InventarioUnidad ,
      CostoCaja ,
      CostoBlister ,
      CostoUnidad ,
      ValorIvaCaja ,
      ValorIvaBlister ,
      ValorIvaUnidad ,
      CostoTotal ,
      CostoTotalIva ,
      VentaTotal ,
      Sucursal ,
      CodigoBarras ,
      PrecioUnidad ,
      PrecioCaja ,
      PrecioBlister ,
      IdProducto
   ) values(
      r_consistentes_tmp.drogueria ,
      r_consistentes_tmp.fecha ,
      r_consistentes_tmp.CodProducto ,
      r_consistentes_tmp.Nombre ,
      r_consistentes_tmp.Presentacion ,
      r_consistentes_tmp.Laboratorio ,
      r_consistentes_tmp.Ubicacion ,
      r_consistentes_tmp.Exento  ,
      r_consistentes_tmp.Excluido ,
      r_consistentes_tmp.NoGravado ,
      r_consistentes_tmp.Gravado ,
      r_consistentes_tmp.Costo ,
      r_consistentes_tmp.ContenidoIntCaja  ,
      r_consistentes_tmp.ContenidoIntBlister ,
      r_consistentes_tmp.ContenidoIntUnidad ,
      r_consistentes_tmp.Iva ,
      r_consistentes_tmp.InventarioCaja ,
      r_consistentes_tmp.InventarioBlister ,
      r_consistentes_tmp.InventarioUnidad ,
      r_consistentes_tmp.CostoCaja ,
      r_consistentes_tmp.CostoBlister ,
      r_consistentes_tmp.CostoUnidad ,
      r_consistentes_tmp.ValorIvaCaja ,
      r_consistentes_tmp.ValorIvaBlister ,
      r_consistentes_tmp.ValorIvaUnidad ,
      r_consistentes_tmp.CostoTotal ,
      r_consistentes_tmp.CostoTotalIva ,
      r_consistentes_tmp.VentaTotal ,
      r_consistentes_tmp.Sucursal ,
      r_consistentes_tmp.CodigoBarras ,
      r_consistentes_tmp.PrecioUnidad ,
      r_consistentes_tmp.PrecioCaja ,
      r_consistentes_tmp.PrecioBlister ,
      r_consistentes_tmp.IdProducto
   );
END
//
DELIMITER ;
------------------------------------------------
set sql_mode=ORACLE;

DELIMITER //
DROP FUNCTION IF EXISTS es_codigo_consistente //
CREATE FUNCTION es_codigo_consistente(r_consistentes_tmp consistentes_tmp%RowType, r_consolidado consolidado%rowtype) RETURN INTEGER AS
   consistente INTEGER DEFAULT FALSE;
   r_Codigo_barras Codigo_barras%rowtype;
   CURSOR c_Codigo_barras IS SELECT * 
                               FROM Codigo_barras 
                              WHERE drogueria = r_consistentes_tmp.drogueria 
                                AND fecha = r_consistentes_tmp.fecha
                                AND IdProducto = r_consistentes_tmp.IdProducto;

   r2_Codigo_barras Codigo_barras%rowtype;
   CURSOR c2_Codigo_barras IS SELECT * 
                               FROM Codigo_barras 
                              WHERE drogueria = r_consolidado.drogueria 
                                AND fecha = r_consolidado.fecha
                                AND IdProducto = r_consolidado.IdProducto;
                                
BEGIN
   IF r_consistentes_tmp.CodProducto = r_consolidado.CodProducto THEN
      RETURN TRUE;
   ELSE
      FOR r_Codigo_barras IN c_Codigo_barras LOOP
         IF r_consolidado.CodProducto = r_Codigo_barras.CodigoBarras THEN
            RETURN TRUE;
         END IF;
      END LOOP;

      FOR r2_Codigo_barras IN c2_Codigo_barras LOOP
         IF r_consistentes_tmp.CodProducto = r2_Codigo_barras.CodigoBarras THEN
            RETURN TRUE;
         END IF;
      END LOOP;

   END IF;
   RETURN FALSE;
END
//
DELIMITER ;


-----------------------------------------


set sql_mode=ORACLE;

DELIMITER //
DROP FUNCTION IF EXISTS es_consistente //
CREATE FUNCTION es_consistente(r_consistentes_tmp consistentes_tmp%RowType) RETURN varchar AS
   ID_rec varchar(10) :='N';
   es_consistente varchar(1);
   Porcentaje_diferente_costo DOUBLE DEFAULT 0.1;
   r_consolidado consolidado%rowtype;
   CURSOR c_consolidado (v_nombre varchar(100)) IS SELECT * 
                                              FROM consolidado
                                             WHERE Nombre = v_nombre;
BEGIN
   FOR r_consolidado IN c_consolidado(r_consistentes_tmp.Nombre) LOOP
      es_consistente:= 'S';
      /* Validar contenido */
      IF (r_consolidado.ContenidoIntCaja > 0 AND r_consistentes_tmp.ContenidoIntCaja > 0) AND 
         (r_consolidado.ContenidoIntCaja != r_consistentes_tmp.ContenidoIntCaja) THEN
         es_consistente:= 'N';
      END IF;

      IF (r_consolidado.ContenidoIntBlister > 0 AND r_consistentes_tmp.ContenidoIntBlister > 0) AND 
         (r_consolidado.ContenidoIntBlister != r_consistentes_tmp.ContenidoIntBlister) THEN
         es_consistente:= 'N';
      END IF;

      IF (r_consolidado.ContenidoIntUnidad > 0 AND r_consistentes_tmp.ContenidoIntUnidad > 0) AND 
         (r_consolidado.ContenidoIntUnidad != r_consistentes_tmp.ContenidoIntUnidad) THEN
         es_consistente:= 'N';
      END IF;

      /* Validar costo */
      IF (r_consolidado.CostoCaja > 0 AND r_consistentes_tmp.CostoCaja > 0) AND
         (NOT r_consolidado.CostoCaja between r_consistentes_tmp.CostoCaja*(1-Porcentaje_diferente_costo) 
         AND r_consistentes_tmp.CostoCaja*(1+Porcentaje_diferente_costo)) THEN
         es_consistente:= 'N';
      END IF;

      IF (r_consolidado.CostoBlister > 0 AND r_consistentes_tmp.CostoBlister > 0) AND
         (NOT r_consolidado.CostoBlister between r_consistentes_tmp.CostoBlister*(1-Porcentaje_diferente_costo) 
         AND r_consistentes_tmp.CostoBlister*(1+Porcentaje_diferente_costo)) THEN
         es_consistente:= 'N';
      END IF;

      IF (r_consolidado.CostoUnidad > 0 AND r_consistentes_tmp.CostoUnidad > 0) AND
         (NOT r_consolidado.CostoUnidad between r_consistentes_tmp.CostoUnidad*(1-Porcentaje_diferente_costo) 
         AND r_consistentes_tmp.CostoUnidad*(1+Porcentaje_diferente_costo)) THEN
         es_consistente:= 'N';
      END IF;


      IF r_consolidado.Ubicacion = r_consistentes_tmp.Ubicacion AND 
         r_consolidado.Presentacion = r_consistentes_tmp.Presentacion AND
         es_codigo_consistente(r_consistentes_tmp, r_consolidado) THEN
            ID_rec := r_consolidado.ID_rec;
      END IF;
      IF es_consistente = 'S' THEN
         ID_rec := r_consolidado.ID_rec;
         RETURN ID_rec;
      END IF;
   END LOOP;

   RETURN ID_rec;
END
//
DELIMITER ;

------------------------------------------------

set sql_mode=ORACLE;
DELIMITER //
DROP PROCEDURE IF EXISTS actualiza_consolidado //
CREATE PROCEDURE actualiza_consolidado (r_consistentes_tmp consistentes_tmp%rowtype, id_c varchar ) AS 
   I_caja INT;
   I_blister INT;
   I_unidad INT;
   r_consolidado consolidado%rowtype;
   CURSOR c_consolidado IS SELECT * 
                           FROM consolidado 
                           WHERE ID_rec = id_c;
   

BEGIN
   FOR r_consolidado in c_consolidado LOOP
      I_caja := r_consistentes_tmp.InventarioCaja + r_consolidado.InventarioCaja;
      I_blister := r_consistentes_tmp.InventarioBlister + r_consolidado.InventarioBlister;
      I_unidad := r_consistentes_tmp.InventarioUnidad + r_consolidado.InventarioUnidad;
      /*tomar el mayor costo */

      UPDATE consolidado SET
         InventarioCaja = I_caja,
         InventarioBlister = I_blister,
         InventarioUnidad = I_unidad,
         CostoCaja = GREATEST(r_consistentes_tmp.CostoCaja, consolidado.CostoCaja),
         CostoUnidad = GREATEST(r_consistentes_tmp.CostoUnidad, consolidado.CostoUnidad),
         CostoBlister = GREATEST(r_consistentes_tmp.CostoBlister, consolidado.CostoBlister)
      WHERE ID_rec = id_c;

   END LOOP;
      
END
//

DELIMITER ;

------------------------------------------------

set sql_mode=ORACLE;
DELIMITER //
DROP PROCEDURE IF EXISTS generar_interfaz_wc //
CREATE PROCEDURE generar_interfaz_wc AS 

   por_procesar INT;
   coincidencias INT;
   count_c INT;
   id_c varchar(100);

   r_Mas_vendidos_tmp Mas_vendidos_tmp%rowtype;

   CURSOR c_mas_vendidos IS SELECT *
                              FROM Mas_vendidos_tmp 
                             where procesado='N'
                             limit 0,1; 
   
   r_consistentes_tmp consistentes_tmp%rowtype;
   CURSOR c_consistentes_tmp IS SELECT *
                                  FROM consistentes_tmp
                                 where procesado='N'
                                 limit 0,1;
   
   
BEGIN
   delete from Mas_vendidos_tmp;
   ALTER TABLE Mas_vendidos_tmp AUTO_INCREMENT=1;
   delete from consolidado;
   ALTER TABLE consolidado AUTO_INCREMENT=1;
   INSERT INTO Mas_vendidos_tmp (drogueria, Nombre, procesado)
   SELECT drogueria, Nombre, 'N' FROM Mas_vendidos;

   SELECT count(*) Into por_procesar from Mas_vendidos_tmp WHERE procesado = 'N';

   WHILE por_procesar > 0 LOOP
      FOR r_Mas_vendidos_tmp in c_mas_vendidos LOOP
         /* Buscar todos los productos de la tabla inventario_completo que coincida con el nombre 
         y para todos los productos consistentes insertarlo en la tabla consistentes_tmp */
         DELETE FROM consistentes_tmp;
         ALTER TABLE consistentes_tmp AUTO_INCREMENT=1;
         INSERT INTO consistentes_tmp(
            drogueria           ,
            fecha               ,
            CodProducto         ,
            Nombre              ,
            Presentacion        ,
            Laboratorio         ,
            Ubicacion           ,
            Exento              ,
            Excluido            ,
            NoGravado           ,
            Gravado             ,
            Costo               ,
            ContenidoIntCaja    ,
            ContenidoIntBlister ,
            ContenidoIntUnidad  ,
            Iva                 ,
            InventarioCaja      ,
            InventarioBlister   ,
            InventarioUnidad    ,
            CostoCaja           ,
            CostoBlister        ,
            CostoUnidad         ,
            ValorIvaCaja        ,
            ValorIvaBlister     ,
            ValorIvaUnidad      ,
            CostoTotal          ,
            CostoTotalIva       ,
            VentaTotal          ,
            Sucursal            ,
            CodigoBarras        ,
            PrecioUnidad        ,
            PrecioCaja          ,
            PrecioBlister       ,
            IdProducto          ,
            procesado
         )
         SELECT *,'N'
           FROM inventario_completo
          WHERE Nombre=r_Mas_vendidos_tmp.Nombre;
          
         SELECT COUNT(*) INTO coincidencias  FROM consistentes_tmp WHERE procesado='N';
         WHILE coincidencias > 0 LOOP
            FOR r_consistentes_tmp in c_consistentes_tmp LOOP
               /* Si el nombre no esta en la tabla interfaz_wc se inserta */
               SELECT count(*) INTO count_c from consolidado WHERE Nombre=r_consistentes_tmp.Nombre;
               IF count_c = 0 THEN
                  insertar_consolidado(r_consistentes_tmp);
               ELSE /* Si el nombre esta en la tabla interfaz_wc se actualiza si es consistente */
                  id_c := es_consistente(r_consistentes_tmp);
                  IF id_c != 'N' THEN
                     actualiza_consolidado(r_consistentes_tmp, id_c);
                  ELSE /* Si no es consistente se inserta en la tabla interfaz_wc */
                     insertar_consolidado(r_consistentes_tmp);
                  END IF;
               END IF;
               UPDATE consistentes_tmp SET procesado='S' WHERE ID_rec = r_consistentes_tmp.ID_rec;
            END LOOP;
            SELECT COUNT(*) INTO coincidencias  FROM consistentes_tmp WHERE procesado='N';
         END LOOP;
         UPDATE Mas_vendidos_tmp SET  procesado = 'S' where ID_rec = r_Mas_vendidos_tmp.ID_rec;
      END LOOP;
      SELECT count(*) Into por_procesar from Mas_vendidos_tmp WHERE procesado = 'N';
   END LOOP;
   
END;
//
DELIMITER ; 
call generar_interfaz_wc();     


---------------------------------------------------------------------
      
      SELECT coincidencias;

      IF coincidencias > 1 THEN
         
         simple_loop2: LOOP

            SELECT count(*) Into por_procesar from consistentes_tmp WHERE procesado = 'N';
            
            IF por_procesar = 0 THEN
               LEAVE simple_loop2;
            END IF;

            OPEN c_consistentes_tmp;
               FETCH c_consistentes_tmp INTO V_CodPoducto, V_Nombre_P;
            CLOSE c_consistentes_tmp;

            


            UPDATE c_consistentes_tmp set procesado = 'S' WHERE Nombre = V_Nombre_P and CodPoducto = V_CodPoducto;

         END simple_loop2


      END IF;


      UPDATE Mas_vendidos_tmp set procesado = 'S' WHERE Nombre = V_Nombre and drogueria = V_Drogueria;

   END LOOP simple_loop;

END//
DELIMITER ;

call generar_interfaz_wc();





