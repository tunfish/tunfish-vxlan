#######################
Troubleshooting Tunfish
#######################


*************************
Troubleshooting WireGuard
*************************


DKMS module not available
=========================

If the following command does not list any module after you installed wireguard-dkms,::

    modprobe wireguard && lsmod | grep wireguard

or if creating a new link returns::

    # ip link add dev wg0 type wireguard
    RTNETLINK answers: Operation not supported

you probably miss the linux headers.

These headers are available in ``linux-headers`` or ``linux-lts-headers``
depending of the kernel installed on your system.

.. note:: https://wiki.archlinux.org/index.php/WireGuard#Troubleshooting

After installing the appropriate linux kernel headers,::

    apt -y install linux-headers-$(uname -r)

just do::

    dpkg-reconfigure wireguard-dkms


Configuration
=============
To dump the WireGuard configuration, use::

    wg showconf wg0-server


Connectivity
============
Running::

    tcpdump -i wg0-server

in combination with an ICMP ping::

    vagrant@tf-alice:~# ping 10.10.10.52

on both machines might tell you whether your packets are reaching
the remote peer or if they're not getting through the tunnel.

.. note:: https://www.ericlight.com/wireguard-part-three-troubleshooting.html



*********************
Troubleshooting VXLAN
*********************
Display information about bridge device::

    brctl show tb-quickstart
    bridge monitor

Display Spanning Tree Protocol (STP) information::

    brctl showstp tb-quickstart

Display MAC and ARP information::

    brctl showmacs tb-quickstart
    arp -a

Ping MAC address through ARP::

    arping -i tb-quickstart 96:71:7d:db:cd:36

To see the dynamic MAC address assignment in action
while bouncing the link on the remote machine, run::

    watch -n0.5 'arp -a; echo; brctl showmacs tb-quickstart'

