# Agent guide

Personal Neovim config for Linux, macOS, and Windows. It targets the latest stable
Neovim only: `init.lua` expects `0.12.6` and warns on mismatch, so do not add
backward-compatibility shims. Authoritative docs: https://neovim.io/doc/user/

## Structure

- `init.lua` is the only entrypoint. It requires modules in this order: `globals`,
  `options`, `custom-autocmd`, `mappings`, `plugin_specs`, `lsp_conf`,
  `diagnostic-conf`, `ui`. Keep this order; LSP setup depends on `plugin_specs`.
- `lua/plugin_specs.lua` is the lazy.nvim spec list and installs lazy.nvim itself
  on first launch. Plugins live under `stdpath("data")/lazy` (Windows:
  `%LOCALAPPDATA%\nvim-data\lazy`).
- Per-plugin setup goes in `lua/config/<name>.lua`; add the spec in
  `plugin_specs.lua` and load it with `require("config.<name>")`.
- Completion engine is selected by `completion_engine` in `plugin_specs.lua`
  (`blink` or `nvim-cmp`). Both configs exist, but only one spec set is loaded.
- LSP uses Neovim's built-in `vim.lsp.config`/`vim.lsp.enable`, not
  `lspconfig.setup`. Enable servers and map their executables in
  `enabled_lsp_servers` in `lua/lsp_conf.lua`; per-server settings are tables
  returned from `after/lsp/<server>.lua`.
- Filetype overrides belong in `after/ftplugin/`; Vimscript helpers live in
  `plugin/*.vim` and `autoload/`. Lua user commands live in `plugin/command.lua`,
  which is auto-sourced (unlike files under `lua/`).
- `ginit.vim` is only for GUI clients. `my_snippets/` contains UltiSnips snippets.
  The leader key is `,` (set in `lua/globals.lua`).
- `plugin/abbrev.vim` intentionally contains misspellings, and `spell/**` is a
  word list; both are excluded in `_typos.toml`.

## Verification

- `stylua --check .` is the only CI check; it runs when Lua files change.
  Format with `stylua .`. Config: 100 columns, 2 spaces, double quotes, Unix
  line endings.
- `pre-commit run --all-files` runs trailing-whitespace, EOF, `typos`, and the
  local stylua check. The stylua hook uses `language: system`, so stylua must be
  installed separately on `PATH`.
- There is no test, build, or lint suite and no package manifest.
- `lazy-lock.json` is intentionally gitignored; do not commit it.
- Startup expects `stdpath("config")/.venv/bin/python3` with `pynvim`
  (`lua/globals.lua`); otherwise it prints "Python provider missing". Missing
  non-optional LSP executables (for example `gopls`) also warn at startup.
