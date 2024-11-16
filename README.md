# OpenSSL with Post Quantum Support

## Packages
This repository includes a few packages.
1. Default - OpenSSL with post quantum support
2. OpenSSL with provider suport - providers can be added by overriding the "providers" argument to this package.
3. OQS-Provider -The OpenSSL provider that allows OpenSSL to be post quantum
4. Liboqs - The library implementing post quantum crytography.

Compilation on normal Linux distributions without Nix can be done with the instructions from [The github page for OQS-Provider](https://github.com/open-quantum-safe/oqs-provider)
With Nix/NixOS, run nix build, or put flake.nix in the input sources of another flake

```
# flake.nix example

## Test Commands
- openssl s_client -tls1_3 -groups x25519_kyber768:p384_kyber768 example.com:443
- openssl list -signature-algorithms -provider oqsprovider
- openssl list -kem-algorithms -provider oqsprovider
