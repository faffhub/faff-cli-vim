" Faff vim plugin - Context-aware omnicompletion for ROAST fields
" Provides intelligent completion for role, objective, action, subject, and tracker fields

function! faff#Complete(findstart, base) abort
    if a:findstart
        " Find the start of the word to complete
        let line = getline('.')
        let start = col('.') - 1

        " Move back to the start of the value (after the = and optional quote)
        while start > 0 && line[start - 1] =~ '[a-zA-Z0-9:/_-]'
            let start -= 1
        endwhile

        return start
    else
        " Get completion matches
        let line = getline('.')

        " Detect which field we're completing
        " Match lines like: role = "element:head-of-customer-success"
        "                   objective = "element:resolving-operational-issues"
        let field_match = matchlist(line, '^\s*\(role\|objective\|action\|subject\|trackers\)\s*=')

        if empty(field_match)
            return []
        endif

        let field_name = field_match[1]

        " Trackers are special - they're in an array
        if field_name == 'trackers'
            let field_name = 'tracker'
        endif

        " Get the faff command (configurable via g:faff_command)
        let faff_cmd = get(g:, 'faff_command', 'faff')

        " Call faff field list to get completions
        let cmd = faff_cmd . ' field list ' . field_name . ' --plain 2>/dev/null | tail -n +2 | cut -f1'
        let values = systemlist(cmd)

        " Filter based on what's already typed
        let matches = []
        for value in values
            if value =~ '^' . escape(a:base, '.*[]^$\')
                call add(matches, {
                    \ 'word': value,
                    \ 'menu': '[' . field_name . ']',
                    \ 'info': value
                    \ })
            endif
        endfor

        return matches
    endif
endfunction
