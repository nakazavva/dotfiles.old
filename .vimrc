if 0 | endif

let s:true = 1
let s:false = 0

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \    (!executable('xdg-open') &&
      \    system('uname') =~? '^darwin'))
let s:is_linux = !s:is_mac && has('unix')

let s:vimrc = expand("<sfile>:p")
let $MYVIMRC = s:vimrc

if s:is_windows
  let $DOTVIM = expand('~/vimfiles')
else
  let $DOTVIM = expand('~/.vim')
endif

let $VIMBUNDLE = $DOTVIM . '/bundle'
let $NEOBUNDLEPATH = $VIMBUNDLE . '/neobundle.vim'

if has('vim_starting')
    set runtimepath+=$NEOBUNDLEPATH
endif

if isdirectory($NEOBUNDLEPATH) == s:true

    call neobundle#begin(expand($VIMBUNDLE))
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/neomru.vim'
    NeoBundle 'Shougo/neocomplete.vim'
    NeoBundle 'Shougo/unite-outline'
    NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make',
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \    },
    \ }

    NeoBundle 'w0ng/vim-hybrid'
    NeoBundle 'bling/vim-airline'
    NeoBundle 'tpope/vim-fugitive'

"    NeoBundle 'scrooloose/syntastic.git'
    NeoBundle 'fatih/vim-go'

    NeoBundle 'tyru/caw.vim'

    NeoBundle 'pangloss/vim-javascript'
    NeoBundle 'mxw/vim-jsx'

    NeoBundle 'leafgarland/typescript-vim'
    NeoBundle 'Quramy/tsuquyomi'

    NeoBundleLazy 'plasticboy/vim-markdown', {
    \ 'autoload' : {
    \   'filetypes' : ['markdown'] }
    \ }

    NeoBundle 'kannokanno/previm'
    NeoBundle 'tyru/open-browser.vim'

    NeoBundle 'digitaltoad/vim-jade.git'

    call neobundle#end()
    filetype plugin indent on
    NeoBundleCheck
else
    if !isdirectory($VIMBUNDLE)
        call mkdir($VIMBUNDLE, 'p')
        sleep 1 | echo printf("Creating '%s'.", $VIMBUNDLE)
    endif
    cd $VIMBUNDLE

    if executable('git')
        call system('git clone git://github.com/Shougo/neobundle.vim')
        if v:shell_error
            throw 'neobundleinit: Git error.'
        endif
    endif

    set runtimepath& runtimepath+=$NEOBUNDLEPATH
    call neobundle#rc($VIMBUNDLE)
    try
        echo printf("Reloading '%s'", $MYVIMRC)
        source $MYVIMRC
    catch
	echohl ErrorMsg
	echomsg 'neobundleinit: $MYVIMRC: could not source.'
	echohl None
    finally
	echomsg 'Installed neobundle.vim'
    endtry

    echomsg 'Finish!'
endif

let mapleader=','

" Shougo/unite.vim "{{{2
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1 
" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
endif

call unite#custom_default_action('file', 'split')
noremap <Leader>uf :Unite file<CR>
noremap <Leader>ur :Unite file_rec<CR>
noremap <Leader>ug :Unite file_rec/git<CR>
noremap <Leader>um :Unite file_mru<CR>
" grep検索
nnoremap <silent> <Leader>g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" ディレクトリを指定してgrep検索
nnoremap <silent> <Leader>dg :<C-u>Unite grep -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> <Leader>cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
" grep検索結果の再呼出
nnoremap <silent> <Leader>r :<C-u>UniteResume search-buffer<CR>
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()"{{{
    "ESCでuniteを終了
    nmap <buffer> <ESC> <Plug>(unite_exit)
    "入力モードのときjjでノーマルモードに移動
    imap <buffer> jj <Plug>(unite_insert_leave)
    "入力モードのときctrl+wでバックスラッシュも削除
    imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
    "ctrl+jで縦に分割して開く
    nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    "ctrl+jで横に分割して開く
    nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    "ctrl+oでその場所に開く
    nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
    inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
    inoremap <silent> <buffer> <expr> ,a unite#do_action('absolute_path')
endfunction"}}}

" Shougo/neocomplete.vim "{{{2
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1

" scrooloose/syntastic.git "{{{2
let g:syntastic_check_on_open=0
let g:syntastic_check_on_save=1
let g:syntastic_auto_loc_list=0
let g:syntastic_loc_list_height=6
let g:syntastic_enable_signs=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" faith/vim-go "{{{2
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" tyru/caw.vim "{{{2
nmap <leader>c <Plug>(caw:i:toggle)
vmap <leader>c <Plug>(caw:i:toggle)

let g:vim_markdown_folding_disabled=1

"######################################################################################
"" Airline:
"######################################################################################
set laststatus=2
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Use backslash
if s:is_mac
  noremap ¥ \
  noremap \ ¥
endif

augroup vimrc
     autocmd!
     autocmd BufWritePost *vimrc source $MYVIMRC
     autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
     autocmd FileType jade,yml,yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

set t_Co=256
set encoding=utf-8 " エンコード
set fileencoding=utf-8 " ファイルエンコード
set noswapfile " .swapファイルを作らない
set nowritebackup " バックアップファイルを作らない
set nobackup " バックアップをしない
set number " 行番号を表示
set ruler " 右下に表示される行・列の番号を表示する
set cursorline " カーソルライン表示
set ignorecase " 小文字の検索でも大文字も見つかるようにする
set smartcase " ただし大文字も含めた検索の場合はその通りに検索する
set incsearch " インクリメンタルサーチを行う
set hlsearch " 検索結果をハイライト表示
set history=10000 " コマンド、検索パターンを10000個まで履歴に残す
set mouse=a " マウスモード有効
set showcmd " コマンドを画面最下部に表示する
set ttymouse=xterm2 " xtermとscreen対応
set expandtab " タブをスペースに置き換える
set tabstop=4 " タブを画面で表示する際の幅
set shiftwidth=4 " インデント時のスペースの数
set completeopt=menuone " 補完時にプレビューウィンドウが開かないようにする、分割時にガチャガチャ動くのを防ぐ
set backspace=indent,eol,start " バックスペースの動きを自然に
set clipboard+=unnamed " 無名レジスタに入るデータを＊レジスタにもいれる
set background=dark
colorscheme hybrid

filetype on
syntax on
