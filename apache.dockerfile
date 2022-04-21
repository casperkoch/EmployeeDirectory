# This file is based on:
# https://www.cloudsavvyit.com/10528/how-to-use-docker-to-containerise-php-and-apache/
# https://www.section.io/engineering-education/dockerized-php-apache-and-mysql-container-development-environment/

FROM php:8.0-apache

# Enable mod rewrite
RUN a2enmod rewrite

# Enable pdo mysql
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql
RUN apt-get update && apt-get upgrade -y

# Change document root
# https://stackoverflow.com/questions/51393494/how-to-change-the-document-root-in-php7-1-apache-from-docker-compose-yml
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

EXPOSE 80
