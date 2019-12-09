/*
Question:
We care about growth and also if users are engaged with our product. 
One of the many ways to track if they are “active” is from their card payment transactions. 
Write a query to calculate the volume of monthly card payment in USD per age group in the interval of 10?

Assumption for USD: 
	Assumed that card payment in USD referred to just using the amount_usd column rather than filtering on transactions_currency='USD'

Assumption for age groups:
	Assumed intervals upto 80 and then anything over 80 
	
Assumption for monthly:
	Assumed every month/year combination in the transcations records
	
Assumption for card payment:
	Assumed that taking transcation type as card payment

*/


select sum(amount_usd) as amount_usd,
	   monthly,
	   age_group
from(
	select sum(amount_usd) as amount_usd,
		   date_trunc('month', transc.created_date) AS monthly,
		   date_part('year', CURRENT_DATE) - users.birth_year as age,
		   case 
			  	when (date_part('year', CURRENT_DATE) - users.birth_year) = 10  then 'x <= 10'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 20 then '10 > x <= 20'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 30 then '20 > x <= 30'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 40 then '30 > x <= 40'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 50 then '40 > x <= 50'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 60 then '50 > x <= 60'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 70 then '60 > x <= 70'
				when (date_part('year', CURRENT_DATE) - users.birth_year) <= 80 then '70 > x <= 80'
				else 'x > 80'
		   end as age_group
	from public.users users
	left join public.transactions transc 
	ON users.user_id = transc.user_id
	where transc.transactions_type = 'CARD_PAYMENT'
	group by monthly, age
) sub 
group by monthly, age_group
order by monthly, age_group

