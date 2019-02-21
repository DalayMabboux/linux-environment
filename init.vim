" VIM plugins
call plug#begin()
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'inkarkat/vim-mark'
Plug 'vim-scripts/ingo-library'
Plug 'parsonsmatt/intero-neovim'
Plug 'neomake/neomake'
Plug 'leafgarland/typescript-vim'
Plug 'majutsushi/tagbar'
Plug 'sbdchd/neoformat'
call plug#end()

set noswapfile
set mouse=a
set background=dark
set nocompatible                         " Don't need to be compatible
set hidden                               " Hide buffer instead of closing them
set nowrap                               " don't wrap lines
set expandtab                            " Use spaces instead of tabs
set tabstop=2                            " a tab is four spaces
set backspace=indent,eol,start           " allow backspacing over everything in insert mode
set autoindent                           " always set autoindenting on
set copyindent                           " copy the previous indentation on autoindenting
"set number                               " always show line numbers
set shiftwidth=2                         " number of spaces to use for autoindenting
set shiftround                           " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                            " set show matching parenthesis
set ignorecase                           " ignore case when searching
set smartcase                            " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab                             " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch                             " highlight search terms
set incsearch                            " show search matches as you type
set showcmd
set wildmenu
set path+=**
set splitbelow                           " Open new split panes to right and bottom, which feels more natural than Vim’s default
set splitright
set laststatus=2
set cursorline
let mapleader=" "

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
" set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\  

let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_checkers = ['tidy']
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" Ag
let g:ackprg = 'ag --nogroup --nocolor --column'

" Convenience mappings
nnoremap <silent> <leader>p :bprev<Return>|        " Switch to last buffer
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>|      " Quickly edit vimrc
nnoremap <silent> <leader>vv :so $MYVIMRC<CR>|     " Save vimrc
nnoremap <silent> <leader>nt :NERDTreeToggle<CR>|   " Open NERDtree
nnoremap <silent> <leader>b :CtrlPBuffer<CR>|      " Open CtrlPBuffer
nnoremap <silent> <leader>a :Ack!<Space>
nnoremap <silent> <leader>s :w<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>g :reg<CR>
nnoremap <silent> <leader>fx :%!xmllint % --format<CR>   " Format XML
nnoremap <silent> <leader>fj :%!python -m json.tool<CR>  " Format JSON
nnoremap Q @@ " 'Q' switches you to Ex mode ... in most of the cases thats not what you want
nmap <F8> :TagbarToggle<CR>
" nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
" nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
" nnoremap <silent> <Leader>> :exe "vertical resize " . (winheight(0) * 3/2)<CR>
" nnoremap <silent> <Leader>< :exe "vertical resize " . (winheight(0) * 2/3)<CR>

let g:xml_syntax_folding=1
au BufRead todo.txt set fdm=indent
au FileType xml setlocal
filetype plugin indent on
syntax enable

if has('nvim')
  " Terminal settings
  tnoremap <Leader><ESC> <C-\><C-n>
  augroup interoMaps
    au!
    " Maps for intero. Restrict to Haskell buffers so the bindings don't collide.
  
    " Background process and window management
    au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
    au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>
  
    " Open intero/GHCi split horizontally
    au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
    " Open intero/GHCi split vertically
    au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
    au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>
  
    " Reloading (pick one)
    " Automatically reload on save
    au BufWritePost *.hs InteroReload
    " Manually save and reload
    au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>
  
    " Load individual modules
    au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
    au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>
  
    " Type-related information
    " Heads up! These next two differ from the rest.
    au FileType haskell map <silent> <leader>t <Plug>InteroGenericType
    au FileType haskell map <silent> <leader>T <Plug>InteroType
    au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>
  
    " Navigation
    au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>
  
    " Managing targets
    " Prompts you to enter targets (no silent):
    au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
  augroup END
  
  " Intero starts automatically. Set this if you'd like to prevent that.
  let g:intero_start_immediately = 1
  
  " Enable type information on hover (when holding cursor at point for ~1 second).
  let g:intero_type_on_hover = 0
  
  " Change the intero window size; default is 10.
  let g:intero_window_size = 15
  
  " Sets the intero window to split vertically; default is horizontal
  let g:intero_vertical_split = 0
  
  " OPTIONAL: Make the update time shorter, so the type info will trigger faster.
  set updatetime=1000
endif

let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

" Remember these commands
" :ccl     -> closes quickfix window
" :cope[n] -> open quickfix window
" :split | terminal -> opens the terminal split below (only NEOVIM)
