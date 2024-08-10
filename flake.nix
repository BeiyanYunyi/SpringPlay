{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (self: super: { gradle = super.gradle.override { java = graalVM; }; }) ];
        pkgs = import nixpkgs { inherit system overlays; };
        graalVMUrls = {
          x86_64-linux = {
            url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_linux-x64_bin.tar.gz";
            hash = "sha256-sEgGmqo6mbhPW5V7FizBgaMqQzDLw1QCdmNjxb52rkg=";
          };
          aarch64-darwin = {
            url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_macos-aarch64_bin.tar.gz";
            hash = "sha256-UV46k6zH4ZONq6g+2kJy5Ulf0wLXzdmex+v0CO1QWrc=";
          };
        };
        graalVM = pkgs.graalvmCEPackages.buildGraalvm {
          useMusl = false;
          src = pkgs.fetchurl graalVMUrls.${system};
          version = "21.0.2";
          meta.platforms = [ system ];
        };
      in
      # deno = pkgs.callPackage ./deno.nix { };
      rec {
        fetchd = pkgs.gradle;
        mitmC = pkgs.mitm-cache;
        packages.default =
          let
            self = pkgs.stdenv.mkDerivation (finalAttrs: {
              pname = "spring-play";
              version = "1.0.0";
              src = ./.;
              nativeBuildInputs = with pkgs; [ gradle ];
              buildInputs = with pkgs; [ makeWrapper ];
              mitmCache = pkgs.gradle.fetchDeps {
                inherit (finalAttrs) pname;
                pkg = self;
                data = ./deps.json;
              };
              __darwinAllowLocalNetworking = true;
              gradleUpdateTask = "bootJar";
              gradleBuildTask = "bootJar";
              installPhase = ''
                runHook preInstall
                mkdir -p $out/{bin,share/SpringPlay}
                cp build/libs/SpringPlay-1.0-SNAPSHOT.jar $out/share/SpringPlay
                makeWrapper ${graalVM}/bin/java $out/bin/SpringPlay \
                  --add-flags "-jar $out/share/SpringPlay/SpringPlay-1.0-SNAPSHOT.jar"
                runHook postInstall
              '';
            });
          in
          self;
        packages.updateDeps = pkgs.stdenv.mkDerivation {
          # src = packages.default.mitmCache.updateScript;
          pname = "update-deps";
          version = "0.0.1";
          dontUnpack = true;
          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp ${packages.default.mitmCache.updateScript} $out/bin/update-deps
            runHook postInstall
          '';
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            graalVM
            gradle
            packages.updateDeps
          ];
        };
      }
    );
}
