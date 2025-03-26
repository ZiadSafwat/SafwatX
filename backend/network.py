from flask import request, jsonify
import subprocess
from utils import get_my_ip_and_mac, get_hostname, get_mac_address, is_device_blocked

def scan_network():
    try:
        result = subprocess.run(["sudo", "arp-scan", "--localnet"], capture_output=True, text=True)
        devices = []

        my_ip, my_mac = get_my_ip_and_mac()
        my_hostname = get_hostname(my_ip) if my_ip else "Unknown"

        for line in result.stdout.split("\n"):
            parts = line.split("\t")
            if len(parts) >= 2:
                ip, mac = parts[0], parts[1]
                hostname = get_hostname(ip)
                blocked = is_device_blocked(ip, mac)

                if ip == my_ip:
                    continue

                devices.append({"ip": ip, "mac": mac, "name": hostname, "blocked": blocked})

        if my_ip and my_mac:
            devices.append({
                "ip": my_ip,
                "mac": my_mac,
                "name": my_hostname,
                "blocked": False
            })

        return jsonify({"devices": devices})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

def block_device():
    ip = request.json.get("ip")
    if not ip:
        return jsonify({"error": "IP address is required"}), 400

    my_ip, my_mac = get_my_ip_and_mac()
    if ip == my_ip:
        return jsonify({"error": "Cannot block yourself!"}), 403

    mac_address = get_mac_address(ip)
    if not mac_address:
        return jsonify({"error": "MAC address not found"}), 500

    if mac_address == my_mac:
        return jsonify({"error": "Cannot block yourself!"}), 403

    try:
        subprocess.run(["sudo", "pkill", "-f", f"arpspoof -i wlp3s0 -t {ip}"], stderr=subprocess.DEVNULL)
        subprocess.Popen(["sudo", "arpspoof", "-i", "wlp3s0", "-t", ip, "192.168.1.1"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["sudo", "ebtables", "-A", "FORWARD", "-s", mac_address, "-j", "DROP"])
        subprocess.run(["sudo", "iptables", "-A", "FORWARD", "-s", ip, "-j", "DROP"])
        return jsonify({"status": "blocked", "ip": ip, "mac": mac_address})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

def unblock_device():
    ip = request.json.get("ip")
    if not ip:
        return jsonify({"error": "IP address is required"}), 400

    mac_address = get_mac_address(ip)
    if not mac_address:
        return jsonify({"error": "MAC address not found"}), 500

    try:
        subprocess.run(["sudo", "pkill", "-f", f"arpspoof -i wlp3s0 -t {ip}"], stderr=subprocess.DEVNULL)
        subprocess.run(["sudo", "ebtables", "-D", "FORWARD", "-s", mac_address, "-j", "DROP"])
        subprocess.run(["sudo", "iptables", "-D", "FORWARD", "-s", ip, "-j", "DROP"])
        subprocess.run(["sudo", "arping", "-c", "3", "-I", "wlp3s0", ip], stderr=subprocess.DEVNULL)
        return jsonify({"status": "unblocked", "ip": ip, "mac": mac_address})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

