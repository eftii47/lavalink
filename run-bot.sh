#!/bin/bash

echo ""
echo "=========================================="
echo "  Starting Java Music Bot"
echo "=========================================="
echo ""

# Check if bot JAR exists
if [ ! -f "target/MusicBot.jar" ]; then
    echo "❌ MusicBot.jar not found!"
    echo "Please build the bot first: ./build.sh"
    exit 1
fi

# Check if config.yml exists
if [ ! -f "config.yml" ]; then
    echo "❌ config.yml not found!"
    echo "Please create config.yml from config.example.yml"
    exit 1
fi

# Check Java
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed!"
    exit 1
fi

echo "✓ Starting bot..."
echo ""

java -jar target/MusicBot.jar
