# Docker image for php-fpm

[![Build Status](https://travis-ci.org/Yavin/docker-alpine-php-fpm.svg?branch=5.6)](https://travis-ci.org/Yavin/docker-alpine-php-fpm)

Tags:
* `latest`, `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~60MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 5.6.28

## Running
```
docker run --rm -p 9000:9000 -v /path/of/application:/application yavin/alpine-php-fpm:5.6
```

Fallowing configuration allow to connect to this FPM setup:
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
[PHP Modules]
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
Phar
posix
readline
Reflection
session
SimpleXML
SPL
standard
tokenizer
xml
xmlwriter
Zend OPcache

[Zend Modules]
Zend OPcache
```

##### All php available packages in repository
```
php5
php5-pgsql
php5-zip
php5-cgi
php5-embed
php5-xmlrpc
php5-dbg
php5-sysvshm
php5-mysql
php5-imap
php5-doc
php5-imagick
php5-zlib
php5-pear-net_socket
php5-calendar
php5-pdo_dblib
php5-dba
php5-mysqli
php5-odbc
php5-soap
php5-shmop
php5-wddx
php5-cli
php5-pear-mail_mime
php5-fpm
php5-phpdbg
php5-pear-auth_sasl
php5-bz2
php5-sockets
php5-pear-mdb2-driver-mysqli
php5-phalcon
php5-memcache
php5-pear-mdb2-driver-sqlite
php5-apache2
php5-pdo_mysql
php5-mailparse
php5-pear-mdb2-driver-mysql
php5-sysvmsg
php5-pspell
php5-iconv
php5-pear-net_idna2
php5-dev
php5-ftp
php5-gettext
php5-mssql
php5-pear-mdb2
php5-mcrypt
php5-exif
php5-xmlreader
php5-xcache
php5-gd
php5-xml
php5-pcntl
php5-pear
php5-pdo_pgsql
php5-phpmailer
php5-phar
php5-apcu
php5-ctype
php5-intl
php5-pdo
php5-openssl
php5-pear-mdb2-driver-pgsql
php5-common
php5-sysvsem
php5-pear-net_smtp
php5-posix
php5-pdo_sqlite
php5-dom
php5-curl
php5-xsl
php5-ldap
php5-pdo_odbc
php5-json
php5-enchant
php5-bcmath
php5-opcache
php5-sqlite3
php5-gmp
php5-snmp
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
