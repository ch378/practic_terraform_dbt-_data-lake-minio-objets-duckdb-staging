# Terraform + MinIO + DuckDB + dbt — Data Lake & Data Engineering Platform

## Description

Ce projet est une plateforme de **Data Engineering locale** conçue pour mettre en pratique une architecture moderne de traitement et de transformation des données.

L'objectif est de construire une pipeline complète permettant de :

* Générer des données bancaires réalistes avec **Faker**
* Stocker les données brutes dans **MinIO**
* Charger les transactions dans **DuckDB**
* Transformer et nettoyer les données avec **dbt**
* Organiser les transformations selon les couches **Staging → Intermediate → Marts**
* Provisionner l'infrastructure locale avec **Terraform**
* Utiliser **Docker** pour exécuter les services
* Préparer l'architecture pour l'ajout futur d'un orchestrateur comme **Apache Airflow** ou **Dagster**
* Préparer les données finales pour leur exploitation dans des outils de Business Intelligence comme **Power BI**

Le projet reproduit ainsi, dans un environnement local, une architecture proche de celles utilisées dans des plateformes Data modernes.

---

## Architecture

```text
                         Terraform
                            |
                            v
                     Docker Infrastructure
                            |
             +--------------+--------------+
             |                             |
             v                             v
          MinIO                           Redis
       Data Lake                         Cache
             |
             | Raw Data
             v
      raw/transactions/
        transactions.json
             |
             |
             v
        DuckDB Database
       banking.duckdb
             |
             | raw_transactions
             v
        +------------+
        |    dbt     |
        +------------+
             |
             v
        STAGING
    stg_transactions
             |
             v
      INTERMEDIATE
     int_transactions
             |
             v
          MARTS
     mart_transactions
             |
             v
   mart_daily_transactions
             |
             v
      + automatisation par airflow /dagster /luigui
```

---

# 1. Data Generation

Les données bancaires sont générées automatiquement avec **Faker** et Python.

Le dataset contient 100 000 transactions avec les informations suivantes :

```text
transaction_id
customer_id
account_id
transaction_date
amount
currency
transaction_type
merchant
country
payment_method
status
```

Exemple :

```text
TRX000001
CUST001245
ACC004521
2026-08-15 14:32:10
1250.50
MAD
CARD_PAYMENT
Amazon
MA
CARD
SUCCESS
```

Les données sont volontairement synthétiques afin de pouvoir reproduire une architecture bancaire sans utiliser de données réelles ou sensibles.

---

# 2. MinIO — Data Lake

**MinIO** est utilisé comme stockage objet compatible avec l'API S3.

Les données brutes sont organisées dans un bucket :

```text
banking-data
```

Avec une structure :

```text
banking-data/
└── raw/
    └── transactions/
        └── transactions.json
```

Cette organisation permet de reproduire une logique de Data Lake :

```text
raw/
    |
    +-- transactions/
    |
    +-- customers/
    |
    +-- accounts/
    |
    +-- payments/
```

L'objectif est de conserver une copie des données originales avant transformation.

---

# 3. DuckDB — Analytical Storage

**DuckDB** est utilisé comme moteur analytique local.

Les transactions CSV sont chargées dans :

```text
data/storage/banking.duckdb
```

La table RAW principale est :

```text
main.raw_transactions
```

Elle contient les 100 000 transactions générées.

Le chargement est effectué avec Python et DuckDB :

```text
transactions.csv
       |
       v
DuckDB
       |
       v
main.raw_transactions
```

DuckDB permet ici de disposer d'un moteur SQL analytique léger et performant sans avoir besoin d'un serveur de base de données séparé.

---

# 4. dbt — Data Transformation

**dbt** est utilisé pour construire la couche de transformation.

Les modèles sont organisés en trois niveaux.

## Staging

```text
stg_transactions
```

Cette couche permet notamment de :

* Nettoyer les valeurs
* Standardiser les chaînes de caractères
* Convertir les types
* Standardiser les devises
* Standardiser les statuts
* Préparer les données pour les transformations métier

Exemple :

```sql
upper(trim(currency))
```

ou :

```sql
cast(amount as decimal(18, 2))
```

---

## Intermediate

```text
int_transactions
```

Cette couche contient la logique métier.

Exemples :

```text
is_successful
is_failed
is_pending
amount_category
```

Une transaction peut par exemple être classifiée :

```text
amount < 100       -> LOW
100 - 999          -> MEDIUM
>= 1000            -> HIGH
```

---

## Marts

La couche Marts contient les données prêtes à être utilisées par les outils analytiques.

### mart_transactions

Cette table contient les transactions nettoyées et enrichies.

