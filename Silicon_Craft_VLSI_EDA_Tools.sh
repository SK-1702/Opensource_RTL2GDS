#!/bin/bash

# Silicon Craft VLSI EDA Tool Installation Script
# Supports Ubuntu/Linux, WSL (Ubuntu inside Windows), and MacOS
# Installs essential open-source tools for VLSI design and verification

set -e  # Exit on error

# Detect OS Type
OS_TYPE="$(uname -s)"

if [[ "$OS_TYPE" == "Linux" ]]; then
    if grep -q Microsoft /proc/version; then
        echo "Detected WSL (Windows Subsystem for Linux)"
        OS_TYPE="WSL"
    else
        echo "Detected Native Linux"
        OS_TYPE="Linux"
    fi
elif [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "Detected MacOS"
    OS_TYPE="MacOS"
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi

# Install dependencies based on OS
if [[ "$OS_TYPE" == "Linux" || "$OS_TYPE" == "WSL" ]]; then
    echo "Updating system and installing dependencies..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential python3 python3-pip cmake git \
                        tcl-dev tk-dev libx11-dev libxaw7-dev flex bison \
                        libxpm-dev libreadline-dev libffi-dev \
                        clang vim libgsl-dev libboost-dev libboost-program-options-dev \
                        swig libfftw3-dev python3-gi-cairo python3-scipy python3-matplotlib \
                        python3-pyqt5 python3-pyqt5.qtsvg python3-pyqt5.qtwebkit \
                        python3-pyqt5.qtserialport python3-lxml python3-yaml \
                        x11-apps xauth
    if [[ "$OS_TYPE" == "WSL" ]]; then
        echo "Setting up X11 forwarding for GUI applications in WSL..."
        echo "export DISPLAY=:0" >> ~/.bashrc
        source ~/.bashrc
    fi
elif [[ "$OS_TYPE" == "MacOS" ]]; then
    echo "Installing dependencies using Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install cmake python3 git boost tcl-tk swig fftw xquartz
    echo "Ensure XQuartz is installed and running for GUI applications."
fi

# Function to install tools
git_clone_build_install() {
    REPO=$1
    DIR_NAME=$(basename "$REPO" .git)
    echo "Installing $DIR_NAME..."
    git clone "$REPO"
    cd "$DIR_NAME"
    mkdir -p build && cd build
    cmake ..
    make -j$(sysctl -n hw.ncpu 2>/dev/null || nproc)
    sudo make install
    cd ../..
}

# Install Open-Source EDA Tools
git_clone_build_install "https://github.com/YosysHQ/yosys.git"
git_clone_build_install "https://github.com/The-OpenROAD-Project/OpenROAD.git"
git_clone_build_install "https://github.com/RTimothyEdwards/magic.git"
git_clone_build_install "https://github.com/RTimothyEdwards/netgen.git"
git_clone_build_install "https://git.code.sf.net/p/ngspice/ngspice.git"
git_clone_build_install "https://github.com/OpenTimer/OpenTimer.git"
git_clone_build_install "https://github.com/The-OpenROAD-Project/OpenSTA.git"
git_clone_build_install "https://github.com/steveicarus/iverilog.git"
git_clone_build_install "https://github.com/YosysHQ/SPEF-Extractor.git"
git_clone_build_install "https://github.com/d-m-bailey/cvc.git"
git_clone_build_install "https://github.com/google/or-tools.git"
git_clone_build_install "https://github.com/ivmai/cudd.git"

# Install KLayout (Special case for Linux and MacOS)
if [[ "$OS_TYPE" == "Linux" || "$OS_TYPE" == "WSL" ]]; then
    echo "Installing KLayout..."
    wget https://www.klayout.org/downloads/Ubuntu-22/klayout_0.28.7-1_amd64.deb
    sudo dpkg -i klayout_0.28.7-1_amd64.deb
    sudo apt install -f -y
    rm klayout_0.28.7-1_amd64.deb
elif [[ "$OS_TYPE" == "MacOS" ]]; then
    echo "Installing KLayout on MacOS..."
    brew install klayout
fi

# Ensure user is in the sudoers file
if [[ "$OS_TYPE" != "MacOS" ]]; then
    echo "Ensuring user is in the sudoers file..."
    sudo usermod -aG sudo $USER
fi

# Verify installations
echo "Verifying installations..."
yosys -V
openroad -version
magic --version
netgen -batch 'exit'
ngspice -v
klayout -v
opentimer --version
opensta -version
iverilog -V

echo "All tools installed successfully on $OS_TYPE!"

