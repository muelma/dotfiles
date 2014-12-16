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
colorscheme desert

set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching (ie. only case insensitive if
                        " no capital letters are present in the search pattern)
set incsearch           " Incremental search
set autowrite           " save before commands like :next and :make
set tabstop=2           " number of spaces of tab
set nosmartindent
set expandtab           " tabs are typed as spaces
set shiftwidth=2        " number of spaces to (auto)indent
set shiftround          " use multiples of shiftwidth when indenting blocks
set autochdir           " change into the directory of the last opened file
set title               " set terminal title
set pastetoggle=<F2>    " paste mode via F2 key
set backspace=indent,eol,start " fix most backspace problems on remote machines

" save some keystrokes     
noremap ; :

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
    " ------------------------------------
    "" 
    "" folding:
        highlight Folded ctermbg=black ctermfg=yellow
    "" search for patterns
        highlight Search ctermbg=black ctermfg=darkyellow
    " visual mode
        highlight Visual ctermbg=darkgrey ctermfg=lightyellow
    "" parenthesis matching
        highlight MatchParen ctermbg=lightgrey ctermfg=black
    "" spell checking
        highlight SpellBad ctermfg=darkred cterm=underline ctermbg=black
        highlight SpellCap ctermfg=yellow cterm=underline ctermbg=black
        highlight SpellLocal ctermfg=yellow cterm=underline ctermbg=black
        highlight SpellRare ctermfg=yellow cterm=underline ctermbg=black
    " beautify the menu (better than black && violett)
        highlight Pmenu ctermbg=darkgrey ctermfg=white
    " remove last search result highlighting
    " nnoremap <silent><esc> :noh<cr><esc>
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

    " Commenting blocks of code.
    autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
    autocmd Filetype c,cpp set comments^=:///
    autocmd FileType sh,ruby,python   let b:comment_leader = '# '
    autocmd FileType conf,fstab       let b:comment_leader = '# '
    autocmd FileType tex              let b:comment_leader = '% '
    autocmd FileType mail             let b:comment_leader = '> '
    autocmd FileType vim              let b:comment_leader = '" '
    noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>


    " Mark the 81th character on each line
    " this way it works also in tabs
    if has("syntax")
        highlight OverLength ctermfg=lightyellow
        autocmd BufWinEnter * let w:m2=matchadd('OverLength', '\%>80v.\+', -1)
    endif

    " header with time informations
    autocmd BufNewFile *.{c,cpp,h,hpp} call InsertSkeleton("cpp_header.txt")
    autocmd BufNewFile *.{h,hpp} call InsertIncludeGuard()
    autocmd BufWritePre,FileWritePre *.{c,cpp,h,hpp} call LastModified()

    function! InsertSkeleton(fname)
        let path_to_skeletons = $HOME . "/.vim/templates/" 
        " Save cpoptions
        let cpoptions = &cpoptions
        " Remove the 'a' option - prevents the name of the
        " alternate file being overwritten with a :read command
        exe "set cpoptions=" . substitute(cpoptions, "a", "", "g")
        exe "read " . path_to_skeletons . a:fname
        " Restore cpoptions
        exe "set cpoptions=" . cpoptions
        " Delete the first line into the black-hole register
        1, 1 delete _
        " Search for @file:
        call search("@file:")
        exe "normal A " . expand("%:t")
        " Search for @date:
        let current_time = strftime("%x %X (%Z)")
        call search("@date:")
        exe "normal A " . current_time
        exe "normal Go "
    endfunction

    function! InsertIncludeGuard()
        " Convert newname.h to NEWNAME_H
        let fname = expand("%:t")
        let fname = toupper(fname)
        let fname = substitute(fname, "\\.", "_", "g")
        let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
        exe "normal i# ifndef " . gatename
        exe "normal o# define " . gatename . " "
        exe "normal Go# endif // " . gatename
        exe "normal GO" 
    endfunction

    " Update the filename if changed
    function! LastModified()
        if &modified
            let save_cursor = getpos(".")
            let n = min([20, line("$")])
            keepjumps exe '1,' . n . 's#^\(.\{,10}@file: \).*#\1' .
                        \ expand("%:t") . '#e'
            call histdel('search', -1)
            call setpos('.', save_cursor)
        endif
    endfun

endif


" don't beep on error
set noerrorbells visualbell t_vb=
" spell checking 
syntax spell toplevel
map <F9> :setlocal spell! spelllang=en_us<CR>
imap <F9> <C-o>:setlocal spell! spelllang=en_us<CR>

" toggle wrapping with F2
map <F2> :set wrap!<CR>

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

" vim latex plugin
" ----------------
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
" ( better safe than sorry )
set grepprg=grep\ -nH\ $*
" Starting with Vim 7, the filetype of empty .tex files defaults to 
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_CompileRule_pdf = 'pdflatex --interaction=nonstopmode --shell-escape $*'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'evince'
" let g:TTarget = 'pdf'
" Set the warning messages to ignore.
let g:Tex_IgnoredWarnings =
\"Underfull\n".
\"Overfull\n".
\"specifier changed to\n".
\"You have requested\n".
\"Missing number, treated as zero.\n".
\"There were undefined references\n".
\"Citation %.%# undefined\n".
\"LaTeX Font Warning:\n".
\"LaTeX Warning: Command:\n"
" This number N says that latex-suite should ignore the first N of the above.
let g:Tex_IgnoreLevel = 9
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_GotoError=0
" ----------------

" autocompletion with clang_complete, snipmate and supertab
" Complete options (disable preview scratch window)
"set completeopt = menu,menuone,longest
" Limit popup menu height
set pumheight=15

" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType = "context"

" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto = 0
" Show clang errors in the quickfix window
"let g:clang_complete_copen = 1
let g:clang_user_options='|| exit 0'
map <C-K> :pyf /usr/share/vim/addons/syntax/clang-format-3.4.py<CR>
imap <C-K> <ESC>:pyf /usr/share/vim/addons/syntax/clang-format-3.4.py<CR>i
