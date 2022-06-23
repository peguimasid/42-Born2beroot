#!/bin/bash

FREE_RAM=$(free -m | awk '$1 == "Mem:" {print $2}')
USED_RAM=$(free -m | awk '$1 == "Mem:" {print $3}')
USED_RAM_PERCENT=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

FREE_DISK=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
USED_DISK=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
USED_DISK_PERCENT=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft += $2} END {printf("%d"), ut/ft*100}')

NUMS_OF_LVM=$(lsblk | grep "lvm" | wc -l)

ARCHITECTURE=$(uname -a)
CPU_PHYSICAL=$(nproc)
V_CPU=$(cat /proc/cpuinfo | grep processor | wc -l)
MEM_USAGE="${USED_RAM}/${FREE_RAM}MB (${USED_RAM_PERCENT}%)"
DISK_USAGE="${USED_DISK}/${FREE_DISK}Gb (${USED_DISK_PERCENT}%)"
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
LAST_BOOT=$(who -b | awk '$1 == "system" {print $3 " " $4}')
LVM_USE=$(if [ NUMS_OF_LVM -eq 0 ]; then echo no; else echo yes; fi)
# Run [sudo apt install net-tools] to this works
CONNECTIONS_TCP=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
USER_LOG=$(users | wc -w)
NETWORK="IP $(hostname -I) $(ip link show | awk '$1 == "link/ether" {print $2}')"
SUDO=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

echo "	#Architecture: ${ARCHITECTURE}"
echo "	#CPU physical: ${CPU_PHYSICAL}"
echo "	#vCPU: ${V_CPU}"
echo "	#Memory Usage: ${MEM_USAGE}"
echo "	#Disk Usage: ${DISK_USAGE}"
echo "	#CPU load: ${CPU_LOAD}"
echo "	#Last boot: ${LAST_BOOT}"
echo "	#LVM use: ${LVM_USE}"
echo "	#Connections TCP: ${CONNECTIONS_TCP} ESTABLISHED"
echo "	#User log: ${USER_LOG}"
echo "	#Network: ${NETWORK}"
echo "	#Sudo: ${SUDO} cmd"
