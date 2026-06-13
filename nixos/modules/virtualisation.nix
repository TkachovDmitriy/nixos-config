{ ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = false;
      ovmf.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
