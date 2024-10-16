Here is your updated README with the changes:

---

# NetGuardX

NetGuardX is a powerful and flexible network security tool developed to manage firewall rules, monitor intrusions, and enhance your network's defense. Designed with simplicity and effectiveness in mind, NetGuardX offers intuitive firewall management, intrusion detection, and robust security enforcement.

## Features

NetGuardX is divided into three main functionalities:

### 1. Firewall Management (fire)
- **Interactive Firewall Configuration**: Set up and manage firewall rules by editing chains, targets, and ports.
- **Reset Option**: Reset the firewall to default settings.
- **Flush Option**: Clear all existing firewall rules.
- **Backup and Restore**: Backup current firewall rules and restore them as needed.
- **List**: View existing firewall rules.

NetGuardX automatically applies additional protection by integrating Snort rules with iptables using fwsnort in the background.

### 2. Intrusion Detection (intr)
- **Email Alerts**: Receive intrusion notifications via email.
- **Log Analysis**: Analyze logs for details of potential attacks.
- **Status Checks**: Monitor system and network traffic anomalies.
- **Available Options**:
  - `-A`: Start intrusion detection.
  - `--email-alert`: Set up email notifications.
  - `--Status`: Check IDS status.

### 3. Run Mode (run)
- **Standard Mode**: General network security settings.
- **Strict Mode**: Enhanced, more aggressive security measures.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Nishu-thakur/NetGuardX.git
   ```

2. Run the setup script to install dependencies:

   ```bash
   cd NetGuardX
   sudo ./setup.sh
   ```

3. Make the script executable:

   ```bash
   chmod +x netguardx
   ```

4. Run NetGuardX with the desired command:

   ```bash
   sudo ./netguardx [command]
   ```

## Usage

- **Help Menu**: `netguardx --help`
  
### Firewall Management (fire)

- Edit firewall rules: `netguardx fire --edit`
- Reset rules: `netguardx fire --reset`
- Flush rules: `netguardx fire --flush`
- Backup rules: `netguardx fire --backup`
- List rules: `netguardx fire --list`

### Intrusion Detection (intr)
- Activate IDS: `netguardx intr -A`
- Set up email alerts: `netguardx intr --email-alert`
- Check IDS status: `netguardx intr --Status`

---

### Run Mode (run)
When you use `netguardx run`, it will prompt you to choose the security mode:
1. **Standard Mode**: General security settings.
2. **Strict Mode**: Enhanced security measures for maximum protection.

After selecting either option, NetGuardX applies the corresponding firewall and network security rules.

Example:
```bash
netguardx run
# Output:
# Enter number:
# 1) Standard
# 2) Strict
```


## Team

NetGuardX is developed by Panchrakshak, a group of passionate cybersecurity enthusiasts dedicated to building open-source security tools.

This addition makes it clear to users that they need to run `setup.sh` first for optimal functionality.

---
