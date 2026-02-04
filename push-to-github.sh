#!/bin/bash

echo ""
echo "=========================================="
echo "  Pushing to GitHub"
echo "=========================================="
echo ""

# Initialize git if needed
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
fi

# Check/set remote
if git remote get-url origin &> /dev/null; then
    echo "Remote 'origin' already exists"
else
    echo "Adding remote origin..."
    git remote add origin https://github.com/eftii47/lavalink.git
fi

# Stage all files
echo ""
echo "Staging files..."
git add -A

# Show status
echo ""
echo "Files to commit:"
git status --short

# Commit
echo ""
COMMIT_MSG="Complete Java-based Lavalink music bot with deployment support"
echo "Committing: $COMMIT_MSG"
git commit -m "$COMMIT_MSG" || echo "Nothing new to commit"

# Push
echo ""
echo "Pushing to GitHub..."
git branch -M main
git push -u origin main --force

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  ✓ Successfully Pushed!"
    echo "=========================================="
    echo ""
    echo "View at: https://github.com/eftii47/lavalink"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "  Push Failed - Authentication Needed"
    echo "=========================================="
    echo ""
    echo "Try one of these methods:"
    echo ""
    echo "1. GitHub CLI (easiest):"
    echo "   gh auth login"
    echo "   git push -u origin main"
    echo ""
    echo "2. Personal Access Token:"
    echo "   git push https://YOUR_TOKEN@github.com/eftii47/lavalink.git main"
    echo ""
    echo "3. SSH:"
    echo "   git remote set-url origin git@github.com:eftii47/lavalink.git"
    echo "   git push -u origin main"
    echo ""
fi
