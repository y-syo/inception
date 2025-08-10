{
  description = "A NixOS configuration for the Inception of Things";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-generators,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = (import inputs.systems);
      forAllSystems = nixpkgs.lib.genAttrs systems;
      hostname = "inception-vm";
    in
    {
      packages = forAllSystems (
        system:
        let
          generate-vm = modules:
            nixos-generators.nixosGenerate {
              inherit system modules;
              specialArgs = {
                inherit hostname;
              };
              format = "vm";
            };
          vm = generate-vm [ ./configuration.nix ];
        in 
        {
          inherit vm;
          default = vm;
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          lib = pkgs.lib;
          selfPkgs = self.packages.${system};
        in
        rec {
          vm =
            let
              scriptName = "run-${hostname}-vm";
              script = pkgs.writeShellScriptBin "${scriptName}" ''
                ${selfPkgs.vm}/bin/run-${hostname}-vm \
                  -enable-kvm \
				  -m 8G \
				  -smp 4 \
				  -vga qxl \
                  -virtfs local,path=$(${pkgs.coreutils}/bin/pwd),mount_tag=host0,security_model=mapped-xattr,id=host0
              '';
            in
            {
              type = "app";
              program = "${script}/bin/${scriptName}";
            };

          clean = 
            let
              scriptName = "clean-${hostname}-vm";
              script = pkgs.writeShellScriptBin "${scriptName}" ''
                ${pkgs.coreutils}/bin/rm -rfv result ${hostname}.qcow2
              '';
            in
            {
              type = "app";
              program = "${script}/bin/${scriptName}";
            };

          default = vm;
        }
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.nixfmt-rfc-style
      );
    };
}
