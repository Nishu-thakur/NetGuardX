#!/usr/bin/bash 
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[34m'
NC='\033[0m'

# Function to check if PSAD is running
check_psad() {
    if systemctl is-active --quiet psad; then
        echo "PSAD is running."
    else
        echo "PSAD is not running. Starting PSAD..."
        sudo systemctl start psad
        
        if systemctl is-active --quiet psad; then
            echo "PSAD started successfully."
        else
            echo "Failed to start PSAD. Exiting."
            exit 1
        fi
    fi
}


show_help() {
    echo "Intrusion Detection (intr):"
    echo "  Usage: netguardx intr [options]"
    echo
    echo "Options:"
    echo "  --email-alert   View email alerts for intrusion detection."
    echo "  -A              Analyze the log file for intrusion attempts."
    echo "  --status        Display current status of intrusion detection."
    echo "  --help          Show this help menu for the intr command."
    echo
    echo "Description:"
    echo "  This command helps you monitor intrusion attempts, view alerts,"
    echo "  and analyze logs using the PSAD (Port Scan Attack Detection) backend."
    echo
}



# Function to simulate checking for email alerts
function check_email_alert {
    # Here, you would implement logic to check for email alerts
    # For demonstration, we simulate finding an email
    MAIL_FILE=$(python manager.py GET MAIL_F)
    if [ -f $MAIL_FILE ];then

            DATE=$(cat $MAIL_FILE | grep -o -E  "[A-Za-Z]{3} [A-Za-Z]{3} [0-9]{2}(.*) =" | sort -nr | head -n1)
            STORED_DATE=$(python manager.py GET MAIL_C)
            if [ "$DATE" == "$STORED_DATE" ];then
                echo -e "${GREEN} [+] NO ALERT...${NC}"
            else
                vi $MAIL_FILE
                # SAVED DATE 
                python manager.py MOD MAIL_C "$DATE"
            fi
    else
        echo -e "${RED}[+]MAIL BOX NOT PRESENT...${NC}"
        echo -e "${RED}[+]UPDATE MAIL BOX PATH IN manager_file.json${NC}"
    fi
}

check_psad
if [ "$UID" == "0" ];then

    if [ $# == 1 ];then
        if [ "$1" == "--help" ];then
            show_help
        elif [ "$1" == "--email-alert" ];then
            check_email_alert
        elif [ "$1" == "-A" ];then
            psad -A
        elif [ "$1" == "--Status" ];then
            psad --Status
        fi
    else
        echo -e "${RED}[Usage] -h"
    fi

else
    echo -e "${RED}[+] Permission Denied${NC}"
    echo -e "${RED}[+] only root user access${NC}"
fi

