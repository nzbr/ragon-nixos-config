{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let
  inherit (inputs) agenix;
  secretsDir = "${toString ../secrets}";
  secretsFile = "${secretsDir}/secrets.nix";
  cfg = config.ragon.agenix;
in
{
  options.ragon.agenix.enable = mkBoolOpt true;
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.${pkgs.system} ];
  # Set passwords
  users.users.root.passwordFile = "${age.secrets.rootPasswd.path}";

  age = {
    secrets =
      if (pathExists secretsFile && cfg.enable)
      then
        mapAttrs'
          (n: _: nameValuePair (removeSuffix ".age" n) {
            file = "${secretsDir}/${n}";
            owner = if (hasInfix "root" n) then mkDefault "root" else mkDefault config.ragon.user.username;
          })
          (import secretsFile)
      else { };
    sshKeyPaths =
      [
        "/persistent/etc/ssh/ssh_host_rsa_key"
        "/persistent/etc/ssh/ssh_host_ed25519_key"
      ];
  };
}
