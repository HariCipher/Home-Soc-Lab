# 🛡️ Home SOC Lab

A fully functional dual-track **Security Operations Center (SOC) + Penetration Testing** home lab built on Kali Linux using VMware and Docker. Designed for hands-on practice in threat detection, log analysis, vulnerability exploitation, and web application security.

---

## 📋 Overview

This lab was built to develop real-world cybersecurity skills across both offensive and defensive security domains — the same tools and workflows used in professional SOC environments.

| Category | Tools |
|---|---|
| **SIEM & Monitoring** | Wazuh, Splunk |
| **Web App Pentesting** | DVWA, OWASP Juice Shop |
| **Exploitation Target** | Metasploitable2 |
| **Attack Platform** | Kali Linux |

---

## 🏗️ Lab Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     VMware Workstation                  │
│                                                         │
│  ┌─────────────────────┐    ┌──────────────────────┐   │
│  │   Kali Linux VM      │    │  Metasploitable2 VM  │   │
│  │  192.168.117.128     │───▶│  192.168.117.129     │   │
│  │                      │    │                      │   │
│  │  Docker Containers:  │    │  Vulnerable Services:│   │
│  │  ├── DVWA (:80)      │    │  ├── FTP (21)        │   │
│  │  ├── Juice Shop      │    │  ├── SSH (22)        │   │
│  │  │   (:3000)         │    │  ├── HTTP (80)       │   │
│  │  ├── Wazuh (:443)    │    │  ├── MySQL (3306)    │   │
│  │  └── Splunk (:8000)  │    │  └── 18+ more ports  │   │
│  └─────────────────────┘    └──────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

**Attack flow:** Kali Linux → attacks → Metasploitable2 / DVWA / Juice Shop → logs → Wazuh / Splunk

---

## 🧰 Tools & Purpose

### Offensive (Red Team)

| Tool | Purpose |
|---|---|
| **Kali Linux** | Main attack platform with 600+ pre-installed security tools |
| **DVWA** (Damn Vulnerable Web App) | Practice OWASP Top 10 web vulnerabilities in a controlled environment |
| **OWASP Juice Shop** | Modern vulnerable web app for XSS, SQLi, broken auth, and more |
| **Metasploitable2** | Intentionally vulnerable Linux VM — practice real exploitation techniques |

### Defensive (Blue Team / SOC)

| Tool | Purpose |
|---|---|
| **Wazuh** | Open-source SIEM — security monitoring, log analysis, threat detection, incident response |
| **Splunk** | Industry-standard SIEM — search, analyze, and visualize security events in real time |

---

## 💻 Host System

| Component | Spec |
|---|---|
| OS | Windows 11 |
| RAM | 16GB |
| GPU | NVIDIA RTX 4050 |
| Hypervisor | VMware Workstation Player 17 |

---

## 🚀 Quick Start

### Prerequisites
- VMware Workstation Player 17 (free)
- 7-Zip for extracting VM images
- At least 40GB free disk space
- 16GB RAM recommended

### Step 1 — Clone this repo
```bash
git clone https://github.com/HariCipher/Home-SOC-Lab.git
cd Home-SOC-Lab
```

### Step 2 — Set up Kali Linux VM
See [setup/01-kali-setup.md](setup/01-kali-setup.md)

### Step 3 — Deploy Docker tools
See [setup/02-docker-tools.md](setup/02-docker-tools.md)

### Step 4 — Set up Metasploitable2
See [setup/03-metasploitable.md](setup/03-metasploitable.md)

### Step 5 — Start the lab
```bash
~/start-lab.sh
```

---

## 🌐 Access URLs

| Tool | URL |
|---|---|
| DVWA | http://localhost |
| Juice Shop | http://localhost:3000 |
| Wazuh Dashboard | https://localhost |
| Splunk | http://localhost:8000 |
| Metasploitable2 | 192.168.117.129 |

---

## 🎯 Practice Scenarios

### SOC / Blue Team
- Monitor live attack traffic in Wazuh as you exploit Metasploitable2
- Ingest Kali scan logs into Splunk and create custom dashboards
- Set up Wazuh rules to detect Nmap scans and brute force attempts
- Practice alert triage — distinguish false positives from real threats

### Pentesting / Red Team
- Exploit vsftpd 2.3.4 backdoor on Metasploitable2 via Metasploit
- Practice SQL Injection, XSS, Command Injection on DVWA
- Complete OWASP Juice Shop challenges
- Run full recon → exploitation → post-exploitation chain

---

## 📁 Repository Structure

```
Home-SOC-Lab/
├── README.md
├── setup/
│   ├── 01-kali-setup.md        ← VMware + Kali setup guide
│   ├── 02-docker-tools.md      ← DVWA, Juice Shop, Splunk, Wazuh
│   └── 03-metasploitable.md    ← target VM setup
├── architecture/
│   └── lab-diagram.md          ← full network diagram + port reference
├── scripts/
│   └── start-lab.sh            ← one-command lab startup script
└── assets/
    └── Screenshots           ← dashboard and tool screenshots
```

---

## 🔗 Related

- [SOC Practice & Attack Writeups](https://github.com/HariCipher) — documentation of attacks, findings, and SOC exercises performed in this lab *(coming soon)*

---

## 👤 Author

**Harilal P** — Cybersecurity Student | SOC Analyst Trainee  
[GitHub](https://github.com/HariCipher) · [LinkedIn](https://linkedin.com/in/thisisharilal)

---

> ⚠️ **Disclaimer:** This lab is for educational purposes only. All tools and techniques are practiced in an isolated, controlled environment. Never use these techniques on systems you do not own or have explicit permission to test.
