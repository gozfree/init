
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufReadPost *
        \ if line("'\"")>0&&line("'\"")<=line("$") |
        \     exe "normal g'\"" |
        \ endif  "自动载入上一次位置
syntax enable
syntax on           "自动高亮
set number          "显示行号
set hlsearch        "高亮搜索结果
set incsearch       "搜索边输入边显示
set colorcolumn=80  "80列
hi ColorColumn ctermbg=235 guibg=#2c2d27
"au BufRead,BufNewFile *.asm,*.h,*.hh,*.hpp,*.hxx,*.c,*.cc,*.cpp,*.cxx,*.java,*.cs,*.sh,*.lua,*.pl,*.pm,*.py,*.rb,*.hs,*.vim 2match Underlined /.\%81v/
"行尾空格显示
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd FileType c,cc,cpp,h,hh,hpp set ts=4 | set expandtab "c/c++文件tab对应4空格

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编码相关
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
"set fileencodings=utf-8,chinese,latin-1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"自动补全匹配
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap " <c-r>=QuoteDelim('"')<CR>
:inoremap ' ''<ESC>i
:inoremap ' <c-r>=QuoteDelim("'")<CR>

function QuoteDelim(char)
    let line = getline('.')
    let col = col('.')
    if line[col - 2] == "\\"
        return a:char
    elseif line[col - 1] == a:char
        return "\<Right>"
    else
        return a:char.a:char."\<Esc>i"
    endif
endfunc

function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自定义快捷键
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"文件之间拷贝
"copy the current visual selection to ~/.vbuf
vmap <S-y> :w! ~/.vbuf<CR>
"copy the current line to the buffer file if no visual selection
nmap <S-y> :.w! ~/.vbuf<CR>
"paste the contents of the buffer file
nmap <S-p> :r ~/.vbuf<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"进行版权声明的设置
"添加或更新头
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :call TitleDet()<cr>'s
function TitleDet()
    let n = 1
    while n < 8
        let line = getline(n)
        let str = '^\s\*\s*\S*updated:\S*.*$'
        if line =~ str
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddTitle()
endfunction

function AddTitle()
    call append(0, "/******************************************************************************")
    call append(1, " * Copyright (C) 2014-2016")
    call append(2, " * file:    ".expand("%:t"))
    call append(3, " * author:  gozfree <gozfree@163.com>")
    call append(4, " * created: ".strftime("%Y-%m-%d %H:%M"))
    call append(5, " * updated: ".strftime("%Y-%m-%d %H:%M"))
    call append(6, " ******************************************************************************/")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunc
function UpdateTitle()
    normal m'
    execute '/ * updated:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
    normal ''
    execute "noh"
    echohl WarningMsg | echo "Successful in updating the copyright." | echohl None
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"文件和函数列表
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F12> :Tlist<cr>'s
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_Exit_OnlyWindow=1
let g:winManagerWindowLayout='FileExplorer|TagList'

" 设置NerdTree
map <F8> :NERDTreeMirror<CR>
map <F8> :NERDTreeToggle<CR>"

map <F2> :call Check_Tab()<cr>'s
function Check_Tab()
    set list            " 显示Tab符，使用一高亮竖线代替
    set listchars=tab:\├\─
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cscope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F9> :call Do_CsTag()<cr>'s
function Do_CsTag()
    if(executable("cscope") && has("cscope") )
        silent! execute "!find . -name \"*.h\" -o -name \"*.hh\" -o -name \"*.hpp\" -o -name \"*.hxx\" -o -name \"*.c\" -o -name \"*.cc\" -o -name \"*.cpp\" -o -name \"*.cxx\" -o -name \"*.java\" -o -name \"*.py\" > cscope.files"
        silent! execute "!cscope -b"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunc

