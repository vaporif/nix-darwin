{pkgs}: let
  inherit (pkgs) lib stdenv;
in
  pkgs.buildNpmPackage {
    pname = "nomicfoundation-solidity-language-server";
    version = "0.8.25";

    src = pkgs.fetchFromGitHub {
      owner = "NomicFoundation";
      repo = "hardhat-vscode";
      rev = "v0.8.25";
      hash = "sha256-DJm/qv5WMfjwLs8XBL2EfL11f5LR9MHfTT5eR2Ir37U=";
    };

    npmDepsHash = "sha256-bLP5kVpfRIvHPCutUvTz5MFal6g5fimzXGNdQEhB+Lw=";
    npmWorkspace = "server";

    postPatch = ''
      rm -rf test
      substituteInPlace server/scripts/bundle.js \
        --replace-fail 'if (!value || value === "")' 'if (false)'
    '';

    nativeBuildInputs =
      [pkgs.pkg-config]
      ++ lib.optional stdenv.isDarwin
      (
        if stdenv.hostPlatform.isAarch64
        then pkgs.clang_20
        else pkgs.llvmPackages_17.clang
      );

    buildInputs = [pkgs.libsecret];

    postInstall = ''
      find -L $out -type l -print -delete
    '';

    meta = {
      description = "Language server for Solidity";
      homepage = "https://github.com/NomicFoundation/hardhat-vscode/tree/development/server";
      license = pkgs.lib.licenses.mit;
      mainProgram = "nomicfoundation-solidity-language-server";
    };
  }
