FROM composer AS fetch_cake
ARG cake_version=2.10.*
RUN composer require cakephp/cakephp $cake_version
COPY bootstrap-suffix.php .
WORKDIR vendor/cakephp/cakephp/app
RUN cat /app/bootstrap-suffix.php >> Config/bootstrap.php
RUN rm composer.json
RUN rm -r Vendor

FROM php:7.3-alpine
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY --from=fetch_cake /app/vendor/cakephp/cakephp /cakephp
WORKDIR /cakephp/app
RUN ln -s /plugin/Vendor
RUN apk add build-base autoconf
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
RUN apk del build-base autoconf
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD []
