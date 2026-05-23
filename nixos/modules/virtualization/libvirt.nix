{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libguestfs
    dnsmasq
    cloud-utils
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
}
