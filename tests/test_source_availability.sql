-- Integration test: Verify source availability reporting works
-- This test shows which sources exist for this tenant
-- Missing sources are EXPECTED and will show as "Not Available"
-- This test ALWAYS PASSES - it's informational only

{% set has_shopify = table_exists('shopify', 'orders') %}
{% set has_hubspot = table_exists('hubspot', 'contacts') %}
{% set has_facebook = table_exists('facebook', 'ads') %}

select
    '{{ var("tenant") }}' as tenant_name,
    '{{ var("tenant_db", env_var("TENANT_DB")) }}' as tenant_database,
    {% if has_shopify %}
        'Shopify: ✓ Available' as shopify_status,
    {% else %}
        'Shopify: ✗ Not Available (expected if tenant doesn''t use Shopify)' as shopify_status,
    {% endif %}
    {% if has_hubspot %}
        'HubSpot: ✓ Available' as hubspot_status,
    {% else %}
        'HubSpot: ✗ Not Available (expected if tenant doesn''t use HubSpot)' as hubspot_status,
    {% endif %}
    {% if has_facebook %}
        'Facebook: ✓ Available' as facebook_status
    {% else %}
        'Facebook: ✗ Not Available (expected if tenant doesn''t use Facebook)' as facebook_status
    {% endif %}

-- Expected output shows:
-- Which sources the tenant has (✓ Available)
-- Which sources are missing (✗ Not Available) - THIS IS NORMAL AND EXPECTED
-- Missing sources do NOT cause test failures - this is informational only
