FROM alpine:latest

RUN apk --update add \
        php-dom \
        php-ctype \
        php-curl \
        php-fpm \
        php-gd \
        php-iconv \
        php-intl \
        php-json \
        php-opcache \
        php-pdo \
        php-pdo_mysql \
        php-posix \
        php-xml \
    && rm -rf /var/cache/apk/*

COPY php.ini /etc/php/conf.d/50-setting.ini
COPY php-fpm.conf /etc/php/php-fpm.conf

VOLUME /app
EXPOSE 9000

CMD ["php-fpm", "-F"]
