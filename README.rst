######################
Tunfish pocpoc runbook
######################


*****
About
*****
A SDN_ proof-of-concept for approaching convenient VXLAN_
Layer 2/3 convergence on top of secure WireGuard_ tunnels.

This runbook will guide you through the process of setting
up an appropriate testbed environment. It will provision
a number of Vagrant machines and configure them to talk
to each other over a software-defined secure private network.


*******
Details
*******
While the effective network transport is based on IP/UDP,
the virtual circuit offers `Data Link Layer`_ connectivity
on a multi-tenant basis through `Open vSwitch`_.

As this unlocks the capability to send Ethernet frames across
IP networks, it will eventually become possible to use protocols
and technologies reserved for local networks so far.

It opens the door to countless applications requiring
`Data Link Layer`_ connectivity like Zeroconf_,
`Multicast DNS (mDNS)`_ or `DNS Service Discovery (DNS-SD)`_
and their popular implementations and applications
like Bonjour_, Avahi_ and `.local`_.

Other candidates are `Universal Plug and Play (UPnP)`_,
the `Service Location Protocol (SLP)`_ and
`Web Services Dynamic Discovery (WS-Discovery)`_.


*****
Setup
*****
This section will guide you through setting up
a development/testing sandbox on your machine.

Acquire source repository::

    git clone https://github.com/tunfish/pocpoc
    cd pocpoc/sandbox/quickstart

Install requirements on Mac OS X using Homebrew::

    ./requirements-macosx.sh

Make Vagrant spin up all machines configured in this environment::

    vagrant up


*****
Usage
*****

Start WireGuard tunnel
======================
Login to alice or bob::

    vagrant ssh tf-alice
    vagrant ssh tf-bob

::

    systemctl start wg-quick@wg0-server

.. note:: This should have happened already by the Ansible role "tunfish.wireguard".

Test WireGuard tunnel
=====================
Check if the WireGuard tunnel works::

    # Login to alice
    vagrant ssh tf-alice

    # Ping bob
    vagrant@tf-alice:~$ ping 10.10.10.52
    64 bytes from 10.10.10.52: icmp_seq=1 ttl=64 time=0.650 ms

in both directions::

    # Login to bob
    vagrant ssh tf-bob

    # Ping alice
    vagrant@tf-bob:/tmp$ ping 10.10.10.51
    64 bytes from 10.10.10.51: icmp_seq=1 ttl=64 time=0.497 ms

Start overlay network
=====================
Let the nodes join the private Tunfish overlay network::

    vagrant ssh tf-alice
    sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh

    vagrant ssh tf-bob
    sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh

Test Data Link Layer connectivity
=================================
Send raw Ethernet frames using Python
- https://dpkt.readthedocs.io/
- http://www.secdev.org/projects/scapy/
- https://github.com/krig/send_arp.py
- https://github.com/agusmakmun/Python-ARP-Flooding
- https://github.com/ammarx/ARP-spoofing
- http://www.kanadas.com/program-e/2014/08/raw_socket_communication_on_li.html
- https://gist.github.com/cslarsen/11339448
- https://csl.name/post/raw-ethernet-frames/
- https://unix.stackexchange.com/questions/323555/unix-way-to-send-transmit-raw-ethernet-frame
- https://sandilands.info/sgordon/teaching/netlab/its332ap5.html
- http://www.larsen-b.com/Article/206.html



**************
Network layout
**************

Machines
========
::

    192.168.50.0/24     The Vagrant network bound to "vboxnet0" on the host machine
    192.168.50.51       The host "tf-alice" on the "eth1" interface
    192.168.50.52       The host "tf-bob"   on the "eth1" interface

WireGuard
=========
::

    10.10.10.0/24       The WireGuard network bound to "wg0-server" on each guest machine
    10.10.10.51         The host "tf-alice" on the "wg0-server" interface
    10.10.10.52         The host "tf-bob"   on the "wg0-server" interface


***********
Development
***********
To repeat the virtual machine provisioning, run::

    vagrant up --provision

To reprovision just a single host, use::

    vagrant up --provision tf-alice


