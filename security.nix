{ config, pkgs, ... }:

let
  pentest-tools = with pkgs; [
    nmap
    wireshark
    metasploit
    burpsuite
    hashcat
    john
    sqlmap
    gobuster
  ];
  
  recon-tools = with pkgs; [
    dnsenum
    amass
    theharvester
  ];

  network-ids = with pkgs; [
    snort
  ];
in {
  environment.systemPackages = pentest-tools ++ recon-tools ++ network-ids;
  programs.wireshark.enable = true;
  users.users."syne".extraGroups = [ "wireshark" ];
}
