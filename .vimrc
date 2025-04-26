" .vimrc
" http://github.com/niw/profiles

"{{{ Initialize

if !exists('s:loaded_vimrc')
  " Don't reset twice on reloading, 'compatible' has many side effects.
  set nocompatible
endif


" Reset all autocmd defined in this file.
augroup MyAutoCommands
  autocmd!
augroup END

"}}}

"{{{ Encodings and Japanese

set fileformats=unix,dos,mac                     " trying EOL formats
set termencoding=utf-8                           " Encoding used for the terminal.
set encoding=utf-8                               " character encoding used inside Vim.
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp " list of character encodings considered when starting to edit an existing file.

" Address the issue for using □ or ●.
" NOTE We also need to apply a patch for Mac OS X Terminal.app
set ambiwidth=double

" Settings for Input Methods
if has('keymap')
  set iminsert=0 imsearch=0
endif

" Multibyte format, See :help fo-table
set formatexpr&
set formatoptions&
set formatoptions+=mM
"set formatoptions=tcroqnlM1

" Fileformat. Default is Unix.
set fileformat=unix
set fileformats=unix,dos,mac

"}}}

"{{{ Global Settings

" Search

" Ignore the case of normal letters
set ignorecase
" If the search pattern contains uppter case characters, override the 'ignorecase' option.
set smartcase
" Use incremental search.
set incsearch
" Do not highlight search result.
set hlsearch
nohlsearch
" Searches wrap around the end of the file.
set wrapscan

" Tab and spaces

" Number of spaces that a <Tab> in the file counts for.
set tabstop=2
" Number of spaces to use for each step of indent.
set shiftwidth=2
" Expand tab to spaces.
set expandtab
" Smart autoindenting.
set autoindent
set smartindent
" Round indent to multiple of 'shiftwidth'.
set shiftround
" Enable modeline.
set modeline
" Disable auto wrap.
autocmd MyAutoCommands FileType * setlocal textwidth=0

" Cursor and Backspace

" Allow backspacing over autoindent, line brakes and the start of insert.
set backspace=indent,eol,start
" Allow h, l, <Left> and <Right> to move to the previous/next line.
set whichwrap&
set whichwrap+=<,>,[,],h,l

" Displays

" When a bracket is inserted, briefly jump to the matching one.
set showmatch
" Command-line completion operates in an enhanced mode.
set wildmenu
" Show line number.
set number
" Show the line and column number of the cursor position.
set ruler
" Lines longer than the width of the window will wrap.
set wrap
" Show status line always.
set laststatus=2
" Show command in the last line of the screen.
set showcmd
" Set title of the window to the value of 'titlesrting'.
set title
" If in Insert, Replace or Visual mode put a message on the last line.
set showmode
" Number of screen lines to use for the command-line.
set cmdheight=2
" Default height for a preview window.
set previewheight=40
" Highlight a pari of < and >.
set matchpairs+=<:>

" Status line

let &statusline = ''
let &statusline .= '%3n '     " Buffer number
let &statusline .= '%<%f '    " Filename
let &statusline .= '%m%r%h%w' " Modified flag, Readonly flag, Preview flag
let &statusline .= '%{"[" . (&fileencoding != "" ? &fileencoding : &encoding) . "][" . &fileformat . "][" . &filetype . "]"}'
let &statusline .= '%='       " Spaces
let &statusline .= '%l,%c%V'  " Line number, Column number, Virtual column number
let &statusline .= '%4P'      " Percentage through file of displayed window.

" Completion

" Complete longest common string, list all matches and complete the next full match.
set wildmode=longest,list,full
" Use the popup menu even if it has only one match.
set completeopt=menuone

" I don't want to use backup files.
set nobackup
set noswapfile
set noundofile

" Hide buffer when it is abandoned.
set hidden

" Expand a history of ':' commands to 100.
set history=100

" Indicates a fast terminal connection.
set ttyfast

" Indicate tab, wrap, trailing spaces and eol or not.
set list
"set nolist
set listchars=tab:»\ ,extends:»,precedes:«,trail:\
augroup MyAutoCommands
  "autocmd VimEnter,ColorScheme * highlight SpecialKey ctermbg=red guibg=#F92672
  autocmd VimEnter,ColorScheme * highlight TrailingWhitespaces ctermbg=red guibg=#F92672
  "autocmd InsertEnter * match TrailingWhitespaces //
  "autocmd InsertLeave * match TrailingWhitespaces /\v\s+$/
  autocmd VimEnter,WinEnter * match TrailingWhitespaces /\v\s+$/
augroup END

