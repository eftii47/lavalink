#!/bin/bash

echo ""
echo "=========================================="
echo "  Building Deployable JAR"
echo "=========================================="
echo ""

# Check Maven
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed!"
    echo "Please install Maven: https://maven.apache.org/install.html"
    exit 1
fi

echo "✓ Maven found: $(mvn -version | head -n 1)"
echo ""

# Check Java
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed!"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17 or higher is required. Current: $JAVA_VERSION"
    exit 1
fi

echo "✓ Java version: $(java -version 2>&1 | head -n 1)"
echo ""

# Clean and build
echo "Building production JAR..."
echo "This creates a standalone executable JAR with all dependencies."
echo ""

mvn clean package -DskipTests

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  Build Successful!"
    echo "=========================================="
    echo ""
    echo "✓ Deployable JAR created: target/MusicBot.jar"
    echo ""
    
    # Get JAR size
    JAR_SIZE=$(du -h target/MusicBot.jar | cut -f1)
    echo "📦 JAR Size: $JAR_SIZE"
    echo ""
    
    echo "This JAR contains:"
    echo "  • Your bot code"
    echo "  • All dependencies (JDA, Lavalink client, etc.)"
    echo "  • Configuration loader"
    echo "  • Everything needed to run"
    echo ""
    echo "=========================================="
    echo "  How to Deploy"
    echo "=========================================="
    echo ""
    echo "1. Upload to your hosting platform:"
    echo "   - target/MusicBot.jar"
    echo "   - config.yml (with your bot token)"
    echo ""
    echo "2. Make sure Lavalink is running:"
    echo "   - Either on same server: Lavalink.jar"
    echo "   - Or remote server: Update config.yml host"
    echo ""
    echo "3. Start command on hosting platform:"
    echo "   java -jar MusicBot.jar"
    echo ""
    echo "For Heroku/Railway/Render, see DEPLOYMENT.md"
    echo ""
else
    echo ""
    echo "❌ Build failed! Check errors above."
    exit 1
fi
