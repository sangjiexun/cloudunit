# LICENCE : CloudUnit is available under the Affero Gnu Public License GPL V3 : https://www.gnu.org/licenses/agpl-3.0.html
# but CloudUnit is licensed too under a standard commercial license.
# Please contact our sales team if you would like to discuss the specifics of our Enterprise license.
# If you are not sure whether the GPL is right for you,
# you can always test our software under the GPL and inspect the source code before you contact us
# about purchasing a commercial license.

# LEGAL TERMS : "CloudUnit" is a registered trademark of Treeptik and can't be used to endorse
# or promote products derived from this project without prior written permission from Treeptik.
# Products or services derived from this software may not be called "CloudUnit"
# nor may "Treeptik" or similar confusing terms appear in their names without prior written permission.
# For any questions, contact us : contact@treeptik.fr

#!/bin/bash

source .env

if [[ $USER != "vagrant" ]]; then
    echo "This script must be run as vagrant user for dev environment"
    exit 1
fi

if [ "$1" != "-y" ]; then
    echo "Are you sure to delete them ? [y/n]"
    read PROD_ASW
    if [ "$PROD_ASW" != "y" ] && [ "$PROD_ASW" != "n" ]; then
        echo "Entrer y ou n!"
        exit 1
    elif [ "$PROD_ASW" = "n" ]; then
        exit 1
    fi
fi

## Generate TLS cert if doesn't exist
if [ -d "cu-traefik/certs" ]; then
  echo "Certificate already generated bypass this step"
else
  mkdir certs
  openssl genrsa 2048 > cu-traefik/certs/traefik.key
  openssl req -new -newkey rsa:2048 -nodes -keyout cu-traefik/certs/traefik.key -out cu-traefik/certs/traefik.csr \
      -subj "/C=FR/ST=PACA/L=BDR/O=treeptik/OU=SI/CN=*.$CU_DOMAIN/emailAddress=s.musso@treeptik.fr"
  openssl x509 -req -days 365 -in cu-traefik/certs/traefik.csr -signkey cu-traefik/certs/traefik.key -out cu-traefik/certs/traefik.crt
fi

echo "***************************"
echo -e "Removing containers And Volumes"
echo "***************************"

docker-compose  -f docker-compose.elk.yml -f docker-compose.dev.yml kill
docker-compose  -f docker-compose.elk.yml -f docker-compose.dev.yml rm -f 
docker volume rm cucompose_gitlab-logs
docker volume rm cucompose_mysqldata
docker volume rm cucompose_redis-data
docker network rm skynet

for container in $(docker ps -aq --format '{{.Names}}' --filter "label=origin=application"); do
  echo "Delete applicative container "$container
  docker rm -f $container
  docker volume rm $container
  docker volume ls -qf dangling=true | xargs -r docker volume rm
done

echo "*******************************"
echo -e "Starting..."
echo "*******************************"
docker network create skynet
docker-compose  --file docker-compose.dev.yml \
                --file docker-compose.elk.yml \
                up -d

