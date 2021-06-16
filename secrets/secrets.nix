let
  pubkeys = import ../data/pubkeys.nix;
in
{
  "smb.age".publicKeys = pubkeys.ragon.computers;
  "cloudflareAcme.age".publicKeys = pubkeys.ragon.computers;
  "nextshot.age".publicKeys = pubkeys.ragon.computers;
  "rootPasswd.age".publicKeys = pubkeys.ragon.computers;
  "rootRagonPasswd.age".publicKeys = pubkeys.ragon.computers;
  "gitlabInitialRootPassword.age".publicKeys = pubkeys.ragon.computers;
  "gitlabSecretFile.age".publicKeys = pubkeys.ragon.computers;
  "gitlabDBFile.age".publicKeys = pubkeys.ragon.computers;
  "gitlabOTPFile.age".publicKeys = pubkeys.ragon.computers;
  "gitlabJWSFile.age".publicKeys = pubkeys.ragon.computers;
  "nextcloudAdminPass.age".publicKeys = pubkeys.ragon.computers;
  "rootWireguardwormhole.age".publicKeys = pubkeys.ragon.hosts.wormhole;
}
