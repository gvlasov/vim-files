function! ToggleComments() 
	execute "normal! ^"
	let curCol=col(".")-1
	let line=getline(".")
	let startLine=line(".")
	let on=1
	if line[curCol]==#"/" && line[curCol+1]==#"/" && line[curCol+2]==#" "
		let add=0
	else
		let add=1
	endif
	if add
		let c=0
		while 1
			execute "normal! i//\ \<Esc>hhj"
			"echom "Current character: >".getline(".")[curCol]."<"
			if getline(".")[curCol] != "\t"
				break
			else
				let c=c+1
			endif
		endwhile
		if c>0
			execute "normal! i//\ \<Esc>"
		endif
		call cursor(startLine, curCol)
	else
		execute "normal! ^"
		let line=getline(".")
		let broken=0
		while line[col(".")-1]==#"/"
			if line(".")==1
				let broken=1
				break
			endif
			execute "normal! k^"
			let line=getline(".")
		endwhile
		if broken == 0
			execute "normal! j^"
		endif
		let line=getline(".")
		while line[col(".")-1]==#"/"
			while line[col(".")-1]==#"/" || line[col(".")-1]==#" "
				execute "normal! x"
				let line=getline(".")
			endw
			execute "normal! j^"
			let line=getline(".")
		endwhile
		call cursor(startLine, curCol)
	endif
endfunction
" Function for proper JavaScript folding
function! JavaScriptFold() 
	" sy region foldBraces start=/{/ end=/}/ transparent fold keepend extend
	function! JSFold()
		return substitute(getline(v:foldstart), "\t", "    ", "g")
	endfunction
	setl foldtext=JSFold()
endfunction

function! InsertJSDoc()
	execute "normal! i/**\<cr> *\<cr>*/\<esc>k$a \<esc>"
	startinsert!
endfunction

function! InsertJSDocLineStart()
	let prevline=getline(".")
	if match(prevline, "^\\s*\\*[^\\/]")!=-1 || match(prevline, "^\\s*\\*$")!=-1
		execute "normal! a\<cr>* "
	elseif match(prevline, "^\\s*\\/\\*\\*")!=-1
		execute "normal! a\<cr> * "
	else
		execute "normal! a\<cr>s\<c-h>"
	endif
	startinsert
	let pos = getpos(".")
	let pos[2] += 1
	call cursor(pos[1], pos[2])
endfunction
 
function! s:HowManyTabs(lnr)
	return len(matchstr(getline(a:lnr), "^\t*"))
endfunction
function! s:ToEdgeOfBlock(direction)
	let startlnr=line('.')
	let startlinetabs=s:HowManyTabs(startlnr)
	let shift=(a:direction ? 1 : -1)
	let nextlnr=startlnr+shift
	while (s:HowManyTabs(nextlnr)>startlinetabs || len(matchstr(getline(nextlnr), "[^\t ]"))==0) && 1<=nextlnr && nextlnr<=line('$')
		let nextlnr+=shift
	endwhile
	return nextlnr.'gg'
endfunction
function! s:InsertJSBreakpoint(method, defaultText)
	if matchstr(getline("."), "^[ \t]*$") ==# getline(".")
	" If current line is empty
		let lnr = line(".")
		let l = getline(lnr)
		while matchstr(l, "^[ \t]*$") ==# l
			let lnr -= 1
			let l = getline(lnr)
		endwhile
		if len(matchstr(l, "{[ \t]*$")) > 0
			let tabs = repeat("\<Tab>", len(matchstr(getline(lnr), "\t*"))+1)
		else
			let tabs = repeat("\<Tab>", len(matchstr(getline(lnr), "\t*")))
		endif
		execute "normal! 0i" . tabs . a:method . ";\<esc>i"		
	else
		if len(matchstr(getline("."), "{[ \t]*$")) > 0
			let tab = "\t"
		else
			let tab = ""
		endif
		execute "normal! A\<cr>" . tab . a:method. ";\<esc>i"		
	endif
	if a:defaultText==1
		if g:insertJsLog==1
			let text = "\"KAKAKA\""
		elseif g:insertJsLog==2
			let text = "\"KOKOKO\""
		elseif g:insertJsLog==3
			let text = "\"KEKEKE\""
			let g:insertJsLog = 0
		endif
		let g:insertJsLog += 1
		execute "normal! i" . text ."\<esc>$"
	else
		execute "normal! T("
		startinsert
	endif
