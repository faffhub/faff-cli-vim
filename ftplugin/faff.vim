" Faff filetype plugin
" Sets up omnicompletion for ASTRO fields (legacy - prefer Telescope picker)

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

" Set up omnicompletion
setlocal omnifunc=faff#Complete

" Enable completion menu
setlocal completeopt+=menu,menuone

" Add some helpful key mappings (optional)
" User can trigger completion with Ctrl-X Ctrl-O
" Or set up more automatic triggers if desired
