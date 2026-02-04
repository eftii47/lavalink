#!/bin/bash

echo "Testing Maven build..."
cd /workspaces/lavalink
mvn clean package -DskipTests
