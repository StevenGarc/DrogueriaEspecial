from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options

import os
import time
import glob

path_browser ='/media/datos2/Descargas/Documentos/webdriver/geckodriver'
path_download = '/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/Inventarios_WC'
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
options.add_argument("--headless") #ventana visible


profile = webdriver.FirefoxProfile()
profile.set_preference("browser.download.folderList", 2)
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", path_download)
profile.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/csv")


browser = webdriver.Firefox(options=options, executable_path=path_browser, firefox_profile=profile)

url = 'http://127.0.0.1'
#browser.maximize_window()  
browser.get(url + '/wp-login.php')
usuario = browser.find_element_by_name('log')
pwd = browser.find_element_by_name('pwd')
usuario.send_keys('amorales')
pwd.send_keys('290764')
browser.find_element_by_id('wp-submit').click()
esperar('//*[@id="menu-posts-product"]/a/div[3]')

browser.get(url +'/wp-admin/edit.php?post_type=product&page=product_exporter')

print(glob.glob(path_download+'/*.csv'))

esperar('//*[@id="wpbody-content"]/div[5]/div[3]/form/div/button')
browser.find_element_by_xpath('//*[@id="wpbody-content"]/div[5]/div[3]/form/div/button').click()
time.sleep(2)
aux = glob.glob(path_download+'/*.part')

while aux!=[]:
    aux = glob.glob(path_download+'/*.part')

browser.close()


