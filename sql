-- Failed value 8406636.27
select sum(amount_inr)fact_transactions from fact_transactions
where status = 'Failed';

-- Failure Rate 
select round(100.0*sum(status = 'Failed')/count(*),2) as overall_failure_rate
from fact_transactions;

-- 1. the overall success rate, around 94%
select round(100.0*sum(status = 'Success')/count(*),2) as overall_success_rate
from fact_transactions;

-- 2. which banks have the lowest success rate: 8	Yes Bank	90.69
select t.bank_id, b.bank_name, round(100.0*count(case when t.status = 'success' then 1 end)/count(*),2) as success_rate
from fact_transactions t
join dim_bank b
on t.bank_id = b.bank_id
group by t.bank_id, b.bank_name
order by success_rate asc;


-- 3. which hours look worst (look at the evening)
success rate per hour 21 hour looks worst
SELECT txn_hour, COUNT(*) AS txns,
       ROUND(100.0 * SUM(status = 'SUCCESS') / COUNT(*), 2) AS success_rate
FROM fact_transactions
GROUP BY txn_hour
ORDER BY success_rate ASC;

--  4. Insufficient Balance 4358 failure reason is the most common
select t.failure_reason_id, r.failure_reason, count(r.failure_reason)
from fact_transactions t
join dim_failure_reason r
on t.failure_reason_id = r.failure_reason_id
group by t.failure_reason_id, r.failure_reason
order by count(r.failure_reason) desc;

-- 5. whether any app stands out
-- Paytm stands out lowest success_rate that is 93.46
select t.app_id, a.app_name, round(100.0*sum(t.status = 'success')/count(*), 2) as total_success_rate
from fact_transactions t
join dim_app a
on t.app_id = a.app_id
group by t.app_id
order by total_success_rate desc;
