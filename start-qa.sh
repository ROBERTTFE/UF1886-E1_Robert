#!/bin/bash
cd "$(dirname "$0")"
docker compose -p "uf1886-qa" -f docker-compose.qa.yml up -d
echo ""
echo "✓ Odoo QA iniciando..."
echo "  La primera vez puede tardar 1-2 minutos en inicializar la BD"
echo ""
echo "  Ver logs: ./logs-qa.sh"
echo "  Acceder: http://localhost:8070"
