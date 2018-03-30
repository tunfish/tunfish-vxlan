#########################
Tunfish node provisioning
#########################

The Ansible playbook for provisioning a Tunfish node.

- main.yml: The main entrypoint
- openvswitch.yml: Setup Open vSwitch
- wireguard.yml: Setup and configure WireGuard
- requirements.yml: Required 3rd-party roles


.. note::

    The guts of this recipe have been derived from the
    "Open Virtual Network (OVN)" setup by Scott S. Lowe, thanks!

    See also:

    - https://blog.scottlowe.org/2016/12/07/learning-environments-ovn/
    - https://github.com/lowescott/learning-tools/tree/master/ovs-ovn/ovn
