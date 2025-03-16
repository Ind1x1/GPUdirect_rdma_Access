#!/bin/bash
#
# Copyright (c) 2019 Mellanox Technologies. All rights reserved.
#
# This Software is licensed under one of the following licenses:
#
# 1) under the terms of the "Common Public License 1.0" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/cpl.php.
#
# 2) under the terms of the "The BSD License" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/bsd-license.php.
#
# 3) under the terms of the "GNU General Public License (GPL) Version 2" a
#    copy of which is available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/gpl-license.php.
#
# Licensee has the right to choose one of the above licenses.
#
# Redistributions of source code must retain the above copyright
# notice and one of the license notices.
#
# Redistributions in binary form must reproduce both the above copyright
# notice, one of the license notices in the documentation
# and/or other materials provided with the distribution.
#
# Author: Alex Rosenbaum <alexr@mellanox.com>
#

#!/bin/bash

# 启用调试模式
if [[ "$1" == "debug" ]]; then
  INSTRUMENTING=yes
  shift
fi

echodbg() {
  [[ "$INSTRUMENTING" ]] && echo "[DEBUG] $@" >&2
}

DEVS=${1:-$(ls /sys/class/infiniband/ 2>/dev/null)}

found=0
for dev in $DEVS; do
    echodbg "Processing device: $dev"
    for port in $(ls /sys/class/infiniband/$dev/ports/ 2>/dev/null); do
        echodbg "  Port: $port"
        ll=$(cat /sys/class/infiniband/$dev/ports/$port/link_layer 2>/dev/null)
        echodbg "    Link layer: $ll"
        
        if [[ "$ll" =~ Ethernet|Infiniband ]]; then
            ndev=$(cat /sys/class/infiniband/$dev/ports/$port/gid_attrs/ndevs/0 2>/dev/null)
            ipaddr=$(ip -f inet addr show $ndev 2>/dev/null | grep -Po 'inet \K[\d.]+' || echo "[no ip addr]")
            
            mlx_pci_dev_path=$(readlink -f /sys/class/infiniband/$dev/device)
            mlx_pci_dev=${mlx_pci_dev_path##*/}
            mlx_pci_br_path=$(dirname $(dirname $mlx_pci_dev_path))
            mlx_pci_br=${mlx_pci_br_path##*/}
            
            echodbg "    PCI Info: dev=$mlx_pci_dev, bridge=$mlx_pci_br"
            
            # 遍历所有PCI总线
            for pci in /sys/class/pci_bus/*; do
                pci_bus=$(basename $pci)
                pci_dev_path=$(readlink -f $pci)
                pci_br_path=$(dirname $(dirname $(dirname $pci_dev_path)))
                pci_br=$(basename $pci_br_path)
                
                if [[ "$mlx_pci_br" == "$pci_br" ]]; then
                    if [[ "${mlx_pci_dev:0:7}" == "$pci_bus" ]]; then
                        continue
                    fi
                    pci_info=$(lspci -D -s "$pci_bus:00.0" 2>/dev/null || echo "$pci_bus:00.0")
                    echo "Network: $ipaddr (${dev}_Port$port) | PCI Device: $pci_info"
                    found=1
                fi
            done
        fi
    done
done

if [[ "$found" -eq 0 ]]; then
    echo "No compatible devices found."
fi