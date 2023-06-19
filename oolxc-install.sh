#!/bin/bash

while true; do
    read -p "This will Install OpenObserve, Proceed(y/n)?" yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) echo "Please answer yes or no." ;;
    esac
done
echo -e updating container
apt-get update
echo -e installing dependancies
apt-get install curl -y

mkdir /etc/oolxc
mkdir /usr/share/oolxc
mkdir /data
mkdir /data/oolxc
wget https://github.com/openobserve/openobserve/releases/download/v0.4.7/openobserve-v0.4.7-linux-amd64.tar.gz
tar -zxvf openobserve-v0.4.7-linux-amd64.tar.gz -C /usr/share/oolxc
rm openobserve-v0.4.7-linux-amd64.tar.gz
echo -e set environment
cat << EOF > /etc/oolxc.env
ZO_ROOT_USER_EMAIL = "oolxc@example.com"
ZO_ROOT_USER_PASSWORD = "OpenObserveLXC"
ZO_DATA_DIR = "/data/oolxc"
EOF
echo -e set up oolxc service
cat << EOF > /usr/lib/systemd/system/oolxc.service
[Unit]
Description=The OpenObserve container
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
LimitNOFILE=65535
EnvironmentFile=/etc/oolxc.env
ExecStart=/usr/share/oolxc/openobserve
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
echo -e reload daemon
systemctl daemon-reload
echo -e enable service to start at boot
systemctl enable oolxc
echo -e start oolxc service
systemctl start oolxc
msg_ok "service started"
systemctl status oolxc
echo -e you can now log in at http://<yourIP>:5080
echo -e login = oolxc@example.com
echo -e password = OpenObserveLXC
