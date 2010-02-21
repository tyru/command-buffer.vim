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
    let g:cmdbuf_buffer_size = 1
endif
if !exists('g:cmdbuf_open_command')
    let g:cmdbuf_open_command = 'new'
endif
if !exists('g:cmdbuf_multiline_separator')
    let g:cmdbuf_multiline_separator = ' | '
endif
" }}}

" Mappings {{{
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
\   <Plug>(cmdbuf-paste-to-cmdline)
\   <Esc>:<C-u>call cmdbuf#paste_to_cmdline()<CR>
nnoremap
\   <silent>
\   <Plug>(cmdbuf-paste-to-cmdline)
\   :<C-u>call cmdbuf#paste_to_cmdline()<CR>

for s:cmdtype in [':', '/', '?']
    execute
    \   'nnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-open-%s)', s:cmdtype)
    \   printf(':<C-u>call cmdbuf#open(%s)<CR>', string(s:cmdtype))

    execute
    \   'cnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-open-from-cmdline-%s)', s:cmdtype)
    \   printf('<C-\>e cmdbuf#open_from_cmdline(%s)<CR>', string(s:cmdtype))
endfor
unlet s:cmdtype


if !g:cmdbuf_no_default_mappings
    nmap g: <Plug>(cmdbuf-open-:)
    nmap g/ <Plug>(cmdbuf-open-/)
    nmap g? <Plug>(cmdbuf-open-?)

    cmap <C-g>: <Plug>(cmdbuf-open-from-cmdline-:)
    cmap <C-g>/ <Plug>(cmdbuf-open-from-cmdline-/)
    cmap <C-g>? <Plug>(cmdbuf-open-from-cmdline-?)
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

        nmap <buffer> <C-g><C-g>    <Plug>(cmdbuf-paste-to-cmdline)
        imap <buffer> <C-g><C-g>    <Plug>(cmdbuf-paste-to-cmdline)
    endfunc "}}}
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
