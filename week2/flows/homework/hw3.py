from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(retries=3)
def extract_from_gcs(color: str, year: int, month: int) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load("de-zoomcamp-gcs")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"data/")
    return Path(f"{gcs_path}")


@task()
def read(path: Path) -> pd.DataFrame:
    """Data cleaning example"""
    return pd.read_parquet(path)


@task()
def write_bq(df: pd.DataFrame) -> None:
    """Write DataFrame to BiqQuery"""

    gcp_credentials_block = GcpCredentials.load("gcp-credentials")

    df.to_gbq(
        destination_table="dezoomcamp.rides",
        project_id="prefect-sbx-community-eng",
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append",
    )


@flow(log_prints=True)
def etl_gcs_to_bq(months: list[int], year: int, color: str):
    """Main ETL flow to load data into Big Query"""
    rows_processed: int = 0
    for month in months:
        path: Path = extract_from_gcs(color, year, month)
        df: pd.DataFrame = read(path)
        rows_processed += df.shape[0]
        write_bq(df)
    print(f"Number of rows processed: {rows_processed}")


if __name__ == "__main__":
    color = "yellow"
    year = 2019
    months = [2, 3]
    etl_gcs_to_bq(months, year, color)
