# Testing Guide

Integration tests show which sources each tenant has. Missing sources are **expected** - tests don't fail.

## Quick Test

```bash
# Check which sources a tenant has
dbt test --select test_source_availability --vars '{"tenant": "TENANT1", "tenant_db": "tenant1_db"}'
```

**Output:**
- ✓ Available - Tenant has this source
- ✗ Not Available - Tenant doesn't have this source (normal!)

## Integration Tests

**Source Availability:** Shows which sources exist for tenant
```bash
dbt test --select test_source_availability --vars '{"tenant": "TENANT1", "tenant_db": "tenant1_db"}'
```

**Conditional Execution:** Verifies mart handles missing sources
```bash
dbt test --select test_conditional_execution --vars '{"tenant": "TENANT1", "tenant_db": "tenant1_db"}'
```

**Schema Isolation:** Verifies tenant schema isolation
```bash
dbt test --select test_tenant_isolation --vars '{"tenant": "TENANT1", "tenant_db": "tenant1_db"}'
```

## Automated Testing

```bash
# Test multiple tenants
./scripts/test_tenants.sh
```

Update tenant names in script to match your environment.

## Key Points

- Missing sources are normal - not all tenants have all sources
- Tests are informational - they show what exists
- NULL values are expected for missing sources
- Schema isolation is verified automatically
