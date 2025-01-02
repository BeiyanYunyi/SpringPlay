{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
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
        packages.default =
          let
            self = pkgs.stdenv.mkDerivation (finalAttrs: {
              pname = "spring-play";
              version = "1.0.0";
              src = ./.;
              # nativeBuildInputs = with pkgs; [ gradle ];

              nativeBuildInputs = with pkgs; [
                # makeWrapper
                gradle
              ];
              mitmCache = pkgs.gradle.fetchDeps {
                inherit (finalAttrs) pname;
                pkg = self;
                data = ./deps.json;
              };
              __darwinAllowLocalNetworking = true;
              gradleUpdateTask = "nativeCompile";
              gradleBuildTask = "nativeCompile";
              # mkdir -p $out/{bin,share/SpringPlay}
              # cp build/libs/SpringPlay-1.0-SNAPSHOT.jar $out/share/SpringPlay
              # makeWrapper ${graalVM}/bin/java $out/bin/SpringPlay \
              #   --add-flags "-jar $out/share/SpringPlay/SpringPlay-1.0-SNAPSHOT.jar"
              installPhase = ''
                runHook preInstall
                mkdir -p $out/bin
                cp build/native/nativeCompile/SpringPlay $out/bin
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
        packages.dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "spring-play";
          tag = "latest";
          contents = [ packages.default ];
          # copyToRoot = pkgs.buildEnv {
          #   name = "spring-play";
          #   paths = [ packages.default ];
          #   pathsToLink = [ "/bin" ];
          # };
          # copyToRoot = [ packages.default ];
          config = {
            Cmd = [ "/bin/SpringPlay" ];
          };
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
