# Ejecutar una Tarea de Respaldo y Notificación

🌌 Como **administrador de sistemas** en Acalsa, quiero **automatizar la tarea de respaldo de una base de datos y recibir notificaciones por correo electrónico** para asegurarme de que los datos estén protegidos y ser notificado sobre el estado de la operación. Esto me permitirá mantener un proceso de respaldo eficiente y estar informado sobre cualquier problema que pueda surgir.

## Criterios de Aceptación

🐘 Puedo ejecutar el script desde la línea de comandos.
🦒 El script crea una base de datos con un nombre único basado en la fecha.
🦣 Restaura una base de datos de respaldo en la base de datos creada.
🦙 Verifica si la estructura de la base de datos restaurada es igual a la base de datos creada.
🦛 Genera un correo electrónico con información sobre el resultado de la verificación.
🐪 Adjunta un archivo de respaldo a la notificación por correo electrónico.
🦇 Se pueden personalizar las credenciales y la información de notificación.

## Instrucciones de Uso

1. Clona este repositorio o descarga el script `backup_and_notify.sh`.

2. Crea un archivo `.env` en el mismo directorio que el script y configura las variables de entorno:

    MYSQL_USER=tu_usuario
    MYSQL_PASSWORD=tu_password
    SENDGRID_API_KEY=TU_API_KEY

Asegúrate de reemplazar `tu_usuario`, `tu_password` y `TU_API_KEY` con tus propias credenciales.

3. Ejecuta el script desde la línea de comandos:

```bash
./backup_and_notify.sh

## El script realizará las siguientes acciones:

🐀 Creará una base de datos con un nombre único basado en la fecha actual.
🐹 Restaurará una base de datos de respaldo en la base de datos recién creada.
🐰 Verificará si la estructura de la base de datos restaurada es igual a la base de datos creada.
🐿️ Generará un correo electrónico con información sobre el resultado de la verificación.
🦫 Adjuntará un archivo de respaldo a la notificación por correo electrónico.
🦔 Enviar la notificación por correo electrónico utilizando SendGrid.
Puedes personalizar las credenciales de MySQL y SendGrid modificando el archivo .env antes de ejecutar el script.

## Pruebas
🔥 Se han realizado las siguientes pruebas en el script:

    🌘 Prueba de creación de base de datos única basada en la fecha.
    🌗 Prueba de restauración de base de datos de respaldo.
    🌖 Prueba de verificación de estructura de base de datos.
    🌕 Prueba de generación de notificación por correo electrónico.
    🌔 Prueba de adjuntar archivo de respaldo a la notificación.
    🌓 Prueba de envío exitoso de correo electrónico.

## Contribuciones

🐐 ¡Las contribuciones son bienvenidas! Si tienes ideas para mejorar este script o el README, siéntete libre de hacer un fork del repositorio y enviar pull requests.