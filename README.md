# teo

This is a TEO app (based in redmine) for deployment in Openshift demo.

$ oc new-app https://github.com/jmnohales/teo.git --strategy=docker

With external database:

docker run --name=teo -it --rm \
  --env='DB_ADAPTER=postgresql' \
  --env='DB_HOST=192.168.42.228' \
  --env='DB_NAME=redmine_production' \
  --env='DB_USER=redmine' \
  --env='DB_PASS=password' \
  --volume=/srv/docker/redmine/redmine:/home/redmine/data \
  teo:1.0
  
