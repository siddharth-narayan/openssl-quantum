{ lib
, openssl
, providers ? []
}:

let 
    openssl-with-providers = openssl.overrideAttrs (old: {
        name = "openssl-with-providers";
        postInstall = old.postInstall + ''
        ${
            lib.concatStringsSep "\n"
            (map
                (provider:
                ''
                    echo "Copying provider ${provider.name}"
                    echo cp -rs --no-preserve=mode "${provider}" "$out/lib/ossl-modules"
                    cp --no-preserve=mode ${provider}/lib/ossl-modules/* "$out/lib/ossl-modules"
                ''
                )
                providers
            )
        } 
        '';
  });

in
    openssl-with-providers
