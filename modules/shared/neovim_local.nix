{ dotfiles }:
{ pkgs }:
pkgs.runCommand "neovim-wrapped" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir -p $out/bin

  makeWrapper /usr/local/bin/nvim $out/bin/nvim_local \
    --set XDG_CONFIG_HOME ${dotfiles}
''
