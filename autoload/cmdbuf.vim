" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{
func! cmdbuf#load() "{{{
    runtime! plugin/cmdbuf.vim
endfunc "}}}


" Assumption: This function is called in normal mode.
func! cmdbuf#open(cmdtype, ...) "{{{
    let insert_str = a:0 != 0 ? a:1 : ''

    call s:set_up(a:cmdtype, insert_str)

    return ''    " for '<Plug>(cmdbuf-open-from-cmdline)'.
endfunc "}}}

" Assumption: This function is called in '<C-\>e'.
func! cmdbuf#open_from_cmdline(cmdtype) "{{{
    let keys = printf(
    \   "\<Esc>:\<C-u>call cmdbuf#open(%s, %s)\<CR>",
    \   string(a:cmdtype),
    \   string(getcmdline())
    \)
    call feedkeys(keys, 'n')
    return ''
endfunc "}}}

" Assumption: This function is called in normal mode.
func! cmdbuf#execute(cmdtype) "{{{
    for line in s:get_lines(a:cmdtype)
        call feedkeys(a:cmdtype . line . "\<CR>", 'n')
    endfor

    close!
endfunc "}}}

" Assumption: This function is called in normal mode.
func! cmdbuf#paste_to_cmdline(cmdtype) "{{{
    let lines = s:get_lines(a:cmdtype)
    let i = 0
    while i < len(lines)
        let line = lines[i]
        if i ==# 0
            call feedkeys(a:cmdtype . line, 'n')
        else
            call feedkeys(g:cmdbuf_multiline_separator . line, 'n')
        endif
        let i += 1
    endwhile

    close!
endfunc "}}}


func! s:set_up(cmdtype, insert_str) "{{{
    let BUF_NAME = '__command_buffer__'
    let winnr = bufwinnr(BUF_NAME)

    if winnr != -1    " Window is displayed.
        execute winnr . 'wincmd w'
        call s:insert_new_line('o', a:cmdtype, a:insert_str)
    elseif bufexists(BUF_NAME)    " Buffer exists but is not displayed.
        execute printf('%d%s', g:cmdbuf_buffer_size, g:cmdbuf_open_command)
        execute bufnr(BUF_NAME) . 'buffer'
        call s:insert_new_line('o', a:cmdtype, a:insert_str)
    else
        " Create (and jump to) buffer.
        execute printf('%d%s', g:cmdbuf_buffer_size, g:cmdbuf_open_command)
        " Name current buffer.
        file `=BUF_NAME`
        " Execute BufEnter autocmd.
        execute 'doautocmd BufEnter' BUF_NAME
        " Set misc. options.
        call s:set_up_options()
        call s:insert_new_line('A', a:cmdtype, a:insert_str)
    endif
endfunc "}}}

func! s:set_up_options() "{{{
    setlocal bufhidden=hide
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile
    setfiletype vim
endfunc "}}}

func! s:insert_new_line(jump, cmdtype, insert_str) "{{{
    call cursor(line('$'), 1)
    call feedkeys(printf('%s%s%s', a:jump, a:cmdtype, a:insert_str), 'n')
endfunc "}}}


func! s:get_lines(cmdtype) "{{{
    if a:cmdtype !=# ':'
        return [getline('$')]
    else
        let [first; rest] = map(s:get_range(a:cmdtype), 'getline(v:val)')
        let first = substitute(first, '^\s*:', '', '')
        return [first] + rest
    endif
endfunc "}}}

" Find first command of multi-line from last line.
func! s:get_range(cmdtype) "{{{
    let pos = getpos('.')
    call cursor(line('$'), 1)
    try
        let firstline = search('^\s*:', 'bcnW')
        let firstline = firstline != 0 ? firstline : line('$')
        return range(firstline, line('$'))
    finally
        call setpos('.', pos)
    endtry
endfunc "}}}
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
