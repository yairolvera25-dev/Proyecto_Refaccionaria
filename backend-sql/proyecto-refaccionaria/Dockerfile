FROM php:8.2-cli

# Instalar dependencias necesarias para Laravel y TiDB
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip default-mysql-client

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar directorio
WORKDIR /app
COPY . .

# Instalar dependencias del proyecto
RUN composer install --no-interaction --optimize-autoloader

# Render usa un puerto dinámico, le decimos a Laravel que lo escuche
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-10000}