" Highlight Cursour Line
"autocmd MyAutoCommands WinEnter,BufEnter * setlocal cursorline
"autocmd MyAutoCommands WinLeave,BufLeave * setlocal nocursorline

" Change current directory by switching the buffers, See :help cmdline-special.
"autocmd MyAutoCommands BufRead,BufEnter * execute ":lcd " . expand("%:p:h:gs? ?\\\\ ?")

" Open QuickFix after vimgrep
"autocmd MyAutoCommands QuickFixCmdPost grep,grepadd,vimgrep,vimgrepadd copen

" Auto insert close tag
autocmd FileType html inoremap <silent> <buffer> </ </<C-x><C-o>

" Restore cursor positon
"{{{
function! s:RestoreCursorPosition()
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  if line("'\"") > 1 && line("'\"") <= line("$")
    execute "normal! g`\""
  endif
endfunction

autocmd MyAutoCommands BufReadPost * call <SID>RestoreCursorPosition()
"}}}

" Auto reload, check file when switch the window.
set autoread
autocmd MyAutoCommands WinEnter * checktime

"}}}

"{{{ Syntax and File Types

" Enable syntax color.
syntax enable
" for TypeScript
set re=0
filetype plugin on

" Enable indent.
filetype indent on

augroup SkeletonAu
  autocmd!
  autocmd BufNewFile *.html 0r $HOME/.vim/skeleton/html.skel
  autocmd BufNewFile *.py 0r $HOME/.vim/skeleton/python.skel
  autocmd BufNewFile *.php 0r $HOME/.vim/skeleton/php.skel
augroup END

augroup MyAutoCommands
  " Disable automatically insert comment.
  " See :help fo-table
  autocmd FileType * setlocal formatoptions-=ro | setlocal formatoptions+=mM

  " File type settings
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType vim setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 expandtab


"}}}

"{{{ Key Mappings

noremap <C-e> $
noremap <C-a> ^
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
vnoremap < <gv
vnoremap > >gv
vnoremap v $h

" pbcopy
nmap _ :.w !nkf -Ws\|pbcopy<CR><CR>
vmap _ :w !nkf -Ws\|pbcopy<CR><CR>

nnoremap <ESC><ESC> :nohlsearch<CR>

" Leaders
"{{{
" Define <Leader>, <LocalLeader>
let mapleader = ','
let maplocalleader = '.'

" Disable <Leader>, <LocalLeader> to avoid unexpected behavior.
noremap <Leader> <Nop>
noremap <LocalLeader> <Nop>
"}}}

" Reserve q for prefix key then assign Q for original actions.
" Q is for Ex-mode which we don't need to use.
nnoremap q <Nop>
nnoremap Q q

" Avoid run K mistakenly with C-k, remap K to qK
nnoremap K <Nop>
nnoremap qK K

" Smart <Space> mapping
nmap <Space> [Space]
xmap <Space> [Space]
nnoremap [Space] <Nop>
xnoremap [Space] <Nop>

" Buffer manipulations
nmap [Space] [Buffer]
xmap [Space] [Buffer]
"{{{
function! s:NextNormalBuffer(loop) "{{{
  let buffer_num = bufnr('%')
  let last_buffer_num = bufnr('$')

  let next_buffer_num = buffer_num
  while 1
    if next_buffer_num == last_buffer_num
      if a:loop
        let next_buffer_num = 1
      else
        break
      endif
    else
      let next_buffer_num = next_buffer_num + 1
    endif
    if next_buffer_num == buffer_num
      break
    endif
    if ! buflisted(next_buffer_num)
      continue
    endif
    if getbufvar(next_buffer_num, '&buftype') == ""
      return next_buffer_num
      break
    endif
  endwhile
  return 0
endfunction "}}}

function! s:OpenNextNormalBuffer(loop) "{{{
  if &buftype == ""
    let buffer_num = s:NextNormalBuffer(a:loop)
    if buffer_num
      execute "buffer" buffer_num
    endif
  endif
endfunction "}}}

function! s:PrevNormalBuffer(loop) "{{{
  let buffer_num = bufnr('%')
  let last_buffer_num = bufnr('$')

  let prev_buffer_num = buffer_num
  while 1
    if prev_buffer_num == 1
      if a:loop
        let prev_buffer_num = last_buffer_num
      else
        break
      endif
    else
      let prev_buffer_num = prev_buffer_num - 1
    endif
    if prev_buffer_num == buffer_num
      break
    endif
    if ! buflisted(prev_buffer_num)
      continue
    endif
    if getbufvar(prev_buffer_num, '&buftype') == ""
      return prev_buffer_num
      break
    endif
  endwhile
  return 0
endfunction "}}}