```text
transaction_id
customer_id
account_id
transaction_date
transaction_date_day
amount
currency
transaction_type
merchant
country
payment_method
status
is_successful
is_failed
is_pending
amount_category
```

### mart_daily_transactions

Cette table fournit des agrégations quotidiennes :

```text
transaction_date_day
currency
total_transactions
total_amount
successful_transactions
failed_transactions
pending_transactions
average_transaction_amount
minimum_transaction_amount
maximum_transaction_amount
```

Elle peut ensuite être utilisée directement pour créer des dashboards BI.

---

# 5. Terraform — Infrastructure as Code

Terraform est utilisé pour définir et provisionner l'infrastructure locale.

L'objectif est d'éviter une configuration manuelle des services.

Architecture Terraform :

```text
terraform/
├── main.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── versions.tf
│
└── modules/
    ├── network/
    ├── redis/
    └── minio/
```

Terraform permet notamment de gérer :

* Le réseau Docker
* Les containers
* Les volumes
* MinIO
* Redis
* Les paramètres d'infrastructure

Le provider Docker utilisé est :

```text
kreuzwerker/docker
```

---

# 6. Docker

Docker permet d'exécuter les différents services dans un environnement local isolé.

Les principaux composants sont :

```text
Docker
│
├── MinIO
│
└── Redis
```

Terraform est utilisé pour déclarer et gérer ces ressources.

L'objectif est de reproduire une petite infrastructure Data Engineering sans dépendre directement d'un environnement cloud.

---

# 7. Redis

Redis est intégré à l'architecture comme couche de cache.

Il pourra notamment être utilisé dans de futures évolutions pour :

* Cacher des résultats fréquemment utilisés
* Accélérer certaines requêtes
* Stocker temporairement des informations
* Servir de composant intermédiaire entre plusieurs services
* Préparer une architecture orientée temps réel

---

# 8. Data Flow

Le pipeline actuel peut être résumé comme suit :

```text
             Faker
               |
               v
       Transaction Generator
               |
               +-------------------+
               |                   |
               v                   v
        transactions.csv    transactions.json
               |                   |
               v                   v
            DuckDB              MinIO
               |                   |
               v                   v
      raw_transactions        Raw Data Lake
               |
               v
             dbt
               |
               v
           Staging
               |
               v
         Intermediate
               |
               v
             Marts
               |
               v
  
```

---

# 9. Technologies utilisées

| Technologie | Utilisation                             |
| ----------- | --------------------------------------- |
| Python      | Génération et ingestion des données     |
| Faker       | Génération de transactions synthétiques |
| Terraform   | Infrastructure as Code                  |
| Docker      | Conteneurisation                        |
| MinIO       | Data Lake / Object Storage              |
| DuckDB      | Stockage analytique local               |
| dbt         | Transformation et modélisation          |
| Redis       | Cache / couche intermédiaire            |
| SQL         | Transformation des données              |


---

# 10. Objectifs Data Engineering

Ce projet permet de pratiquer plusieurs concepts importants du Data Engineering :

### Data Ingestion

```text
API / Generator
      |
      v
Raw Data
```

### Data Lake

```text
Raw files
   |
   v
MinIO
```

### Data Storage

```text
CSV
 |
 v
DuckDB
```

### Data Transformation

```text
Raw
 |
 v
Staging
 |
 v
Intermediate
 |
 v
Marts
```

### Infrastructure as Code

```text
Terraform
    |
    v
Docker Infrastructure
```

### Analytics

```text
Marts
  |
  v
+ si vous voulez  Power BI
```

---

# 11. Data Quality

Une évolution importante du projet sera l'ajout de contrôles de qualité avec dbt.

Par exemple :

```text
transaction_id NOT NULL
customer_id NOT NULL
account_id NOT NULL
amount >= 0
status IN ('SUCCESS', 'FAILED', 'PENDING', 'CANCELLED')
currency IS NOT NULL
```

Des tests dbt pourront être ajoutés afin de détecter automatiquement :

* Les valeurs NULL
* Les doublons
* Les valeurs invalides
* Les relations incorrectes
* Les anomalies dans les données

---

# 12. Évolution vers l'orchestration

Une prochaine étape du projet sera d'ajouter un **orchestrateur de pipelines** afin d'automatiser les différentes tâches.

Deux solutions sont particulièrement intéressantes :

## Apache Airflow

Airflow pourrait orchestrer le pipeline complet :

```text
Generate Transactions
        |
        v
Upload to MinIO
        |
        v
Load into DuckDB
        |
        v
Run dbt
        |
        v
Run Data Quality Tests
        |
        v
Refresh BI Dataset
```

Le DAG pourrait être organisé comme ceci :

```text
generate_data
      |
      v
upload_minio
      |
      v
load_duckdb
      |
      v
dbt_run
      |
      v
dbt_test
      |
      v
success
```

