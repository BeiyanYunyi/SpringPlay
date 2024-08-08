{
  inputs = { };
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    # deno = pkgs.callPackage ./deno.nix { };
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (graalvmCEPackages.buildGraalvm {
            useMusl = false;
            src = fetchurl {
              url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_linux-x64_bin.tar.gz";
              hash = "sha256-sEgGmqo6mbhPW5V7FizBgaMqQzDLw1QCdmNjxb52rkg=";
            };
            version = "21.0.2";
            meta.platforms = [ system ];
          })
        ];
      };
    };
}
