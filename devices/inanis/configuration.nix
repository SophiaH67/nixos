{
  networking.hostName = "inanis";
  virtualisation.diskSize = 20 * 1024;

  # Request v6 addr
  networking.enableIPv6 = true;
  networking.useDHCP = true;
}