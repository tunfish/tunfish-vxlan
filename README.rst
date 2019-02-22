.. image:: https://img.shields.io/github/tag/tunfish/tunfish-sandbox.svg
    :target: https://github.com/tunfish/tunfish-sandbox
.. image:: https://img.shields.io/badge/platform-Linux%20%7C%20OpenWRT%20%7C%20LEDE-blue.svg
    :target: #
.. image:: https://img.shields.io/badge/technologies-WireGuard%20%7C%20Netlink%20%7C%20AMQP%20%7C%20Websocket-blue.svg
    :target: #

|

.. image:: https://ptrace.tunfish.org/thunfisch-160.jpg
    :target: #


###############
Tunfish Sandbox
###############

*****
About
*****
A proof-of-concept for creating convenient VPN environments
on top of secure WireGuard_ tunnels.

This runbook will guide you through the process of setting
up an appropriate testbed environment. It will provision
a number of Vagrant machines and configure them to talk
to each other over a software-defined secure private network.

After that, you will easily be able to conduct connectivity
tests and continue with further experiments.


*****
Setup
*****
This section will guide you through setting up
a development/testing sandbox on your machine.

Acquire source repository::

    git clone https://github.com/tunfish/tunfish-sandbox

Install requirements on Mac OS X using Homebrew::

    ./requirements-macosx.sh

Make Vagrant provision and spin up all machines configured in this environment::

    vagrant up


**************
Network layout
**************
There are three machines ``"tf-portier"``, ``"tf-gateway-1"`` and
``"tf-client-1"``, completely provisioned by Vagrant.

Here is a short overview as an introduction.
Please read this section carefully.


Machines
========
The Vagrant network "192.168.50.0/24".
::

    192.168.50.1        The hypervisor host on its "vboxnet0" interface
    192.168.50.70       Portier server
    192.168.50.71       Gateway server 1
    192.168.50.80       Client 1


*****
Usage
*****

Login to each virtual machine::

    vagrant ssh tf-portier
    vagrant ssh tf-gateway-1
    vagrant ssh tf-client-1


***********
Development
***********
To repeat the virtual machine provisioning, run::

    vagrant up --provision

To reprovision just a single host, use::

    vagrant up --provision tf-portier

The source code directory ``./src`` will be mounted into each
virtual machine at ``/opt/tunfish-sandbox`` for convenient live
editing.


*******************
Project information
*******************

About
=====
The "Tunfish sandbox" spike is released under the GNU AGPL license.
Its source code lives on `GitHub <https://github.com/tunfish/tunfish-sandbox>`_.
You might also want to have a look at the `documentation <https://tunfish.org/doc/sandbox/>`_.

If you'd like to contribute you're most welcome!
Spend some time taking a look around, locate a bug, design issue or
spelling mistake and then send us a pull request or create an issue.

Thanks in advance for your efforts, we really appreciate any help or feedback.

License
=======
Licensed under the GNU AGPL license. See LICENSE_ file for details.

.. _LICENSE: https://github.com/tunfish/tunfish-sandbox/blob/master/LICENSE



****************
Acknowledgements
****************

Tunfish would not have been possible without these awesome people:

- Jason Donenfeld for conceiving and building WireGuard_. After reading
  the introduction `[RFC] WireGuard: next generation secure network tunnel`_
  in late 2016 and quickly scanning his `paper about WireGuard`_, nobody
  wondered that WireGuard rapidly gained attraction.

- Mitchell Hashimoto, Chris Roberts and the countless other `contributors to Vagrant`_
  for conceiving and maintaining Vagrant_.

- Michael DeHaan, James Cammarata, Toshio Kuratomi, Brian Coca, Matt Clay, Dag Wieers
  and the countless other `contributors to Ansible`_ for conceiving and maintaining Ansible_.

- Countless other authors of packages from the Python
  ecosystem and beyond for gluing everything together.

Thank you so much for providing such great infrastructure
components and resources to the community! You know who you are.


***************
Troubleshooting
***************
If you encounter any problems during setup, we may humbly
refer you to the `<doc/troubleshooting.rst>`_ documentation.


----

Have fun!


.. _WireGuard: https://www.wireguard.com/

.. _[RFC] WireGuard\: next generation secure network tunnel: https://lkml.org/lkml/2016/6/28/629
.. _paper about WireGuard: https://www.wireguard.com/papers/wireguard.pdf

.. _Ansible role to deploy a wireguard server: https://github.com/botto/ansible-wireguard
.. _Vagrant: https://www.vagrantup.com/
.. _Ansible: https://www.ansible.com/
.. _contributors to Vagrant: https://github.com/hashicorp/vagrant/graphs/contributors
.. _contributors to Ansible: https://github.com/ansible/ansible/graphs/contributors
