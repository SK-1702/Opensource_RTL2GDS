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
                        x11-apps xauth libgtest-dev

    # Configure GUI for WSL
    if [[ "$OS_TYPE" == "WSL" ]]; then
        echo "Setting up X11 forwarding for GUI applications in WSL..."
        echo "export DISPLAY=:0" >> ~/.bashrc
        source ~/.bashrc
        sudo apt install -y x11-apps xauth
    fi
elif [[ "$OS_TYPE" == "MacOS" ]]; then
    echo "Installing dependencies using Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install cmake python3 git boost tcl-tk swig fftw xquartz
    echo "Ensure XQuartz is installed and running for GUI applications."
fi

# -------------------------------------------------------------
# Install Google Test (GTest) - Required for OpenROAD Build
# -------------------------------------------------------------
echo "Installing Google Test (GTest)..."

if [[ ! -f /usr/lib/libgtest.a ]]; then
    echo "GTest not found. Building and installing..."
    cd /usr/src/gtest
    sudo cmake CMakeLists.txt
    sudo make -j$(nproc)
    sudo cp lib/*.a /usr/lib
else
    echo "GTest is already installed."
fi

# -------------------------------------------------------------
# Function to install tools with checks
# -------------------------------------------------------------
git_clone_build_install() {
    REPO=$1
    DIR_NAME=$(basename "$REPO" .git)

    # Check if directory already exists
    if [[ -d "$DIR_NAME" ]]; then
        echo "$DIR_NAME already exists. Checking installation..."
        if command -v "$DIR_NAME" &> /dev/null; then
            echo "$DIR_NAME is already installed. Skipping..."
            return
        else
            echo "$DIR_NAME directory exists but installation not found. Removing and reinstalling..."
            sudo rm -rf "$DIR_NAME"
        fi
    fi

    echo "Installing $DIR_NAME..."
    git clone "$REPO"
    cd "$DIR_NAME"

    # Initialize submodules if present
    if [[ -f ".gitmodules" ]]; then
        git submodule update --init --recursive
    fi

    # Check if CMakeLists.txt or Makefile exists
    if [[ -f "CMakeLists.txt" ]]; then
        mkdir -p build && cd build
        cmake ..
        make -j$(nproc)
        sudo make install
        cd ../..
    elif [[ -f "Makefile" || -f "configure" ]]; then
        if [[ -f "configure" ]]; then
            ./configure
        fi
        make -j$(nproc)
        sudo make install
        cd ..
    else
        echo "Error: No CMakeLists.txt or Makefile found in $DIR_NAME. Skipping..."
        cd ..
    fi
}

# -------------------------------------------------------------
# Install Open-Source EDA Tools
# -------------------------------------------------------------
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

# -------------------------------------------------------------
# Install KLayout (Special case for Linux and MacOS)
# -------------------------------------------------------------
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

# -------------------------------------------------------------
# Ensure user is in the sudoers file
# -------------------------------------------------------------
if [[ "$OS_TYPE" != "MacOS" ]]; then
    echo "Ensuring user is in the sudoers file..."
    sudo usermod -aG sudo $USER
fi

# -------------------------------------------------------------
# Verify installations
# -------------------------------------------------------------
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

# -------------------------------------------------------------
# Launch GUI for KLayout and Magic
# -------------------------------------------------------------
if [[ "$OS_TYPE" == "Linux" || "$OS_TYPE" == "WSL" || "$OS_TYPE" == "MacOS" ]]; then
    echo "Launching KLayout and Magic for GUI verification..."
    klayout &
    magic -d XR &
fi

echo "All tools installed successfully on $OS_TYPE!"

