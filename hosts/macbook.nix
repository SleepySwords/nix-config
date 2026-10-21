{ self, config, pkgs, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  # system.configurationRevision = self.rev or self.dirtyRev or null;
  system.primaryUser = "ibby";
  users.users.ibby = {
    home = "/Users/ibby";
  };

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
