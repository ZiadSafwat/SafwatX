
# 💻SafwatX✨

**SafwatX** is a network management tool designed for Linux users, inspired by popular tools like **TuxCut** and **EvilLimiter**. It provides an intuitive interface to scan, block, and unblock devices on your local network. Built with **Flutter** and **Python (Flask)**, it allows users to manage network devices with ease. The app features a paginated table with sortable fields, search functionality, and Excel export capabilities, all backed by efficient state management.

## Features

- **🖥 Network Scanning**: ️ Scan your local network to discover all connected devices.
- **🚫 Device Management**:  Block or unblock devices from accessing your network via ARP spoofing, ebtables, and iptables.
- **📊 Paginated Table**:  A responsive table that displays network devices, with features like:
  - Sorting for all columns (IP, MAC, Name, Block State)
  - Search functionality to quickly find devices.
- **📈 Excel Export**:  Export device data into an Excel sheet for further analysis.
- **🔄 State Management**:  Efficient state management using Flutter’s `Provider` package to ensure smooth UI updates.
## 📽️ Demo Preview  
![BriefPDF Demo](preview.gif)
## Installation

### Step 1: Set Up the Backend

Ensure that your system meets the requirements and all necessary Python packages are installed.

1. Clone this repository:

    ```bash
    git clone https://github.com/ZiadSafwat/SafwatX.git
    cd SafwatX/backend
    ```

2. Make file excutable:

    ```bash
     chmod +x setup_and_run.sh
    ```
3. Install the required linux packages and Python dependencies:

    ```bash
    ./setup_and_run.sh
    ```

    This will install the required packages and start the Flask server on **port 5000** this is the port configured for the frontend app. If running on a system that requires elevated permissions, the script will ask for sudo access.

### Step 2: Set Up the Flutter Frontend

1. Clone the repository and navigate to the `frontend` directory:

    ```bash
    cd SafwatX/app
    ```

 

2. Run the Flutter application:

    ```bash
    ./safwatX
    ```

### Step 3: Start the Flask Backend Server

The Flask server will be automatically started using the `setup_and_run.sh` script. The server will be accessible on `localhost:5000`.

## How It Works

1. **🔍 Scanning Devices**:  The app uses the `arp-scan` tool to discover devices on the local network, showing the IP address, MAC address, and hostname of each device.
2. **🚫 Blocking Devices**:  By selecting a device, you can block it from the network using ARP spoofing and iptables/ebtables rules.
3. **🔓 Unblocking Devices**:  Unblock devices by removing the rules that were applied to block them.
4. **📜 Paginated Table**:  A paginated table displays the list of devices on the network, with sorting and searching functionalities for an improved user experience.
5. **📉 Export to Excel**:  The device data can be exported to an Excel file for reporting purposes.

## Inspired By

This project is inspired by [**TuxCut**](https://github.com/droope/tuxcut) and [**EvilLimiter**](https://github.com/bitbrute/evillimiter), both of which are well-known tools for network management and device blocking.

## Requirements

- Python 3.x
- Flask
- `arp-scan`
- `ebtables`
- `iptables`
- `libnotify-dev`
 

## Troubleshooting

If you encounter issues with missing dependencies or permission errors, ensure that you have the necessary privileges to run network commands such as `sudo arp-scan`, `iptables`, and `ebtables`.

### Common Errors

- **Missing Dependencies**: If certain packages are missing (e.g., `arp-scan`, `ebtables`), use the setup script to install them. If you're using a custom Linux distribution, you may need to install these manually.
  
- **Permission Denied**: Some commands may require root access. Ensure that you run the app as a user with the appropriate permissions or use `sudo`.


## 📩 Contact  
📧 **Email:** [Ziadsafwataraby@gmail.com](mailto:Ziadsafwataraby@gmail.com)  
🔗 **Website:** [MyWebsite](https://waves.pockethost.io/user-profile/3b5wmxh6tierl5h)  
🔗 GitHub: @ZiadSafwat
## Disclaimer

🚨 **Warning**: This application is intended for legal use only. **I am not responsible for any misuse** or violation of local or international laws resulting from the use of this application. Users are required to comply with local laws and regulations when using this app. Please ensure your usage is in accordance with the law and ethical standards.

⚠️ Using this app for illegal or harmful activities may lead to legal consequences.
 
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
