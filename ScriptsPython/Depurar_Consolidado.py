import csv
def ejecutar():
    path_consolidado='/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/inventario_consolidado/consolidado-31082021.csv'
    path_depurado = '/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/inventario_consolidado/depurado-31082021.csv'
    columnas = ['CodProducto', 'Nombre', 
                'ContenidoInternoCaja', 'ContenidoInternoBlister', 'ContenidoInternoUnidad', 
                'ValorCajaContado', 'ValorBlisterContado', 'ValorUnidadContado', 
                'InventarioCaja', 'InventarioBlister', 'InventarioUnidad']
    list_data = leer_csv(path_consolidado, columnas)
    dic_nombres = {}
    for producto in list_data:
        print(producto)
        if producto['Nombre'] in dic_nombres:
            inventario_aux = sumar_inventarios(dic_nombres[producto['Nombre']], producto)
            precio_aux = conciliar_precios(inventario_aux, producto)
            dic_nombres[producto['Nombre']] = precio_aux
        else:
            dic_nombres.update({producto['Nombre']: producto})
    list_nombres = dic_nombres.values()
    guardar_csv(list_nombres, columnas, path_depurado)

def conciliar_precios(consolidado, nuevo):
    presentaciones_precio = ['ValorCajaContado', 'ValorBlisterContado', 'ValorUnidadContado']
    for presentacion_precio in presentaciones_precio:
        if float(consolidado[presentacion_precio]) >= float(nuevo[presentacion_precio]):
            consolidado.update({presentacion_precio: consolidado[presentacion_precio]})
        else:
            consolidado.update({presentacion_precio: nuevo[presentacion_precio]})
    return consolidado


def sumar_inventarios(consolidado, nuevo):
    presentaciones_inventaio = ['InventarioCaja', 'InventarioBlister', 'InventarioUnidad']
    for presentacion_inventaio in presentaciones_inventaio:
        consolidado.update({presentacion_inventaio: int(consolidado[presentacion_inventaio])+int(nuevo[presentacion_inventaio])})
    return consolidado

def leer_csv(path, columnas):
    cont = 0
    list_data = []
    with open(path, newline='', encoding="utf-8") as File: 
        reader = csv.reader(File, delimiter=';')
        for row in reader:
            
            if cont == 0:
                cont+=1
            else:
                aux={}
                for i in range(len(columnas)):
                    aux[columnas[i]]=row[i]
                list_data.append(aux)
                cont+=1
    return list_data

def guardar_csv(list_data, columnas, file_path):
    try:
        with open(file_path, 'w', newline='', encoding="utf-8") as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=columnas, delimiter=';')
            writer.writeheader()
            for data in list_data:
                writer.writerow(data)
    except IOError:
        print("I/O error")
    print("Writing complete", file_path)

ejecutar()