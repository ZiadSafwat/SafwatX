from flask import Flask
from network import scan_network, block_device, unblock_device
import shutdown  # For graceful server shutdown

app = Flask(__name__)

# Register API endpoints
app.add_url_rule('/scan', 'scan_network', scan_network, methods=['GET'])
app.add_url_rule('/block', 'block_device', block_device, methods=['POST'])
app.add_url_rule('/unblock', 'unblock_device', unblock_device, methods=['POST'])

# Run Flask server
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

