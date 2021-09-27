\!rm -f /tmp/Consolidado.csv
SELECT CodProducto,
       Nombre,
       ContenidoIntCaja,
       ContenidoIntBlister,
       ContenidoIntUnidad,
       PrecioCaja,
       PrecioBlister,
       PrecioUnidad,
       InventarioCaja,
       InventarioBlister,
       InventarioUnidad,
       Drogueria
  FROM consolidado
  into outfile '/tmp/Consolidado.csv'
FIELDS TERMINATED BY ';'
 LINES TERMINATED BY '\n';


