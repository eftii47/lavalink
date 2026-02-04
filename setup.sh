#!/bin/bash

echo ""
echo "=========================================="
echo "  Lavalink v4 Node.js Host Setup"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Node.js
echo -n "Checking Node.js... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓${NC} $NODE_VERSION"
else
    echo -e "${RED}✗ Node.js not found${NC}"
    echo "Please install Node.js 18 or higher: https://nodejs.org/"
    exit 1
fi

# Check Java
echo -n "Checking Java... "
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo -e "${GREEN}✓${NC} $JAVA_VERSION"
else
    echo -e "${RED}✗ Java not found${NC}"
    echo "Please install Java 17 or higher"
    exit 1
fi

# Check Lavalink.jar
echo -n "Checking Lavalink.jar... "
if [ -f "Lavalink.jar" ]; then
    echo -e "${GREEN}✓${NC} Found"
else
    echo -e "${RED}✗ Not found${NC}"
    exit 1
fi

# Check plugins directory
echo -n "Checking plugins... "
if [ -d "plugins" ]; then
    PLUGIN_COUNT=$(ls -1 plugins/*.jar 2>/dev/null | wc -l)
    echo -e "${GREEN}✓${NC} $PLUGIN_COUNT plugins found"
else
    echo -e "${YELLOW}⚠${NC} No plugins directory"
fi

echo ""
echo "=========================================="
echo "  Installing Node.js Dependencies"
echo "=========================================="
echo ""

npm install

echo ""
echo "=========================================="
echo "  Configuration"
echo "=========================================="
echo ""

# Create config.yml if it doesn't exist
if [ ! -f "config.yml" ]; then
    echo "Creating config.yml file from config.example.yml..."
    cp config.example.yml config.yml
    echo -e "${YELLOW}⚠${NC} Please edit config.yml and add your Discord bot token!"
    echo ""
else
    echo -e "${GREEN}✓${NC} config.yml file exists"
fi

# Make start.sh executable
chmod +x start.sh

echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Edit config.yml file with your Discord bot token:"
echo "   ${YELLOW}nano config.yml${NC}"
echo ""
echo "2. (Optional) Configure plugins in application.yml"
echo ""
echo "3. Start Lavalink server:"
echo "   ${GREEN}./start.sh${NC}"
echo "   or"
echo "   ${GREEN}npm run lavalink:start${NC}"
echo ""
echo "4. In a new terminal, start the Discord bot:"
echo "   ${GREEN}npm start${NC}"
echo ""
echo "=========================================="
echo ""
