set virtualedit+=onemore
"convert to unix filetype on save
set ff=unix
let mapleader=","
syntax on
set encoding=utf-8
set fileencoding=utf-8
set number relativenumber
set title
set hlsearch
"highlight toggle
nnoremap <silent><expr> <C-h> (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
set paste
set noshowmode
set laststatus=0
"set noshowcmd
set noswapfile
" Indents
 set nowrap
 set linebreak
 set showbreak=\ \
 set breakindent
 set breakindentopt=shift:1
 set formatoptions=l
 set tabstop=1
 set softtabstop=-1
 set shiftwidth=0
 set shiftround
 set expandtab
 set autoindent
 set cpoptions+=I
 set smartindent
"case insensitive search
set ignorecase
set smartcase
"remaps
"makes o insert a blank line in normal mode
nnoremap o o<Esc>0"_D
nnoremap L .
"no clue
"makes d delete and x cut, paste is infinite. default vim is retarded
set clipboard+=unnamedplus
set clipboard+=unnamed
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap dd "_dd
noremap c "_c
vnoremap c "_c
nnoremap C "_C
" noremap x "+x
" nnoremap Y "+y$
" xnoremap y "+y
" nnoremap yy "+yy
" noremap p "+gp
" noremap P "+gP
vnoremap <expr> p 'pgvy'
nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d
"no need to press shit for command mode
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;
"makes ctrl+s increment to not conflict with tmux
nnoremap <C-s> <C-a>
filetype plugin indent on
"center search and substitution
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zzo
com! -nargs=* -complete=command ZZWrap let &scrolloff=999 | exec <q-args> | let &so=0
noremap <Leader>s "sy:ZZWrap .,$s/<C-r>s//gc<Left><Left><Left>
"start of tpope config
set backspace=indent,eol,start
set complete-=i
set smarttab
"set nrformats-=octal
set ttimeout
set ttimeoutlen=1
set incsearch
"nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
set laststatus=2
"set wildmenu
set scrolloff=1
set sidescroll=1
set sidescrolloff=2
"set display+=lastline
"set display+=truncate
"set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
"setglobal tags-=./tags tags-=./tags; tags^=./tags;
set viminfo^=!
"set sessionoptions-=options
set viewoptions-=options
"set nolangremap
"snoremap <C-U> <C-G>u<C-U>
"snoremap <C-W> <C-G>u<C-W>
"vnoremap <C-U> <C-G>u<C-U>
"vnoremap <C-W> <C-G>u<C-W>
"inoremap <C-U> <C-G>u<C-U>
"inoremap <C-W> <C-G>u<C-W>
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
 let g:is_posix = 1
endif
"open file at last closed location
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
autocmd BufReadPost norm zz
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright
" Enable autocompletion:
set wildmode=longest,list,full
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Automatically deletes all trailing whitespace and newlines at end of file on save.
" and resets cursor position.
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e " add trailing newline for ANSI C standard
autocmd BufWritePre *neomutt* %s/^--$/-- /e " dash-dash-space signature delimiter in emails
" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" change normal mode cursor to underline
" set guicursor=n-v-c-sm:hor100,i-ci-ve:ver25,r-cr-o:hor20"
" plug.vim
" frozen makes the plugins not update
call plug#begin('~/.config/nvim/plugged')
 Plug 'iamcco/markdown-preview.nvim',       { 'do': 'cd app && npx --yes yarn install' }
 Plug 'echasnovski/mini.indentscope',       { 'branch': 'stable','frozen': 1 }
 Plug 'lukas-reineke/indent-blankline.nvim',{ 'tag': 'v2.20.8',  'frozen': 1 }
 Plug 'psliwka/vim-smoothie',               { 'frozen': 1 }
 Plug 'junegunn/fzf',                       { 'frozen': 1 }
 Plug 'brenoprata10/nvim-highlight-colors', { 'frozen': 1 }
 Plug 'tpope/vim-surround',                 { 'frozen': 1 }
 Plug 'tomtom/tcomment_vim',                { 'frozen': 1 }
 Plug 'echasnovski/mini.align'
 Plug 'morhetz/gruvbox',                    { 'frozen': 1 }
call plug#end()

"colors
let g:gruvbox_transparent_bg = 1
let g:gruvbox_italic = 1
set bg=dark
set t_8f=^[[38;2;%lu;%lu;%lum " set foreground color
set t_8b=^[[48;2;%lu;%lu;%lum " set background color
colorscheme gruvbox
set t_Co=256                         " Enable 256 colors
set termguicolors                    " Enable GUI colors for the terminal to get truecolor
hi Normal guibg=NONE ctermbg=NONE
hi statusline guibg=NONE gui=NONE guifg=#7d8618
hi LineNr guifg=#7d8618

" Tcomment.
"comment at begginign of line
"let g:tcomment#options ={
" \ 'col': 1,
" \ 'whitespace': 'no',
" \ 'strip_whitespace': '0'
"\}

"MiniAlign
lua << EOF
 require('mini.align').setup()
EOF

" Identscope.
lua << EOF
 require('mini.indentscope').setup({
  draw = {
   delay = 100,
   priority = 2,
  },
  symbol = '┇'
 })
EOF

" Indentblankline.
let g:indent_blankline_char = '│'
lua << EOF
 vim.opt.list = true
 vim.cmd [[highlight IndentBlanklineIndent1 guifg=#cc241d gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent2 guifg=#98971a gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent3 guifg=#d79921 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent4 guifg=#458588 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent5 guifg=#b16286 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent6 guifg=#689d6a gui=nocombine]]
 require("indent_blankline").setup {
  space_char_blankline = "",
  char_highlight_list =
  {
   "IndentBlanklineIndent1",
   "IndentBlanklineIndent2",
   "IndentBlanklineIndent3",
   "IndentBlanklineIndent4",
   "IndentBlanklineIndent5",
   "IndentBlanklineIndent6",
  },
 }
EOF

" Markdownpreview.
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_page_title = 'MarkdownPreview'
let g:mkdp_theme = 'light'
" Open the URL in a new Firefox window
let g:mkdp_browserfunc = 'MarkdownPreview'
function! MarkdownPreview(url)
 silent exec "!librewolf --new-window " . shellescape(a:url)
endfunction

" Colors plug.
lua << EOF
 require('nvim-highlight-colors').setup {
 render = 'background', -- or 'foreground' or 'first_column'
  enable_named_colors = true,
  enable_tailwind = true,
 }
EOF
