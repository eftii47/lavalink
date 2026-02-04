#!/bin/bash

echo ""
echo "=========================================="
echo "  Removing Node.js Files"
echo "=========================================="
echo ""

# List files to be removed
echo "Files to remove:"
echo "  - package.json"
echo "  - package-lock.json (if exists)"
echo "  - node_modules/ (if exists)"
echo "  - src/index.js (old Node.js bot)"
echo "  - npm-debug.log (if exists)"
echo ""

read -p "Continue with deletion? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing Node.js files..."
    
    # Remove files
    [ -f "package.json" ] && rm -f package.json && echo "  ✓ Removed package.json"
    [ -f "package-lock.json" ] && rm -f package-lock.json && echo "  ✓ Removed package-lock.json"
    [ -d "node_modules" ] && rm -rf node_modules/ && echo "  ✓ Removed node_modules/"
    [ -f "src/index.js" ] && rm -f src/index.js && echo "  ✓ Removed src/index.js"
    [ -f "npm-debug.log" ] && rm -f npm-debug.log && echo "  ✓ Removed npm-debug.log"
    
    echo ""
    echo "✓ Node.js files removed!"
    echo ""
    echo "The bot is now 100% Java-based!"
    echo ""
    echo "Next steps:"
    echo "  1. Build: ./build.sh"
    echo "  2. Run: ./run-bot.sh"
    echo ""
else
    echo "Cancelled."
    exit 0
fi
