# homelab-server

This ansible repo is in charge to perform the initial configuration of my homelab server.

It will execute following operations :

* Check if the Operating System and the ansible version is supported by the setup
* Install my survival kit 
  * Vim
  * Midnight Commander
  * TMux
  * ...
* Ensure that the local setting, timezone, hostname is correctly set
* Install the latest Dotnet SDK 
  * Dotnet core 3.1 
  * Dotnet 5
* Install the visual studio code
* Install the Google Chrome browser
* Install the AMDGPU driver
* Install the KVM/libvirt and configure it by
  * Removing the default network
  * Installing a host-bridge network

The execution is done using the script run.sh
