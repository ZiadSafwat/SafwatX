#!/bin/bash

# ==============================
# Detect Distribution and Install Packages
# ==============================

# Detect the distribution and set package manager and package lists
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
fi

echo "Detected Distribution: $DISTRO $VERSION"

# Function to install packages on Debian-based distributions (Ubuntu, Debian, etc.)
install_debian_packages() {
    sudo apt update -y
    sudo apt install -y arp-scan ebtables iptables python3-pip python3-venv libnotify-dev
}

# Function to install packages on Arch-based distributions (Arch Linux, Manjaro, etc.)
install_arch_packages() {
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm arp-scan ebtables iptables python-pip python-virtualenv libnotify
}

# Function to install packages on Fedora/RHEL-based distributions (Fedora, CentOS, etc.)
install_fedora_packages() {
    sudo dnf install -y arp-scan ebtables iptables python3-pip python3-venv libnotify-devel
}

# Check the distribution and install the correct packages
case "$DISTRO" in
    debian|ubuntu|linuxmint)
        echo "Installing packages for Debian-based system..."
        install_debian_packages
        ;;
    arch|manjaro)
        echo "Installing packages for Arch-based system..."
        install_arch_packages
        ;;
    fedora|centos|rhel)
        echo "Installing packages for Fedora/RHEL-based system..."
        install_fedora_packages
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

# ==============================
# Install Python Dependencies
# ==============================

# Create and activate Python virtual environment
echo "Creating and activating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python packages from requirements.txt (ensure requirements.txt exists)
echo "Installing Python dependencies..."
pip install -r requirements.txt

# ==============================
# Check if Installation is Successful
# ==============================

# Check if arp-scan is installed
if ! command -v arp-scan &> /dev/null
then
    echo "Error: arp-scan is not installed. Exiting..."
    exit 1
fi

# Check if ebtables is installed
if ! command -v ebtables &> /dev/null
then
    echo "Error: ebtables is not installed. Exiting..."
    exit 1
fi

# Check if iptables is installed
if ! command -v iptables &> /dev/null
then
    echo "Error: iptables is not installed. Exiting..."
    exit 1
fi

# Check if libnotify-dev is installed
if ! dpkg-query -l libnotify-dev &> /dev/null
then
    echo "Error: libnotify-dev is not installed. Exiting..."
    exit 1
fi

# Check if Python dependencies are installed
if ! pip show Flask &> /dev/null || ! pip show netifaces &> /dev/null
then
    echo "Error: Python dependencies not installed. Exiting..."
    exit 1
fi

# ==============================
# Run Flask Server
# ==============================

# Run the Flask app as root on port 5000
echo "Running the Flask app on port 5000..."
sudo flask run --host=0.0.0.0 --port=5000

