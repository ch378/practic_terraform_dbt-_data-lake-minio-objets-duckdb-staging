from faker import Faker
import csv
import json
import random
from datetime import datetime, timedelta
from pathlib import Path


fake = Faker("fr_FR")

NUMBER_OF_TRANSACTIONS = 100_000

OUTPUT_DIR = Path(__file__).parent

CSV_FILE = OUTPUT_DIR / "transactions.csv"
JSON_FILE = OUTPUT_DIR / "transactions.json"


CURRENCIES = [
    "MAD",
    "EUR",
    "USD",
    "GBP",
]

COUNTRIES = [
    "MA",
    "FR",
    "ES",
    "DE",
    "GB",
    "US",
    "IT",
    "BE",
    "NL",
]

TRANSACTION_TYPES = [
    "CARD_PAYMENT",
    "CASH_WITHDRAWAL",
    "TRANSFER",
    "DIRECT_DEBIT",
    "ONLINE_PAYMENT",
    "BANK_TRANSFER",
]

PAYMENT_METHODS = [
    "CARD",
    "CASH",
    "BANK_TRANSFER",
    "DIRECT_DEBIT",
    "MOBILE",
]

STATUSES = [
    "SUCCESS",
    "FAILED",
    "PENDING",
    "CANCELLED",
]

MERCHANTS = [
    "Amazon",
    "Carrefour",
    "Marjane",
    "Jumia",
    "Glovo",
    "Uber",
    "Netflix",
    "Spotify",
    "Apple",
    "Google",
    "Decathlon",
    "IKEA",
    "Zara",
    "H&M",
    "Shell",
    "TotalEnergies",
]


def generate_transaction(transaction_number: int) -> dict:
    transaction_date = fake.date_time_between(
        start_date="-2y",
        end_date="now"
    )

    transaction = {
        "transaction_id": f"TRX{transaction_number:06d}",
        "customer_id": f"CUST{random.randint(1, 20_000):06d}",
        "account_id": f"ACC{random.randint(1, 30_000):06d}",
        "transaction_date": transaction_date.strftime("%Y-%m-%d %H:%M:%S"),
        "amount": round(random.uniform(5, 50_000), 2),
        "currency": random.choice(CURRENCIES),
        "transaction_type": random.choice(TRANSACTION_TYPES),
        "merchant": random.choice(MERCHANTS),
        "country": random.choice(COUNTRIES),
        "payment_method": random.choice(PAYMENT_METHODS),
        "status": random.choices(
            STATUSES,
            weights=[85, 7, 5, 3],
            k=1
        )[0],
    }

    return transaction


def generate_transactions():
    print(f"Generating {NUMBER_OF_TRANSACTIONS:,} transactions...")

    transactions = []

    for i in range(1, NUMBER_OF_TRANSACTIONS + 1):
        transactions.append(generate_transaction(i))

        if i % 10_000 == 0:
            print(f"{i:,} transactions generated")

    return transactions


def save_csv(transactions):
    fieldnames = [
        "transaction_id",
        "customer_id",
        "account_id",
        "transaction_date",
        "amount",
        "currency",
        "transaction_type",
        "merchant",
        "country",
        "payment_method",
        "status",
    ]

    with open(
        CSV_FILE,
        "w",
        newline="",
        encoding="utf-8"
    ) as file:

        writer = csv.DictWriter(
            file,
            fieldnames=fieldnames
        )

        writer.writeheader()
        writer.writerows(transactions)

    print(f"CSV created: {CSV_FILE}")


def save_json(transactions):
    with open(
        JSON_FILE,
        "w",
        encoding="utf-8"
    ) as file:

        json.dump(
            transactions,
            file,
            ensure_ascii=False,
            indent=2
        )

    print(f"JSON created: {JSON_FILE}")


def main():
    transactions = generate_transactions()

    save_csv(transactions)
    save_json(transactions)

    print()
    print("Generation completed.")
    print(f"Total transactions: {len(transactions):,}")


if __name__ == "__main__":
    main()