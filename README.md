# faff-cli-neovim

Neovim plugin for [Faff](https://github.com/faffhub/faff-cli) — fuzzy-searchable field completion when editing log files.

**Requires Neovim (v0.10+) and [Telescope](https://github.com/nvim-telescope/telescope.nvim).**

## What it does

When you run `faff log edit`, the log file opens in Neovim. This plugin:

- Detects that you're editing a Faff log file and sets the `faff` filetype
- Binds `Ctrl-F` to a Telescope picker for fuzzy-searching field values
- Calls `faff field list <field>` to pull live vocabulary from your workspace
- Inserts the selected value, with tracker IDs annotated with their human-readable name

## Installation

### lazy.nvim

```lua
{
  'faffhub/faff-cli-neovim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
}
```

No further configuration needed if `faff` is on your `$PATH` and your workspace is at `~/.faff` or `$FAFF_DIR`.

## Usage

1. Run `faff log edit` to open today's log
2. Move the cursor to a session field line, e.g.:
   ```toml
   role = ""
   impact = ""
   mode = ""
   subject = ""
   trackers = []
   ```
3. Press `Ctrl-F` (normal or insert mode)
4. Fuzzy-search and press Enter to insert

For tracker fields, the picker shows the tracker name prominently and inserts the ID with a comment:
```toml
trackers = ["element:2633285", # Customer Support
```

## Configuration

All configuration is optional. Set these in your lazy.nvim `config` function or anywhere in your Neovim config.

### `vim.g.faff_root`

Path to your Faff workspace root. Use this if your workspace is not at `~/.faff` and you don't have `$FAFF_DIR` set in your environment (e.g. when launching Neovim from a GUI).

```lua
vim.g.faff_root = '/path/to/your/faff/workspace'
```

Resolution order: `g:faff_root` → `$FAFF_DIR` → `~/.faff`

### `vim.g.faff_command`

Path to the `faff` executable. Use this if `faff` is installed in a virtualenv or otherwise not on your `$PATH`.

```lua
vim.g.faff_command = '/Users/tom/.virtualenvs/faff/bin/faff'
```

### Custom keybinding

The default `Ctrl-F` binding is set in `ftplugin/faff.vim`. To override it, add to your config:

```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'faff',
  callback = function()
    vim.keymap.set({ 'n', 'i' }, '<leader>ff', function()
      require('faff.picker').pick_field()
    end, { buffer = true, desc = 'Pick faff session field value' })
  end,
})
```

## Supported fields

| Field | Description |
|-------|-------------|
| `role` | Your role for the session |
| `impact` | The impact/objective |
| `mode` | The type of work (e.g. coding, reviewing) |
| `subject` | What you're working on |
| `trackers` | Issue/ticket references |