---

## Dagster

Une autre possibilité est d'utiliser **Dagster** pour gérer les assets de données.

L'architecture pourrait évoluer vers :

```text
                    Dagster
                       |
        +--------------+--------------+
        |              |              |
        v              v              v
    MinIO Asset    DuckDB Asset    dbt Assets
        |              |              |
        +--------------+--------------+
                       |
                       v
                     Marts
                       |
                       v
                   Power BI
```

Dagster permettrait notamment de mieux représenter les dépendances entre les différents assets de données et de suivre leur matérialisation.

---

# 13. Future Architecture

À terme, l'architecture pourrait évoluer vers :

```text
                         Terraform
                             |
                             v
                          Docker
                             |
          +------------------+------------------+
          |                  |                  |
          v                  v                  v
        MinIO              Redis             Airflow
     Data Lake             Cache            Orchestrator
          |                                    |
          |                                    |
          +----------------+-------------------+
                           |
                           v
                         DuckDB
                           |
                           v
                          dbt
                           |
              +------------+------------+
              |                         |
              v                         v
          Intermediate                Marts
                                        |
                                        v
                                    + Power BI
```

Une alternative à Airflow serait :

```text
Terraform
    |
    v
Docker
    |
    +---- MinIO
    |
    +---- Redis
    |
    +---- Dagster
             |
             v
           DuckDB
             |
             v
            dbt
             |
             v
           Marts
```

---

# 14. Roadmap

### Phase 1 — Data Generation

* [x] Génération de 100 000 transactions
* [x] Création CSV
* [x] Création JSON

### Phase 2 — Data Lake

* [x] Déploiement MinIO
* [x] Création du bucket
* [x] Upload des données RAW

### Phase 3 — Analytical Storage

* [x] Installation DuckDB
* [x] Création de `banking.duckdb`
* [x] Création de `raw_transactions`
* [x] Chargement des transactions

### Phase 4 — Transformation

* [x] Configuration dbt
* [x] Staging
* [x] Intermediate
* [x] Marts
* [x] Agrégations quotidiennes

### Phase 5 — Infrastructure

* [x] Terraform
* [x] Docker
* [x] Docker Network
* [x] MinIO
* [x] Redis

### Phase 6 — Data Quality

* [ ] Tests dbt avancés
* [ ] Détection des doublons
* [ ] Validation des montants
* [ ] Validation des statuts
* [ ] Monitoring de la qualité

### Phase 7 — Orchestration

* [ ] Apache Airflow ou Dagster
* [ ] Automatisation de l'ingestion
* [ ] Automatisation du chargement DuckDB
* [ ] Automatisation de dbt
* [ ] Automatisation des tests
* [ ] Gestion des erreurs
* [ ] Scheduling quotidien

### Phase 8 — Analytics + objectif data analyst

* [ ] Dashboard Power BI
* [ ] KPI transactions
* [ ] KPI montants
* [ ] Analyse par pays
* [ ] Analyse par devise
* [ ] Analyse des transactions échouées
* [ ] Analyse temporelle

---

# Conclusion

Ce projet constitue une **plateforme Data Engineering locale de bout en bout**, permettant de pratiquer les principales étapes d'un pipeline moderne :

```text
Generation
    ↓
Ingestion
    ↓
Data Lake
    ↓
Storage
    ↓
Transformation
    ↓
Data Quality
    ↓
Data Marts
    ↓
Business Intelligence
```

L'utilisation combinée de **Terraform, Docker, MinIO, DuckDB, dbt, Redis et Python** permet de construire une architecture reproductible et proche des pratiques utilisées dans les environnements professionnels.

La prochaine évolution sera l'ajout d'un orchestrateur comme **Apache Airflow ou Dagster** afin d'automatiser l'ensemble du pipeline et de passer d'une exécution manuelle à une véritable **pipeline Data Engineering orchestrée**.
screen terreform<img width="1920" height="1080" alt="Screenshot 2026-10-07 150018" src="https://github.com/user-attachments/assets/cc08c975-98b7-4b7a-8df7-33f1099724e1" />
dbvear pour visualisation de base de donnes<img width="1920" height="1020" alt="Screenshot 2026-10-07 162742" src="https://github.com/user-attachments/assets/7663829a-9a0c-4a53-9546-7c4b065401ce" />
<img width="1920" height="1020" alt="Screenshot 2026-10-07 162652" src="https://github.com/user-attachments/assets/031573ca-507e-4dcb-9256-1dc569589bfd" />
object storage <img width="1920" height="1080" alt="Screenshot 2026-10-07 145912" src="https://github.com/user-attachments/assets/1b87886a-3e9f-4c77-9223-7554e99cc37f" />



