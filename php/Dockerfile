ARG PHP_VER
FROM php:${PHP_VER}-fpm

ARG UID=1000
ARG GUID=1000
ARG USER=www-data
RUN usermod -u $UID $USER && groupmod -g $GUID $USER

# Configuring OS
RUN echo 'alias ll="ls -l --color"' >>  /etc/bash.bashrc
RUN chown -R $USER:$USER /var/www

RUN apt-get update

# OS Utilities
RUN apt-get -y install \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    tree \
    vim \
    unzip \
    zip \
    wget \
    curl \
    git \
    nano \
    mc

# PHP Extensions
RUN docker-php-ext-install \
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
    zip

# fix memory limit for php-cli
RUN echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

# Install Composer
# See: https://getcomposer.org/download
RUN wget https://getcomposer.org/download/2.5.5/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer

# Install WP-CLI
# See: https://make.wordpress.org/cli/handbook/guides/installing/
# See: https://github.com/wp-cli/wp-cli/tags
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /app

USER $USER


