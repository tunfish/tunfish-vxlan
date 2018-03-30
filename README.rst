.. image:: https://ptrace.tunfish.org/thunfisch-160.jpg

|

.. image:: https://img.shields.io/github/tag/tunfish/pocpoc.svg
    :target: https://github.com/tunfish/pocpoc

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

After that, you will easily be able to conduct connectivity
tests and continue with further experiments.


*******
Details
*******
While the effective network transport is based on IP/UDP,
the virtual circuit offers `Data Link Layer`_ (Layer 2)
connectivity on a multi-tenant basis through `Open vSwitch`_.

As this unlocks the capability to send Ethernet frames across
IP networks, it will eventually become possible to use protocols
and technologies reserved for local networks (LANs) so far.

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
Login to each alice and bob::

    vagrant ssh tf-alice
    vagrant ssh tf-bob

Start WireGuard interface::

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
Let both nodes join the private Tunfish overlay network::

    vagrant ssh tf-alice
    sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh

    vagrant ssh tf-bob
    sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh

Test Data Link Layer connectivity
=================================

Check IP connectivity
---------------------
Check if sending and receiving ICMP packets works::

    # Login to alice
    vagrant ssh tf-alice

    # Ping bob
    vagrant@tf-alice:~$ ping 10.10.20.52
    64 bytes from 10.10.20.52: icmp_seq=1 ttl=64 time=0.672 ms

in both directions::

    # Login to bob
    vagrant ssh tf-bob

    # Ping alice
    vagrant@tf-bob:/tmp$ ping 10.10.20.51
    64 bytes from 10.10.20.51: icmp_seq=1 ttl=64 time=0.484 ms

Check Layer 2 connectivity
--------------------------
Todo.

Send raw Ethernet frames or other beasts using Python, e.g.:

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
    192.168.50.51       The host "tf-alice" on its own "eth1" interface
    192.168.50.52       The host "tf-bob"   on its own "eth1" interface

WireGuard
=========
::

    10.10.10.0/24       The WireGuard network bound to "wg0-server" on each guest machine
    10.10.10.51         The host "tf-alice" on its own "wg0-server" interface
    10.10.10.52         The host "tf-bob"   on its own "wg0-server" interface


***********
Development
***********
To repeat the virtual machine provisioning, run::

    vagrant up --provision

To reprovision just a single host, use::

    vagrant up --provision tf-alice

The source code directory `./src` will be mounted into each
virtual machine at `/opt/quickstart-dev` for convenient live
editing.


*******************
Project information
*******************

About
=====
The "Tunfish pocpoc" spike is released under the GNU AGPL license.
Its source code lives on `GitHub <https://github.com/tunfish/pocpoc>`_.
You might also want to have a look at the `documentation <https://tunfish.org/doc/>`_.

If you'd like to contribute you're most welcome!
Spend some time taking a look around, locate a bug, design issue or
spelling mistake and then send us a pull request or create an issue.

Thanks in advance for your efforts, we really appreciate any help or feedback.

Code license
============
Licensed under the GNU AGPL license. See LICENSE_ file for details.

.. _LICENSE: https://github.com/tunfish/pocpoc/blob/master/LICENSE


****************
Acknowledgements
****************

Tunfish would not have been possible without these awesome people:

- Jason Donenfeld for conceiving and building WireGuard_. After reading
  the introduction `[RFC] WireGuard: next generation secure network tunnel`_
  in late 2016 and quickly scanning his `paper about WireGuard`_, nobody
  wondered that WireGuard rapidly gained attraction.

- M. Mahalingam, D. Dutt, K. Duda, P. Agarwal, L. Kreeger, T. Sridhar,
  M. Bursell and C. Wright for conceiving the
  `[RFC 7348] Virtual eXtensible Local Area Network (VXLAN)`_ standard,
  a framework for overlaying virtualized layer 2 networks over layer 3 networks.

- J. Gross, T. Sridhar, P. Garg, C. Wright, I. Ganga, P. Agarwal, K. Duda,
  D. Dutt and J. Hudson for their work on the VXLAN_ successor Geneve_
  per `[draft-ietf-nvo3-geneve-06] Geneve: GEneric NEtwork Virtualization Encapsulation`_.

- The `many authors <http://docs.openvswitch.org/en/latest/internals/authors/>`_
  of `Open vSwitch`_.

- Aaron Brady for his journal article `Making your own private Internet`_,
  which strongly inspired the central idea behind this PoC.
  The `tunfish-join.sh`_ prototype is derived from his `wg-config.bash`_ gist.

- Scott S. Lowe for his `collection of tools and files for learning new technologies`_.
  To be able to easily spin up development and testing environments,
  we used his Vagrant+Ansible recipe `"Open Virtual Network (OVN)" setup`_
  to derive our `sandbox/quickstart` environment from.
  He writes about it at `Learning Environments for OVN`_
  and you might also enjoy reading his `many other articles about Open vSwitch`_.

- Martin Eskdale Moen for his `Ansible role to deploy a wireguard server`_.
  We forked this Ansible_ role to `tunfish.wireguard`_ and added some slight improvements.

- Mitchell Hashimoto, Chris Roberts and the countless other `contributors to Vagrant`_
  for conceiving and maintaining Vagrant_.

- Michael DeHaan, James Cammarata, Toshio Kuratomi, Brian Coca, Matt Clay, Dag Wieers
  and the countless other `contributors to Ansible`_ for conceiving and maintaining Ansible_.

Thank you so much for providing such great infrastructure
components and resources to the community! You know who you are.


*******
Outlook
*******
By replacing the Ansible_ roles through SaltStack_ commands, this might
eventually evolve into a full IaaS_ platform with strong multitenancy capabilities.

See also `Firing events from custom Python scripts`_ and go figure ;].


***************
Troubleshooting
***************
If you encounter any problems during setup, we may humbly
refer you to the `<doc/troubleshooting.rst>`_ documentation.


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

.. _[RFC 7348] Virtual eXtensible Local Area Network (VXLAN): https://tools.ietf.org/html/rfc7348
.. _Geneve: https://www.redhat.com/en/blog/what-geneve
.. _[draft-ietf-nvo3-geneve-06] Geneve\: GEneric NEtwork Virtualization Encapsulation: https://tools.ietf.org/html/draft-ietf-nvo3-geneve-06

.. _Making your own private Internet: https://insom.github.io/journal/2017/04/02/
.. _tunfish-join.sh: https://github.com/tunfish/pocpoc/blob/master/src/tunfish-client/tunfish-join.sh
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

.. _SaltStack: https://saltstack.com/
.. _Firing events from custom Python scripts: https://docs.saltstack.com/en/latest/topics/event/events.html#from-custom-python-scripts
.. _IaaS: https://en.wikipedia.org/wiki/Infrastructure_as_a_service
