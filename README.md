# Linux SQL Server Debugger

[![Build and Push Docker Image](https://github.com/greatbody/linux-sqlserver-debugger/actions/workflows/docker-build-push.yml/badge.svg)](https://github.com/greatbody/linux-sqlserver-debugger/actions/workflows/docker-build-push.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)

A containerized debugging and testing environment for SQL Server connectivity on Linux systems. This Docker image provides a complete toolset for database administrators, developers, and DevOps engineers who need to troubleshoot SQL Server connections, test database queries, and manage Azure SQL resources from a Linux environment.

## 🚀 Features

- **SQL Server Tools**: Pre-installed `mssql-tools18` with `sqlcmd` for direct database connectivity
- **Azure CLI Integration**: Full Azure CLI support for cloud database management
- **ODBC Connectivity**: Complete ODBC development files for custom applications
- **Ubuntu 22.04 Base**: Modern, stable Linux environment
- **Multi-Architecture Support**: Compatible with both AMD64 and ARM64 platforms
- **Interactive Access**: Container remains running for `docker exec` debugging sessions
- **Automated CI/CD**: GitHub Actions workflow for automated builds and publishing

## 📋 Prerequisites

- Docker installed on your system
- Basic knowledge of SQL Server and Docker commands

## 🛠️ Quick Start

### Option 1: Use Pre-built Image (Recommended)

Pull and run the latest image from GitHub Container Registry:

```bash
# Pull the latest image
docker pull ghcr.io/greatbody/linux-sqlserver-debugger:latest

# Run the container
docker run -d --name sql-debugger ghcr.io/greatbody/linux-sqlserver-debugger:latest

# Access the container
docker exec -it sql-debugger /bin/bash
```

### Option 2: Build from Source

Clone the repository and build locally:

```bash
# Clone the repository
git clone https://github.com/greatbody/linux-sqlserver-debugger.git
cd linux-sqlserver-debugger

# Build the image
./build.sh

# Run the container
./run.sh
```

## 📖 Usage Examples

### Connecting to SQL Server

Once inside the container, you can use `sqlcmd` to connect to SQL Server instances:

```bash
# Connect to a local SQL Server instance
sqlcmd -S localhost -U sa -P YourPassword

# Connect to Azure SQL Database
sqlcmd -S your-server.database.windows.net -U your-username -P your-password -d your-database

# Connect using integrated authentication
sqlcmd -S your-server -E
```

### Using Azure CLI

The container includes Azure CLI for managing cloud resources:

```bash
# Login to Azure
az login

# List SQL servers
az sql server list

# Create a database
az sql db create --resource-group myResourceGroup --server myServer --name myDatabase
```

### Testing ODBC Connections

Test ODBC connectivity for application development:

```bash
# List available ODBC drivers
odbcinst -q -d

# Test ODBC connection
isql -v "Driver={ODBC Driver 18 for SQL Server};Server=your-server;Database=your-db;UID=your-user;PWD=your-password"
```

## 🏗️ Architecture

The image is built on Ubuntu 22.04 and includes:

```
Ubuntu 22.04 LTS
├── Microsoft SQL Server Tools 18
│   ├── sqlcmd
│   └── bcp
├── Azure CLI
├── ODBC Driver 18 for SQL Server
├── UnixODBC Development Files
└── Essential Linux utilities
```

## 🔧 Configuration

### Environment Variables

The following environment variables are pre-configured:

- `DEBIAN_FRONTEND=noninteractive` - Prevents interactive prompts during package installation
- `ACCEPT_EULA=Y` - Accepts Microsoft EULA for SQL Server tools
- `PATH` - Includes SQL Server tools directory

### Persistent Storage

To persist data and configurations, mount volumes when running the container:

```bash
docker run -d --name sql-debugger \
  -v /host/data:/data \
  -v /host/config:/config \
  ghcr.io/greatbody/linux-sqlserver-debugger:latest
```

## 🛡️ Security Considerations

- **Credentials**: Never include sensitive credentials in the container image
- **Network**: Use appropriate Docker network configurations for security
- **Updates**: Regularly update the container image for security patches
- **Access**: Limit container access to authorized personnel only

## 🔄 Development Workflow

### Local Development

1. Make changes to the Dockerfile or scripts
2. Build locally: `./build.sh`
3. Test the container: `./run.sh`
4. Verify functionality with your SQL Server instances

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes and test thoroughly
4. Commit with descriptive messages: `git commit -m "Add feature: description"`
5. Push to your fork: `git push origin feature/your-feature`
6. Create a Pull Request

## 🚀 Continuous Integration

The project uses GitHub Actions for automated building and publishing:

- **Triggers**: Pushes to main/master branch, tags, and pull requests
- **Multi-arch builds**: Supports both AMD64 and ARM64 architectures
- **Registry**: Images are published to GitHub Container Registry
- **Caching**: Build cache optimization for faster CI/CD

## 📁 Project Structure

```
linux-sqlserver-debugger/
├── Dockerfile              # Main container definition
├── build.sh                # Local build script
├── run.sh                  # Container run script
├── requirement.md          # Technical requirements
├── LICENSE                 # MIT license
├── .github/
│   └── workflows/
│       └── docker-build-push.yml  # CI/CD workflow
└── .augment/
    └── env/
        └── setup.sh        # Environment setup script
```

## 🔍 Troubleshooting

### Container Won't Start
```bash
# Check container logs
docker logs sql-debugger

# Verify image exists
docker images | grep sql-server-connector
```

### SQL Server Connection Issues
```bash
# Test network connectivity
telnet your-server 1433

# Check SQL Server tools version
sqlcmd -?

# Verify ODBC drivers
odbcinst -q -d
```

### Permission Issues
```bash
# Run container with specific user
docker run --user $(id -u):$(id -g) -d --name sql-debugger ghcr.io/greatbody/linux-sqlserver-debugger:latest
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/greatbody/linux-sqlserver-debugger/issues)
- **Discussions**: [GitHub Discussions](https://github.com/greatbody/linux-sqlserver-debugger/discussions)
- **Documentation**: Check the `requirement.md` file for technical details

## 🏷️ Tags

`sql-server` `docker` `linux` `debugging` `azure` `database` `odbc` `ubuntu` `containerization` `devops`

---

**Note**: This tool is designed for debugging and development purposes. Ensure proper security measures are in place when using in production environments.
