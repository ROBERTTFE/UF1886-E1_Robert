# UF1886_LAB - Odoo Multi-Entorno

## ⚡ Inicio Rápido

### 1. Configurar secretos
```bash
# Generar contraseñas seguras
openssl rand -base64 32

# DEV
echo "TU_PASSWORD_POSTGRES" > secrets/dev/postgres_password
echo "TU_PASSWORD_ADMIN" > secrets/dev/odoo_admin_password

# QA
echo "TU_PASSWORD_POSTGRES" > secrets/qa/postgres_password
echo "TU_PASSWORD_ADMIN" > secrets/qa/odoo_admin_password

# PROD
echo "TU_PASSWORD_POSTGRES" > secrets/prod/postgres_password
echo "TU_PASSWORD_ADMIN" > secrets/prod/odoo_admin_password
```

### 2. Levantar entorno
```bash
# Desarrollo
./start-dev.sh

# QA
./start-qa.sh

# Producción
./start-prod.sh
```

**IMPORTANTE**: La primera vez tardará 1-2 minutos en inicializar la base de datos.

### 3. Acceder

- **DEV**: http://localhost:8069
- **QA**: http://localhost:8070  
- **PROD**: http://localhost:8071

**Usuario**: `admin`  
**Contraseña**: La configurada en `secrets/{env}/odoo_admin_password`

### Apache Hop Web UI

- **DEV**: http://localhost:8080
- **QA**: http://localhost:8081
- **PROD**: http://localhost:8082

Los workflows se almacenan en `hop/{env}/`.

## 🛠️ Comandos por Entorno

### DEV
```bash
./start-dev.sh       # Iniciar
./stop-dev.sh        # Parar
./logs-dev.sh        # Ver logs
./restart-dev.sh     # Reiniciar
./clean-dev.sh       # Limpiar (¡elimina datos!)
./shell-odoo-dev.sh      # Shell en Odoo
./shell-postgres-dev.sh  # psql en PostgreSQL
./shell-hop-dev.sh       # Shell en Apache Hop
```

### QA
```bash
./start-qa.sh
./stop-qa.sh
./logs-qa.sh
./restart-qa.sh
./clean-qa.sh
./shell-odoo-qa.sh
./shell-postgres-qa.sh
```

### PROD
```bash
./start-prod.sh
./stop-prod.sh
./logs-prod.sh
./restart-prod.sh
./clean-prod.sh
./shell-odoo-prod.sh
./shell-postgres-prod.sh
```

### General
```bash
./status.sh          # Ver estado de TODOS los entornos
```

## 🔧 PostgreSQL

PostgreSQL **NO está expuesto** al host. Solo accesible desde la red interna Docker.
```bash
# Acceder a PostgreSQL DEV
./shell-postgres-dev.sh

# Acceder a PostgreSQL QA
./shell-postgres-qa.sh

# Acceder a PostgreSQL PROD
./shell-postgres-prod.sh
```

Comandos útiles en psql:
```sql
\l          -- Listar bases de datos
\dt         -- Listar tablas
\du         -- Listar usuarios
\q          -- Salir
```

## 🔒 Seguridad

| Entorno       | Puerto Odoo | PostgreSQL    | Acceso BD desde host |
|---------------|-------------|---------------|----------------------|
| DEV           | 8069        | No expuesto   | ❌ No (solo Docker)  |
| QA            | 8070        | No expuesto   | ❌ No (solo Docker)  |
| PROD          | 8071        | No expuesto   | ❌ No (solo Docker)  |

✅ **Contraseñas en Docker Secrets** (nunca en texto plano)  
✅ **PostgreSQL aislado** en red interna  
✅ **Inicialización automática** de BD  
✅ **secrets/ excluido** de Git  

## 🐛 Troubleshooting

### Ver estado de todos los entornos
```bash
./status.sh
```

### Contenedor reiniciándose
```bash
# Ver logs del entorno problemático
./logs-dev.sh    # o logs-qa.sh, logs-prod.sh
```

### Limpiar y empezar de nuevo
```bash
# DEV
./clean-dev.sh
./start-dev.sh

# QA
./clean-qa.sh
./start-qa.sh

# PROD (¡CUIDADO!)
./clean-prod.sh
./start-prod.sh
```

## 📦 Estructura
```
UF1886_LAB/
├── docker-compose.dev.yml
├── docker-compose.qa.yml
├── docker-compose.prod.yml
├── secrets/
│   ├── dev/
│   ├── qa/
│   └── prod/
├── config/
│   ├── dev/odoo.conf
│   ├── qa/odoo.conf
│   └── prod/odoo.conf
├── addons/
│   ├── dev/
│   ├── qa/
│   └── prod/
├── hop/
│   ├── dev/
│   ├── qa/
│   └── prod/
├── backups/
├── scripts/
│   └── entrypoint.sh (genérico para todos los entornos)
└── *.sh (scripts para cada entorno)
```
