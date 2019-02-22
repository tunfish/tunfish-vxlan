#########################
Tunfish Sandbox Changelog
#########################

development
===========
- Add basic websocket server based on OpenResty
- Add basic Tunfish client ``tunctl.{lua,py}``
- Put Tunfish VXLAN aside

2018-05-11 0.2.0
================
- Add `tunfish-join.sh` program to establish virtual layer 2 circuitry through VXLAN
- Add IP connectivity probing after network setup. Improve console output.
- Rename "sandbox" directory to "environment"
- Naming things. Polishing. Refactoring. Documentation.
- Add basic service discovery example based on python-zeroconf
- Add OpenResty to Ubuntu Vagrant boxes

2018-03-30 0.1.0
================
- Add README
- Add Vagrant environment for tunfish-vxlan
- Properly setup and configure WireGuard
- Add Makefile with documentation builder targets
