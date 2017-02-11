# Docker image for php-fpm

[![Build Status](https://travis-ci.org/Yavin/docker-alpine-php-fpm.svg?branch=master)](https://travis-ci.org/Yavin/docker-alpine-php-fpm)

Tags:
* `latest`, `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~65MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 7.0.15

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
RUN apk --update add php7-ftp && rm -rf /var/cache/apk/*
```

#### PHP extensions included:
* bcmath
* dom
* ctype
* curl
* fpm
* gd
* iconv
* intl
* json
* mbstring
* mcrypt
* mysqlnd
* opcache
* openssl
* pdo
* pdo_mysql
* pdo_pgsql
* pdo_sqlite
* phar
* posix
* session
* soap
* xml
* zip

##### Other php7 packages available in repository
```
dba
sqlite3
pear
phpdbg
litespeed
gmp
pcntl
common
xsl
enchant
pspell
snmp
doc
dev
xmlrpc
embed
xmlreader
exif
ldap
gettext
sysvshm
shmop
odbc
imap
pdo_dblib
pgsql
pdo_odbc
xdebug
apache2
cgi
wddx
calendar
tidy
sockets
apc
sysvmsg
zlib
ftp
sysvsem
bz2
mysqli
```

###### Licence
[MIT](https://opensource.org/licenses/MIT)
