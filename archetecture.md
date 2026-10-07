                         Terraform
                             |
                             v
                    +------------------+
                    | Docker Network   |
                    | data_network     |
                    +--------+---------+
                             |
          +------------------+------------------+
          |                  |                  |
          v                  v                  v
   +-------------+    +-------------+    +-------------+
   | PostgreSQL  |    |    MinIO    |    |    Redis    |
   |             |    |             |    |             |
   | Port: 5432  |    | Port: 9000  |    | Port: 6379  |
   +------+------+    +------+------+    +------+------+
          |                  |                  |
          |                  |                  |
     postgres_data      minio_data         redis_data
          |                  |                  |
          +------------------+------------------+
                             |
                             v
                    Data Engineering
                       Applications
                             |
              +--------------+--------------+
              |                             |
              v                             v
        Python Ingestion                  dbt
              |                             |
              v                             v
           MinIO                       PostgreSQL
            raw/                    staging / marts