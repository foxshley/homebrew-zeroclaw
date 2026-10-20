# Switching to `zeroclaw-patched`

The formula installs the existing `zeroclaw` command and runs the existing ZeroClaw service against `$(brew --prefix)/var/zeroclaw`. That directory holds the live workspace, including configuration, credentials, agents, and memories. Keep it in place throughout the switch and rollback.

The formula is keg-only so the Homebrew Core keg can remain installed as a rollback target. Both kegs provide `zeroclaw`, so only one can be linked into the command path at a time.

## Before switching

1. Record `brew services list` and `command -v zeroclaw`.
2. Stop `zeroclaw` with `brew services stop zeroclaw` and confirm the daemon has exited.
3. Unlink the Core formula with `brew unlink zeroclaw`. Keep its keg installed; it contains the currently working patched Core binary and remains the rollback target.
4. Install the tap formula, then link its command with `brew link --force zeroclaw-patched`.
5. Confirm `zeroclaw --version` and run a harmless command against the existing workspace before starting the service.
6. Start the service with `brew services start zeroclaw-patched`; confirm it is healthy and reads the existing workspace.

Do not run the Core and patched services at the same time. The launch agents use the same workspace and could contend for state.

## Rollback

1. Stop `zeroclaw-patched` and confirm its daemon has exited.
2. Unlink `zeroclaw-patched` with `brew unlink zeroclaw-patched`.
3. Relink the still-installed Homebrew Core keg with `brew link --force zeroclaw`.
4. Start the original service with `brew services start zeroclaw` and confirm it is healthy.

Leave `$(brew --prefix)/var/zeroclaw` untouched. Do not restore the older stock binary backup from `local-fixes`; the retained Core keg contains the current working patched installation.
