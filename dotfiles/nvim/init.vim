"____________________________________"
"filetype plugin indent on

call plug#begin()
	Plug 'rebelot/kanagawa.nvim'
	Plug 'neomake/neomake'
	Plug 'mattn/emmet-vim'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'JellyApple102/easyread.nvim', { 'do': ':UpdateRemotePlugins', 'branch': 'main' }
call plug#end()

"____________________________________"
:set number relativenumber
:set cc=80
:set clipboard=unnamedplus
:set noswapfile
:set ignorecase
:set smartcase

"____________________________________"
let g:impact_transbg=1

"___________________________________"
:syntax on
:colorscheme kanagawa-dragon
":colorscheme ocha-color
":colorscheme old_codedark
"set termguicolors

"___________________________________"
:set list
:set showbreak=↪
:set listchars=tab:→\ ,trail:·,eol:¬,extends:…,precedes:…
hi NonText ctermfg=8
hi SpecialKey ctermfg=8

"___________________________________"
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set smartindent
:set autoindent
:set scrolloff=10
"____________________________________"
:set wildmenu
:set incsearch
:set hlsearch

"____________________________________"
":set mouse=a
:set cursorline
:set tabpagemax=100

"____________________________________"
:syntax sync minlines=300
:set synmaxcol=300
:set regexpengine=1


"____________________________________ EasyRead"
:luafile ~/.config/nvim/easyreadconf.lua

"____________________________________ Deoplete"
let g:deoplete#enable_at_startup = 1
let g:deoplete#complete_method = "complete"
"let g:deoplete#ignore_sources = {}
"let g:deoplete#ignore_sources.ocaml = ['buffer', 'around', 'member', 'tag']
"let g:deoplete#auto_complete_delay = 0
autocmd CompleteDone * silent! pclose!

"____________________________________ Neomake"
autocmd BufWinEnter,BufWritePost *.c :Neomake gcc

call neomake#configure#automake('w')
let g:neomake_open_list=0
let g:c_syntax_for_h=1
let g:neomake_c_enabled_makers=['gcc']
let g:neomake_gcc_args=[
		\ '-fsyntax-only',
		\ '-Wall',
		\ '-Werror',
		\ '-Wextra',
		\ '-Wconversion',
		\ '-Wunreachable-code',
		\ '-Winit-self',
		\ '-I../includes',
		\ '-I../include',
		\ '-I.',
		\ ]
"	\ '-Wfloat-equal',
"	\ '-Wshadow',
"	\ '-Wpointer-arith',
"	\ '-Wcast-align',
"	\ '-Wstrict-prototypes',
"	\ '-Wwrite-strings',
"	\ '-Waggregate-return',

"____________________________________"

function! Html_config ()
	hi HtmlTag cterm=NONE ctermfg=white ctermbg=NONE
	hi HtmlEndTag cterm=NONE ctermfg=white ctermbg=NONE
endfunction

function! Js_config ()
	syn match Keyword "from"
	syn match Boolean "constructor"
	syn match Boolean "componentWillMount"
	syn match Boolean "componentDidMount"
	syn match Boolean "componentWillUnmount"
	syn match Boolean "componentDidUnmount"
endfunction

function! Yaml_config ()
	set tabstop=2
	set softtabstop=2
	set expandtab
	set shiftwidth=2
	set et
	set ai
	set cuc
	set cul
	set filetype=yaml
"	set textwidth=80
"	set formatoptions+=t
	:xnoremap <silent> <space> mZ:call CommentToggleHash()<CR>`Z
endfunction

function! Python_config ()
	set tabstop=2
	set softtabstop=2
	set expandtab
	set shiftwidth=2
	set ai
	set cuc
	set cul
	syn match pythonBoolean "\(\W\|^\)\@<=self\(\.\)\@="
	let python_highlight_all = 1
	:xnoremap <silent> <space> mZ:call CommentToggleHash()<CR>`Z
endfunction

function! Nix_config ()
	set tabstop=2
	set softtabstop=2
	set expandtab
	set shiftwidth=2
	set ai
	set cuc
	set cul
	syn match pythonBoolean "\(\W\|^\)\@<=self\(\.\)\@="
	let python_highlight_all = 1
	:xnoremap <silent> <space> mZ:call CommentToggleHash()<CR>`Z
endfunction

function! Ruby_config ()
	set tabstop=2
	set softtabstop=2
	set expandtab
	set shiftwidth=2
	set ai
	set cuc
	set cul
	:xnoremap <silent> <space> mZ:call CommentToggleHash()<CR>`Z
endfunction

function! OCaml_config ()
	set sts=2
	set sw=2
	set sta
	set et
"	let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
"	execute 'set rtp+=' . g:opamshare . '/merlin/vim'
"	execute 'runtime ' . g:opamshare . '/merlin/vim/plugin/**/*.vim'
"	" ocp-indent
"	execute 'set rtp^=' . g:opamshare . '/ocp-indent/vim'
"	execute 'runtime ' . g:opamshare . '/ocp-indent/vim/plugin/**/*.vim'

"	let g:neomake_c_enabled_makers=['merlin']
	"autocmd BufWritePost *.ml execute MerlinErrorCheck | redraw!
	syn match Keyword "let"
	syn match Keyword " in "
	syn match Keyword "functor"
	:xnoremap <silent> <space> mZ:call CommentToggleHash()<CR>`Z
endfunction

function! Kotlin_config ()
	set cc=120
	set tabstop=4
	set softtabstop=4
	set expandtab
	set shiftwidth=4
	:xnoremap <silent> <space> mZ:call CommentToggle()<CR>`Z
