# Open Observe in a linux Container on Proxmox

mkdir /etc/oolxc

mkdir /usr/share/oolxc

mkdir /data

mkdir /data/oolxc

cd /usr/share/oolxc

wget https://github.com/openobserve/openobserve/releases/download/v0.4.7/openobserve-v0.4.7-linux-amd64.tar.gz

tar -zxvf openobserve-v0.4.7-linux-amd64.tar.gz

rm openobserve-v0.4.7-linux-amd64.tar.gz

cd ~

nano /etc/openobserve.env

///// copy and edit the following to your liking ///////////

ZO_ROOT_USER_EMAIL = "root@example.com"

ZO_ROOT_USER_PASSWORD = "Complexpass#123"

ZO_DATA_DIR = "/data/oolxc"

/////////////////////////////

ctrl-x

ctrl-y

nano /usr/lib/systemd/system/openobserve.service

///// copy and edit the following to your liking ///////////

[Unit]

Description=The OpenObserve server

After=syslog.target network-online.target remote-fs.target nss-lookup.target

Wants=network-online.target


[Service]

Type=simple

LimitNOFILE=65535

EnvironmentFile=/etc/openobserve.env

ExecStart=/usr/share/oolxc

ExecStop=/bin/kill -s QUIT $MAINPID

Restart=on-failure

[Install]

WantedBy=multi-user.target

/////////////////////////////


systemctl daemon-reload

systemctl enable openobserve

systemctl start openobserve

systemctl status openobserve

to test service

curl -v http://localhost:5080/healthz

should return

{"status":"ok"}

