{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, deepseq, ghc-byteorder, lib
      , text, text-short
      }:
      mkDerivation {
        pname = "base58";
        version = "0.1.0.0";
        src = ./.;
        libraryHaskellDepends = [
          base bytestring deepseq ghc-byteorder text text-short
        ];
        testHaskellDepends = [ base ];
        homepage = "https://github.com/emilypi/base58";
        description = "Modern, performant base58 encodings and decodings";
        license = lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
