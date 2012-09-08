" initialise pathogen
" make sure these lines are enabled before filetype detection
" ( ie. if has("autocmd") block )
call pathogen#infect()

" turn on vim mode instead of vi mode
" this command triggers many option settings, therefore
" every other option should be set after this
set nocompatible
" however, prohibit modeline support for security
" modelines are special lines in files that can alter the behaviour of vim
" and/or execute malicious code through vim commands
set modelines=0
set nomodeline

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
" set background=dark
" ... well, didn't like the colors ;-)
" ... and time is too limited to set my own

" enable syntax highlighting if present
if has("syntax")
    syntax on
    set hlsearch
    " setting highlight colors
    " ------------------------
    " this is highly customized to my likings
    " and performs only with my .Xresources
    "
    " folding:
        highlight Folded ctermbg=black ctermfg=yellow
    " Mark the 81th character on each line
        highlight OverLength ctermfg=78
        match OverLength '\%81v.\+'
    " search for patterns
        highlight Search ctermbg=black ctermfg=darkyellow
    " visual mode
        highlight Visual ctermbg=darkgrey ctermfg=78
    " parenthesis matching
        highlight MatchParen ctermbg=grey ctermfg=black
    " spell checking
        highlight SpellBad ctermfg=darkred cterm=underline ctermbg=black
        highlight SpellCap ctermfg=yellow cterm=underline ctermbg=black
        highlight SpellLocal ctermfg=yellow cterm=underline ctermbg=black
        highlight SpellRare ctermfg=yellow cterm=underline ctermbg=black
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
    filetype plugin indent on
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
    " set doxygen comments for c/c++ source code
    autocmd Filetype c,cpp set comments^=:///
endif

set showcmd		    " Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching (ie. only case insensitive if
                    " no capital letters are present in the search pattern)
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set tabstop=4		" number of spaces of tab
set expandtab		" tabs are typed as spaces
set shiftwidth=4    " number of spaces to (auto)indent
set shiftround      " use multiples of shiftwidth when indenting blocks
set autochdir       " change into the directory of the last opened file
"
" TODO: check the following options -- useful?
set foldmethod=syntax
"set hidden         " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" set encoding
" ( hate it so much ... )
" ensures that vim defaults to utf-8 as often as possible
if has("multi_byte") 
    " termencoding defines the terminal encoding (how the keyboard is
    " interpreted
    if &termencoding == "" 
    let &termencoding = &encoding 
    endif 
    " internal representaton
    set encoding=utf-8
    " set default encoding
    setglobal fileencoding=utf-8
    " bomb is rather useless in utf-8 thus commented
    " setglobal bomb
    " when opening a file, test the following encodings and 
    " stick to the first match
    set fileencodings=ucs-bom,utf-8,latin1 
endif 

if has("statusline")
    " always show the status line
    set laststatus=2
    " content of the statusline
    " shows filename, modifications, encoding, line, row, percentage
    set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" don't beep on error
set noerrorbells visualbell t_vb=

" spell checking 
setlocal spell spelllang=en_gb
syntax spell toplevel
" deactivate ( since I am probably reading source code )
set nospell

" vim latex plugin
"
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
" ( better safe than sorry )
set grepprg=grep\ -nH\ $*
" Starting with Vim 7, the filetype of empty .tex files defaults to 
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
