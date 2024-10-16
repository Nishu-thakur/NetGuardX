# NetGuardX

**NetGuardX** is a powerful and flexible network security tool developed to manage firewall rules, monitor intrusions, and enhance your network's defense. Designed with simplicity and effectiveness in mind, **NetGuardX** offers intuitive firewall management and intrusion detection functionalities while working seamlessly in the background to enforce robust security measures.

---

## Features

**NetGuardX** is divided into two main functionalities:

### 1. Firewall Management (`fire`)
- **Interactive Firewall Configuration**: Allows users to interactively set up and manage firewall rules by choosing chains, targets, and ports.
- **Reset Option**: Easily reset the firewall to default settings with a simple command.
- **Flush Option**: Clear all existing firewall rules in one command.
- **Backup and Restore**: Backup current firewall rules and restore them later as needed, ensuring a smooth rollback process in case of misconfigurations.

*Automatic Security Enhancement*: Whenever firewall rules are updated, **NetGuardX** automatically applies additional protection by enhancing iptables with Snort rules in the background using `fwsnort`. This process is fully transparent to the user.

### 2. Intrusion Detection (`intr`)
- **Email Alerts**: Receive email alerts about potential intrusions in your network.
- **Log File Analysis**: Analyze log files for detailed information on intrusion attempts.
- **Status Checks**: Display the current status of the intrusion detection system (IDS) using `psad` and monitor network traffic for anomalies.
- **Detailed Reports**: Get detailed reports on network activity and potential threats.

---

## Installation

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/Nishu-thakur/NetGuardX.git
```

### 2. Run the Setup Script

Before executing **NetGuardX**, ensure all dependencies are installed by running the `setup.sh` script:

```bash
cd NetGuardX
sudo ./setup.sh
```

The `setup.sh` script will automatically install required dependencies like `psad`, `iptables`, `fwsnort`, and other necessary tools for proper functioning of **NetGuardX**.

### 3. Make the NetGuardX Script Executable

Once the setup is complete, make the main script executable:

```bash
chmod +x netguardx
```

### 4. Run NetGuardX

Now, you can run **NetGuardX** with the desired command:

```bash
sudo ./netguardx [command]
```

---

## Usage

### Help Menu
To view available options and usage instructions for **NetGuardX**, use the following command:

```
netguardx --help
```

### Firewall Management (`fire`)

To interactively manage your firewall, simply run:

```
netguardx fire
```

**Options**:
- **Reset Firewall Rules**: Reset all firewall rules to default settings:
    ```
    netguardx fire --reset
    ```
  
- **Flush Firewall Rules**: Flush all the current firewall rules:
    ```
    netguardx fire --flush
    ```

- **Backup Firewall Rules**: Backup current iptables rules to a file:
    ```
    netguardx fire --backup
    ```

- **Restore Firewall Rules**: Restore previously backed-up firewall rules:
    ```
    netguardx fire --restore
    ```

### Intrusion Detection (`intr`)

To monitor your network for intrusions and view system status, use:

```
netguardx intr
```

---

## Team

**NetGuardX** is developed by **The GuardX Team**, a group of passionate cybersecurity enthusiasts dedicated to building open-source security tools.


---

### Summary of Changes:
- Added a **setup step** that instructs users to execute `setup.sh` before running **NetGuardX**.
- This ensures that all required dependencies are installed and configured.
