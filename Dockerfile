# SQL Server Connector Image
# Based on Ubuntu 22.04 with SQL Server tools, Azure CLI, and ODBC development files

FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft repository keys and sources
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update package list after adding Microsoft repositories
RUN apt-get update

# Install SQL Server tools and ODBC development files
RUN apt-get install -y \
    mssql-tools18 \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add SQL Server tools to PATH
ENV PATH="$PATH:/opt/mssql-tools18/bin"

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Set working directory
WORKDIR /app

# Keep container running for docker exec access
CMD ["sleep", "infinity"]
