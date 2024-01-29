-- Question 3. Count records

SELECT COUNT(1) 
FROM green_taxi_data
WHERE DATE(lpep_pickup_datetime) = '2019-09-18' 
AND DATE(lpep_dropoff_datetime) = '2019-09-18';

-- Question 4. Largest trip for each day

SELECT
    DATE_TRUNC('day', lpep_pickup_datetime) AS pickup_day,
   	SUM(trip_distance) AS total_trip_distance
FROM
    green_taxi_data
GROUP BY
    pickup_day
ORDER BY
    total_trip_distance DESC
LIMIT 1;

-- Question 5. Three biggest pick up Boroughs

SELECT z."Borough", SUM(g.total_amount) as total_amount_sum
FROM green_taxi_trips g
JOIN zones z ON g."PULocationID" = z."LocationID"
WHERE g.lpep_pickup_datetime >= '2019-09-18' 
 AND g.lpep_pickup_datetime < '2019-09-19' 
 AND z."Borough" != 'Unknown'
GROUP BY z."Borough"
HAVING SUM(g.total_amount) > 50000
ORDER BY total_amount_sum DESC
LIMIT 3;

-- Question 6. Largest tip

SELECT z."Zone"
FROM green_taxi_trips g
JOIN zones z ON g."DOLocationID" = z."LocationID"
WHERE g.tip_amount
IN (
    SELECT MAX(g.tip_amount)
    FROM green_taxi_trips g
    JOIN zones z ON g."PULocationID" = z."LocationID"
    WHERE DATE_TRUNC('month', g.lpep_pickup_datetime) = '2019-09-01'
      AND z."Zone" = 'Astoria'
    GROUP BY g."PULocationID",  z."Zone"
    ORDER BY MAX(g.tip_amount) DESC
    LIMIT 1
);
