{{ config(
    enabled = table_exists('shopify', 'orders'),
    schema = tenant_schema(),
    tags = ['shopify']
) }}

select *
from {{ source('shopify', 'orders') }}