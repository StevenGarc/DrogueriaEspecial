
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