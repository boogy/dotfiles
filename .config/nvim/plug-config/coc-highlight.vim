
" To enable highlight current symbol on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <leader>cc :call CocAction('pickColor')<cr>
nnoremap <leader>cp :call CocAction('colorPresentation')<cr>

