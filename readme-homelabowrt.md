deactivate ipv6

```sh
uci set 'network.lan.ipv6=0'
uci set 'network.wan.ipv6=0'
uci set 'dhcp.lan.dhcpv6=disabled'
uci del network.lan.ip6assign

uci commit
uci -q delete dhcp.lan.dhcpv6
uci -q delete dhcp.lan.ra

uci commit dhcp
uci commit

/etc/init.d/odhcpd disable
/etc/init.d/odhcpd stop


uci set network.lan.delegate="0"
uci commit network

/etc/init.d/network restart

```


wireguard client

```sh

opkg update
opkg install wireguard-tools
opkg install luci-app-wireguard
VPN_IF="vpn"
VPN_SERV="SERVER_ADDRESS"

```