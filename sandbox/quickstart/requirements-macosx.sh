#!/bin/sh

echo
echo "INFO:  Installing all requirements for Tunfish sandbox on Mac OS X using Homebrew"
echo

# Install Homebrew-Cask for installing VirtualBox and Vagrant
echo "INFO:  Installing Homebrew-Cask"
brew tap caskroom/cask

# Install VirtualBox as hypervisor
echo "INFO:  Installing VirtualBox"
brew cask install virtualbox

# Install Vagrant for virtual machine provisioning
echo "INFO:  Installing Vagrant"
echo "INFO:  You might want to choose 'virtualbox' when being asked for a provider"
brew cask install vagrant

# Install Ansible for application infrastructure provisioning
echo "INFO:  Installing Ansible"
brew install ansible

# Acquire Linux distribution image
echo "INFO:  Downloading VirtualBox OS image 'Ubuntu 16.04 (Bento)'"
[[ ! "$(vagrant box list)" =~ "bento/ubuntu-16.04" ]] && vagrant box add "bento/ubuntu-16.04" --provider virtualbox
