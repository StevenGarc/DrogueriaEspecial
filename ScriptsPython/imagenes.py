from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options
import time
import glob
import csv

input_file="Datos_Test.csv"
ouput_file="imagenes_sku.csv"

Columnas = ["SKU", "Imagen"]
datos = []


Usuario = "30562"
Passworld = "Elsamaria$98"
Url = "https://bancodeimagenes.coopidrogas.com.co/"
path_browser ='/media/datos2/Descargas/Documentos/webdriver/geckodriver'
path_download = '/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/imagenes'

def esperar(xpath):
    try:
        element = WebDriverWait(browser, 10).until(
            EC.presence_of_element_located((By.XPATH, xpath))
        )
        return True
    finally:
        print("esperando ", xpath)
        return False


options = Options()
options.add_argument("--headless") #ventana visible

profile = webdriver.FirefoxProfile()
profile.set_preference("browser.download.folderList", 2)
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", path_download)
profile.set_preference("browser.helperApps.neverAsk.saveToDisk", "application/zip")

browser = webdriver.Firefox(options=options, executable_path=path_browser, firefox_profile=profile)

#browser.maximize_window()  
browser.get(Url)

usuario_input = browser.find_element_by_xpath('//*[@id="codigoDrogueria"]')
passworld_input = browser.find_element_by_xpath('//*[@id="inputPassword"]')

usuario_input.send_keys(Usuario)
passworld_input.send_keys(Passworld)

browser.find_element_by_xpath('/html/body/div[2]/form/button').click()

time.sleep(2)

#esperar('//*[@id="contenidoModalTyC"]')
#esperar('/html/body/div[4]/div/div/div[1]/button/span')

browser.find_element_by_xpath('/html/body/div[4]/div/div/div[1]/button/span').click()
time.sleep(1)
esperar('//*[@id="sortBy"]')

Cont = 0
datos_producto = {}

def Descargar_imagenes(SKU):
    browser.find_element_by_xpath('//*[@id="sortBy"]').click()
    browser.find_element_by_xpath('//*[@id="sortBy"]/option[4]').click()
    search_input = browser.find_element_by_xpath('//*[@id="searchValue"]')
    search_input.send_keys(SKU)
    browser.find_element_by_xpath('//*[@id="buscarProducto"]').click()
    resultado_busqueda = browser.find_element_by_xpath('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[5]').text
    if resultado_busqueda == 'No se encontraron resultados':
        browser.find_element_by_xpath('//*[@id="sortBy"]/option[3]').click()
        browser.find_element_by_xpath('//*[@id="buscarProducto"]').click()
        resultado_busqueda = browser.find_element_by_xpath('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[5]').text
        if resultado_busqueda == 'No se encontraron resultados':
            search_input.clear()
            return 'No se encontraron resultados'
        else: 
            esperar('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[3]/div[1]/div/div/div/div[3]')
            resultado_busqueda = browser.find_element_by_xpath('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[3]/div[1]/div/div/div/div[3]').text
            browser.find_element_by_xpath('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[3]/div[1]/div/div/div[1]/div[1]/span/span[1]/span[2]').click()
            time.sleep(1)
            search_input.clear()
            return resultado_busqueda
    else:
        esperar('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[3]/div[1]/div/div/div/div[3]')
        resultado_busqueda = browser.find_element_by_xpath('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[3]/div[1]/div/div/div/div[3]').text
        browser.find_element_by_xpath('//*[@id="myGridProductos"]/div[1]/div[2]/div[1]/div[3]/div[1]/div/div/div[1]/div[1]/span/span[1]/span[2]').click()
        time.sleep(1)
        search_input.clear()
        return resultado_busqueda




with open(input_file, newline='', encoding="utf-8") as File:  
    reader = csv.reader(File, delimiter=';')
    lote = 0
    for row in reader:
        if Cont == 0:
            #Data.append(row)
            Cont+=1
        else: 
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
            }
            try:
                respuesta = Descargar_imagenes(datos_producto['CodProducto'])
                if respuesta != "No se encontraron resultados":
                    datos.append({"SKU": datos_producto['CodProducto'],"Imagen": respuesta})
            except:
                respuesta = Descargar_imagenes(datos_producto['CodProducto'])
                if respuesta != "No se encontraron resultados":
                    datos.append({"SKU": datos_producto['CodProducto'],"Imagen": respuesta})


            lote+=1
            print("conteo de lote: ", lote)
            if lote == 10: 
                lote = 0 
                browser.find_element_by_xpath('//*[@id="ag-myGridProductos-descargar-paquete"]/i[1]').click()
                time.sleep(2)
                browser.find_element_by_xpath('//*[@id="limpiarBusqueda"]').click()
                browser.find_element_by_xpath('//*[@id="limpiarBusqueda"]').click()
                time.sleep(1)

    lote = 0 
    browser.find_element_by_xpath('//*[@id="ag-myGridProductos-descargar-paquete"]/i[1]').click()
    time.sleep(2)
    browser.find_element_by_xpath('//*[@id="limpiarBusqueda"]').click()
    browser.find_element_by_xpath('//*[@id="limpiarBusqueda"]').click()
    time.sleep(1)

try:
    with open(ouput_file, 'w', newline='', encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=Columnas, delimiter=',')
        writer.writeheader()
        for data in datos:
            writer.writerow(data)
except IOError:
    print("I/O error")
    
print("Writing complete")

aux = glob.glob(path_download+'/*.part')

while aux!=[]:
    aux = glob.glob(path_download+'/*.part')

browser.close()

                
