#!/bin/sh

#----remove extra interfaces
#--network
uci delete network.wan
uci delete network.@switch[0]
uci delete network.@switch_vlan[0]
#--dhcp
uci delete dhcp.lan
uci delete dhcp.wan

#----disable ipv6
uci delete network.wan6
#uci delete network.lan.ip6assign
uci delete network.globals.ula_prefix
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

#----update lan specific settings - set static ip
#--TODO - update mac from chip/nvram
#uci set network.lan.macaddr='fe:ed:f0:0d:a1:10'
#--TODO - update below for external dhcp
#uci set network.lan.ipaddr='192.168.1.45'
#uci set network.lan.gateway='192.168.1.1'
#uci set network.lan.dns='192.168.1.250'
#uci set network.lan.broadcast='192.168.1.255'

#----add wifi interface
uci set network.wifi=interface
uci set network.wifi.proto='static'
uci set network.wifi.ipaddr='11.11.11.1'
uci set network.wifi.macaddr='fe:ed:f0:0d:a1:11'
uci set network.wifi.netmask='255.255.255.0'

#----set the wifi enabled as default and configure wifi settings
uci set wireless.@wifi-device[0].disabled=0

uci set wireless.@wifi-iface[0].network='wifi'
uci set wireless.@wifi-iface[0].ssid=RECOIL_BS
uci set wireless.@wifi-iface[0].encryption=psk2
#--TODO update key using random key generator
uci set wireless.@wifi-iface[0].key="recoil123"

#----configure the dhcp settings for wifi
uci set dhcp.wifi=dhcp
uci set dhcp.wifi.interface='wifi'
uci set dhcp.wifi.start=2
uci set dhcp.wifi.limit=64
uci set dhcp.wifi.leasetime=12h

#----commit all uci changes
uci commit network
uci commit wireless
uci commit dhcp

#----reboot to update the changes to system
reboot

