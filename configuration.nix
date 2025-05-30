{ config, pkgs, ... }:

{

# Base NIXOS system config
# Version: 1.1

  # Metadata 
  # Set system state version
  system.stateVersion = "25.05";

  # Imports
  imports =
    [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Framework Workstation
      ./configuration-framework-workstation.nix

      # Networking hostfile
      ./hosts.nix
    ];

  boot = {
    loader= {
      grub = {
       enable = true;
       device = "nodev";
       efiSupport = true;
       useOSProber = true; # Multi OS detection
       configurationLimit = 5; # Set maximum config to be kept
      };
      # Dual boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 0; # Time waiting in grub for user  
    };

    initrd = {
      availableKernelModules = [ "usb_storage" "sd_mod" "sr_mod" ]; # Load USB, SCSI disk support, SCSI CD-rom support
      verbose = false;
      systemd.enable = true;
    };
   
    # Set console loglevel to 0 - Default = 4 
    consoleLogLevel = 0;

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest; # Always get latest linux kernel
    kernelParams = [
      # Boot behavior and verbosity settings
      "quiet"
      "rd.systemd.show_status=false"  # Suppress systemd status messages during boot

      # System debugging and logging
      "rd.udev.log_level=3"           # Set udev logging level
      "udev.log_priority=3"           # Set udev log priority
    ];

    kernel.sysctl."vm.max_map_count" = "2097152"; # Set kernel vm map count higher

    supportedFilesystems = ["ntfs"]; # Support NTFS
    extraModulePackages = [ ];
  };

  networking = {
    enableIPv6 = false;
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
    firewall = {
      enable = true;
      checkReversePath = false;
      allowedTCPPorts = [ ]; 
    };
    nameservers = [ "1.1.1.1" "1.0.0.1"];
  };

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # locales
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # Default TTY console settings
  console = {
    keyMap = "us";
  };

  # Add additional man pages 
  documentation.dev.enable = true;

  # Virtualisation modules
  virtualisation = {
    libvirtd.enable = false;
  };

 # Services
  services = {
    dbus.enable = true; # Bus coms
    thermald.enable = true; # Thermals regulation
    power-profiles-daemon.enable = true;

    # ssh
    openssh = {
      enable = false;
      settings = {
        #kexAlgorithms = [ "curve25519-sha256" ];
        #ciphers = [ "chacha20-poly1305@openssh.com" ];
        #passwordAuthentication = false;
        #permitRootLogin = "no"; # do not allow to login as root user
        #kbdInteractiveAuthentication = false;
      };
    };
   
    # DNS Daemon
    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1" "1.0.0.1"];
      extraConfig = "DNSOverTLS=yes";
    };
  };

  # Program modules and settings
  programs = {
  };

  # Nix.PKGs extra config
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment = {
   variables = {
    LANG = "en_US.UTF-8";
   };

   systemPackages = with pkgs; [
   
   ];
  };

  # Fonts
  fonts.packages = with pkgs; [

  ];
}
