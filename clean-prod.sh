#!/bin/bash
cd "$(dirname "$0")"
echo "⚠️  Esto eliminará contenedores Y datos de PROD"
read -p "¿Estás COMPLETAMENTE seguro? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    docker compose -p "uf1886-prod" -f docker-compose.prod.yml down -v
    echo "✓ Limpieza completa de PROD realizada"
fi
