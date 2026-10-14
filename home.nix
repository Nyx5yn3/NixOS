{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
    ripgrep
    fd
    imv
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
	tokyonight-nvim
	plenary-nvim
	telescope-nvim

	(nvim-treesitter.withPlugins (p: [
	p.c p.lua p.vim p.vimdoc p.bash p.python p.nix p.query
	]))
    ];
    
    extraLuaConfig = ''
	-- Options
	vim.g.mapleader        = " "
	vim.opt.number 	       = true
	vim.opt.relativenumber = true
	vim.opt.cursorline     = true
	vim.opt.shiftwidth     = 4
	vim.opt.tabstop        = 4
	vim.opt.expandtab      = true
	vim.opt.termguicolors  = true
	
	--Tokyo Night
	vim.cmd([[colorscheme tokyonight-night]])

	--Telescope
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

	--TreeSitter
	require('nvim-treesitter').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    '';
  };

    #Yazi
    programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./tokyo-night.toml);
  };

  programs.bash = {
    enable = true;
  };
  
# ============================
#   i3  
# ============================
xsession.windowManager.i3 = {
enable = true;

config = {
  modifier = "Mod4"; #Super key 
  terminal = "alacritty";
  menu = "rofi -show drun";

  bars = [ ];
  
  fonts = {
    names = [ "JetBrainsMono Nerd Font" ];
    size = 12.0;
  };

  window = {
    border = 1;
    titlebar = false;
  };

  startup = [
    { command = "dex --autostart --environment i3"; notification = false; }
    { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
    { command = "nm-applet"; notification = false; }
    { command = "feh --bg-fill ~/Downloads/edgy.png"; always = true; notification = false; }
    { command = "picom -b"; always = true; notification = false; }
    { command = "spice-vdagent"; always = true; notification = false; }
    { command = "autotiling"; always = true; notification = false; }
    { command = "systemctl --user restart polybar.service"; always = true; notification = false; }
    { command = "i3-msg workspace 1"; always = true; notification = false; }
  ];
};
  extraConfig = ''
  # Audio
  bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%
  bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%
  bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle
  bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle

  # Movimiento y ventanas (Tus atajos personalizados)
  floating_modifier Mod4
  tiling_drag modifier titlebar
  bindsym Mod4+q kill
  
  bindsym Mod4+j focus left
  bindsym Mod4+k focus down
  bindsym Mod4+l focus up
  bindsym Mod4+ntilde focus right

  bindsym Mod4+Shift+j move left
  bindsym Mod4+Shift+k move down
  bindsym Mod4+Shift+l move up
  bindsym Mod4+Shift+ntilde move right
  
  bindsym Mod4+n exec alacritty -e yazi
  '';
};

# =============================
#    POLYBAR 
# ===========================
  services.polybar = {
    enable = true;
    
    package = pkgs.polybar.override {
      i3Support = true;
    };
    
    script = "polybar main &";

    config = {
      "bar/main" = {
        width = "100%";
        height = "24pt";
        radius = 0;
        
        background = "#1a1b26"; 
        foreground = "#c0caf5";
        
        line-size = "3pt";
        padding-left = 1;
        padding-right = 2;
        module-margin = 1;

        font-0 = "JetBrainsMono Nerd Font:size=10;2";

        modules-left = "i3";
        modules-center = "date";
        modules-right = "memory cpu";

        cursor-click = "pointer";
        enable-ipc = true;
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        
        strip-wsnumbers = true;
        
        ws-icon-0 = "1;"; 
        ws-icon-1 = "2;"; 
        ws-icon-2 = "3;"; 
        ws-icon-3 = "4;"; 
        ws-icon-default = ""; 
        
        label-focused = "%icon%";
        label-focused-foreground = "#7aa2f7";
        label-focused-underline = "#7aa2f7";
        label-focused-padding = 2;
        
        label-unfocused = "%icon%";
        label-unfocused-foreground = "#565f89";
        label-unfocused-padding = 2;
        
        label-urgent = "%icon%";
        label-urgent-foreground = "#f7768e";
        label-urgent-padding = 2;
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%I:%M %p";
        date-alt = "%Y-%m-%d %I:%M:%S %p";
        
        label = "%date%";
        label-foreground = "#bb9af7";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        label = "RAM %percentage_used%%";
        label-foreground = "#9ece6a";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        label = "CPU %percentage%%";
        label-foreground = "#e0af68";
      };
    };
  };
}
