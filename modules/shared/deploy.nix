{ pkgs, ... }:
let
  darwin-rebuild = "/run/current-system/sw/bin/darwin-rebuild";
  nixos-rebuild = "${toString pkgs.nixos-rebuild}/bin/nixos-rebuild";
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  rebuild-command = if isDarwin then darwin-rebuild else nixos-rebuild;
  system = pkgs.stdenv.hostPlatform.system;
  deploy-from-git = (
    pkgs.writeShellScriptBin "deploy-from-git" ''
      #!/bin/bash
      sudo ${rebuild-command} switch --flake github:SleepySwords/nix-config --show-trace
    ''
  );
in
{
  users.users.deploy = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHz29F59kPjXDtuA12h3U2qUL/aun7yMellK4WR4h7Ye ibby"
    ];
  } // pkgs.lib.optionalAttrs isDarwin {
    uid = 550;
    home = "/Users/deploy";
    createHome = true;
  } // pkgs.lib.optionalAttrs isLinux {
    isNormalUser = true;
  };

  security.sudo =
    if isDarwin then
      {
        extraConfig = ''
          deploy ALL=(root) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild switch --flake github\:SleepySwords/nix-config --show-trace
        '';
      }
    else
      {
        extraRules = [
          {
            users = [ "deploy" ];
            runAs = "root";
            commands = [
              {
                command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake github:SleepySwords/nix-config --show-trace";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };

  environment.systemPackages = [
    deploy-from-git
  ];
}
