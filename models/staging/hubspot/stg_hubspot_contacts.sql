{{ config(
    enabled = table_exists('hubspot', 'contacts'),
    schema = tenant_schema(),
    tags = ['hubspot']
) }}

select *
from {{ source('hubspot', 'contacts') }}