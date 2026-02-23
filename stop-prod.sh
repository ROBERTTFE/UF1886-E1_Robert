#!/bin/bash
cd "$(dirname "$0")"
docker compose -p "uf1886-prod" -f docker-compose.prod.yml down
echo "✓ Odoo PROD detenido"
