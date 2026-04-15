# Local Tooling

Use this repo's documented checks exactly as written in `AGENTS.md` and
the `justfile`. The required CLI toolchain is:

- `just`
- `rg` (`ripgrep`)
- `node` + `npm` (for `npx`)
- `lychee`
- `pre-commit`

Run `just doctor` after installation. It verifies that every required
command is on `PATH` before you rely on `just check`.

## Fast path

If you already have a preferred package manager, install those five
tools with it and then run:

```bash
just doctor
just install-hooks
```

## macOS (Homebrew)

```bash
brew install just ripgrep node lychee pre-commit
just doctor
just install-hooks
```

## Debian / Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y ripgrep nodejs npm pipx cargo
cargo install --locked just
cargo install --locked lychee
pipx install pre-commit
just doctor
just install-hooks
```

## What the hooks run

The checked-in [.pre-commit-config.yaml](../.pre-commit-config.yaml)
runs the same lightweight repo checks you should expect in normal
authoring:

- `just lint`
- `just format-check`
- `just anchors`

`just links` stays outside the default hook set because it depends on
`lychee` and is typically run before pushing or in CI.
