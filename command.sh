#!/bin/bash

# dopo la creazione di una nuova shell si torna al sistema di build predefinito
export DOCKER_BUILDKIT=1
docker build -f Dockerfile-experimental -t registry .

# si può concatenare il comando 
DOCKER_BUILDKIT=1 docker build -f Dockerfile-experimental -t registry .

docker run --network altaformazione --name zipkin -p 9411:9411 -d openzipkin/zipkin
docker run --network altaformazione --name mongo -d mongo:latest
docker run --memory 256m --network altaformazione -p 8761:8761 --name registry -d registry
docker run --network altaformazione --memory 256m --name catalog -p 18080:8080 -e "MONGO_URL=mongo" -e "ZIPKIN_URL=http://zipkin:9411" -e "EUREKA_URL=http://registry:8761/eureka" -d catalog
docker run --network altaformazione --memory 256m --name purchases -p 28080:8080 -e "MONGO_URL=mongo" -e "ZIPKIN_URL=http://zipkin:9411" -e "EUREKA_URL=http://registry:8761/eureka" -d purchases
docker run --network altaformazione --memory 256m --name zuul-proxy -p 5000:5000 -e "ZIPKIN_URL=http://zipkin:9411" -e "EUREKA_URL=http://registry:8761/eureka" -d zuul-proxy


declare -i i;i=0; while true; do i+=1; echo $i; curl -X GET -H "Content-Type: application/json" 'http://catalogo.local/api/products'; echo ""; sleep 2; done;



# mettere a inizio Dockerfile

# syntax = docker/dockerfile:1.0-experimental