-- Every customer must have exactly six statement months.
select customer_id
from {{ ref('fct_customer_month') }}
group by customer_id
having count(*) != 6
