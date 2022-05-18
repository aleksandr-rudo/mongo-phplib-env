#!/bin/sh

LIBRARY_REPO=${LIBRARY_REPO:-}
DRIVER_REPO=${DRIVER_REPO:-}
SPECIFICATIONS_REPO=${SPECIFICATIONS_REPO:-}
COMPASS_REPO=${COMPASS_REPO:-}



# Functions to fetch MongoDB binaries
. functions.sh


# Installing Mongo-php-driver
echo ""
echo "Installing Mongo-php-driver"
git clone $DRIVER_REPO
mv mongo-php-driver driver
cd driver
git submodule update --init
cd ..
cp scripts/driver/* driver/ 


# Building Mongo-php-driver
echo ""
echo "Building Mongo-php-driver"
install_latest_driver


# Installing Mongo-php-library
echo ""
echo "Installing Mongo-php-library"
git clone $LIBRARY_REPO
mv mongo-php-library library
cd library
composer update
cp phpunit.xml.dist phpunit.xml
cd ..
cp scripts/library/* library/
cd library
bash test.sh --stop-on-error
cd ..	


# Installing Specifications
echo ""
echo "Installing Specifications"
git clone $SPECIFICATIONS_REPO


# Installing Specifications
echo ""
echo "Installing Compass"
git clone $COMPASS_REPO
cp scripts/compass/* compass/ 
