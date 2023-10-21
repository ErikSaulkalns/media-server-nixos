{ config, pkgs, ... }:

let
  params = import ./params.nix;
in
{
  # Boot Configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
