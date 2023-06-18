# Open Observe in a linux Container on Proxmox

Lets start by creating some directories ...
mkdir /etc/oolxc
mkdir /usr/share/oolxc
mkdir /data
mkdir /data/oolxc
now lets move to where we want the binary to live 
```
cd /usr/share/oolxc
```
Now grab the binary
```
wget https://github.com/openobserve/openobserve/releases/download/v0.4.7/openobserve-v0.4.7-linux-amd64.tar.gz
```
unzip it
```
tar -zxvf openobserve-v0.4.7-linux-amd64.tar.gz
```
remove the archive so you just have the binary
```
rm openobserve-v0.4.7-linux-amd64.tar.gz
```
get back home
```
cd ~
```
create your environment variables
```
nano /etc/openobserve.env
```

///// copy and edit the following to your liking //////////
```
ZO_ROOT_USER_EMAIL = "root@example.com"
ZO_ROOT_USER_PASSWORD = "Complexpass#123"
ZO_DATA_DIR = "/data/oolxc"
```
/////////////////////////////
```
ctrl-x
```
```
ctrl-y
```
Now lets configure the service
```
nano /usr/lib/systemd/system/openobserve.service
```
///// copy and edit the following to your liking ///////////
```
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
```
/////////////////////////////

Fire up the service
```
systemctl daemon-reload
systemctl enable openobserve
systemctl start openobserve
```
see if its running
```
systemctl status openobserve
```
to test service
```
curl -v http://localhost:5080/healthz
```
should return
{"status":"ok"}

