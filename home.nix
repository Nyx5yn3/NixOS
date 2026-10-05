{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./tokyo-night.toml);
  };

  programs.bash = {
    enable = true;
  };
}
