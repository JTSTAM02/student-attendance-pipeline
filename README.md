# Student Attendance Data Pipeline

An end-to-end data engineering project built on AWS and dbt,
calculating key education metrics for school districts.

## Architecture
Raw CSV → S3 → Glue → Athena → dbt → Metrics

## Tech Stack
- **AWS S3** — data lake storage (Bronze/Silver/Gold layers)
- **AWS IAM** — security and access management
- **AWS Glue** — automated schema detection and data catalog
- **AWS Athena** — serverless SQL query engine
- **dbt Core** — data transformation, testing, and documentation
- **GitHub** — version control with branch-based PR workflow

## Metrics Built
| Metric | Description |
|--------|-------------|
| ADA | Average Daily Attendance by school |
| ADM | Average Daily Membership by school |
| Truancy Days | Total unexcused absences by student |
| Chronic Absenteeism | Students missing 10%+ of enrolled days |

## dbt Project Structure
attendance_dbt/
├── models/
│   ├── staging/        # Raw data cleaned and typed
│   ├── intermediate/   # Business logic and flags
│   └── marts/          # Final metrics for reporting
├── tests/              # Custom singular tests
└── dbt_project.yml

## Data Quality
- 15 automated dbt tests covering null checks,
  accepted values, uniqueness, and business logic
- Custom ADA range test ensuring metrics stay between 0-100%
- Null-safe coalescing on critical columns

## Pipeline Lineage
raw_attendance (S3/Glue)
↓
stg_attendance
↓
int_attendance_daily
↓
mart_ada    mart_adm    mart_truancy
