#!/bin/bash

echo "Removing old .env files..."
rm -f .env .env.example

echo "✓ Cleaned up .env files"
echo ""
echo "The project now uses YAML configuration only:"
echo "  - application.yml (Lavalink server)"
echo "  - config.yml (Discord bot - create from config.example.yml)"
echo ""
echo "Run ./setup.sh to configure your bot!"
