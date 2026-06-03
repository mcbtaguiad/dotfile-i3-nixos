{ ... }:

{

  services.fwupd.enable = true;

  boot.kernelModules = [ "thinkpad_acpi" ];

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  # thinkfan
  services.thinkfan = {
    enable = true;
    sensors = [
      {
        type = "hwmon";
        query = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input";
      }
    ];
    fans = [
      {
        type = "tpacpi";
        query = "/proc/acpi/ibm/fan";
      }
    ];
    levels = [
      [
        0
        0
        45
      ]
      [
        1
        43
        50
      ]
      [
        2
        48
        55
      ]
      [
        3
        53
        60
      ]
      [
        4
        58
        65
      ]
      [
        5
        63
        70
      ]
      [
        6
        68
        75
      ]
      [
        7
        72
        80
      ]
      [
        127
        78
        32767
      ]
    ];
  };

}
