#!/bin/bash
source bin/activate
python formato.py
cp prueba.csv /var/www/wordpress/test_woo
python drogueria.py



