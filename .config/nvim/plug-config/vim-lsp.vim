"
" Plugin Commands: https://github.com/prabirshrestha/vim-lsp#supported-commands
"

" ########################################################
" Python language server
" ########################################################

" Highlight references to the symbol under the cursor (enabled by default)
let g:lsp_document_highlight_enabled = 0

" Disable diagnostic support
let g:lsp_diagnostics_enabled = 0


" ########################################################
" Python language server
" ########################################################
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif


" ########################################################
" Ansible language server
" ########################################################
if executable('ansible-lint')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ansible-lint',
        \ 'cmd': {server_info->['ansible-lint']},
        \ 'allowlist': ['yaml', 'ansible', 'yaml.ansible'],
        \ })
endif

" ########################################################
" Terraform language server
" ########################################################
if executable('terraform-ls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'terraform-ls',
        \ 'cmd': {server_info->['terraform-ls', 'serve']},
        \ 'whitelist': ['terraform'],
        \ })
endif


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" let the server do the folding
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

" disable folding globally
let g:lsp_fold_enabled = 0
