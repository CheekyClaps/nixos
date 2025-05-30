{ config, pkgs, ... }:

{
networking = {
  stevenblack = {
      enable = false;
      #block = [ "fakenews" "gambling" "porn" "social" ];
    };
  extraHosts = ''
    127.0.0.1 localhost
    192.168.1.3 unifi.local
    192.168.1.10 proxmox.local
  '';
  };
}
