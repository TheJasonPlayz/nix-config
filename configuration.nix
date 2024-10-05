{ config, lib, pkgs, options, ... }:
let 
  theme = import ./theme.nix;
in 
{
  /* Nix */ 
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    settings.trusted-users = [ "jasonw" ];
  };
  system.stateVersion = "24.05";

  /* General */

  environment.systemPackages = with pkgs; [
    nixFlakes
    git
    sbctl
    xorg.xf86videoamdgpu
    clinfo
  ];
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  time.hardwareClockInLocalTime = true;

  location.provider = "geoclue2";

  programs.fish.enable = true;

  /* Boot */

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

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
  users.users.jasonw = {
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
    home = "/home/jasonw";
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
    useDHCP = lib.mkDefault true;
  };

  /* Sound */
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    daemon.config = { flat-volumes = "no"; };
    package = pkgs.pulseaudioFull;
  };

  /* Bluetooth */
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.blueman ];
  
  /* UI */
  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      greeters.slick.enable = true;
    };
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
      ];
    };
    xkb.options = "compose:caps";
    videoDrivers = [ "amdgpu" ];
  };

  hardware.amdgpu = {
    amdvlk.enable = true;
    initrd.enable = true;
  };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
    driSupport32Bit = lib.mkForce true;
  };

  programs.light.enable = true;

  services.redshift = {
    enable = true;
  };

  /* Peripherals */
  services.libinput.enable = true;


  /* Fonts */
  fonts = {
    fontDir.enable = true;
    packages = with pkgs;[
      terminus_font
      source-code-pro
      source-sans-pro
      source-serif-pro
      font-awesome
      jetbrains-mono
    ];
  };

  /* File Systems */

  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/c0172953-b8cc-49bf-aa74-10b9189c0f96";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/42F7-2143";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ 
    { device = "/dev/disk/by-uuid/c2b18e39-f26c-420c-b42f-654095b6a201"; }
  ];
}
