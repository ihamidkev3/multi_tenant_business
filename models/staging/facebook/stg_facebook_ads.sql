{{ config(
    enabled = table_exists('facebook', 'ads'),
    schema = tenant_schema(),
    tags = ['facebook']
) }}

select *
from {{ source('facebook', 'ads') }}