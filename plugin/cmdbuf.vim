" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_cmdbuf') && g:loaded_cmdbuf
    finish
endif
let g:loaded_cmdbuf = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Global Variables {{{
if !exists('g:cmdbuf_no_default_mappings')
    let g:cmdbuf_no_default_mappings = 0
endif
if !exists('g:cmdbuf_no_default_autocmd')
    let g:cmdbuf_no_default_autocmd = 0
endif
if !exists('g:cmdbuf_buffer_size')
    let g:cmdbuf_buffer_size = 5
endif
if !exists('g:cmdbuf_open_command')
    let g:cmdbuf_open_command = 'new'
endif

if !exists('g:cmdbuf_multiline_separator')
    let g:cmdbuf_multiline_separator = {}
endif
call extend(
\   g:cmdbuf_multiline_separator,
\   {
\       ':' : ' | ',
\       '/' : ' ',
\       '?' : ' ',
\   },
\   'keep'
\)
" }}}

" Mappings {{{

" From cmdbuf.
inoremap
\   <silent>
\   <Plug>(cmdbuf-close)
\   <Esc>:<C-u>close<CR>
nnoremap
\   <silent>
\   <Plug>(cmdbuf-close)
\   :<C-u>close<CR>

inoremap
\   <silent>
\   <Plug>(cmdbuf-execute)
\   <Esc>:<C-u>call cmdbuf#execute()<CR>
nnoremap
\   <silent>
\   <Plug>(cmdbuf-execute)
\   :<C-u>call cmdbuf#execute()<CR>

inoremap
\   <silent>
\   <Plug>(cmdbuf-paste)
\   <Esc>:<C-u>call cmdbuf#paste()<CR>
nnoremap
\   <silent>
\   <Plug>(cmdbuf-paste)
\   :<C-u>call cmdbuf#paste()<CR>

for s:cmdtype in [':', '/', '?']
    " From cmdbuf.
    execute
    \   'inoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-execute-%s)', s:cmdtype)
    \   printf('<Esc>:<C-u>call cmdbuf#execute(%s)<CR>', string(s:cmdtype))
    execute
    \   'nnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-execute-%s)', s:cmdtype)
    \   printf(':<C-u>call cmdbuf#execute(%s)<CR>', string(s:cmdtype))

    execute
    \   'inoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-paste-%s)', s:cmdtype)
    \   printf('<Esc>:<C-u>call cmdbuf#paste(%s)<CR>', string(s:cmdtype))
    execute
    \   'nnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-paste-%s)', s:cmdtype)
    \   printf(':<C-u>call cmdbuf#paste(%s)<CR>', string(s:cmdtype))

    " From normal mode, out of cmdbuf.
    execute
    \   'nnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-open-%s)', s:cmdtype)
    \   printf(':<C-u>call cmdbuf#open(%s)<CR>', string(s:cmdtype))

    " From command-line.
    execute
    \   'cnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-open-from-%s)', s:cmdtype)
    \   printf('<C-\>e cmdbuf#open_from(%s)<CR>', string(s:cmdtype))
endfor
unlet s:cmdtype


if !g:cmdbuf_no_default_mappings
    nmap g: <Plug>(cmdbuf-open-:)
    nmap g/ <Plug>(cmdbuf-open-/)
    nmap g? <Plug>(cmdbuf-open-?)

    cmap <C-g>: <Plug>(cmdbuf-open-from-:)
    cmap <C-g>/ <Plug>(cmdbuf-open-from-/)
    cmap <C-g>? <Plug>(cmdbuf-open-from-?)
endif
" }}}

" AutoCommand {{{
if !g:cmdbuf_no_default_autocmd
    augroup cmdbuf
        autocmd!

        autocmd BufEnter __command_buffer__ call s:set_up_mappings()
    augroup END

    func! s:set_up_mappings() "{{{
        nmap <buffer> <Esc>     <Plug>(cmdbuf-close)

        nmap <buffer> <CR>      <Plug>(cmdbuf-execute)
        imap <buffer> <CR>      <Plug>(cmdbuf-execute)
        nmap <buffer> <C-o>:    <Plug>(cmdbuf-execute-:)
        imap <buffer> <C-o>:    <Plug>(cmdbuf-execute-:)
        nmap <buffer> <C-o>/    <Plug>(cmdbuf-execute-/)
        imap <buffer> <C-o>/    <Plug>(cmdbuf-execute-/)
        nmap <buffer> <C-o>?    <Plug>(cmdbuf-execute-?)
        imap <buffer> <C-o>?    <Plug>(cmdbuf-execute-?)

        nmap <buffer> <C-g><C-g>    <Plug>(cmdbuf-paste)
        imap <buffer> <C-g><C-g>    <Plug>(cmdbuf-paste)
        nmap <buffer> <C-g>:        <Plug>(cmdbuf-paste-:)
        imap <buffer> <C-g>:        <Plug>(cmdbuf-paste-:)
        nmap <buffer> <C-g>/        <Plug>(cmdbuf-paste-/)
        imap <buffer> <C-g>/        <Plug>(cmdbuf-paste-/)
        nmap <buffer> <C-g>?        <Plug>(cmdbuf-paste-?)
        imap <buffer> <C-g>?        <Plug>(cmdbuf-paste-?)
    endfunc "}}}
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
