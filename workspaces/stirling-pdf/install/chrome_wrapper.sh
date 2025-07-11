#!/bin/bash

# Create Chrome user data directory
mkdir -p /tmp/chrome-user-data

# Launch Chrome with optimized flags for Kasm
exec google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --disable-background-timer-throttling \
  --disable-backgrounding-occluded-windows \
  --disable-renderer-backgrounding \
  --user-data-dir=/tmp/chrome-user-data \
  --start-maximized \
  "$@"
