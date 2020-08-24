let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"

let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

xmap <c-c><c-c> <Plug>SlimeRegionSend
nmap <c-c><c-c> <Plug>SlimeParagraphSend
nmap <c-c>v     <Plug>SlimeConfig
