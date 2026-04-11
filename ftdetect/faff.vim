" Detect Faff files in the Faff workspace
" Using 'set filetype=' to override built-in toml detection
"
" Root directory resolution order:
"   1. g:faff_root (set in your Neovim config)
"   2. $FAFF_DIR environment variable
"   3. ~/.faff (default)

augroup faff_workspace_detect
  autocmd!
  autocmd FileType toml call s:DetectFaffWorkspaceFile()
augroup END

function! s:DetectFaffWorkspaceFile()
  if exists('g:faff_root') && !empty(g:faff_root)
    let raw_dir = g:faff_root
  elseif !empty($FAFF_DIR)
    let raw_dir = $FAFF_DIR
  else
    let raw_dir = expand('~/.faff')
  endif

  let faff_dir = fnamemodify(resolve(raw_dir), ':p')
  let current_file = resolve(expand('%:p'))

  if stridx(current_file, faff_dir . 'logs/') == 0
    set filetype=faff
  elseif stridx(current_file, faff_dir . 'plans/') == 0
    set filetype=faff
  endif
endfunction
