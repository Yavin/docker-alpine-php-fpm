FROM alpine:3.5

RUN apk --update add \
        php5 \
        php5-bcmath \
        php5-dom \
        php5-ctype \
        php5-curl \
        php5-fpm \
        php5-gd \
        php5-iconv \
        php5-intl \
        php5-json \
        php5-mcrypt \
        php5-opcache \
        php5-openssl \
        php5-pdo \
        php5-pdo_mysql \
        php5-pdo_pgsql \
        php5-pdo_sqlite \
        php5-phar \
        php5-posix \
        php5-soap \
        php5-xml \
    && rm -rf /var/cache/apk/*

COPY php.ini /etc/php5/conf.d/50-setting.ini
COPY php-fpm.conf /etc/php5/php-fpm.conf

EXPOSE 9000

CMD ["php-fpm", "-F"]
