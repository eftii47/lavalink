#!/bin/bash

echo ""
echo "=========================================="
echo "  Building Java Music Bot"
echo "=========================================="
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed!"
    echo "Please install Maven: https://maven.apache.org/install.html"
    echo ""
    echo "On Ubuntu/Debian: sudo apt-get install maven"
    echo "On macOS: brew install maven"
    exit 1
fi

echo "✓ Maven found: $(mvn -version | head -n 1)"
echo ""

# Check Java version
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed!"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17 or higher is required. Current version: $JAVA_VERSION"
    exit 1
fi

echo "✓ Java version: $(java -version 2>&1 | head -n 1)"
echo ""

# Build the project
echo "Building project with Maven..."
echo "This may take a few minutes on first run..."
echo ""

mvn clean package

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  Build Successful!"
    echo "=========================================="
    echo ""
    echo "✓ Bot JAR created: target/MusicBot.jar"
    echo ""
    echo "To run the bot:"
    echo "  java -jar target/MusicBot.jar"
    echo ""
    echo "Or use: ./run-bot.sh"
    echo ""
else
    echo ""
    echo "❌ Build failed! Check the errors above."
    exit 1
fi
