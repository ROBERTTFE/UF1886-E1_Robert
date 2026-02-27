# INFORME TÉCNICO FINAL  
Transporte de componentes entre entornos DEV → QA → PROD

Proyecto: UF1886_LAB  
Módulo transportado: Personalización de formato de ventas  
Fecha: (indicar fecha)  
Responsable: (indicar nombre)

---

# Descripción general del transporte

Se realiza el transporte del módulo desarrollado en entorno DEV hacia los entornos QA y PROD con el objetivo de validar su correcto funcionamiento y garantizar la estabilidad antes de su explotación definitiva.

El módulo modifica el formato del reporte de ventas mediante el archivo:

- views/sale_report.xml

---

# Pasos seguidos

## 2.1 Verificación en entorno DEV

- Validación sintaxis Python (`__manifest__.py`)
- Validación XML (`sale_report.xml`)
- Actualización del módulo en base de datos DEV
- Comprobación funcional del reporte modificado

Comandos utilizados:

```bash
python3 -m py_compile __manifest__.py
xmllint --noout views/sale_report.xml
docker exec -it odoo-dev bash -lc "odoo -d odoo_dev -u nombre_modulo --stop-after-init"
````

Resultado: entorno DEV estable y funcional.

---

## 2.2 Transporte a QA

- Sincronización del código mediante Git / rsync
- Actualización del módulo en entorno QA
- Revisión de logs del contenedor

Comando de actualización:

```bash

docker exec -it odoo-qa bash -lc "odoo -d odoo_qa -u nombre_modulo --stop-after-init"

```

Verificación:

- No aparecen errores en logs.
- El reporte se genera correctamente.
- No se detectan inconsistencias en la base de datos.

---

## 2.3 Transporte a PRODUCCIÓN

- Confirmación de estabilidad en QA
- Backup previo de base de datos PROD
- Actualización controlada del módulo
- Verificación funcional

Backup previo:

```bash
docker exec -it postgres-prod pg_dump -U odoo_prod odoo_prod > backup_pre_transporte.sql
```

Actualización módulo:

```bash
docker exec -it odoo-prod bash -lc "odoo -d odoo_prod -u nombre_modulo --stop-after-init"
```

Resultado: transporte completado sin incidencias críticas.

---

# Incidencias detectadas

| Nº | Incidencia                     | Entorno | Causa                                | Impacto             |
| -- | ------------------------------ | ------- | ------------------------------------ | ------------------- |
| 1  | Nombre incorrecto del manifest | DEV     | Archivo no llamado `__manifest__.py` | Módulo no detectado |
| 2  | (Si hubo alguna)               |         |                                      |                     |

Descripción detallada:

- Incidencia 1: Odoo no reconocía el módulo debido a nombre incorrecto del archivo manifest.
- Solución aplicada: Renombrado correcto del fichero.

---

# Acciones aplicadas

- Corrección del nombre del manifest.
- Validación sintáctica completa.
- Validación XML con xmllint.
- Actualización controlada en cada entorno.
- Backup previo en producción.
- Revisión de logs tras cada actualización.

---

# Resultado final del transporte

✔ El módulo se encuentra instalado en los tres entornos.
✔ El reporte personalizado funciona correctamente.
✔ No se detectan errores en logs tras la actualización.
✔ La base de datos mantiene integridad estructural.

Estado final: ESTABLE Y OPERATIVO.

---

# Posibles riesgos futuros

1. Cambios en estructura del modelo `sale.order` en futuras versiones.
2. Actualización de versión de Odoo que afecte a vistas heredadas.
3. Diferencias de versión PostgreSQL entre entornos.
4. Modificación directa de vistas en PROD sin control de versiones.
5. Transporte manual sin validación previa en QA.

---

# Recomendaciones técnicas

- Mantener control de versiones con Git.
- No actualizar directamente en producción sin pasar por QA.
- Realizar backups automáticos diarios.
- Documentar cada transporte con número de versión.
- Validar compatibilidad tras actualizaciones mayores de Odoo.

---

# CONCLUSIÓN FINAL

El transporte del módulo se ha realizado siguiendo procedimiento controlado, con validación sintáctica previa, pruebas intermedias en QA y actualización segura en producción.

No se detectan incidencias activas tras el despliegue.
````


---

Ahora vamos a hacerlo realmente profesional.

Pregunta crítica (solo una):

En tu procedimiento real, ¿hiciste **backup antes de actualizar producción** o actualizaste directamente?

Eso cambia la calidad del informe (y la nota en evaluación).
