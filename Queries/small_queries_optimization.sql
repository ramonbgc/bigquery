SELECT name, gender, SUM(number) AS total
FROM `bigquery-public-data.usa_names.usa_1910_2013`
GROUP BY name,gender
ORDER BY total DESC
LIMIT 10;


-- check the execution times
SELECT date_diff(end_time, start_time, MILLISECOND) as runtime, * FROM `region-us.INFORMATION_SCHEMA.JOBS` WHERE job_id in ('eL9zOSMXQE88t_KV6lmmfwLDUbVh!195f21f3602', 'bquxjob_7267c815_195f2204e2e'); 