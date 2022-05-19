#!/bin/sh
build_latest_driver ()
{
   rm -r mongo-php-driver
   git clone https://github.com/mongodb/mongo-php-driver.git
   cd mongo-php-driver
   git submodule update --init
   phpize > /dev/null && ./configure --enable-mongodb-developer-flags > /dev/null && make clean > /dev/null && make all > /dev/null && make install
   cd ..
   rm -r mongo-php-driver
}

install_driver ()
{
  _REPO_URL=$1

  # Installing Mongo-php-driver
  echo "================================================================================================"
  echo "Installing Mongo-php-driver"
  git clone ${_REPO_URL}
  mv mongo-php-driver driver
  cd driver
  git submodule update --init
  cd ..
  cp scripts/driver/* driver/
}

install_library ()
{
  _REPO_URL=$1

  # Installing Mongo-php-library
  echo "================================================================================================"
  echo "Installing Mongo-php-library"
  git clone ${_REPO_URL}
  mv mongo-php-library library
  cd library
  composer update
  cp phpunit.xml.dist phpunit.xml
  cd ..
  cp scripts/library/* library/
  cd library
  bash test.sh --stop-on-error
  cd ..
}

install_specifications ()
{
  _REPO_URL=$1

  # Installing Specifications
  echo "================================================================================================"
  echo "Installing Specifications"
  git clone ${_REPO_URL}
}

install_compass ()
{
  _REPO_URL=$1

  # Installing Compass
  echo "================================================================================================"
  echo "Installing Compass"
  git clone ${_REPO_URL}
  cp scripts/compass/* compass/
}

set_mongo_server ()
{
  MONGO_SERVER=$1
  cp phpunit.xml phpunit1.xml
  sed -r "s/mongodb\:\/\/[^\/]+\//mongodb:\/\/$MONGO_SERVER:27017\//gi" phpunit1.xml | tee phpunit.xml
  rm phpunit1.xml
}