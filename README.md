# homebrew-zeroclaw

Homebrew tap for the `zeroclaw-patched` distribution, maintained as a fork-local package for a reproducible Telegram reaction repair.

Install with:

```sh
brew tap foxshley/zeroclaw
brew install zeroclaw-patched
```

The package provides the `zeroclaw`, `zeroclaw-acp-bridge`, and `zerocode` commands and shares the existing ZeroClaw runtime directory at `$(brew --prefix)/var/zeroclaw`, including configuration, credentials, agents, and memory. It is keg-only because those commands overlap with Homebrew Core; follow the migration guide to switch links and services safely. Review [MIGRATION.md](MIGRATION.md) before switching from Homebrew Core because both packages provide the `zeroclaw` command and service. The formula pins an immutable source commit and checksum; see the migration guide for revision updates.
