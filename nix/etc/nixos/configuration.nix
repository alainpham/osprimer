{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "nxvm"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "LatArCyrHeb-16";
    keyMap = "fr";
  };

  users.groups.apham = { };

  users.users.apham = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=50M
    SystemMaxFileSize=10M
  '';
  
  services.openssh.enable = true;

  services.spice-vdagentd.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager.startx.enable = true;
    windowManager.dwm.enable = true;
  };

  # essentials
  programs.git.enable = true;
  programs.tmux.enable = true;
  programs.vim.enable = true;
  programs.neovim.enable = true;
  programs.htop.enable = true;
  programs.gnupg.agent.enable = true;
  
  environment.systemPackages = with pkgs; [
    # essentials

    curl
    wget
    ncdu
    dnsutils
    bmon
    btop
    zip
    unzip
    virt-what
    wireguard-tools
    jq
    jc
    sshfs
    iotop
    wakeonlan
    cloud-utils
    iperf


    # Dev environment
    ansible
    nodejs_24
    go
    maven

    # kube
    k3s_1_33
    k9s
    kubernetes-helm

    # GUI applications
    st
  ];

  # Dev environment
  programs.java.enable = true;
  programs.java.package = pkgs.jdk17_headless;


  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.extraPackages = with pkgs; [
    docker-compose docker-buildx skopeo 
  ];

  # GUI applications

  systemd.services.numLockOnTty = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # /run/current-system/sw/bin/setleds -D +num < "$tty";
      ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
        for tty in /dev/tty{1..6}; do
            ${pkgs.kbd}/bin/setleds -D +num < "$tty";
        done
      '');
    };
  };

  system.stateVersion = "25.05";

}

