# Open Observe in a linux Container on Proxmox
>PREREQUISITE<br>
Must have Linux Container up and running.<br> I ran through this with a fresh debian 11 container on proxmox

Lets start by creating some directories ...
>mkdir /etc/oolxc <br>
>mkdir /usr/share/oolxc<br>
>mkdir /data<br>
>mkdir /data/oolxc<br>

Let's grab the binary
```
wget https://github.com/openobserve/openobserve/releases/download/v0.4.7/openobserve-v0.4.7-linux-amd64.tar.gz
```
unzip it
```
tar -zxvf openobserve-v0.4.7-linux-amd64.tar.gz -C /usr/share/oolxc
```
now ditch the tar
```
rm openobserve-v0.4.7-linux-amd64.tar.gz
```
Now create your environment variables
```
nano /etc/openobserve.env
```

copy and edit the following to your liking
## This will be your login information. 
>Make sure your data directory matches what you created previously
```
ZO_ROOT_USER_EMAIL = "root@example.com"
ZO_ROOT_USER_PASSWORD = "Complexpass#123"
ZO_DATA_DIR = "/data/oolxc"
```
Exit and save
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
Copy and edit the following to your liking 
>Make sure your Environment file and binary locations are properly mapped<br>
>If you created the directories as shown above this should work fine
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

Now visit your http://IP:5080 and use the login info you put in your environment variables to log in<br>
# MAD PROPS TO OPENOBSERVE TEAM FOR MAKING THIS SO DAMN EASY

