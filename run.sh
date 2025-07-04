#!/bin/bash

# Run script for SQL Server Connector Docker container
# This script runs the container with proper configuration

set -e  # Exit on any error

# Configuration
IMAGE_NAME="sql-server-connector"
IMAGE_TAG="latest"
CONTAINER_NAME="sql-server-connector"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "Starting SQL Server Connector Docker container..."
echo "Container name: ${CONTAINER_NAME}"
echo "Image: ${FULL_IMAGE_NAME}"
echo ""

# Check if container already exists
if docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container '${CONTAINER_NAME}' already exists."
    
    # Check if it's running
    if docker ps --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "Container is already running."
        echo ""
        echo "To access the container, use:"
        echo "  docker exec -it ${CONTAINER_NAME} /bin/bash"
    else
        echo "Starting existing container..."
        docker start "${CONTAINER_NAME}"
        echo ""
        echo "✅ Container started successfully!"
        echo ""
        echo "To access the container, use:"
        echo "  docker exec -it ${CONTAINER_NAME} /bin/bash"
    fi
else
    # Run new container
    echo "Creating and starting new container..."
    docker run -d --name "${CONTAINER_NAME}" "${FULL_IMAGE_NAME}"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Container started successfully!"
        echo "Container name: ${CONTAINER_NAME}"
        echo ""
        echo "To access the container, use:"
        echo "  docker exec -it ${CONTAINER_NAME} /bin/bash"
        echo ""
        echo "To stop the container, use:"
        echo "  docker stop ${CONTAINER_NAME}"
        echo ""
        echo "To remove the container, use:"
        echo "  docker rm ${CONTAINER_NAME}"
    else
        echo ""
        echo "❌ Failed to start container!"
        exit 1
    fi
fi
