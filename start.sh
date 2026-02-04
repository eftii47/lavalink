#!/bin/bash

echo "=========================================="
echo "  Lavalink v4 Host - Starting..."
echo "=========================================="
echo ""

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install Java 17 or higher."
    exit 1
fi

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17 or higher is required. Current version: $JAVA_VERSION"
    exit 1
fi

echo "✓ Java version: $(java -version 2>&1 | head -n 1)"
echo ""

# Check if Lavalink.jar exists
if [ ! -f "Lavalink.jar" ]; then
    echo "❌ Lavalink.jar not found!"
    exit 1
fi

# Check if application.yml exists
if [ ! -f "application.yml" ]; then
    echo "❌ application.yml not found!"
    exit 1
fi

# Check plugins directory
if [ -d "plugins" ]; then
    PLUGIN_COUNT=$(ls -1 plugins/*.jar 2>/dev/null | wc -l)
    echo "✓ Found $PLUGIN_COUNT plugin(s) in plugins/ directory"
    echo ""
fi

# Start Lavalink
echo "Starting Lavalink server..."
echo "=========================================="
echo ""

java -jar Lavalink.jar
