#!/bin/bash
cd "$(dirname "$0")"
docker compose -p "uf1886-dev" -f docker-compose.dev.yml restart
echo "✓ Odoo DEV reiniciado"
