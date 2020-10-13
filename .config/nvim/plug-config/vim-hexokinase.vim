let g:Hexokinase_highlighters = [ 'backgroundfull' ]

" All possible values
" full_hex, triple_hex, rgb, rgba, hsl, hsla, colour_names
let g:Hexokinase_optInPatterns = [
\     'full_hex',
\     'triple_hex',
\     'rgb',
\     'rgba',
\     'hsl',
\     'hsla',
\ ]

" Filetype specific patterns to match
" entry value must be comma seperated list
let g:Hexokinase_ftOptInPatterns = {
\     'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
\     'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
\     'markdown': 'full_hex,rgb,rgba,hsl,hsla',
\ }

" Sample value, to keep default behaviour don't define this variable
" let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript']
