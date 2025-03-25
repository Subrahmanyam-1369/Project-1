#!/bin/bash

LOG_FILE="./deploy.log"
APP_DIR="./app"
BRANCH="main"

echo "===== [Git Manager] Starting Git Tasks =====" >> "$LOG_FILE"

if [ -d "$APP_DIR/.git" ]; then
  cd "$APP_DIR" || exit
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$current_branch" != "$BRANCH" ]]; then
    echo "❌ Error: Not on $BRANCH branch. You're on $current_branch." >> "$LOG_FILE"
    exit 1
  fi

  if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️ Warning: Uncommitted changes found." >> "$LOG_FILE"
    exit 1
  fi

  echo "✅ Pulling latest code from $BRANCH..." >> "$LOG_FILE"
  git pull origin "$BRANCH" >> "$LOG_FILE" 2>&1

else
  echo "📦 App directory exists but no Git repo found. Skipping Git pull." >> "$LOG_FILE"
fi

echo "🔄 Recent Commits (if any):" >> "$LOG_FILE"
cd "$APP_DIR" && git log -3 --pretty=format:"%h - %an: %s" >> "$LOG_FILE" 2>/dev/null

echo "===== [Git Manager] Completed =====" >> "$LOG_FILE"
