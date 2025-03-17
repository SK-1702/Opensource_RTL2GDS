# Opensource_RTL2GDS
# Silicon Craft VLSI EDA Tools

## Overview
This repository provides an automated installation script for open-source EDA tools required for VLSI design and verification. The tools are set up to run on:
- **Linux (Ubuntu)**
- **WSL (Ubuntu on Windows)**
- **MacOS**

## Features
- Automatically detects the OS and installs the required dependencies.
- Installs open-source EDA tools including Yosys, OpenROAD, Magic, Netgen, Ngspice, OpenTimer, OpenSTA, Icarus Verilog, SPEF Extractor, CVC, OR-Tools, and CUDD.
- Configures environment settings for seamless usage.

## Installation
### **Step 1: Clone the Repository**
```
 git clone https://github.com/your_username/Silicon_Craft_VLSI_EDA.git
 cd Silicon_Craft_VLSI_EDA
```

### **Step 2: Grant Execution Permission**
```
 chmod +x install_eda_tools.sh
```

### **Step 3: Run the Installation Script**
#### **For Linux and WSL**
```
 ./install_eda_tools.sh
```
#### **For MacOS**
```
 ./install_eda_tools.sh
```

## Tools Installed
- **Yosys** - Open-source synthesis tool
- **OpenROAD** - Digital design flow
- **Magic** - Layout editor
- **Netgen** - LVS tool
- **Ngspice** - Circuit simulator
- **OpenTimer** - Static timing analysis
- **OpenSTA** - Another STA tool
- **Icarus Verilog** - Verilog simulation
- **SPEF Extractor** - Parasitic extraction
- **CVC** - Verilog compiler
- **OR-Tools** - Optimization library
- **CUDD** - Binary decision diagrams (BDD) library

## Verification
After installation, verify the tools by running:
```
 yosys -V
 openroad -version
 magic --version
 netgen -batch 'exit'
 ngspice -v
 opentimer --version
 opensta -version
 iverilog -V
```

## Contributing
Feel free to submit pull requests for additional tools and optimizations.

## License
This project is open-source and available under the MIT License.

