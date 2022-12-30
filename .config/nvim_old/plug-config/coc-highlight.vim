
" To enable highlight current symbol on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <leader>cp :call CocAction('pickColor')<cr>
nnoremap <leader>cP :call CocAction('colorPresentation')<cr>

