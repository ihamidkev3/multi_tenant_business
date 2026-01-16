{% macro table_exists(source_name, table_name) %}

{% set relation = source(source_name, table_name) %}

{% set relation_exists = adapter.get_relation(
    database=relation.database,
    schema=relation.schema,
    identifier=relation.identifier
) %}

{% if relation_exists is not none %}
    {{ return(true) }}
{% else %}
    {{ return(false) }}
{% endif %}

{% endmacro %}
