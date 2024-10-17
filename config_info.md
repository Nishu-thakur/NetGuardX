## **Configuration File Editing Instructions**

### **1. Setting up psad Configuration**

1. **Open the psad configuration file:**
   ```bash
   sudo nano /etc/psad/psad.conf
   ```

2. **Update the following lines:**
   - **Set the email address for alerts:**
     ```plaintext
     EMAIL_ADDRESSES your_email@example.com
     ```
   - **Enable persistence:**
     ```plaintext
     ENABLE_PERSISTENCE Y
     ```
   - **Set syslog file and daemon:**
     ```plaintext
     ENABLE_SYSLOG_FILE Y
     IPT_SYSLOG_FILE /var/log/syslog
     SYSLOG_DAEMON rsyslog
     ```
   - **Set minimum danger level and email alert danger level:**
     ```plaintext
     MIN_DANGER_LEVEL 1
     EMAIL_ALERT_DANGER_LEVEL 2
     ```

3. **Save and exit the editor:**
   - Press `CTRL + X`, then `Y`, and hit `Enter` to save the changes.

4. **Restart psad to apply the changes:**
   ```bash
   sudo systemctl restart psad
   ```

---

### **2. Setting up fwsnort Configuration**

1. **Open the fwsnort configuration file:**
   ```bash
   sudo nano /etc/fwsnort/fwsnort.conf
   ```

2. **Make necessary adjustments** according to your needs. Common settings you might update include log levels, alert thresholds, etc.

