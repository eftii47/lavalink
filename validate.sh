#!/bin/bash

echo ""
echo "=========================================="
echo "  Lavalink v4 Setup Validation"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to check file
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1 - NOT FOUND"
        ((ERRORS++))
    fi
}

# Function to check directory
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
    else
        echo -e "${YELLOW}⚠${NC} $1/ - NOT FOUND"
        ((WARNINGS++))
    fi
}

echo "Checking Core Files:"
echo "--------------------"
check_file "Lavalink.jar"
check_file "application.yml"
check_file "package.json"
check_file ".env.example"
check_file ".gitignore"

echo ""
echo "Checking Source Files:"
echo "--------------------"
check_dir "src"
check_file "src/index.js"

echo ""
echo "Checking Scripts:"
echo "--------------------"
check_file "start.sh"
check_file "setup.sh"

echo ""
echo "Checking Documentation:"
echo "--------------------"
check_file "README.md"
check_file "QUICKSTART.md"
check_file "YOUTUBE_AUTH.md"

echo ""
echo "Checking Docker Files:"
echo "--------------------"
check_file "docker-compose.yml"
check_file "Dockerfile"

echo ""
echo "Checking Plugins:"
echo "--------------------"
if [ -d "plugins" ]; then
    PLUGIN_COUNT=$(ls -1 plugins/*.jar 2>/dev/null | wc -l)
    if [ "$PLUGIN_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Found $PLUGIN_COUNT plugins:"
        ls -1 plugins/*.jar | sed 's/^/  - /'
    else
        echo -e "${YELLOW}⚠${NC} No plugins found in plugins/"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}✗${NC} plugins/ directory not found"
    ((ERRORS++))
fi

echo ""
echo "Validating JSON Files:"
echo "--------------------"
if command -v node &> /dev/null; then
    node -e "JSON.parse(require('fs').readFileSync('package.json', 'utf8'))" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} package.json is valid JSON"
    else
        echo -e "${RED}✗${NC} package.json has syntax errors"
        ((ERRORS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} Node.js not found, skipping JSON validation"
    ((WARNINGS++))
fi

echo ""
echo "Checking Dependencies:"
echo "--------------------"

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓${NC} Node.js $NODE_VERSION"
else
    echo -e "${RED}✗${NC} Node.js not found (required: v18+)"
    ((ERRORS++))
fi

# Check Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo -e "${GREEN}✓${NC} $JAVA_VERSION"
else
    echo -e "${RED}✗${NC} Java not found (required: v17+)"
    ((ERRORS++))
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓${NC} npm v$NPM_VERSION"
else
    echo -e "${YELLOW}⚠${NC} npm not found"
    ((WARNINGS++))
fi

echo ""
echo "Checking Node Modules:"
echo "--------------------"
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} node_modules/ installed"
    
    # Check key dependencies
    for pkg in "discord.js" "lavalink-client" "dotenv"; do
        if [ -d "node_modules/$pkg" ]; then
            echo -e "  ${GREEN}✓${NC} $pkg"
        else
            echo -e "  ${YELLOW}⚠${NC} $pkg not found (run npm install)"
            ((WARNINGS++))
        fi
    done
else
    echo -e "${YELLOW}⚠${NC} node_modules/ not found (run npm install)"
    ((WARNINGS++))
fi

echo ""
echo "Checking Configuration:"
echo "--------------------"
if [ -f "config.yml" ]; then
    echo -e "${GREEN}✓${NC} config.yml file exists"
    
    # Check for required variables
    if grep -q "token: \"your_discord_bot_token_here\"" config.yml 2>/dev/null; then
        echo -e "  ${YELLOW}⚠${NC} discord.token not configured"
        ((WARNINGS++))
    fi
    
    if grep -q "clientId: \"your_discord_client_id_here\"" config.yml 2>/dev/null; then
        echo -e "  ${YELLOW}⚠${NC} discord.clientId not configured"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} config.yml file not found (copy from config.example.yml)"
    ((WARNINGS++))
fi

echo ""
echo "Checking File Permissions:"
echo "--------------------"
if [ -x "start.sh" ]; then
    echo -e "${GREEN}✓${NC} start.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} start.sh needs chmod +x (run: chmod +x start.sh)"
    ((WARNINGS++))
fi

if [ -x "setup.sh" ]; then
    echo -e "${GREEN}✓${NC} setup.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} setup.sh needs chmod +x (run: chmod +x setup.sh)"
    ((WARNINGS++))
fi

echo ""
echo "Lavalink Version:"
echo "--------------------"
if [ -f "Lavalink.jar" ]; then
    java -jar Lavalink.jar --version 2>&1 | head -4 | sed 's/^/  /'
fi

echo ""
echo "=========================================="
echo "  Validation Summary"
echo "=========================================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "You're ready to start:"
    echo "  1. Configure config.yml with your Discord token"
    echo "  2. Run: ./start.sh (Lavalink server)"
    echo "  3. Run: npm start (Discord bot)"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ $WARNINGS warning(s) found${NC}"
    echo ""
    echo "Setup is functional but some optional items need attention."
    echo "Review warnings above for details."
else
    echo -e "${RED}✗ $ERRORS error(s) and $WARNINGS warning(s) found${NC}"
    echo ""
    echo "Please fix the errors above before proceeding."
fi

echo ""
exit $ERRORS
