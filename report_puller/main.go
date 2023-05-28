package main

import (
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func main() {
	// Define your AWS region and S3 bucket name
	region := "us-east-1"
	bucket := "s3-report-bucket-diego"

	// Get the current date
	currentDate := time.Now().Format("2006-01-02") // Format: YYYY-MM-DD

	// Define the S3 object key using the current date
	objectKey := fmt.Sprintf("opened_ports_%s.txt", currentDate)

	// Create an AWS session
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
	if err != nil {
		fmt.Println("Failed to create session:", err)
		return
	}

	// Create an S3 client
	svc := s3.New(sess)

	// Create a file to write the downloaded data
	file, err := os.Create(objectKey)
	if err != nil {
		fmt.Println("Failed to create file:", err)
		return
	}
	defer file.Close()

	// Create an S3 input parameter
	input := &s3.GetObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(objectKey),
	}

	// Download the file from S3
	result, err := svc.GetObject(input)
	if err != nil {
		fmt.Println("Failed to download file:", err)
		return
	}

	// Copy the S3 object data to the local file
	_, err = file.ReadFrom(result.Body)
	if err != nil {
		fmt.Println("Failed to write file:", err)
		return
	}

	fmt.Println("File downloaded successfully:", objectKey)
}
