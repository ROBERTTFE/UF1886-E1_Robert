#!/bin/bash
cd "$(dirname "$0")"
echo "⚠️  Esto eliminará contenedores Y datos de QA"
read -p "¿Estás seguro? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    docker compose -p "uf1886-qa" -f docker-compose.qa.yml down -v
    echo "✓ Limpieza completa de QA realizada"
fi
