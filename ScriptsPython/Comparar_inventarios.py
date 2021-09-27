import csv

def ejecutar():

    file_nuevos = "Crecion.csv"
    file_actualizar = "Actualizacion.csv"
    file_drogueria = "prueba_img.csv"
    file_WC = 'Inventarios_WC/wc-product-export-27-8-2021-1630085080064.csv'
    columnas = ["ID","Tipo","SKU","Nombre","Publicado","¿Está destacado?","Visibilidad en el catálogo","Descripción corta","Descripción","Día en que empieza el precio rebajado","Día en que termina el precio rebajado","Estado del impuesto","Clase de impuesto","¿En inventario?","Inventario","Cantidad de bajo inventario","¿Permitir reservas de productos agotados?","¿Vendido individualmente?","Peso (kg)","Longitud (cm)","Anchura (cm)","Altura (cm)","¿Permitir valoraciones de clientes?","Nota de compra","Precio rebajado","Precio normal","Categorías","Etiquetas","Clase de envío","Imágenes","Límite de descargas","Días de caducidad de la descarga","Superior","Productos agrupados","Ventas dirigidas","Ventas cruzadas","URL externa","Texto del botón","Posición","Nombre del atributo 1","Valor(es) del atributo 1","Atributo visible 1","Atributo global 1"]
    nuevos = []
    actualizar = []
    list_WC_data = leer_csv(file_WC, columnas)
    list_drogueria_data = leer_csv(file_drogueria, columnas)

    dict_WC_data = indexar_sku(list_WC_data)
    dict_drogueria_data = indexar_sku(list_drogueria_data)

    for SKU, data in dict_drogueria_data.items():
        if SKU in dict_WC_data:
            if verificar_cambio(data, dict_WC_data[SKU]):
                actualizar.append(data)
        else:
            nuevos.append(data)

    guardar_csv(nuevos, columnas, file_nuevos)
    guardar_csv(actualizar, columnas, file_actualizar)

def leer_csv(path, columnas):
    cont = 0
    list_data = []
    with open(path, newline='', encoding="utf-8") as File: 
        reader = csv.reader(File, delimiter=',')
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

def indexar_sku(list_data):
    dict_data = {}
    for data in list_data:
        dict_data.update({data["SKU"]: data})
    return dict_data

def verificar_cambio(producto_drogueria, producto_WC):
    atributos = ["Tipo","Nombre",
                "Publicado","Visibilidad en el catálogo",
                "Descripción corta","Descripción",
                "Día en que empieza el precio rebajado",
                "Día en que termina el precio rebajado",
                "Clase de impuesto",
                "¿En inventario?","Inventario",
                "Cantidad de bajo inventario","Peso (kg)",
                "Longitud (cm)", "Anchura (cm)","Altura (cm)",
                "Nota de compra","Precio rebajado","Precio normal",
                "Categorías","Etiquetas","Clase de envío",
                "Superior","Productos agrupados",
                "Ventas dirigidas","Ventas cruzadas",
                "URL externa","Texto del botón",
                "Nombre del atributo 1","Valor(es) del atributo 1"]

    for atributo in atributos:
        if atributo == "Precio normal": 
            producto_drogueria[atributo] = producto_drogueria[atributo].replace('.',',')
        if atributo == 'Categorías':
            if producto_drogueria[atributo] == '' and  producto_WC[atributo] !='': producto_drogueria[atributo] = 'Sin categorizar'
        if producto_drogueria[atributo].strip() != producto_WC[atributo].strip():
            return True
    return False

def guardar_csv(list_data, columnas, file_path):
    try:
        with open(file_path, 'w', newline='', encoding="utf-8") as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=columnas, delimiter=',')
            writer.writeheader()
            for data in list_data:
                writer.writerow(data)
    except IOError:
        print("I/O error")
    print("Writing complete", file_path)




ejecutar()
