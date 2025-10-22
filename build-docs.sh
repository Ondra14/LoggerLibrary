#!/bin/bash

# Build documentation for LoggerLibrary only
# Usage: ./build-docs.sh

set -e

echo "🔨 Building documentation for LoggerLibrary..."

swift package --allow-writing-to-directory ./docs \
    generate-documentation \
    --target LoggerLibrary \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path LoggerLibrary

echo "✅ Documentation built successfully!"
echo "📚 Open: docs/index.html"
