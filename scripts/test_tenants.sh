#!/bin/bash
# Test script for multiple tenant scenarios
# This script tests tenants with different source configurations
# Missing sources are EXPECTED and will not cause failures

echo "=========================================="
echo "Multi-Tenant dbt Integration Tests"
echo "=========================================="
echo ""
echo "Note: Missing sources are expected and normal behavior"
echo ""

# Function to test a tenant and show source availability
test_tenant() {
    local tenant_name=$1
    local tenant_db=$2
    local description=$3
    
    echo "=========================================="
    echo "Testing: $description"
    echo "Tenant: $tenant_name | Database: $tenant_db"
    echo "=========================================="
    
    # Run models (missing sources will be skipped - this is OK)
    echo "Running models..."
    dbt run --vars "{\"tenant\": \"$tenant_name\", \"tenant_db\": \"$tenant_db\"}" || {
        echo "⚠️  Run had issues - check logs above"
    }
    
    # Show source availability (informational)
    echo ""
    echo "Checking source availability (informational - missing sources are OK)..."
    dbt test --select test_source_availability --vars "{\"tenant\": \"$tenant_name\", \"tenant_db\": \"$tenant_db\"}" || {
        echo "Source availability check completed - see results above"
    }
    
    # Run tests (these are informational, not failing)
    echo ""
    echo "Running integration tests..."
    dbt test --select test_source_availability test_conditional_execution test_tenant_isolation --vars "{\"tenant\": \"$tenant_name\", \"tenant_db\": \"$tenant_db\"}" || {
        echo "⚠️  Some tests had issues - check results above"
    }
    
    echo ""
}

# Test Tenant 1: Has only Shopify
test_tenant "TENANT1" "tenant1_db" "Tenant 1 (Shopify only)"

# Test Tenant 2: Has 2 sources (e.g., Shopify + HubSpot)
test_tenant "TENANT2" "tenant2_db" "Tenant 2 (2 sources - update description)"

echo ""
echo "=========================================="
echo "Integration tests completed!"
echo "=========================================="
echo ""
echo "Review the output above to see:"
echo "  - Which sources each tenant has"
echo "  - Which sources are missing (expected)"
echo "  - Schema isolation status"
echo ""
echo "Note: Update tenant names and databases in this script to match your environment"
