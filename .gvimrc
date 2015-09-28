" .gvimrc
" http://github.com/niw/profiles

"{{{ Initialize

" We have now 64 bit Windows.
let s:has_win = has('win32') || has('win64')

"}}}

" Font settings {{{

if s:has_win
  set guifont=MeiryoKe_Console:h9:cSHIFTJIS
  "set guifont=MS_Gothic:h9:cSHIFTJIS
  if has('printer')
    set printfont=MS_Mincho:h9:cSHIFTJIS
  endif
elseif has('mac')
  "set guifont=Monaco:h10
  set gfn=Monaco:h13
  set gfw=Hiragino\ Kaku\ Gothic\ Pro:h13
else
  set guifont=Monospace\ 8
endif

set lsp=1
let g:molokai_original = 1

" }}}

" Window settings {{{

" Window width
set columns=120
" Window height
set lines=65
" Command line height
set cmdheight=2
" No toolbar, No menubar, No scrollbars
set guioptions-=T
set guioptions-=m
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" Transparency if we can use.
if(exists('&transparency'))
  set transparency=3
  augroup MyAutoCommands
    autocmd FocusGained * set transparency=3
    autocmd FocusLost * set transparency=8
  augroup END
endif
" Use visualbell, stop beeping.
set visualbell t_vb=

" }}}

" Platform Dependents {{{

if has("gui_macvim")
  set fuoptions=maxvert,maxhorz
endif

" }}}

" vim:set tabstop=2 shiftwidth=2 expandtab foldmethod=marker nowrap:
