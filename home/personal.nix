{ config, pkgs, ... }:
let
  local_dotfiles = "${config.home.homeDirectory}/stuff/dev/dotfiles";
  local_neovim = (import ../modules/shared/neovim_local.nix { dotfiles = local_dotfiles; });
in
{
  imports = [
    ((import ../modules/shared/dotfiles.nix) {})
  ];

  home.username = "ibby";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [ hello (local_neovim { inherit pkgs; }) ];
  home.stateVersion = "26.05";
}
