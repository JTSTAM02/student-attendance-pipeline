import boto3
import time
import json


def lambda_handler(event, context):
    """
    Attendance Pipeline Trigger
    
    Triggered by EventBridge schedule every morning at 6am Eastern (11am UTC)
    Cron expression: 0 11 * * ? *
    
    Steps:
        1. Starts the Glue crawler to pick up new S3 files
        2. Waits for crawler to complete
        3. Returns success response
    
    In production this would also trigger a dbt run via
    Glue job or Step Functions after the crawler completes.
    """

    glue_client = boto3.client('glue', region_name='us-east-2')

    print("Starting attendance pipeline...")

    # Step 1 - Start the Glue crawler
    try:
        glue_client.start_crawler(Name='attendance-raw-crawler')
        print("Glue crawler started successfully")
    except glue_client.exceptions.CrawlerRunningException:
        print("Crawler already running, skipping...")

    # Step 2 - Wait for crawler to complete
    print("Waiting for crawler to complete...")
    while True:
        response = glue_client.get_crawler(Name='attendance-raw-crawler')
        state = response['Crawler']['State']
        print(f"Crawler state: {state}")

        if state == 'READY':
            print("Crawler completed successfully!")
            break
        elif state == 'STOPPING':
            time.sleep(10)
        else:
            time.sleep(15)

    # Step 3 - Log completion
    print("Pipeline trigger complete!")
    print("In production: dbt run would be triggered here via Glue job or Step Functions")

    return {
        'statusCode': 200,
        'body': json.dumps('Attendance pipeline triggered successfully!')
    }
