---
title: "Deploy OpenNebula on-prem with an ISO"
linkTitle: "ISO deployment"
description:
weight: 3
---

## Introduction

The OpenNebula ISO is a disk image that can be written to removable media, that can be booted up to install a pre-configured version of AlmaLinux 9 and OpenNebula Enterprise Edition, including initial setup, on a server provided.

Once the ISO has booted and finished installing and setting up the software, a pre-configured cloud based on OpenNebula will be ready for immediate use, installed on a single bare-metal server, complete with the OpenNebula Front-end server and a KVM hypervisor node. The same ISO can be used to install other KVM hypervisors on the same infrastructure.

The OS installed also includes a menu and a little set of ansible playbooks to make the OpenNebula infrastructure Management simpler.

![onepoc_architecture](/images/ISO/00-onepoc_architecture.png)

## Requirements

The OpenNebula ISO is based on AlmaLinux 9, and thus it shares the same requirements to run. Note that only the x86-64-v2 instruction set (introduced in 2008\) is supported. The following table states the minimum requirements for installing the ISO.

| Component | Required |
| :---- | :---- |
| **CPU** | - Recent CPU (after 2016)<br />- Virtualization enabled at BIOS level |
| **Memory** | - Over 32 GB for frontend and nodes |
| **Disk** | - 512 GB NvME |
| **Network** | - At least a NIC for management\* <br />- Recommended 2 NICs (management and service) |

\*Not needed for installation
{{< alert title="Warning" color="warning" >}}
**Installing the ISO will delete all the disk data on the server during the installation.**
{{< /alert >}}

## ISO Download and installation

Now it is time to download the OpenNebula ISO (based on Alma Linux). Currently, the following versions are available:

