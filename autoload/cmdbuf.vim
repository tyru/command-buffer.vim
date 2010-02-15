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
func! cmdbuf#open(...) "{{{
    let insert_str = a:0 != 0 ? a:1 : ''

    call s:create_jump_buffer()
    call s:set_up_buffer()

    if insert_str != ''
        call setline(1, insert_str)
    endif
    call feedkeys('A', 'n')

    return ''    " for '<Plug>(cmdbuf-open-from-cmdline)'.
endfunc "}}}

" Assumption: This function is called in '<C-\>e'.
func! cmdbuf#open_from_cmdline() "{{{
    let keys = printf("\<Esc>:\<C-u>call cmdbuf#open(%s)\<CR>", string(getcmdline()))
    call feedkeys(keys, 'n')
    return ''
endfunc "}}}

" Assumption: This function is called in normal mode.
func! cmdbuf#execute(cmdtype) "{{{
    for lnum in range(1, line('$'))
        call s:insert_cmdline(a:cmdtype, getline(lnum) . "\<CR>")
    endfor
    close!
endfunc "}}}

" Assumption: This function is called in normal mode.
func! cmdbuf#paste_to_cmdline(cmdtype) "{{{
    for lnum in range(1, line('$'))
        call s:insert_cmdline(a:cmdtype, getline(lnum))
    endfor
    close!
endfunc "}}}


func! s:insert_cmdline(cmdtype, insert_str) "{{{
    if a:cmdtype =~# '^[:/?]$'
        call feedkeys(a:cmdtype . a:insert_str, 'n')
    else
        call s:warnf('unknown cmdtype (%s).', a:cmdtype)
    endif
endfunc "}}}

func! s:create_jump_buffer() "{{{
    let winnr = bufwinnr(g:cmdbuf_buffer_name)
    if winnr == -1
        " Create (and jump to) buffer.
        execute printf('%d%s', g:cmdbuf_buffer_size, g:cmdbuf_open_command)
        " Name current buffer.
        file `=g:cmdbuf_buffer_name`
        " Execute BufEnter autocmd.
        execute 'doautocmd BufEnter' g:cmdbuf_buffer_name
    else
        execute winnr . 'wincmd w'
    endif
endfunc "}}}

func! s:set_up_buffer() "{{{
    setlocal bufhidden=wipe
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile
endfunc "}}}
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
