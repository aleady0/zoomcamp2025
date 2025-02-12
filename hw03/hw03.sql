-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `nytaxi.ny_taxi.yellow_taxi_2024_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://zoomcamp2005al/yellow_taxi_2024_data/*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE `nytaxi.ny_taxi.yellow_tripdata_non_partitioned` AS
SELECT * FROM `nytaxi.ny_taxi.yellow_taxi_2024_ext`;

-- Q1
select COUNT(*)
FROM `nytaxi.ny_taxi.yellow_tripdata_partitioned`;

-- Q2 Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables. 
-- 0
select distinct(PULocationID)
FROM `nytaxi.ny_taxi.yellow_taxi_2024_ext`;
-- 155.12 MB
select distinct(PULocationID)
FROM `nytaxi.ny_taxi.yellow_tripdata_non_partitioned`;

-- Q4
select count(fare_amount)
FROM `nytaxi.ny_taxi.yellow_tripdata_partitioned`
WHERE fare_amount = 0;

-- Q5
CREATE OR REPLACE TABLE `nytaxi.ny_taxi.yellow_tripdata_part_clust`
PARTITION BY
  DATE(tpep_dropoff_timedate)
  CLUSTER BY VendorID  AS
SELECT * FROM `nytaxi.ny_taxi.yellow_taxi_2024_ext`;

--  Q6
-- Scanning 310.24 MB of data
SELECT DISTINCT(VendorID)
FROM `nytaxi.ny_taxi.yellow_tripdata_non_partitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Scanning ~26.84 MB of DATA
SELECT DISTINCT(VendorID)
FROM `nytaxi.ny_taxi.yellow_tripdata_part_clust`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Q7
-- GCP Bucket

-- Q8
-- False


