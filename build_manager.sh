#!/bin/bash

LOG_FILE="./deploy.log"
APP_DIR="./app"
ENV_FILE=".env"

echo "===== [Build Manager] Starting Build Tasks =====" >> "$LOG_FILE"

if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
  echo "✅ Environment variables loaded." >> "$LOG_FILE"
else
  echo "❌ .env file is missing!" >> "$LOG_FILE"
  exit 1
fi

required_vars=(DB_HOST DB_USER API_KEY)
for var in "${required_vars[@]}"; do
  if [[ -z "${!var}" ]]; then
    echo "❌ Missing required variable: $var" >> "$LOG_FILE"
    exit 1
  fi
done

cd "$APP_DIR" || exit

start_time=$(date +%s)

echo "⚙️ Installing dependencies..." >> "$LOG_FILE"
pip install -r requirements.txt >> "$LOG_FILE" 2>&1

echo "🔧 Running build script..." >> "$LOG_FILE"
chmod +x build.sh
./build.sh >> "$LOG_FILE" 2>&1

end_time=$(date +%s)
build_time=$((end_time - start_time))
echo "✅ Build finished in $build_time seconds." >> "$LOG_FILE"
echo "===== [Build Manager] Completed =====" >> "$LOG_FILE"
