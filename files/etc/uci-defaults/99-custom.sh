# 根据网卡数量配置网络
count=0
for iface in $(ls /sys/class/net | grep -v lo); do
  # 检查是否有对应的设备，并且排除无线网卡
  if [ -e /sys/class/net/$iface/device ] && [[ $iface == eth* || $iface == en* ]]; then
    count=$((count + 1))
  fi
done
if [ "$count" -eq 1 ]; then
    # 单个网卡，设置为 DHCP 模式
    uci set network.lan.proto='dhcp'
    uci commit network
elif [ "$count" -gt 1 ]; then
    # 多个网卡，保持静态 IP
    uci set network.lan.ipaddr='192.168.2.1'
    uci commit network
fi
