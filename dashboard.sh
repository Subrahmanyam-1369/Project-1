#!/bin/bash

APP_DIR="./app"
LOG_FILE="./deploy.log"
PORT=3000
HEALTH_URL="http://localhost:$PORT"

GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

clear
echo "${CYAN}======================="
echo "  DEPLOYMENT DASHBOARD"
echo "=======================${RESET}"

echo -e "
${YELLOW}🔄 Last 3 Git Commits:${RESET}"
cd "$APP_DIR" && git log -3 --pretty=format:"%h - %an: %s" 2>/dev/null || echo "No Git repo"

echo -e "
${YELLOW}🛠️ App Status:${RESET}"
pgrep -f app.py > /dev/null && echo "${GREEN}✅ RUNNING${RESET}" || echo "${RED}❌ NOT RUNNING${RESET}"

echo -e "
${YELLOW}🧪 Health Check:${RESET}"
status=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL")
[[ "$status" == "200" ]] && echo "${GREEN}Healthy (HTTP $status)${RESET}" || echo "${RED}Unhealthy (HTTP $status)${RESET}"

echo -e "
${YELLOW}📄 Log Snippet:${RESET}"
tail -n 10 "$LOG_FILE"

echo -e "
${CYAN}======================="
echo "   End of Dashboard"
echo "=======================${RESET}"
