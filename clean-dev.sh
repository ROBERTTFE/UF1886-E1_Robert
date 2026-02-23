#!/bin/bash
cd "$(dirname "$0")"
echo "⚠️  Esto eliminará contenedores Y datos de DEV"
read -p "¿Estás seguro? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    docker compose -p "uf1886-dev" -f docker-compose.dev.yml down -v
    echo "✓ Limpieza completa de DEV realizada"
fi