endfunction

function! Golang_config ()
	set cc=120
	set tabstop=2
	set softtabstop=2
	set expandtab
	set shiftwidth=2
"	syn match Keyword "func"
"	syn match Keyword "return"
"	syn match Keyword "package"
	:xnoremap <silent> <space> mZ:call CommentToggle()<CR>`Z
endfunction

function! Elixir_config ()
	set cc=120
	set tabstop=2
	set softtabstop=2
	set expandtab
	set shiftwidth=2
	let g:neomake_elixir_enabled_makers = ['mix']
	let g:neomake_c_enabled_makers = ['mix']
	autocmd! BufWritePost * Neomake
	:xnoremap <silent> <space> mZ:call CommentToggleHash()<CR>`Z
endfunction

autocmd BufRead,BufNewFile *.go set filetype=go
autocmd BufRead,BufNewFile *.tf set filetype=tf
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd BufRead,BufNewFile *.hcl set filetype=hcl
autocmd BufRead,BufNewFile *.j2 set filetype=jinja2
autocmd BufRead,BufNewFile *.bu set filetype=butane
autocmd BufRead,BufNewFile *.svelte set filetype=html
autocmd BufRead,BufNewFile *.ex,*.exs set filetype=elixir
autocmd BufRead,BufNewFile *.eex,*.leex set filetype=eelixir
autocmd BufRead,BufNewFile *.kt,*.kts,*.ktm set filetype=kotlin

autocmd FileType html,css,php,javascript,eelixir,svelte EmmetInstall
"autocmd FileType ocaml set rtp+=/home/mnhdrn/.opam/default/share/merlin/vim
autocmd Filetype html exe Html_config()
autocmd Filetype python exe Python_config()
autocmd Filetype javascript exe Js_config()
autocmd FileType ruby,erb,inky,inky-erb exe Ruby_config()
autocmd FileType yaml,tf,hcl,jinja2,butane exe Yaml_config()
autocmd FileType nix exe Nix_config()
autocmd Filetype ocaml exe OCaml_config()
autocmd Filetype elixir exe Elixir_config()
autocmd Filetype kotlin exe Kotlin_config()
autocmd Filetype golang exe Golang_config()


let g:user_emmet_install_global = 0

"____________________________________"
"Only apply to .txt files...
augroup HelpInTabs
	autocmd!
	autocmd BufEnter	*.txt	call HelpInNewTab()
augroup END

"Only apply to help files...
function! HelpInNewTab ()
	if &buftype == 'help'
		"Convert the help window to a tab
		execute "normal \<C-W>T"
	endif
endfunction
"____________________________________"
function! CommentToggle()
	execute ':silent! s/\([^ ]\)/\/\/ \1/'
	execute ':silent! s/^\( *\)\/\/ \/\/ /\1/'
endfunction

function! CommentToggleHash()
	execute ':silent! s/\([^ ]\)/\# \1/'
	execute ':silent! s/^\( *\)\# \# /\1/'
endfunction

"smart indent when entering insert mode with i on empty lines"
function! IndentWithI()
	if len(getline('.')) == 0
		return "\"_cc"
	else
		return "i"
	endif
endfunction

function ToggleTheGoyo()
	if exists('#Goyo')
		set list
	else
		set nolist
	endif

endfunction

"____________________________________"
let g:BASH_Ctrl_j = 'off'
let g:BASH_Ctrl_s = 'off'

:map <C-n> :Texplore<CR>
:nnoremap  M :EasyreadToggle<CR>
:nnoremap <space> :noh<CR>
:nnoremap <S-j> :tabn<CR>
:nnoremap <S-k> :tabp<CR>
:nnoremap <F3> :Stdheader<CR>
:nnoremap <expr> i IndentWithI()
:nnoremap <C-k> :m.+1<CR>==
:nnoremap <C-j> :m.-2<CR>==
:vnoremap <C-k> :m'>+1<CR>gv=gv
:vnoremap <C-j> :m'<-2<CR>gv=gv

"_ to fix home and end key in nvim
:map <esc>OH <home>
:cmap <esc>OH <home>
:imap <esc>OH <home>
:map <esc>OF <end>
:cmap <esc>OF <end>
:imap <esc>OF <end>

"____________________________________"
"
" Use I to enter in insert at the begining of the line
" Use A to enter in insert at the ending of the line
"
" Go to the top of the file gg
" Go to the end of the file G
"
" Use :terminal to open a terminal in vim
"
" A to enter in insert mode at the begining of the line
" I to enter in insert mode at the end of the line
"
" Center screen "normal zz
" Go to top screan H
" Go to bottom of screen L
" Go to center of screen M
" Make down screen ctrl + e
" Make up screen ctrl + y
"
" Go to the begining of line 0
" Go to the end of line $
" Go to first char of line ^
" Go to the last char of line g_
"
" Go to the next choosen character f(x)
" Go to the previous choosen character F(x)
" Repeat previous f/F in the same way ;
" Repeat previous f/F in reversed way ,
"
" Set lowercase gu
" Set uppercase gU
"
" Use * to seek the word where you are
" w to go to the next word, e to go to the end of the next word
" b to go to the previous word
"
" Use :set filetype=php || html for indentation in php
