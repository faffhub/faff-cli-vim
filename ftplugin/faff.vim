" Faff filetype plugin
" Sets up omnicompletion and Telescope picker for faff session fields

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

" Set up omnicompletion
setlocal omnifunc=faff#Complete

" Enable completion menu
setlocal completeopt+=menu,menuone

" Telescope picker (Ctrl-F in normal and insert mode)
if has('nvim')
  nnoremap <buffer> <C-f> <cmd>lua require('faff.picker').pick_field()<CR>
  inoremap <buffer> <C-f> <cmd>lua require('faff.picker').pick_field()<CR>
endif

" User can also trigger omnicompletion with Ctrl-X Ctrl-O
