#!/bin/bash
# Home SOC Lab - Startup Script
# Run this every time you boot Kali to bring up the full lab
# Usage: ~/start-lab.sh

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        Home SOC Lab - Starting Up        ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Start Docker containers
echo "[*] Starting Docker containers..."
docker start dvwa juice-shop splunk 2>/dev/null

# Start Wazuh
echo "[*] Starting Wazuh SIEM..."
cd ~/wazuh-docker/single-node && docker-compose up -d 2>/dev/null

# Wait for containers to be ready
echo "[*] Waiting for services to initialize..."
sleep 5

# Check status
echo ""
echo "[*] Container status:"
docker ps --format "  {{.Names}}: {{.Status}}" | grep -E "dvwa|juice|splunk|wazuh"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║           Lab Access URLs                ║"
echo "╠══════════════════════════════════════════╣"
echo "║  DVWA        → http://localhost          ║"
echo "║  Juice Shop  → http://localhost:3000     ║"
echo "║  Splunk      → http://localhost:8000     ║"
echo "║  Wazuh       → https://localhost         ║"
echo "║  Target      → 192.168.117.129           ║"
echo "╚══════════════════════════════════════════╝"
echo ""
