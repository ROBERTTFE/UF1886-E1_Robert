#!/bin/bash
cd "$(dirname "$0")"
echo "═══════════════════════════════════════"
echo "Estado de TODOS los entornos"
echo "═══════════════════════════════════════"
echo ""

echo "DEV:"
if docker compose -p "uf1886-dev" -f docker-compose.dev.yml ps --quiet 2>/dev/null | grep -q .; then
  docker compose -p "uf1886-dev" -f docker-compose.dev.yml ps
else
  echo "  No iniciado"
fi
echo ""

echo "QA:"
if docker compose -p "uf1886-qa" -f docker-compose.qa.yml ps --quiet 2>/dev/null | grep -q .; then
  docker compose -p "uf1886-qa" -f docker-compose.qa.yml ps
else
  echo "  No iniciado"
fi
echo ""

echo "PROD:"
if docker compose -p "uf1886-prod" -f docker-compose.prod.yml ps --quiet 2>/dev/null | grep -q .; then
  docker compose -p "uf1886-prod" -f docker-compose.prod.yml ps
else
  echo "  No iniciado"
fi
