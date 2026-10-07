import duckdb
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent

CSV_FILE = BASE_DIR / "ingestion" / "transactions.csv"
DUCKDB_FILE = Path(__file__).resolve().parent / "banking.duckdb"


def load_transactions():
    print("Starting DuckDB ingestion")

    if not CSV_FILE.exists():
        raise FileNotFoundError(
            f"CSV file not found: {CSV_FILE}"
        )

    connection = duckdb.connect(str(DUCKDB_FILE))

    connection.execute("""
        CREATE OR REPLACE TABLE raw_transactions AS
        SELECT
            transaction_id,
            customer_id,
            account_id,
            CAST(transaction_date AS TIMESTAMP) AS transaction_date,
            CAST(amount AS DECIMAL(18, 2)) AS amount,
            currency,
            transaction_type,
            merchant,
            country,
            payment_method,
            status
        FROM read_csv_auto(?)
    """, [str(CSV_FILE)])

    count = connection.execute("""
        SELECT COUNT(*)
        FROM raw_transactions
    """).fetchone()[0]

    print(f"Transactions loaded: {count:,}")

    connection.close()

    print(f"DuckDB database created: {DUCKDB_FILE}")


if __name__ == "__main__":
    load_transactions()