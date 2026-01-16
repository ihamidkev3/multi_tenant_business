{{ config(
    schema = tenant_schema(),
    tags = ['marts']
) }}

{% set has_shopify = table_exists('shopify', 'orders') %}
{% set has_hubspot = table_exists('hubspot', 'contacts') %}
{% set has_facebook = table_exists('facebook', 'ads') %}

with shopify as (
    {% if has_shopify %}
        select * from {{ ref('stg_shopify_orders') }}
    {% else %}
        select 
            cast(null as string) as order_id,
            cast(null as string) as customer_id
        where false
    {% endif %}
),
hubspot as (
    {% if has_hubspot %}
        select * from {{ ref('stg_hubspot_contacts') }}
    {% else %}
        select 
            cast(null as string) as contact_id
        where false
    {% endif %}
),
facebook as (
    {% if has_facebook %}
        select * from {{ ref('stg_facebook_ads') }}
    {% else %}
        select 
            cast(null as string) as ad_id
        where false
    {% endif %}
)

select
    s.order_id,
    s.customer_id,
    h.contact_id,
    f.ad_id
from shopify s
left join hubspot h
    on s.customer_id = h.contact_id
left join facebook f
    on h.contact_id = f.ad_id
