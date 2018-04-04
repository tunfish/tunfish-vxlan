#!/bin/bash
#
# Establish virtual layer 2 circuitry through VXLAN.
#
# About
# -----
# This program establishes VXLANs between different hosts, adds them
# to a network bridge device running the Spanning Tree Protocol (STP)
# and configures IPs on the bridge devices.
#
# Spanning tree will mean that we really can just treat these VXLANs
# like cables – connect them all to a core switch, connect them to
# each other, and let STP avoid switching loops.
#
# Starting from Linux 3.12, the VXLAN implementation is quite complete
# as both multicast and unicast are supported as well as IPv6 and IPv4.
#
# Usage
# -----
# ::
#
#     vagrant ssh tf-alice
#     sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh
#
# References
# ----------
# - https://en.wikipedia.org/wiki/Virtual_Extensible_LAN
# - https://www.kernel.org/doc/Documentation/networking/vxlan.txt
# - https://en.wikipedia.org/wiki/Spanning_Tree_Protocol
#
# Acknowledgements
# ----------------
# The general idea and the guts of this recipe have been derived from
# the article "Making your own private Internet" by Aaron Brady, thanks!
#
# See also:
#
# - https://insom.github.io/journal/2017/04/02/
# - https://gist.github.com/insom/f8e259a7bd867cdbebae81c0eaf49776
#

# Stop on first error
set -e


# ===============
# Configuration I
# ===============

# The realm of your Tunfish network. Maximum length is 12 characters.
TUNFISH_REALM="quickstart"

# The member name of the current host. Usually the hostname itself.
TUNFISH_MEMBER_NAME=$(uname -n)

# Yes, we are a real host.
TUNFISH_MEMBER_TYPE="host"

# TODO: Obtain more configuration parameters, especially the
# address mapping applied when adding members to the realm.


# ================
# Configuration II
# ================

# Compute name of bridge device
# Attention: Maximum length of interface name is 15 characters.
# TODO: Limit this as it will cause problems otherwise.
# https://unix.stackexchange.com/questions/195532/linux-choke-on-interface-labels-16-characters-under-fedora-20
TUNFISH_BRIDGE_DEVICE="tb-${TUNFISH_REALM}"

# Adjust bridge forward delay to improve recovery speed (seconds). Default: 15.0
TUNFISH_BRIDGE_FORWARD_DELAY=2

# How long to wait for members joining the realm (seconds)
PROBE_IP_TIMEOUT=15



# ====
# Main
# ====

# Import utility library
here=$(dirname $0)
source ${here}/tunfish-util.sh

# Lift off
echo -e "$(minfo "INFO:  Joining Tunfish realm") $(mvalue ${TUNFISH_REALM})"

msection "INFO:  Loading kernel modules"
modprobe ipv6
modprobe udp_tunnel
modprobe ip6_udp_tunnel


msection "INFO:  Configuring Tunfish network"

echo -e "INFO:  Configuring bridge $(mvalue ${TUNFISH_BRIDGE_DEVICE})"
if ! brctl show | grep $TUNFISH_BRIDGE_DEVICE >>/dev/null 2>&1; then
    brctl addbr $TUNFISH_BRIDGE_DEVICE
fi

# Turn on STP
echo -e "INFO:  Turning on Spanning Tree Protocol (STP)"
brctl stp $TUNFISH_BRIDGE_DEVICE on

# Adjust forward delay to improve recovery speed. Default: 15.0
echo -e "INFO:  Adjusting forward delay to improve recovery speed"
brctl setfd $TUNFISH_BRIDGE_DEVICE $TUNFISH_BRIDGE_FORWARD_DELAY

# TODO: Also adjust ageing time? Default: 300.0
#brctl setageing $TUNFISH_BRIDGE_DEVICE $TUNFISH_BRIDGE_AGEING_TIME


echo -e "INFO:  Configuring member $(mvalue ${TUNFISH_MEMBER_NAME}), type=$TUNFISH_MEMBER_TYPE"
ip_self=()
ip_other=()
case $TUNFISH_MEMBER_NAME in

    tf-alice)

        # TODO: As there is no "replace" command for "ip link",
        # wrap into "link_exists" / "purge_links" helpers.

        # Associate private address with bridge device
        ip addr replace 10.10.20.51/24 dev $TUNFISH_BRIDGE_DEVICE

        # Add VXLAN links to designated peers
        if ip link show tn-bob >>/dev/null 2>&1; then
            ip link del tn-bob
        fi
        # Note: The "id" parameter is the VXLAN Network Identifier (VNI).
        ip link add tn-bob   type vxlan remote 10.10.10.52 id 1 dstport 4789

        # Bookkeeping
        ip_self+=(10.10.20.51)
        ip_other+=(10.10.20.52)

        #ip link add vorke   type vxlan remote 10.88.88.3 id 1 dstport 4789
        #ip link add bob     type vxlan remote 10.88.88.1 id 2 dstport 4789
        #ip link add rho     type vxlan remote 10.88.88.2 id 4 dstport 4789
    ;;

    tf-bob)

        # TODO: As there is no "replace" command for "ip link",
        # wrap into "link_exists" / "purge_links" helpers.

        # Associate private address with bridge device
        ip addr replace 10.10.20.52/24 dev $TUNFISH_BRIDGE_DEVICE

        # Add VXLAN links to designated peers
        if ip link show tn-alice >>/dev/null 2>&1; then
            ip link del tn-alice
        fi
        # Note: The "id" parameter is the VXLAN Network Identifier (VNI).
        ip link add tn-alice   type vxlan remote 10.10.10.51 id 1 dstport 4789

        # Bookkeeping
        ip_self+=(10.10.20.52)
        ip_other+=(10.10.20.51)

        #ip link add bob     type vxlan remote 10.88.88.1 id 3 dstport 4789
        #ip link add epsilon type vxlan remote 10.88.88.4 id 1 dstport 4789
        #ip link add rho     type vxlan remote 10.88.88.2 id 5 dstport 4789
    ;;
esac

msection "INFO:  Bringing up networking"
ip link set up dev $TUNFISH_BRIDGE_DEVICE
for link in tn-alice tn-bob; do
    if ip link show $link >>/dev/null 2>&1; then
        ip link set up $link
        brctl addif $TUNFISH_BRIDGE_DEVICE $link
        ethtool -K $link tx off >>/dev/null 2>&1
    fi
done

# Signal success
msuccess "INFO:  The Tunfish network is ready"
echo


# Monitor list if IP addresses until becoming reachable
msection "INFO:  Waiting for realm to materialize"
probe_members_ip "${ip_self[@]}" "${ip_other[@]}"

#msection "INFO:  Network information"
#ip link show $TUNFISH_BRIDGE_DEVICE
#brctl showstp $TUNFISH_BRIDGE_DEVICE | grep flags
