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
