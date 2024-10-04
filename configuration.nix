{ config, lib, pkgs, options, ... }:
let 
  theme = import ./theme.nix;
in 
{
  /* Nix */ 
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      builders-use-substitutes = true
    '';
  };
  nix.trustedUsers = [ "jasonw" ];

  /* General */

  environment.systemPackages = with pkgs; [
    nixFlakes
    git
    sbctl
  ];

  time.hardwareClockInLocalTime = true;

  /* Boot */

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  /*boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };*/

  /* Security */

  services.openssh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };
  users.users.jason = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "lp"
      "video"
      "audio"
      "libvirtd"
      "kvm"
      "bluetooth"
    ];
    createHome = true;
    home = "/home/jason";
  };

  /* Shell */
  users.defaultUserShell = pkgs.fish;
  environment.pathsToLink = [ "/share/zsh" "/share/fish" ];
  #environment.variables.EDITOR = "${pkgs.vscode}"
  environment.etc."/fish/config.fish".text = '';
  
  '';

  /* Networking */
  networking = {
    hostName = "JASONS_COMPUTER";
    networkmanager.enable = true;
    iproute2.enable = true;
  };

  /* Sound */
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    daemon.config = { flat-volumes = "no"; };
  };

  /* Bluetooth */
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.doconf.enable = true;
  services.dbus.packages = [ pkgs.blueman ];
  hardware.pulseAudio = {
    extraModules = [ pokgs.pulseaudio-modules-bt ];
    package = pks.pulseaudioFull;
  };
  
  /* UI */
  services.xserver = {
    enable = true;
    services.xserver = {
      displayManager.lightdm = {
        greeters.slick.enable = true;
      };
      windowManager.qtile = {
        enable = true;
        extraPackages = python3Packages: withPython3Packages; [
          qtile-extras
        ]
      };
      videoDrivers = [
        "amdgpu"
      ]
    };
  };

  hardware.amdgpu = {
    initrd.enable = true;
    amdvlk.enable = true;
  };

  programs.light.enable = true;

  services.redshift = {
    enable = true;
  }

  /* Peripherals */
  services.xserver.xkbOptions = "compose:caps";
  services.xserver.libinput.enable = true;

  /* Fonts */
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs;[
      corefont
      terminus_font
      source-code-pro
      source-sans-pro
      source-serif-pro
      font-awesome
      jetbrains-mono
    ];
  };
}