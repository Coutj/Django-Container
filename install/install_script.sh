#!/bin/bash

set -e

# Script para iniciar a instalacao do projeto.

# Altere os valores da variaveis de acordo com o estabelecido no arquivo de configurações.
DJANGO_DIR_NAME="Django"
DJANGO_PROJECT_NAME="DJANGO_PROJECT"
DJANGO_APP_NAME="DJANGO_APP"

# Indo para raiz
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"/..

# Upgrade pip
pip install --upgrade pip

# Criando ambiente virtual para desenvolvimento do projeto
python3 -m venv env

# Ativando ambiente virtual
source ./env/bin/activate

# Instalando requirements
pip install -r requirements.txt

# Criando pasta do projeto
mkdir "$DJANGO_DIR_NAME"

cd "$DJANGO_DIR_NAME"

# Inicia o projeto
django-admin startproject $DJANGO_PROJECT_NAME .

cd ..

# Copia arquivos de configuracao do django
cp -f ./install/settings.py "$DJANGO_DIR_NAME/$DJANGO_PROJECT_NAME/"
cp -f ./install/urls.py "$DJANGO_DIR_NAME/$DJANGO_PROJECT_NAME/"

# Cria script de instalação do APP
echo "#!/bin/sh" > ./scripts/create_app.sh
echo "python manage.py startapp $DJANGO_APP_NAME" >> ./scripts/create_app.sh

# Altera nomes de diretorios no Dockerfile
cp -f ./install/Dockerfile ./Dockerfile
sed -i "s/%DJANGO_DIR_NAME%/$DJANGO_DIR_NAME/g" ./Dockerfile

# Altera nomes de diretorios no docker-compose
cp -f ./install/docker-compose.yml ./docker-compose.yml
sed -i "s/%DJANGO_DIR_NAME%/$DJANGO_DIR_NAME/g" ./docker-compose.yml

# Altera nomes de diretorios e app no script 
cp -f ./install/commands.sh ./scripts/commands.sh
sed -i "s/%DJANGO_DIR_NAME%/$DJANGO_DIR_NAME/g" ./scripts/commands.sh
sed -i "s/%DJANGO_APP_NAME%/$DJANGO_APP_NAME/g" ./scripts/commands.sh


# Move arquivo de requirements para diretorio do django
cp ./requirements.txt "$DJANGO_DIR_NAME/"
