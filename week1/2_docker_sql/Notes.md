# WEEK 1 / Docker & SQL

## What is Docker?

Docker is a tool for running your applications inside containers. Containers package all the dependencies and code your app needs to run into a single file, which will run the same way on any machine.

Docker is similar in concept to Virtual Machines, except it’s much more lightweight. Instead of running an entire separate operating system (which is a massive overhead), Docker runs containers, which use the same host operating system, and only virtualize at a software level.

### Why do we need it?

Docker takes the same kind of version control and packaging that tools like Git and NPM provide and allows you to use it for your server software. Since your container is a single image, it makes it very easy to version track different builds of your container. And since everything is contained, it makes managing all of your dependencies much easier.

With Docker, your development environment will be exactly the same as your production environment, and exactly the same as everyone else’s development environment, alleviating the problem of “it’s broken on my machine!”

## Running postgreSQL on Docker

```bash
docker run -it \
-e POSTGRES_USER="root" \
-e POSTGRES_PASSWORD="root" \
-e POSTGRES_DB="ny_taxi" \
-v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
-p 5432:5432 \
postgres:13
```

## Running PgAdmin on Docker

```bash
docker run -it \
-e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
-e PGADMIN_DEFAULT_PASSWORD="root" \
-p 8080:80 \
dpage/pgadmin4
```

### Problem with running PgAdmin and Postgres as before

Docker containers are isolated VMs. This means that there is no way that they can interact with each other.
We need to create a network make containers be able to communicate with each other.

## Network

```bash
docker network create <<NAME OF THE NETWORK>>
```

In our case:

```bash
docker network create pg-network
```

## Let's re-write the postgresql and pgadmin execution with network

### Postgres

We will be adding the network to the command and we will be adding a name to the container, that will help us to refer to it within the Docker network (when we need to refer to it from pgadmin in 'hostname').

```bash
docker run -it \
-e POSTGRES_USER="root" \
-e POSTGRES_PASSWORD="root" \
-e POSTGRES_DB="ny_taxi" \
-v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
-p 5432:5432 \
--network=pg-network \
--name pg-database \
postgres:13
```

### PgAdmin

```bash
docker run -it \
-e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
-e PGADMIN_DEFAULT_PASSWORD="root" \
-p 8080:80 \
--network=pg-network \
--name pgadmin-2 \
dpage/pgadmin4
```

### Running data ingestion pipeline locally

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
# For the homework:
# URL="wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz"
# URL="wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"

python ingest_data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```

### Build Docker Image

```bash
docker build -t taxi_ingest:v001 .
```

### Run Dockerized pipeline

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

docker run -it \
    --network=pg-network \
    taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```

## Docker compose

Docker compose allows us to configure the setup or tear down of multiple docker containers at the same time.
The basic commands are ```docker compose up``` and ```docker compose down```.

### Running Postgres and PgAdming at the same time

```bash
Docker compose up
```

### Tear down the setup

```bash
docker compose down
```

### to make pgAdmin configuration persistent

Create a folder data_pgadmin. Change its permission via

```bash
sudo chown 5050:5050 data_pgadmin
```

and mount it to the /var/lib/pgadmin folder:

```yaml
services:
  pgadmin:
    image: dpage/pgadmin4
    volumes:
      - ./data_pgadmin:/var/lib/pgadmin
    ...
```
