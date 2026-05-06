# Session 10 - Automation & Scheduling

## AWS Resources Created

### Lambda Function
- **Name:** attendance-pipeline-trigger
- **Runtime:** Python 3.11
- **Timeout:** 15 minutes
- **Role:** lambda-attendance-role
- **What it does:** Triggers Glue crawler and waits for completion

### IAM Role
- **Name:** lambda-attendance-role
- **Policies:** AWSGlueServiceRole, AmazonAthenaFullAccess, AmazonS3FullAccess

### EventBridge Schedule
- **Name:** attendance-pipeline-daily
- **Cron:** 0 11 * * ? * (6am Eastern / 11am UTC daily)
- **Target:** attendance-pipeline-trigger Lambda function

## Key Concepts Learned
- boto3 = AWS SDK for Python, used to control AWS services programmatically
- Lambda = serverless functions, no server to manage
- EventBridge = cloud scheduling service, like cron but for AWS
- Cron expression 0 11 * * ? * = every day at 11am UTC
- Lambda default timeout is 3 seconds, always increase for pipeline triggers

## Automated Pipeline Flow
Every morning at 6am Eastern:
1. EventBridge triggers Lambda function
2. Lambda starts Glue crawler via boto3
3. Crawler scans S3 for new attendance files
4. Athena tables updated automatically
5. dbt models ready to rebuild with fresh data
