set virtualedit+=onemore
"convert to unix filetype on save
set ff=unix
syntax on
set encoding=utf-8
set fileencoding=utf-8
set number relativenumber
set title
" Hide left bar from lsp.
set signcolumn=number
" Goodbye mouse.
set mouse=
" Search.
"nnoremap <silent><Tab> :noh<CR>
"  ^tab to clear search
set hlsearch
set shortmess-=S " Show amount of search results
"  Highlight toggle.
nnoremap <silent><expr> <Tab> (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
set paste
set noshowmode
set laststatus=0
set noswapfile
" Wrap.
autocmd BufRead,BufNewFile *.md setlocal wrap
autocmd BufRead,BufNewFile *.html setlocal wrap
noremap j gj
noremap k gk
set nowrap
"set linebreak
set showbreak=>
"set breakindent
"set breakindentopt=shift:1
" Indents.
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
nnoremap <silent><F2> :setlocal listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣,nbsp:+<CR>:IndentBlanklineDisable<CR>
nnoremap <silent><F3> :setlocal listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+<CR>:IndentBlanklineEnable<CR>
set formatoptions=l
set tabstop=1
set softtabstop=-1
set shiftwidth=1
set shiftround
set expandtab
set autoindent
set cpoptions+=I
set smartindent
" Case insensitive search.
set ignorecase
set smartcase
" Hide tildes on empty lines
set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾
" Remaps.
let mapleader=","
" Tabs
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap td :tabclose<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
" Makes o insert a blank line in normal mode
nnoremap o o<Esc>0"_D
nnoremap O O<Esc>0"_D
nnoremap L .
" Makes d delete and x cut, paste is infinite. default vim is retarded
set clipboard+=unnamedplus
set clipboard+=unnamed
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap dd "_dd
noremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap <expr> p 'pgvy'
nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d
" No need to press shit for command mode.
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;
" Makes ctrl+s increment to not conflict with tmux.
nnoremap <C-s> <C-a>
filetype plugin indent on
" This makes :checkhealth not yell about providers
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
" Center search and substitution.
" This is also configued by a plugin in the plugins section.
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zzo
com! -nargs=* -complete=command ZZWrap let &scrolloff=999 | exec <q-args> | let &so=0
noremap <Leader>s "sy:ZZWrap .,$s/<C-r>s//gc<Left><Left><Left>
" Start of tpope config.
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set ttimeout
set ttimeoutlen=1
set incsearch
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
set laststatus=2
set wildmenu
set scrolloff=1
set sidescroll=1
set sidescrolloff=2
set display+=lastline
set display+=truncate
setglobal tags-=./tags tags-=./tags; tags^=./tags;
set viminfo^=!
set sessionoptions-=options
set viewoptions-=options
set nolangremap
snoremap <C-U> <C-G>u<C-U>
snoremap <C-W> <C-G>u<C-W>
vnoremap <C-U> <C-G>u<C-U>
vnoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
 let g:is_posix = 1
endif
" Open urls in .
function! GetVisualSelection()
 if mode()=="v"
  let [line_start, column_start] = getpos("v")[1:2]
  let [line_end, column_end] = getpos(".")[1:2]
 else
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  end
  if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
   let [line_start, column_start, line_end, column_end] =
      \   [line_end, column_end, line_start, column_start]
   end
   let lines = getline(line_start, line_end)
   if len(lines) == 0
    return ['']
   endif
   if &selection ==# "exclusive"
    let column_end -= 1 "Needed to remove the last character to make it match the visual selction
   endif
   if visualmode() ==# "\<C-V>"
    for idx in range(len(lines))
     let lines[idx] = lines[idx][: column_end - 1]
     let lines[idx] = lines[idx][column_start - 1:]
    endfor
   else
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[ 0] = lines[ 0][column_start - 1:]
   endif
   return join(lines)  "returns selection as a string of space seperated line
  endfunction
vnoremap <leader>o :<BS><BS><BS><BS><BS>execute '!openlisturl' shellescape(GetVisualSelection())<CR>
"nnoremap <leader>o :execute "!notify-send \"" . GetVisualSelection() . "\""
"exe "!notify-send \"" . abc . "\""
" Open file at last closed location. (this is literal magic)
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
autocmd BufReadPost norm zz
" Change normal mode cursor to underline.
" set guicursor=n-v-c-sm:hor100,i-ci-ve:ver25,r-cr-o:hor20"
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright
" Enable autocompletion:
set wildmode=longest,list,full
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e " add trailing newline for ANSI C standard
autocmd BufWritePre * %retab!
" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Plug.vim -- all my plugin configuration is below,
" frozen makes the plugins not update.
" Auto install plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.config/nvim/plugged')
 Plug 'iamcco/markdown-preview.nvim'                   ,{ 'frozen': 1, 'do': 'cd app && npx --yes yarn install' }
" Plug 'lukas-reineke/indent-blankline.nvim'           ,{ 'frozen': 0 }
 Plug 'lukas-reineke/indent-blankline.nvim'            ,{ 'frozen': 1, 'tag': 'v2.20.8' }
 Plug 'nvim-treesitter/nvim-treesitter'                ,{ 'frozen': 0, 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-context'       ,{ 'frozen': 0 }
" Plug 'psliwka/vim-smoothie'                           ,{ 'frozen': 1 }
 Plug 'ggandor/leap.nvim'                              ,{ 'frozen': 1 }
 Plug 'HiPhish/rainbow-delimiters.nvim'                ,{ 'frozen': 0 }
 Plug 'folke/which-key.nvim'                           ,{ 'frozen': 1 }
 Plug 'nvim-telescope/telescope.nvim'                  ,{ 'frozen': 1 }
  Plug 'nvim-lua/plenary.nvim'                         ,{ 'frozen': 1 }
  Plug 'nvim-telescope/telescope-fzf-native.nvim'      ,{ 'frozen': 1, 'do': 'make' }
  Plug 'MunifTanjim/nui.nvim'                          ,{ 'frozen': 1 }
 Plug 'brenoprata10/nvim-highlight-colors'             ,{ 'frozen': 1 }
 Plug 'tpope/vim-surround'                             ,{ 'frozen': 1 }
 Plug 'tomtom/tcomment_vim'                            ,{ 'frozen': 1 }
 Plug 'echasnovski/mini.align'                         ,{ 'frozen': 1 }
 Plug 'preservim/nerdtree'                             ,{ 'frozen': 1 }
 Plug 'echasnovski/mini.indentscope'                   ,{ 'frozen': 1, 'branch': 'stable' }
 Plug 'morhetz/gruvbox'                                ,{ 'frozen': 1 }
 Plug 'sbdchd/neoformat'                               ,{ 'frozen': 1 }
 Plug 'axlebedev/vim-find-my-cursor'                   ,{ 'frozen': 1 }
 Plug 'junegunn/vim-slash'                             ,{ 'frozen': 1 }
 Plug 'monaqa/dial.nvim'                               ,{ 'frozen': 1 }
 Plug 'Eandrju/cellular-automaton.nvim'                ,{ 'frozen': 1 }
 Plug 'andrewferrier/wrapping.nvim'                    ,{ 'frozen': 1 }
 Plug 'williamboman/mason.nvim'                        ,{ 'frozen': 0 }
  Plug 'williamboman/mason-lspconfig.nvim'             ,{ 'frozen': 0 }
  Plug 'neovim/nvim-lspconfig'                         ,{ 'frozen': 0 }
call plug#end()

" Colors (must be loaded after gruvbox plugin).
if has('termguicolors')
 set termguicolors
endif
" More in the plugins section.
let g:gruvbox_transparent_bg = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 1
"let g:gruvbox_invert_indent_guides = 1
let g:gruvbox_hls_cursor = 'orange'
set bg=dark
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE
hi statusline ctermbg=NONE guibg=NONE gui=NONE guifg=#7d8618
hi LineNr guifg=#7d8618

" Tcomment.
" Comment at start of line.
let g:tcomment#options ={
\ 'whitespace': 'no',
\ 'strip_whitespace': '0'
\}

" MiniAlign.
lua << EOF
 require('mini.align').setup()
EOF

" Identscope.
lua << EOF
 require('mini.indentscope').setup({
  draw = {
   delay = 200,
   priority = 2,
  },
  symbol = '┇',
  options = {
   -- Type of scope's border: which line(s) with smaller indent to
   -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
   border = 'top',

   -- Whether to use cursor column when computing reference indent.
   -- Useful to see incremental scopes with horizontal cursor movements.
   indent_at_cursor = true,

   -- Whether to first check input line to be a border of adjacent scope.
   -- Use it if you want to place cursor on function header to get scope of
   -- its body.
   try_as_border = true,
  },
 })
EOF

"OLD
let g:indent_blankline_char = '│'
lua << EOF
 vim.opt.list = true
 vim.cmd [[highlight IndentBlanklineIndent1 guifg=#79740e gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent2 guifg=#b57614 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent3 guifg=#076678 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent4 guifg=#8f3f71 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent5 guifg=#427b58 gui=nocombine]]
 vim.cmd [[highlight IndentBlanklineIndent6 guifg=#af3a03 gui=nocombine]]
 require("indent_blankline").setup {
  space_char_blankline = "",
  -- show_current_context = true,
  -- show_current_context_start = true,
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

" Markdownpreview plug.
let g:mkdp_auto_start = 0
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

" Search plug.
noremap <plug>(slash-after) zz
if has('timers')
  " Blink 2 times with 50ms interval.
  noremap <expr> <plug>(slash-after) 'zz'.slash#blink(5, 50)
endif

" Find cursor plug.
nnoremap <leader>f <CMD>FindCursor #7d8618 500<CR>
noremap % %<CMD>FindCursor 0 500<CR>

" Extended increment, dial.nvim plug.
lua << EOF
local augend = require("dial.augend")
require("dial.config").augends:register_group{
-- default augends used when no group name is specified
default = {
 augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
 augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
 augend.date.alias["%Y/%m/%d"],  -- date (2022/02/19, etc.)
 augend.constant.alias.bool,    -- boolean value (true <-> false)
 augend.semver.alias.semver
 }
}
EOF
nmap  <C-s>  <Plug>(dial-increment)
nmap  <C-x>  <Plug>(dial-decrement)
nmap g<C-s> g<Plug>(dial-increment)
nmap g<C-x> g<Plug>(dial-decrement)
vmap  <C-s>  <Plug>(dial-increment)
vmap  <C-x>  <Plug>(dial-decrement)
vmap g<C-s> g<Plug>(dial-increment)
vmap g<C-x> g<Plug>(dial-decrement)

" Language server.
" Mason
lua << EOF
require("mason").setup({
 ui = {
 check_outdated_packages_on_open = true,
 }
})

require("mason-lspconfig").setup{
 ensure_installed = {
  "bashls",
  "cssls",
  "html",
  "clangd",
  "vimls",
  "jsonls",
  "marksman",
  "ruff_lsp",
  "pylsp",
 },
}

local lspconfig = require('lspconfig')
lspconfig.bashls.setup {}
lspconfig.cssls.setup{}
lspconfig.html.setup{}
lspconfig.clangd.setup{}
lspconfig.vimls.setup{}
lspconfig.jsonls.setup{}
lspconfig.marksman.setup{}
lspconfig.ruff_lsp.setup{}
lspconfig.pylsp.setup{
 settings = {
  pylsp = {
   plugins = {
    pycodestyle = {
     ignore = {'E302', 'E305'},
     -- maxLineLength = 100
    }
   }
  }
 }
}
-- lspconfig.rust_analyzer.setup {
--  -- Server-specific settings. See `:help lspconfig-setup`
--  settings = {
--    ['rust-analyzer'] = {},
--  },
--}

-- Visuals.
-- disable virtual_text (inline) diagnostics and use floating window
-- format the message such that it shows source, message and
-- the error code. Show the message with <space>e
vim.diagnostic.config({
 underline = false,
 update_in_insert = false,
 virtual_text = false,
 signs = true,
 float = {
  win_options = {
   winblend = 100
  },
  border = "single",
  format = function(diagnostic)
   return string.format(
    "%s (%s) [%s]",
    diagnostic.message,
    diagnostic.source,
    diagnostic.code or diagnostic.user_data.lsp.code
   )
  end,
 },
})

-- Transparent and groovy popup.
vim.api.nvim_set_hl(0, "Normal"                    , { bg = "none"    })
vim.api.nvim_set_hl(0, "NormalFloat"               , { bg = "none"    })
vim.api.nvim_set_hl(0, "FloatBorder"               , { fg = "#7d8618", bg = "none"})
vim.api.nvim_set_hl(0, "DiagnosticError"           , { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "DiagnosticWarn"            , { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "DiagnosticInfo"            , { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "DiagnosticHint"            , { fg = "#83a598" })
vim.api.nvim_set_hl(0, "DiagnosticOk"              , { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn" , { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo" , { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint" , { fg = "#83a598" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk"   , { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError"  , { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn"   , { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo"   , { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint"   , { fg = "#83a598" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk"     , { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticFloatingError"   , { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn"    , { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo"    , { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "DiagnosticFloatingHint"    , { fg = "#83a598" })
vim.api.nvim_set_hl(0, "DiagnosticFloatingOk"      , { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticSignError"       , { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn"        , { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo"        , { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint"        , { fg = "#83a598" })
vim.api.nvim_set_hl(0, "DiagnosticSignOk"          , { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "DiagnosticDeprecated"      , { fg = "#d3869b" })
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary"     , { fg = "#d3869b" })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
 group = vim.api.nvim_create_augroup('UserLspConfig', {}),
 callback = function(ev)
 -- Enable completion triggered by <c-x><c-o>
 vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

 -- Buffer local mappings.
 -- See `:help vim.lsp.*` for documentation on any of the below functions
 local opts = { buffer = ev.buf }
 vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
 vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
 vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
 vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
 vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
 vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
 vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
 vim.keymap.set('n', '<space>wl', function()
 print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
 end, opts)
 vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
 vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
 vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
 vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
 vim.keymap.set('n', '<space>f', function()
 vim.lsp.buf.format { async = true }
 end, opts)
 end,
})
EOF
" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
 -- A list of parser names, or "all" (the five listed parsers should always be installed)
 -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "all" },
 ensure_installed = { all },
 -- Install parsers synchronously (only applied to `ensure_installed`)
 sync_install = false,
 -- Automatically install missing parsers when entering buffer
 -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
 auto_install = true,
 -- List of parsers to ignore installing (or "all")
 ignore_install = { },
 ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
 -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
 highlight = {
  enable = true,
  -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
  -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
  -- the name of the parser)
  -- list of language that will be disabled
  disable = { toml, c },
  -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
  disable = function(lang, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
   return true
   end
   end,
   -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
   -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
   -- Using this option may slow down your editor, and you may see some duplicate highlights.
   -- Instead of true it can also be a list of languages
   additional_vim_regex_highlighting = false,
 },
}
EOF
" Wrapper.nvim plug.
lua << EOF
 require("wrapping").setup()
EOF

" Automaton plug.
nmap <leader>fml <cmd>CellularAutomaton make_it_rain<CR>

" Rainbow parentheses.
lua << EOF
 -- This module contains a number of default definitions
 local rainbow_delimiters = require 'rainbow-delimiters'
 ---@type rainbow_delimiters.config
 vim.g.rainbow_delimiters = {
  strategy = {
   [''] = rainbow_delimiters.strategy['global'],
   vim = rainbow_delimiters.strategy['global'],
  },
  query = {
   [''] = 'rainbow-delimiters',
   lua = 'rainbow-delimiters',
  },
  priority = {
   [''] = 110,
   lua = 210,
  },
  highlight = {
   'RainbowDelimiterRed',
   'RainbowDelimiterYellow',
   'RainbowDelimiterBlue',
   'RainbowDelimiterOrange',
   'RainbowDelimiterGreen',
   'RainbowDelimiterViolet',
   'RainbowDelimiterCyan',
  },
 }

 query = {
  -- Use parentheses by default
  [''] = 'rainbow-delimiters',
  -- Use blocks for Lua
  lua = 'rainbow-delimiters',
  -- Determine the query dynamically
  query = function(bufnr)
  -- Use blocks for read-only buffers like in `:InspectTree`
  local is_nofile = vim.bo[bufnr].buftype == 'nofile'
  return is_nofile and 'rainbow-blocks' or 'rainbow-delimiters'
  end
 }
EOF

" Treesitter context.
lua << EOF
 require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
 }
 vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
 end, { silent = true })
EOF

" Telescope
lua << EOF
local Layout = require("nui.layout")
local Popup = require("nui.popup")
local telescope = require("telescope")
local TSLayout = require("telescope.pickers.layout")

local function make_popup(options)
  local popup = Popup(options)
  function popup.border:change_title(title)
    popup.border.set_text(popup.border, "top", title)
  end
  return TSLayout.Window(popup)
end

telescope.setup({
  defaults = {
    layout_strategy = "flex",
    layout_config = {
      horizontal = {
        size = {
          width = "90%",
          height = "60%",
        },
      },
      vertical = {
        size = {
          width = "90%",
          height = "90%",
        },
      },
    },
    create_layout = function(picker)
      local border = {
        results = {
          top_left = "┌",
          top = "─",
          top_right = "┬",
          right = "│",
          bottom_right = "",
          bottom = "",
          bottom_left = "",
          left = "│",
        },
        results_patch = {
          minimal = {
            top_left = "┌",
            top_right = "┐",
          },
          horizontal = {
            top_left = "┌",
            top_right = "┬",
          },
          vertical = {
            top_left = "├",
            top_right = "┤",
          },
        },
        prompt = {
          top_left = "├",
          top = "─",
          top_right = "┤",
          right = "│",
          bottom_right = "┘",
          bottom = "─",
          bottom_left = "└",
          left = "│",
        },
        prompt_patch = {
          minimal = {
            bottom_right = "┘",
          },
          horizontal = {
            bottom_right = "┴",
          },
          vertical = {
            bottom_right = "┘",
          },
        },
        preview = {
          top_left = "┌",
          top = "─",
          top_right = "┐",
          right = "│",
          bottom_right = "┘",
          bottom = "─",
          bottom_left = "└",
          left = "│",
        },
        preview_patch = {
          minimal = {},
          horizontal = {
            bottom = "─",
            bottom_left = "",
            bottom_right = "┘",
            left = "",
            top_left = "",
          },
          vertical = {
            bottom = "",
            bottom_left = "",
            bottom_right = "",
            left = "│",
            top_left = "┌",
          },
        },
      }

      local results = make_popup({
        focusable = false,
        border = {
          style = border.results,
          text = {
            top = picker.results_title,
            top_align = "center",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal",
        },
      })

      local prompt = make_popup({
        enter = true,
        border = {
          style = border.prompt,
          text = {
            top = picker.prompt_title,
            top_align = "center",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal",
        },
      })

      local preview = make_popup({
        focusable = false,
        border = {
          style = border.preview,
          text = {
            top = picker.preview_title,
            top_align = "center",
          },
        },
      })

      local box_by_kind = {
        vertical = Layout.Box({
          Layout.Box(preview, { grow = 1 }),
          Layout.Box(results, { grow = 1 }),
          Layout.Box(prompt, { size = 3 }),
        }, { dir = "col" }),
        horizontal = Layout.Box({
          Layout.Box({
            Layout.Box(results, { grow = 1 }),
            Layout.Box(prompt, { size = 3 }),
          }, { dir = "col", size = "50%" }),
          Layout.Box(preview, { size = "50%" }),
        }, { dir = "row" }),
        minimal = Layout.Box({
          Layout.Box(results, { grow = 1 }),
          Layout.Box(prompt, { size = 3 }),
        }, { dir = "col" }),
      }

      local function get_box()
        local strategy = picker.layout_strategy
        if strategy == "vertical" or strategy == "horizontal" then
          return box_by_kind[strategy], strategy
        end

        local height, width = vim.o.lines, vim.o.columns
        local box_kind = "horizontal"
        if width < 100 then
          box_kind = "vertical"
          if height < 40 then
            box_kind = "minimal"
          end
        end
        return box_by_kind[box_kind], box_kind
      end

      local function prepare_layout_parts(layout, box_type)
        layout.results = results
        results.border:set_style(border.results_patch[box_type])

        layout.prompt = prompt
        prompt.border:set_style(border.prompt_patch[box_type])

        if box_type == "minimal" then
          layout.preview = nil
        else
          layout.preview = preview
          preview.border:set_style(border.preview_patch[box_type])
        end
      end

      local function get_layout_size(box_kind)
        return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
      end

      local box, box_kind = get_box()
      local layout = Layout({
        relative = "editor",
        position = "50%",
        size = get_layout_size(box_kind),
      }, box)

      layout.picker = picker
      prepare_layout_parts(layout, box_kind)

      local layout_update = layout.update
      function layout:update()
        local box, box_kind = get_box()
        prepare_layout_parts(layout, box_kind)
        layout_update(self, { size = get_layout_size(box_kind) }, box)
      end

      return TSLayout(layout)
    end,
  },
})
 require('telescope').load_extension('fzf')
 local builtin = require('telescope.builtin')
 vim.keymap.set('n', '<leader>tf', builtin.find_files, {})
 vim.keymap.set('n', '<leader>tg', builtin.live_grep, {})
 vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
 vim.keymap.set('n', '<leader>th', builtin.help_tags, {})
EOF

" Nerdtree (file tree).
"nnoremap <leader>nf :NERDTreeFocus<CR>
"nnoremap <leader>n :NERDTree<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>ns :NERDTreeFind<CR>
nnoremap <silent> <C-o> :<CR>
