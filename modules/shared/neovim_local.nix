{ dotfiles, neovim }:
{ pkgs }:
pkgs.runCommand "neovim-wrapped" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir -p $out/bin

  makeWrapper ${neovim} $out/bin/nvim_local \
    --set XDG_CONFIG_HOME ${dotfiles}
''
