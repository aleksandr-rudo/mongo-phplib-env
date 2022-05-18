ARG DOCKER_PHP_VERSION

FROM php:${DOCKER_PHP_VERSION}-fpm

# Setting user
USER root

ARG TZ='UTC'

# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
RUN echo "${TZ}" && apt-get -y update && apt-get install tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get -y remove tzdata

RUN apt-get -y update && apt-get install -y \
    bash msmtp perl wget procps libzip-dev libpng-dev libwebp-dev mc \
    patch acl git gettext libcurl4 curl libxml2-dev openssh-client buildapp \
    postgresql-client gettext rsync

RUN apt-get install -y \ 
    g++ make automake autoconf libzip-dev \
    htop libpng-dev libwebp-dev \
    libmcrypt-dev zlib1g icu-devtools libicu-dev build-essential

RUN apt-get install -y libssl-dev pkg-config

# PHPIZE
RUN apt-get install -y $PHPIZE_DEPS

# PHP Modules
RUN echo "installing base PHP modules" \
    && docker-php-ext-configure gettext \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure soap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install gd \
    && docker-php-ext-install opcache \
    && docker-php-ext-install soap \
    && docker-php-ext-install xml \
#    && docker-php-ext-install gmp \
#    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache \
    && docker-php-ext-install exif \
    && docker-php-ext-install zip \
#    && docker-php-ext-install mcrypt \
#    && docker-php-ext-install mbstring \
    && docker-php-ext-install iconv \
    && echo "end modules"

# DBs and PHP modules for DBs
RUN echo "installing DBs" \
    && pecl install -o -f redis mongodb \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable mongodb \
    && echo "end DBs"

# Clean
RUN docker-php-source delete

# Composer installation
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN /usr/local/bin/composer self-update

# Ruby
RUN apt-get install -y ruby

#PYTHON
ENV PYTHONUNBUFFERED=1
RUN apt-get install -y python3 python3-pip && ln -sf python3 /usr/bin/python
RUN pip3 install --no-cache --upgrade pip setuptools
RUN alias python=python3

# Java
RUN apt-get install -y default-jre default-jdk

# Specific install config to satisfy Compass requirements
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install -y nodejs gcc g++ make
RUN npm install -g npm@8.7.0

ARG LIBRARY_REPO=empty
ARG DRIVER_REPO=empty
ARG SPECIFICATIONS_REPO=empty
ARG COMPASS_REPO=empty

ENV LIBRARY_REPO=${LIBRARY_REPO}
ENV DRIVER_REPO=${DRIVER_REPO}
ENV SPECIFICATIONS_REPO=${SPECIFICATIONS_REPO}
ENV COMPASS_REPO=${COMPASS_REPO}

WORKDIR /var/www/