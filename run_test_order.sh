#!/bin/bash

set -e

echo "🧪 Running tests from order_service..."
docker compose exec order_service sh -c "RAILS_ENV=test bundle exec rspec"


