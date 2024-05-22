# Openssl With Providers

## Compilation
Compilation on normal Linux distributions without Nix can be done with the instructions from [The github page for OQS-Provider](https://github.com/open-quantum-safe/oqs-provider)
With Nix/NixOS, run nix build, or put flake.nix in the input sources of another flake

## Test Commands
- openssl s_client -tls1_3 -groups x25519_kyber768:p384_kyber768 example.com:443
- openssl list -signature-algorithms -provider oqsprovider
- openssl list -kem-algorithms -provider oqsprovider
