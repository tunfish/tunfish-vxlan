######################
Tunfish pocpoc runbook
######################


*****
About
*****
A SDN_ proof-of-concept for approaching convenient VXLAN_
Layer 2/3 convergence on top of secure WireGuard_ tunnels.


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
Let the nodes join the shared Tunfish network::

	vagrant ssh tf-alice
	sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh

	vagrant ssh tf-bob
	sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh


****************
Acknowledgements
****************
- Aaron Brady for his journal article `Making your own private Internet`__,
  which strongly inspired this PoC.
  We derived our `tunfish-join.sh` prototype from his `wg-config.bash gist`__.

- Scott S. Lowe for his `collection of tools and files for learning new technologies`__.
  To be able to easily spin up development and testing environments,
  we used his `"Open Virtual Network (OVN)" setup`__
  to derive our `sandbox/quickstart` environment from.
  You might also enjoy reading his blog article `Learning Environments for OVN`__.


.. _SDN: https://en.wikipedia.org/wiki/Software-defined_networking
.. _VXLAN: https://en.wikipedia.org/wiki/Virtual_Extensible_LAN
.. _WireGuard: https://www.wireguard.com/
.. _Making your own private Internet: https://insom.github.io/journal/2017/04/02/
.. _wg-config.bash: https://gist.github.com/insom/f8e259a7bd867cdbebae81c0eaf49776
.. _"Open Virtual Network (OVN)" setup: https://github.com/lowescott/learning-tools/tree/master/ovs-ovn/ovn
.. _Learning Environments for OVN: https://blog.scottlowe.org/2016/12/07/learning-environments-ovn/
.. _collection of tools and files for learning new technologies: https://github.com/lowescott/learning-tools
