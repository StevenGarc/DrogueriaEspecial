set NombreDrogueria=Suba
for /F "tokens=2" %%i in ('DATE /T') do Set fecha=%%i
set fecha=%fecha:/=%
set file_name=inventario-%fecha%-%NombreDrogueria%
SET file_Barras=CodigoBarras-%fecha%-%NombreDrogueria%
SET directorio=%PUBLIC%\Documents\Reporte-%NombreDrogueria%
mkdir %directorio%
sqlcmd -E -d Dominium -i ".\ExtraerDatos.sql"  -s ; -W |findstr /v /c:"---" > %directorio%\%file_name%.csv
sqlcmd -E -d Dominium -Q "SELECT * FROM CodigoBarras"  -s ; -W |findstr /v /c:"---" > %directorio%\%file_Barras%.csv
ipconfig > %directorio%\ipconfig.txt
pause