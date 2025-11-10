# Faff Vim Plugin

Context-aware omnicompletion for editing Faff plan files in Vim.

## Features

- Autocomplete ROAST field values (role, objective, action, subject, tracker)
- Uses `faff field list` to pull real vocabulary from your Faff workspace
- Context-aware: only shows roles when completing `role = ""`, etc.

## Installation

### Using vim-plug

Add to your `.vimrc`:

```vim
Plug 'faffhub/faff-cli-vim'
```

Then run `:PlugInstall`.

### Using Vundle

```vim
Plugin 'faffhub/faff-cli-vim'
```

Then run `:PluginInstall`.

### Using Pathogen

```bash
cd ~/.vim/bundle
git clone https://github.com/faffhub/faff-cli-vim.git
```

### Manual Installation

```bash
git clone https://github.com/faffhub/faff-cli-vim.git
cd faff-cli-vim
cp -r autoload ftdetect ftplugin ~/.vim/
```

## Usage

The plugin automatically activates when editing:
- Plan files: `Faff/plans/*.toml` or `Faff/plans/*.json`
- Log files: `Faff/logs/*.toml` (via `faff log edit`)
- Temporary intent files (via `faff intent edit`, `faff intent derive`)

### Example Usage

1. Type a field name and equals sign:
   ```
   role = "
   ```

2. Press `Ctrl-X Ctrl-O` to trigger omnicompletion

3. Vim will show completions from your actual vocabulary:
   ```
   element:head-of-customer-success
   element:team-lead
   element:solutions-architect
   ```

4. Use arrow keys or `Ctrl-N`/`Ctrl-P` to navigate, Enter to select

## Supported Fields

- `role = "..."`
- `objective = "..."`
- `action = "..."`
- `subject = "..."`
- `trackers = [ "...",]`

## How It Works

The plugin:
1. Detects files in `Faff/plans/` directories
2. Sets the filetype to `faff`
3. Enables omnicompletion via `faff#Complete()`
4. When triggered, parses the current line to detect which field you're editing
5. Calls `faff field list <field> --plain` to get real vocabulary
6. Filters based on what you've already typed
7. Returns matches with the field name shown in brackets

## Configuration

### Custom Faff Command Path

If `faff` is not in your `$PATH` (e.g., installed in a Python venv), you can specify the full path:

**For Neovim (init.lua):**
```lua
vim.g.faff_command = '/Users/tom/Projects/faff-cli/.venv/bin/faff'
```

**For Vim (vimrc):**
```vim
let g:faff_command = '/Users/tom/Projects/faff-cli/.venv/bin/faff'
```

If not set, defaults to `faff` (assumes it's on your PATH).

## Requirements

- `faff` CLI must be available (either in `$PATH` or configured via `g:faff_command`)
- Your current working directory must be a Faff workspace (or set explicitly)
