# dotfiles

My macOS dotfiles, managed with [chezmoi](https://chezmoi.io). Repo: `vebrasmusic/dotfiles`.

Covers: zsh, [AeroSpace](https://nikitabobko.github.io/AeroSpace/) (tiling WM), Ghostty,
Neovim (LazyVim), lazygit, and a Homebrew `Brewfile` of every app/CLI I use.

---

## Setting up a brand-new Mac (from zero)

Goal: from a factory-fresh Mac with **nothing** installed (no git, no Homebrew, no CLI
tools) to fully configured in ~10 minutes of wall-clock time (most of it unattended
downloads).

### Prerequisites — check these first (not commands)

These are the things you can't `curl`:

- **Admin account.** You must be able to `sudo`. Homebrew asks for your login password
  once. Check:  Apple menu → System Settings → Users & Groups → your account says *Admin*.
- **Internet connection.**
- **Your Anthropic API key** on hand (`sk-ant-...`). Needed by the Neovim `avante` plugin.
  Grab it from the Anthropic console before you start. (Optional: a Moonshot key too.)
- **Willingness to click two GUI prompts:**
  1. The macOS *Command Line Tools* installer window (triggered by the Homebrew step).
  2. Granting **AeroSpace** the Accessibility permission after install (see post-install).

### Bootstrap commands

Run these in order in Terminal (the built-in one — you don't have Ghostty yet).

```sh
# 1. Homebrew. This also installs Apple's Command Line Tools (git, cc, etc.).
#    Follow the prompts and enter your login password when asked.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Put brew on PATH for THIS shell (Apple Silicon path).
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Install chezmoi, then pull + apply these dotfiles straight from GitHub.
#    This lays down ~/.zshrc, ~/.config/*, the Brewfile, lazygit config, etc.
brew install chezmoi
chezmoi init --apply vebrasmusic

# 4. Install every app + CLI from the Brewfile (AeroSpace, Ghostty, Neovim,
#    lazygit, go tooling, ...). Takes the longest — it's downloading everything.
brew bundle --file="$HOME/.config/homebrew/Brewfile"

# 5. Store your Anthropic API key in the macOS Keychain (see "Keychain" below).
#    Replace the placeholder with your real key.
security add-generic-password -a "$USER" -s anthropic-api-key -w 'sk-ant-REPLACE_ME'

# 6. Install the EXACT pinned Neovim plugins (from lazy-lock.json).
nvim --headless "+Lazy! restore" +qa
```

Then quit Terminal and open **Ghostty** — you're running the configured setup.

### Post-install manual steps

- **AeroSpace Accessibility permission (required).** The first time AeroSpace runs, macOS
  prompts for Accessibility access — allow it. If you missed the prompt: System Settings →
  Privacy & Security → Accessibility → enable **AeroSpace**. Without this, tiling/hotkeys
  do nothing. AeroSpace is set to start at login.
- **Node (optional).** `~/.zshrc` wires up `nvm` if present, but nvm isn't installed by
  default. Install it separately only if you need Node.

---

## Keychain: API keys for Neovim (avante)

The Neovim AI plugin **avante** ([config](dot_config/nvim/lua/plugins/avante.lua)) does **not**
store your API key in this repo (secrets never go in dotfiles). Instead it fetches the key
at runtime from the macOS Keychain via:

```
cmd:security find-generic-password -s anthropic-api-key -w
```

**On every new machine you must add the key once**, or Neovim throws:

```
failed to get key: (error code 44)
security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain.
```

Fix — store it once (survives reboots, encrypted by macOS):

```sh
security add-generic-password -a "$USER" -s anthropic-api-key -w 'sk-ant-REPLACE_ME'
```

Optional Moonshot provider:

```sh
security add-generic-password -a "$USER" -s moonshot-api-key -w 'sk-REPLACE_ME'
```

Verify it's stored:

```sh
security find-generic-password -s anthropic-api-key -w   # should print the key
```

---

## Neovim plugin pinning (avoiding surprise breakage)

Plugin versions are locked in [`dot_config/nvim/lazy-lock.json`](dot_config/nvim/lazy-lock.json),
which is committed to this repo. On a new machine, `:Lazy restore` (step 6 above) installs
**exactly** those commits — no surprise "latest" versions.

The background update checker is turned **off**
([`lazy.lua`](dot_config/nvim/lua/config/lazy.lua)) so nothing drifts on its own. (This is
what previously caused `nvim-treesitter-textobjects` to jump to its rewritten `main` branch
and break `<leader>gg`/treesitter.)

**To update plugins deliberately:**

```sh
# inside nvim
:Lazy update
```

Then commit the refreshed lock file so the new versions travel to your other machines:

```sh
chezmoi re-add ~/.config/nvim/lazy-lock.json
chezmoi cd
git add dot_config/nvim/lazy-lock.json && git commit -m "nvim: bump pinned plugins" && git push
```

If plugins ever get into a weird state, snap them back to the lock:

```sh
nvim --headless "+Lazy! restore" +qa
```

---

## Day-to-day chezmoi usage

Handy aliases (defined in [`dot_zshrc`](dot_zshrc)):

- `brew-install` — `brew bundle` from the tracked Brewfile.
- `chezmoi-sync` — reload `~/.zshrc` and run `brew-install`.

Typical edit loop:

```sh
chezmoi edit ~/.zshrc      # edit the source
chezmoi diff               # preview what would change on disk
chezmoi apply              # apply it
# then commit in the source repo:
chezmoi cd
git add -A && git commit -m "..." && git push
```
