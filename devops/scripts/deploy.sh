#!/bin/bash
set -e

echo "========================================="
echo "🚀 Starting Automated Deployment Pipeline"
echo "========================================="

# 1. Back up current running image tags to enable instant rollback
echo "📦 Backing up active deployment state..."
docker tag sakshimalik565/skill-hive-backend:latest sakshimalik565/skill-hive-backend:rollback-backup || true
docker tag sakshimalik565/skill-hive-frontend:latest sakshimalik565/skill-hive-frontend:rollback-backup || true


# 2. Pull latest images
echo "📥 Fetching latest images from DockerHub..."
docker compose pull backend frontend nginx

# 3. Deploy new containers
echo "🔄 Re-creating containers..."
# Recreate with 5 seconds timeout for grace shutdown
docker compose down --timeout 5
docker compose up -d --remove-orphans

# 4. Wait for services to initialize
echo "⏱️ Waiting for services to initialize (15 seconds)..."
sleep 15

# 5. Run Health Check Verification
echo "🔍 Running health check validation..."
HEALTH_CHECK_URL="http://localhost:80/api/health"
MAX_ATTEMPTS=5
ATTEMPT=1
SUCCESS=0

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Attempt $ATTEMPT/$MAX_ATTEMPTS checking $HEALTH_CHECK_URL..."
    # Query API endpoint via curl
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_CHECK_URL || true)
    
    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "✅ Health check passed! Application is responding with HTTP 200."
        SUCCESS=1
        break
    else
        echo "⚠️ Health check returned HTTP $STATUS_CODE. Retrying in 5 seconds..."
        sleep 5
        ATTEMPT=$((ATTEMPT+1))
    fi
done

if [ $SUCCESS -ne 1 ]; then
    echo "❌ ERROR: Health check validation failed after $MAX_ATTEMPTS attempts."
    exit 1
fi

echo "========================================="
echo "🎉 Deployment Completed Successfully!"
echo "========================================="
exit 0
