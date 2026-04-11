" Detect Faff files in the Faff workspace
" Using 'set filetype=' to override built-in toml detection

" Match log files opened via faff log edit

" Detect files in FAFF_DIR (defaults to ~/.faff if not set)
augroup faff_workspace_detect
  autocmd!
  autocmd BufReadPost *.toml,*.json call s:DetectFaffWorkspaceFile()
augroup END

function! s:DetectFaffWorkspaceFile()
  " Determine FAFF_DIR: use $FAFF_DIR if set, otherwise default to ~/.faff
  let faff_dir = empty($FAFF_DIR) ? expand('~/.faff') : $FAFF_DIR

  " Normalize paths for comparison
  let faff_dir = fnamemodify(resolve(faff_dir), ':p')
  let current_file = expand('%:p')

  " Check if file is in logs/ or plans/ subdirectory of FAFF_DIR
  if stridx(current_file, faff_dir . 'logs/') == 0
    set filetype=faff
  elseif stridx(current_file, faff_dir . 'plans/') == 0
    set filetype=faff
  endif
endfunction
