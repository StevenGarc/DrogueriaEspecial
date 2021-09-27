import csv
import os

def ejecutar():
    path_inventarios = '/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/Inventarios'
    path_consolidado = '/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/inventario_consolidado/'
    archivos = listar_csv(path_inventarios)
    fecha = archivos[0].split('-')[1]
    path_consolidado = path_consolidado + 'consolidado-'+fecha+'.csv'
    columnas = ['CodProducto', 'Nombre', 
                'ContenidoInternoCaja', 'ContenidoInternoBlister', 'ContenidoInternoUnidad', 
                'ValorCajaContado', 'ValorBlisterContado', 'ValorUnidadContado', 
                'InventarioCaja', 'InventarioBlister', 'InventarioUnidad']
    consolidado = {}
    print(archivos)
    for archivo in archivos:
        inventario = leer_csv(path_inventarios+"/"+archivo, columnas)
        for producto in inventario:
            if producto['CodProducto'] in consolidado:
                inventario_aux = sumar_inventarios(consolidado[producto['CodProducto']], producto)
                precio_aux = conciliar_precios(inventario_aux, producto)
                consolidado[producto['CodProducto']] = precio_aux
            else:
                consolidado.update({producto['CodProducto']: producto})
    for k, v in consolidado.items():
        print(k, v)


    guardar_csv(consolidado.values(), columnas, path_consolidado)


    

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
    with open(path, newline='', encoding='latin-1') as File:  
        reader = csv.reader(File, delimiter=';')
        for row in reader:
            if row == [] or row[0]=='': return list_data
            aux={}
            for i in range(len(columnas)):
                aux[columnas[i]]=row[i].strip()
            list_data.append(aux)
            cont+=1
    return list_data

def listar_csv(path):
    archivos = os.listdir(path)
    return archivos

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




