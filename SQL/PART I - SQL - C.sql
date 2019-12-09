/*
Question:
We are interested in the spending patterns of non standard vs standard users. 
Write a query to show the number of days where the average card payments volume of non standard users 
is less than standard users.

Assumption for standard:
	standard = "STANDARD"
	non-standard = ("PREMIUM_OFFER","METAL","METAL_FREE","PREMIUM_FREE","PREMIUM")

Assumption for average card payment:
	assuming volume is avg card payment amounts
	
Assumption: only days which are in both sets
	only assumed days which are in both standard and non-standard are considered
	

*/




select count(*)
from (
		-- standard 
	select * 
	from(
		select transc.created_date::DATE as daily,
			  count(*) as standard_count, 
			  avg(amount_usd) as standard_transc_avg
		from public.users users
		left join public.transactions transc 
		ON users.user_id = transc.user_id
		where transc.transactions_type = 'CARD_PAYMENT'
		and users.plan = 'STANDARD'
		group by daily

	) standard 
	join (
		--- non-standard 
		select transc.created_date::DATE as daily,
			  count(*) as non_standard,
			  avg(amount_usd) as non_standard_transc_avg
		from public.users users
		left join public.transactions transc 
		ON users.user_id = transc.user_id
		where transc.transactions_type = 'CARD_PAYMENT'
		and users.plan != 'STANDARD'
		group by daily
	) non_standard ON non_standard.daily = standard.daily
	
) sub

where sub.non_standard_transc_avg < sub.standard_transc_avg
