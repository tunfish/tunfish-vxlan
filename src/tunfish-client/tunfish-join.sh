#!/bin/bash
#
# tunfish-join.sh
# Establish virtual layer 2 circuitry through VXLAN.
#
# Usage
# -----
# ::
#
#     vagrant ssh tf-alice
#     sudo /opt/quickstart-dev/tunfish-client/tunfish-join.sh
#
#
# Acknowledgements
# ----------------
# The guts of this recipe have been derived from the
# "Making your own private Internet" article by Aaron Brady, thanks!
#
# See also:
#
# - https://insom.github.io/journal/2017/04/02/
# - https://gist.github.com/insom/f8e259a7bd867cdbebae81c0eaf49776
#

# Stop on first error
set -e

# =============
# Configuration
# =============
WIREGUARD_DEV="wg0-server"
TUNFISH_NETWORK="quickstart"
TUNFISH_MEMBER_NAME=$(uname -n)
TUNFISH_MEMBER_TYPE="host"
TUNFISH_BRIDGE_FORWARD_DELAY=2
PROBE_IP_TIMEOUT=5

# TODO: Obtain more configuration parameters

# Attention: Maximum length of interface name is 15 characters.
# https://unix.stackexchange.com/questions/195532/linux-choke-on-interface-labels-16-characters-under-fedora-20
TUNFISH_BRIDGE_DEVICE="tb-${TUNFISH_NETWORK}"


# ====
# Main
# ====

# Import utility library
here=$(dirname $0)
source ${here}/tunfish-util.sh

echo -e "$(minfo "INFO:  Joining Tunfish network") $(mvalue ${TUNFISH_NETWORK})"

msection "INFO:  Loading kernel modules"
modprobe ipv6
modprobe udp_tunnel
modprobe ip6_udp_tunnel

msection "INFO:  Configuring WireGuard interfaces"
echo "INFO:  Remark: These steps have already been performed by Ansible role tunfish.wireguard"
#wg showconf $WIREGUARD_DEV; echo


msection "INFO:  Configuring Tunfish network"

echo -e "INFO:  Configuring bridge $(mvalue ${TUNFISH_BRIDGE_DEVICE})"
if ! brctl show | grep $TUNFISH_BRIDGE_DEVICE >>/dev/null 2>&1; then
    brctl addbr $TUNFISH_BRIDGE_DEVICE
fi

# Turn on STP
brctl stp $TUNFISH_BRIDGE_DEVICE on

# Lower bridge forward delay to improve recovery speed
brctl setfd $TUNFISH_BRIDGE_DEVICE $TUNFISH_BRIDGE_FORWARD_DELAY


echo -e "INFO:  Configuring member $(mvalue ${TUNFISH_MEMBER_NAME}), type=$TUNFISH_MEMBER_TYPE"
ip_self=()
ip_other=()
case $TUNFISH_MEMBER_NAME in
    tf-alice)
        ip addr replace 10.10.20.51/24 dev $TUNFISH_BRIDGE_DEVICE
        # TODO: As there is no "replace", Wrap into "link_exists" / "purge_links" helpers
        ip link del tn-bob   type vxlan remote 10.10.10.52 id 1 dstport 4789
        ip link add tn-bob   type vxlan remote 10.10.10.52 id 1 dstport 4789

        ip_self+=(10.10.20.51)
        ip_other+=(10.10.20.52)


        #ip link add vorke   type vxlan remote 10.88.88.3 id 1 dstport 4789
        #ip link add bob     type vxlan remote 10.88.88.1 id 2 dstport 4789
        #ip link add rho     type vxlan remote 10.88.88.2 id 4 dstport 4789
    ;;
    tf-bob)
        ip addr replace 10.10.20.52/24 dev $TUNFISH_BRIDGE_DEVICE
        # TODO: As there is no "replace", Wrap into "link_exists" / "purge_links" helpers
        ip link del tn-alice   type vxlan remote 10.10.10.51 id 1 dstport 4789
        ip link add tn-alice   type vxlan remote 10.10.10.51 id 1 dstport 4789

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

# Monitor list if IP addresses until becoming reachable
probe_members_ip ${ip_self[@]} ${ip_other[@]}
