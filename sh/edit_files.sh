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

config interface 'wan'
	option proto 'dhcp'
	option device 'eth0'
	option peerdns '0'
	list dns '114.114.114.114'
	list dns '8.8.8.8'

# 可选：创建一个桥接的LAN口，但关闭其DHCP服务器功能，仅用于设备管理
# 如果不需要管理接口，可删除此段
config interface 'lan'
	option proto 'static'
	option ipaddr '172.16.8.1'
	option netmask '255.255.255.0'
	option device 'br-lan'
	option type 'bridge'
	list ports 'eth1'  # 如果有第二个网口
	option ip4table 'wan'  # 关键：将LAN的流量路由到WAN表

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'eth1'  # 如果有第二个网口
EOF
