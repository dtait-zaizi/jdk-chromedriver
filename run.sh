#!/bin/sh
set -x

CWD=`pwd`

cd /etc/ssl/certs

if [ -d /certs ]
then
  find /certs -type f -exec cp -L {} /etc/ssl/certs/ \;
fi

if [ -d /ca ]
then
  find /ca -type f -exec cp -L {} /etc/ssl/certs/ \;
fi

if [ ! -d /etc/ssl/certs/java ]
then
  mkdir -p /etc/ssl/certs/java
fi

/usr/sbin/update-ca-certificates

chmod +w java/cacerts

if [ -d /ca ]
then
  find /ca \( -name '*.crt' -o  -name '*.pem' \) -type f | xargs -r basename >> /tmp/certs_list
  for CA in `cat /tmp/certs_list`
  do
    keytool -import -alias ${CA%%.*} -keystore java/cacerts --trustcacerts -file ${CA} -storepass changeit -noprompt
  done
fi

echo "CA Cert Stores updated"

cd ${CWD}

exec ${@}