endfunction
function! s:SurroundWithTryCatch()
	execute "normal! gv"
	let startl = line("v")
	let endl = line(".")
	execute "normal! \<esc>" . endl . "ggo} catch (e) {\<cr>\<cr>}\<Esc>"
	execute "normal! " . startl . "ggOtry {\<Esc>"
	while startl+1 <= endl+1
	" Indent selected lines by 1 tab to the right
		execute "normal! " . (startl+1) . "gg>>"
		let startl += 1
	endwhile
	"Insert tabs inside catch (e) {}
	execute "normal! " . (endl+3) . "ggi" . repeat("\<Tab>", s:HowManyTabs(startl))
	call feedkeys("A", "n") " Press A in normal mode
endfunction
function! LoadServerToBuffers(path, pattern)
	let command = "find \"" . a:path ."\" -name '" . a:pattern . "' | sed 's/ /\\\\\\ /'"
	echom command
	let output = system(command)
	let files = split(output, "\n")
	for file in files
		execute "badd " . file
	endfor
endfunction
function! s:ShowLog(command)
" Show output of a system command in a separate window
	let isJavaOutputWindow = 0
	" If window with filetype=suseilog was already open, 
	" then display output of a command in that window
	windo if &filetype ==# 'suseilog' | let bufstatus="" | let isJavaOutputWindow = 1 | execute "set statusline=Running\\ a\\ command" | let @c = system(a:command) | execute "normal ggdG\"cp" | execute "set statusline=".bufstatus | endif
	if isJavaOutputWindow == 0
	" Else display it in a new window
		new
		set filetype=suseilog
		let bufstatus=&statusline
		set statusline=Running\ a\ command...
		let @c = system(a:command)
		execute "normal ggdG\"cp"
		execute "set statusline=".bufstatus
		" Snap window to the bottom side of VIM and set its height to 14 lines
		execute "normal \<c-w>J\<c-w>14_"
		call feedkeys("<cr>", "n")
	endif
endfunction
function! ModeChange()
" Makes current file executable
    if getline(1) =~ "^#!"
        if getline(1) =~ "bin/"
            silent !chmod a+x <afile>
        endif
    endif
endfunction
function! ReportFileSaveTime()
" Saves current time and file to a certain file
	call system('echo `date +"%Y-%m-%d %H:%M:%S"` ' . @% . ' >> ' . g:fileSaveLog)
	" Trim log to a given number of lines
	call system('echo -e "1,-'.g:fileSaveLogMaxLen.'d\nwq" | ed '.g:fileSaveLog)
endfunction
function! ReportFileSaveMark()
	let text = input('Name mark: ')
	call system('echo $ `date +"%Y-%m-%d %H:%M:%S"` — Mark: ' . text . ' — ' . @% . ' >> ' . g:fileSaveLog)
	call input(@%)
	call system('echo  >> ' . g:fileSaveLog)
	" Trim log to a given number of lines
	call system('echo -e "1,-'.g:fileSaveLogMaxLen.'d\nwq" | ed '.g:fileSaveLog)
endfunction
function! s:TogglePhtmlFiletype()
	if &ft ==# "html"
		set ft=php
	else
		set ft=html
	endif
endfunction
function! AddCSS3Prefixes() 
	exec "norm! ^\"pY"
	exec "norm! \"ppI-webkit-\<Esc>"
	exec "norm! \"ppI-moz-\<Esc>"
	exec "norm! \"ppI-ms-\<Esc>"
	exec "norm! \"ppI-o-\<Esc>"
endfunction
" Setting options
syntax enable
set autoindent
set smarttab
set foldenable
set foldlevel=9999
let javascript_fold=1
set number
set ruler
set nowrap 
set mouse=a
colorscheme desert
set tabstop=4
set shiftwidth=4
let g:fileSaveLog = '~/.vim/filesave'
let g:fileSaveLogMaxLen = 1000
let g:pastebin_api_dev_key = 'f2349ac9b15712183409f11456812adc'
let g:user_zen_leader_key = '<c-z>'
let g:netrw_browse_split = 3
let g:netrw_liststyle = 3
call pathogen#infect()
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set foldcolumn=0
set comments=s1:/**,mb:*,ex:*/ 
let mapleader=","
let insertJsLog = 1
filetype plugin indent on
command! W w
command! Q q
command! -nargs=+ LoadToBuffers :call LoadServerToBuffers(<f-args>)<cr>
" command! Q q
"nnoremap Q <nop>
" Autocmds
au! FileType javascript 
	\ call JavaScriptFold() |
	\ nnoremap ,jc :call InsertJSDoc()<cr>
