{
  config,
  pkgs,
  modulesPath,
  hostname,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  networking.hostName = hostname;
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Since `fileSystems` is ignored by nixos-generators, we need to be creative
  systemd.services.mount-inception = {
    description = "i love inception :D";

    # fstab entry:
    #  host0   /wherever    9p      trans=virtio,version=9p2000.L   0 0
    script = ''
      mkdir -p /inception
      /run/wrappers/bin/mount -t 9p -o trans=virtio,version=9p2000.L host0 /inception
    '';

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  users.users.root = {
    password = "xd";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "libvirtd"
	  "docker"
    ];
  };

  services = {
    getty.autologinUser = "root";
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
        AllowUsers = null;
      };
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    libinput.enable = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  virtualisation = 
  {
    docker = {
      enable = true;
    };
  };

  networking.extraHosts = ''
  127.0.0.1 mmoussou.42.fr
  '';

  programs = {
    zsh = {
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enable = true;
      enableBashCompletion = true;
      shellAliases = (import ./aliases.nix);
    };
  };

  environment = {
    systemPackages = with pkgs; [
      firefox
      bindfs
      git
      unzip
      neovim
	  gnumake
    ];
  };

  system.stateVersion = "24.11";
}
