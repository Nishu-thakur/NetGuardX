#!/usr/bin/bash 

# Define colors for messages

#GLOBAL VARIABLE
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[34m'
NC='\033[0m' # No Color
IPTABLES=/sbin/iptables


# Function to display action menu

ask_action() {
    echo -e "\n${YELLOW}Choose an action:${NC}"
    echo -e "${BLUE}1) Insert${NC}"
    echo -e "${BLUE}2) Append${NC}"
    echo -e "${BLUE}3) Delete${NC}"
    echo -e "${BLUE}4) POLICY${NC}"
    read -p "Enter your choice {1-4}: " action_choice
    case "$action_choice" in
        1) action="-I";;
        2) action="-A";;
        3) action="-D";;
        4) action="-P";;
        *) echo -e "${RED}Invalid Choice!${NC}";exit 1;;
    esac
}

##### Function to choose chain
ask_chain() {
    echo -e "\n${YELLOW}Choose chain to modify:${NC}"
    echo -e "${BLUE}1) INPUT${NC}"
    echo -e "${BLUE}2) OUTPUT${NC}"
    echo -e "${BLUE}3) FORWARD${NC}"
    read -p "Enter your choice (1-3): " chain_choice
    case "$chain_choice" in
        1) chain="INPUT";;
        2) chain="OUTPUT";;
        3) chain="FORWARD";;
        *) echo -e "${RED}Invalid choice!${NC}";exit 1;;
    esac
}

# Function to ask for protocol
ask_protocol() {
    echo -e "\n${BLUE}Specify protocol (e.g., tcp,udp,icmp,igmp,all) or leave blank for none: ${NC}" 
    read -p":" protocol
    if [ "$protocol" == "tcp" ] || [ "$protocol" == "udp" ];then
        echo -e "${BLUE}Enter then source ports (leave blank if not needed): ${NC}" 
        read -p":" source_port
        echo -e "${BLUE}Enter the destination port (leave blank if not needed): ${NC}" 
        read -p":" dest_port
    fi        
    if [ "$protocol" == "tcp" ]; then
        echo -e "${BLUE}Do you want to specify TCP flags? (yes/no): ${NC}" 
        read -p":" tcp_choice
        if [ "$tcp_choice" == "yes" ]; then
            echo -e "${BLUE}Enter the TCP flags (e.g./ SYN,ACK,FIN,RST): ${NC}" 
            read -p":" tcp_flag

        fi
    elif [ "$protocol" == "icmp" ]; then
        echo -e "\n${BLUE}Choose an ICMP type:${NC}"
        echo -e "${BLUE}1). echo-request${NC}"
        echo -e "${BLUE}2). echo-reply${NC}"
        echo -e "${BLUE}3). destination-unreachable${NC}"
        echo -e "${BLUE}4). ttl-exceeded${NC}"
        echo -e "Enter the number corresponding to the ICMP type (leave blank if not needed): " 
        read -p":" icmp_choice
        case $icmp_choice in 
            1) icmp_type="echo-request";;
            2) icmp_type="echo-reply";;
            3) icmp_type="destination-unreachable";;
            4) icmp_type="timestamp-request";;
            *) icmp_type="";;
        esac
        if [ ! -z "$icmp_type" ];then
            echo "Selected ICMP type: $icmp_type"
        fi
    fi
    # Ask for the source IP address (optional)
    echo -e "\n${BLUE}Enter the source IP address (leave blank if not needed): ${NC}" 
    read -p":" source_ip

    # Ask for the destination IP address (optional)
    echo -e "\n${BLUE}Enter the destination IP address (leave blank if not needed): ${NC}" 
    read -p":" dest_ip

}


# Function to ask for state matching
ask_state_match() {
    echo -e "\n${BLUE}Do you want to match connection state (yes/no)? ${NC}" 
    read -p":" state_match
    if [ "$state_match" == "yes" ];then
        echo "[+] State (e,g.,NEW,ESTABLISHED,RELATED,INVALID)"
        read -p "Specify state: " state
        fi
}

# Function to ask for target action (-j)
ask_target_action() {
    echo -e "\n${YELLOW}Choose target action (-j):${NC}"
    echo -e "${BLUE}1) ACCEPT${NC}"
    echo -e "${BLUE}2) LOG${NC}"
    echo -e "${BLUE}3) DROP${NC}"
    echo -e "${BLUE}4) REJECT${NC}"
    echo -e "${BLUE}5) RETURN${NC}"
    read -p "Enter your choice (1-5): " target_choice
    case "$target_choice" in 
        1) target="ACCEPT";;
        2) target="LOG";;
        3) target="DROP";;
        4) target="REJECT";;
        5) target="RETURN";;
        *) echo -e "${RED}Invalid choice!${NC}"; exit 1;;
    esac
}

# Function to ask for looging options if -j LOG is selected
ask_logging_options(){
    read -p "Specify log prefix (optional) or leave blank: " log_prefix
    read -p "Log TCP options IP options  (yes/no)? " log_options
    read -p "LOG TCP SEQUENCE (yes/no)? " log_tcp_sequence
}


