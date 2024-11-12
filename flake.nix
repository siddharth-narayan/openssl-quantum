{
  outputs = { self, nixpkgs }:
  let pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  {
    packages.x86_64-linux = {
      liboqs = pkgs.callPackage ./liboqs.nix {};
      oqsprovider = pkgs.callPackage ./oqs-provider.nix { liboqs = self.packages.x86_64-linux.liboqs; };
      oqsprovider-static = pkgs.callPackage ./oqs-provider.nix { enableStatic = true; };

      openssl-quantum = pkgs.callPackage ./openssl-with-providers.nix { providers = [ self.packages.x86_64-linux.oqsprovider ]; };        
      default = self.packages.x86_64-linux.openssl-quantum;
      
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        self.packages.x86_64-linux.default
      ];
    };
  };
}
