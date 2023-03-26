# Use an official PHP-FPM runtime as a parent image
FROM php:7.4-fpm

# Install Apache web server and required PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    libapache2-mod-fcgid \
    libapache2-mod-php \
    && docker-php-ext-install mysqli pdo_mysql

# Copy the index.php file to the web server's document root
COPY index.php /var/www/html/index.php

# Configure Apache to use PHP-FPM and enable the necessary modules
RUN a2enmod proxy_fcgi setenvif && \
    a2enconf php7.4-fpm && \
    sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf && \
    echo "SetEnvIf Authorization \"(.*)\" HTTP_AUTHORIZATION=\$1" >> /etc/apache2/apache2.conf

# Expose port 80 for incoming traffic
EXPOSE 80

# Start Apache web server with PHP-FPM
CMD ["apache2-foreground"]