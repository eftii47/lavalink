#!/bin/bash

echo ""
echo "=========================================="
echo "  Pushing to GitHub Repository"
echo "=========================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
    git remote add origin https://github.com/eftii47/lavalink.git
fi

# Check if remote exists
if ! git remote get-url origin &> /dev/null; then
    echo "Adding remote origin..."
    git remote add origin https://github.com/eftii47/lavalink.git
fi

# Show current status
echo "Current git status:"
git status --short
echo ""

# Add all files
echo "Adding files to git..."
git add .

# Show what will be committed
echo ""
echo "Files to be committed:"
git status --short
echo ""

# Commit
read -p "Enter commit message (or press Enter for default): " COMMIT_MSG
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Complete Java music bot with Lavalink v4"
fi

echo ""
echo "Committing with message: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# Push
echo ""
echo "Pushing to GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  ✓ Successfully pushed to GitHub!"
    echo "=========================================="
    echo ""
    echo "Repository: https://github.com/eftii47/lavalink"
    echo ""
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "If you need to authenticate:"
    echo "  1. GitHub Personal Access Token:"
    echo "     git push https://YOUR_TOKEN@github.com/eftii47/lavalink.git main"
    echo ""
    echo "  2. Or configure credentials:"
    echo "     gh auth login"
    echo ""
fi
