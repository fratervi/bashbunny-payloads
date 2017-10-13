#!/bin/bash

# Title: Get OS
# Description: Uses ethernet attack modes to attempt to identify the OS,
#		based on the win93 prank payload code.
# Author: FraterVI
# Version: 0.1
# Category: Extention
# Attackmodes: ECM_ETHERNET and RNDIS_ETHERNET

function GET_OS {
	ATTACKMODE ECM_ETHERNET
	QUACK DELAY 3000
	GET TARGET_IP
	if [ -z "${TARGET_IP}" ]; then
		echo "No Target IP" > /dev/null
		ATTACKMODE RNDIS_ETHERNET
		QUACK DELAY 3000
		GET TARGET_IP
		if [ -z "${TARGET_IP}" ]; then
			LED FAIL3
			OS=FAIL3
			exit 1
		else
			OS="WIN"
		fi
	else
		OS="LINUX"
	fi
	nmap -O -sV --osscan-guess $TARGET_IP > /root/udisk/loot/nmap_results.log
	grep -v 'unknown-linux' /root/udisk/loot/nmap_results.log | grep -i 'linux'
	RES=$?
	if [ $RES -eq 0 ]; then
		export OS='LINUX'
	else
		grep -v 'MAC Address' /root/udisk/loot/nmap_results.log |grep -i 'mac'
		RES=$?
		if [ $RES -eq 0 ]; then
			OS='MAC'
		else
			grep -i 'windows' /root/udisk/loot/nmap_results.log
			RES=$?
			if [ $RES -eq 0 ]; then
				OS="WIN"
			else
				OS="FAIL3"
			fi
		fi
	fi
}

export -f GET_OS
