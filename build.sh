#!/bin/bash

# Build script for SQL Server Connector Docker image
# This script builds the Docker image with all required components

set -e  # Exit on any error

# Configuration
IMAGE_NAME="sql-server-connector"
IMAGE_TAG="latest"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building SQL Server Connector Docker image..."
echo "Image name: ${FULL_IMAGE_NAME}"
echo ""

# Build the Docker image
docker build -t "${FULL_IMAGE_NAME}" .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build completed successfully!"
    echo "Image: ${FULL_IMAGE_NAME}"
    echo ""
    echo "To run the container, use:"
    echo "  ./run.sh"
    echo ""
    echo "Or run manually with:"
    echo "  docker run -d --name sql-server-connector ${FULL_IMAGE_NAME}"
    echo "  docker exec -it sql-server-connector /bin/bash"
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi
