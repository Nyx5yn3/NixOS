{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./security.nix
    ];

  # Bootloader.
    boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = true;
  
    # resolución compatible con KVM
    gfxmodeBios = "1024x768";
  
    theme = "${pkgs.minimal-grub-theme}";
  
    configurationLimit = 50;
  };

  networking.hostName = "nixos"; 
  # networking.wireless.enable = true; 
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #Enable networking
  networking.networkmanager.enable = true;

  #Time zone.
  time.timeZone = "America/Caracas";

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

# =================================
#	XSERVER / i3
# =================================
  services.xserver.enable = true;

#Configure keymap in X11 
   services.xserver.xkb = {
    layout = "latam";
    variant = "";
   };
######################
#   LY and Console 
#####################

  console = {
	font = "Lat2-Terminus16"; 
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animate = true;
      animation = "1"; #matrix rain, might delete later
      box_title = " Welcome back Syne "; 
      hide_borders = false;        
      clear_password = true;       
    };
  };


########
#i3
########
  services.xserver.windowManager.i3 = {
	enable = true;
	extraPackages = with pkgs; [
		rofi
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

# ==========================
#	HOME MANAGER
# ==========================
home-manager.users."syne" = import ./home.nix;

# =============================================================================================
#  PKGS
# --List packages installed. To search, run:
# $ nix search wget
# =============================================================================================

  environment.systemPackages = with pkgs; [ 
    wget
    fastfetch
    alacritty
    git
    firefox
    picom
    feh
    xdg-user-dirs	
    arc-theme
    lxappearance
    btop
    autotiling
  ];
# ==========================================================================================
#	ALIASES
# ==========================================================================================
  environment.shellAliases = {
	NRS = "sudo nixos-rebuild switch";
	clean = "sudo nix-collect-garbage -d";
	neofetch = "fastfetch";
    snvim = "sudo -E nvim";
  };
# ==========================================================================================

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # ========================================================================================
  #	FONTS 
  # ========================================================================================
   fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
   ];	

  system.stateVersion = "26.05"; #I didnt read the comment
}