- [OpenNebula 7.0.1 Community Edition](https://one-poc.s3.eu-central-1.amazonaws.com/7.0.1/CE/opennebula-7.0.1-CE.iso) \([SHA256 checksum](https://one-poc.s3.eu-central-1.amazonaws.com/7.0.1/CE/opennebula-7.0.1-CE.iso.sha)\)

Once the image is downloaded, there are two ways to go:

- If the server has a IPMI, ILO, iDRAC, RSA or some other way to mount remote media (ISO or USB), the ISO can be directly mounted on it
- If, on the other side, there is no server console but there is physical access to the USB ports on the server, a USB image can be created to boot from it

In Linux or MacOS, the image can be dumped on the USB with the following command

```bash
dd if=/path/to/your/opennebula-7.0.1-CE.iso of=/dev/sdXX
```

{{< alert title="Check the USB drive" color="warning" >}}
`/dev/sdXX` is the drive for the USB drive. It's recommended to check it twice to avoid catastrophic data lose{{< /alert >}}

On windows, the USB drive can be created with Rufus.

{{< alert title="Rufus USB creation mode" color="warning" >}}
The USB drive must be created using DD mode or else it won't be bootable.{{< /alert >}}

With the media inserted (or virtually mounted) on the server, after rebooting it set the right boot device on the BIOS. Some BIOS may be able to boot the media as MBR and UEFI. We recommend to boot is as UEFI for compatibility reasons.

The bootloader will show the following screen

| ![uefi_boot_screen](/images/ISO/0-uefi_boot_screen.png) | ![mbr_boot_screen](/images/ISO/0-mbr_boot_screen.png) |
| ----- | ----- |
| UEFI boot screen | MBR boot screen |

The Options are the following:
- `Install OpenNebula POC` will install a full OpenNebula frontend and the necessary software to make it a OpenNebula KVM hypervisor
- `Install OpenNebula Node` will install only the KVM Hypervisor packages

{{< alert title="Other options" color="success" >}}
**The options `Test this media and Install ...` are not recommended on remote console installations because they are slow and must send all the ISO data to compute a checksum**. They may be useful installing from fast local media (i.e. a USB pendrive) if the unit is prone to error.
{{< /alert >}}

The installation interface will be in text mode and will only ask for confirmation before deleting all the data on the first disk that it finds on a screen that looks like the following:

![validation_script](/images/ISO/01-validation_script.png)

{{< alert title="Warning: data will be deleted" color="warning" >}}
**IMPORTANT: OpenNebula will be installed on the first disk found and it will delete IRREVERSIBLY all the data in that disk. Ensure that this is the right server.**{{< /alert >}}

After the confirmation, the installation will start. It will show some information related to the default settings and the packages that will be installed

![anaconda_unattended_install](/images/ISO/02-anaconda_unattended_install.png)

## Frontend configuration

Once the installation is finished in the frontend, no network card will be configured, so an access with the console must be provided. It will look like the following (the colours and the font may vary)

```
Welcome to OpenNebula Proof of Concept (onepoc) !

- Please, log in as user `root`
- For a basic configuration of the server, please execute `onefemenu`
- After the network is configured, the sunstone interface will be running in

  http://this_server:2616

- Please, check the manual page onepoc-quickstart with a

  $ man onepoc-quickstart 7

Thank you!
```

{{< alert title="Default user and password" color="success" >}}
Default user is root and default root password is `0p3nN3bul4`.
After the login, execute `onefemenu` in order to configure the frontend.
{{< /alert >}}

The frontend menu will look like the following one (the colours and the font may vary). The options can be navigated with the cursor keys and the options can be selected with ENTER:

```
                            ┌──────────────────────OpenNebula node Setup─────────────────────────┐
                            │ Setup menu                                                         │
                            │ ┌────────────────────────────────────────────────────────────────┐ │
                            │ │          check_host          Check host requirements           │ │
                            │ │          netconf             Configure network                 │ │
                            │ │          enable_fw           Enable firewalld                  │ │
                            │ │          disable_fw          Disable firewalld                 │ │
                            │ │          add_host            Add OpenNebula Host               │ │
                            │ │          proxy               Configure proxy settings          │ │
                            │ │          tmate               Remote console support            │ │
                            │ │          show_oneadmin_pass  Show oneadmin password            │ │
                            │ │          quit                Exit to Shell                     │ │
                            │ │                                                                │ │
                            │ │                                                                │ │
                            │ │                                                                │ │
                            │ │                                                                │ │
                            │ └────────────────────────────────────────────────────────────────┘ │
                            ├────────────────────────────────────────────────────────────────────┤
                            │                   <  OK  >          <Cancel>                       │
                            └────────────────────────────────────────────────────────────────────┘
```

### Network and hostname setup

Now is time to configure the network using the option `netconf` on the menu. This will launch `nmtui` (the default ncurses configuration interface), that allows the setup of the network and hostname, as more complex network configuration (bonding, VLAN, etc.)

The following menu will appear

```
                                                   ┌─┤ NetworkManager TUI ├──┐
                                                   │                         │
                                                   │ Please select an option │
                                                   │                         │
                                                   │ Edit a connection       │
                                                   │ Activate a connection   │
                                                   │ Set system hostname     │
                                                   │ Radio                   │
                                                   │                         │
                                                   │ Quit                    │
                                                   │                         │
                                                   │                    <OK> │
                                                   │                         │
                                                   └─────────────────────────┘
```

To configure the network, select `Edit a connection`. The following menu will appear showing all the available network interfaces. In this case the image only shows one, but there may be more than one. Select the one that will be used for OpenNebula management.

```
                                                  ┌───────────────────────────┐
                                                  │                           │
                                                  │ ┌─────────────┐           │
                                                  │ │ Ethernet  ↑ │ <Add>     │
                                                  │ │   enp3s0  ▒ │           │
                                                  │ │ Loopback  ▒ │ <Edit...> │
                                                  │ │   lo      ▒ │           │
                                                  │ │           ▒ │ <Delete>  │
                                                  │ │           ▒ │           │
                                                  │ │           ▮ │           │
                                                  │ │           ▒ │           │
                                                  │ │           ▒ │           │
                                                  │ │           ▒ │           │
                                                  │ │           ▒ │           │
                                                  │ │           ↓ │ <Back>    │
                                                  │ └─────────────┘           │
                                                  │                           │
                                                  └───────────────────────────┘
```

{{< alert title="Network considerations" color="success" >}}
Determine the network address of the frontend before configuring the network.
In this document a static IP 172.20.0.7/24 with default gatewayi 172.20.0.1 and DNS 172.20.0.1, single port ethernet with MTU 1500 connection will be used.
To set up special networking configuration, please check the documentation about `nmtui`.
{{< /alert >}}

Select the interface that must be configured for OpenNebula management access. After that, navigate to "IPv4 CONFIGURATION", press Enter and change the option to Manual. After that, select the field `Show` at the right side.

```
                           │                     ┌────────────┐                                      │
                           │ ═ ETHERNET          │ Disabled   │                            <Show>    │
                           │ ═ 802.1X SECURITY   │ Automatic  │                            <Show>    │
                           │                     │ Link-Local │                                      │
                           │ ╤ IPv4 CONFIGURATION│ Manual     │                            <Hide>    │
                           │ │          Addresses│ Shared     │ ___________ <Remove>                 │
                           │ │                   └────────────┘                                      │

```

The IPv4 Settings can be set up then. After setting up the IP/mask, default gateway and DNS servers, check `Require IPv4 addressing for this connection` and `Automatically connect`.

```
                           ┌───────────────────────────┤ Edit Connection ├───────────────────────────┐
                           │                                                                         │
                           │         Profile name enp3s0__________________________________           │
                           │               Device enp3s0 (XX:XX:XX:XX:XX:XX)______________           │
                           │                                                                         │
                           │ ═ ETHERNET                                                    <Show>    │
                           │ ═ 802.1X SECURITY                                             <Show>    │
                           │                                                                         │
                           │ ╤ IPv4 CONFIGURATION <Manual>                                 <Hide>    │
                           │ │          Addresses 172.20.0.7/24____________ <Remove>                 │
                           │ │                    <Add...>                                           │
                           │ │            Gateway 172.20.0.1_______________                          │
                           │ │        DNS servers 172.20.0.1_______________ <Remove>                 │
                           │ │                    <Add...>                                           │
                           │ │     Search domains <Add...>                                           │
                           │ │                                                                       │
                           │ │            Routing (No custom routes) <Edit...>                       │
                           │ │ [ ] Never use this network for default route                          │
                           │ │ [ ] Ignore automatically obtained routes                              │
                           │ │ [ ] Ignore automatically obtained DNS parameters                      │
                           │ │                                                                       │
                           │ │ [X] Require IPv4 addressing for this connection                       │
                           │ └                                                                       │
                           │                                                                         │
                           │ ═ IPv6 CONFIGURATION <Automatic>                              <Show>    │
                           │                                                                         │
                           │ [X] Automatically connect                                               │
                           │ [X] Available to all users                                              │
                           │                                                                         │
                           │                                                           <Cancel> <OK> │
                           │                                                                         │
                           └─────────────────────────────────────────────────────────────────────────┘
```

The default hostname is `onepoc`, if it needs to be changed, the option `Set system hostname` of the menu will lead to the following text dialog that allow the hostname change.

```

                                                   ┌─┤ NetworkManager TUI ├──┐
                                                   │                         │
                                                   │ Please select an option │
                                      ┌─────────────────┤ Set Hostname ├──────────────────┐
                                      │                                                   │
                                      │ Hostname ________________________________________ │
                                      │                                                   │
                                      │                                     <Cancel> <OK> │
                                      │                                                   │
                                      └───────────────────────────────────────────────────┘

                                                   │                    <OK> │
                                                   │                         │
                                                   └─────────────────────────┘
```

After the modification of the configuration, choose `Quit` on the menu. An ansible playbook will configure the needed services, it may take some minutes until finished.

```
....

PLAY RECAP *********************************************************************
172.20.0.7                 : ok=44   changed=2    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
frontend                   : ok=42   changed=8    unreachable=0    failed=0    skipped=28   rescued=0    ignored=0

Press any key to continue
```

## Configuring the Hypervisor host

After the installation, the server runs only the frontend and needs to be added as a OpenNebula hypervisor to run VMs. The steps are:

- log in as root in the server
- execute `onefemenu`
- select the option `add_host`

{{< alert title="Avoid the usage of loopback addresses" color="success" >}}
When a node is added, always use it's external IP, neither `localhost` nor a loopback addres `127.x.x.x'.
{{< /alert >}}

After selecting the option `add_host`, the IP for the host will be asked for.
In this case we are using the IP that was configured before, 172.20.0.7

```
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Insert the IP for the node                               │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │172.20.0.7                                            │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘

```

Then, the user to log into the node will be asked. It MUST be root or have sudo root access without password

```
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Insert the user for the node                             │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │root                                                  │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘
```

A confirmation dialog like the following will be shown:

```
                       ┌──────────────────────────────────────────────────────────────────────────────┐
                       │ Add node  172.20.0.7 logging as user root (with nopasswd root permissions)?  │
                       │ Password will be asked. If not provided, an ssh connection using the ssh key │
                       │ of onepoc user will be used                                                  │
                       │                                                                              │
                       │                                                                              │
                       ├──────────────────────────────────────────────────────────────────────────────┤
                       │                         < Yes >             < No  >                          │
                       └──────────────────────────────────────────────────────────────────────────────┘
```

After that, an ansible playbook will run in order to execute all the needed operations on the frontend. This may take some minutes

```
...
PLAY RECAP *********************************************************************
...
...
172.20.0.7                 : ok=52   changed=27   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
frontend                   : ok=43   changed=11   unreachable=0    failed=0    skipped=27   rescued=0    ignored=0

Press any key to continue
```

**Graphical User Interface**

The GUI should be available in http://\<frontend\_ip\>:2616

The oneadmin password can be obtained in `onefemenu`, in the option `show_oneadmin_pass`

{{< alert title="Length of `oneadmin` password" color="success" >}}
`oneadmin` default password is 32 hex chars long (128 bits of entropy). It's recommended to create another user to work with OpenNebula and let oneadmin user only for administrative tasks.
{{< /alert >}}

**Networking**

The ISO deployment does not automatically configure virtual networks. Instead, FRR is configured to add BGP-EVPN so VXLANs should work for internal communication. VXLAN is a technology that allows isolation between Virtual networks, depending on an identifier between 1 and 16777215.

That means that a virtual network over VXLAN can be created from the web interface, selecting the type VXLAN, setting up the physical device for the package transit, and filling the contextualization of the network (address, gateway, etc.).

A VNET can be set up on the sunstone interface on Networks \-\> Virtual Networks \-\> Create Virtual Network, following the next model. In this case we are using the VXLAN 100 (a positive number under 16777215) on the interface enp3s0 of the frontend, but it must be adjusted to the external interface of the frontend.

{{< alert title="VXLAN evpn" color="success" >}}
To allow he VXLAN mode must be `evpn` in all cases.
{{< /alert >}}

![sunstone-network_config](/images/ISO/03-sunstone-network_config.png)

An address range must be created, in this case we chose an IPv4 range address starting from 172.16.100.8 with 100 consecutive IPs.

![sunstone-network_ip_range](/images/ISO/04-sunstone-network_ip_range.png)

The network contextualization has the following parameters

![sunstone-network_context](/images/ISO/05-sunstone-network_context.png)

{{< alert title="MTU size" color="warning" >}}
The contextualization MTU on this network MUST be the MTU of the physical interface minus 50 bytes (the size of the VXLAN encapsulation) or smaller. 1450 is a safe default (regular ethernet frame size).
{{< /alert >}}


### Virtual network considerations

VXLAN networks are totally internal and have no access to external networks. By default they can be considered a totally isolated net. External access from/to this networks must be configured.

#### Determining the VM identifier

To determine the virtual network that needs external access use `onevnet list`. This command will list the existent virtual networks, for instance:

```
# onevnet list
  ID USER     GROUP    NAME          CLUSTERS   BRIDGE    STATE    LEASES OUTD ERRO
   0 oneadmin oneadmin test_vnet     0          XXXXX     rdy           0    0    0
```

The `ID` and the `NAME` field of every row can be used for all operations on virtual networks.

#### Creating the virtual Network Gateway (access from the frontend)

In this case, to create the default gateway on this virtual net, the command `onevnet_add_gw` followed by the ID of the virtual network should be executed. For example the following command will create the gateway for the network 0

```
# onevnet_add_gw 0
```

To delete the gateway and make the network unreachable, reverting the behaviour, `onevnet_del_gw <NETWORK_ID>` should be executed in the same way

{{< alert title="Persistence of the gateway" color="warning" >}}
This gateway is not persistent after reboots. If the frontend is rebooted, the command `onevnet_add_gw <NETWORK_ID>` must be issued again.
{{< /alert >}}

#### Setting up NAT (access to the same networks as the frontend)

Virtual machines on this virtual network won't be able to access to the same networks as the frontend because there is no NAT. A simple NAT can be created executing the command `enable_masquerade`

{{< alert title="Security and persistence warning" color="warning" >}}
By default, the `enable_masquerade` command will allow ALL the virtual networks having a gateway. To disable this behaviour, execute `disable_masquerade`. After a reboot of the frontend, the NAT configuration will be deleted and must be applied again using `enable_masquerade`.
{{< /alert >}}

#### Add local route (access from external networks to the virtual network)

After the gateway has been created and NAT masquerade has been enabled, the VMs in the virtual network 172.16.100.0/24:

- can communicate (bidirectionally) with the frontend
- can access to the same networks that the frontend (i.e. internet)

Currently, any machine (even if it has access to the frontend) cannot reach ths virtual network because doesn't know how to arrive to it. For that, a route via the frontend external IP is needed. A route can be added locally.

{{< alert title="Routing setup" color="Success" >}}
This document must not be taken as a manual to configure routing. These are local solutions to test the access. None of this solutions will persist after a reboot of the workstation where they have been applied.
{{< /alert >}}

On a workstation with access to the frontend, a local route to the virtual net can be created with the following commands depending on the operating system
- Linux: `sudo ip route add 172.16.100.0/24 via <frontend_ip>`
- Windows: `route add 172.16.100.0 MASK 255.255.255.0 <frontend_ip>`
- BSD: `route add -net 172.16.100.0/24 <frontend_ip>`

After the route exists, the workstation should be able to reach the virtual machines running on the frontend without further configuration.

## GPU Configuration - Host

If the OpenNebula evaluation involves GPU management, GPU should be configured in pass-through mode. For the detailed process check [our official documentation](https://docs.opennebula.io/7.0/product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough/)
Overall, a GPU configuration in OpenNebula consists from 2 main stages:
- Host preparation and driver configuration
- OpenNebula settings for PCI pass-through devices

To prepare the OpenNebula host complete the following steps:
- Check that IOMMU was enabled on the host using the following command:
```default
# dmesg | grep -i iommu
```
If IOMMU wasn’t enabled on the host, follow the process specified in the official documentation to enable IOMMU - https://docs.opennebula.io/7.0/product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough/.
At the next step GPU has to be bound to the vfio driver. For this, perform the following steps:
1. Install `driverctl` utility:

    ```default
    # dnf install driverctl
    ```

2.  Ensure `vfio-pci` module is loaded on boot:

    ```default
    # echo "vfio-pci" | sudo tee /etc/modules-load.d/vfio-pci.conf
    # modprobe vfio-pci
    ```

3.  Identify the GPU's PCI address:

    ```default
    # lspci -D | grep -i nvidia
    0000:e1:00.0 3D controller: NVIDIA Corporation GH100 [H100 PCIe] (rev a1)
    ```

4.  Set the driver override.     Use the PCI address from the previous step to set an override for the device to use the `vfio-pci` driver.

    ```default
    # driverctl set-override 0000:e1:00.0 vfio-pci
    ```

5.  Verify the driver binding:
    Check that the GPU is now using the `vfio-pci` driver.

    ```default
    # lspci -Dnns e1:00.0 -k
    Kernel driver in use: vfio-pci
    ```

### VFIO Device Ownership

For OpenNebula to manage the GPU, the VFIO device files in `/dev/vfio/` must be owned by the `root:kvm` user and group. This is achieved by creating a `udev` rule.

1.  Identify the IOMMU group for your GPU using its PCI address:

    ```default
    # find /sys/kernel/iommu_groups/ -type l | grep e1:00.0
    /sys/kernel/iommu_groups/85/devices/0000:e1:00.0
    ```
    In this example, the IOMMU group is `85`.

2.  Create a `udev` rule:
    Create the file `/etc/udev/rules.d/99-vfio.rules` with the following content:

    ```default
    SUBSYSTEM=="vfio", GROUP="kvm", MODE="0666"
    ```

3.  Reload `udev` rules:

    ```default
    # udevadm control --reload
    # udevadm trigger
    ```

4.  Verify ownership:
    Check the ownership of the device file corresponding to your GPU's IOMMU group.

    ```default
    # ls -la /dev/vfio/
    crw-rw-rw- 1 root kvm 509, 0 Oct 16 10:00 85
    
## GPU Configuration - OpenNebula

### Monitoring PCI Devices

To make the GPUs available in OpenNebula, configure the PCI probe on the front-end node to monitor NVIDIA devices.

1.  Edit the PCI probe configuration file at `/var/lib/one/remotes/etc/im/kvm-probes.d/pci.conf`.
2.  Add a filter for NVIDIA devices:

    ```default
    :filter: '10de:*'
    ```

3.  Synchronize the hosts from the Front-end to apply the new configuration:

    ```default
    # su - oneadmin
    $ onehost sync -f
    ```

After a few moments, you can check if the GPU is being monitored correctly by showing the host information (`onehost show <HOST_ID>`). The GPU should appear in the `PCI DEVICES` section.

## VM with GPU instantiation
 To instantiate VM with a GPU login into the OpenNebula GUI and navigate to the VMs tab. Click “Create”. Then select one of the VM templates On the next screen enter the VM name and click “Next”.

![VM Instantiation](/images/ISO/06-vm-instantiate-1.png)

On the next screen select required Storage and Network options. In the “PCI Devices” section click “Attach PCI device”

![PCI Device attachment](/images/ISO/07-vm-instantiate-pci-device.png)

In the dropdown menu select available GPU device which will be attached to the VM. Then click “Accept” button and finalize VM configuration.

![PCI Device attachment](/images/ISO/08-vm-instantiate-pci-device-select.png)

Click the “Finish” button to start VM instantiation. After a while, the VM will be instantiated and may be used. 

## vLLM appliance validation
The vLLM appliance is available through the OpenNebula Marketplace. Follow steps from the official documentation page - https://docs.opennebula.io/7.0/solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification/. To download vLLM appliance and instantiate with a GPU in passthrough mode, the following steps have to be performed:
1. Go to Storage -> Apps section.
Search for vLLM appliance and import it. Select DataStore where to save image

![PCI Device attachment](/images/ISO/09-vllm-appliance.png)
2. Go to VMs section and instantiate vLLM appliance. Specify common VM parameters. In the “Advanced Settings” go to “PCI devices” and ensure that required GPU device selected for attachment to the VM. Click “Accept” and then “Finish” to instantiate vLLM appliance.
3. Once vLLM appliance instantiated, follow steps from the https://docs.opennebula.io/7.0/solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification/ to access a webchat app or execute benchmarking tests

## Next Steps

Additionally, we recommend checking [Validate the environment]({{% relref "validate_the_environment" %}}), that describes how to explore the resources installed and how to download and run appliances from the [OpenNebula Marketplace](https://marketplace.opennebula.io/).

Finally, you can use your OpenNebula installation to [Run a Kubernetes Cluster on OpenNebula]({{% relref "running_kubernetes_clusters" %}}) with minimal steps -- first downloading the OneKE Service from the OpenNebula Public Marketplace, then  deploying a full-fledged K8s cluster with a test application.
