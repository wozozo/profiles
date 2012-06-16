set wildignore+=*/.hg/*,*/.svn/*,*/cache/*,*/.sass-cache/*,.DS_Store,*.pyc,*~
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$',
\ }
let g:ctrlp_max_height = &lines
" 1 - the parent directory of the current file.
" 2 - the nearest ancestor that contains one of these directories/files
" 0 - don’t manage working directory
let g:ctrlp_working_path_mode = 0
let g:ctrlp_extensions = ['cmdline', 'yankring', 'menu']
