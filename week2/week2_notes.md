# Week 2 Notes

## What is a Data Lake?

Central repository that holds Big Data from many sources.

Data can be:

- Structured
- Semi-structured
- Unstructured

The goal is to ingest data as quickly as possible and make it available for other team members (Data Analysts, Data Scientists, Data Engineers, etc).

Its being used extensively in ML and analytical solutions

Generally when storing data in a Data Lake you would associate metadata for faster access.

Data lakes have to be secure and scalable, as well as have inexpensive hardware.

### Data Lake vs Data Warehouse

Data Lake:

Data: Unstructured \
Target Users: Data Scientist, Data Analysts \
Use Cases: Stream Processing, Machine Learning, Real Time Analysis.

Raw, Large (petabytes) and Undefined.

Data Warehouse:

Data: Structured \
Target Users: Business Analysts \
Use Cases: Batch Processing, BI, Reporting.

Refined, Smaller and Relational.

### ETL vs ELT

ETL mainly used for small amount of data. \
ELT is used for large amounts of data. Provides data lake support (Schema on read).

### Gotcha of Data Lake

- Data Lakes can convert into Data Swamps
- No versioning
- Incompatible schemas for same data without versioning
- No metadata associated
- Joins not possible

### Cloud providers for data lakes

- GCP - cloud storage
- AWS - S3
- AZURE - Azure Blob

## What is Workflow Orchestration?

Governing Data flow respecting Orchestration rules on business logic.

A data flow combines disparate applications together - these applications are often from many different vendors

Examples of disparate applications and services:

- A cleansing script in Pandas
- Data transformation with DBT
- ML use case

Workflow orchestration tools allow turning code into workflows can be scheduled, run abd observed

Workflow configurations include:

- The order of execution (of tasks)
- The packaging (Docker, Kubernetes, sub-process)
- The type of delivery (concurrency, async, Ray, DAGs, etc)

A workflow orchestration tool executes the workflow run

- Scheduling
- Remote execution
- Privacy
- Knows when to restart or retry an operation
- Visibility / Alerts
- Parametarization
- Integrates with many systems

Prefect is a modern, open source orchestration tool.
