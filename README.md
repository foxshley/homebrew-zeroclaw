# homebrew-zeroclaw

Homebrew tap for the `zeroclaw-patched` distribution, maintained as a fork-local package for a reproducible Telegram reaction repair.

Install with:

```sh
brew tap foxshley/zeroclaw
brew install zeroclaw-patched
```

The installed command remains `zeroclaw`. It shares the existing ZeroClaw runtime directory at `$(brew --prefix)/var/zeroclaw`, including configuration, credentials, agents, and memory. Review the migration instructions before switching from Homebrew Core because both packages provide the `zeroclaw` command and service.
