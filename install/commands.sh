#!/bin/sh

# O shell irá encerrar a execução do script quando um comando falhar
set -e

chown -R duser:duser /venv
chown -R duser:duser /data/web/static
chown -R duser:duser /data/web/media
chown -R duser:duser /%DJANGO_DIR_NAME%
chmod -R 755 /data/web/static
chmod -R 755 /data/web/media


wait_psql.sh
collectstatic.sh
migrate.sh

if [ ! -d "/%DJANGO_DIR_NAME%/%DJANGO_APP_NAME%" ]; then
    echo "Ciando APP"
    create_app.sh
fi

chmod -R 777 /%DJANGO_DIR_NAME%

mkdir -p "/%DJANGO_DIR_NAME%/%DJANGO_APP_NAME%/static/%DJANGO_APP_NAME%/css"
mkdir -p "/%DJANGO_DIR_NAME%/%DJANGO_APP_NAME%/templates/%DJANGO_APP_NAME%"
mkdir -p "/%DJANGO_DIR_NAME%/%DJANGO_APP_NAME%/static/%DJANGO_APP_NAME%/js"
mkdir -p "/%DJANGO_DIR_NAME%/%DJANGO_APP_NAME%/static/%DJANGO_APP_NAME%/img"

runserver.sh
