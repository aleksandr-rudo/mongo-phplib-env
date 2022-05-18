#!/bin/sh
phpize > /dev/null && ./configure --enable-mongodb-developer-flags > /dev/null && make clean > /dev/null && make all > /dev/null && make install