#!/bin/bash
####----sysctl----####
sysctl -a | egrep "ipv4.*(accept|send)_redirects" | awk -F "=" '{print $1 "=0"}'
 > a.txt

cat a.txt >>/etc/sysctl.conf

cat /etc/sysctl.conf | sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1
/' /etc/sysctl.conf
sysctl -p
####----rpm----####
yum -y install strongswan openvpn zip curl wget

rpm -ivh flexgw-2.5.0-1.el6.x86_64.rpm

cp -f /usr/local/flexgw/rc/strongswan.conf /etc/strongswan/strongswan.conf
cp -f /usr/local/flexgw/rc/openvpn.conf /etc/openvpn/server.conf

cat /etc/strongswan/strongswan.d/charon/dhcp.conf | sed  -i 's/load = yes/#load
= yes/' /etc/strongswan/strongswan.d/charon/dhcp.conf

>/etc/strongswan/ipsec.secrets

echo "/etc/init.d/openvpn  start" >> /etc/rc.local
echo "sleep 5" >> /etc/rc.local
echo "/etc/init.d/strongswan  start" >> /etc/rc.local

ln -s /etc/init.d/initflexgw /etc/rc3.d/S98initflexgw