{% macro tenant_schema() %}
    {% if not var('tenant', none) %}
        {{ exceptions.raise_compiler_error("Required variable 'tenant' is not set. Please provide it via --vars") }}
    {% endif %}
    {% set tenant = var('tenant') %}
    {{ return('stg_' ~ lower(tenant)) }}
{% endmacro %}