function! s:OpenPrevNormalBuffer(loop) "{{{
  if &buftype == ""
    let buffer_num = s:PrevNormalBuffer(a:loop)
    if buffer_num
      execute "buffer" buffer_num
    endif
  endif
endfunction "}}}

noremap <silent> [Buffer]P :<C-u>call <SID>OpenPrevNormalBuffer(0)<CR>
noremap <silent> [Buffer]p :<C-u>call <SID>OpenPrevNormalBuffer(1)<CR>
noremap <silent> [Buffer]N :<C-u>call <SID>OpenNextNormalBuffer(0)<CR>
noremap <silent> [Buffer]n :<C-u>call <SID>OpenNextNormalBuffer(1)<CR>
"}}}

" Window manipulations
nmap s [Window]
nnoremap [Window] <Nop>
"{{{
nnoremap [Window]j <C-W>j
nnoremap [Window]k <C-W>k
nnoremap [Window]h <C-W>h
nnoremap [Window]l <C-W>l

nnoremap [Window]J <C-W>J
nnoremap [Window]K <C-W>K
nnoremap [Window]H <C-W>H
nnoremap [Window]L <C-W>L

nnoremap [Window]v <C-w>v
" Centering cursor after splitting window
nnoremap [Window]s <C-w>szz

nnoremap [Window]q :<C-u>quit<CR>
nnoremap [Window]d :<C-u>Bdelete<CR>

nnoremap [Window]= <C-w>=
nnoremap [Window], <C-w><
nnoremap [Window]. <C-w>>
nnoremap [Window]] <C-w>+
nnoremap [Window][ <C-w>-
"}}}

" Tab manipulations
nmap t [Tab]
nnoremap [Tab] <Nop>
"{{{
function! s:MapTabNextWithCount()
  let tab_count = 1
  while tab_count < 10
    execute printf("noremap <silent> [Tab]%s :tabnext %s<CR>", tab_count, tab_count)
    let tab_count = tab_count + 1
  endwhile
endfunction

nnoremap <silent> [Tab]c :<C-u>tabnew<CR>
nnoremap <silent> [Tab]q :<C-u>tabclose<CR>
nnoremap <silent> [Tab]n :<C-u>tabnext<CR>
nnoremap <silent> [Tab]p :<C-u>tabprev<CR>

call s:MapTabNextWithCount()
"}}}

" Move cursor by display line
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Centering search result and open fold.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" Run EX commands
nnoremap ; q:i
nnoremap : q:i
"{{{
"autocmd MyAutoCommands CmdwinEnter * nnoremap <buffer> <ESC> :<C-u>quit<CR>

augroup MyAutoCommands
  autocmd CmdwinEnter * nnoremap <buffer> <ESC><ESC> :<C-u>quit<CR>
  autocmd CmdwinEnter * nnoremap <buffer> : <Nop>
  autocmd CmdwinEnter * nnoremap <buffer> ; <Nop>
augroup END
"}}}

" Disable highlight
noremap <silent> gh :<C-u>nohlsearch<CR>

" Reset syntax highlight
noremap <silent> gj :<C-u>syntax sync clear<CR>

" Select the last modified texts
nnoremap <silent> gm `[v`]
vnoremap <silent> gm :<C-u>normal gc<CR>
onoremap <silent> gm :<C-u>normal gc<CR>

" Grep
nnoremap <silent> gr :<C-u>Grep<Space><C-r><C-w><CR>
xnoremap <silent> gr :<C-u>call <SID>CommandWithVisualRegionString('Grep')<CR>

" Make
noremap <silent> [Space], :<C-u>make<CR>

" Quick edit and reload .vimrc
nnoremap <silent> [Space].  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [Space]s. :<C-u>source $MYVIMRC<CR>
" Open shell on console or GUI application.
function! s:OpenShell() "{{{
  shell
endfunction "}}}
" Run shell
nnoremap <silent> [Space]; :<C-u>call <SID>OpenShell()<CR>

" Remove tailing spaces.
"{{{
function! s:StripTrailingWhitespaces()
  silent execute "normal ma<CR>"
  let saved_search = @/
  %s/\s\+$//e
  silent execute "normal `a<CR>"
  let @/ = saved_search
endfunction

command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
"}}}

"}}}

"}}}

" Re-enable filetype plugin for ftdetect directory of each runtimepath
filetype off
filetype on

"}}}
"{{{ Finalize

if !exists('s:loaded_vimrc')
  let s:loaded_vimrc = 1
endif

" See :help secure
set secure

"}}}

" vim: tabstop=2 shiftwidth=2 textwidth=0 expandtab foldmethod=marker
