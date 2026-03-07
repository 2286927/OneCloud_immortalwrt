#!/bin/bash

# 此脚本用于配置客户端模式，从上级路由获取IP
# 参数1: 可留空或不使用
# 参数2: 可留空或不使用

# 如果files/etc/config文件夹不存在，创建文件夹
if [ ! -d "./files/etc/config" ]; then
  mkdir -p ./files/etc/config
fi

# 生成客户端模式网络配置
# 注意：这里将物理网口 eth0 配置为 WAN 口，通过 DHCP 客户端获取IP
# LAN 口（如果需要）可以通过虚拟接口或另一个物理接口创建，此处示例不创建独立的LAN口
cat <<'EOF' > ./files/etc/config/network
config interface 'loopback'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'
	option device 'lo'

config globals 'globals'
	option packet_steering '1'

config interface 'wan'
	option proto 'dhcp'
	option device '@Internet'
	option peerdns '0'
	list dns '202.103.224.68'
	list dns '202.103.225.68'

config device
	option name 'br-lan'
	option type 'bridge'

config interface 'Internet'
	option proto 'none'
	option device 'eth0'

config interface 'wan6'
	option proto 'dhcpv6'
	option device '@wan'
	option reqaddress 'try'
	option reqprefix 'auto'
	option norelease '1'
	option peerdns '0'
	list dns '240e:9:0:100:202:103:224:68'
	list dns '240e:9:2000:100:202:103:225:68'

config interface 'Bypass'
	option proto 'static'
	option device '@Internet'
	option ipaddr '192.168.1.2'
	option netmask '255.255.255.0'
	list ip6addr 'fe80::2'
	option ip6gw 'fe80::1'

config device
	option name 'eth0'
	option macaddr '36:98:69:DC:D0:BE'
EOF


