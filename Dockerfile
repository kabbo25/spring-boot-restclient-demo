FROM wordpress:5.8.1-php7.4-apache

# Install PostgreSQL PHP extensions
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install PG4WP plugin
RUN curl -o /tmp/pg4wp.zip https://downloads.wordpress.org/plugin/pg4wp.1.3.1.zip \
    && unzip /tmp/pg4wp.zip -d /usr/src/wordpress/wp-content/plugins/ \
    && rm /tmp/pg4wp.zip
