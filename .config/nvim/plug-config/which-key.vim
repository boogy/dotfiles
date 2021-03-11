let g:which_key_map = {}
let g:which_key_sep = '➜'

call which_key#register('<Space>', "g:which_key_map")
" call which_key#register('<Leader>', "g:which_key_map")

nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual ','<CR>

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'

" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search'                             ,
      \ '/' : [':History/'     , 'history']            ,
      \ ';' : [':Commands'     , 'commands']           ,
      \ 'b' : [':BLines'       , 'current buffer']     ,
      \ 'B' : [':Buffers'      , 'open buffers']       ,
      \ 'c' : [':Commits'      , 'commits']            ,
      \ 'C' : [':BCommits'     , 'buffer commits']     ,
      \ 'f' : [':Files'        , 'files']              ,
      \ 'g' : [':GFiles'       , 'git files']          ,
      \ 'G' : [':GFiles?'      , 'modified git files'] ,
      \ 'h' : [':History'      , 'file history']       ,
      \ 'H' : [':History:'     , 'command history']    ,
      \ 'l' : [':Lines'        , 'lines']              ,
      \ 'm' : [':Marks'        , 'marks']              ,
      \ 'M' : [':Maps'         , 'normal maps']        ,
      \ 'p' : [':Helptags'     , 'help tags']          ,
      \ 'P' : [':Tags'         , 'project tags']       ,
      \ 's' : [':Snippets'     , 'snippets']           ,
      \ 'S' : [':Colors'       , 'color schemes']      ,
      \ 't' : [':Rg'           , 'text Rg']            ,
      \ 'T' : [':BTags'        , 'buffer tags']        ,
      \ 'w' : [':Windows'      , 'search windows']     ,
      \ 'y' : [':Filetypes'    , 'file types']         ,
      \ 'z' : [':FZF'          , 'FZF']                ,
      \ }

" Windows mappings
let g:which_key_map['w'] = {
      \ 'name' : '+windows'                            ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : ['resize +5'  , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : ['resize -5'  , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ }

" Terminal mappings
let g:which_key_map.t = {
      \ 'name' : '+terminal'                                                  ,
      \ ';' : [':FloatermNew --wintype=popup --height=6'        , 'terminal'] ,
      \ 'f' : [':FloatermNew fzf'                               , 'fzf']      ,
      \ 'p' : [':FloatermNew python'                            , 'python']   ,
      \ 'r' : [':FloatermNew ranger'                            , 'ranger']   ,
      \ 't' : [':FloatermToggle'                                , 'toggle']   ,
      \ 'v' : [':FloatermNew vifm'                              , 'ytop']     ,
      \ }

" cp is for file configurations
let g:which_key_map.c = {
  \ 'name'  : 'copy-utils'                                                          ,
  \ 'r'     : [":let @+ = expand('%')"                      , 'copy-relative-path'] ,
  \ 'n'     : [":let @+ = expand('%:t')"                    , 'copy-file-name']     ,
  \ 'p'     : [":let @+ = expand('%:p')"                    , 'copy-full-path']     ,
  \ }

" GitGutter shortcuts
let g:which_key_map['gi'] = {
  \ 'name'  : 'Git Gutter'                                                               ,
  \ 't'     : [":GitGutterToggle"                   , 'GitGutter Toggle On/Off']         ,
  \ 's'     : [":GitGutterSignsToggle"              , 'Turn the signs On and Off']       ,
  \ 'h'     : [":GitGutterLineHighlightsToggle"     , 'Line highlighting On/Off']        ,
  \ 'n'     : [":GitGutterLineNrHighlightsToggle"   , 'Line number highlighting On/Off'] ,
  \ 'N'     : ["<Plug>(GitGutterNextHunk)"          , 'Git Gutter Next Hunk']            ,
  \ 'P'     : ["<Plug>(GitGutterPrevHunk)"          , 'Git Gutter Previous Hunk']        ,
  \ 'S'     : ["<Plug>(GitGutterStageHunk)"         , 'GitGutter Stage Hunk']            ,
  \ 'U'     : ["<Plug>(GitGutterUndoHunk)"          , 'GitGutter Undo Hunk']             ,
  \ 'p'     : ["<Plug>(GitGutterPreviewHunk)"       , 'GitGutter Preview Hunk']          ,
  \ }


" VIM LSP mappings
let g:which_key_map['l'] = {
  \ 'name'  : 'VIM LSP server'                                           ,
  \ 'F'     : [":LspDocumentFormat"         , 'Document Format']         ,
  \ 'f'     : [":LspDocumentFold"           , 'Document Fold']           ,
  \ 'd'     : [":LspPeekDeclaration."       , 'Peek Declaration']        ,
  \ 'D'     : [":LspDeclaration."           , 'Declaration']             ,
  \ 'r'     : [":LspRename"                 , 'Rename']                  ,
  \ 'W'     : [":LspWorkspaceSymbolSearch"  , 'Workspace Symbol Search'] ,
  \ }

" CoCCommand for python
let g:which_key_map['y'] = {
  \ 'name'  : 'Python CocCommands'                       ,
  \ 'i'     : [":CocCommand pyright.organizeimports"     , 'Organize python imports'] ,
  \ 'l'     : [":CoCCommand python.runLinting"           , 'Run linting']             ,
  \ 'a'     : [":CoCCommand pyright.addoptionalforparam" , 'Run linting']             ,
  \ 'r'     : [":CoCCommand pyright.restartserver"       , 'Restart Python Server']   ,
  \ }

" ALE mappings
let g:which_key_map['A'] = {
  \ 'name'  : 'ALE mappings'                                      ,
  \ 'e'     : [":ALEEnable"                 , 'Enable ALE']       ,
  \ 'D'     : [":ALEDisable"                , 'Disable ALE']      ,
  \ 'l'     : [":ALELint"                   , 'Lint buffer']      ,
  \ 'p'     : [":ALEPrevious"               , "Previous"]         ,
  \ 'n'     : [":ALENext"                   , "Next"]             ,
  \ 'L'     : [":ALELintStop"               , 'Stop Linter']      ,
  \ 'g'     : [":ALEGoToDefinition"         , 'Go To Definition'] ,
  \ 's'     : [":ALEFixSuggest"             , 'Fix Suggest']      ,
  \ 'd'     : [":ALEGoToDefinition"         , 'Go to Definition'] ,
  \ 'r'     : [":ALERename"                 , 'Rename']           ,
  \ }

