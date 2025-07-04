# SQL Server Connector Image Requirements

We need a Docker image based on Ubuntu 22.04 with the following components installed:

1. SQL Server Connector (mssql-tools18)
2. Azure CLI (az)
3. ODBC Development Files

## Installation Commands

The following commands should be included in the Dockerfile or setup script:

```bash
# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Add Microsoft repository keys and sources
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Update package list and install required packages
sudo apt-get update
sudo apt-get install -y mssql-tools18 unixodbc-dev
```

This setup will allow for:
- Easy database connection testing
- Azure cloud integration
- ODBC connectivity

## Deployment Requirement: Container Accessibility

**Important**: The Docker container must remain running after deployment to allow access via `docker exec` for debugging and maintenance purposes.

### Problem
By default, if a Docker container runs a command and then finishes, the container will exit and become inaccessible. This prevents using `docker exec` to access the container for troubleshooting, maintenance, or interactive debugging.

### Solution
To keep the container running indefinitely, we implement one of the following approaches:

#### Option 1: Use a long-running process as the main command
```dockerfile
# Keep container running with a sleep command
CMD ["sleep", "infinity"]
```

#### Option 2: Use tail to keep container alive
```dockerfile
# Keep container running by tailing a log file
CMD ["tail", "-f", "/dev/null"]
```

#### Option 3: Run a service or daemon
```dockerfile
# Run a service that keeps the container active
CMD ["bash", "-c", "while true; do sleep 30; done"]
```

### Usage After Deployment
Once deployed with any of the above solutions, you can access the running container using:
```bash
docker exec -it <container_name_or_id> /bin/bash
```

This allows for:
- Interactive debugging and troubleshooting
- Running SQL Server connection tests
- Executing Azure CLI commands
- Performing maintenance tasks
- Accessing logs and configuration files
