# Docker image for php-fpm

[![](https://badge.imagelayers.io/yavin/alpine-php-fpm:5.6.svg)](https://imagelayers.io/?images=yavin/alpine-php-fpm:5.6)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~60MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 5.6.17

#### PHP extensions included:
* fpm
* iconv
* opcache
* pdo_mysql
* json
* xml
* curl
* gd
* intl
* pdo
* mbstring
* dom
* ctype
* posix

## Custom php.ini settings
Create `Dockerfile` file with fallowing content and php.ini file with desired settings (look at php.ini file in this repository)
```
FROM yavin/alpine-php-fpm:5.6
COPY php.ini /etc/php7/conf.d/50-setting.ini
```
And then 
```
docker build -t my-php-fpm .
docker run --rm -p 9000:9000 -v /your/app/folder:/www my-php-fpm:latest
```

## Add extension that you need
```
FROM yavin/alpine-php-fpm:5.6
RUN apk --update add php7-zip && rm -rf /var/cache/apk/*
```

## Change FPM parameters
Copy php-fpm.conf and modify. You will probably want to change process manager settings:
```
; ...
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 5
; ...
```
and build your image:
```
FROM yavin/alpine-php-fpm:5.6
COPY php-fpm.conf /etc/php7/php-fpm.conf
```

## Running
```
docker run --rm -p 9000:9000 -v /your/app/folder:/www yavin/alpine-php-fpm:5.6
```

Remember, that your web serwer must also have mounted application path at same location as this fpm container (`/www` folder).

##### All php available packages in repository
```
php-soap
php-openssl
php-gmp
php-phar
php-embed
php-pdo_odbc
php-mysqli
php-common
php-ctype
php-fpm
php-shmop
php-xsl
php-curl
php-json
php-dom
php-pspell
php-sockets
php-pdo
php-pear
php-cli
php-zip
php-pgsql
php-sysvshm
php-imap
php-intl
php-zlib
php-phpdbg
php-sysvsem
php-mysql
php-sqlite3
php-cgi
php-snmp
php-pdo_pgsql
php-xml
php-wddx
php-sysvmsg
php-enchant
php-bcmath
php-apache2
php-gd
php-odbc
php-ftp
php-exif
php-pdo_mysql
php-ldap
php-dbg
php-opcache
php-pdo_sqlite
php-posix
php-dba
php-iconv
php-gettext
php-xmlreader
php
php-xmlrpc
php-bz2
php-pcntl
php-mcrypt
php-memcache-3.0.8-r4
php-pdo_dblib
php-dev
php-doc
php-mssql
php-calendar
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
