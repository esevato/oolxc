#!/bin/bash
while true; do
    read -p "This will Install OpenObserve, Proceed(y/n)?" yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) echo "Please answer yes or no." ;;
    esac
done
echo -e updating debian
apt-get update
echo -e installing dependancies
apt-get install curl -y
mkdir /etc/oo
mkdir /usr/share/oo
mkdir /data
mkdir /data/oo
wget https://github.com/openobserve/openobserve/releases/download/v0.4.7/openobserve-v0.4.7-linux-amd64.tar.gz
tar -zxvf openobserve-v0.4.7-linux-amd64.tar.gz -C /usr/share/oo
rm openobserve-v0.4.7-linux-amd64.tar.gz
echo -e set environment
cat << EOF > /etc/oo.env
ZO_ROOT_USER_EMAIL = "oo@example.com"
ZO_ROOT_USER_PASSWORD = "OpenObserve"
ZO_DATA_DIR = "/data/oo"
EOF
echo -e set up oo service
cat << EOF > /usr/lib/systemd/system/oo.service
[Unit]
Description=The OpenObserve Server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
LimitNOFILE=65535
EnvironmentFile=/etc/oo.env
ExecStart=/usr/share/oo/openobserve
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
echo -e reload daemon
systemctl daemon-reload
echo -e enable service to start at boot
systemctl enable oo
echo -e start oo service
systemctl start oo
systemctl status oo
echo -e you can now log in at http://<yourIP>:5080
echo -e login = oo@example.com
echo -e password = OpenObserve
