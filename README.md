# Multi-Tenant dbt Project

Tenant-aware dbt pipeline with:
- dynamic source database selection via `tenant_db`
- tenant schema isolation via `tenant_schema()`
- conditional staging model enablement via `table_exists()`
- stable mart outputs when some sources are missing
- source-level tests/freshness are skipped to prevent failures when tenants do not have all source tables
- model-level tests are applied at the staging model level

## Architecture

- Staging layer reflects physical reality. If a source table does not exist, the staging model is disabled.
- Mart layer stays enabled to keep a stable DAG and contract. Missing sources return empty, typed fallback CTEs.
- `mart_tenant` outputs one row per `customer_id` with platform IDs aggregated as arrays (`order_ids`, `contact_ids`, `ad_ids`).
- `array_agg(... order by ...)` is used for deterministic array ordering.
- `mart_tenant` array outputs are compatible with adapters that support array data types/functions.


## Project Structure
```text
multi_tenants/
├── macros/
│   ├── macros.yml                    # Macro docs
│   ├── table_exists.sql              # Source existence check
│   └── tenant_schema.sql             # Tenant schema helper
├── models/
│   ├── sources/sources.yml           # Tenant-aware source definitions
│   ├── staging/                      # Conditionally enabled staging models
│   └── marts/
│       ├── mart_tenant.sql           # Customer mart with array ID outputs
│       └── mart_tenant.yml           # Mart column docs
└── scripts/
    └── tenants.sh                    # Single-tenant runner helper
```

## Required Vars

- `tenant` (example: `TENANT1`)
- `tenant_db` (example: `tenant1_db`)

## Quick Start

```bash
pip install -r requirements.txt
pip install dbt-snowflake  # or your adapter

dbt run --vars '{"tenant":"TENANT1","tenant_db":"tenant1_db"}'
```

## Tenant Script

Run one tenant:

```bash
./scripts/tenants.sh TENANT1 tenant1_db
```

What it does:
1. Runs `dbt run` for the tenant.
2. Runs `dbt run-operation table_exists` for:
   - `shopify.orders`
   - `hubspot.contacts`
   - `facebook.ads`

## Common Commands

```bash
dbt run --vars '{"tenant":"TENANT1","tenant_db":"tenant1_db"}'
dbt run --select staging --vars '{"tenant":"TENANT1","tenant_db":"tenant1_db"}'
dbt run-operation table_exists --args '{"source_name":"shopify","table_name":"orders"}' --vars '{"tenant":"TENANT1","tenant_db":"tenant1_db"}'
```


## Resources

- https://docs.getdbt.com/
- https://docs.getdbt.com/docs/build/jinja-macros#variables

## License

MIT. See `LICENSE`.
