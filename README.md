# Faff Neovim Plugin

Fuzzy-searchable field completion for editing Faff plan files in Neovim.

**Note:** This plugin requires Neovim and Telescope. It will not work in regular Vim.

## Features

- Fuzzy-search ASTRO field values (action, subject, tracker, role, objective)
- Uses `faff field list` to pull real vocabulary from your Faff workspace
- Context-aware: detects which field you're editing
- Shows tracker names prominently for easy selection
- Inserts tracker IDs with human-readable comments

## Installation

### Using lazy.nvim (Recommended)

Add to your Neovim config:

```lua
{
  'faffhub/faff-cli-vim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  init = function()
    -- Set up filetype detection for .faff.toml files
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
      pattern = '*.faff.toml',
      callback = function()
        vim.bo.filetype = 'faff'
      end,
    })

    -- Set up keybindings for Telescope field picker
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'faff',
      callback = function()
        vim.keymap.set({'n', 'i'}, '<C-f>', function()
          require('faff.picker').pick_field()
        end, { buffer = true, desc = 'Pick ASTRO field value' })
      end,
    })
  end,
  config = function()
    vim.g.faff_command = '/path/to/your/faff'  -- Update this path
  end,
}
```

## Usage

The plugin automatically activates when editing:
- Plan files: `Faff/plans/*.toml` or `Faff/plans/*.json`
- Log files: `Faff/logs/*.toml` (via `faff log edit`)
- Temporary intent files ending in `.faff.toml` (via `faff intent edit`, `faff intent derive`)

### Using the Telescope Picker

1. Position cursor on an ASTRO field line:
   ```toml
   role = ""
   trackers = []
   ```

2. Press `Ctrl-F` (works in both normal and insert mode)

3. Telescope opens with a fuzzy-searchable list:
   - For **trackers**: Shows tracker name prominently with ID
   - For **other fields**: Shows value and usage statistics
   - Type to fuzzy-search and filter in real-time

4. Select with Enter:
   - **Trackers**: Inserts `"element:12345", # Customer Name`
   - **Other fields**: Inserts just the value

### Example

When completing a tracker field:
```toml
trackers = [
```

Press `Ctrl-F`, type "customer", select from list, and it inserts:
```toml
trackers = ["element:2633285", # Customer Support
```

## Supported Fields

- `action = "..."`
- `subject = "..."`
- `tracker` in `trackers = [ "...",]`
- `role = "..."`
- `objective = "..."`

## How It Works

The plugin:
1. Detects `.faff.toml` files and sets filetype to `faff`
2. Binds `Ctrl-F` to open the Telescope picker
3. When triggered, detects which ASTRO field you're editing
4. Calls `faff field list <field> --plain` to get ALL values (used + unused)
5. For trackers, shows tracker names from plan definitions
6. Opens Telescope for fuzzy searching
7. Inserts selected value with comments for trackers

## Configuration

### Custom Faff Command Path

If `faff` is not in your `$PATH` (e.g., installed in a Python venv), you can specify the full path:

```lua
vim.g.faff_command = '/Users/tom/.virtualenvs/faff/bin/faff'
```

If not set, defaults to `faff` (assumes it's on your PATH).

### Custom Keybinding

To change the keybinding from `Ctrl-F`, update the keymap in your config:

```lua
vim.keymap.set({'n', 'i'}, '<leader>ff', function()  -- Use leader+ff instead
  require('faff.picker').pick_field()
end, { buffer = true, desc = 'Pick ASTRO field value' })
```

## Requirements

- Neovim (tested on v0.10+)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- `faff` CLI must be available (either in `$PATH` or configured via `g:faff_command`)
- Your current working directory must be a Faff workspace (or set explicitly)
