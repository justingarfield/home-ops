# Hardware

## Table of Contents

* [Compute](#compute)
  * [Main / Gaming PC](#main-pc)
  * [Media PC](#media-pc)
  * [Living Room NUC](#living-room-nuc)
  * [Management NUC](#management-nuc)
  * [Raspberry Pi 4 Model B](#raspberry-pi)
  * [Dell R320 appliance server](#dell-r320)
  * [HP DL380 G6](#hp-dl380-g6)
* [Dedicated Storage](#dedicated-storage)
* [Network](#network)
* [Equipment Cabinets / Racks](#equipment-cabinets-and-racks)
* [Other](#other)

## <a id="compute"></a>Compute

### <a id="main-pc"></a>Main / Gaming PC

Custom-built PC I use as my main / gaming workstation.

**Key Features**:

* Additional 4-port NIC so I can be on multiple VLANs and Subnets at once
* Separate OS / Gaming Data / Docker Data / WSL Data disks to eliminate contention
* 128GB RAM so I can launch tons of Containers, VMs, etc. without worry
* 10Gbps NIC connection to switch for quick access to NAS files

#### Main Components

| Component | Product |
|-|-|
| Motherboard      | [Gigabyte Z590 AORUS Master](https://www.amazon.com/gp/product/B083GTD1N6) |
| CPU              | [Intel® Core™ i7-11700K Desktop Processor](https://www.amazon.com/gp/product/B08X6ND3WP) |
| Memory           | 128GB (4 x 32GB) of [Corsair Vengeance LPX DDR4 RAM](https://www.amazon.com/gp/product/B07YV9VYYY) |
| Graphics Card    | [ASUS nVidia 3060](#) |
| Power Supply     | [Corsair HX Series, HX850, 850 Watt, 80+ Platinum Certified](https://www.amazon.com/gp/product/B01NARQ2QU) |
| Case             | [Define R6 Tempered Glass](https://www.fractal-design.com/products/cases/define/define-r6-tempered-glass/blackout/) |
| Additional NIC   | [Quad-Port PCIe Gigabit Ethernet Server Adapter with NetXtreme® BCM5719](https://www.amazon.com/gp/product/B0BDRVFL2R) |
| Backup Battery   | [APC UPS 1500VA Sine Wave UPS Battery Backup, BR1500MS2](https://www.amazon.com/APC-Protector-BR1500MS2-Back-UPS-Uninterruptible/dp/B08GRY1W93) |

#### Storage Setup

| Name | Brand/Model | Size | Type | Description |
|-|-|-|-|-|
| Windows OS Disk  | [Samsung 980 Pro - NVMe - Gen 4](https://www.amazon.com/gp/product/B08GLX7TNT)  |   1TB | NVMe | Holds Windows OS files, updates, main programs, etc. |
| Gaming Data Disk | [Samsung 980 Pro - NVMe - Gen 4](https://www.amazon.com/gp/product/B08GLX7TNT)  |   1TB | NVMe | Holds all gaming related files to reduce contention with OS related tasks |
| Docker Data Disk | [Crucial MX500 250GB SSD - SATA3](https://www.amazon.com/gp/product/B0781VSXBP) | 256GB | SSD  | Holds all Docker Desktop Data (including downloaded Images/layers) |
| WSL Data Disk    | [Crucial MX500 250GB SSD - SATA3](https://www.amazon.com/gp/product/B0781VSXBP) | 256GB | SSD  | Holds all WSL-side Data (source code, etc.) |

### <a id="media-pc"></a>Media PC

Custom-built PC I use as my media workstation.

**Key Features**:

* 18x CPU Cores
* Separate OS / Plex Data / Music Data / Scratch disks to eliminate contention
* 128GB RAM to easily handle multiple large media-related tasks _(enconding, transcoding, demuxing, muxing, etc.)_
* 10Gbps NIC connection to switch for quick access to NAS files

#### Main Components

| Component | Product |
|-|-|
| Motherboard      |  |
| CPU              | 18-core Xeon |
| Memory           | 128GB RAM Kit |
| Graphics Card    |  |
| Power Supply     |  |
| Case             |  |
| Additional NIC   |  |
| Backup Battery   | [APC UPS 1500VA Sine Wave UPS Battery Backup, BR1500MS2](https://www.amazon.com/APC-Protector-BR1500MS2-Back-UPS-Uninterruptible/dp/B08GRY1W93) |

#### Storage Setup

| Name | Brand/Model | Size | Type | Description |
|-|-|-|-|-|
| Linux OS Disk         | [Samsung 980 Pro - NVMe - Gen 3](https://www.amazon.com/gp/product/B08GLX7TNT) |   1TB | NVMe | Holds Linux OS files, updates, main programs, etc. |
| Plex Data Disk        | [Samsung 980 Pro - NVMe - Gen 3](https://www.amazon.com/gp/product/B08GLX7TNT) |   1TB | NVMe | Holds all Plex Media Service (PMS)  related files to eliminate contention with OS related tasks |
| Music (Mirrored)      | [Crucial MX500 1TB SSD - SATA3](https://www.amazon.com/gp/product/B078211KBB)  |  1TB | SSD  | Holds all music files, mirrored with another matching disk |
| Music (Mirrored)      | [Crucial MX500 1TB SSD - SATA3](https://www.amazon.com/gp/product/B078211KBB)  |  1TB | SSD  | Holds all music files, mirrored with another matching disk |
| Download Scratch Disk | [Crucial MX500 1TB SSD - SATA3](https://www.amazon.com/gp/product/B078211KBB)  |  1TB | SSD  | Holds partial and fully downloaded files that eventually get moved |
| Spare                 | [Crucial MX500 1TB SSD - SATA3](https://www.amazon.com/gp/product/B078211KBB)  |  1TB | SSD  | Currently unused |

### <a id="living-room-nuc"></a>Living Room NUC

GMKtec Intel NUC box that I use in the Living Room. Hooked up to a 65" Samsung QLED TV.

### <a id="management-nuc"></a>Management NUC

GMKtec Intel NUC box that I use in the basement as a Management / SIEM PC; as well as an in-house Docker Registry Mirror for multiple registries.

### <a id="raspberry-pi"></a>Raspberry Pi 4 Model B

* 8 x [Raspberry Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/)
  * 8 x [Crucial 1TB MX500 SSD](https://www.amazon.com/gp/product/B078211KBB)

### <a id="dell-r320"></a>Dell R320 appliance server

* 2 x [Dell R320 appliance server](https://www.amazon.com/Dell-PowerEdge-R320-Certified-Refurbished)
  * 2 x [Intel XL710-BM1 10G Quad-Port SFP+ NIC](https://www.fs.com/products/75602.html)
  * 4 x [Seagate 3TB Enterprise Capacity SAS](https://www.amazon.com/gp/product/B07F7NBGY3) 7.2k RPM drives
  * 8GB RAM

### <a id="hp-dl380-g6"></a>HP DL380 G6

Currently offline because electricity costs are becoming insane.

* 2 x HP DL380 G6
  * 64GB RAM
  * 4 x 320GB SAS drives
  * 4 x 780GB SAS drives

## <a id="dedicated-storage"></a>Dedicated Storage

* 1 x [Synology DS3617x](https://www.amazon.com/Synology-DS3617xs-Station-Diskless-12-Bay/dp/B01MSTCXPN) w/ 16GB RAM
  * 12 x [10TB WD Red Pro](https://www.amazon.com/Red-10TB-Internal-Hard-Drive/dp/B084F34HZ6) 7.2k RPM SATA drives
  * Additional 2-port SFP+ NIC with 20Gbps LAGG to switch

## <a id="network"></a>Network

* 1 x [FS S5500-48T8SP](https://resource.fs.com/mall/file/datasheet/l3-stackable-poe%2B-switch-datasheet.pdf) 48-Port Gigabit L3 PoE+ Managed Switch with 8 SFP+
* 1 x [FS S3900-24T4S](https://www.fs.com/products/72944.html) 24-Port Gigabit Ethernet L2+ Switch, 24 x Gigabit RJ45, with 4 x 10Gb SFP+ Uplinks
* 1 x [FS AP3000C](https://www.fs.com/products/84028.html) Wi-Fi 5 802.11ac Wave 2, 3000 Mbps Wireless Access Point, 4x4 MU-MIMO
* 1 x [TimeMachines TM2000B](https://timemachinescorp.com/product/gps-ntpptp-network-time-server-tm2000/) GPS NTP+PTP Network Time Server
* 1 x [TimeMachines TM160](https://timemachinescorp.com/product/rack-mount-0-5-inch-poe-ntp-clock/) POE NTP Clock

## <a id="equipment-cabinets-and-racks"></a>Equipment Cabinets / Racks

* 2 x [UCTRONICS Pi Rack Pro for Raspberry Pi 4B](https://www.amazon.com/gp/product/B0B6TW81P6)
* 1 x [FS Horizontal Single Sided Cable Manager](https://www.fs.com/products/29038.html)
* 2 x [FS 10GBASE-T SFP+ Transceiver Module](https://www.fs.com/products/66612.html)
* 5 x [FS 1U 19" Rack Blanking Panel](https://www.fs.com/products/72753.html)
* 4 x [FS Single-Phase 15A/125V Basic PDU](https://www.fs.com/products/119617.html)
* Many x [FS Cat8 Snagless Shielded Ethernet Network Patch Cable](https://www.fs.com/products/72756.html)
* Many x [FS Red NEMA 5-15P to IEC320 C13 Power Cord](https://www.fs.com/products/36091.html)
* Many x [FS Blue NEMA 5-15P to IEC320 C13 Power Cord](https://www.fs.com/products/36089.html)
* Many x [FS 10G SFP+ Passive DAC Twinax Cable](https://www.fs.com/products/104207.html)
