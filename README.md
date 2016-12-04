# Docker image for php-fpm

[![Build Status](https://travis-ci.org/Yavin/docker-alpine-php-fpm.svg?branch=master)](https://travis-ci.org/Yavin/docker-alpine-php-fpm)

Tags:
* `latest`, `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~65MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 7.0.12

## Running
```
docker run --rm -p 9000:9000 -v /path/of/application:/application yavin/alpine-php-fpm:7.0
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
FROM yavin/alpine-php-fpm:7.0
COPY php.ini /etc/php7/conf.d/50-setting.ini
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
FROM yavin/alpine-php-fpm:7.0
COPY php-fpm.conf /etc/php7/php-fpm.conf
```

## Add extension that you need
```
FROM yavin/alpine-php-fpm:7.0
RUN apk --update add php7-zip && rm -rf /var/cache/apk/*
```

#### PHP extensions included:
* fpm
* session
* opcache
* pdo_mysql
* mysqlnd
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
* mcrypt
* iconv
* phar
* openssl

##### Other php7 packages available in repository
```
php7-dba
php7-sqlite3
php7-pear
php7-phpdbg
php7-litespeed
php7-gmp
php7-pcntl
php7-common
php7-xsl
php7-enchant
php7-pspell
php7-snmp
php7-doc
php7-dev
php7-xmlrpc
php7-embed
php7-xmlreader
php7-pdo_sqlite
php7-exif
php7-ldap
php7-gettext
php7-sysvshm
php7-shmop
php7-odbc
php7-pdo_pgsql
php7-imap
php7-pdo_dblib
php7-pgsql
php7-pdo_odbc
php7-zip
php7-apache2
php7-cgi
php7-readline
php7-wddx
php7-bcmath
php7-calendar
php7-tidy
php7-sockets
php7-soap
php7-sysvmsg
php7-zlib
php7-ftp
php7-sysvsem
php7-pdo
php7-bz2
php7-mysqli
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
