{
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.pipewire-config;
in
{
  options.pipewire-config = {
    enable = mkEnableOption "Configure pipewire";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      # systemWide = true;

      # extraConfig.pipewire."92-low-latency" = {
      #   context.properties = {
      #     default.clock.allowed-rates = [
      #       48000
      #       96000
      #       192000
      #     ];
      #     default.clock.rate = 192000;
      #     default.clock.quantum = 256;
      #     default.clock.min-quantum = 32;
      #     default.clock.max-quantum = 2048;
      #   };
      # };
      # extraConfig.pipewire-pulse."92-low-latency" = {
      #   context.modules = [
      #     {
      #       name = "libpipewire-module-protocol-pulse";
      #       args = {
      #         pulse.min.req = "32/192000";
      #         pulse.default.req = "256/192000";
      #         pulse.max.req = "2048/192000";
      #         pulse.min.quantum = "32/192000";
      #         pulse.max.quantum = "2048/192000";
      #       };
      #     }
      #   ];
      #   stream.properties = {
      #     node.latency = "256/192000";
      #     resample.quality = 1;
      #   };
      # };

      extraConfig.pipewire."91-null-sinks" = {
        "context.objects" = [
          {
            # A default dummy driver. This handles nodes marked with the "node.always-driver"
            # properyty when no other driver is currently active. JACK clients need this.
            factory = "spa-node-factory";
            args = {
              "factory.name" = "support.node.driver";
              "node.name" = "Dummy-Driver";
              "priority.driver" = 8000;
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "Microphone-Proxy";
              "node.description" = "Microphone";
              "media.class" = "Audio/Source/Virtual";
              "audio.position" = "MONO";
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "Main-Output-Proxy";
              "node.description" = "Main Output";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];
      };
    };
  };
}
