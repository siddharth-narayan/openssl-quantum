# Previous shell.nix
# { pkgs ? import <nixpkgs> {}}:
#   pkgs.mkShell {
#     # nativeBuildInputs is usually what you want -- tools you need to run
#     nativeBuildInputs = with pkgs.buildPackages; [
#       (callPackage /home/siddharth/projects/oqs-provider/with-providers.nix { providers = [ (callPackage /home/siddharth/projects/oqs-provider/oqs-provider.nix {}) ]; })
#     ];
# }

{
  outputs = { self, nixpkgs }:
  let pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  {
	    # Declare some local packages be available via self.packages
      packages.x86_64-linux = {
        default = self.packages.x86_64-linux.openssl-with-oqsprovider;
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
