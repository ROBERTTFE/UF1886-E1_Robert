#!/bin/bash
# =============================================================
# Script de entrega — Ejercicio Práctico E1
# Alumno: Robert Machón
# Archivo final: Robert_Machón_CE1.4.zip
# =============================================================

set -e

PROYECTO="$HOME/UF1886_LAB"
ENTREGA="$HOME/entrega_CE1.4"
ZIP_NOMBRE="Robert_Machón_CE1.4"

echo ""
echo "=================================================="
echo "  PREPARACIÓN DE ENTREGA — E1 UF1886"
echo "  Alumno: Robert Machón"
echo "  ZIP: ${ZIP_NOMBRE}.zip"
echo "=================================================="
echo ""

# ── 1. Crear estructura de carpetas ──────────────────────────
echo "▶ Creando estructura de carpetas..."

mkdir -p "${ENTREGA}/evidencias/BLOQUE1"
mkdir -p "${ENTREGA}/evidencias/BLOQUE2"
mkdir -p "${ENTREGA}/evidencias/BLOQUE3"

echo "  ✓ evidencias/BLOQUE1/"
echo "  ✓ evidencias/BLOQUE2/"
echo "  ✓ evidencias/BLOQUE3/"

# ── 2. Copiar evidencias desde el proyecto ───────────────────
echo ""
echo "▶ Copiando archivos de evidencias..."

# BLOQUE 1
SRC="${PROYECTO}/evidencias"

copiar() {
  local origen="$1"
  local destino="$2"
  local nombre="$3"
  if [ -f "${origen}/${nombre}" ]; then
    cp "${origen}/${nombre}" "${destino}/${nombre}"
    echo "  ✓ ${destino##*/entrega_CE1.4/}/${nombre}"
  else
    # Crear plantilla vacía si el archivo no existe todavía
    echo "# ${nombre} — PENDIENTE DE COMPLETAR" > "${destino}/${nombre}"
    echo "  ⚠ ${destino##*/entrega_CE1.4/}/${nombre}  ← CREADO VACÍO (falta completar)"
  fi
}

copiar "${SRC}/BLOQUE1" "${ENTREGA}/evidencias/BLOQUE1" "componentes_identificados.md"
copiar "${SRC}/BLOQUE1" "${ENTREGA}/evidencias/BLOQUE1" "versiones_entornos.md"

copiar "${SRC}/BLOQUE2" "${ENTREGA}/evidencias/BLOQUE2" "transporte_dev_qa.md"
copiar "${SRC}/BLOQUE2" "${ENTREGA}/evidencias/BLOQUE2" "verificacion_sintaxis.md"
copiar "${SRC}/BLOQUE2" "${ENTREGA}/evidencias/BLOQUE2" "transporte_etl_qa.md"
copiar "${SRC}/BLOQUE2" "${ENTREGA}/evidencias/BLOQUE2" "logs_qa.txt"

copiar "${SRC}/BLOQUE3" "${ENTREGA}/evidencias/BLOQUE3" "transporte_qa_prod.md"
copiar "${SRC}/BLOQUE3" "${ENTREGA}/evidencias/BLOQUE3" "interpretacion_doc_ingles.md"

# informe_final.md va en BLOQUE3 Y en la raíz de evidencias
copiar "${SRC}/BLOQUE3" "${ENTREGA}/evidencias/BLOQUE3" "informe_final.md"
if [ -f "${SRC}/BLOQUE3/informe_final.md" ]; then
  cp "${SRC}/BLOQUE3/informe_final.md" "${ENTREGA}/evidencias/informe_final.md"
  echo "  ✓ evidencias/informe_final.md  (copia en raíz)"
else
  echo "# informe_final.md — PENDIENTE DE COMPLETAR" > "${ENTREGA}/evidencias/informe_final.md"
  echo "  ⚠ evidencias/informe_final.md  ← CREADO VACÍO (falta completar)"
fi

# ── 3. Copiar backups si existen ─────────────────────────────
echo ""
echo "▶ Comprobando backups de base de datos..."
if ls "${PROYECTO}/backups/"*.dump 1>/dev/null 2>&1; then
  mkdir -p "${ENTREGA}/evidencias/BLOQUE3/backups"
  cp "${PROYECTO}/backups/"*.dump "${ENTREGA}/evidencias/BLOQUE3/backups/"
  echo "  ✓ Backups copiados en evidencias/BLOQUE3/backups/"
else
  echo "  ⚠ No se encontraron backups en ${PROYECTO}/backups/"
  echo "    Asegúrate de haber ejecutado pg_dump antes del transporte a PROD."
fi

# ── 4. Verificar estructura final ────────────────────────────
echo ""
echo "▶ Estructura de la carpeta de entrega:"
echo ""
find "${ENTREGA}" -type f | sort | while read -r f; do
  rel="${f##*/entrega_CE1.4/}"
  size=$(wc -c < "$f")
  if [ "$size" -gt 50 ]; then
    echo "  ✅  ${rel}"
  else
    echo "  ⚠   ${rel}  ← archivo vacío o plantilla sin completar"
  fi
done

# ── 5. Crear el ZIP ───────────────────────────────────────────
echo ""
echo "▶ Creando archivo ZIP..."

cd "$HOME"
zip -r "${ZIP_NOMBRE}.zip" "entrega_CE1.4/" -x "*.DS_Store" -x "__MACOSX/*"

ZIP_PATH="$HOME/${ZIP_NOMBRE}.zip"
ZIP_SIZE=$(du -sh "${ZIP_PATH}" | cut -f1)

echo ""
echo "=================================================="
echo "  ✅  ZIP creado correctamente"
echo "  📦  ${ZIP_PATH}"
echo "  📏  Tamaño: ${ZIP_SIZE}"
echo "=================================================="
echo ""

# ── 6. Verificación final ─────────────────────────────────────
echo "▶ Contenido del ZIP:"
unzip -l "${ZIP_PATH}" | tail -n +4 | head -n -2 | awk '{print "  " $4}'

echo ""
echo "=================================================="
echo "  PENDIENTES ANTES DE ENTREGAR:"
echo ""

# Detectar archivos con "PENDIENTE" en su contenido
PENDIENTES=0
while IFS= read -r -d '' f; do
  if grep -q "PENDIENTE" "$f" 2>/dev/null; then
    echo "  ⚠  ${f##*/entrega_CE1.4/}  ← completar con datos reales"
    PENDIENTES=$((PENDIENTES + 1))
  fi
done < <(find "${ENTREGA}" -type f -name "*.md" -print0)

if [ "$PENDIENTES" -eq 0 ]; then
  echo "  ✅  Todos los archivos están completados."
fi

echo ""
echo "  Recuerda añadir las CAPTURAS DE PANTALLA a los .md"
echo "  correspondientes antes de generar el ZIP final."
echo "=================================================="
echo ""