
set sql_mode=ORACLE;
DELIMITER //
DROP PROCEDURE IF EXISTS generar_consolidado //
CREATE PROCEDURE generar_consolidado AS 

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