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
}
