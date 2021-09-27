#!/bin/bash
# carga los Codigos de barra de las droguerias en Mas_vendidos,
# A cada archivo le intoduce el id de la drogueria y la fecha del proseso

IN_PATH='/home/adminvoxoni/Documentos/Voxoni/Drogueria/Scrapy/QueryDrogueria'
cd $IN_PATH
rm -f /tmp/out_*
ls Reporte* -d | while read directorio; do
    DROGUERIA=$(echo $directorio|cut -d- -f2) 
    ARCHIVO=$(ls $directorio/A*csv|cut -d/ -f2)
    
    #FECHA_W=$(echo $ARCHIVO |cut -d- -f2) 
    #FECHA=$(echo $FECHA_W | awk '{print substr($0,5,4)"-"substr($0,3,2)"-"substr($0,1,2)}')
    ARCHIVO_OUT=/tmp/out_$ARCHIVO
    echo $DROGUERIA, $ARCHIVO, $ARCHIVO_OUT
    LC_ALL=C
    awk -b -v drogueria=$DROGUERIA '{print drogueria";"$0}' $directorio/$ARCHIVO > $ARCHIVO_OUT-AUX
    awk 'NR>1' $ARCHIVO_OUT-AUX > $ARCHIVO_OUT
    CARGAR=$(wc -l $ARCHIVO_OUT|awk '{print $1}')
    
    dos2unix $ARCHIVO_OUT

    mysql -u root acopio -e "delete from Mas_vendidos where drogueria = '$DROGUERIA';"
    echo "LOAD DATA INFILE '$ARCHIVO_OUT'
    INTO TABLE Mas_vendidos 
    FIELDS TERMINATED BY ';' 
    ENCLOSED BY '\"'
    LINES TERMINATED BY '\n';" > tmp.$$

    chmod 777 $ARCHIVO_OUT
    mysql -u root acopio < tmp.$$
    CARGADOS=$(mysql -u root acopio -e "select count(*) from Mas_vendidos where drogueria = '$DROGUERIA';" |tail -1)
        
    if [ "$CARGAR" = "$CARGADOS" ]; then
        echo Cargando $ARCHIVO_OUT CARGAR:$CARGAR CARGADOS:$CARGADOS
    else
        echo ERROR!!! Cargando $ARCHIVO_OUT CARGAR:$CARGAR CARGADOS:$CARGADOS
    fi
    rm -f tmp.$$
done