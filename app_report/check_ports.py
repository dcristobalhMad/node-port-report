from kubernetes import client, config
import subprocess
import yaml
import boto3
import datetime
import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

config.load_incluster_config()

# Create Kubernetes API client
api_client = client.CoreV1Api()

# Retrieve list of nodes in the cluster
nodes = api_client.list_node().items

# Function to check if a port is open on a node
def check_port(node, port):
    try:
        cmd = f"nc -z -w 1 {node.status.addresses[0].address} {port}"
        subprocess.check_output(cmd, shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

# Function to parse the YAML file and retrieve the whitelist ports
def parse_yaml(file_path):
    whitelist_ports = []
    with open(file_path, 'r') as yaml_file:
        data = yaml.safe_load(yaml_file)
        if 'whitelist_ports' in data:
            whitelist_ports = data['whitelist_ports']
    return whitelist_ports

# Iterate over each node and check open ports
def check_ports_on_nodes():
    results = {}
    for node in nodes:
        node_name = node.metadata.name
        print(f"Checking ports on node: {node_name}")

        # Retrieve whitelist ports from YAML file
        whitelist_ports = parse_yaml('whitelist.yaml')

        # Check all ports from 1 to 65535 excluding whitelist ports
        opened_ports = []
        for port in range(1, 65535):
            if port not in whitelist_ports:
                if check_port(node, port):
                    opened_ports.append(port)

        results[node_name] = opened_ports
        print(f"Opened ports on {node_name}: {opened_ports}")
        print("-" * 50)

    return results

try:

    # Run the port checking process
    results = check_ports_on_nodes()

    # Generate filename with today's date
    today = datetime.datetime.now().strftime('%Y-%m-%d')
    filename = f"opened_ports_{today}.txt"

    # Write results to a file
    with open(filename, 'w') as file:
        for node_name, opened_ports in results.items():
            file.write(f"{node_name}: {opened_ports}\n")

    print("Results saved to opened_ports file.")

    # Upload file to S3 bucket
    def upload_to_s3(file_path, bucket_name, object_key):
        s3_client = boto3.client('s3')
        s3_client.upload_file(file_path, bucket_name, object_key)

    # Specify your S3 bucket details
    s3_bucket_name = 's3-report-bucket-diego'
    s3_object_key = filename


    upload_to_s3(filename, s3_bucket_name, s3_object_key)
    print("File uploaded to S3 successfully.")
    raise ValueError('A very specific bad thing happened.')

except Exception as e:
    error_message = f"Error occurred while running the script: {str(e)}"

    # Email configuration
    smtp_server = 'smtp.gmail.com'
    smtp_port = 587
    sender_email = 'alertsender2023@gmail.com'
    receiver_email = 'diecristher@gmail.com'
    email_subject = 'Script Execution Failed'

    # Create the email message
    message = MIMEMultipart()
    message['From'] = sender_email
    message['To'] = receiver_email
    message['Subject'] = email_subject
    amazing_password = os.environ.get('MAIL_PASSWORD')
    # Attach error message to the email
    message.attach(MIMEText(error_message, 'plain'))

    # Connect to SMTP server and send the email
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(sender_email, amazing_password)
        server.send_message(message)

    print(f"Error occurred while running the script. Email notification sent.")