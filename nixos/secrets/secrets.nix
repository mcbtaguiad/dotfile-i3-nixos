let
  sinagtala = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGj8PGkNJ8WXE/uKFNviroq9pOPiYmv1Ow8sR0GZIeTa root@nixos";
  marilag = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtRgFcnP4rUZzrrNQEbbX5aRt/TB9YeZBCVumDcpZ3e root@nixos";
  workstation = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtf3e9lQR1uAypz4nrq2nDj0DvZZGONku5wO+M87wUVTistrY8REsWO2W1N/v4p2eX30Bnwk7D486jmHGpXFrpHM0EMf7wtbNj5Gt1bDHo76WSci/IEHpMrbdD5vN8wCW2ZMwJG4JC8lfFpUbdmUDWLL21Quq4q9XDx7/ugs1tCZoNybgww4eCcAi7/GAmXcS/u9huUkyiX4tbaKXQx1co7rTHd7f2u5APTVMzX0C1V9Ezc6l8I+LmjZ9rvQav5N1NgFh9B60qk9QJAb8AK9+aYy7bnBCBJ/BwIkWKYmLoVBi8j8v8UVhVdQMvQxLax41YcD8pbgU5s1O2nxM1+TqeGxrGHG6f7jqxhGWe21I7i8HPvOHNJcW4oycxFC5PNKnXNybEawE23oIDQfIG3+EudQKfAkJ3YhmrB2l+InIo0Wi9BHBIUNPzTldMS53q2teNdZR9UDqASdBdMgp4Uzfs1+LGdE5ExecSQzt4kZ8+o9oo9hmee4AYNOTWefXdip0= mtaguiad@tags-p51";

in
{
  "cloudflared-marilag.age".publicKeys = [
    marilag
    workstation
  ];

  "wireguard-privkey-marilag.age".publicKeys = [
    marilag
    workstation
  ];

  "wireguard-podman-marilag.age".publicKeys = [
    marilag
    workstation
  ];

  "beszel-agent-marilag.age".publicKeys = [
    marilag
    workstation
  ];

  "immich-secret-marilag.age".publicKeys = [
    marilag
    workstation
  ];
}
