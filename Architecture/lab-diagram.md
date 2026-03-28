# Lab Architecture

This document describes the network topology, component relationships, and data flow of the Home SOC Lab.

---

## Network Diagram

```
╔══════════════════════════════════════════════════════════════════════╗
║                     HOST MACHINE (Windows 11)                        ║
║                     16GB RAM | RTX 4050                              ║
║                     VMware Workstation Player 17                     ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║   ┌─────────────────────────────────┐                                ║
║   │      KALI LINUX VM              │                                ║
║   │      192.168.117.128            │                                ║
║   │      6GB RAM | 4 vCPUs          │                                ║
║   │                                 │                                ║
║   │   ┌─────────────────────────┐   │                                ║
║   │   │    DOCKER CONTAINERS    │   │                                ║
║   │   │                         │   │                                ║
║   │   │  ┌─────────────────┐    │   │                                ║
║   │   │  │ DVWA            │    │   │                                ║
║   │   │  │ :80             │    │   │                                ║
║   │   │  │ Web App Target  │    │   │                                ║
║   │   │  └─────────────────┘    │   │                                ║
║   │   │                         │   │                                ║
║   │   │  ┌─────────────────┐    │   │                                ║
║   │   │  │ Juice Shop      │    │   │                                ║
║   │   │  │ :3000           │    │   │                                ║
║   │   │  │ Web App Target  │    │   │                                ║
║   │   │  └─────────────────┘    │   │                                ║
║   │   │                         │   │                                ║
║   │   │  ┌─────────────────┐    │   │                                ║
║   │   │  │ Wazuh SIEM      │    │   │                                ║
║   │   │  │ :443            │    │   │   VMware NAT Network           ║
║   │   │  │ Threat Detection│    │   │   192.168.117.0/24             ║
║   │   │  └─────────────────┘    │   │                                ║
║   │   │                         │   │   ┌─────────────────────────┐  ║
║   │   │  ┌─────────────────┐    │   │   │  METASPLOITABLE2 VM     │  ║
║   │   │  │ Splunk SIEM     │    │◄──┼──▶│  192.168.117.129        │  ║
║   │   │  │ :8000           │    │   │   │  512MB RAM              │  ║
║   │   │  │ Log Analysis    │    │   │   │                         │  ║
║   │   │  └─────────────────┘    │   │   │  Open Ports:            │  ║
║   │   └─────────────────────────┘   │   │  21  FTP (vsftpd 2.3.4) │  ║
║   │                                 │   │  22  SSH                │  ║
║   │   Kali Tools:                   │   │  80  HTTP (Apache)      │  ║
║   │   • Nmap, Metasploit            │   │  139 SMB (Samba)        │  ║
║   │   • Burp Suite, SQLMap          │   │  3306 MySQL             │  ║
║   │   • Gobuster, Nikto             │   │  5432 PostgreSQL        │  ║
║   │   • Wireshark, Netcat           │   │  8180 Tomcat            │  ║
║   │   • Python security scripts     │   │  + 16 more ports        │  ║
║   └─────────────────────────────────┘   └─────────────────────────┘  ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

## Attack & Detection Flow

```
┌──────────────┐     Attack      ┌──────────────────────┐
│              │────────────────▶│  Metasploitable2     │
│  Kali Linux  │                 │  DVWA                │
│  (Attacker)  │────────────────▶│  Juice Shop          │
│              │                 └──────────┬───────────┘
└──────────────┘                            │
                                            │ Logs & Events
                                            ▼
                               ┌────────────────────────┐
                               │   Wazuh SIEM           │
                               │   • Alert Detection    │
                               │   • Log Analysis       │
                               │   • Threat Hunting     │
                               └────────────┬───────────┘
                                            │
                                            ▼
                               ┌────────────────────────┐
                               │   Splunk               │
                               │   • Log Ingestion      │
                               │   • Custom Dashboards  │
                               │   • SPL Queries        │
                               └────────────────────────┘
```

---

## Component Roles

### Attacker (Kali Linux)
The main offensive platform. Used to run scans, exploits, and web application attacks against targets in the lab.

### Targets
| Target | Type | Purpose |
|---|---|---|
| Metasploitable2 | VM | Network service exploitation — FTP, SMB, MySQL, SSH |
| DVWA | Docker | Web app pentesting — SQLi, XSS, Command Injection |
| Juice Shop | Docker | Modern web app security — OWASP Top 10 challenges |

### Monitoring (Blue Team)
| Tool | Role |
|---|---|
| Wazuh | Collects and analyses logs, triggers alerts on suspicious activity |
| Splunk | Ingests logs for search, visualisation, and threat hunting |

---

## Port Reference

### Kali Docker Services
| Port | Service |
|---|---|
| 80 | DVWA |
| 3000 | OWASP Juice Shop |
| 443 | Wazuh Dashboard |
| 8000 | Splunk Web UI |
| 9997 | Splunk data forwarder |

### Metasploitable2 Open Ports
| Port | Service | Vulnerability |
|---|---|---|
| 21 | FTP (vsftpd 2.3.4) | Backdoor RCE |
| 22 | SSH (OpenSSH 4.7p1) | Outdated version |
| 23 | Telnet | Clear text credentials |
| 25 | SMTP (Postfix) | Open relay |
| 80 | HTTP (Apache 2.2.8) | Multiple web apps |
| 139/445 | SMB (Samba) | usermap_script exploit |
| 1524 | Bindshell | Root shell |
| 3306 | MySQL 5.0.51a | No root password |
| 5432 | PostgreSQL 8.3 | Default credentials |
| 8180 | Apache Tomcat | Default credentials + WAR upload |

---

## Screenshots

> Add screenshots to the `assets/` folder and they will display here.

### Wazuh Dashboard
![Wazuh Dashboard](../Assets/Wazuh-Dashboard.png)

### Splunk Home
![Splunk Home](../Assets/Splunk-Dashboard.png)

### DVWA Login
![DVWA](../Assets/DVWA.png)

### Juice Shop
![OWASP-Juice Shop](../Assets/OWASP-Juice-Shop.png)

### Nmap Scan — Metasploitable2
![Nmap Scan](../Assets/nmap-metasploitable2.png)

### Docker Containers Running
![Docker PS](../Assets/docker-ps.png)
