#!/bin/bash

set -e

echo "🔧 Building containers..."
docker compose build

echo "⏳ Waiting for services to be ready..."
sleep 10

echo "📂 Creating and migrating order_service DB..."
docker compose exec order_service rails db:create db:migrate

echo "📂 Creating, migrating and seeding customer_service DB..."
docker compose exec customer_service rails db:create db:migrate db:seed