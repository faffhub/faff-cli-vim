" Detect Faff files in the Faff workspace
" Using 'set filetype=' to override built-in toml detection

" Match log files opened via faff log edit

" Detect files in FAFF_DIR (defaults to ~/.faff if not set)
augroup faff_workspace_detect
  autocmd!
  autocmd FileType toml call s:DetectFaffWorkspaceFile()
augroup END

function! s:DetectFaffWorkspaceFile()
  let faff_dir = fnamemodify(resolve(empty($FAFF_DIR) ? expand('~/.faff') : $FAFF_DIR), ':p')
  let current_file = resolve(expand('%:p'))
  if stridx(current_file, faff_dir . 'logs/') == 0
    set filetype=faff
  elseif stridx(current_file, faff_dir . 'plans/') == 0
    set filetype=faff
  endif
endfunction
