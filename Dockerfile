# Use an official PHP-FPM runtime as a parent image
FROM php:7.4-fpm

# Update and upgrade the base image packages
RUN apt-get update && apt-get upgrade -y

# Install Apache web server and required PHP extensions
RUN apt-get install -y --no-install-recommends \
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
    sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf && \
    sed -i 's/\<VirtualHost \*:80/VirtualHost \*:8080/g' /etc/apache2/sites-available/000-default.conf && \
    echo "SetEnvIf Authorization \"(.*)\" HTTP_AUTHORIZATION=\$1" >> /etc/apache2/apache2.conf

# Expose port 80 for incoming traffic
EXPOSE 8080

# Start Apache web server with PHP-FPM
CMD ["apache2-foreground"]
