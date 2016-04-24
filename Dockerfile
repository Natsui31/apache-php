FROM php:5.6-apache
MAINTAINER Natsui31 "Gwendoline.Boirelle@gmail.com"

VOLUME /var/www/html

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev libmcrypt-dev \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip mcrypt \
	&& docker-php-ext-install opcache \
	&& a2enmod rewrite \
	&& rm -rf /var/lib/apt/lists/*

RUN chmod a+r /etc/hosts

COPY opcache.ini custom.ini /usr/local/etc/php/conf.d/
