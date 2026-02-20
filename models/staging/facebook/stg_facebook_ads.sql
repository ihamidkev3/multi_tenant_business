-- Multi-tenant safe staging:
-- This model only builds if the source table exists.
-- Due to multi-tenancy, some tenants may not have the Facebook Ads table.
-- Instead of running source tests/freshness here (which would fail if missing),
-- the test logic is integrated into the staging/mart models.

{{ config(
    enabled = table_exists('facebook', 'ads'),
    schema = tenant_schema(),
    tags = ['facebook']
) }}

select 
    ad_id,
    customer_id
from {{ source('facebook', 'ads') }}