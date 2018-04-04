####################
Tunfish Sandbox Todo
####################

- [o] Gateway from private network to internet
    - https://github.com/xcellardoor/wireguard-simple-vpn-config
    - https://www.ckn.io/blog/2017/11/14/wireguard-vpn-typical-setup/
    - https://dcamero.azurewebsites.net/wireguard.html
- [o] Look what the Freifunk people are doing with Batman and GRE tunnels
- [o] Merge functionality of https://github.com/botto/ansible-wireguard and https://github.com/le9i0nx/ansible-wireguard
- [o] Investigate isolation using network namespaces, VLAN tags and VNIs
    - https://www.wireguard.com/netns/
- [o] Document the fact that Geneve is the successor of VXLAN
- [o] Have a look at https://github.com/ccollicutt/ansible_playbooks/tree/master/sdn
- [o] Add Makefile. i.e. spin up like "make quickstart"
- [o] Make ansible-wireguard even more flexible
- [o] Helper for purging all "tb-" and "tn-" network links
- [o] Test setup on a virtual OpenWRT/LEDE machine
      https://openwrt.org/docs/guide-developer/test-virtual-image-using-armvirt
- [o] We need better data management in tunfish-join.sh
- [o] Improve docs "Network layout"
- [o] Make https://tunfish.org/doc/sandbox.html from sandbox/README.rst
- [o] Install shortcut to "tunfish-join" command
- [o] Let "tunfish-join" fetch its realm information from the backend
- [o] Improve credits: Linux Kernel + Networking, VXLAN
- [o] Introduce "libtunfish" (Bash)
- [o] Introduce "tunfish-info" program
- [o] What is a Tunfish Realm?
      Think of network namespaces, but interconnected between different hosts
      and secured on the wire using WireGuard. By default, Tunfish Realms are
      isolated from each other but can be connected with each other on demand.
- [o] Performance measurements
- [o] Describe encapsulation layers in detail: An Ethernet frame sent across
      Layer 2/3 convergence boundaries will get encapsulated into VXLAN
      IP/UDP packets destined to port 4789. These will be picked up by
      WireGuard, in turn using a IP/UDP tunnel to a single port 51820
      over the regular upstream link (which in turn might be defined by SDN ;]).
- [o] Will it be possible to run something like a collaborative Little Snitch as a service
      protecting the data link to/from the internets?
- [o] Avatar image for https://github.com/tunfish
- [o] Adjust documentation target path => "sandbox" subdirectory!
- [o] Ethernet or even lower Data Link Layer frames
      using "Franz jagt im komplett verwahrlosten Taxi quer durch Bayern.". Small and large ones.
- [o] Use "ip" and "iproute2" commands instead of "brctl", as the latter is becoming deprecated

    - https://sgros-students.blogspot.de/2013/11/comparison-of-brctl-and-bridge-commands.html
    - https://unix.stackexchange.com/questions/255484/how-can-i-bridge-two-interfaces-with-ip-iproute2
    - https://github.com/ebiken/doc-network/wiki/Linux-iproute2-:-ip-link-bridge-operations
    - http://bashusr.com/wordpress/
    - https://github.com/Gandi/bridge-utils/tree/trill/libbridge
- [o] *Trusted* networks
- [o] Docs: Introduce "Goal"
- [o] Hook "tunfish-join" into if-up.d of wg0-server
- [o] By replacing the Ansible_ roles through SaltStack_ commands, this might
      eventually evolve into a full IaaS_ platform with strong multitenancy capabilities.
      See also `Firing events from custom Python scripts`_ and go figure ;].


.. _Ansible: https://www.ansible.com/
.. _SaltStack: https://saltstack.com/
.. _Firing events from custom Python scripts: https://docs.saltstack.com/en/latest/topics/event/events.html#from-custom-python-scripts
.. _IaaS: https://en.wikipedia.org/wiki/Infrastructure_as_a_service
