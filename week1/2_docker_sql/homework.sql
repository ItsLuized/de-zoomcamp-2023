-- Question 3. Count records
SELECT COUNT(1)
FROM yellow_taxi_trips
WHERE CAST(lpep_pickup_datetime AS DATE) = '2019-01-15'
AND CAST(lpep_dropoff_datetime AS DATE) = '2019-01-15'

-- Question 4. Largest trip for each day
SELECT CAST(lpep_pickup_datetime AS DATE), trip_distance
FROM yellow_taxi_trips
ORDER BY trip_distance DESC;

-- Question 5. The number of passengers
SELECT (SELECT COUNT(1)
FROM yellow_taxi_trips
WHERE passenger_count = 2
AND CAST(lpep_pickup_datetime AS DATE ) = '2019-01-01') AS two_passengers,
(SELECT COUNT(1)
FROM yellow_taxi_trips
WHERE passenger_count = 3
AND CAST(lpep_pickup_datetime AS DATE ) = '2019-01-01') AS three_passengers
FROM yellow_taxi_trips
LIMIT (1);

-- Question 6. Largest tip
SELECT zdo."Zone", t."tip_amount"
FROM yellow_taxi_trips t
LEFT JOIN zones zpu
ON zpu."LocationID" = t."PULocationID"
LEFT JOIN zones zdo
ON zdo."LocationID" = t."DOLocationID"
WHERE t."PULocationID" IN (7,8)
ORDER BY 2 DESC