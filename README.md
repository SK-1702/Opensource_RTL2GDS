# Opensource_RTL2GDS
# Silicon Craft VLSI Opensource EDA Tools installation setup


## Introduction  
Openlane RTL2GDS is an **open-source, fully automated RTL-to-GDSII flow**, built using industry-standard EDA tools. This flow supports Linux, Windows (via WSL), and macOS, making it accessible for VLSI engineers, researchers, and students.

## 📌 **Features**
✔ End-to-end **RTL-to-GDSII** flow  
✔ **Fully open-source** toolchain  
✔ **Multi-OS Support:** Ubuntu, WSL, and macOS  
✔ Integrated **synthesis, floorplanning, placement, routing, and verification**  
✔ Minimal dependencies, simple installation  

## 🔧 **Tools Used in the Flow**
| Stage              | Tool                 |
|-------------------|----------------------|
| **Synthesis**     | Yosys                 |
| **Floorplanning** | OpenROAD              |
| **Placement**     | OpenROAD              |
| **Routing**       | OpenROAD              |
| **DRC/LVS Check** | Magic, Netgen         |
| **Timing Analysis** | OpenSTA, OpenTimer   |
| **SPICE Simulations** | Ngspice             |
| **Logic Simulation** | Icarus Verilog       |

---

## 🛠 **Installation Steps**
Follow these steps to install all required tools and set up the RTL-to-GDS flow.

### 1️⃣ **Clone the Repository**
```sh
git clone https://github.com/YOUR_USERNAME/Silicon_Craft_RTL2GDS.git
cd Silicon_Craft_RTL2GDS
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

## Folder Structure
Silicon_Craft_RTL2GDS/
- │── designs/            # User RTL Designs
- │── scripts/            # Automation scripts
- │── pdks/               # Process Design Kits
- │── tools/              # Installed EDA Tools
- │── results/            # Output GDSII files
- │── docs/               # Documentation
- │── install_eda_tools.sh  # Installation script
- │── run_flow.sh         # RTL-to-GDS automation
- │── README.md           # Project documentation

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

