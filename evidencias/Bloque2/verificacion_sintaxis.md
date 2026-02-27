# 2.2 Verificación sintáctica

Módulo: Personalización de formato de ventas  
Archivo de manifiesto detectado: manifest  
Nombre esperado por Odoo: __manifest__.py  

---

## 1) Sintaxis Python

### 1.1 Comprobación del nombre del archivo (requisito Odoo)

__Objetivo:__ verificar que el manifiesto tiene el nombre requerido por Odoo para que el módulo sea reconocido.

__Comando ejecutado:__

```code

{
    "license": "LGPL-3",
    "name":"Personalización de formato de ventas",
    "data":[
        "views/sale_report.xml",
    ],
    "depends":[
        "sale",
    ]
}

```
