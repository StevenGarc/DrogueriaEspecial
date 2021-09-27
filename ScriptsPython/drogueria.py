from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options

csv = "test_woo/prueba.csv"


def esperar(xpath):
    try:
        element = WebDriverWait(browser, 20).until(
            EC.presence_of_element_located((By.XPATH, xpath))
        )
        return True
    finally:
        print("esperando ", xpath)
        return False


options = Options()
#options.add_argument("--headless") #ventana visible
url = 'http://127.0.0.1'
browser = webdriver.Firefox(options=options, executable_path='/media/datos2/Descargas/Documentos/webdriver/geckodriver')
#browser.maximize_window()  
browser.get(url + '/wp-login.php')
usuario = browser.find_element_by_name('log')
pwd = browser.find_element_by_name('pwd')
usuario.send_keys('amorales')
pwd.send_keys('290764')
browser.find_element_by_id('wp-submit').click()
esperar('//*[@id="menu-posts-product"]/a/div[3]')
browser.get(url +'/wp-admin/edit.php?post_type=product&page=product_importer')

esperar('//*[@id="wpbody-content"]/div[5]/div[3]/form/div/a')
browser.find_element_by_xpath('//*[@id="wpbody-content"]/div[5]/div[3]/form/div/a').click()

esperar('//*[@id="woocommerce-importer-file-url"]')
path_csv = browser.find_element_by_xpath('//*[@id="woocommerce-importer-file-url"]')
path_csv.send_keys(csv)

esperar('//*[@id="woocommerce-importer-update-existing"]')
#browser.find_element_by_xpath('//*[@id="woocommerce-importer-update-existing"]').click()

esperar('//*[@name="save_step"][ @value="Seguir" ]')
browser.find_element_by_xpath('//*[@name="save_step"][ @value="Seguir" ]').click()


esperar('//*[@name="save_step"][ @value="Ejecutar el importador"]')
browser.find_element_by_xpath('//*[@name="save_step"][ @value="Ejecutar el importador"]').click()



