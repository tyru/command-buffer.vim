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
if !exists('g:cmdbuf_debug')
    let g:cmdbuf_debug = 0
endif
if !exists('g:cmdbuf_no_default_mappings')
    let g:cmdbuf_no_default_mappings = 0
endif
if !exists('g:cmdbuf_no_default_autocmd')
    let g:cmdbuf_no_default_autocmd = 0
endif
if !exists('g:cmdbuf_buffer_name')
    let g:cmdbuf_buffer_name = '__command_buffer__'
endif
if !exists('g:cmdbuf_buffer_size')
    let g:cmdbuf_buffer_size = 1
endif
if !exists('g:cmdbuf_open_command')
    let g:cmdbuf_open_command = 'new'
endif
" }}}

" Mappings {{{
nnoremap
\   <silent>
\   <Plug>(cmdbuf-open)
\   :<C-u>call cmdbuf#open()<CR>

inoremap
\   <silent>
\   <Plug>(cmdbuf-close)
\   <Esc>:<C-u>close<CR>
nnoremap
\   <silent>
\   <Plug>(cmdbuf-close)
\   :<C-u>close<CR>

for s:cmdtype in [':', '/', '?']
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
    \   printf('<Plug>(cmdbuf-paste-to-cmdline-%s)', s:cmdtype)
    \   printf('<Esc>:<C-u>call cmdbuf#paste_to_cmdline(%s)<CR>', string(s:cmdtype))
    execute
    \   'nnoremap'
    \   '<silent>'
    \   printf('<Plug>(cmdbuf-paste-to-cmdline-%s)', s:cmdtype)
    \   printf(':<C-u>call cmdbuf#paste_to_cmdline(%s)<CR>', string(s:cmdtype))
endfor
unlet s:cmdtype

cnoremap
\   <silent>
\   <Plug>(cmdbuf-open-from-cmdline)
\   <C-\>e cmdbuf#open_from_cmdline()<CR>


if !g:cmdbuf_no_default_mappings
    nmap g: <Plug>(cmdbuf-open)
endif
" }}}

" AutoCommand {{{
if !g:cmdbuf_no_default_autocmd
    augroup cmdbuf
        autocmd!

        execute 'autocmd BufEnter' g:cmdbuf_buffer_name 'call s:set_up_mappings()'
    augroup END

    " Map if rhs has not mapped.
    func! s:map(modes, options, remap_p, lhs, rhs) "{{{
        for mode in split(a:modes, '\zs')
            if !hasmapto(a:rhs, mode)
                execute
                \   printf('%s%smap', mode, (a:remap_p ? '' : 'nore'))
                \   a:options
                \   a:lhs
                \   a:rhs
            endif
        endfor
    endfunc "}}}

    func! s:set_up_mappings() "{{{
        call s:map('n', '<buffer>', 1, '<Esc>', '<Plug>(cmdbuf-close)')

        call s:map('ni', '<buffer>', 1, '<CR>', '<Plug>(cmdbuf-execute-:)')
        call s:map('ni', '<buffer>', 1, '<C-CR>', '<Plug>(cmdbuf-execute-/)')
        call s:map('ni', '<buffer>', 1, '<S-CR>', '<Plug>(cmdbuf-execute-?)')

        call s:map('ni', '<buffer>', 1, '<C-g>:', '<Plug>(cmdbuf-paste-to-cmdline-:)')
        call s:map('ni', '<buffer>', 1, '<C-g>/', '<Plug>(cmdbuf-paste-to-cmdline-/)')
        call s:map('ni', '<buffer>', 1, '<C-g>?', '<Plug>(cmdbuf-paste-to-cmdline-?)')
    endfunc "}}}
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
