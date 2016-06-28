# Docker image for php-fpm

[![](https://badge.imagelayers.io/yavin/alpine-php-fpm:latest.svg)](https://imagelayers.io/?images=yavin/alpine-php-fpm:latest)

Tags:
* `latest`, `7.0` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile)
* `5.6` [Dockerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~65MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 7.0.7

## Running
```
docker run --rm -p 9000:9000 -v /path/of/application:/app yavin/alpine-php-fpm:7.0
```

Fallowing nginx configuration allow to connect to this FPM setup:
<pre>
server {
    # here some other configuration...

    location ~ \.php(/|$) {
        include       fastcgi_params;
        fastcgi_param DOCUMENT_ROOT   <b>/app/web</b>;
        fastcgi_param SCRIPT_FILENAME <b>/app/web</b>$fastcgi_script_name;
        fastcgi_pass  <b>fpm-host-name:9000</b>;
    }
}
</pre>

Please note the path that is passed to FPM and compare it with the `docker run` command.
Above example assume that the `/app/web` is the "public" folder of your app.
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
docker run --rm -p 9000:9000 -v /path/of/application:/app my-php-fpm:latest
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

##### All php7 available packages in repository
```
php7-intl
php7-openssl
php7-dba
php7-sqlite3
php7-pear
php7-phpdbg
php7-litespeed
php7-gmp
php7-pdo_mysql
php7-pcntl
php7-common
php7-oauth
php7-xsl
php7-fpm
php7-gmagick
php7-mysqlnd
php7-enchant
php7-solr
php7-uuid
php7-pspell
php7-ast
php7-redis
php7-snmp
php7-doc
php7-mbstring
php7-lzf
php7-timezonedb
php7-dev
php7-xmlrpc
php7-stats
php7-embed
php7-xmlreader
php7-pdo_sqlite
php7-exif
php7-msgpack
php7-opcache
php7-ldap
php7-posix
php7-session
php7-gd
php7-gettext
php7-mailparse
php7-json
php7-xml
php7-mongodb
php7-iconv
php7-sysvshm
php7-curl
php7-shmop
php7-odbc
php7-phar
php7-pdo_pgsql
php7-imap
php7-pdo_dblib
php7-pgsql
php7-pdo_odbc
php7-xdebug
php7-zip
php7-apache2
php7-cgi
php7-ctype
php7-inotify
php7-amqp
php7-mcrypt
php7-readline
php7-wddx
php7-libsodium
php7-bcmath
php7-calendar
php7-tidy
php7-dom
php7-sockets
php7-zmq
php7-memcached
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
