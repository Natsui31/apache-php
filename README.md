Automated build of Apache-PHP with Docker
===========

#### Embedded extension on this build
> iconv 
> mcrypt 
> gd
> mbstring
> Apache mod : rewrite

#### Use the pre built image
The pre built image can be downloaded using docker directly. 
After that you do not need to use this command again, you will have the image on your machine.

```
$ docker pull natsui31/apache-php
```

#### Build the docker image by yourself
If you prefer you can easily build the docker image by yourself. 
After this the image is ready for use on your machine and can be used for multiple starts.

```
$ git clone https://github.com/Natsui31/docker-apache-php.git apache-php
$ cd apache-php
$ docker build -t natsui31/apache-php .
```

#### Start the container
The container has all pre requisites set up to run any web application.

```
$ docker run -p 80:80 -v /your/html/path:/var/www/html natsui31/apache-php
```

#### How to install more PHP extensions
For example, if you want to have a PHP-FPM image with iconv, mcrypt and gd extensions, you can inherit the base image that you like, and write your own Dockerfile like this: 

```
FROM natsui31/apache-php:latest RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
```

Remember, you must install dependencies for your extensions manually.
If an extension needs custom configure arguments, you can use the docker-php-ext-configure script like this example.

#### PECL extensions
Some extensions are not provided with the PHP source, but are instead available through PECL. 
To install a PECL extension, use pecl install to download and compile it, then use 
docker-php-ext-enable to enable it:

```
FROM natsui31/apache-php:latest
RUN apt-get update && apt-get install -y libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached
```

#### Other extensions
Some extensions are not provided via either Core or PECL; these can be installed too, although the process is less automated:

```
FROM natsui31/apache-php:latest
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p xcache \
    && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && ( \
        cd xcache \
        && phpize \
        && ./configure --enable-xcache \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xcache \
    && docker-php-ext-enable xcache
```
