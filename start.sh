#!/bin/sh
set -e

UID=${UID:-1000}
GID=${GID:-1000}

CURRENT_UID=$(id -u www-data)
CURRENT_GID=$(id -g www-data)

if [ "$CURRENT_GID" != "$GID" ]; then
    groupmod -o -g "$GID" www-data
fi

if [ "$CURRENT_UID" != "$UID" ]; then
    usermod -o -u "$UID" www-data
fi

chown -R www-data:www-data /var/www

cd /var/www/html

if [ -f composer.json ]; then
    echo "Running composer update..."
    composer update
fi

exec apache2-foreground
