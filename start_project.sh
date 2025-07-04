#!/bin/bash

set -e

echo "🔧 Starting containers in background..."
docker compose up -d

echo "⏳ Waiting for services to be ready..."
sleep 10

echo "📥 Starting RabbitMQ consumer in customer_service..."
docker compose exec -T customer_service rails orders:consume &
echo "🎉 Project is up and running. Consumer is listening for messages."
