### 1) Create VM

<p>Create a new virtual machine, selecting Linux and Ubuntu64 as the Type and Version. Select sufficient memory (i.e. in green zone just before the redzone). For the hard disk, select the 'Create a virtial hard disk now' option. Choose VDI and dynamically allocated. Choose 1TB as the size.</p>

### 2) Configure the VM

### 3) Run an update

    sudo apt-get update
    sudo apt-get upgrade
    reboot

### 4) Install the following software

    sudo apt-get install gcc make git

### 5) Install guest additions
<p>Insert and run the guest additions. Set the Shared Clipboard and Drag and Drop to be bidirectional. Restart the machine.Don't forget to eject the Gues Addions disk.</p>

### 6) Clone the repo for installing the software

    git clone https://github.com/WTAC-NGS/ngs-vm.git
    cd ngs-vm

### 7) Install miniconda

    ./install_miniconda.sh
    
### 8) Install the software

    ./install_software.sh
    
### 9) Run the tests

    cd tests
    ./test_unix.sh
    
### 10) To enable shared folders

    sudo usermod -a -G vboxsf manager
  
### 11) Add terminal and screenshot to the menu


    

