" Rakesh Patel .vimrc
" Email: roc@rocpatel.com
" Last change: August 7th, 2009
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

filetype on

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" ADDED BY ME
set number
set backspace=indent,eol,start
set showmode
set softtabstop=2
set shiftwidth=2
set tabstop=2
set autoindent
set splitright
" Use spaces instead of tabs
" set expandtab
colorscheme molokai 
set guifont=Inconsolata:h12
set ignorecase
set vb " turns off visual bell
set smartindent
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " filename
set statusline+=%h%m%r%w                     " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
set statusline+=%=                           " right align remainder
set statusline+=0x%-8B                       " character value
set statusline+=%-14(%l,%c%V%)               " line, character
set statusline+=%<%P                         " file position

" compiler ruby

" autocmd FileType make     set noexpandtab
" autocmd FileType python   set noexpandtab


let g:fuzzy_ignore = "*.log"
let g:fuzzy_matching_limit = 70
let g:fuzzy_ceiling = 50000
let mapleader=","

set grepprg=ack
set grepformat=%f:%l:%m

map <leader>l :TlistToggle<CR>
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>r :RunSpec<CR>
map <leader>R :RunSpecs<CR>
map <leader>f :Ack 


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backupdir=~/.vimswaps,/tmp

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  "filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

  augroup mkd

    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
