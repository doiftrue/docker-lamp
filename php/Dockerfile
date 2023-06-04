ARG PHP_VER
FROM php:${PHP_VER}-fpm

ARG UID=1000
ARG GUID=1000
ARG USER=www-data
ARG WORK_DIR=/var/app

RUN set -x; \
# WORK_DIR capabilities
    usermod -u $UID $USER; \
    groupmod -g $GUID $USER; \
	chown -R $USER:$USER $WORK_DIR; \
# OS Utilities
    apt-get update; \
    apt-get -y install \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    default-mysql-client \
    vim \
    nano \
    unzip \
    zip \
    wget \
    curl \
    git \
    tree \
    mc \
;

RUN set -x; \
# PHP Extensions
	docker-php-ext-install \
    gd \
    mysqli \
    pdo \
    #pdo_pgsql \
    #pgsql \
    pdo_mysql \
    mbstring \
    tokenizer \
    opcache \
    exif \
    intl \
    zip \
; \
# PHP imagick
	apt-get install -y libmagickwand-dev; \
    pecl install imagick; \
	docker-php-ext-enable imagick; \
# Install Composer
# See: https://getcomposer.org/download
	wget https://getcomposer.org/download/2.5.5/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer; \
# Install WP-CLI
# See: https://make.wordpress.org/cli/handbook/guides/installing/
# See: https://github.com/wp-cli/wp-cli/tags
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wget https://raw.githubusercontent.com/wp-cli/wp-cli/main/utils/wp-completion.bash \
    && mv wp-completion.bash /usr/local/include/wp-cli-completion.bash \
    && echo -e '\nsource /usr/local/include/wp-cli-completion.bash' >>  /etc/bash.bashrc;


## Configuring OS
RUN echo 'alias ll="ls -l --color"' >> /etc/bash.bashrc; \
# fix memory limit for php-cli
    echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

## Install cert to curl work correctly
COPY --chmod=644 ./certs/ROOT_CA_CERT/myRootCA.pem.crt /usr/local/share/ca-certificates/
RUN	apt-get install -y ca-certificates && update-ca-certificates

WORKDIR $WORK_DIR

# it's just for documentation (clearity)
EXPOSE 9000

USER $USER


