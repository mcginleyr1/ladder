#!/bin/sh


modprobe xt_mark

echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
#echo 'net.ipv6.conf.all.disable_policy = 1' | tee -a /etc/sysctl.conf

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# emphemeral-node mode (auto-remove)
    #--socks5-server=localhost:1055

tailscaled --verbose=1 --port 41641 --tun=userspace-networking --state=mem: &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=suc &
/app/ladder -p 80
