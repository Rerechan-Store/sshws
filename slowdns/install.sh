#!/bin/bash

# [ Membuat directory SlowDNS ]
mkdir -p /etc/slowdns

# [ Membaca Lokasi Nameserver SlwoDNS ]
nameserver=$(cat /etc/funny/.nsdomain)

# // Membersihkan Layar
clear

# [ Menampilkan Kata sebelum menginstall ]
echo " Memulai Instalasi "

# [ Menunggu 5detik sebelum melanjutkan instalasi ]
sleep 5

# [ Pergi ke Directory SlowDNS ]
cd /etc/slowdns

# [ Mengambil File Publik key & Private Key ]
wget -O server.key "https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/server.key"
wget -O server.pub "https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/server.pub"

# [ Mengambil File Core Slowdns ]
wget https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/sldns-client
wget https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/sldns-server

# [ Memberikan Izin agar file dapat di execute ]
chmod 777 /etc/slowdns/*

# [ Membuat Service Client ]
cat > /etc/systemd/system/client.service <<EOF
[Unit]
Description=SlowDNS By Rerechan02
Documentation=https://prof.rerechan02.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/sldns-client -udp 1.1.1.1:53 --pubkey-file /etc/slowdns/server.pub $nameserver 127.0.0.1:22
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# [ Membuar Service Server ]
cat > /etc/systemd/system/server.service <<END
[Unit]
Description=SlowDNS By FN_Project
Documentation=https://t.me/fn_project
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/sldns-server -udp 0.0.0.0:5300 -privkey-file /etc/slowdns/server.key $nameserver 127.0.0.1:22
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

# [ Melakukan Reload Semua Service ]
systemctl daemon-reload

# [ Menjalankan Service ]
systemctl enable server
systemctl enable client

# [ Memulai Service ]
systemctl start server
systemctl start client

# [ Melakukan Restart Service ]
systemctl restart server
systemctl restart client

# [ Membersihkan Layar ]
clear

# [ Menunggu 3 Detik ]
sleep 3

echo " Success Install SlowDNS FN Project "

# [ Menungu 5 detik ]
sleep 5

# [ Membersihkan Layar ]
clear
