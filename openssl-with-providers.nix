{ lib
, openssl
, providers ? []
, autoloadProviders ? true
, quantumSafe ? true
}:

 
openssl.overrideAttrs (old: {
        name = "openssl-with-providers";
        postInstall = old.postInstall + ''
        ${
            if autoloadProviders then lib.concatStringsSep "\n"
            (map
                (provider:
                ''
                    echo "Copying provider ${provider.name}"
                    echo cp -rs --no-preserve=mode "${provider}" "$out/lib/ossl-modules"
                    echo "Adding ${provider.name} to openssl.conf"
                    echo sed -i 's/\\[provider_sect\\]/[provider_sect]\n${provider.name} = ${provider.name}_sect/g' $etc/etc/ssl/openssl.cnf
                    
                    cp --no-preserve=mode ${provider}/lib/ossl-modules/* "$out/lib/ossl-modules"
                    
                    # sed -i '/^[[:space:]]*#/!s/\[provider_sect\]/[provider_sect]\n${provider.name} = ${provider.name}_sect/g' $etc/etc/ssl/openssl.cnf
                    # echo "[${provider.name}_sect]" >> $etc/etc/ssl/openssl.cnf
                    
                    sed -i '/^[[:space:]]*#/!s/\[provider_sect\]/[provider_sect]\noqsprovider = oqsprovider_sect/g' $etc/etc/ssl/openssl.cnf
                    echo "[oqsprovider_sect]" >> $etc/etc/ssl/openssl.cnf
                    echo "activate = 1" >> $etc/etc/ssl/openssl.cnf
                ''
                )
                providers
            ) else ""
        }
        ${ if quantumSafe then 
        ''
        echo "[tls_system_default]" >> $etc/etc/ssl/openssl.cnf
        echo "Groups = x25519" >> $etc/etc/ssl/openssl.cnf
        '' 
        else "" }
        
        ${ if autoloadProviders then 
        ''
        echo Enable the default provider
        echo sed -i '/^[[:space:]]*#/!s/\[default_sect\]/[default_sect]\nactivate = 1/g' $etc/etc/ssl/openssl.cnf
        sed -i '/^[[:space:]]*#/!s/\[default_sect\]/[default_sect]\nactivate = 1/g' $etc/etc/ssl/openssl.cnf
        ''
        else ''''}
        '';
})
