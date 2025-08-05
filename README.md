# Domain Blocker with iptables

This Bash script blocks all IPv4 and IPv6 addresses associated with a given domain using `iptables` and `ip6tables`.  
It first resolves the domain to its current IP addresses, previews the rules that will be applied, and then optionally applies them.

---

## 📌 Features
- Resolves both IPv4 (A records) and IPv6 (AAAA records) for a given domain.
- Displays the `iptables` rules before applying them.
- Confirms with the user before making any changes.
- Avoids adding duplicate firewall rules.
- Works for both incoming and outgoing traffic.

---

## 🚀 Usage
1. Make the script executable:
   ```bash
   chmod +x domain_to_ip_converted_to_block.sh
   ```
2. Run the script:
   ```bash
   domain_to_ip_converted_to_block.sh
   ```
3. Enter the domain name when prompted.
4. Review the rules and confirm to apply them.

## ⚠️ Challenges & Limitations
- Blocking domains with iptables has some important caveats:
  - IP address volatility: Domains often change IPs (especially CDN-backed services). Rules may become outdated quickly.
  - Shared hosting: A single IP can host many domains. Blocking one IP may block multiple unrelated sites.
  - DNS resolution timing: iptables resolves the domain only once when the rule is created.
  - IPv6 traffic: You must block both IPv4 and IPv6 to be effective.
  - Maintenance overhead: IP changes require updating the rules frequently.
- Because of these challenges, iptables-based blocking is not the most reliable way to block domains.
