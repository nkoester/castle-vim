"""""""""""""""""""""""""""""""""""""
" nkoester, 06062015 - intial vimrc
"""""""""""""""""""""""""""""""""""""

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings
" Must be first, because it changes other options as a side effect.
set nocompatible


"""""""""""""""""""""""""""""
" Miscellaneous settings ...
"""""""""""""""""""""""""""""
set number                     " Show line numbers <3
set hidden                     " Allow hidden buffers, don't limit to 1 file per window/split

set backspace=indent,eol,start " allow backspacing over everything in insert mode

if has("vms")
    set nobackup               " do not keep a backup file, use versions instead
else
    set backup                 " keep a backup file
endif

set history=300           " keep 50 lines of command line history
set ruler                 " show the cursor position all the time
set showcmd               " display incomplete commands
set showmode

set scrolloff=5           " distance to scrolling

set laststatus=2

highlight MatchParen cterm=bold ctermbg=none ctermfg=9  " bracket matching settings

if has('mouse')   " Enable mouse
  set mouse=a
endif

" tab completion mode with partial match and list
set wildmode=list:longest,full
set wildmenu

set wildchar=<Tab> wildmenu wildmode=full


""""""""""""""""""""
" Searching options
""""""""""""""""""""
set incsearch    " do incremental searching
set ignorecase   " Ignore case when searching
set smartcase    " ?

"""""""""""""""""""""""""""""
" Window width/wrapping
"""""""""""""""""""""""""""""
set textwidth=79
set formatoptions-=t
set wrap
set linebreak
set nolist

"""""""""""""""""""""""""""""
" Tabbing, indentation etc.
"""""""""""""""""""""""""""""
set smarttab        " make 'tab' insert indents instead
                    " of tabs at the beginning of a line
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces


""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

""""""""""""""""""
" Key bindings
""""""""""""""""""

" Exit insert mode easily
"inoremap ii <Esc>l
inoremap jj <Esc>l

" Write file and return to what you were doing
inoremap <F2> <Esc>:w<CR>a
nnoremap <F2> :w<CR>

" source the config file
inoremap <F5> <Esc>:source $MYVIMRC<CR>:echo "sourced $MYVIMRC"<CR>a
nnoremap <F5> :source $MYVIMRC<CR>:echo "sourced $MYVIMRC"<CR>

" Because 'Shift+;' for a ':' sucks
"nnoremap ; :
"nnoremap : ;
"vnoremap ; :
"vnoremap : ;

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" resize windows TODO: FIX
nnoremap <A-_> <C-W>+

nnoremap <A-=> <C-W>>
nnoremap <A--> <C-W><

" Control-Enter = append new line
nnoremap <C-J> A<CR><Esc>
" Map Ctrl-Space to insert a single space :)
nnoremap <NUL> i<Space><Esc>

""""""""""""""""
" Auto completion
""""""""""""""""
" bind it to Ctrl-Space
inoremap <NUL> <C-n>

set completeopt=longest,menuone

"make enter work just as <C-Y> would when selction in popup
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


""""""""""""""""
" Command def.
""""""""""""""""
" show changes: diff between the current buffer and loaded file
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif


""""""""""""""""
" Side explorer
""""""""""""""""
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
nnoremap <silent> <C-E> :call ToggleVExplorer()<CR>

" mode for wrapping text in the file
function! TextMode()
    :set formatoptions=tc
    :set fo+=a
    :set textwidth=80
endfunction

command! SetTextMode call TextMode()

" Hit enter in the file browser to open the selected file with :vsplit to the
" right of the browser.
let g:netrw_altv = 1
let g:netrw_winsize = -28              " absolute width of netrw window
"let g:netrw_banner = 0                " do not display info on the top of window
let g:netrw_liststyle = 3              " tree-view
let g:netrw_sort_sequence = '[\/]$,*'  " sort is affecting only: directories on the top, files below
let g:netrw_browse_split = 4           " use the previous window to open file
set autochdir                          " Change directory to the current buffer when opening files.

"""""""""""""""
" autocommands
"""""""""""""""
if has("autocmd")
      " say hello ^^
      autocmd VimEnter * echo "kitten <3 you     >^.^<  (meow)"

      " Enable file type detection.
      " load indent files to automatically do language-dependent indenting
      filetype plugin indent on

      " Put these in an autocmd group, so that we can delete them easily.
      augroup vimrcEx
          au!

          " For all text files set 'textwidth' to 78 characters.
          autocmd FileType text setlocal textwidth=78

          " When editing a file, always jump to the last known cursor position.
          autocmd BufReadPost
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

      augroup END

