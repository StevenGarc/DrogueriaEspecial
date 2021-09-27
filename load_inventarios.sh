#!/bin/bash
# carga los inventarios de las droguerias en ingreso_inventario, limpiando previamente la tabla
# A cada archivo le intoduce el id de la drogueria y la fecha del proseso

IN_PATH='/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/Inventarios'
cd $IN_PATH
rm -f /tmp/out_*
ls inventario*csv | while read archivo; do 
    DROGUERIA=$(basename -s .csv $archivo | cut -d- -f3 )
    FECHA_W=$(echo $archivo | cut -d- -f2)
    FECHA=$(echo $FECHA_W | awk '{print substr($0,5,4)"-"substr($0,3,2)"-"substr($0,1,2)}')
    #echo $DROGUERIA $FECHA
    ARCHIVO_OUT=/tmp/out_$archivo
    LC_ALL=C
    awk -b -v drogueria=$DROGUERIA -v fecha=$FECHA '{if (length($0)>30){print drogueria";"fecha";"$0}}' $archivo > $ARCHIVO_OUT
    mysql -u root acopio -e "delete from ingreso_inventario where drogueria = '$DROGUERIA' and fecha = '$FECHA';"
    echo "LOAD DATA INFILE '$ARCHIVO_OUT'
    INTO TABLE ingreso_inventario 
    FIELDS TERMINATED BY ';' 
    ENCLOSED BY '\"'
    LINES TERMINATED BY '\n';" > tmp.$$

    chmod 777 $ARCHIVO_OUT
    echo Cargando $ARCHIVO_OUT
    mysql -u root acopio < tmp.$$
    rm -f tmp.$$
done 

