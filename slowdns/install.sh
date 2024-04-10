#!/bin/bash
nsdomain=$(cat /etc/funny/.dns)
clear
echo " Memulai Installasi SlowDNS "
clear
sleep 3
rm -fr /etc/slowdns/*
mkdir -p /etc/slowdns
