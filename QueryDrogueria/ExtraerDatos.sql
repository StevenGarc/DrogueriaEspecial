SET NOCOUNT ON;
IF OBJECT_ID(N'Temp', N'U') IS NOT NULL  
   DROP TABLE Temp;  
GO

Create TABLE Temp (
CodProducto varchar (100),
Nombre varchar (100),
Presentacion varchar (100),
Laboratorio varchar (100),
Ubicacion varchar (100),
Exento varchar (100),
Excluido varchar (100),
NoGravado varchar (100),
Gravado varchar (100),Costo varchar (100),
ContenidoIntCaja varchar (100),
ContenidoIntBlister varchar (100),
ContenidoIntUnidad varchar (100),
Iva varchar (100),
InventarioCaja varchar (100),
InventarioBlister varchar (100),
InventarioUnidad varchar (100),
CostoCaja varchar (100),
CostoBlister varchar (100),
CostoUnidad varchar (100),
ValorIvaCaja varchar (100),
ValorIvaBlister varchar (100),
ValorIvaUnidad varchar (100),
CostoTotal varchar (100),
CostoTotalIva varchar (100),
VentaTotal varchar (100),
Sucursal varchar(100)
);

Insert Temp Exec Rep_ActualesCosteadosCostoReal @CostType=1,@Criteria=N'0',@Resumido=N'N'

alter table Temp add CodigoBarras varchar(100) 
alter table Temp add PrecioUnidad varchar(100);
alter table Temp add PrecioCaja varchar(100);
alter table Temp add PrecioBlister varchar(100);
alter table Temp add IdProducto varchar(100);


UPDATE Temp 
   SET PrecioUnidad=p.ValorUnidadContado,
       PrecioCaja =p.ValorCajaContado,
	   PrecioBlister = p.ValorBlisterContado,
	   IdProducto = p.IdProducto
 from Temp
INNER JOIN Productos p on  p.CodProducto=Temp.CodProducto;


SELECT * FROM Temp