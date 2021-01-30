// main.go
package main

import (
	"fmt"
	"context"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/events"
)

func handler(ctx context.Context, s3Event events.S3Event) {
  fmt.Printf("start run the code samir marin")
  for _, record := range s3Event.Records {
    s3 := record.S3
    fmt.Printf("[%s - %s] Bucket = %s, Key = %s \n", record.EventSource, record.EventTime, s3.Bucket.Name, s3.Object.Key)
  }
}


func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}

