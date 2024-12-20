#!/bin/bash

# Function to check if the environment is WSL
is_wsl() {
    if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
        echo "WSL"
        return 0
    else
        return 1
    fi
}

# Function to check if the environment is a virtual machine
is_virtual_machine() {
    # Check for virtualization using systemd-detect-virt
    if command -v systemd-detect-virt &> /dev/null; then
        virt_type=$(systemd-detect-virt)
        if [[ "$virt_type" != "none" ]]; then
            echo "Virtual Machine ($virt_type)"
            return 0
        fi
    fi

    # Fallback: Look for virtualization hints in DMI or other system files
    if grep -qE "(VMware|VirtualBox|QEMU|KVM|Xen)" /sys/class/dmi/id/product_name 2>/dev/null ||
       grep -qE "(VMware|VirtualBox|QEMU|KVM|Xen)" /proc/cpuinfo; then
        echo "Virtual Machine"
        return 0
    fi

    return 1
}

# Function to check if the environment is physical hardware
is_physical_hardware() {
    if ! is_wsl && ! is_virtual_machine; then
        echo "Physical Hardware"
        return 0
    fi
    return 1
}

# Main script logic
if is_wsl; then
    echo "The script is running in WSL."
elif is_virtual_machine; then
    echo "The script is running in a Virtual Machine."
elif is_physical_hardware; then
    echo "The script is running on Physical Hardware."
else
    echo "Unable to determine the environment."
fi
