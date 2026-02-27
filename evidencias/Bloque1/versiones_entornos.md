# Versiones por entornos (DEV / QA / PROD)

## Comandos utilizados

## Odoo

- `sudo docker exec -it odoo-dev odoo --version`
- `sudo docker exec -it odoo-qa odoo --version`
- `sudo docker exec -it odoo-prod odoo --version`

### PostgreSQL

- `sudo docker exec -it postgres-dev postgres --version`
- `sudo docker exec -it postgres-qa postgres --version`
- `sudo docker exec -it postgres-prod postgres --version`

### Apache Hop

- Imagen detectada por `Docker ps -a`: `apache/hop:2.17.0`
- `sudo docker exec hop-dev /opt/hop/hop-conf.sh -v`
- `sudo docker exec hop-qa /opt/hop/hop-conf.sh -v`
- `sudo docker exec hop-prod /opt/hop/hop-conf.sh -v`

---

## Tabla de versiones

| Entorno | Odoo | PostgreSQL | Hop |
| --- | --- | --- | --- |
| DEV | Odoo Server 18.0-20251121 | postgres (PostgreSQL) 16.11 | apache/hop:2.17.0 |
| QA | Odoo Server 18.0-20252221 | postgres (PostgreSQL) 16.11 | apache/hop:2.17.0 |
| PROD | Odoo Server 18.0-20252221 | posgres (PostgreSQL) 16.11 | apache/hop:2.17.0 |

---

## Observaciones

- Odoo y PostgreSQL están alineados en los tres entornos (misma version).
- Hop también está alineado por el tag de la imagen (`2.17.0`).