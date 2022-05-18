#!/bin/sh
install_latest_driver ()
{
   rm -r mongo-php-driver
   git clone https://github.com/mongodb/mongo-php-driver.git
   cd mongo-php-driver
   git submodule update --init
   phpize > /dev/null && ./configure --enable-mongodb-developer-flags > /dev/null && make clean > /dev/null && make all > /dev/null && make install
   cd ..
   rm -r mongo-php-driver
}
