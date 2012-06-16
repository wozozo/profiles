" Stop configuration when we can't use neocomplecache.
if v:version < 702 || $SUDO_USER != ''
  finish
endif

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1

" Disable neocomplcache on special cases.
let g:neocomplcache_lock_buffer_name_pattern = '\[Command Line\]'

let g:neocomplcache_snippets_dir = '~/.vim/snippets,~/.vim/bundle/snipmate-snippets/snippets'
" let g:neocomplcache_enable_auto_select = 1 " AutoComplPop like behavior.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)

" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:nowrap:
