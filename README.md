# Docker image for php-fpm

[![Build Status](https://travis-ci.org/Yavin/docker-alpine-php-fpm.svg?branch=master)](https://travis-ci.org/Yavin/docker-alpine-php-fpm)
[![](https://images.microbadger.com/badges/image/yavin/alpine-php-fpm:latest.svg)](https://microbadger.com/images/yavin/alpine-php-fpm:latest)

Tags:
* `latest` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile) (based on alpine adge)
* `7.1` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/7.1/Dockerfile)
* `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/7.0/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~65MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 7.1.10

## Running

```sh
docker run --rm -p 9000:9000 -v /path/of/application:/application yavin/alpine-php-fpm:7.1
```

Following nginx configuration allow to connect to this FPM setup:

```nginx
server {
    # here some other configuration...

    location ~ \.php(/|$) {
        include       fastcgi_params;
        fastcgi_param DOCUMENT_ROOT   /application/web;
        fastcgi_param SCRIPT_FILENAME /application/web$fastcgi_script_name;
        fastcgi_pass  fpm-host-name:9000;
    }
}
```

Please note the path that is passed to FPM and compare it with the `docker run` command.
Above example assume that the `/application/web` is the "public" folder of your app.
If paths in FPM container are the same as in Nginx you can replace it with `$realpath_root`
nginx variable.

## Custom php.ini settings
Create `Dockerfile` file with fallowing content and php.ini file with desired settings (look at php.ini file in this repository)

```Dockerfile
FROM yavin/alpine-php-fpm:7.1
COPY php.ini /etc/php7/conf.d/50-setting.ini
```
And then 

```sh
docker build -t my-php-fpm .
docker run --rm -p 9000:9000 -v /path/of/application:/application my-php-fpm:latest
```

## Change FPM parameters
Copy php-fpm.conf and modify. You will probably want to change process manager settings:

```ini
; ...
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 5
; ...
```
and build your image:

```Dockerfile
FROM yavin/alpine-php-fpm:7.1
COPY php-fpm.conf /etc/php7/php-fpm.conf
```

## Add extension that you need

```Dockerfile
FROM yavin/alpine-php-fpm:7.1
RUN apk --update add php7-ftp && rm -rf /var/cache/apk/*
```

#### PHP extensions included:

```sh
$ php -m
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
fileinfo
filter
gd
hash
iconv
intl
json
libxml
mbstring
mcrypt
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
Phar
posix
readline
Reflection
session
SimpleXML
soap
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip

[Zend Modules]
Zend OPcache
```

##### Other php7 packages available in repository

```sh
$ apk --update search php7
php7-intl-7.1.3-r0
php7-openssl-7.1.3-r0
php7-dba-7.1.3-r0
php7-sqlite3-7.1.3-r0
php7-dev-7.1.3-r0
php7-pear-7.1.3-r0
php7-shmop-7.1.3-r0
php7-phpdbg-7.1.3-r0
php7-xmlwriter-7.1.3-r0
php7-pecl-7.1.3-r0
php7-posix-7.1.3-r0
php7-litespeed-7.1.3-r0
php7-gmp-7.1.3-r0
php7-pdo_mysql-7.1.3-r0
php7-bz2-7.1.3-r0
php7-pcntl-7.1.3-r0
php7-common-7.0.17-r4
php7-pdo-7.1.3-r0
php7-oauth-2.0.2-r0
php7-xsl-7.1.3-r0
php7-ctype-7.1.3-r0
php7-mbstring-7.1.3-r0
php7-fpm-7.1.3-r0
php7-mysqli-7.1.3-r0
php7-phar-utils-7.1.3-r0
php7-gmagick-2.0.4_rc1-r3
php7-imagick-3.4.3-r1
php7-mysqlnd-7.1.3-r0
php7-enchant-7.1.3-r0
php7-solr-2.4.0-r0
php7-uuid-1.0.4-r0
php7-curl-7.1.3-r0
php7-pspell-7.1.3-r0
php7-xmlrpc-7.1.3-r0
php7-imap-7.1.3-r0
php7-ast-0.1.4-r0
php7-libs-7.1.3-r0
php7-redis-3.1.2-r0
php7-phar-7.1.3-r0
php7-snmp-7.1.3-r0
php7-doc-7.1.3-r0
php7-fileinfo-7.1.3-r0
php7-opcache-7.1.3-r0
php7-sockets-7.1.3-r0
php7-lzf-1.6.5-r1
php7-xmlreader-7.1.3-r0
php7-dom-7.1.3-r0
php7-timezonedb-2017.2-r0
php7-apache2-7.1.3-r0
php7-pear-mail_mime-1.10.0-r0
php7-rdkafka-2.0.0-r0
php7-stats-2.0.3-r0
php7-embed-7.0.17-r4
php7-pdo_sqlite-7.1.3-r0
php7-pear-auth_sasl2-0.2.0-r0
php7-exif-7.1.3-r0
php7-msgpack-2.0.2-r0
php7-wddx-7.1.3-r0
php7-recode-7.1.3-r0
php7-ldap-7.1.3-r0
php7-xml-7.1.3-r0
php7-pdo_odbc-7.1.3-r0
php7-pear-net_socket-1.1.0-r0
php7-7.1.3-r0
php7-session-7.1.3-r0
php7-gd-7.1.3-r0
php7-gettext-7.1.3-r0
php7-mailparse-3.0.2-r0
php7-mcrypt-7.1.3-r0
php7-pdo_dblib-7.1.3-r0
php7-json-7.1.3-r0
php7-mongodb-1.2.8-r0
php7-sysvsem-7.1.3-r0
php7-calendar-7.1.3-r0
php7-iconv-7.1.3-r0
php7-sysvshm-7.1.3-r0
php7-soap-7.1.3-r0
php7-cgi-7.1.3-r0
php7-odbc-7.1.3-r0
php7-pdo_pgsql-7.1.3-r0
php7-zip-7.1.3-r0
php7-pgsql-7.1.3-r0
php7-xdebug-2.5.0-r1
php7-zlib-7.1.3-r0
php7-inotify-2.0.0-r0
php7-couchbase-2.2.3-r1
php7-config-7.1.3-r0
php7-amqp-1.9.0-r0
php7-cassandra-1.2.2-r0
php7-libsodium-1.0.6-r0
php7-pear-net_smtp-1.8.0-r1
php7-bcmath-7.1.3-r0
php7-tidy-7.1.3-r0
php7-zmq-1.1.3-r0
php7-memcached-3.0.3-r0
php7-apcu-5.1.8-r0
php7-sysvmsg-7.1.3-r0
php7-imagick-dev-3.4.3-r1
php7-ftp-7.1.3-r0
php7-ssh2-1.0-r0
php7-pear-net_idna2-0.2.0-r1
php7-pear-auth_sasl-1.1.0-r0
php7-pear-net_smtp-doc-1.8.0-r1
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
