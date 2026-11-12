final: prev: {
  # === Vendor environment (pre-built vendor/local for quine-relay) ===
  acme-chef = final.callPackage ./packages/acme-chef.nix { };
  velato-01 = final.callPackage ./packages/velato-01.nix { };
  vendor-env = final.callPackage ./packages/vendor-env.nix { };

  # === Custom packages not in nixpkgs ===
  ksh93 = final.callPackage ./packages/ksh93.nix { };
  lazyk = final.callPackage ./packages/lazyk.nix { };
  ratfor = final.callPackage ./packages/ratfor.nix { };
  cimfomfa = final.callPackage ./packages/cimfomfa.nix { };
  zoem = final.callPackage ./packages/zoem.nix { };
  velato = final.callPackage ./packages/velato.nix { };
  cfunge = final.callPackage ./packages/cfunge.nix { };
  squirrel = final.callPackage ./packages/squirrel.nix { };
  nickle = final.callPackage ./packages/nickle.nix { };
  spl2c = final.callPackage ./packages/spl2c.nix { };
  livescript = final.callPackage ./packages/livescript.nix { };
  mustache-cli = final.callPackage ./packages/mustache-cli.nix { };
  # Debian's AFNIX build machinery supports GCC through version 14.
  afnix = final.callPackage ./packages/afnix.nix { stdenv = final.gcc14Stdenv; };
  genius = final.callPackage ./packages/genius.nix { };
  yorick = final.callPackage ./packages/yorick.nix { };
  gpt-portugol = final.callPackage ./packages/gpt-portugol.nix { };
  parser3 = final.callPackage ./packages/parser3.nix { };
  swift-bin = final.callPackage ./packages/swift-bin.nix { };
  gambas3 = final.callPackage ./packages/gambas3.nix { };
  gm2 = final.callPackage ./packages/gm2.nix { };

  # 6.0.5 parses each 2047-byte chunk as a complete command. The relay's
  # 19 KiB Gnuplot line hits this regression; 6.0.6 still has the same bug.
  gnuplot = prev.gnuplot.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/gnuplot-long-lines.patch ];
  });

}
