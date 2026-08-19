# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

# =====================================
#	ONLY IF YOU ARE RUNNING FROM VM
# =====================================
services.spice-vdagentd.enable = true;


# ==================================
#	Thunar
# ==================================
programs.thunar.enable = true;
programs.xfconf.enable = true; 


# =================================
#	XSERVER / i3
# =================================
  services.xserver.enable = true;

#Configure keymap in X11 
   services.xserver.xkb = {
    layout = "latam";
    variant = "";
   };

#LightDM
  services.xserver.displayManager.lightdm.enable = true;
  
#i3
  services.xserver.windowManager.i3 = {
	enable = true;
	extraPackages = with pkgs; [
		rofi
		i3status
		i3lock
	];
  };
# ===================================================================================
#	NIRI AND WAYLAND
# ===================================================================================
#programs.niri.enable = true;

#services.xserver.xkb = {
#	layout = "latam";
#	variant = "";
#};

#services.displayManager.sddm.enable = true;
#services.displayManager.sddm.wayland.enable = true;

# ===================================================================================

# Configure console keymap
  console.keyMap = "la-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."syne" = {
    isNormalUser = true;
    description = "syne";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


# =============================================================================================
#  PKGS
# --List packages installed. To search, run:
# $ nix search wget
# =============================================================================================

  environment.systemPackages = with pkgs; [
    vim 
    wget
    fastfetch
    neovim
    alacritty
    git
    firefox
    picom
    feh
    xdg-user-dirs	
    arc-theme
    lxappearance
    xfce.xfce4-panel
    xfce.xfce4-whiskermenu-plugin
  ];
# ==========================================================================================
#	ALIASES
# ==========================================================================================
  environment.shellAliases = {
	NRS = "sudo nixos-rebuild switch";
  };
# ==========================================================================================

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  # ========================================================================================
  #	FONTS (La ia me dijo que la pusiera aqui)
  # ========================================================================================
   fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
   ];	

  system.stateVersion = "26.05"; # Did you read the comment?

}
