# Docker image for php-fpm

[![Build Status](https://travis-ci.org/Yavin/docker-alpine-php-fpm.svg?branch=7.0)](https://travis-ci.org/Yavin/docker-alpine-php-fpm/branches)
[![](https://images.microbadger.com/badges/image/yavin/alpine-php-fpm:7.0.svg)](https://microbadger.com/images/yavin/alpine-php-fpm:7.0)

Tags:
* `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/7.0/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small. Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 7.0.21

## Running

```sh
docker run --rm -p 9000:9000 -v /path/of/application:/application yavin/alpine-php-fpm:7.0
```

Following nginx configuration allow to connect to this FPM setup:

```nginx
server {
    # here some other configuration...

    location ~ \.php(/|$) {
        include       fastcgi_params;
        fastcgi_param DOCUMENT_ROOT   <b>/application/web</b>;
        fastcgi_param SCRIPT_FILENAME <b>/application/web</b>$fastcgi_script_name;
        fastcgi_pass  <b>fpm-host-name:9000</b>;
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
FROM yavin/alpine-php-fpm:7.0
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
FROM yavin/alpine-php-fpm:7.0
COPY php-fpm.conf /etc/php7/php-fpm.conf
```

## Add extension that you need

```Dockerfile
FROM yavin/alpine-php-fpm:7.0
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
mysqli
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
standard
tokenizer
xml
xmlwriter
Zend OPcache
zip

[Zend Modules]
Zend OPcache
```

##### Other php7 packages available in repository

```sh
$ apk --update search php7
php7-intl-7.0.16-r0
php7-openssl-7.0.16-r0
php7-dba-7.0.16-r0
php7-sqlite3-7.0.16-r0
php7-pear-7.0.16-r0
php7-phpdbg-7.0.16-r0
php7-litespeed-7.0.16-r0
php7-gmp-7.0.16-r0
php7-pdo_mysql-7.0.16-r0
php7-pcntl-7.0.16-r0
php7-common-7.0.16-r0
php7-xsl-7.0.16-r0
php7-fpm-7.0.16-r0
php7-mysqlnd-7.0.16-r0
php7-enchant-7.0.16-r0
php7-pspell-7.0.16-r0
php7-snmp-7.0.16-r0
php7-doc-7.0.16-r0
php7-mbstring-7.0.16-r0
php7-dev-7.0.16-r0
php7-xmlrpc-7.0.16-r0
php7-embed-7.0.16-r0
php7-xmlreader-7.0.16-r0
php7-pdo_sqlite-7.0.16-r0
php7-exif-7.0.16-r0
php7-opcache-7.0.16-r0
php7-ldap-7.0.16-r0
php7-posix-7.0.16-r0
php7-session-7.0.16-r0
php7-gd-7.0.16-r0
php7-gettext-7.0.16-r0
php7-json-7.0.16-r0
php7-xml-7.0.16-r0
php7-7.0.16-r0
php7-iconv-7.0.16-r0
php7-sysvshm-7.0.16-r0
php7-curl-7.0.16-r0
php7-shmop-7.0.16-r0
php7-odbc-7.0.16-r0
php7-phar-7.0.16-r0
php7-pdo_pgsql-7.0.16-r0
php7-imap-7.0.16-r0
php7-pdo_dblib-7.0.16-r0
php7-pgsql-7.0.16-r0
php7-pdo_odbc-7.0.16-r0
php7-xdebug-2.5.0-r1
php7-zip-7.0.16-r0
php7-apache2-7.0.16-r0
php7-cgi-7.0.16-r0
php7-ctype-7.0.16-r0
php7-mcrypt-7.0.16-r0
php7-wddx-7.0.16-r0
php7-bcmath-7.0.16-r0
php7-calendar-7.0.16-r0
php7-tidy-7.0.16-r0
php7-dom-7.0.16-r0
php7-sockets-7.0.16-r0
php7-soap-7.0.16-r0
php7-apcu-5.1.8-r0
php7-sysvmsg-7.0.16-r0
php7-zlib-7.0.16-r0
php7-ftp-7.0.16-r0
php7-sysvsem-7.0.16-r0
php7-pdo-7.0.16-r0
php7-bz2-7.0.16-r0
php7-mysqli-7.0.16-r0
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
