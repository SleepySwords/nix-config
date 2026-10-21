{ config, pkgs, ... }:
let
  local_dotfiles = "${config.home.homeDirectory}/stuff/dev/dotfiles";
  local_neovim = (import ../modules/shared/neovim_local.nix { dotfiles = local_dotfiles; neovim = "/usr/local/bin/nvim"; });
in
{
  imports = [
    ((import ../modules/shared/dotfiles.nix) {})
  ];

  home.username = "ibby";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [ nixd nixfmt hello (local_neovim { inherit pkgs; }) ];
}
