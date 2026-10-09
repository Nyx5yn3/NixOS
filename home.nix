{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
    ripgrep
    fd
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


  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./tokyo-night.toml);
  };

  programs.bash = {
    enable = true;
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
        
        label-focused = "%name%";
        label-focused-foreground = "#7aa2f7";
        label-focused-underline = "#7aa2f7";
        label-focused-padding = 2;
        
        label-unfocused = "%name%";
        label-unfocused-foreground = "#565f89";
        label-unfocused-padding = 2;
        
        label-urgent = "%name%";
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
