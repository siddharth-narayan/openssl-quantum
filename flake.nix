{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      {
          packages = {
            liboqs = pkgs.callPackage ./liboqs.nix {};
            oqsprovider = pkgs.callPackage ./oqs-provider.nix { liboqs = self.packages.${system}.liboqs; };
            oqsprovider-static = pkgs.callPackage ./oqs-provider.nix { liboqs = self.packages.${system}.liboqs; enableStatic = true; };

            openssl-quantum = pkgs.callPackage ./openssl-with-providers.nix { providers = [ self.packages.${system}.oqsprovider ]; };
            default = self.packages.${system}.openssl-quantum;
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              self.packages.${system}.default
            ];
        };
      }
    );
}
