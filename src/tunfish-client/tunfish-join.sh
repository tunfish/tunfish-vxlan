#!/bin/bash
#
# The guts of this recipe have been derived from the
# "Making your own private Internet" article by Aaron Brady, thanks!
#
# See also:
#
# - https://insom.github.io/journal/2017/04/02/
# - https://gist.github.com/insom/f8e259a7bd867cdbebae81c0eaf49776
#
# Usage::
#
#     vagrant ssh tf-alice
#     sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh


# =============
# Configuration
# =============
# Attention: Maximum length of interface name is 15 characters.
# https://unix.stackexchange.com/questions/195532/linux-choke-on-interface-labels-16-characters-under-fedora-20
TUNFISH_NETWORK="quickstart"
TUNFISH_BRIDGE="tb-${TUNFISH_NETWORK}"
WIREGUARD_DEV="wg0-server"
TUNFISH_NODENAME=$(uname -n)
TUNFISH_NODETYPE="host"


# ====
# Main
# ====

echo "INFO:  Joining Tunfish network '$TUNFISH_NETWORK'"

echo "INFO:  Loading kernel modules"
modprobe ipv6
modprobe udp_tunnel
modprobe ip6_udp_tunnel

echo "INFO:  Configuring WireGuard interfaces"
echo "INFO:  Remark: This work has already been performed by Ansible role 'tunfish.wireguard'"
#wg showconf $WIREGUARD_DEV; echo

echo "INFO:  Configuring Tunfish bridge '$TUNFISH_BRIDGE'"
if ! brctl show | grep $TUNFISH_BRIDGE >>/dev/null 2>&1; then
    brctl addbr $TUNFISH_BRIDGE
fi

# Turn on STP
brctl stp $TUNFISH_BRIDGE on

# Lower bridge forward delay to improve recovery speed
brctl setfd $TUNFISH_BRIDGE 2


echo "INFO:  Configuring Tunfish node '$TUNFISH_NODENAME', type=$TUNFISH_NODETYPE"
case $TUNFISH_NODENAME in
    tf-alice)
        ip addr replace 10.10.20.51/24 dev $TUNFISH_BRIDGE
        # TODO: As there is no "replace", Wrap into "link_exists" / "purge_links" helpers
        ip link del tn-bob   type vxlan remote 10.10.10.52 id 1 dstport 4789
        ip link add tn-bob   type vxlan remote 10.10.10.52 id 1 dstport 4789

        #ip link add vorke   type vxlan remote 10.88.88.3 id 1 dstport 4789
        #ip link add bob     type vxlan remote 10.88.88.1 id 2 dstport 4789
        #ip link add rho     type vxlan remote 10.88.88.2 id 4 dstport 4789
    ;;
    tf-bob)
        ip addr replace 10.10.20.52/24 dev $TUNFISH_BRIDGE
        # TODO: As there is no "replace", Wrap into "link_exists" / "purge_links" helpers
        ip link del tn-alice   type vxlan remote 10.10.10.51 id 1 dstport 4789
        ip link add tn-alice   type vxlan remote 10.10.10.51 id 1 dstport 4789

        #ip link add bob     type vxlan remote 10.88.88.1 id 3 dstport 4789
        #ip link add epsilon type vxlan remote 10.88.88.4 id 1 dstport 4789
        #ip link add rho     type vxlan remote 10.88.88.2 id 5 dstport 4789
    ;;
esac

echo "INFO:  Bringing up Tunfish network"
ip link set up dev $TUNFISH_BRIDGE
for link in tn-alice tn-bob; do
    if ip link show $link >>/dev/null 2>&1; then
        ip link set up $link
        brctl addif $TUNFISH_BRIDGE $link
        ethtool -K $link tx off >>/dev/null 2>&1
    fi
done
