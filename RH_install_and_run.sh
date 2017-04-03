#!/bin/sh

echo -e "\n **** PARAMOS CONTENEDORES EN EJECUCIÓN ****"
docker stop `docker ps | tail -n +2 | awk '{print $1}'`

echo -e "\n **** Construimos el contenedor TEO ****"
docker build -t teo:1.0 .

echo -e "\n **** eliminando anterior POSTGRESQL ****"
docker rm postgresql-redmine
echo -e "\n **** eliminando anterior TEO ****"
docker rm teo
echo -e "\n **** BORRANDO VOLUMENES NO USADOS ****"
docker volume rm $(docker volume ls -f dangling=true -q)

sleep 1
echo -e "\n **** INICIANDO BBDD ****"
#docker run --name=postgresql-redmine -d --env='DB_NAME=redmine_production' --env='DB_USER=redmine' --env='DB_PASS=password' --volume=/srv/docker/redmine/postgresql:/var/lib/postgresql sameersbn/postgresql:9.6-2
docker run --name=postgresql-redmine -d --env='DB_NAME=redmine_production' --env='DB_USER=redmine' --env='DB_PASS=password' sameersbn/postgresql:9.6-2

echo -e "\n **** INICIANDO REDMINE TEO ****"
#docker run --name=teo -d --link=postgresql-redmine:postgresql --publish=10083:80 --publish=10022:22 --env='REDMINE_PORT=10083' --volume=/srv/docker/redmine/redmine:/home/redmine/data teo:1.0
#docker run --name=teo -d --link=postgresql-redmine:postgresql --publish=10083:80 --publish=10022:22 --env='REDMINE_PORT=10083' --volume=/srv/docker/redmine/redmine:/home/redmine/data teo:1.0
docker run --name=teo -d --link=postgresql-redmine:postgresql --publish=10083:80 --publish=10022:22 --env='REDMINE_PORT=10083' teo:1.0


echo -e "\n **** LISTADO CONTENEDORES ****"
docker ps

echo -e "\n **** LOGS REDMINE ****"
docker logs -f `docker ps | grep 'teo' | awk '{print $1}'`  

