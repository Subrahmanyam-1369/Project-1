#!/bin/bash

echo ">>> Starting Full Deployment Process..."

./git_manager.sh
if [ $? -ne 0 ]; then
  echo "❌ Git Manager failed. Exiting."
  exit 1
fi

./build_manager.sh
if [ $? -ne 0 ]; then
  echo "❌ Build Manager failed. Exiting."
  exit 1
fi

./deploy_manager.sh
if [ $? -ne 0 ]; then
  echo "❌ Deployment Manager failed. Exiting."
  exit 1
fi

echo ">>> Deployment Process Complete. Check deploy.log for details."
