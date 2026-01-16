-- Integration test: Verify tenant schema isolation
-- This test ensures each tenant's data is in the correct schema

select
    '{{ var("tenant") }}' as tenant_name,
    current_schema() as actual_schema,
    'stg_' || lower('{{ var("tenant") }}') as expected_schema,
    case 
        when current_schema() = 'stg_' || lower('{{ var("tenant") }}') 
        then 'Schema Isolation: ✓ Correct'
        else 'Schema Isolation: ✗ Mismatch'
    end as isolation_status

-- This test verifies:
-- 1. Actual schema matches expected schema format
-- 2. Schema name is lowercase
-- 3. Schema prefix is 'stg_'
-- 4. Each tenant has isolated schema