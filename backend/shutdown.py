import signal
import subprocess
import sys

def shutdown_server(signal, frame):
    print("\n🛑 Stopping ARP spoofing processes...")
    subprocess.run(["sudo", "pkill", "-f", "arpspoof"], stderr=subprocess.DEVNULL)
    print("✅ Cleanup complete. Exiting...")
    sys.exit(0)

# Capture CTRL+C (SIGINT)
signal.signal(signal.SIGINT, shutdown_server)

