# Configuration File Editing Instructions

## Setting psad Configuration

1. Open the configuration file:
   ```bash
   sudo nano /etc/psad/psad.conf
Update the following lines:

Set the email addresses:

plaintext
Copy code
EMAIL_ADDRESSES your_email@example.com
Enable persistence:

plaintext
Copy code
ENABLE_PERSISTENCE Y
Set syslog file and daemon:

plaintext
Copy code
ENABLE_SYSLOG_FILE Y
IPT_SYSLOG_FILE /var/log/syslog
SYSLOG_DAEMON rsyslog
Set minimum danger level and email alert danger level:

plaintext
Copy code
MIN_DANGER_LEVEL 1
EMAIL_ALERT_DANGER_LEVEL 2
Save and exit the editor (CTRL + X, then Y, then Enter).

Restart psad to apply changes:

bash
Copy code
sudo systemctl restart psad
Setting fwsnort Configuration
Open the fwsnort configuration file:

bash
Copy code
sudo nano /etc/fwsnort/fwsnort.conf
Make necessary adjustments as needed.

Save and exit the editor.

Adding Your Email Address to manager_file.json
Open the manager_file.json:

bash
Copy code
sudo nano /path/to/manager_file.json
Add your email address:

json
Copy code
{
    "email": "your_email@example.com"
}
Save and exit the editor.
