-- Create an external table with data on gcs
CREATE OR REPLACE EXTERNAL TABLE
  `dezoomcamp_2023.external-fhv-tripdata` OPTIONS ( format = 'CSV',
    uris = ['gs://de-zoomcamp-2023/fhv/fhv_tripdata_2019-*.csv.gz'] );

-- Create a BigQuery table from a external table
CREATE OR REPLACE TABLE `dezoomcamp_2023.fhv-tripdata_non_partitioned` AS
SELECT * FROM `dezoomcamp_2023.external-fhv-tripdata`;

-- Question 1.
-- What is the count for fhv vehicle records for year 2019?
SELECT COUNT(*) FROM `dezoomcamp_2023.external-fhv-tripdata` LIMIT 1;
-- Answer: 43,244,696

-- Question 2.
-- Write a query to count the distinct number of affiliated_base_number for the entire dataset on both the tables.
-- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
SELECT COUNT(DISTINCT(affiliated_base_number)) FROM `dezoomcamp_2023.external-fhv-tripdata`;
-- Ans: 0 B

SELECT COUNT(DISTINCT(affiliated_base_number)) FROM `dezoomcamp_2023.fhv-tripdata_non_partitioned`;
-- Ans: 317.94 MB

-- Question 3.
-- How many records have both a blank (null) PUlocationID and DOlocationID in the entire dataset?
SELECT COUNT(*) FROM `dezoomcamp_2023.fhv-tripdata_non_partitioned` WHERE PUlocationID IS NULL AND DOlocationID IS NULL;
-- Ans: 717,748

-- Question 4.
-- What is the best strategy to optimize the table if query always filter by pickup_datetime and order by affiliated_base_number?
-- - [ ] Cluster on pickup_datetime Cluster on affiliated_base_number
-- - [x] Partition by pickup_datetime Cluster on affiliated_base_number
-- - [ ] Partition by pickup_datetime Partition by affiliated_base_number
-- - [ ] Partition by affiliated_base_number Cluster on pickup_datetime

-- Question 5.
-- Implement the optimized solution you chose for question 4.
-- Write a query to retrieve the distinct affiliated_base_number between pickup_datetime 2019/03/01 and 2019/03/31 (inclusive).
-- Use the BQ table you created earlier in your from clause and note the estimated bytes.
-- Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed.
-- What are these values? Choose the answer which most closely matches.
CREATE OR REPLACE TABLE `dezoomcamp_2023.fhv_tripdata_partitioned_clustered`
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM `dezoomcamp_2023.external-fhv-tripdata`;

SELECT DISTINCT(affiliated_base_number) from `dezoomcamp_2023.fhv-tripdata_non_partitioned` WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';
-- Ans: 647.87 MB

SELECT DISTINCT(affiliated_base_number) from `dezoomcamp_2023.fhv_tripdata_partitioned_clustered` WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';
-- Ans: 23.05 MB

-- Question 6.
-- Where is the data stored in the External Table you created?
-- Ans: GCP Bucket

-- Question 7.
-- It is best practice in Big Query to always cluster your data:
-- Ans: False


