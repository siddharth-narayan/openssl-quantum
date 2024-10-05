{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          oqsprovider = pkgs.callPackage ./oqs-provider.nix {};
          oqsprovider-static = pkgs.callPackage ./oqs-provider.nix { enableStatic = true; };
  
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
