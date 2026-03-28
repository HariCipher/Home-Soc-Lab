# 02 — Docker Tools Setup (DVWA, Juice Shop, Wazuh, Splunk)

This guide covers deploying all four Docker-based tools in the home lab using Kali Linux.

---

## Prerequisites

- Kali Linux running in VMware (see [01-kali-setup.md](01-kali-setup.md))
- At least 20GB free disk space in the Kali VM

---

## Step 1 — Install Docker

```bash
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker

# Run Docker without sudo
sudo usermod -aG docker $USER
newgrp docker
```

Verify:
```bash
docker --version
docker ps
```

---

## Step 2 — Deploy DVWA

DVWA (Damn Vulnerable Web Application) is a PHP/MySQL web app with intentionally vulnerable functionality for practicing OWASP Top 10 attacks.

```bash
docker run -d \
  -p 80:80 \
  --name dvwa \
  ghcr.io/digininja/dvwa:latest
```

**Setup after deployment:**
1. Open browser → `http://localhost`
2. Go to `http://localhost/setup.php`
3. Click **Create / Reset Database**
4. Login: `admin` / `password`
5. Go to **DVWA Security** → set level to **Low** to start

**What you can practice:**
- SQL Injection
- XSS (Reflected, Stored, DOM)
- Command Injection
- File Upload vulnerabilities
- CSRF
- Brute Force

---

## Step 3 — Deploy OWASP Juice Shop

Juice Shop is a modern intentionally vulnerable Node.js web app covering 100+ security challenges across OWASP Top 10 categories.

```bash
docker run -d \
  -p 3000:3000 \
  --name juice-shop \
  bkimminich/juice-shop
```

Access: `http://localhost:3000`

No setup needed — create an account and start solving challenges. The scoreboard is hidden at first — finding it is the first challenge.

---

## Step 4 — Deploy Wazuh (SIEM)

Wazuh is an open-source security platform providing SIEM, XDR, and compliance capabilities. Used in real SOC environments worldwide.

```bash
# Clone Wazuh Docker repository (v4.7.0)
git clone https://github.com/wazuh/wazuh-docker.git -b v4.7.0
cd wazuh-docker/single-node

# Increase virtual memory (required by Wazuh)
sudo sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf

# Generate SSL certificates
docker-compose -f generate-indexer-certs.yml run --rm generator

# Start Wazuh
docker-compose up -d
```

This deploys three containers: `wazuh.manager`, `wazuh.indexer`, `wazuh.dashboard`.

First startup takes 3–5 minutes. Access: `https://localhost`

**Default credentials:** `admin` / `SecretPassword`

**What you can practice:**
- Log ingestion and analysis
- Alert triage — real vs false positive
- Rule creation and tuning
- Incident response workflows
- File integrity monitoring

---

## Step 5 — Deploy Splunk

Splunk is the industry-standard SIEM used in most enterprise SOC environments.

```bash
docker run -d \
  --name splunk \
  -p 8000:8000 \
  -p 9997:9997 \
  -e SPLUNK_START_ARGS='--accept-license' \
  -e SPLUNK_GENERAL_TERMS='--accept-sgt-current-at-splunk-com' \
  -e SPLUNK_PASSWORD='changeme123' \
  splunk/splunk:latest
```

Wait ~2 minutes for startup, then access: `http://localhost:8000`

**Default credentials:** `admin` / `changeme123`

**What you can practice:**
- SPL (Splunk Processing Language) queries
- Creating dashboards and alerts
- Ingesting logs from Kali and Metasploitable2
- Threat hunting with search queries

---

## Step 6 — Verify All Containers

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

Expected output:
```
NAMES          STATUS          PORTS
splunk         Up X minutes    0.0.0.0:8000->8000/tcp
wazuh.manager  Up X minutes    ...
wazuh.indexer  Up X minutes    ...
wazuh.dashboard Up X minutes   0.0.0.0:443->443/tcp
juice-shop     Up X hours      0.0.0.0:3000->3000/tcp
dvwa           Up X hours      0.0.0.0:80->80/tcp
```

---

## Step 7 — Create Lab Startup Script

Save this script so you can start everything with one command:

```bash
cat > ~/start-lab.sh << 'EOF'
#!/bin/bash
echo "[*] Starting SOC + Pentesting Home Lab..."
docker start dvwa juice-shop splunk 2>/dev/null
cd ~/wazuh-docker/single-node && docker-compose up -d
echo ""
echo "[*] Lab is up! Access:"
echo "    DVWA:       http://localhost"
echo "    Juice Shop: http://localhost:3000"
echo "    Splunk:     http://localhost:8000"
echo "    Wazuh:      https://localhost"
echo "    Target:     192.168.117.129 (Metasploitable2)"
EOF
chmod +x ~/start-lab.sh
```

From now on, just run `~/start-lab.sh` every time you start Kali.

---

## Access Summary

| Tool | URL | Username | Password |
|---|---|---|---|
| DVWA | http://localhost | admin | password |
| Juice Shop | http://localhost:3000 | (register) | — |
| Wazuh | https://localhost | admin | SecretPassword |
| Splunk | http://localhost:8000 | admin | changeme123 |

---

## Next Step

→ [03 — Metasploitable2 Setup](03-metasploitable.md)
