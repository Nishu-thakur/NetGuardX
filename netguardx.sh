#!/bin/bash

# Color Codes for styling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
RESET='\033[0m'
ARG=$#


# ASCII Art for NETGUARDX
banner() {
  echo -e "${CYAN}"
    echo " _        _______ _________ _______           _______  _______  ______           "
    echo "( (    /|(  ____ \\__   __/(  ____ \|\     /|(  ___  )(  ____ )(  __  \ |\     /|"
    echo "|  \  ( || (    \/   ) (   | (    \/| )   ( || (   ) || (    )|| (  \  )( \   / )"
    echo "|   \ | || (__       | |   | |      | |   | || (___) || (____)|| |   ) | \ (_) / "
    echo "| (\ \) ||  __)      | |   | | ____ | |   | ||  ___  ||     __)| |   | |  ) _ (  "
    echo "| | \   || (         | |   | | \_  )| |   | || (   ) || (\ (   | |   ) | / ( ) \ "
    echo "| )  \  || (____/\   | |   | (___) || (___) || )   ( || ) \ \__| (__/  )( /   \ )"
    echo "|/    )_)(_______/   )_(   (_______)(_______)|/     \||/   \__/(______/ |/     \|"
                                                                                 

  echo -e "${YELLOW}                The GuardX Team${RESET}"
}

# Tool Description
tool_info() {
  echo -e "${GREEN}Welcome to NETGUARDX - Advanced Network Intrusion Detection and Security Tool${RESET}"
  echo -e "${WHITE}Developed by: The GuardX Team${RESET}"
  echo
  echo -e "${BLUE}NETGUARDX Features:${RESET}"
  echo -e "${MAGENTA}1. Intrusion Detection and Prevention"
  echo -e "2. Real-time Network Monitoring"
  echo -e "3. Customizable Security Alerts"
  echo -e "4. Lightweight and Fast Performance"
  echo -e "5. Easy Integration with Firewalls${RESET}"
  echo
  echo "Commands:"
  echo "  fire      Manage firewall settings."
  echo "  intr      Monitor intrusion alerts."
  echo
  echo "For more information on each command, use:"
  echo "  netguardx fire --help"
  echo "  netguardx intr --help"
  echo
}

#monitor the intruder log file 
monitor_room(){
    INTRU=./intrusion.sh
    case $1 in 
        --help) tool_info
                $INTRU $1
                ;;
        --email-alert) $INTRU $1;;
        --Status) $INTRU $1;;
        -A) $INTRU $1;;
        *) tool_info
            ;;
    esac
}

# Fire command help with reset, flush, backup, and restore options

fire_help() {
    echo "Firewall Management (fire):"
    echo "  Usage: netguardx fire"
    echo
    echo "Description:"
    echo "  This command will interactively ask you to manage your firewall rules."
    echo "  You will be prompted to select chains (INPUT, OUTPUT, FORWARD), target actions, and ports."
    echo
    echo "Additional Options:"
    echo "  --reset      Reset the firewall rules to default settings."
    echo "  --edit       manuplate the firewall"
    echo "  --flush      Flush all the current firewall rules."
    echo "  --backup     Backup the current firewall rules to a file."
    echo "  --restore    Restore firewall rules from a backup file."
    echo
    echo "  Use --reset if you want to restore the default firewall rules, --flush to clear all existing rules."
    echo "  Use --backup to create a backup of your current iptables rules, and --restore to apply a backup."
    echo
}

firewall_room(){
    fire=./firewall.sh

    case $1 in 
        --help) tool_info
                fire_help;;
        --reset) ./iptables.sh && echo -e "\n${BLUE}Successfully Reset...";;
        --flush) $fire $1;;
        --backup) $fire $1;;
        --restore) $fire $1;;
        --edit) $fire $1;;
        *) fire_help
    esac
}


# Main Function to run banner and tool info

banner

if [ "$UID" == "0" ];then
    if [ $# -gt 0 ];then
        case $1 in 
        --help) tool_info;;
        intr) [ -n "$2" ] && monitor_room $2;; 
        fire) [ -n "$2" ] && firewall_room $2;;
        *) echo -e "${BLUE}[+]hahaha you don't know --help${NC}"
        esac
    fi
else
    echo -e "${RED}Permission Denied${NC}"
    echo -e "${RED}You Don't Have Permission${NC}"
fi