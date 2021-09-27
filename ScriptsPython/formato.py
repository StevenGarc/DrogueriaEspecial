import csv
# input_file="DatosTienda2.csv"
input_file = "/tmp/Consolidado.csv"
ouput_file = "prueba.csv"


Cont = 0
Columnas = ["ID", "Tipo", "SKU", "Nombre", "Publicado", "¿Está destacado?",
            "Visibilidad en el catálogo", "Descripción corta", "Descripción",
            "Día en que empieza el precio rebajado", "Día en que termina el precio rebajado",
            "Estado del impuesto", "Clase de impuesto", "¿En inventario?", "Inventario",
            "Cantidad de bajo inventario", "¿Permitir reservas de productos agotados?",
            "¿Vendido individualmente?", "Peso (kg)", "Longitud (cm)", "Anchura (cm)",
            "Altura (cm)", "¿Permitir valoraciones de clientes?", "Nota de compra",
            "Precio rebajado", "Precio normal", "Categorías", "Etiquetas",
            "Clase de envío", "Imágenes", "Límite de descargas", "Días de caducidad de la descarga",
            "Superior", "Productos agrupados", "Ventas dirigidas", "Ventas cruzadas",
            "URL externa", "Texto del botón", "Posición", "Nombre del atributo 1",
            "Valor(es) del atributo 1", "Atributo visible 1", "Atributo global 1"]
dict_data = []
list_codigos = []
with open(input_file, newline='', encoding="utf-8") as File:
    reader = csv.reader(File, delimiter=';')
    for row in reader:
        print(row)
        datos_producto = {
            "CodProducto": row[0],
            "Nombre": row[1],
            "ContenidoInternoCaja": row[2],
            "ContenidoInternoBlister": row[3],
            "ContenidoInternoUnidad": row[4],
            "ValorCajaContado": row[5],
            "ValorBlisterContado": row[6],
            "ValorUnidadContado": row[7],
            "InventarioCaja": row[8],
            "InventarioBlister": row[9],
            "InventarioUnidad": row[10],
            "Drogueria": row[11]
        }
        while datos_producto["CodProducto"] in list_codigos:
            datos_producto["CodProducto"] = datos_producto["Drogueria"] + \
                datos_producto["CodProducto"]
        list_codigos.append(datos_producto["CodProducto"])

        variaciones = (int(datos_producto["InventarioCaja"]) > 0) + (int(
            datos_producto["InventarioBlister"]) > 0) + (int(datos_producto["InventarioUnidad"]) > 0)
        print('cantidad de varicaiones ' + str(variaciones))
        if variaciones > 1:
            print("producto Variable " + datos_producto["CodProducto"])
            producto_csv = {
                "Tipo": "variable",
                "SKU": datos_producto["CodProducto"],
                "Nombre": datos_producto["Nombre"],
                "Publicado": 1,
                "Visibilidad en el catálogo": "visible",
                "¿En inventario?": 1,
                "Nombre del atributo 1": "Presentacion",
                "Valor(es) del atributo 1": "Caja, Blister, Unidad",
            }
            dict_data.append(producto_csv)

            if int(datos_producto["InventarioCaja"]) > 0:
                variacion_caja = {
                    "Tipo": "variation",
                    "SKU": datos_producto["CodProducto"]+"-Caja",
                    "Nombre": datos_producto["Nombre"]+" - Caja",
                    "Superior": datos_producto["CodProducto"],
                    "Publicado": 1,
                    "Posición": 1,
                    "Visibilidad en el catálogo": "visible",
                    "¿En inventario?": 1,
                    "Nombre del atributo 1": "Presentacion",
                    "Valor(es) del atributo 1": "Caja",
                    "Inventario": datos_producto["InventarioCaja"],
                    "Precio normal": datos_producto["ValorCajaContado"]
                }
                dict_data.append(variacion_caja)

            if int(datos_producto["InventarioBlister"]) > 0:
                variacion_blister = {
                    "Tipo": "variation",
                    "SKU": datos_producto["CodProducto"]+"-Blister",
                    "Nombre": datos_producto["Nombre"]+" - Blister",
                    "Superior": datos_producto["CodProducto"],
                    "Publicado": 1,
                    "Posición": 1,
                    "Visibilidad en el catálogo": "visible",
                    "¿En inventario?": 1,
                    "Nombre del atributo 1": "Presentacion",
                    "Valor(es) del atributo 1": "Blister",
                    "Inventario": datos_producto["InventarioBlister"],
                    "Precio normal": datos_producto["ValorBlisterContado"]
                }
                dict_data.append(variacion_blister)

            if int(datos_producto["InventarioUnidad"]) > 0:
                variacion_unidad = {
                    "Tipo": "variation",
                    "SKU": datos_producto["CodProducto"]+"-Unidad",
                    "Nombre": datos_producto["Nombre"]+" - Unidad",
                    "Superior": datos_producto["CodProducto"],
                    "Publicado": 1,
                    "Posición": 1,
                    "Visibilidad en el catálogo": "visible",
                    "¿En inventario?": 1,
                    "Nombre del atributo 1": "Presentacion",
                    "Valor(es) del atributo 1": "Unidad",
                    "Inventario": datos_producto["InventarioUnidad"],
                    "Precio normal": datos_producto["ValorUnidadContado"]
                }
                dict_data.append(variacion_unidad)

        else:
            print("producto Simple " + datos_producto["CodProducto"])
            if int(datos_producto["InventarioCaja"]) > 0:
                inentario = datos_producto["InventarioCaja"]
                valor = datos_producto["ValorCajaContado"]
            if int(datos_producto["InventarioBlister"]) > 0:
                inentario = datos_producto["InventarioBlister"]
                valor = datos_producto["ValorBlisterContado"]
            if int(datos_producto["InventarioUnidad"]) > 0:
                inentario = datos_producto["InventarioUnidad"]
                valor = datos_producto["ValorUnidadContado"]

            producto_csv = {
                "Tipo": "simple",
                "SKU": datos_producto["CodProducto"],
                "Nombre": datos_producto["Nombre"],
                "Publicado": 1,
                "Visibilidad en el catálogo": "visible",
                "¿En inventario?": 1,
                "Inventario": inentario,
                "Precio normal": valor
            }
            dict_data.append(producto_csv)

try:
    with open(ouput_file, 'w', newline='', encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=Columnas, delimiter=',')
        writer.writeheader()
        for data in dict_data:
            writer.writerow(data)
except IOError:
    print("I/O error")

print("Writing complete")
