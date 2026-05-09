# Student Attendance Data Pipeline

An end-to-end data engineering project built on AWS and dbt,
automating key education metrics for school districts.

## Architecture
Raw CSV → S3 → Glue → Athena → d AWS Lambda + Eventbridge (automated daily runs)

## Tech Stack
- **AWS S3** — data lake storage (Bronze/Silver/Gold layers)
- **AWS IAM** — security and access management
- **AWS Glue** — automated schema detection and data catalog
- **AWS Athena** — serverless SQL query engine
- **AWS Lambda** - serverless pipeline trigger function
- **dbt Core** — data transformation, testing, and documentation
- **Python + boto3** - Lambda function and AWS SDK
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
│   ├── staging/           # Raw data cleaned and typed
│   │   ├── stg_attendance.sql
│   │   ├── sources.yml
│   │   └── schema.yml
│   ├── intermediate/      # Business logic and flags
│   │   ├── int_attendance_daily.sql
│   │   └── schema.yml
│   └── marts/             # Final metrics for reporting
│       ├── mart_ada.sql
│       ├── mart_adm.sql
│       ├── mart_truancy.sql
│       └── schema.yml
├── tests/
│   └── assert_ada_between_0_and_100.sql
└── dbt_project.yml

## Data Quality
- 33 automated dbt tests covering null checks,
  accepted values, uniqueness, and business logic
- Custom ADA range test ensuring metrics stay between 0-100%
- Null-safe coalescing on critical columns
- Incremental loading - only processes new rows on each run

## ️ Automation

Pipeline runs automatically every morning at 6am Eastern:

1. **EventBridge** fires scheduled trigger
2. **Lambda** function wakes up (Python + boto3)
3. **Glue Crawler** scans S3 for new attendance files
4. **Athena** tables refreshed automatically
5. **dbt** rebuilds incremental models with new data
6. **33 tests** run to validate data quality
7. **CloudWatch** logs full execution for monitoring

## Incremental Loading

Models use `insert_overwrite` incremental strategy partitioned
by `attendance_date`. On each run dbt only processes new rows
since the last execution — critical for handling a full school
year of data efficiently at scale.

## Pipeline Lineage
raw_attendance (S3/Glue)
↓
stg_attendance
↓
int_attendance_daily
↓
mart_ada    mart_adm    mart_truancy

##  How to Run

### Prerequisites
- AWS account with S3, Glue, Athena, Lambda access
- Python 3.11+
- dbt-athena-community

### Setup
```bash
# Clone the repo
git clone https://github.com/JTSTAM02/student-attendance-pipeline.git
cd student-attendance-pipeline

# Create virtual environment
python3 -m venv dbt-env
source dbt-env/bin/activate

# Install dbt
pip install dbt-athena-community

# Configure AWS credentials
aws configure

# Run the pipeline
cd attendance_dbt
dbt build
```

## Session Notes

Detailed notes from each build session are in the `/notes` directory,
documenting key concepts, decisions, and lessons learned.
