#!/bin/bash

arc=$(uname -snrvmo)
pcpu=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
tram=$(free -m | awk '$1 == "Mem:" {print $2}')
fram=$(free -m | awk '$1 == "Mem:" {print $4}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(expr ${uram} \* 100 / ${tram})
tdisk=$(df -Bg --total | awk '$1 == "total" {print($2)}' | awk '{print substr($1,1,length($1)-1)}')
fdisk=$(df -Bg --total | awk '$1 == "total" {print($4)}' | awk '{print substr($1,1,length($1)-1)}')
udisk=$(df -Bg --total | awk '$1 == "total" {print($3)}' | awk '{print substr($1,1,length($1)-1)}')
pdisk=$(df -Bg --total | awk '$1 == "total" {print($5)}' | awk '{print substr($1,1,length($1)-1)}')
cpul=$(top -bn1 | awk '$1 == "%Cpu(s):" {printf("%.1f%%"), $2 + $3 + $4 + $6}')
lb=$(who -b | awk '$1 == "system" {printf("%s %s",$3, $4)}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [[ ${lvmt} -eq 0 ]]; then echo "no"; else echo "yes"; fi)
ntcp=$(netstat -at | grep "ESTABLISHED" | wc -l)
ulog=$(who | wc -l)
ip=$(hostname -I)
mac=$(ip a | awk '$1 == "link/ether" {print $2}')
scmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


echo "#Architecture: ${arc}
#CPU physical: ${pcpu}
#vCPU: ${vcpu}
#Memory Usage: ${fram}/${tram}MB (${pram}%)
#Disk Usage: ${fdisk}/${tdisk}Gb (${pdisk}%)
#CPU load: ${cpul}
#Last boot: ${lb}
#LVM use: ${lvmu}
#Connexions TCP: ${ntcp} ESTABLISHED
#User log: ${ulog}
#Network: IP ${ip} (${mac})
#Sudo: ${scmd} cmd" | wall