ask_string_match(){
    echo -e "\n${BLUE}Do you want to match a specific string in the packet (yes/no) ${NC}" 
    read -p":" string_match
    if [ "$string_match" == "yes" ];then
        echo -e "${BLUE}Specific the string to match (e.g., --string 'attack'): ${NC}" 
        read -p":" match_string
    fi    
}

ask_interface(){
    echo -e "\n${YELLOW}Do You Want to Add Interface${NC}"
    echo -e "${YELLOW}Choose interface${NC}"
    echo -e "${BLUE}1) wlp2-${NC}"
    echo -e "${BLUE}2) enp0-${NC}"
    echo -e "${BLUE}3) lo${NC}"
    read -p "Enter your choice (1-3): " interface_choice
    case $interface_choice in
        1) interface="wlp2s0";;
        2) interface="enp0s31f5";;
        3) interface="lo";;
        *) interface=""
    esac
}

# Delete rule 
perform_deltion(){
    echo -e "${BLUE}[+] Delete By Rule Number${NC}"
    sleep 2
    $IPTABLES -L $chain --line-numbers
    read -p "Enter rule number:-" number
    $IPTABLES -D $chain $number
    echo -e "\n${BLUE}[+] Succesfully Deleted${NC}"
}

build_rule() {
    # asking for action
    ask_action
    ask_chain

    rule="$action $chain"
    
    if [ "$action" == "-P" ];then
        ask_target_action
        rule+=" $target"
     #### firewall rule submission
        execute_rule
     #### exit the script
        exit 1
    fi

    if [ "$action" == "-D" ];then
        perform_deltion
        exit 1
    fi
    
    ask_protocol
    
    if [ -n "$protocol" ];then
        case "$protocol" in 
            tcp)
                rule+=" -p $protocol"
                if [ -n "$tcp_flag" ];then
                    rule+=" --tcp-flags $tcp_flag"
                fi
                if [ -n "$source_port" ];then
                    rule+=" --sport $source_port"
                fi
                if [ -n "$dst_ip" ];then
                    rule+=" --dport $dest_port"
                fi
                ;;
            udp)
                rule+=" -p $protocol"
                if [ -n "$source_ip" ];then
                    rule+=" --sport $source_port"
                fi
                if [ -n "$dst_ip" ];then
                    rule+=" --dport $dest_port"
                fi
                ;;
            icmp)
                rule+=" -p $protocol"
                if [ -n "$icmp_type" ];then
                    rule+=" --icmp-type $icmp_type"
                fi
                ;;
        esac
    fi 

    # Ask Interfaces
    ask_interface
    if [ -n $interface ];then
        rule+=" -i $interface"
    fi
    # SOURCE IP AND DESTINATION ADDRESS
    if [ -n "$source_ip" ];then
        rule+=" -s $source_ip"
    fi
    if [ -n "$dest_ip" ];then
        rule+=" -d $dest_ip"
    fi

    #### IF PROTOCOL IS TCP THEN ASK_state
    if [ "$protocol" == "tcp" ];then
        ask_state_match

        if [ "$state_match" == "yes" ] &&  [ -n "$state" ];then
            rule+=" -m state --state $state"
        fi
    fi


    # Any String Match
    ask_string_match
    if [ "$string_match" == "yes" ] && [ -n "$match_string" ];then
        rule+=' -m string --string "$match_string" --algo bm'
    fi

    ask_target_action

    if [ -n "$target" ];then
        rule+=" -j $target"
    fi

    if [ "$target" == "LOG" ];then
        ask_logging_options
        [ -n "$log_prefix" ] && rule+=" --log-prefix \"$log_prefix \""
        [ "$log_options" == "yes" ] && rule+=" --log-ip-options --log-tcp-options"
        [ "$log_tcp_sequence" == "yes" ] && rule+=" --log-tcp-sequence"
    fi  


}

execute_rule(){
    $IPTABLES $rule
}

flush_file(){
    $IPTABLES -F
    $IPTABLES -P INPUT ACCEPT
    $IPTABLES -P OUTPUT ACCEPT
    $IPTABLES -P FORWARD ACCEPT
    echo -e "${BLUE}#- SuccessFully Flushed...."
}

backup_file(){
    iptables-save > /root/ipt.save
    echo -e "${BLUE}#- SuccessFully Backuped...."
}
restore_file(){
    cat /root/ipt.save | iptables-restore
    echo -e " ${BLUE}#- SuccesFully Restored...."
}


###### rule builder
if [ $1 ];then
    case $1 in 
        --backup)backup_file;;
        --flush)flush_file;;
        --restore)restore_file;;
        --edit)build_rule;;
    esac
fi

###### rule executer
#



































### Check for backup 
if [ -f /root/ipt.save ];then
    cat /root/ipt.save | iptables-restore
else
    ./iptables.sh
    iptables-save > /root/ipt.save
fi



