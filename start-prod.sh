#!/bin/bash
cd "$(dirname "$0")"
docker compose -p "uf1886-prod" -f docker-compose.prod.yml up -d
echo ""
echo "✓ Odoo PROD iniciando..."
echo "  La primera vez puede tardar 1-2 minutos en inicializar la BD"
echo ""
echo "  Ver logs: ./logs-prod.sh"
echo "  Acceder: http://localhost:8071"
