 " Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif

" platform
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \    (!executable('xdg-open') &&
      \    system('uname') =~? '^darwin'))
let s:is_linux = !s:is_mac && has('unix')

let s:vimrc = expand("<sfile>:p")
let $MYVIMRC = s:vimrc

" NeoBundle path
if s:is_windows
  let $DOTVIM = expand('~/vimfiles')
else
  let $DOTVIM = expand('~/.vim')
endif
let $VIMBUNDLE = $DOTVIM . '/bundle'
let $NEOBUNDLEPATH = $VIMBUNDLE . '/neobundle.vim'

" Add neobundle to runtimepath.
if has('vim_starting')
    set runtimepath+=$NEOBUNDLEPATH
endif

" NeoBundle: {{{1
if stridx(&runtimepath, $NEOBUNDLEPATH) != -1

    call neobundle#begin(expand($VIMBUNDLE))
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/neomru.vim'


    call neobundle#end()
    filetype plugin indent on
    NeoBundleCheck
else
    echo "Installing neobundle.vim..."
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
endif

" Shougo/unite.vim "{{{2
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1 

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
" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
endif

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

augroup vimrc
     autocmd!
     autocmd BufWritePost *vimrc source $MYVIMRC
     autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
 augroup END

let mapleader=','
let mapleader=','
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

