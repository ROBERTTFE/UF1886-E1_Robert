# 2.2 Verificación sintáctica

Módulo: Personalización de formato de ventas  
Archivo de manifiesto detectado: manifest  
Nombre esperado por Odoo: __manifest__.py  

---

## 1) Sintaxis Python

### 1.1 Comprobación del nombre del archivo (requisito Odoo)

__Objetivo:__ verificar que el manifiesto tiene el nombre requerido por Odoo para que el módulo sea reconocido.

__Comando ejecutado:__
```bash
ls -la

drwxrwxr-x 3 user user 4096 Feb 25 12:58 .
drwxrwxr-x 3 user user 4096 Feb 24 13:43 ..
-rw-rw-r-- 1 user user    0 Feb 24 13:43 __init__.py
-rw-rw-r-- 1 user user  334 Feb 25 12:58 __manifest__.py
drwxrwxr-x 2 user user 4096 Feb 25 12:20 views
```


```bash
contenido __manifest__.py

{
    "name": "Custom Sale Codes (Report)",
    "version": "1.0.0",
    "category": "Sales",
    "summary": "Añade referencia interna y código de barras al reporte de pedido.",
    "depends": ["sale"],
    "data": [
        "views/sale_report.xml",
    ],
    "installable": True,
    "application": False,
    "license": "LGPL-3"
}

```
## 2) Validación XML

__Objetivo:__ comprobar que el XML referenciado en el manifest está bien formado.

__Archivo referenciado:__

- views/sale_report.xml
  
### 2.1 Verificar la existencia del archivo

__Comando ejecutado:__

```bash


```
__Salida obtenida:__
```bash


```

### 2.2 Validación archivo XML (bien formado)
```bash
xmllint --noout views/sale_report.xml
echo $?
```
__Salida obtenida:__
```bash


```
__Resultado:__
- Código de retorno
- Interpretación:
  - 0 -> XML bien formado
  - Error -> indicar mensaje exacto