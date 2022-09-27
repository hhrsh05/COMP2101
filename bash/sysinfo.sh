#!/bin/bash
#My lab 1 script 
#echo will show us the whatever you wirte in front of it  
echo "FQDN:"
#hostname -A will tell us the hostname 
hostname -A
echo "Host Inforamtion:"
#hostnamectl will give us the all information about the operating system 
hostnamectl   
echo "IP Addresses :" 
#these both commands will give us the IP addresses 
ip a s ens33 | grep -w inet | awk '{print $2}'
ip a s ens33 | grep -w inet6 | awk '{print $2}'
echo "Root Filesystem status:"
#df -h will give us the information about rootfile system  
df -h /dev/sda3

