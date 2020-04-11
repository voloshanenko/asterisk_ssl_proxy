#!/bin/bash

DOMAIN="pbx.voloshanenko.com"
TEMP_DIR="/tmp/pbx/certs"

SRC_KEY_FILE="webserver.key"
SRC_CERT_FILE="webserver.crt"
SRC_CHAIN_FILE="ca-bundle.crt"
DESTINATION_KEY_FILE="${DOMAIN}.key"
DESTINATION_CERT_FILE="${DOMAIN}.crt"
DESTINATION_CERT_DIR="nginx-data/certs/"
DOCKER_PROXY_DIR="/home/docker-proxy-companion"
DOMAIN="pbx.voloshanenko.com"

REMOTE_HOST="10.100.101.200"
REMOTE_USER="root"
REMOTE_KEY="/root/.ssh/id_rsa"
REMOTE_DIR="/etc/httpd/pki"
DOCKER_PROXY_DIR="/home/docker-proxy-companion"

echo "Started at $(date)"

mkdir -p ${TEMP_DIR}

echo "Get local dir md5sum fingerprint"
if [ "$(ls -A ${TEMP_DIR})" ]; then
    current_md5=`md5sum ${TEMP_DIR}/* | cut -d " " -f 1`
else
    current_md5=""
fi

echo "Get remote dir md5sum fingerprint"
remote_md5=`ssh -i ${REMOTE_KEY} ${REMOTE_USER}@${REMOTE_HOST} md5sum ${REMOTE_DIR}/* | cut -d " " -f 1`

if [[ "${current_md5}" != "${remote_md5}" ]]; then
   echo "md5 mismatch detected..."
   echo "Remove files from temp dir..."
   rm -rf ${TEMP_DIR}/*
   echo "Transfer files from remote host..."
   scp -i ${REMOTE_KEY} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/* ${TEMP_DIR}
   echo "Concate chain and certificate into one file and copy destination folder..."

   echo "Copy key to destination folder..."
   cat ${TEMP_DIR}/${SRC_CERT_FILE} ${TEMP_DIR}/${SRC_CHAIN_FILE}  > ${DOCKER_PROXY_DIR}/${DESTINATION_CERT_DIR}/${DESTINATION_CERT_FILE}
   echo "Restart docker-proxy-companion stack"
   cat ${TEMP_DIR}/${SRC_KEY_FILE} > ${DOCKER_PROXY_DIR}/${DESTINATION_CERT_DIR}/${DESTINATION_KEY_FILE}
   cd ${DOCKER_PROXY_DIR} && docker-compose restart
else
   echo "md5 equal... Nothing to do..."
fi

echo "Finished at $(date)"
