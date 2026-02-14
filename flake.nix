{
  description = "Flake for pesde CLI binary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.pesde = pkgs.stdenv.mkDerivation {
        pname = "pesde";
        version = "0.7.2";

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.unzip
        ];

        buildInputs = [
          pkgs.zlib
          pkgs.openssl_3
          pkgs.dbus
          pkgs.libgcc
        ];

        src = pkgs.fetchzip {
          url = "https://github.com/pesde-pkg/pesde/releases/download/v0.7.2%2Bregistry.0.2.3/pesde-0.7.2-linux-x86_64.zip";
          sha256 = "sha256-O0HUfpwQxxDRyhA4LCp/9lmNpEzGh9O5FlljP/llIV8=";
        };

        installPhase = ''
          mkdir -p $out/bin
          cp $src/pesde $out/bin/pesde
          chmod +x $out/bin/pesde
        '';
      };

      defaultPackage.${system} = self.packages.${system}.pesde;
    };
}
