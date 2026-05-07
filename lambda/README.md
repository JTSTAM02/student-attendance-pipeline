# Lambda Functions

## attendance_pipeline_trigger.py

Serverless function that triggers the attendance data pipeline.

### Trigger
- AWS EventBridge schedule
- Runs daily at 6am Eastern (11am UTC)
- Cron: `0 11 * * ? *`

### What It Does
1. Starts the Glue crawler `attendance-raw-crawler`
2. Polls crawler state every 15 seconds
3. Returns 200 success when crawler completes

### AWS Configuration
- Runtime: Python 3.11
- Timeout: 15 minutes
- IAM Role: lambda-attendance-role
- Region: us-east-2

### Dependencies
- boto3 (built into Lambda runtime, no install needed)

### Future Improvements
- Trigger dbt run after crawler completes
- Add CloudWatch alerting on failure
- Add Step Functions for more complex orchestration
