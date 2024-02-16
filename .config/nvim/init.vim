set virtualedit+=onemore
"convert to unix filetype on save
set ff=unix
let mapleader=","
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
" Hide tildes on emtpy lines
set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾
" Remaps.
" Makes o insert a blank line in normal mode
nnoremap o o<Esc>0"_D
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
 Plug 'iamcco/markdown-preview.nvim',           { 'do': 'cd app && npx --yes yarn install' }
 Plug 'echasnovski/mini.indentscope',           { 'branch': 'stable', 'frozen': 1 }
" Plug 'lukas-reineke/indent-blankline.nvim',   { 'frozen': 0 }
 Plug 'lukas-reineke/indent-blankline.nvim',    { 'tag': 'v2.20.8',   'frozen': 1 }
 Plug 'nvim-treesitter/nvim-treesitter',        { 'frozen': 0, 'do': ':TSUpdate'}
 Plug 'psliwka/vim-smoothie',                   { 'frozen': 1 }
 Plug 'easymotion/vim-easymotion',              { 'frozen': 1 }
" Plug 'junegunn/fzf',                           { 'frozen': 1 }
 Plug 'brenoprata10/nvim-highlight-colors',     { 'frozen': 1 }
 Plug 'tpope/vim-surround',                     { 'frozen': 1 }
 Plug 'tomtom/tcomment_vim',                    { 'frozen': 1 }
 Plug 'echasnovski/mini.align',                 { 'frozen': 1 }
 Plug 'morhetz/gruvbox',                        { 'frozen': 1 }
 Plug 'sbdchd/neoformat',                       { 'frozen': 1 }
 Plug 'axlebedev/vim-find-my-cursor',           { 'frozen': 1 }
 Plug 'junegunn/vim-slash',                     { 'frozen': 1 }
 Plug 'monaqa/dial.nvim',                       { 'frozen': 1 }
 Plug 'kien/rainbow_parentheses.vim',           { 'frozen': 1 }
 Plug 'nvim-treesitter/nvim-treesitter-context',{ 'frozen': 0 }
 Plug 'Eandrju/cellular-automaton.nvim',        { 'frozen': 1 }
 Plug 'andrewferrier/wrapping.nvim',            { 'frozen': 1 }
 Plug 'williamboman/mason.nvim',                { 'frozen': 0 }
 Plug 'williamboman/mason-lspconfig.nvim',      { 'frozen': 0 }
 Plug 'neovim/nvim-lspconfig',                  { 'frozen': 0 }
call plug#end()

" Colors (must be loaded after gruvbox plugin).
" More in the plugins section.
let g:gruvbox_transparent_bg = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 1
"let g:gruvbox_invert_indent_guides = 1
let g:gruvbox_hls_cursor = 'orange'
set bg=dark
"set t_8f=^[[38;2;%lu;%lu;%lum " set foreground color
"set t_8b=^[[48;2;%lu;%lu;%lum " set background color
colorscheme gruvbox
set t_Co=256                         " Enable 256 colors
set termguicolors                    " Enable GUI colors for the terminal to get truecolor
hi Normal guibg=NONE ctermbg=NONE
hi statusline guibg=NONE gui=NONE guifg=#7d8618
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
  symbol = '┇'
 })
EOF

" Indentblankline.
"NEW
"lua << EOF
"require("ibl").setup{
" debounce = 100,
" indent = {
"  char = "│",
"  --tab_char = { "a", "b", "c" },
"  repeat_linebreak = true,
" },
" whitespace = {
"  remove_blankline_trail = true,
"  highlight = { "Whitespace", "NonText" },
" },
" scope = {
"  enabled = true,
"  show_start = true,
"  show_end = false,
"  injected_languages = true,
"  highlight = { "Function", "Label" },
"  priority = 600,
" },
"}
"EOF
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
" Rainbow parentheses plug.
autocmd VimEnter * :RainbowParenthesesToggle
autocmd Syntax * :RainbowParenthesesLoadRound
autocmd Syntax * :RainbowParenthesesLoadSquare
autocmd Syntax * :RainbowParenthesesLoadBraces

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
--"grammarly",
  "marksman"
 },
}

local lspconfig = require('lspconfig')
lspconfig.bashls.setup {}
lspconfig.cssls.setup{}
lspconfig.html.setup{}
lspconfig.clangd.setup{}
lspconfig.vimls.setup{}
lspconfig.jsonls.setup{}
--lspconfig.grammarly.setup{}
lspconfig.marksman.setup{}
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
  disable = { },
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
