/*
Question:
Daily sign-ups is an important metric to quantify the success of growth strategies and campaigns led by our country managers. 
Write a query to calculate the mean, the standard deviation and the median of weekly sign-ups per country.

Assumption:
	Assumed that I could use postgres functions for mean and standard deviation 

*/

select avg(new_users) as mean, 
	   stddev_pop(new_users) as standard_deviation, 
	   percentile_disc(0.5) within group (order by calculation.new_users) as median,
	   country
FROM (
	SELECT date_trunc('week', created_date) AS weekly,
		   count(user_id) AS new_users,
		   country
	FROM public.users
	GROUP BY weekly, country
	ORDER BY weekly
) calculation
GROUP BY country
ORDER BY country
