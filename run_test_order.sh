#!/bin/bash

set -e

echo "🔧 Building containers..."
docker compose -f docker-compose.test.yml build

echo "🚀 Starting services in background..."
docker compose -f docker-compose.test.yml up -d

echo "⏳ Waiting for services to be ready..."
sleep 10

echo "📂 Creating and migrating order_service DB..."
docker compose -f docker-compose.test.yml exec order_service rails db:create db:migrate

echo "📂 Creating, migrating and seeding customer_service DB..."
docker compose -f docker-compose.test.yml exec customer_service rails db:create db:migrate


echo "🧪 Running integration tests from customer_service..."
docker compose -f docker-compose.test.yml exec order_service bundle exec rspec

echo "🧹 Cleaning up containers..."
docker compose -f docker-compose.test.yml down
