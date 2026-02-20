-- Multi-tenant safe staging:
-- This model only builds if the HubSpot contacts table exists.
-- Due to multi-tenancy, some tenants may not have HubSpot.
-- Instead of running source tests/freshness here (which would fail if missing),
-- the test logic is integrated into the staging/mart models.

{{ config(
    enabled = table_exists('hubspot', 'contacts'),
    schema = tenant_schema(),
    tags = ['hubspot']
) }}

select 
    contact_id,
    customer_id
from {{ source('hubspot', 'contacts') }}