# Use a base image with Python runtime
FROM python:3.9

# Update the package lists and install netcat
RUN apt-get update && \
    apt-get install -y netcat

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code to the container
COPY . .


CMD ["python", "check_ports.py"]