else

  set autoindent        " always set autoindenting on

endif


"""""""""""""""
" Spelling ...
"""""""""""""""
if has("spell")
    " set spell

    " toggle spelling with F4 key
    nnoremap <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
    inoremap <F4> <Esc>:set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>a

    nnoremap [s [sz=
    nnoremap ]s ]sz=

    "set spell spelllang=en,de                          " spell checking
    "highlight PmenuSel ctermfg=black ctermbg=lightgray " they were using white on white

    set sps=best,10       " limit it to just the top 10 items

    " allows spelling errors to be highlighted even if the line is selected
    "hi clear SpellBad
    "hi SpellBad cterm=bold ctermfg=red
    highlight clear SpellBad
    highlight SpellBad cterm=bold ctermbg=red
    highlight clear SpellCap
    highlight SpellCap cterm=bold ctermbg=166
    highlight clear SpellRare
    highlight SpellRare cterm=bold ctermbg=166
    highlight clear SpellLocal
    highlight SpellLocal cterm=bold ctermbg=166
endif

" split movement
nmap <c-Left> <c-w>h
nmap <c-Down> <c-w>j
nmap <c-Right> <c-w>l
nmap <c-Up> <c-w>k

" buffer movement
map <a-Left> :bprevious<CR>
map <a-Right> :bnext<CR>

" remap stupid movement bindings
noremap ; l
noremap l k
noremap k j
noremap j h

" pathogen setup
" execute pathogen#infect()
call plug#begin('~/.vim/plugged')

Plug 'https://github.com/elzr/vim-json.git', { 'for': ['json', 'distribution', 'project'] }

"Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/flazz/vim-colorschemes.git'
Plug 'https://github.com/ervandew/supertab.git'
Plug 'https://github.com/vim-scripts/SearchComplete.git'
Plug 'https://github.com/easymotion/vim-easymotion.git'
Plug 'https://github.com/tpope/vim-surround'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'https://github.com/tpope/vim-unimpaired.git'

Plug 'https://github.com/vim-syntastic/syntastic'

Plug 'bkad/CamelCaseMotion'

Plug 'ntpeters/vim-better-whitespace'

Plug 'nathanaelkane/vim-indent-guides'

Plug 'tomtom/tcomment_vim'

"Plug 'itspriddle/ZoomWin'
Plug 'https://github.com/vim-scripts/zoomwintab.vim'

"Plug 'valloric/youcompleteme'
Plug 'davidhalter/jedi-vim'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'


Plug 'junegunn/goyo.vim'

call plug#end()

"map <S-Enter> <Plug>(easymotion-prefix)

" airline settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#whitespace#checks=['indent', 'mixed-indent-file']


"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_symbols.space = "\ua0"

"the arrows are just stupid
let g:airline_left_sep='▙'
let g:airline_right_sep='▟'

" does not work?
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#buffer_nr_format = '%s: '

let g:airline_theme="badwolf"
" avoid insert mode leave lag
set ttimeoutlen=10
" always show
set laststatus=2
" reduced from 4000
set updatetime=250

"CamelCaseMotion
call camelcasemotion#CreateMotionMappings('<leader>')

" indent-guides
set ts=4 sw=4 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 4

map <F3> <Esc>\ig<CR>:echo "Indent Guides toggle"<CR>

" vim-better-whitespace
" trim on save
autocmd BufWritePre * StripWhitespace

" Goyo config
let g:goyo_linenr=1
let g:goyo_height= '90%'
let g:goyo_width = 100

noremap <silent> <Leader>cm :exe ColumnMode()<CR>
function! ColumnMode()
  exe "norm \<C-u>"
  let @z=&so
  set noscb so=0
  bo vs
  exe "norm \<PageDown>"
  setl scrollbind
  wincmd p
  setl scrollbind
  let &so=@z
endfunction

syntax enable


"""""""""""""""""
" colors etc.
"""""""""""""""""
colorscheme jellybeans

"row
set cursorline
highlight CursorLine term=NONE cterm=NONE ctermbg=237

"margin
set colorcolumn=80
highlight ColorColumn ctermbg=237

"visual
hi Visual term=reverse cterm=reverse guibg=Grey

"set the cursor shape depending on the mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

"reset cursor on exit
autocmd VimLeave * let &t_me="\<Esc>[6 q"

" better json
au BufRead,BufNewFile,BufReadPost *.json set syntax=json
au BufNewFile,BufRead,BufReadPost *.project set filetype=json
au BufNewFile,BufRead,BufReadPost *.distribution set filetype=json
let g:vim_json_syntax_conceal = 0

