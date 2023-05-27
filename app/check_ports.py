from kubernetes import client, config
import subprocess
import yaml

# Load Kubernetes configuration from default location
config.load_kube_config()

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
        for port in range(1, 10):
            if port not in whitelist_ports:
                if check_port(node, port):
                    opened_ports.append(port)

        results[node_name] = opened_ports
        print(f"Opened ports on {node_name}: {opened_ports}")
        print("-" * 50)

    return results

# Run the port checking process
results = check_ports_on_nodes()

# Write results to a file
with open('opened_ports.txt', 'w') as file:
    for node_name, opened_ports in results.items():
        file.write(f"{node_name}: {opened_ports}\n")

print("Results saved to opened_ports.txt file.")