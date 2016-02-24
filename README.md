# Docker image for php-fpm

[![](https://badge.imagelayers.io/yavin/alpine-php-fpm:5.6.svg)](https://imagelayers.io/?images=yavin/alpine-php-fpm:5.6)

Tags:
* `latest`, `7.0`, `7.0.3` [Dokerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/master/Dockerfile)
* `5.6`, `5.6.17` [Dokerfile](https://github.com/Yavin/docker-alpine-php-fpm/blob/5.6/Dockerfile)

Image for php-fpm. It is based on Alpine linux and thats why it is very small (~60MB). Included extensions are required for Symfony framework 3+, that's why it should also work with other applications.
* PHP 5.6.17

## Running
```
docker run --rm -p 9000:9000 -v /path/of/application:/app yavin/alpine-php-fpm:5.6
```

Fallowing configuration allow to connect to this FPM setup:
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

Please note the path that is passed to FPM and compare it with the `docker run` command. Above example assume that the `/app/web` is the "public" folder of your app. If paths in PFM container are the same as in Nginx you can replace it with `$realpath_root` nginx variable.

## Custom php.ini settings
Create `Dockerfile` file with fallowing content and php.ini file with desired settings (look at php.ini file in this repository)
```
FROM yavin/alpine-php-fpm:5.6
COPY php.ini /etc/php/conf.d/50-setting.ini
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
FROM yavin/alpine-php-fpm:5.6
COPY php-fpm.conf /etc/php/php-fpm.conf
```

## Add extension that you need
```
FROM yavin/alpine-php-fpm:5.6
RUN apk --update add php-zip && rm -rf /var/cache/apk/*
```

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
