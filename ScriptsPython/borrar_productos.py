import csv
from requests import NullHandler
from requests.api import options
from woocommerce import API

"""Configuracion Produccion"""
"""
wcapi = API(

    url="https://www.drogueriaespecial.com/",  # Your store URL
    consumer_key="ck_cace5342881a49681854b8ece5561bac9a204ea5",  # Your consumer key
    consumer_secret="cs_e80e3651aa0003e7181ffcdb58dfc563bbfb4800",  # Your consumer secret
    wp_api=True,  # Enable the WP REST API integration
    version="wc/v3",  # WooCommerce WP REST API version
    timeout=10
)
"""
"""Configuracion Local"""
#""" 
wcapi = API(
    url="http://127.0.0.1/", # Your store URL
    consumer_key="ck_b1e6b281275035a1b60f9ae86126629eb712d07c", # Your consumer key
    consumer_secret="cs_0775d7d41a6b4a07c920df1161621b7fab194478", # Your consumer secret
    wp_api=True, # Enable the WP REST API integration
    version="wc/v3", # WooCommerce WP REST API version
    timeout=100 
)
#"""

productos = wcapi.get("products", params={"per_page":100}).json()
print(len(productos), [x["id"] for x in productos])
while len(productos)!=0:
    wcapi.post("products/batch", {"delete": [x["id"] for x in productos]}).json()
    productos = wcapi.get("products", params={"per_page":100}).json()
    print(len(productos), [x["id"] for x in productos])

for i in productos:
    print("Borrando ", i["id"])
    wcapi.delete("products/"+str(i["id"]), params={"force": True}).json()