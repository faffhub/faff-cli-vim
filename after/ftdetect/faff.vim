" Detect Faff files in the Faff workspace
" Using 'set filetype=' to override built-in toml detection
" (placed in after/ftdetect/ to run after built-in detection)

" Match plan files in Faff/plans/
autocmd BufRead,BufNewFile **/Faff/plans/*.toml set filetype=faff
autocmd BufRead,BufNewFile **/Faff/plans/*.json set filetype=faff

" Match log files in Faff/logs/
autocmd BufRead,BufNewFile **/Faff/logs/*.toml set filetype=faff

" Match temporary files created by faff CLI (faff intent edit, etc.)
autocmd BufRead,BufNewFile *.faff.toml set filetype=faff
