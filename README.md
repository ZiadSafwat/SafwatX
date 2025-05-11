# [SafwatX](https://ziadsafwat.github.io/SafwatX/) - Network Management App 

SafwatX is a robust, cross-platform Flutter application designed for network management and monitoring. It enables users to scan network devices, monitor bandwidth, block/unblock devices using ARP spoofing, and export data for analysis.

## Features

- **Network Device Scanning**: Discover devices with details like IP, MAC, hostname, vendor and blocking status.
- **Bandwidth Monitoring**: Track download and upload speeds.
- **Device Blocking/Unblocking**: Restrict network access for specific devices.
- **Speed Testing**: Measure network performance with integrated speed tests (windows upload speed test not implemented ).
- **Data Export**: Export device lists to Excel for reporting.

- **Cross-Platform Support**: Windows and Linux.

## Screenshots

<!-- Add screenshots of your app -->
![Dashboard](./website/s1.png)  


## Installation

### Prerequisites

- **Flutter**: [Install Flutter](https://flutter.dev/docs/get-started/install).
- **Git**: To clone the repository.
- **Platform-Specific Requirements**:
  - **Windows**:
    - WinPcap/Npcap for packet capture. [Download winpcap](https://www.winpcap.org/install/).
    - Admin privileges for ARP spoofing (in developing run editor with Admin privileges ).
    - [.exe file](https://github.com/ZiadSafwat/SafwatX/releases/download/v1.0.0/win.v.1.0.0.zip)
  - **Linux**:
    - CLI tools: `arp-scan`, `arpspoof`, `ebtables`, `iptables`, `speedtest-cli`, `dig`, `arping`.
    - `libpcap` for packet capture.
    - Root privileges for network operations (the linux file in project root already ask for password when run in debug and release).
    -  [.deb file](https://github.com/ZiadSafwat/SafwatX/releases/download/v1.0.0/safwatx-1.0.0+1-linux.deb)
- **Dependencies**: Listed in `pubspec.yaml` (e.g., `provider`, `excel`, `path_provider`).

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/safwatx.git
   cd safwatx
   ```

2. **Install Flutter Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up Platform-Specific Tools**:
   - **Windows**:
     - Install winpcap if not already present.
   - **Linux**:
     - Install required tools:
       ```bash
       sudo apt update
       sudo apt install arp-scan dsniff ebtables iptables dnsutils python3-speedtest-cli libpcap-dev
       ```
     - Ensure `arpspoof` and `arping` (from `dsniff`) are accessible in the system PATH.
     - No asset setup is needed, as Linux uses system-installed tools.

4. **Run the App**:
   - **Windows** (run editor with admin privileges):
     ```bash
     flutter run
     ```
   - **Linux** (the app will ask for root privileges):
     - if you want to package app to debian run this :
      ```bash
        flutter_distributor release --name=SafwatX --jobs=release-SafwatX-linux-deb 
        ```
     - i have modified the linux\runner\main.cc file to ask for root in debug and release app version:
     ```bash
        //old code 
        //#include "my_application.h"
        //
        //int main(int argc, char** argv) {
        //  g_autoptr(MyApplication) app = my_application_new();
        //  return g_application_run(G_APPLICATION(app), argc, argv);
        //}
        // new code
        #include "my_application.h"
        #include <unistd.h>
        #include <stdlib.h>
        #include <sstream>
        #include <iostream>

        int main(int argc, char** argv) {
          if (getuid() != 0) {
            std::cerr << "Not running as root. Attempting to relaunch with pkexec...\n";

            // Rebuild command with GUI env variables
            std::stringstream command;
            command << "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \"" << argv[0] << "\"";
            for (int i = 1; i < argc; ++i) {
              command << " \"" << argv[i] << "\"";
            }

            return system(command.str().c_str());
          }

          g_autoptr(MyApplication) app = my_application_new();
          return g_application_run(G_APPLICATION(app), argc, argv);
        }


     ```
    

## Usage

1. **Launch the App**:
   - On Windows, `WinArpSpoof.exe` starts automatically to enable network operations.
   - On Linux, the app uses system CLI tools (`arp-scan`, `arpspoof`, etc.).
   - The dashboard displays connected devices, bandwidth metrics, and control options.

2. **Scan Network**:
   - Click "Scan Network" to list devices with IP, MAC, hostname, and blocking status.
   - Your device is marked as "(your Device)" in the list.

3. **Monitor Bandwidth**:
   - View real-time download and upload speeds per sec, updated every 3 seconds.
   - Windows uses `wmic`; Linux uses `/proc/net/dev`.

4. **Block/Unblock Devices**:
   - Select a device and toggle block/unblock.
   - Windows uses `WinArpSpoof.exe block/unblock`.
   - Linux uses `arpspoof`, `ebtables`, and `iptables`.

5. **Run Speed Test**:
   - Initiate a speed test to measure download and upload speeds (Mbps).
   - Linux uses `speedtest-cli`; Windows uses `WinArpSpoof.exe speedtest` (windows upload speed test not implemented ).

6. **Export Data**:
   - Export the device list to `table_data.xlsx` for analysis.

## Platform Implementations

### Windows

- **CLI Tool**: `WinArpSpoof.exe` ([GitHub](https://github.com/ZiadSafwat/WinArpSpoof)).
- **Key Operations**:
  - **Scanning**: `WinArpSpoof.exe scan` to list devices (IP, MAC, hostname, vendor).
  - **Blocking**: `WinArpSpoof.exe block <IP>` with `start` for ARP spoofing.
  - **Unblocking**: `WinArpSpoof.exe unblock <IP>`.
  - **Bandwidth**: Uses `wmic` to query `Win32_PerfFormattedData_Tcpip_NetworkInterface` for `BytesReceivedPersec` and `BytesSentPersec`.
  - **Speed Test**: `WinArpSpoof.exe speedtest` for network performance (windows upload speed test not implemented ).
- **Dependencies**:
  - Winpcap for packet capture.
  - Admin privileges.
- **Setup**:
  - Place `WinArpSpoof.exe` in `assets/`.
  - Run with admin privileges:
    ```cmd
    flutter run
    ```
- **Notes**:
  - The app automatically starts `WinArpSpoof.exe` on launch.
  - Cleanup ensures `WinArpSpoof.exe` stops on app exit.

### Linux

- **CLI Tools**:
  - `arp-scan`: Network scanning.
  - `arpspoof`: ARP spoofing for blocking.
  - `ebtables`/`iptables`: MAC and IP-based firewall rules.
  - `speedtest-cli`: Speed testing.
  - `dig`: Hostname resolution.
  - `arping`: ARP table restoration.
  - `ip`: Interface and IP management.
- **Key Operations**:
  - **Scanning**: `arp-scan --interface=<iface> --localnet` to list devices.
  - **Blocking**: `arpspoof -i <iface> -t <IP> <gateway>` with `ebtables` and `iptables` to drop packets.
  - **Unblocking**: Stops `arpspoof` and removes `ebtables`/`iptables` rules, then uses `arping` to restore ARP tables.
  - **Bandwidth**: Reads `/proc/net/dev` for bytes received and sent, with a 1-second delta.
  - **Speed Test**: `speedtest-cli --json` for download/upload speeds in Mbps.
- **Dependencies**:
  - `libpcap`, `arp-scan`, `dsniff`, `ebtables`, `iptables`, `dnsutils`, `speedtest-cli`.
  - Root privileges.
- **Setup**:
  - Install dependencies:
    ```bash
    sudo apt update
    sudo apt install arp-scan dsniff ebtables iptables dnsutils python3-speedtest-cli libpcap-dev
    ```
  - Run with root privileges (the app is configured to ask for root privileges)
 
- **Notes**:
  - No asset files are needed; all tools are system-installed.
  - Cleanup stops `arpspoof` and unblocks all devices on app exit.

## Project Structure

```
safwatx/
├── assets/
│   └── WinArpSpoof.exe          # Windows CLI tool
├── lib/
│   ├── models/
│   │   └── device_model.dart    # Device data model
│   ├── providers/
│   │   └── network_provider.dart # State management
│   ├── screens/
│   │   └── Dashboard/           # UI components
│   └── services/
│       ├── services.dart        # NetworkManager interface
│       ├── linux_network_manager.dart # Linux implementation
│       └── windows_network_manager.dart # Windows implementation
└── pubspec.yaml                 # Dependencies and assets
 ```



## Troubleshooting

### Windows
- **WinArpSpoof.exe Fails to Start**:
  - Verify it’s in `assets/` and listed in `pubspec.yaml`.
  - Run with admin privileges.
  - Ensure winpcap is installed.
  - Test manually:
    ```cmd
    WinArpSpoof.exe start
    ```
- **Bandwidth Shows 0.0**:
  - Generate network traffic (e.g., stream a video).
  - Check `wmic` output:
    ```cmd
    wmic path Win32_PerfFormattedData_Tcpip_NetworkInterface get BytesReceivedPersec,BytesSentPersec
    ```

### Linux
- **Scanning Fails**:
  - Ensure `arp-scan` is installed and accessible (`sudo arp-scan --localnet`).
  - Run with root privileges.
- **Blocking Fails**:
  - Verify `arpspoof`, `ebtables`, and `iptables` are installed.
  - Check for conflicting firewall rules:
    ```bash
    sudo iptables -L -v -n
    sudo ebtables -L
    ```
- **Bandwidth Shows 0.0**:
  - Confirm the correct interface (e.g., `eth0`):
    ```bash
    cat /proc/net/dev
    ```
  - Generate traffic (e.g., download a file).

 ## ⚠️ Ethical and Legal Reminder

ARP spoofing is a Man-in-the-Middle attack and is considered illegal or unauthorized on networks you don't own or manage. Always use this code only in educational labs or networks where you have explicit permission.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contact

- **Maintainer**: Ziad Safwat Elaraby (ziadsafwataraby@gmail.com)
- **Repository**: [github.com/ZiadSafwat/SafwatX](https://github.com/ZiadSafwat/SafwatX)
- **Windows CLI Tool**: [Website](https://ziadsafwat.github.io/WinArpSpoof/website/)

---

Built with 💙 using Flutter and open-source tools.
