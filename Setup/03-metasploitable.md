# 03 — Metasploitable2 Setup

Metasploitable2 is an intentionally vulnerable Linux virtual machine designed for practicing penetration testing techniques. It serves as the primary attack target in this home lab.

---

## Prerequisites

- VMware Workstation Player 17 installed
- Kali Linux VM running (see [01-kali-setup.md](01-kali-setup.md))
- ~3GB free disk space

---

## Step 1 — Download Metasploitable2

Download from SourceForge:

👉 https://sourceforge.net/projects/metasploitable/files/Metasploitable2/

File: `metasploitable-linux-2.0.0.zip` (~800MB)

Extract with 7-Zip after downloading.

---

## Step 2 — Import into VMware

1. Open VMware Workstation Player
2. Click **Open a Virtual Machine**
3. Navigate to extracted folder → select `Metasploitable.vmx`
4. Click **Edit virtual machine settings** and configure:

| Setting | Value |
|---|---|
| Memory | 512 MB |
| Processors | 1 |
| Network Adapter | NAT (same as Kali) |

---

## Step 3 — First Boot

1. Click **Play virtual machine**
2. If VMware asks about moving/copying → select **I copied it**
3. Wait for boot (takes ~30 seconds)
4. Login at the prompt:
   - Username: `msfadmin`
   - Password: `msfadmin`

---

## Step 4 — Verify Network

Get the IP address:
```bash
ifconfig
```

Note the `eth0` IP — should be `192.168.117.129` if on the same NAT network as Kali.

From **Kali terminal**, verify connectivity:
```bash
ping 192.168.117.129 -c 3
```

---

## Step 5 — Full Port Scan from Kali

Run a service version scan to see all available attack surfaces:

```bash
nmap -sV 192.168.117.129
```

Expected output — 23 open ports including:

| Port | Service | Version |
|---|---|---|
| 21 | FTP | vsftpd 2.3.4 (backdoor!) |
| 22 | SSH | OpenSSH 4.7p1 |
| 23 | Telnet | Linux telnetd |
| 80 | HTTP | Apache 2.2.8 |
| 139/445 | SMB | Samba 3.x |
| 3306 | MySQL | 5.0.51a |
| 5432 | PostgreSQL | 8.3.0 |
| 8180 | HTTP | Apache Tomcat |

---

## Vulnerable Services — Practice Targets

### High Priority (beginner-friendly)

| Service | Port | Vulnerability | Tool |
|---|---|---|---|
| vsftpd 2.3.4 | 21 | Backdoor command execution | Metasploit |
| Samba | 139/445 | usermap_script exploit | Metasploit |
| Tomcat | 8180 | Default credentials + WAR upload | Manual / Metasploit |
| MySQL | 3306 | No root password | mysql client |
| Telnet | 23 | Clear text credentials | telnet |

### Web Applications

Metasploitable2 also runs several vulnerable web apps on port 80:
- **DVWA** — `http://192.168.117.129/dvwa`
- **Mutillidae** — `http://192.168.117.129/mutillidae`
- **phpMyAdmin** — `http://192.168.117.129/phpmyadmin`
- **WebDAV** — `http://192.168.117.129/dav`

---

## Important — Keep Metasploitable2 Isolated

Metasploitable2 must **never** be exposed to the internet. Always keep the network adapter set to **NAT or Host-Only** in VMware — never Bridged.

---

## Network Overview

```
Kali Linux (attacker)     →    Metasploitable2 (target)
192.168.117.128                192.168.117.129
```

Both VMs share the same VMware NAT network, allowing direct communication without internet exposure.

---

## Next Step

→ Return to [README.md](../README.md) to start practicing attack scenarios.
