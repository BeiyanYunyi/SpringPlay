# SpringPlay

A taste of Spring Boot and Kotlin.

JDK 21 and GraalVM are supported. Uses Version Catalog.

Also provides a `flake.nix` for Nix users.

## Nix

### Developing

After updating gradle dependencies, run:

```bash
nix run .#update-deps
```

Or in nix develop environment:

```bash
nix develop
# in develop shell
update-deps
```

Then in nix develop environment:

```bash
./gradlew bootRun
```

### Building

```bash
nix build
```

Then use `./result/bin/SpringPlay` to start the server.
