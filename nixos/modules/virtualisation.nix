{ ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };

  programs.virt-manager.enable = true;

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
