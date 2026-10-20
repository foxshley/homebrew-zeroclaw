# Switching to `zeroclaw-patched`

The formula installs the existing `zeroclaw` command and runs the existing ZeroClaw service against `$(brew --prefix)/var/zeroclaw`. That directory holds the live workspace, including configuration, credentials, agents, and memories. Keep it in place throughout the switch and rollback.

The formula is keg-only so the Homebrew Core keg can remain installed as a rollback target. Both kegs provide `zeroclaw`, `zeroclaw-acp-bridge`, and `zerocode`, so only one can be linked into the command path at a time.

## Before switching

1. Record `brew services list` and `command -v zeroclaw`.
2. Install the tap formula while Core is still running: `brew install foxshley/zeroclaw/zeroclaw-patched`. Keg-only installation does not link commands or start a service.
3. Stop `zeroclaw` with `brew services stop zeroclaw` and confirm the daemon has exited.
4. Unlink the Core formula with `brew unlink zeroclaw`. Keep its keg installed as the rollback target.
5. Link the tap formula with `brew link --force zeroclaw-patched`.
6. Confirm `zeroclaw --version` and run a harmless command against the existing workspace before starting the service.
7. Start the service with `brew services start zeroclaw-patched`; confirm it is healthy and reads the existing workspace.
8. After the switch is healthy, pin Core with `brew pin zeroclaw` to retain the rollback keg. Keep it pinned while the patched package is active; unpin only when intentionally updating Core or after rolling back.

Do not run the Core and patched services at the same time. The launch agents use the same workspace and could contend for state. Keep the Core formula pinned while the patched package is active. To roll back, stop the patched service, unlink it, relink the retained Core keg, and start Core as described below.

## Rollback

1. Stop `zeroclaw-patched` and confirm its daemon has exited.
2. Unlink `zeroclaw-patched` with `brew unlink zeroclaw-patched`.
3. Relink the still-installed Homebrew Core keg with `brew link --force zeroclaw`.
4. Start the original service with `brew services start zeroclaw` and confirm it is healthy.

Leave `$(brew --prefix)/var/zeroclaw` untouched. The retained Core keg remains available as the rollback target.

## Updating the installed package

The formula is keg-only to keep the Core keg available. Homebrew retains the formula’s existing link state during upgrades. Update it with `brew upgrade foxshley/zeroclaw/zeroclaw-patched`, then restart its service with `brew services restart zeroclaw-patched`; an already-running daemon does not switch to the new binary automatically. Confirm `command -v zeroclaw`, `command -v zeroclaw-acp-bridge`, `command -v zerocode`, their reported versions, and `brew services list`. Homebrew Core should stay pinned throughout; unpin it only for an intentional Core update or rollback.

## Updating the repair

The formula pins an immutable source commit archive and SHA256. To update it, review and test the source change, calculate and verify the new archive SHA256, then update both the archive commit and `sha256` together. Keep the formula at version `0.8.5` with an incremented Homebrew `revision` while the upstream application version is unchanged; bump the formula version when upstream advances. Create the immutable source release tag after source review and tests. Promote a new tap formula revision only after package validation; do not use a moving branch as the formula source.
