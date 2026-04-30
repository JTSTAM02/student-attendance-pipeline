
## What I Built
- IAM role: glue-attendance-role
- Glue database: attendance_glue_db
- Glue crawler: attendance-raw-crawler
- Crawler scans s3://student-attendance-tstamm-2024/raw/attendance/
- Table auto-created: attendance

## Key Concepts
- Glue Crawler = auto-detects schema from S3 files
- Data Catalog = stores table definitions Athena can query
- Always point crawlers at FOLDERS not files
- S3 + Glue + Athena = serverless data lake pipeline

## ADA Query
SELECT
    school_id,
    SUM(present) AS days_present,
    SUM(enrolled) AS days_enrolled,
    ROUND(SUM(present) * 100.0 / SUM(enrolled), 1) AS ada_pct
FROM attendance_glue_db.attendance
GROUP BY school_id;

