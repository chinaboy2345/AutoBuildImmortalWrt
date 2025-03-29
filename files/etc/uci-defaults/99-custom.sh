# 设置默认wan口防火墙打开 方便虚拟机用户首次访问webui
uci set firewall.@zone[1].input='ACCEPT'
uci commit firewall
# 设置主机名映射 解决安卓原生TV首次连不上网的问题
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"
uci commit dhcp
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
