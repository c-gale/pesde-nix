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

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          unzip
        ];

        buildInputs = with pkgs; [
          zlib
          openssl
          dbus
          libgcc
        ];

        src = pkgs.fetchzip {
          url = "https://github.com/pesde-pkg/pesde/releases/download/v0.7.4%2Bregistry.0.2.3/pesde-0.7.4-linux-x86_64.zip";
          sha256 = "sha256-nnYDoM+lTFIiHFCfALXVQIXJbpzLKOaScn/y6jBtHg4=";
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
