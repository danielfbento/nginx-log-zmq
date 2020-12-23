#!/bin/bash

VERSIONS=(1.14.2 1.16.1 1.18.0 1.19.6)

for VERSION in "${VERSIONS[@]}"
do

  cd utils/
  URL=https://nginx.org/download/nginx-${VERSION}.tar.gz

  whereis wget > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "Missing wget"
    exit 1
  fi

  wget $URL 
  rm -rf ../vendor
  mkdir -p ../vendor
  mv nginx-$VERSION.tar.gz ../vendor/
  cd ../vendor/
  tar -xvzf nginx-$VERSION.tar.gz
  cd nginx-$VERSION
  ./configure --add-module=../.. --prefix=/usr/local/nginx
  make && sudo make install
  cd ../../
  sudo cp nginx.conf /usr/local/nginx/conf/nginx.conf

  sudo /usr/local/nginx/sbin/nginx -t

  if [ $? -ne 0 ]; then
    echo "Problems with version $VERSION"
    exit 1
  fi

  sudo rm -rf /usr/local/nginx
done
