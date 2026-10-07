import boto3
from botocore.exceptions import ClientError
from pathlib import Path


MINIO_ENDPOINT = "http://localhost:9000"

MINIO_ACCESS_KEY = "admin"
MINIO_SECRET_KEY = "admin123456"

BUCKET_NAME = "banking-data"

LOCAL_FILE = Path(__file__).parent / "transactions.json"

MINIO_OBJECT = "raw/transactions/transactions.json"


def create_minio_client():
    return boto3.client(
        "s3",
        endpoint_url=MINIO_ENDPOINT,
        aws_access_key_id=MINIO_ACCESS_KEY,
        aws_secret_access_key=MINIO_SECRET_KEY,
        region_name="us-east-1",
    )


def create_bucket(client):
    try:
        client.head_bucket(
            Bucket=BUCKET_NAME
        )

        print(f"Bucket already exists: {BUCKET_NAME}")

    except ClientError:
        print(f"Creating bucket: {BUCKET_NAME}")

        client.create_bucket(
            Bucket=BUCKET_NAME
        )

        print("Bucket created successfully")


def upload_file(client):
    if not LOCAL_FILE.exists():
        raise FileNotFoundError(
            f"File not found: {LOCAL_FILE}"
        )

    print(f"Uploading: {LOCAL_FILE}")
    print(f"Destination: s3://{BUCKET_NAME}/{MINIO_OBJECT}")

    client.upload_file(
        str(LOCAL_FILE),
        BUCKET_NAME,
        MINIO_OBJECT
    )

    print("Upload completed successfully")


def main():
    print("Starting MinIO ingestion")

    client = create_minio_client()

    create_bucket(client)

    upload_file(client)

    print("Ingestion completed")


if __name__ == "__main__":
    main()