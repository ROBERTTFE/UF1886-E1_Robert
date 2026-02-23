#!/bin/bash
set -e

echo "=== Entrypoint Personalizado - Odoo ==="

# Inyectar admin_passwd desde Docker Secret
if [ -f /run/secrets/odoo_admin_password ]; then
    ADMIN_PASS=$(cat /run/secrets/odoo_admin_password)
    echo "✓ Admin password cargada (${#ADMIN_PASS} caracteres)"
    sed "s/PLACEHOLDER_SECRET/${ADMIN_PASS}/" /etc/odoo/odoo.conf > /tmp/odoo.conf
else
    echo "⚠ No se encontró admin password"
    cp /etc/odoo/odoo.conf /tmp/odoo.conf
fi

# Leer password de PostgreSQL
if [ -f /run/secrets/postgres_password ]; then
    DB_PASSWORD=$(cat /run/secrets/postgres_password)
    echo "✓ DB password cargada (${#DB_PASSWORD} caracteres)"
else
    echo "✗ No se encontró postgres password"
    exit 1
fi

# Leer configuración de odoo.conf (funciona para cualquier entorno)
DB_HOST=$(grep "^db_host" /etc/odoo/odoo.conf | awk '{print $3}' | tr -d ' ')
DB_PORT=$(grep "^db_port" /etc/odoo/odoo.conf | awk '{print $3}' | tr -d ' ')
DB_NAME=$(grep "^db_name" /etc/odoo/odoo.conf | awk '{print $3}' | tr -d ' ')
DB_USER=$(grep "^db_user" /etc/odoo/odoo.conf | awk '{print $3}' | tr -d ' ')

echo "Configuración detectada:"
echo "  Host: $DB_HOST"
echo "  Puerto: $DB_PORT"
echo "  Base de datos: $DB_NAME"
echo "  Usuario: $DB_USER"

# Esperar a que PostgreSQL esté listo
echo "=== Esperando PostgreSQL ==="
MAX_TRIES=30
TRIES=0
until PGPASSWORD="${DB_PASSWORD}" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; do
    TRIES=$((TRIES + 1))
    if [ $TRIES -ge $MAX_TRIES ]; then
        echo "✗ PostgreSQL no responde después de $MAX_TRIES intentos"
        exit 1
    fi
    echo "PostgreSQL no disponible, esperando... ($TRIES/$MAX_TRIES)"
    sleep 2
done
echo "✓ PostgreSQL listo"

# Verificar si la BD necesita inicialización
echo "=== Verificando estado de la BD ==="
TABLE_COUNT=$(PGPASSWORD="${DB_PASSWORD}" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | tr -d ' ')

if [ "$TABLE_COUNT" = "0" ] || [ -z "$TABLE_COUNT" ]; then
    echo "⚠ Base de datos vacía, inicializando con módulo base..."
    echo "   Esto puede tardar 1-2 minutos..."

    # ── FIX: se añaden --without-demo y --load-language ──────────────────────
    odoo \
        --config=/tmp/odoo.conf \
        --db_password="${DB_PASSWORD}" \
        -i base \
        --stop-after-init \
        --without-demo=all \
        --load-language=es_ES
    # ─────────────────────────────────────────────────────────────────────────

    echo "✓ Base de datos inicializada"

    # ── FIX: actualizar contraseña del usuario admin desde Docker Secret ──────
    # Odoo crea el usuario admin con password "admin" por defecto al hacer -i base.
    # Aquí la sobreescribimos con la misma clave que se usa como master password,
    # que ya proviene del secret odoo_admin_password.
    # Odoo detectará en el primer login que es texto plano y la hasheará solo.
    echo "=== Actualizando contraseña del usuario admin ==="

    # Escapar caracteres especiales para SQL
    ADMIN_PASS_ESCAPED=$(printf '%s' "${ADMIN_PASS}" | sed "s/'/''/g")

    PGPASSWORD="${DB_PASSWORD}" psql \
        -h "$DB_HOST" \
        -p "$DB_PORT" \
        -U "$DB_USER" \
        -d "$DB_NAME" \
        -c "UPDATE res_users SET password = '${ADMIN_PASS_ESCAPED}' WHERE login = 'admin';"

    echo "✓ Contraseña del usuario admin actualizada correctamente"
    # ─────────────────────────────────────────────────────────────────────────

else
    echo "✓ Base de datos ya inicializada ($TABLE_COUNT tablas)"
fi

# Iniciar Odoo en modo normal
echo "=== Iniciando Odoo ==="
exec odoo \
    --config=/tmp/odoo.conf \
    --db_password="${DB_PASSWORD}"
