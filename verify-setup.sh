#!/bin/bash

echo ""
echo "=========================================="
echo "  Final Setup Verification"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "Checking file structure..."
echo ""

# Core files
echo "Core Configuration:"
[ -f "application.yml" ] && echo -e "${GREEN}✓${NC} application.yml (Lavalink server config)" || echo -e "${RED}✗${NC} application.yml missing"
[ -f "config.example.yml" ] && echo -e "${GREEN}✓${NC} config.example.yml (Bot config template)" || echo -e "${RED}✗${NC} config.example.yml missing"

# Check if old .env files exist
echo ""
echo "Legacy Files Check:"
if [ -f ".env" ] || [ -f ".env.example" ]; then
    echo -e "${YELLOW}⚠${NC} Old .env files found - run ./cleanup.sh to remove"
else
    echo -e "${GREEN}✓${NC} No .env files (using YAML only)"
fi

# Check bot config
echo ""
echo "Bot Configuration:"
if [ -f "config.yml" ]; then
    echo -e "${GREEN}✓${NC} config.yml exists"
    if grep -q "your_discord_bot_token_here" config.yml; then
        echo -e "${YELLOW}  ⚠${NC} Discord token not configured yet"
    else
        echo -e "${GREEN}  ✓${NC} Discord token configured"
    fi
else
    echo -e "${YELLOW}⚠${NC} config.yml not found"
    echo "   Run: cp config.example.yml config.yml"
fi

# Dependencies
echo ""
echo "Dependencies:"
[ -f "package.json" ] && echo -e "${GREEN}✓${NC} package.json (uses yaml parser, not dotenv)" || echo -e "${RED}✗${NC} package.json missing"

if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} node_modules installed"
    if [ -d "node_modules/yaml" ]; then
        echo -e "${GREEN}  ✓${NC} yaml package installed"
    else
        echo -e "${YELLOW}  ⚠${NC} yaml package missing - run: npm install"
    fi
    if [ -d "node_modules/dotenv" ]; then
        echo -e "${YELLOW}  ⚠${NC} dotenv still installed (not needed anymore)"
    fi
else
    echo -e "${YELLOW}⚠${NC} node_modules not installed - run: npm install"
fi

# Documentation
echo ""
echo "Documentation:"
[ -f "README.md" ] && echo -e "${GREEN}✓${NC} README.md"
[ -f "CONFIGURATION.md" ] && echo -e "${GREEN}✓${NC} CONFIGURATION.md (How to configure)"
[ -f "QUICKSTART.md" ] && echo -e "${GREEN}✓${NC} QUICKSTART.md"

echo ""
echo "=========================================="
echo "  Configuration Summary"
echo "=========================================="
echo ""
echo "✓ Using YAML-only configuration"
echo "✓ No .env files needed"
echo ""
echo "Configuration files:"
echo "  1. application.yml - Lavalink server (Java)"
echo "  2. config.yml - Discord bot (Node.js)"
echo ""
echo "Next steps:"
echo "  1. cp config.example.yml config.yml"
echo "  2. nano config.yml (add Discord token)"
echo "  3. ./start.sh (start Lavalink)"
echo "  4. npm start (start bot)"
echo ""
echo "Read CONFIGURATION.md for detailed setup guide!"
echo ""
