#!/bin/bash

# Cargar variables de entorno desde el archivo .env
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Obtener la fecha actual en el formato YMD (año, mes, día)
current_date=$(date +"%Y%m%d")

# Configuración de las credenciales de SendGrid
api_key="$SENDGRID_API_KEY"
from_email="respaldos_$current_date@$ENDPOINT"
to_email="$TO_EMAIL"
subject="Backup Database"

# Nombre del archivo de respaldo
backupFileName="backup_$current_date.sql.gz"

# Realizar el respaldo de la base de datos y comprimirlo
mysqldump --no-tablespaces -u "$MYSQL_USER"  -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE_EXPORT" | gzip > "$backupFileName"

# Nombre de la base de datos con la fecha actual
database_name_test="backup_test_acalsa"

# Crear la base de datos
#mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "CREATE DATABASE $database_name_test;"

# Descomprimir el archivo de respaldo y cambiar su nombre
uncompressedFileName="backup_$current_date.sql.test"
gunzip -c "$backupFileName" > "$uncompressedFileName"

# Restaurar la base de datos "backup.sql.test" en la base de datos específica
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$database_name_test" < "$uncompressedFileName"

# Verificar que la estructura de la base de datos restaurada sea igual a "$database_name"
diff_output=$(mysqldiff --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" "$MYSQL_DATABASE_EXPORT" "$uncompressedFileName")

if [ -z "$diff_output" ]; then
  database_verification_result="La base de datos restaurada es igual a la base de datos que usa el sistema."
else
  database_verification_result="Advertencia: La base de datos restaurada no es igual a la base de datos $database_name. Diferencias detectadas:\n$diff_output"
fi

# Contenido HTML del correo con una plantilla básica
html_body="
<!DOCTYPE html>
<html>
<head>
  <title> Respaldo base de datos</title>
</head>
<body>
  <h1>Respaldo  Base de Datos</h1>
  <p>$database_verification_result</p>
</body>
</html>
"

# Crear un archivo JSON temporal con los datos de la solicitud
json_file="/tmp/sendgrid_request.json"
cat <<EOF > "$json_file"
{
  "personalizations": [
    {
      "to": [
        {
          "email": "$to_email"
        }
      ],
      "subject": "$subject"
    }
  ],
  "from": {
    "email": "$from_email"
  },
  "content": [
    {
      "type": "text/html",
      "value": "$html_body"
    }
  ],
  "attachments": [
    {
      "content": "$(cat "$backupFileName" | base64 -w 0)",
      "filename": "$backupFileName",
      "type": "application/gzip",
      "disposition": "attachment"
    }
  ]
}
EOF

# Configuración de la solicitud cURL para enviar el correo electrónico a través de SendGrid
curl -X "POST" "https://api.sendgrid.com/v3/mail/send" \
     -H "Authorization: Bearer $api_key" \
     -H "Content-Type: application/json" \
     -d "@$json_file"

