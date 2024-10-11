FROM php:8.2.24-apache-bookworm

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install required apt packages
RUN apt-get update && apt-get install -y \
    git libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql


# Install Flarum
RUN mkdir -p /app && cd /app
RUN composer create-project flarum/flarum:v1.8.0 /app
RUN composer require flarum/extension-manager:*
RUN chown -R www-data:www-data /app
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

# Expose port
EXPOSE 80
