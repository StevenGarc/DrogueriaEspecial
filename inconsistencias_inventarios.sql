-- Se generan inconsistencias de inventarios en archivos separados por drogueria
-- Misma drogueria mas de un producto con el mismo nombre
\! rm -f /tmp/val_mismo_nombre_diferente_codigo_misma_drogueria.csv
SELECT 'Drogueria','Producto','Cantidad Repetidos'
 union all 
SELECT drogueria, Nombre, count(1) 
  from ingreso_inventario 
 group by drogueria, Nombre 
having count(1)>1
  into outfile '/tmp/val_mismo_nombre_diferente_codigo_misma_drogueria.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';


-- Productos con el mismo nombre diferente codigo en diferentes droguerias
\! rm -f /tmp/val_mismo_nombre_diferente_codigo_diferente_drogueria.csv
SELECT 'Producto','Drogueria 1', 'Codigo 1', 'Drogueria 2', 'Codigo 2'
 union all 
SELECT a.Nombre, a.drogueria, a.CodProducto, b.drogueria, b.CodProducto 
  from ingreso_inventario a, ingreso_inventario b 
 where a.Nombre = b.Nombre 
   and a.drogueria != b.drogueria
   and a.CodProducto != b.CodProducto
  into outfile '/tmp/val_mismo_nombre_diferente_codigo_diferente_drogueria.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';

-- Productos con el mismo codigo diferente nombre en diferente drogueria
\! rm -f /tmp/val_mismo_codigo_diferente_nombre_diferente_drogueria.csv
SELECT 'Codigo','Drogueria 1', 'Nombre 1', 'Drogueria 2', 'Nombre 2'
 union all 
SELECT a.CodProducto, a.drogueria, a.Nombre, b.drogueria, b.Nombre 
  from ingreso_inventario a, ingreso_inventario b 
 where a.CodProducto = b.CodProducto
   and a.drogueria != b.drogueria
   and Nombre_diferente(a.Nombre, b.Nombre)=1
  into outfile '/tmp/val_mismo_codigo_diferente_nombre_diferente_drogueria.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';



-- Productos con el mismo codigo diferente nombre en diferente drogueria
\! rm -f /tmp/val_mismo_codigo_diferente_nombre_diferente_drogueria.csv
SELECT 'Codigo','Drogueria 1', 'Nombre 1', 'Drogueria 2', 'Nombre 2'
 union all 
SELECT a.CodProducto, a.drogueria, a.Nombre, b.drogueria, b.Nombre 
  from ingreso_inventario a, ingreso_inventario b 
 where a.CodProducto = b.CodProducto
   and a.drogueria != b.drogueria
   and a.Nombre != b.Nombre
  into outfile '/tmp/val_mismo_codigo_diferente_nombre_diferente_drogueria.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';


-- BellaVista=B, CiudadJardin=C
SELECT 'Codigo','BellaVista', 'CiudadJardin'
 union all 
SELECT B.CodProducto, B.Nombre, C.Nombre
  from ingreso_inventario B, ingreso_inventario C
 where a.CodProducto = b.CodProducto
   and a.drogueria != b.drogueria
   and a.Nombre != b.Nombre
  into outfile '/tmp/val_mismo_codigo_diferente_nombre_diferente_drogueria.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';

--Codigos de producto no numericos o con longitud menor a 5
\! rm -f /tmp/val_Codigos_no_numericos_y_cortos.csv 
select 'Drogueria', 'Nombre', 'Codigo'
 union all
select Drogueria, Nombre, CodProducto  
  from ingreso_inventario 
 where not CodProducto regexp '[0-9]' or 
length (CodProducto)<5
  into outfile '/tmp/val_Codigos_no_numericos_y_cortos.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';

-- productos con una variacion del precio superior al 50% entre droguerias
\! rm -f /tmp/val_variacion_precio_significativa_entre_drogueria.csv
SELECT 'Codigo','Nombre','Drogueria 1', 'Precio Caja 1', 'Precio Blister 1', 'Precio Unidad 1',
       'Drogueria 2', 'Precio Caja 2', 'Precio Blister 2', 'Precio Unidad 2'
 union all 
SELECT a.CodProducto, a.Nombre, a.drogueria, a.ValorCajaContado, a.ValorBlisterContado, a.ValorUnidadContado,
       b.drogueria, b.ValorCajaContado, b.ValorBlisterContado, b.ValorUnidadContado
  from ingreso_inventario a, ingreso_inventario b 
 where a.drogueria != b.drogueria
   and a.CodProducto = b.CodProducto
   and (((a.ValorCajaContado > 0 and b.ValorCajaContado > 0) and ((a.ValorCajaContado/b.ValorCajaContado) > 1.5 or (a.ValorCajaContado/b.ValorCajaContado) < 0.6667))
       or ((a.ValorBlisterContado > 0 and b.ValorBlisterContado > 0) and ((a.ValorBlisterContado/b.ValorBlisterContado) > 1.5 or (a.ValorBlisterContado/b.ValorBlisterContado) < 0.6667))
       or ((a.ValorUnidadContado > 0 and b.ValorUnidadContado > 0) and ((a.ValorUnidadContado/b.ValorUnidadContado) > 1.5 or (a.ValorUnidadContado/b.ValorUnidadContado) < 0.6667)))
  into outfile '/tmp/val_variacion_precio_significativa_entre_drogueria.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';



SELECT Nombre, CodProducto, contiene_sigla(Nombre)FROM ingreso_inventario where contiene_sigla(Nombre);


--Productos con Sigla en el Nombre 
\! rm -f /tmp/val_Codigos_no_numericos_y_cortos.csv 
select 'Drogueria', 'Nombre', 'Codigo', 'Sigla'
 union all
SELECT Drogueria, Nombre, CodProducto, contiene_sigla(Nombre)
  FROM ingreso_inventario 
 where contiene_sigla(Nombre) != 'NULL'
  into outfile '/tmp/val_Productos_Sigla_En_El_Nombre.csv'
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';




