# OpenSSL with Post Quantum Support

## Packages
This repository includes a few packages.
1. Default - OpenSSL with full post quantum support
2. OpenSSL with provider suport - providers can be added by overriding the "providers" argument to this package.
3. OQS-Provider -The OpenSSL provider that allows OpenSSL to be post quantum
4. Liboqs - The library implementing post quantum crytography.

## Usage

```nix
# flake.nix
inputs.openssl-quantum.url = "github:siddharth-narayan/openssl-with-providers";
outputs = { nixpkgs, openssl-quantum, ... }:
{
  # Packages can be accessed
  openssl-quantum.packages.x86_64-linux.default
}

# nix develop (devshell)
nix develop github:siddharth-narayan/openssl-quantum
```

### Test Commands
OpenSSL is available for testing in the devshell:
```bash
openssl s_client -tls1_3 -groups <PQ groups> test.openquantumsafe.org:6000 # Example group: X25519MLKEM768
openssl list -providers
openssl list -signature-algorithms -provider oqsprovider
openssl list -kem-algorithms -provider oqsprovider
```
