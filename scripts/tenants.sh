#!/usr/bin/env bash

set -euo pipefail

TENANT="${1:-TENANT1}"
TENANT_DB="${2:-tenant1_db}"
VARS="{\"tenant\":\"${TENANT}\",\"tenant_db\":\"${TENANT_DB}\"}"

echo "Tenant: ${TENANT}"
echo "Database: ${TENANT_DB}"
echo ""

echo "1) Running dbt run..."
dbt run --vars "${VARS}"
echo ""

echo "2) Checking source table existence with run-operation..."
dbt run-operation table_exists --args '{"source_name":"shopify","table_name":"orders"}' --vars "${VARS}"
dbt run-operation table_exists --args '{"source_name":"hubspot","table_name":"contacts"}' --vars "${VARS}"
dbt run-operation table_exists --args '{"source_name":"facebook","table_name":"ads"}' --vars "${VARS}"
echo ""

echo "Done."
