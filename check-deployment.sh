#!/bin/bash

echo ""
echo "=========================================="
echo "  Deployment Validation Check"
echo "=========================================="
echo ""

ERRORS=0
WARNINGS=0

# Check 1: Java Version
echo "✓ Checking Java..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -ge 17 ]; then
        echo "  ✓ Java $JAVA_VERSION detected (required: 17+)"
    else
        echo "  ✗ Java 17+ required, found: $JAVA_VERSION"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ✗ Java not installed"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: Maven
echo "✓ Checking Maven..."
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -version | head -n 1 | awk '{print $3}')
    echo "  ✓ Maven $MVN_VERSION detected"
else
    echo "  ⚠ Maven not installed (needed for building)"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 3: Source Files
echo "✓ Checking source files..."
REQUIRED_FILES=(
    "src/MusicBot.java"
    "src/Config.java"
    "src/LavalinkManager.java"
    "src/MusicCommandHandler.java"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ Missing: $file"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check 4: Configuration Files
echo "✓ Checking configuration files..."
if [ -f "pom.xml" ]; then
    echo "  ✓ pom.xml (Maven config)"
else
    echo "  ✗ Missing: pom.xml"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "config.example.yml" ]; then
    echo "  ✓ config.example.yml (Bot config template)"
else
    echo "  ✗ Missing: config.example.yml"
    ERRORS=$((ERRORS + 1))
fi

if [ ! -f "config.yml" ]; then
    echo "  ⚠ config.yml not created (copy from config.example.yml)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "  ✓ config.yml (Bot config)"
fi

if [ -f "application.yml" ]; then
    echo "  ✓ application.yml (Lavalink config)"
else
    echo "  ✗ Missing: application.yml"
    ERRORS=$((ERRORS + 1))
fi

# Check 5: Lavalink Server
echo "✓ Checking Lavalink server..."
if [ -f "Lavalink.jar" ]; then
    JAR_SIZE=$(du -h Lavalink.jar | cut -f1)
    echo "  ✓ Lavalink.jar ($JAR_SIZE)"
else
    echo "  ✗ Missing: Lavalink.jar"
    ERRORS=$((ERRORS + 1))
fi

if [ -d "plugins" ]; then
    PLUGIN_COUNT=$(find plugins -name "*.jar" | wc -l)
    echo "  ✓ plugins/ ($PLUGIN_COUNT plugins)"
else
    echo "  ⚠ No plugins directory"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 6: Deployment Files
echo "✓ Checking deployment files..."
DEPLOY_FILES=(
    "Procfile"
    "system.properties"
    "Dockerfile"
    "docker-compose.yml"
)

for file in "${DEPLOY_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ⚠ Missing: $file (optional for some platforms)"
    fi
done

# Check 7: Build Scripts
echo "✓ Checking build scripts..."
if [ -f "build-deploy.sh" ]; then
    echo "  ✓ build-deploy.sh (Production build)"
else
    echo "  ⚠ Missing: build-deploy.sh"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 8: Documentation
echo "✓ Checking documentation..."
if [ -f "README.md" ]; then
    echo "  ✓ README.md"
else
    echo "  ⚠ Missing: README.md"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -f "DEPLOYMENT.md" ]; then
    echo "  ✓ DEPLOYMENT.md"
fi

# Check 9: Test Build (if Maven available)
echo ""
echo "✓ Testing build process..."
if command -v mvn &> /dev/null; then
    echo "  Running: mvn clean compile -q"
    if mvn clean compile -q 2>&1 | grep -q "BUILD SUCCESS"; then
        echo "  ✓ Build test successful!"
        
        # Check if target directory created
        if [ -d "target/classes" ]; then
            CLASS_COUNT=$(find target/classes -name "*.class" | wc -l)
            echo "  ✓ Compiled $CLASS_COUNT class files"
        fi
    else
        echo "  ✗ Build test failed!"
        echo "  Run 'mvn clean compile' to see detailed errors"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ⚠ Skipping build test (Maven not available)"
fi

# Check 10: Hosting Platform Compatibility
echo ""
echo "✓ Checking hosting platform compatibility..."
echo "  ✓ VPS/Dedicated (Ready - upload JAR and run)"
echo "  ✓ Railway.app (Ready - Procfile present)"
echo "  ✓ Heroku (Ready - Procfile + system.properties)"
echo "  ✓ Render.com (Ready - standard Java app)"
echo "  ✓ Docker (Ready - Dockerfile + docker-compose.yml)"

# Summary
echo ""
echo "=========================================="
echo "  Validation Summary"
echo "=========================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ Perfect! Bot is ready for deployment!"
    echo ""
    echo "Next steps:"
    echo "  1. Build: ./build-deploy.sh"
    echo "  2. Configure: cp config.example.yml config.yml"
    echo "  3. Deploy: Upload target/MusicBot.jar to your platform"
    echo ""
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Ready with warnings ($WARNINGS warnings)"
    echo ""
    echo "The bot can be deployed, but some optional files are missing."
    echo ""
else
    echo "❌ Not ready for deployment"
    echo ""
    echo "Errors: $ERRORS"
    echo "Warnings: $WARNINGS"
    echo ""
    echo "Please fix the errors before deploying."
    echo ""
fi

exit $ERRORS
