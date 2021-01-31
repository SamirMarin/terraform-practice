// main.go
package main

import (
  "io/ioutil"
  "encoding/json"
	"fmt"
	"context"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/events"
  "github.com/aws/aws-sdk-go/service/s3"
  "github.com/aws/aws-sdk-go/aws/session"
  "github.com/aws/aws-sdk-go/aws"
)

func handler(ctx context.Context, s3Event events.S3Event) {
  fmt.Printf("start run the code samir marin")
  for _, record := range s3Event.Records {
    s3_record := record.S3
    fmt.Printf("[%s - %s] Bucket = %s, Key = %s \n", record.EventSource, record.EventTime, s3_record.Bucket.Name, s3_record.Object.Key)

    svc := s3.New(session.New())

    input := s3.GetObjectInput{
      Bucket: aws.String(s3_record.Bucket.Name),
      Key:    aws.String(s3_record.Object.Key),
    }

    var events_cloudtrail map[string]interface{}
    fmt.Println("This is to test the reading of the object")
    o, err := svc.GetObject(&input)
    if err != nil {
      fmt.Println("Im in error one")
      fmt.Println("here is the test of error print" + err.Error())
    }
    b, err := ioutil.ReadAll(o.Body)
    if err != nil {
      fmt.Println("Im in error two")
      fmt.Println(err)
    }

    if err := json.Unmarshal(b, &events_cloudtrail); err != nil {
      fmt.Println("Im in error three")
      fmt.Errorf("Error unmarshaling cloutrail JSON: %s", err.Error())
    }

    fmt.Println("right before the print golang go woo")
    fmt.Println(events_cloudtrail)
  }
}


func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}

