import os
import subprocess
import netifaces
import random

# Get the default network interface
def get_network_interface():
    gateways = netifaces.gateways()
    return gateways["default"][netifaces.AF_INET][1]

# Get the default gateway (router IP)
def get_gateway():
    return subprocess.getoutput("ip route | grep default | awk '{print $3}'")

# Get your own IP and MAC address
def get_my_info():
    iface = get_network_interface()
    ip = netifaces.ifaddresses(iface)[netifaces.AF_INET][0]['addr']
    mac = netifaces.ifaddresses(iface)[netifaces.AF_LINK][0]['addr']
    return {"interface": iface, "ip": ip, "mac": mac}

# Enable/disable IP forwarding
def set_ip_forwarding(enable=True):
    value = "1" if enable else "0"
    os.system(f"echo {value} | sudo tee /proc/sys/net/ipv4/ip_forward")

# Generate a random MAC address
def generate_random_mac():
    return "02:00:%02x:%02x:%02x:%02x" % (
        random.randint(0, 255),
        random.randint(0, 255),
        random.randint(0, 255),
        random.randint(0, 255),
    )