****************
Acknowledgements
****************

Thank you so much for providing such great infrastructure
components and resources to the community!

- Jason Donenfeld for conceiving WireGuard_. After reading the introduction
  `[RFC] WireGuard: next generation secure network tunnel`_ in late 2016
  and quickly scanning his `paper about WireGuard`_, nobody wondered
  that WireGuard is rapidly gaining adoption.

- The `many authors <http://docs.openvswitch.org/en/latest/internals/authors/>`_
  of `Open vSwitch`_.

- Aaron Brady for his journal article `Making your own private Internet`_,
  which strongly inspired the central idea behind this PoC.
  The `tunfish-join.sh` prototype is derived from his `wg-config.bash`_ gist.

- Scott S. Lowe for his `collection of tools and files for learning new technologies`_.
  To be able to easily spin up development and testing environments,
  we used his `"Open Virtual Network (OVN)" setup`_ Vagrant recipe
  to derive our `sandbox/quickstart` environment from.
  He writes about the recipes at `Learning Environments for OVN`_
  and you might also enjoy reading his `many other articles about Open vSwitch`_.

- Martin Eskdale Moen for his `Ansible role to deploy a wireguard server`_.
  We forked this to the `tunfish.wireguard`_ role and added some slight improvements.

- Mitchell Hashimoto, Chris Roberts and the countless other `contributors to Vagrant`_
  for conceiving and maintaining Vagrant_.

- Michael DeHaan, James Cammarata, Toshio Kuratomi, Brian Coca, Matt Clay, Dag Wieers
  and the countless other `contributors to Ansible`_ for conceiving and maintaining Ansible_.


***************
Troubleshooting
***************

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



.. _SDN: https://en.wikipedia.org/wiki/Software-defined_networking
.. _VXLAN: https://en.wikipedia.org/wiki/Virtual_Extensible_LAN
.. _WireGuard: https://www.wireguard.com/
.. _Data Link Layer: https://en.wikipedia.org/wiki/OSI_model#Layer_2:_Data_Link_Layer
.. _Open vSwitch: https://www.openvswitch.org/

.. _Zeroconf: http://zeroconf.org/
.. _Multicast DNS (mDNS): http://www.multicastdns.org/
.. _DNS Service Discovery (DNS-SD): http://www.dns-sd.org/
.. _Bonjour: https://developer.apple.com/bonjour/
.. _Avahi: http://avahi.org/
.. _.local: https://en.wikipedia.org/wiki/.local
.. _Web Services Dynamic Discovery (WS-Discovery): https://en.wikipedia.org/wiki/WS-Discovery
.. _Universal Plug and Play (UPnP): https://en.wikipedia.org/wiki/Universal_Plug_and_Play
.. _Service Location Protocol (SLP): https://en.wikipedia.org/wiki/Service_Location_Protocol

.. _[RFC] WireGuard\: next generation secure network tunnel: https://lkml.org/lkml/2016/6/28/629
.. _paper about WireGuard: https://www.wireguard.com/papers/wireguard.pdf
.. _Making your own private Internet: https://insom.github.io/journal/2017/04/02/
.. _wg-config.bash: https://gist.github.com/insom/f8e259a7bd867cdbebae81c0eaf49776
.. _"Open Virtual Network (OVN)" setup: https://github.com/lowescott/learning-tools/tree/master/ovs-ovn/ovn
.. _Learning Environments for OVN: https://blog.scottlowe.org/2016/12/07/learning-environments-ovn/
.. _many other articles about Open vSwitch: https://blog.scottlowe.org/tags/ovs/
.. _collection of tools and files for learning new technologies: https://github.com/lowescott/learning-tools
.. _Ansible role to deploy a wireguard server: https://github.com/botto/ansible-wireguard
.. _tunfish.wireguard: https://github.com/tunfish/ansible-wireguard
.. _Vagrant: https://www.vagrantup.com/
.. _Ansible: https://www.ansible.com/
.. _contributors to Vagrant: https://github.com/hashicorp/vagrant/graphs/contributors
.. _contributors to Ansible: https://github.com/ansible/ansible/graphs/contributors
