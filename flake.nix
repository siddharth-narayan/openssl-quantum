{
  outputs = { self, nixpkgs }:
  let pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  {
	    # Declare some local packages be available via self.packages
      packages.x86_64-linux = {
        default = self.packages.x86_64-linux.openssl-with-oqsprovider;
        oqsprovider-static = pkgs.callPackage ./oqs-provider.nix { enableStatic = true; };
        oqsprovider = pkgs.callPackage ./oqs-provider.nix {};

        openssl-with-oqsprovider = pkgs.callPackage ./openssl-with-providers.nix { providers = [ self.packages.x86_64-linux.oqsprovider ]; };
      };
      devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        self.packages.x86_64-linux.default
      ];
    };
  };
}
