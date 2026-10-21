{ pkgs, ... }:
let
  deploy-from-git = (
    pkgs.writeShellScriptBin "deploy-from-git" ''
      #!/bin/bash
      sudo ${"${toString pkgs.nixos-rebuild}/bin/nixos-rebuild"} switch --flake github:SleepySwords/nix-config --show-trace
    ''
  );
  system = pkgs.stdenv.hostPlatform.system;

in
{
  users.users.deploy = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHz29F59kPjXDtuA12h3U2qUL/aun7yMellK4WR4h7Ye ibby"
    ];
    isNormalUser = true;
  };

  security.sudo =
    if pkgs.lib.hasPrefix "darwin" system then
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
      }
    else
      {
        extraConfig = ''
          deploy ALL=(root) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild switch
        '';
      };

  environment.systemPackages = [
    deploy-from-git
  ];
}
