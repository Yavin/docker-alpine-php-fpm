# Docker image for php-fpm

[![Build Status](https://travis-ci.org/Yavin/docker-alpine-php-fpm.svg?branch=5.6)](https://travis-ci.org/Yavin/docker-alpine-php-fpm)
[![](https://images.microbadger.com/badges/image/yavin/alpine-php-fpm:5.6.svg)](https://microbadger.com/images/yavin/alpine-php-fpm:5.6)

Tags:
* `latest`, `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~60MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 5.6.30

## Running
```
docker run --rm -p 9000:9000 -v /path/of/application:/application yavin/alpine-php-fpm:5.6
```

Fallowing nginx configuration allow to connect to this FPM setup:
<pre>
server {
    # here some other configuration...

    location ~ \.php(/|$) {
        include       fastcgi_params;
        fastcgi_param DOCUMENT_ROOT   <b>/application/web</b>;
        fastcgi_param SCRIPT_FILENAME <b>/application/web</b>$fastcgi_script_name;
        fastcgi_pass  <b>fpm-host-name:9000</b>;
    }
}
</pre>

Please note the path that is passed to FPM and compare it with the `docker run` command.
Above example assume that the `/application/web` is the "public" folder of your app.
If paths in FPM container are the same as in Nginx you can replace it with `$realpath_root`
nginx variable.

## Custom php.ini settings
Create `Dockerfile` file with fallowing content and php.ini file with desired settings (look at php.ini file in this repository)
```
FROM yavin/alpine-php-fpm:5.6
COPY php.ini /etc/php5/conf.d/50-setting.ini
```
And then
```
docker build -t my-php-fpm .
docker run --rm -p 9000:9000 -v /path/of/application:/application my-php-fpm:latest
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
COPY php-fpm.conf /etc/php5/php-fpm.conf
```

## Add extension that you need
```
FROM yavin/alpine-php-fpm:5.6
RUN apk --update add php-zip && rm -rf /var/cache/apk/*
```

#### PHP extensions included:
```
$ php -m
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
ereg
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
standard
tokenizer
xml
xmlwriter
Zend OPcache

[Zend Modules]
Zend OPcache
```

##### All php available packages in alpine repository
```
$ apk --update search php5
php5-5.6.30-r0
php5-pgsql-5.6.30-r0
php5-zip-5.6.30-r0
php5-cgi-5.6.30-r0
php5-embed-5.6.30-r0
php5-xmlrpc-5.6.30-r0
php5-dbg-5.6.30-r0
php5-sysvshm-5.6.30-r0
php5-mysql-5.6.30-r0
php5-imap-5.6.30-r0
php5-doc-5.6.30-r0
php5-imagick-3.4.2-r1
php5-zlib-5.6.30-r0
php5-pear-net_socket-1.0.14-r1
php5-calendar-5.6.30-r0
php5-pdo_dblib-5.6.30-r0
php5-dba-5.6.30-r0
php5-mysqli-5.6.30-r0
php5-odbc-5.6.30-r0
php5-soap-5.6.30-r0
php5-shmop-5.6.30-r0
php5-wddx-5.6.30-r0
php5-cli-5.6.30-r0
php5-pear-mail_mime-1.8.9-r1
php5-fpm-5.6.30-r0
php5-phpdbg-5.6.30-r0
php5-pear-auth_sasl-1.0.6-r0
php5-bz2-5.6.30-r0
php5-sockets-5.6.30-r0
php5-pear-mdb2-driver-mysqli-2.5.0b5-r0
php5-phalcon-2.0.13-r0
php5-memcache-3.0.8-r5
php5-pear-mdb2-driver-sqlite-2.5.0b5-r0
php5-apache2-5.6.30-r0
php5-pdo_mysql-5.6.30-r0
php5-mailparse-2.1.6-r2
php5-pear-mdb2-driver-mysql-2.5.0b5-r0
php5-xdebug-2.5.0-r1
php5-sysvmsg-5.6.30-r0
php5-pspell-5.6.30-r0
php5-iconv-5.6.30-r0
php5-pear-net_idna2-0.1.1-r1
php5-dev-5.6.30-r0
php5-ftp-5.6.30-r0
php5-gettext-5.6.30-r0
php5-mssql-5.6.30-r0
php5-pear-mdb2-2.5.0b5-r0
php5-mcrypt-5.6.30-r0
php5-exif-5.6.30-r0
php5-xmlreader-5.6.30-r0
php5-xcache-3.2.0-r1
php5-gd-5.6.30-r0
php5-xml-5.6.30-r0
php5-pcntl-5.6.30-r0
php5-pear-5.6.30-r0
php5-pdo_pgsql-5.6.30-r0
php5-phpmailer-5.2.4-r1
php5-phar-5.6.30-r0
php5-apcu-4.0.11-r1
php5-ctype-5.6.30-r0
php5-intl-5.6.30-r0
php5-pdo-5.6.30-r0
php5-openssl-5.6.30-r0
php5-pear-mdb2-driver-pgsql-2.5.0b5-r0
php5-common-5.6.30-r0
php5-sysvsem-5.6.30-r0
php5-pear-net_smtp-1.7.2-r0
php5-posix-5.6.30-r0
php5-pdo_sqlite-5.6.30-r0
php5-dom-5.6.30-r0
php5-curl-5.6.30-r0
php5-xsl-5.6.30-r0
php5-ldap-5.6.30-r0
php5-pdo_odbc-5.6.30-r0
php5-pear-auth_sasl2-0.1.0-r0
php5-json-5.6.30-r0
php5-enchant-5.6.30-r0
php5-bcmath-5.6.30-r0
php5-opcache-5.6.30-r0
php5-sqlite3-5.6.30-r0
php5-gmp-5.6.30-r0
php5-snmp-5.6.30-r0
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
