#!/bin/bash

read -p "Enter domain: " domain

ipv4s=$(dig +short "$domain" A)
ipv6s=$(dig +short "$domain" AAAA)

if [ -z "$ipv4s" ] && [ -z "$ipv6s" ]; then
    echo "Could not resolve any IP for $domain"
    exit 1
fi

echo "======================================="
echo " Rules that will be applied:"
echo "======================================="

# Preview IPv4 rules
for ip in $ipv4s; do
    echo "iptables -A OUTPUT -d $ip -j DROP"
    echo "iptables -A INPUT -s $ip -j DROP"
done

# Preview IPv6 rules
for ip in $ipv6s; do
    echo "ip6tables -A OUTPUT -d $ip -j DROP"
    echo "ip6tables -A INPUT -s $ip -j DROP"
done

echo "======================================="
read -p "Do you want to apply these rules? (y/n): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Apply IPv4 rules
for ip in $ipv4s; do
    sudo iptables -C OUTPUT -d "$ip" -j DROP 2>/dev/null || sudo iptables -A OUTPUT -d "$ip" -j DROP
    sudo iptables -C INPUT -s "$ip" -j DROP 2>/dev/null || sudo iptables -A INPUT -s "$ip" -j DROP
    echo "Blocked IPv4 $ip"
done

# Apply IPv6 rules
for ip in $ipv6s; do
    sudo ip6tables -C OUTPUT -d "$ip" -j DROP 2>/dev/null || sudo ip6tables -A OUTPUT -d "$ip" -j DROP
    sudo ip6tables -C INPUT -s "$ip" -j DROP 2>/dev/null || sudo ip6tables -A INPUT -s "$ip" -j DROP
    echo "Blocked IPv6 $ip"
done
