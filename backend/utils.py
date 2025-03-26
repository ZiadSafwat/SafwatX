import subprocess
import netifaces

def get_my_ip_and_mac():
    interface = "wlp3s0"  # Change to your actual network interface
    try:
        mac_address = netifaces.ifaddresses(interface)[netifaces.AF_LINK][0]['addr']
        ip_address = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['addr']
        return ip_address, mac_address
    except Exception as e:
        print(f"⚠️ Could not get self info: {e}")
        return None, None

def get_hostname(ip):
    try:
        result = subprocess.run(["dig", "+short", "-x", ip], capture_output=True, text=True)
        hostname = result.stdout.strip()
        return hostname if hostname else "Unknown"
    except Exception:
        return "Unknown"

def get_mac_address(ip):
    try:
        result = subprocess.run(["sudo", "arp-scan", "--localnet"], capture_output=True, text=True)
        for line in result.stdout.split("\n"):
            parts = line.split("\t")
            if len(parts) >= 2 and parts[0] == ip:
                return parts[1]
    except Exception as e:
        print(f"❌ Error getting MAC for {ip}: {e}")
    return None

def is_device_blocked(ip, mac):
    iptables_output = subprocess.run(["sudo", "iptables", "-L", "-v", "-n"], capture_output=True, text=True).stdout
    ebtables_output = subprocess.run(["sudo", "ebtables", "-L"], capture_output=True, text=True).stdout
    return ip in iptables_output or (mac and mac in ebtables_output)

