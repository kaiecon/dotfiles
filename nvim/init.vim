scriptencoding=utf-8
filetype off

let mapleader = "\<Space>"

if has('nvim')
  let g:python3_host_prog = '/usr/local/bin/python3'
  let g:python_host_prog = '/usr/local/bin/python2'
endif

"" dein
" パス設定
let s:dein_dir = fnamemodify('~/.cache/dein/', ':p') "<-お好きな場所
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim' "<-固定

" dein.vim本体の存在チェックとインストール
if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' shellescape(s:dein_repo_dir)
    silent! execute 'helptags' s:dein_repo_dir . '/doc/'
endif

" dein.vim本体をランタイムパスに追加
if &runtimepath !~# '/dein.vim'
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

" 設定開始
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " プラグインリストを収めた TOML ファイル
    " 予め TOML ファイル（後述）を用意しておく
    let g:rc_dir    = expand('~/.config/nvim/rc')
    let s:toml      = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

    " TOML を読み込み、キャッシュしておく
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    " 設定終了
    call dein#end()
    call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
    call dein#install()
    call dein#end()
endif

filetype plugin indent on
syntax enable

""" denite

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr> <C-j>
        \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> <C-l>
        \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <Tab>
        \ denite#do_map('choose_action')
endfunction

nnoremap [denite] <Nop>
nmap <Leader>u [denite]

nnoremap <silent> [denite]f :<C-u>Denite file<CR>
nnoremap <silent> [denite]r :<C-u>Denite file/rec<CR>
nnoremap <silent> [denite]m :<C-u>Denite file_mru<CR>
nnoremap <silent> [denite]b :<C-u>Denite buffer<CR>

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

" Change file/rec command.
call denite#custom#var('file/rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

" " Add custom menus
" let s:menus = {}
" let s:menus.zsh = {
" \ 'description': 'Edit your import zsh configuration'
" \ }
" let s:menus.zsh.file_candidates = [
" \ ['zshrc', '~/.zshrc'],
" \ ['zshenv', '~/.zshenv'],
" \ ]
" let s:menus.my_commands = {
" \ 'description': 'Example commands'
" \ }
" let s:menus.my_commands.command_candidates = [
" \ ['Split the window', 'vnew'],
" \ ['Open zsh menu', 'Denite menu:zsh'],
" \ ['Format code', 'FormatCode', 'go,python'],
" \ ]
" call denite#custom#var('menu', 'menus', s:menus)

" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Floating window
let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7

" Change denite default options
call denite#custom#option('default', {
    \ 'split': 'floating',
    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
    \ })

"" previm
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

let g:previm_enable_realtime = 1

filetype plugin indent on     " required!
filetype indent on

"" indentLine
let g:indentLine_color_term = 111
let g:indentLine_char = '|'

let g:tex_conceal = ''

"" 自動コンパイル
" filetype plugin on
" augroup setAutoCompile
"     autocmd!
"     autocmd BufWritePost *.cc :!clang++ -std=c++14 %:p
" augroup END

"" テンプレート読み込み
augroup readTemplate
  autocmd!
  autocmd BufNewFile *.{cpp,cc} 0r $HOME/.vim/templete/cpp.txt
augroup END

" set runtimepath+=~/.config/vim

if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
  endif

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"" Options 
set t_Co=256
set laststatus=2
set clipboard+=unnamed 
set number
set backspace=indent,eol,start
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set encoding=utf-8
set ignorecase
set smartcase
set wildmenu
set wildmode=longest:full,full
set infercase
set hlsearch!
nnoremap <ESC><ESC> :noh<CR>
if has('mac')
  nnoremap ;  :
  nnoremap :  ;
  vnoremap ;  :
  vnoremap :  ;
endif
" 括弧補完
inoremap {<CR> {}<LEFT><CR><ESC><S-o>
inoremap (<CR> ()<LEFT>
 
syntax on

"" References
" dein
" http://qiita.com/naoyuki1019/items/943f8bf561eae151a9e7
" http://qiita.com/delphinus/items/00ff2c0ba972c6e41542
" neosnippet 
" https://qiita.com/ahiruman5/items/4f3c845500c172a02935
" vim-clang
" https://qiita.com/koara-local/items/815b08ff5c6673d8a5c6
