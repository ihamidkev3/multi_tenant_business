{{ config(
    schema = tenant_schema(),
    tags = ['marts']
) }}

{% set has_shopify = table_exists('shopify', 'orders') %}
{% set has_hubspot = table_exists('hubspot', 'contacts') %}
{% set has_facebook = table_exists('facebook', 'ads') %}

with shopify as (
    {% if has_shopify %}
        select 
            customer_id, 
            array_agg(order_id order by order_id) as order_ids
        from {{ ref('stg_shopify_orders') }}
        group by customer_id
    {% else %}
        select 
            cast(null as {{ dbt.type_string() }}) as customer_id,
            cast(null as {{ dbt.type_array() }}) as order_ids
        where false
    {% endif %}
),
hubspot as (
    {% if has_hubspot %}
        select 
            customer_id, 
            array_agg(contact_id order by contact_id) as contact_ids
        from {{ ref('stg_hubspot_contacts') }}
        group by customer_id
    {% else %}
        select 
            cast(null as {{ dbt.type_string() }}) as customer_id,
            cast(null as {{ dbt.type_array() }}) as contact_ids
        where false
    {% endif %}
),
facebook as (
    {% if has_facebook %}
        select 
            customer_id, 
            array_agg(ad_id order by ad_id) as ad_ids
        from {{ ref('stg_facebook_ads') }}
        group by customer_id
    {% else %}
        select 
            cast(null as {{ dbt.type_string() }}) as customer_id,
            cast(null as {{ dbt.type_array() }}) as ad_ids
        where false
    {% endif %}
),

customer_spine as (
    select customer_id from shopify
    where customer_id is not null
    union
    select customer_id from hubspot
    where customer_id is not null
    union
    select customer_id from facebook
    where customer_id is not null
)

select
    c.customer_id,
    s.order_ids,
    h.contact_ids,
    f.ad_ids
from customer_spine c
left join shopify s  on c.customer_id = s.customer_id
left join hubspot h  on c.customer_id = h.customer_id
left join facebook f on c.customer_id = f.customer_id
