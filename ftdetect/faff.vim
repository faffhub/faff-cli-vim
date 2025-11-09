" Detect Faff files in the Faff workspace
" Match plan files in Faff/plans/
autocmd BufRead,BufNewFile **/Faff/plans/*.toml setfiletype faff
autocmd BufRead,BufNewFile **/Faff/plans/*.json setfiletype faff

" Match log files in Faff/logs/
autocmd BufRead,BufNewFile **/Faff/logs/*.toml setfiletype faff

" Match temporary files created by faff CLI (faff intent edit, etc.)
autocmd BufRead,BufNewFile *.faff.toml setfiletype faff
