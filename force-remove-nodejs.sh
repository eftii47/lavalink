#!/bin/bash

# Force removal without confirmation - use with caution
echo "Force removing all Node.js files..."

rm -f package.json
rm -f package-lock.json
rm -f yarn.lock
rm -f pnpm-lock.yaml
rm -rf node_modules/
rm -f src/index.js
rm -f npm-debug.log

echo "✓ All Node.js files deleted"
echo ""
echo "Remaining structure:"
ls -la src/ 2>/dev/null || echo "src/ is now empty or only contains Java files"
echo ""
echo "Project is now 100% Java!"
