#!/bin/bash
#My LAb 3 Script 
which lxd >/dev/null 
if [ $? -ne 0 ]; then 
    # you have to install lxd 
    echo "start installation of lxd by enetring password"
    sudo apt-get update
    sudo apt-get install lxd
    if [ $? -ne 0 ]; then
    #lxd installation is failed 
    	echo " lxd installation is failed "
    	exit 1
    fi
fi     
ip a s | grep -w lxdbr0
if [ $? -ne 0 ]; then 
	lxd init --auto
	if  [ $? -ne 0 ]; then
		echo " interface failed "
		exit 1
        fi
fi
#this will create our container  
lxc launch ubuntu:20.04  COMP2101-S22
#lxc list will show us containers 
lxc list 
containerIP=$(lxc list | grep -w IPV4 -v | awk '{ print$6 }')
sudo -- sh -c "echo $containerIP COMP2101-S22 >> /etc/hosts"
#this will install apache2 in conatiner 
lxc exec COMP2101-S22 -- apt install apache2
#this will start the apache2 web server 
lxc exec COMP2101-S22 -- systemctl start apache2
#curl will test that it is working 
curl http://comp2101-s22/
if [ $? -eq 0 ]; then
	echo "successfull"
	exit 0 
else 
	echo "failed"
	exit 1
fi
