import csv
import os


#input_file="DatosTienda2.csv"
input_file="prueba.csv"
imagenes_file = "imagenes_sku.csv" 
ouput_file="prueba_img.csv"
dir_imagenes = '/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/imagenes/'
dir_imagenes_servidor = 'http://127.0.0.1/test_woo/imagenes/'


Cont = 0
Columnas = ["ID","Tipo","SKU","Nombre","Publicado","¿Está destacado?","Visibilidad en el catálogo","Descripción corta","Descripción","Día en que empieza el precio rebajado","Día en que termina el precio rebajado","Estado del impuesto","Clase de impuesto","¿En inventario?","Inventario","Cantidad de bajo inventario","¿Permitir reservas de productos agotados?","¿Vendido individualmente?","Peso (kg)","Longitud (cm)","Anchura (cm)","Altura (cm)","¿Permitir valoraciones de clientes?","Nota de compra","Precio rebajado","Precio normal","Categorías","Etiquetas","Clase de envío","Imágenes","Límite de descargas","Días de caducidad de la descarga","Superior","Productos agrupados","Ventas dirigidas","Ventas cruzadas","URL externa","Texto del botón","Posición","Nombre del atributo 1","Valor(es) del atributo 1","Atributo visible 1","Atributo global 1"]
dict_data = []

dict_imagenes = {}

with open(input_file, newline='', encoding="utf-8") as File: 
    reader = csv.reader(File, delimiter=',')
    for row in reader:
        if Cont == 0:
            #Data.append(row)
            Cont+=1
        else: 
            aux={}
            for i in range(len(Columnas)):
                aux[Columnas[i]]=row[i]
            dict_data.append(aux)
            print(aux)


Cont = 0
with open(imagenes_file, newline='', encoding="utf-8") as File: 
    reader = csv.reader(File, delimiter=',')
    for row in reader:
        if Cont == 0:
            Cont+=1
        elif row[1]!="No se encontraron resultados": 
            aux={row[0]: row[1]}
            dict_imagenes.update(aux)
            print(aux)

for k, v in dict_imagenes.items():
    try:
        contenido = os.listdir(dir_imagenes+v)
        dict_imagenes[k] = [dir_imagenes_servidor+v+'/'+x for x in contenido]
        print(dict_imagenes[k])
    except:
        dict_imagenes[k] = ""
        print("Error con ", v)
print(dict_imagenes)


for aux in dict_data:
    if aux["SKU"] in dict_imagenes:
        img_str = ''
        for img in dict_imagenes[aux["SKU"]]:
            img_str += img + ','
        aux['Imágenes'] = img_str


try:
    with open(ouput_file, 'w', newline='', encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=Columnas, delimiter=',')
        writer.writeheader()
        for data in dict_data:
            writer.writerow(data)
except IOError:
    print("I/O error")
    
print("Writing complete")