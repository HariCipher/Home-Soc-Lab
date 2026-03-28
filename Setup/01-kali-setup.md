# 01 — Kali Linux Setup (VMware)

This guide covers setting up Kali Linux in VMware Workstation Player as the main attack platform for the home lab.

---

## Prerequisites

- [VMware Workstation Player 17](https://www.vmware.com/products/workstation-player.html) (free)
- [7-Zip](https://www.7-zip.org) for extracting the VM image
- ~15GB free disk space for the Kali VM

---

## Step 1 — Download Kali Linux VMware Image

Go to the official Kali Linux download page and download the pre-built VMware image:

👉 https://www.kali.org/get-kali/#kali-virtual-machines

- Click the **VMware** tab
- Download the **64-bit** `.7z` file (~3GB)

> Use the official pre-built VMware image — not the installer ISO. Default credentials are `kali` / `kali` and no display configuration is needed.

---

## Step 2 — Extract and Import

1. Right-click the downloaded `.7z` file → 7-Zip → **Extract to same folder**
2. Open VMware Workstation Player
3. Click **Open a Virtual Machine**
4. Navigate to the extracted folder and select the `.vmx` file
5. Click **Edit virtual machine settings** before starting and configure:

| Setting | Value |
|---|---|
| Memory | 6144 MB (6GB) |
| Processors | 4 (2 cores × 2) |
| Display → 3D Acceleration | OFF |

---

## Step 3 — First Boot

1. Click **Play virtual machine**
2. If VMware asks about moving/copying, select **I copied it**
3. Login with: `kali` / `kali`
4. Desktop should load immediately — no black screen, no display issues

---

## Step 4 — Update Kali

Open a terminal and run:

```bash
sudo apt update && sudo apt upgrade -y
```

This takes 5–10 minutes. Run it before installing anything else.

---

## Step 5 — Install VMware Guest Tools

For proper screen resizing and clipboard sharing:

```bash
sudo apt install -y open-vm-tools open-vm-tools-desktop
sudo reboot
```

After reboot, the display will auto-resize when you resize the VMware window.

---

## Step 6 — Configure Shell

Kali uses **zsh** by default. Add useful aliases to `~/.zshrc`:

```bash
echo 'alias ll="ls -la"' >> ~/.zshrc
echo 'alias ports="ss -tlnp"' >> ~/.zshrc
exec zsh
```

---

## Network Configuration

The lab uses VMware's **NAT** network by default, giving Kali and Metasploitable2 IPs in the same subnet:

| Machine | IP |
|---|---|
| Kali Linux | 192.168.117.128 |
| Metasploitable2 | 192.168.117.129 |

Verify connectivity:
```bash
ping 192.168.117.129 -c 3
```

---

## Verify Installation

```bash
# Check Kali version
cat /etc/os-release

# Check available tools
which nmap burpsuite metasploit-framework sqlmap
```

---

## Next Step

→ [02 — Docker Tools Setup](02-docker-tools.md)
