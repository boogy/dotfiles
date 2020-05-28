" ANSIBLE configurations
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_normal_keywords_highlight = 'Constant'
let g:ansible_with_keywords_highlight = 'Constant'
let g:ansible_template_syntaxes = { '*.rb.j2': 'ruby' }

au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */playbooks/*.yaml set filetype=yaml.ansible
au BufRead,BufNewFile */*-ansible/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */*-ansible/*.yaml set filetype=yaml.ansible
au BufRead,BufNewFile */hosts_playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */hosts_playbooks/*.yaml set filetype=yaml.ansible

augroup ansible_vim_fthosts
  autocmd!
  autocmd BufNewFile,BufRead hosts setfiletype yaml.ansible
augroup END
