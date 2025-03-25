#!/bin/bash

LOG_FILE="./deploy.log"
APP_DIR="./app"
PORT=3000
BACKUP_DIR="./backup_$(date +%Y%m%d_%H%M%S)"
HEALTH_URL="http://localhost:$PORT"

echo "===== [Deploy Manager] Starting Deployment Tasks =====" >> "$LOG_FILE"

cp -r "$APP_DIR" "$BACKUP_DIR"
echo "📦 Backup created at $BACKUP_DIR" >> "$LOG_FILE"

pkill -f app.py
sleep 1

echo "🚀 Starting app in background..." >> "$LOG_FILE"
nohup python3 "$APP_DIR/app.py" >> "$LOG_FILE" 2>&1 &

sleep 3

status_code=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL")
if [[ "$status_code" == "200" ]]; then
  echo "✅ App is running fine (HTTP $status_code)" >> "$LOG_FILE"
else
  echo "❌ Health check failed. Rolling back..." >> "$LOG_FILE"
  pkill -f app.py
  rm -rf "$APP_DIR"
  mv "$BACKUP_DIR" "$APP_DIR"
  nohup python3 "$APP_DIR/app.py" >> "$LOG_FILE" 2>&1 &
fi

echo "===== [Deploy Manager] Completed =====" >> "$LOG_FILE"
