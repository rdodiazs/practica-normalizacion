# Restauración de la base de datos.

En esta carpeta se encuentra el archivo `afiliacion-db.sql` que, al ser ejecutado con el comando `\i` en `psql`, restaura toda la base de datos `afiliacion_db`.

Para hacer más sencilla la reconstrucción de `afiliacion_db`, en el archivo de respaldo definí a mano al rol `postgres` como dueño de la base de datos, pero puede ser modificado al rol que sea de nuestro interés. En dicho caso, recomiendo usar alguna herramienta de búsqueda-reemplazo para hacer el trabajo más expedito.

