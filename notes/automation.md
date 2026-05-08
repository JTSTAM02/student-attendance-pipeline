## Gotchas & Fixes

### CloudWatch Logging
Lambda needs explicit permission to write logs.
Add `CloudWatchLogsFullAccess` to lambda-attendance-role.
In production use `AWSLambdaBasicExecutionRole` at creation time
which includes CloudWatch logging by default.
