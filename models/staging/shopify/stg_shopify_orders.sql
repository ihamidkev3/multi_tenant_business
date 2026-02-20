-- Multi-tenant safe staging:
-- This model only builds if the Shopify orders table exists.
-- Some tenants may not have Shopify, so running source-level tests/freshness here could fail.
-- Instead, all test logic is integrated into the staging and mart models.

{{ config(
    enabled = table_exists('shopify', 'orders'),
    schema = tenant_schema(),
    tags = ['shopify']
) }}

select 
    order_id,
    customer_id
from {{ source('shopify', 'orders') }}