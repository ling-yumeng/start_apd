# Build

```sh
make
```



# Install on your local system

```sh
sudo cp -r build/* -t /
```



# Remove

```sh
sudo systemctl stop start_apd
sudo rm -r /etc/start_apd
sudo rm /usr/bin/start_apd
sudo rm /usr/lib/systemd/system/start_apd.service
sudo rm -r /usr/libexec/start_apd
```



# Enable Hot Spot

1. Make sure you've connected to a wlan
2. Check your wireless interface name. If it is not `wlan0`, edit `/usr/bin/start_apd`, replace `wlan0` at `WIRELESS_CARD=wlan0` with your real interface name, for example `wlp3s0`.
3. Start service with `systemctl start start_apd`



# Disable Host Spot

```sh
systemctl stop start_apd
```
