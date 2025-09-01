# 1️⃣ Imagen base con PHP 8.2 y Apache
FROM php:8.2-apache

# 2️⃣ Instalar extensiones de PHP necesarias
RUN apt-get update && apt-get install -y unzip git curl \
    && docker-php-ext-install mysqli pdo pdo_mysql

# 3️⃣ Habilitar mod_rewrite para .htaccess
RUN a2enmod rewrite

# 4️⃣ Configurar DocumentRoot en public/
RUN sed -i 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's|AllowOverride None|AllowOverride All|' /etc/apache2/apache2.conf

# 5️⃣ Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 6️⃣ Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# 7️⃣ Copiar proyecto al contenedor
COPY . /var/www/html/

# 8️⃣ Establecer permisos
RUN chown -R www-data:www-data /var/www/html

# 9️⃣ Instalar dependencias de Composer
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# 🔟 Instalar dependencias de npm
RUN npm install

# 1️⃣1️⃣ Exponer puerto 80
EXPOSE 80

# 1️⃣2️⃣ Iniciar Apache
CMD ["apache2-foreground"]
