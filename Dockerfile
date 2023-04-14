FROM php:8.1-fpm

RUN usermod --non-unique --uid 1000 www-data
RUN groupmod --non-unique --gid 1000 www-data

RUN mkdir -p /usr/src/php/ext

RUN apt-get -qq update \
    && apt-get install -y apt-utils \
                          xmlsec1 \
                          git \
                          unzip \
                          vim \
                          wget \
                          libzip-dev \
                          libicu-dev \
                          g++ \
                          libmcrypt-dev \
                          libxml2-dev \
                          libbz2-dev \
                          libcurl4 \
                          libcurl4-gnutls-dev \
                          libssl-dev \
                          libgmp-dev \
                          libpcre3-dev\
                          libpq-dev\
                          telnet\
                          lsof


#Xdebug
RUN curl https://xdebug.org/files/xdebug-3.1.3.tgz > /tmp/xdebug.tgz \
    && tar -xpzf /tmp/xdebug.tgz \
    && mv xdebug-3.1.3 /usr/src/php/ext \
    && docker-php-ext-install xdebug-3.1.3

ADD 30-custom.ini /usr/local/etc/php/conf.d/30-custom.ini

RUN apt-get -y purge
