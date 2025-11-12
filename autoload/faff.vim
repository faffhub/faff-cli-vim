" Faff vim plugin - Context-aware omnicompletion for ASTRO fields
" Provides intelligent completion for action, subject, tracker, role, and objective fields

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

        " Call faff field list to get completions (now includes all defined values)
        let cmd = faff_cmd . ' field list ' . field_name . ' --plain 2>/dev/null | tail -n +2'
        let lines = systemlist(cmd)

        " Filter based on what's already typed
        let matches = []
        for line in lines
            " Parse TSV output from 'faff field list'
            " - For trackers: Value, Name, Intents, Sessions, Logs
            " - For other fields: Value, Intents, Sessions, Logs
            let parts = split(line, '\t')
            if len(parts) == 0
                continue
            endif

            let value = parts[0]

            " For trackers, the second column is the name
            let name = ''
            if field_name == 'tracker' && len(parts) > 1
                let name = parts[1]
            endif

            if value =~ '^' . escape(a:base, '.*[]^$\')
                " For trackers with names, insert value + comment
                if field_name == 'tracker' && !empty(name)
                    call add(matches, {
                        \ 'word': '"' . value . '", # ' . name,
                        \ 'menu': name,
                        \ 'info': value . ' - ' . name
                        \ })
                else
                    call add(matches, {
                        \ 'word': value,
                        \ 'menu': '[' . field_name . ']',
                        \ 'info': value
                        \ })
                endif
            endif
        endfor

        return matches
    endif
endfunction
