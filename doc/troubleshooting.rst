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


WireGuard connectivity
======================
Run::

    tcpdump -i wg0-server

to tell you whether your packets are reaching the remote server
or if they're not getting through the tunnel.

.. note:: https://www.ericlight.com/wireguard-part-three-troubleshooting.html
