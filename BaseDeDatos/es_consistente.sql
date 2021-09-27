
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
