# homebrew-zeroclaw

Homebrew tap for `zeroclaw-patched`, built from the `foxshley/zeroclaw` fork at ZeroClaw v0.8.6 with the Telegram reaction repair. The formula also builds and installs the matching web dashboard so ZeroClaw Desktop can load the gateway interface.

Install with:

```sh
brew tap foxshley/zeroclaw
brew install zeroclaw-patched
```

The package provides the `zeroclaw`, `zeroclaw-acp-bridge`, and `zerocode` commands, plus the matching gateway dashboard. It shares the existing ZeroClaw runtime directory at `$(brew --prefix)/var/zeroclaw`, including configuration, credentials, agents, and memory. It is keg-only because those commands overlap with Homebrew Core; follow the migration guide to switch links and services safely. Review [MIGRATION.md](MIGRATION.md) before switching from Homebrew Core because both packages provide the `zeroclaw` command and service. The formula pins an immutable source commit and checksum. See [MIGRATION.md](MIGRATION.md) for upgrades and rollback.
