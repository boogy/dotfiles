" Ale
let g:ale_disable_lsp = 1
let g:ale_enabled = 1

" Set this variable to 1 to fix files when you save them
let g:ale_fix_on_save = 0
let g:ale_completion_autoimport = 1
let g:ale_python_auto_pipenv = 0
let g:ale_python_flake8_auto_pipenv = 0
let g:ale_python_flake8_change_directory = 'project'
let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_flake8_options = ''
let g:ale_python_flake8_use_global = 0

" Global Variables:
let g:ale_cache_executable_check_failures = v:null
let g:ale_change_sign_column_color = 0
let g:ale_command_wrapper = v:null
let g:ale_completion_delay = v:null
let g:ale_completion_enabled = 0
let g:ale_completion_max_suggestions = v:null
let g:ale_echo_cursor = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_echo_msg_info_str = 'Info'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_fix_on_save = 0
let g:ale_fixers = {'python': ['yapf']}
let g:ale_history_enabled = 1
let g:ale_history_log_output = 1
let g:ale_keep_list_window_open = 0
let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_linter_aliases = {}
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_linters_explicit = 0
let g:ale_linters_ignore = {}
let g:ale_list_vertical = 0
let g:ale_list_window_size = 10
let g:ale_loclist_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lsp_root = {}
let g:ale_max_buffer_history_size = 20
let g:ale_max_signs = -1
let g:ale_maximum_file_size = v:null
let g:ale_open_list = 0
let g:ale_pattern_options = v:null
let g:ale_pattern_options_enabled = v:null
let g:ale_set_balloons = 0
let g:ale_set_highlights = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_set_signs = 1
let g:ale_sign_column_always = 0
let g:ale_sign_error = '●'
let g:ale_sign_info = '●'
let g:ale_sign_offset = 1000000
let g:ale_sign_style_error = '●'
let g:ale_sign_style_warning = '●'
let g:ale_sign_warning = '●'
let g:ale_sign_highlight_linenrs = 0
let g:ale_statusline_format = v:null
let g:ale_type_map = {}
let g:ale_use_global_executables = v:null
let g:ale_virtualtext_cursor = 0
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_warn_about_trailing_whitespace = 1

function! AleLinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
