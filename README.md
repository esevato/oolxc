tteck has added a script to create the container and install OO as a part of his Proxmox helper respository ...
https://tteck.github.io/Proxmox/

# Open Observe in a linux Container on Proxmox
>PREREQUISITE<br>
Must have Linux Container up and running.<br> I ran through this with a fresh debian 11 container on proxmox

Lets start by creating some directories ...
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
nano /etc/oolxc.env
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

ctrl-x

y

Enter

Now lets configure the service
```
nano /usr/lib/systemd/system/oolxc.service
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
EnvironmentFile=/etc/oolxc.env
ExecStart=/usr/share/oolxc/openobserve
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
Fire up the service
```
systemctl daemon-reload
systemctl enable oolxc
systemctl start oolxc
```
see if its running
```
systemctl status oolxc
```
to test service
```
curl -v http://localhost:5080/healthz
```
should return
{"status":"ok"}

Now visit your http://IP:5080 and use the login info you put in your environment variables to log in<br>
# MAD PROPS TO OPENOBSERVE TEAM FOR MAKING THIS SO DAMN EASY

