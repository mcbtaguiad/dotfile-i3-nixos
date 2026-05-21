let
  sinagtala = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGj8PGkNJ8WXE/uKFNviroq9pOPiYmv1Ow8sR0GZIeTa root@nixos";
  marilag = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtRgFcnP4rUZzrrNQEbbX5aRt/TB9YeZBCVumDcpZ3e root@nixos";

in
{
  "cloudflared-marilag.age".publicKeys = [
    marilag
  ];

}