au! FileType php 
	\ set foldmethod=manual
au! FileType py 
    \ nnoremap <M-r> :!python %<cr>|
				\ set expandtab
au! FileType sh 
    \ nnoremap <M-r> :!bash %<cr>
au! FileType java 
	\ call JavaScriptFold() |
	\ compiler ant |
	\ set makeprg=ant\ -find\ 'build.xml' | 
	\ nnoremap ,bs :!ant buildStaticData<cr>
autocmd! BufRead,BufNewFile *.xsd
	\ set filetype=xml
au! BufNewFile,BufRead *.tpl set filetype=php
au! BufWritePost *.sh call ModeChange()
au! BufWritePost * call ReportFileSaveTime()
"autocmd! BufWinLeave *.* mkview
"autocmd! BufWinEnter *.* silent loadview
autocmd! FileType help
	\ set nonumber
" Mappings
nnoremap <leader>d yyp
nnoremap <leader>sl :SessionList<CR>
nnoremap <leader>ss :SessionSave<CR>
nnoremap <leader>sc :SessionClose<CR>
nnoremap <leader>rr :vsplit $MYVIMRC<CR>
nnoremap <leader>rs :so $MYVIMRC<CR>
nnoremap <space> zR
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <F1> <nop>
vnoremap <c-z> <nop>
inoremap <C-Space> <C-X><C-I>
inoremap <s-cr> <esc>:call InsertJSDocLineStart()<cr>
nnoremap <leader>c :call ToggleComments()<cr>
nnoremap <leader>l :call <SID>InsertJSBreakpoint('console.log()', 1)<cr>
nnoremap <leader>L :call <SID>InsertJSBreakpoint('console.log()', 0)<cr>
nnoremap <leader>e :call <SID>InsertJSBreakpoint('throw new Error()', 1)<cr>
"nnoremap <leader>E :call <SID>InsertJSBreakpoint('throw new Error()', 0)<cr>
vnoremap <leader>t <Esc>:call <SID>SurroundWithTryCatch()<cr>
nnoremap <F2> :w<cr>
inoremap <F2> <c-o>:w<cr>
nnoremap Q :q<cr>
inoremap <c-l> <c-^>
" Alt commands
nnoremap <M-t> :call ReportFileSaveMark()<cr>
"nnoremap <F3> :execute 'new ' . g:fileSaveLog<cr>
nnoremap <M-o> :b 
nnoremap <M-e> :e 
nnoremap <M-f> :Grep 
nnoremap <M-l> :!ls<cr>
nnoremap <M-p> :pwd<cr>
nnoremap <M-n> :set number!<cr>
nnoremap <M-w> :set wrap!<cr>
nnoremap <M-s> :%s/
nnoremap <M-v> :vs<cr>
nnoremap <M-3> :set expandtab!<cr>:echo "Expand tab is ".&expandtab<cr>
nnoremap <M-4> :set list!<cr>:echo "List is ".&expandtab<cr>
nnoremap =A gg=G<c-o><c-o>
nnoremap <M-c>s :call AddCSS3Prefixes()<cr>
" Git
nnoremap <leader>gs :!git status<cr>
nnoremap <leader>ga :!git add 
nnoremap <leader>gc :!git commit -m '
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>gl :!git log<cr>
" Filetype-dependent mappings
	" Place php breakpoint on the next line
autocmd! FileType php 
	\ nnoremap <leader>E :call <SID>InsertJSBreakpoint('throw new Exception(print_r(, true))', 0)<cr> |
	\ set formatoptions+=roa |
	\ nnoremap <leader>F :call <SID>TogglePhtmlFiletype()<cr>
autocmd! FileType html 
	\ nnoremap <leader>F :call <SID>TogglePhtmlFiletype()<cr>
autocmd! FileType cpp 
	\ nnoremap <M-r> :execute "normal \\rr"<cr>
" Execute .sh file with <M-r>
autocmd! FileType sh
	\ nnoremap <M-r> :!./%<cr>
" Quit without notification from suseilog files
autocmd! FileType suseilog 
	\ nnoremap Q :q!<cr>
" Removing shit from GUI so there is more space for everything
set guioptions=ca
set fdc=0
" Motions
" Inside parenthesis
onoremap p i(
set fileencodings+=cp1251
set noswapfile
