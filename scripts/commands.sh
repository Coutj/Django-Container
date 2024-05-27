#!/bin/sh

# O shell irá encerrar a execução do script quando um comando falhar
set -e

chown -R duser:duser /venv
chown -R duser:duser /data/web/static
chown -R duser:duser /data/web/media
chown -R duser:duser /Django
chmod -R 755 /data/web/static
chmod -R 755 /data/web/media
chmod -R 777 /Django


wait_psql.sh
collectstatic.sh
migrate.sh

if [ ! -d "/Django/DJANGO_APP" ]; then
    echo "Ciando APP"
    create_app.sh
fi

mkdir -p "/Django/DJANGO_APP/static/DJANGO_APP/css"
mkdir -p "/Django/DJANGO_APP/templates/DJANGO_APP"
mkdir -p "/Django/DJANGO_APP/static/DJANGO_APP/js"
mkdir -p "/Django/DJANGO_APP/static/DJANGO_APP/img"

runserver.sh