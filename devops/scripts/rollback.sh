#!/bin/bash
set -e

echo "========================================="
echo "🚨 DEPLOYMENT FAILURE: Initiating Rollback"
echo "========================================="

# 1. Restore the backup tag to latest
echo "🔄 Restoring backup image tags..."
docker tag sakshimalik565/skill-hive-backend:rollback-backup sakshimalik565/skill-hive-backend:latest || true
docker tag sakshimalik565/skill-hive-frontend:rollback-backup sakshimalik565/skill-hive-frontend:latest || true

# 2. Restart services using old images
echo "🔄 Restarting containers with previous stable version..."
docker compose down --timeout 5
docker compose up -d --remove-orphans

# 3. Wait for services to initialize
echo "⏱️ Waiting for services to initialize (15 seconds)..."
sleep 15

# 4. Verify recovery
HEALTH_CHECK_URL="http://localhost:80/api/health"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_CHECK_URL || true)

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "✅ Rollback successful! Services are healthy and responding."
    echo "========================================="
    exit 0
else
    echo "❌ CRITICAL: Rollback failed. Services are not responding. Manual intervention required."
    echo "========================================="
    exit 1
fi
