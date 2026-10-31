-- Expected loss can never exceed the amount owed.
select customer_id
from {{ ref('fct_customer_risk') }}
where expected_loss > ead + 1
