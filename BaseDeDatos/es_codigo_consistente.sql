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
